-- the setting exists and server does not crash
--SET os_thread_priority = 10;
SET max_threads = 10;
SELECT count() FROM numbers(1000);
