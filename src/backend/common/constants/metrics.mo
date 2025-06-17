module {
    // Time constants
    public let ONE_SECOND : Nat = 1;
    public let ONE_MINUTE : Nat = 60;
    public let ONE_HOUR : Nat = 3600;
    public let ONE_DAY : Nat = 86400;
    public let ONE_WEEK : Nat = 604800;
    public let ONE_MONTH : Nat = 2592000;
    public let ONE_YEAR : Nat = 31536000;

    // Storage metrics constants
    public let MIN_STORAGE_SIZE : Nat = 0;
    public let MAX_STORAGE_SIZE : Nat = 1099511627776; // 1TB in bytes
    public let MIN_FILE_SIZE : Nat = 0;
    public let MAX_FILE_SIZE : Nat = 1073741824; // 1GB in bytes
    public let MIN_CHUNK_SIZE : Nat = 1;
    public let MAX_CHUNK_SIZE : Nat = 1048576; // 1MB in bytes
    public let DEFAULT_CHUNK_SIZE : Nat = 65536; // 64KB in bytes
    public let MIN_FILES_PER_USER : Nat = 0;
    public let MAX_FILES_PER_USER : Nat = 10000;
    public let MIN_CHUNKS_PER_FILE : Nat = 1;
    public let MAX_CHUNKS_PER_FILE : Nat = 10000;
    public let MIN_STORAGE_PER_USER : Nat = 0;
    public let MAX_STORAGE_PER_USER : Nat = 1073741824; // 1GB in bytes

    // Performance metrics constants
    public let MIN_LATENCY : Nat = 0;
    public let MAX_LATENCY : Nat = 10000; // 10 seconds in milliseconds
    public let MIN_THROUGHPUT : Nat = 0;
    public let MAX_THROUGHPUT : Nat = 1073741824; // 1GB per second in bytes
    public let MIN_CONCURRENT_REQUESTS : Nat = 0;
    public let MAX_CONCURRENT_REQUESTS : Nat = 1000;
    public let MIN_REQUEST_RATE : Nat = 0;
    public let MAX_REQUEST_RATE : Nat = 1000; // requests per second
    public let MIN_RESPONSE_TIME : Nat = 0;
    public let MAX_RESPONSE_TIME : Nat = 10000; // 10 seconds in milliseconds
    public let MIN_PROCESSING_TIME : Nat = 0;
    public let MAX_PROCESSING_TIME : Nat = 10000; // 10 seconds in milliseconds

    // Usage metrics constants
    public let MIN_REQUESTS : Nat = 0;
    public let MAX_REQUESTS : Nat = 1000000;
    public let MIN_BANDWIDTH : Nat = 0;
    public let MAX_BANDWIDTH : Nat = 1099511627776; // 1TB in bytes
    public let MIN_ACTIVE_USERS : Nat = 0;
    public let MAX_ACTIVE_USERS : Nat = 1000000;
    public let MIN_TOTAL_USERS : Nat = 0;
    public let MAX_TOTAL_USERS : Nat = 1000000;
    public let MIN_DAILY_ACTIVE_USERS : Nat = 0;
    public let MAX_DAILY_ACTIVE_USERS : Nat = 1000000;
    public let MIN_MONTHLY_ACTIVE_USERS : Nat = 0;
    public let MAX_MONTHLY_ACTIVE_USERS : Nat = 1000000;

    // Cache metrics constants
    public let MIN_CACHE_SIZE : Nat = 0;
    public let MAX_CACHE_SIZE : Nat = 1073741824; // 1GB in bytes
    public let MIN_CACHE_ENTRIES : Nat = 0;
    public let MAX_CACHE_ENTRIES : Nat = 100000;
    public let MIN_CACHE_TTL : Nat = 0;
    public let MAX_CACHE_TTL : Nat = 31536000; // 1 year in seconds
    public let DEFAULT_CACHE_TTL : Nat = 3600; // 1 hour in seconds
    public let MIN_CACHE_HITS : Nat = 0;
    public let MAX_CACHE_HITS : Nat = 1000000;
    public let MIN_CACHE_MISSES : Nat = 0;
    public let MAX_CACHE_MISSES : Nat = 1000000;
    public let MIN_CACHE_EVICTIONS : Nat = 0;
    public let MAX_CACHE_EVICTIONS : Nat = 1000000;

    // Queue metrics constants
    public let MIN_QUEUE_SIZE : Nat = 0;
    public let MAX_QUEUE_SIZE : Nat = 100000;
    public let MIN_QUEUE_ITEMS : Nat = 0;
    public let MAX_QUEUE_ITEMS : Nat = 100000;
    public let MIN_QUEUE_PRIORITY : Nat = 0;
    public let MAX_QUEUE_PRIORITY : Nat = 10;
    public let DEFAULT_QUEUE_PRIORITY : Nat = 5;
    public let MIN_QUEUE_RETRIES : Nat = 0;
    public let MAX_QUEUE_RETRIES : Nat = 10;
    public let DEFAULT_QUEUE_RETRIES : Nat = 3;
    public let MIN_QUEUE_PROCESSING_TIME : Nat = 0;
    public let MAX_QUEUE_PROCESSING_TIME : Nat = 10000; // 10 seconds in milliseconds
    public let MIN_QUEUE_WAIT_TIME : Nat = 0;
    public let MAX_QUEUE_WAIT_TIME : Nat = 10000; // 10 seconds in milliseconds

    // Error messages
    public let ERROR_INVALID_STORAGE_SIZE : Text = "Invalid storage size";
    public let ERROR_INVALID_FILE_SIZE : Text = "Invalid file size";
    public let ERROR_INVALID_CHUNK_SIZE : Text = "Invalid chunk size";
    public let ERROR_INVALID_LATENCY : Text = "Invalid latency";
    public let ERROR_INVALID_THROUGHPUT : Text = "Invalid throughput";
    public let ERROR_INVALID_CONCURRENT_REQUESTS : Text = "Invalid concurrent requests";
    public let ERROR_INVALID_REQUEST_RATE : Text = "Invalid request rate";
    public let ERROR_INVALID_RESPONSE_TIME : Text = "Invalid response time";
    public let ERROR_INVALID_PROCESSING_TIME : Text = "Invalid processing time";
    public let ERROR_INVALID_REQUESTS : Text = "Invalid requests";
    public let ERROR_INVALID_BANDWIDTH : Text = "Invalid bandwidth";
    public let ERROR_INVALID_ACTIVE_USERS : Text = "Invalid active users";
    public let ERROR_INVALID_TOTAL_USERS : Text = "Invalid total users";
    public let ERROR_INVALID_CACHE_SIZE : Text = "Invalid cache size";
    public let ERROR_INVALID_CACHE_ENTRIES : Text = "Invalid cache entries";
    public let ERROR_INVALID_CACHE_TTL : Text = "Invalid cache TTL";
    public let ERROR_INVALID_CACHE_HITS : Text = "Invalid cache hits";
    public let ERROR_INVALID_CACHE_MISSES : Text = "Invalid cache misses";
    public let ERROR_INVALID_CACHE_EVICTIONS : Text = "Invalid cache evictions";
    public let ERROR_INVALID_QUEUE_SIZE : Text = "Invalid queue size";
    public let ERROR_INVALID_QUEUE_ITEMS : Text = "Invalid queue items";
    public let ERROR_INVALID_QUEUE_PRIORITY : Text = "Invalid queue priority";
    public let ERROR_INVALID_QUEUE_RETRIES : Text = "Invalid queue retries";
    public let ERROR_INVALID_QUEUE_PROCESSING_TIME : Text = "Invalid queue processing time";
    public let ERROR_INVALID_QUEUE_WAIT_TIME : Text = "Invalid queue wait time";

    // Status messages
    public let STATUS_METRICS_UPDATED : Text = "Metrics updated successfully";
    public let STATUS_METRICS_RESET : Text = "Metrics reset successfully";
    public let STATUS_METRICS_CLEARED : Text = "Metrics cleared successfully";
    public let STATUS_METRICS_EXPORTED : Text = "Metrics exported successfully";
    public let STATUS_METRICS_IMPORTED : Text = "Metrics imported successfully";
    public let STATUS_METRICS_VALIDATED : Text = "Metrics validated successfully";
    public let STATUS_METRICS_INVALID : Text = "Metrics validation failed";
    public let STATUS_METRICS_ERROR : Text = "Metrics error occurred";
    public let STATUS_METRICS_WARNING : Text = "Metrics warning occurred";
    public let STATUS_METRICS_INFO : Text = "Metrics info message";
    public let STATUS_METRICS_DEBUG : Text = "Metrics debug message";
    public let STATUS_METRICS_TRACE : Text = "Metrics trace message";

    // Feature flags
    public let ENABLE_STORAGE_METRICS : Bool = true;
    public let ENABLE_PERFORMANCE_METRICS : Bool = true;
    public let ENABLE_USAGE_METRICS : Bool = true;
    public let ENABLE_CACHE_METRICS : Bool = true;
    public let ENABLE_QUEUE_METRICS : Bool = true;
    public let ENABLE_METRICS_EXPORT : Bool = true;
    public let ENABLE_METRICS_IMPORT : Bool = true;
    public let ENABLE_METRICS_VALIDATION : Bool = true;
    public let ENABLE_METRICS_LOGGING : Bool = true;
    public let ENABLE_METRICS_MONITORING : Bool = true;
}; 