#include <Processors/QueryPlan/ReadFromMergeTree.h>
#include <Processors/QueryPipeline.h>
#include <Processors/ConcatProcessor.h>
#include <Processors/Transforms/ReverseTransform.h>
#include <Storages/MergeTree/MergeTreeSelectProcessor.h>
#include <Storages/MergeTree/MergeTreeReverseSelectProcessor.h>
#include <Storages/MergeTree/MergeTreeThreadSelectBlockInputProcessor.h>
#include <common/logger_useful.h>

namespace DB
{

ReadFromMergeTree::ReadFromMergeTree(
    const MergeTreeData & storage_,
    StorageMetadataPtr metadata_snapshot_,
    String query_id_,
    Names required_columns_,
    RangesInDataParts parts_,
    IndexStatPtr index_stats_,
    PrewhereInfoPtr prewhere_info_,
    Names virt_column_names_,
    Settings settings_,
    size_t num_streams_,
    ReadType read_type_)
    : ISourceStep(DataStream{.header = MergeTreeBaseSelectProcessor::transformHeader(
        metadata_snapshot_->getSampleBlockForColumns(required_columns_, storage_.getVirtuals(), storage_.getStorageID()),
        prewhere_info_,
        virt_column_names_)})
    , storage(storage_)
    , metadata_snapshot(std::move(metadata_snapshot_))
    , query_id(std::move(query_id_))
    , required_columns(std::move(required_columns_))
    , parts(std::move(parts_))
    , index_stats(std::move(index_stats_))
    , prewhere_info(std::move(prewhere_info_))
    , virt_column_names(std::move(virt_column_names_))
    , settings(std::move(settings_))
    , num_streams(num_streams_)
    , read_type(read_type_)
{
}

Pipe ReadFromMergeTree::readFromPool()
{
    Pipes pipes;
    size_t sum_marks = 0;
    size_t total_rows = 0;

    for (const auto & part : parts)
    {
        sum_marks += part.getMarksCount();
        total_rows += part.getRowsCount();
    }

    auto pool = std::make_shared<MergeTreeReadPool>(
        num_streams,
        sum_marks,
        settings.min_marks_for_concurrent_read,
        std::move(parts),
        storage,
        metadata_snapshot,
        prewhere_info,
        true,
        required_columns,
        settings.backoff_settings,
        settings.preferred_block_size_bytes,
        false);

    auto * logger = &Poco::Logger::get(storage.getLogName() + " (SelectExecutor)");
    LOG_TRACE(logger, "Reading approx. {} rows with {} streams", total_rows, num_streams);

    for (size_t i = 0; i < num_streams; ++i)
    {
        auto source = std::make_shared<MergeTreeThreadSelectBlockInputProcessor>(
            i, pool, settings.min_marks_for_concurrent_read, settings.max_block_size,
            settings.preferred_block_size_bytes, settings.preferred_max_column_in_block_size_bytes,
            storage, metadata_snapshot, settings.use_uncompressed_cache,
            prewhere_info, settings.reader_settings, virt_column_names);

        if (i == 0)
        {
            /// Set the approximate number of rows for the first source only
            source->addTotalRowsApprox(total_rows);
        }

        pipes.emplace_back(std::move(source));
    }

    return Pipe::unitePipes(std::move(pipes));
}

template<typename TSource>
ProcessorPtr ReadFromMergeTree::createSource(const RangesInDataPart & part)
{
    return std::make_shared<TSource>(
            storage, metadata_snapshot, part.data_part, settings.max_block_size, settings.preferred_block_size_bytes,
            settings.preferred_max_column_in_block_size_bytes, required_columns, part.ranges, settings.use_uncompressed_cache,
            prewhere_info, true, settings.reader_settings, virt_column_names, part.part_index_in_query);
}

Pipe ReadFromMergeTree::readInOrder()
{
    Pipes pipes;
    for (const auto & part : parts)
    {
        auto source = read_type == ReadType::InReverseOrder
                    ? createSource<MergeTreeReverseSelectProcessor>(part)
                    : createSource<MergeTreeSelectProcessor>(part);

        pipes.emplace_back(std::move(source));
    }

    auto pipe = Pipe::unitePipes(std::move(pipes));

    if (read_type == ReadType::InReverseOrder)
    {
        pipe.addSimpleTransform([&](const Block & header)
        {
            return std::make_shared<ReverseTransform>(header);
        });
    }

    return pipe;
}

Pipe ReadFromMergeTree::read()
{
    if (read_type == ReadType::Default && num_streams > 1)
        return readFromPool();

    auto pipe = readInOrder();

    /// Use ConcatProcessor to concat sources together.
    /// It is needed to read in parts order (and so in PK order) if single thread is used.
    if (read_type == ReadType::Default && pipe.numOutputPorts() > 1)
        pipe.addTransform(std::make_shared<ConcatProcessor>(pipe.getHeader(), pipe.numOutputPorts()));

    return pipe;
}

void ReadFromMergeTree::initializePipeline(QueryPipeline & pipeline, const BuildQueryPipelineSettings &)
{
    Pipe pipe = read();

    for (const auto & processor : pipe.getProcessors())
        processors.emplace_back(processor);

    // Attach QueryIdHolder if needed
    if (!query_id.empty())
        pipe.addQueryIdHolder(std::make_shared<QueryIdHolder>(query_id, storage));

    pipeline.init(std::move(pipe));
}

static const char * indexTypeToString(ReadFromMergeTree::IndexType type)
{
    switch (type)
    {
        case ReadFromMergeTree::IndexType::None:
            return "None";
        case ReadFromMergeTree::IndexType::MinMax:
            return "MinMax";
        case ReadFromMergeTree::IndexType::Partition:
            return "Partition";
        case ReadFromMergeTree::IndexType::PrimaryKey:
            return "PrimaryKey";
        case ReadFromMergeTree::IndexType::Skip:
            return "Skip";
    }

    __builtin_unreachable();
}

static const char * readTypeToString(ReadFromMergeTree::ReadType type)
{
    switch (type)
    {
        case ReadFromMergeTree::ReadType::Default:
            return "Default";
        case ReadFromMergeTree::ReadType::InOrder:
            return "InOrder";
        case ReadFromMergeTree::ReadType::InReverseOrder:
            return "InReverseOrder";
    }

    __builtin_unreachable();
}

void ReadFromMergeTree::describeActions(FormatSettings & format_settings) const
{
    std::string prefix(format_settings.offset, format_settings.indent_char);
    format_settings.out << prefix << "ReadType: " << readTypeToString(read_type) << '\n';

    if (index_stats && !index_stats->empty())
    {

        std::string indent(format_settings.indent, format_settings.indent_char);
        format_settings.out << prefix << "Indexes:\n";

        for (const auto & stat : *index_stats)
        {
            format_settings.out << prefix << indent << indexTypeToString(stat.type) << '\n';

            if (!stat.name.empty())
                format_settings.out << prefix << indent << indent << "Name: " << stat.name << '\n';

            if (!stat.used_keys.empty())
            {
                format_settings.out << prefix << indent << indent << "Keys: " << stat.name << '\n';
                for (const auto & used_key : stat.used_keys)
                    format_settings.out << prefix << indent << indent << indent << used_key << '\n';
            }

            if (!stat.description.empty())
                format_settings.out << prefix << indent << indent << "Description: " << stat.description << '\n';

            format_settings.out << prefix << indent << indent << "Parts: " << stat.num_parts_after << '\n';
            format_settings.out << prefix << indent << indent << "Granules: " << stat.num_granules_after << '\n';
        }
    }
}

}
