#include <Common/config.h>

#if USE_AWS_S3

#    include <IO/ReadBufferFromIStream.h>
#    include <IO/ReadBufferFromS3.h>
#    include <Common/Stopwatch.h>

#    include <aws/s3/S3Client.h>
#    include <aws/s3/model/GetObjectRequest.h>
#    include <common/logger_useful.h>

#    include <utility>

namespace ProfileEvents
{
    extern const Event S3ReadMicroseconds;
    extern const Event S3ReadBytes;
    extern const Event S3ReadRequestsErrors;
}

namespace DB
{
namespace ErrorCodes
{
    extern const int S3_ERROR;
    extern const int CANNOT_SEEK_THROUGH_FILE;
    extern const int SEEK_POSITION_OUT_OF_BOUND;
}


ReadBufferFromS3::ReadBufferFromS3(
    std::shared_ptr<Aws::S3::S3Client> client_ptr_, const String & bucket_, const String & key_, Int64 s3_max_single_read_retries_, size_t buffer_size_)
    : SeekableReadBuffer(nullptr, 0)
    , client_ptr(std::move(client_ptr_))
    , bucket(bucket_)
    , key(key_)
    , s3_max_single_read_retries(s3_max_single_read_retries_)
    , buffer_size(buffer_size_)
{
}


bool ReadBufferFromS3::nextImpl()
{
    if (!impl)
        impl = initialize();

    Stopwatch watch;
    bool next_result = false;

    for (Int64 attempt = s3_max_single_read_retries; s3_max_single_read_retries < 0 || attempt >= 0; --attempt)
    {
        if (!impl)
            impl = initialize();

        try
        {
            next_result = impl->next();
            break;
        }
        catch (const Exception & e)
        {
            ProfileEvents::increment(ProfileEvents::S3ReadRequestsErrors, 1);

            impl.reset();
            offset = getPosition();

            if (!attempt)
                throw;
        }
    }

    watch.stop();
    ProfileEvents::increment(ProfileEvents::S3ReadMicroseconds, watch.elapsedMicroseconds());
    if (!next_result)
        return false;
    internal_buffer = impl->buffer();

    ProfileEvents::increment(ProfileEvents::S3ReadBytes, internal_buffer.size());

    working_buffer = internal_buffer;
    return true;
}

off_t ReadBufferFromS3::seek(off_t offset_, int whence)
{
    if (impl)
        throw Exception("Seek is allowed only before first read attempt from the buffer.", ErrorCodes::CANNOT_SEEK_THROUGH_FILE);

    if (whence != SEEK_SET)
        throw Exception("Only SEEK_SET mode is allowed.", ErrorCodes::CANNOT_SEEK_THROUGH_FILE);

    if (offset_ < 0)
        throw Exception("Seek position is out of bounds. Offset: " + std::to_string(offset_), ErrorCodes::SEEK_POSITION_OUT_OF_BOUND);

    offset = offset_;

    return offset;
}


off_t ReadBufferFromS3::getPosition()
{
    return offset + count();
}

std::unique_ptr<ReadBuffer> ReadBufferFromS3::initialize()
{
    LOG_TRACE(log, "Read S3 object. Bucket: {}, Key: {}, Offset: {}", bucket, key, std::to_string(offset));

    Aws::S3::Model::GetObjectRequest req;
    req.SetBucket(bucket);
    req.SetKey(key);
    if (offset != 0)
        req.SetRange("bytes=" + std::to_string(offset) + "-");

    Aws::S3::Model::GetObjectOutcome outcome = client_ptr->GetObject(req);

    if (outcome.IsSuccess())
    {
        read_result = outcome.GetResultWithOwnership();
        return std::make_unique<ReadBufferFromIStream>(read_result.GetBody(), buffer_size);
    }
    else
        throw Exception(outcome.GetError().GetMessage(), ErrorCodes::S3_ERROR);
}

}

#endif
