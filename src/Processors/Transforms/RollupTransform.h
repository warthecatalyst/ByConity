#pragma once
#include <Processors/IAccumulatingTransform.h>
#include <Processors/Transforms/AggregatingTransform.h>

namespace DB
{

/// Takes blocks after grouping, with non-finalized aggregate functions.
/// Calculates subtotals and grand totals values for a set of columns.
class RollupTransform : public IAccumulatingTransform
{
public:
    RollupTransform(Block header, AggregatingTransformParamsPtr params, bool add_grouping_set_column = true);
    String getName() const override { return "RollupTransform"; }

protected:
    void consume(Chunk chunk) override;
    Chunk generate() override;

private:
    AggregatingTransformParamsPtr params;
    ColumnNumbers keys;
    Chunks consumed_chunks;
    Chunk rollup_chunk;
    size_t last_removed_key = 0;
    size_t set_counter = 0;
    // TODO @jingpeng @wangtao: this is a temporary fix to prevent RollupTransform generate `__grouping_set`,
    // can be removed if optimizer no longer use this transform
    bool add_grouping_set_column;

    Chunk merge(Chunks && chunks, bool final);
};

}
