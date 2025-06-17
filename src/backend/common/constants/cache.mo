module {
    // Time constants
    public let ONE_SECOND : Nat = 1;
    public let ONE_MINUTE : Nat = 60;
    public let ONE_HOUR : Nat = 3600;
    public let ONE_DAY : Nat = 86400;
    public let ONE_WEEK : Nat = 604800;
    public let ONE_MONTH : Nat = 2592000;
    public let ONE_YEAR : Nat = 31536000;

    // Cache size limits
    public let MIN_CACHE_SIZE : Nat = 0;
    public let MAX_CACHE_SIZE : Nat = 1073741824; // 1GB in bytes
    public let DEFAULT_CACHE_SIZE : Nat = 10485760; // 10MB in bytes
    public let MIN_CACHE_ENTRIES : Nat = 0;
    public let MAX_CACHE_ENTRIES : Nat = 100000;
    public let DEFAULT_CACHE_ENTRIES : Nat = 1000;
    public let MIN_CACHE_ENTRY_SIZE : Nat = 0;
    public let MAX_CACHE_ENTRY_SIZE : Nat = 1048576; // 1MB in bytes
    public let DEFAULT_CACHE_ENTRY_SIZE : Nat = 1024; // 1KB in bytes

    // Cache time limits
    public let MIN_CACHE_TTL : Nat = 0;
    public let MAX_CACHE_TTL : Nat = 31536000; // 1 year in seconds
    public let DEFAULT_CACHE_TTL : Nat = 3600; // 1 hour in seconds
    public let MIN_CACHE_REFRESH : Nat = 0;
    public let MAX_CACHE_REFRESH : Nat = 31536000; // 1 year in seconds
    public let DEFAULT_CACHE_REFRESH : Nat = 300; // 5 minutes in seconds
    public let MIN_CACHE_EXPIRY : Nat = 0;
    public let MAX_CACHE_EXPIRY : Nat = 31536000; // 1 year in seconds
    public let DEFAULT_CACHE_EXPIRY : Nat = 86400; // 1 day in seconds

    // Cache policy limits
    public let MIN_CACHE_POLICY_PRIORITY : Nat = 0;
    public let MAX_CACHE_POLICY_PRIORITY : Nat = 10;
    public let DEFAULT_CACHE_POLICY_PRIORITY : Nat = 5;
    public let MIN_CACHE_POLICY_WEIGHT : Nat = 0;
    public let MAX_CACHE_POLICY_WEIGHT : Nat = 100;
    public let DEFAULT_CACHE_POLICY_WEIGHT : Nat = 50;
    public let MIN_CACHE_POLICY_THRESHOLD : Nat = 0;
    public let MAX_CACHE_POLICY_THRESHOLD : Nat = 100;
    public let DEFAULT_CACHE_POLICY_THRESHOLD : Nat = 80;

    // Cache statistics limits
    public let MIN_CACHE_HITS : Nat = 0;
    public let MAX_CACHE_HITS : Nat = 1000000;
    public let DEFAULT_CACHE_HITS : Nat = 0;
    public let MIN_CACHE_MISSES : Nat = 0;
    public let MAX_CACHE_MISSES : Nat = 1000000;
    public let DEFAULT_CACHE_MISSES : Nat = 0;
    public let MIN_CACHE_EVICTIONS : Nat = 0;
    public let MAX_CACHE_EVICTIONS : Nat = 1000000;
    public let DEFAULT_CACHE_EVICTIONS : Nat = 0;
    public let MIN_CACHE_EXPIRATIONS : Nat = 0;
    public let MAX_CACHE_EXPIRATIONS : Nat = 1000000;
    public let DEFAULT_CACHE_EXPIRATIONS : Nat = 0;

    // Cache policy types
    public let CACHE_POLICY_LRU : Text = "lru";
    public let CACHE_POLICY_LFU : Text = "lfu";
    public let CACHE_POLICY_FIFO : Text = "fifo";
    public let CACHE_POLICY_LIFO : Text = "lifo";
    public let CACHE_POLICY_RANDOM : Text = "random";
    public let CACHE_POLICY_CLOCK : Text = "clock";
    public let CACHE_POLICY_ARC : Text = "arc";
    public let CACHE_POLICY_2Q : Text = "2q";
    public let CACHE_POLICY_MQ : Text = "mq";
    public let CACHE_POLICY_GDSF : Text = "gdsf";
    public let CACHE_POLICY_GDFS : Text = "gdfs";
    public let CACHE_POLICY_LIRS : Text = "lirs";
    public let CACHE_POLICY_SLRU : Text = "slru";
    public let CACHE_POLICY_TINYLFU : Text = "tinylfu";
    public let CACHE_POLICY_W_TINYLFU : Text = "w-tinylfu";
    public let CACHE_POLICY_SIEVE : Text = "sieve";
    public let CACHE_POLICY_CLOCK_PRO : Text = "clock-pro";
    public let CACHE_POLICY_ARC_PRO : Text = "arc-pro";
    public let CACHE_POLICY_2Q_PRO : Text = "2q-pro";
    public let CACHE_POLICY_MQ_PRO : Text = "mq-pro";

    // Error messages
    public let ERROR_INVALID_CACHE_SIZE : Text = "Invalid cache size";
    public let ERROR_INVALID_CACHE_ENTRIES : Text = "Invalid number of cache entries";
    public let ERROR_INVALID_CACHE_ENTRY_SIZE : Text = "Invalid cache entry size";
    public let ERROR_INVALID_CACHE_TTL : Text = "Invalid cache TTL";
    public let ERROR_INVALID_CACHE_REFRESH : Text = "Invalid cache refresh";
    public let ERROR_INVALID_CACHE_EXPIRY : Text = "Invalid cache expiry";
    public let ERROR_INVALID_CACHE_POLICY_PRIORITY : Text = "Invalid cache policy priority";
    public let ERROR_INVALID_CACHE_POLICY_WEIGHT : Text = "Invalid cache policy weight";
    public let ERROR_INVALID_CACHE_POLICY_THRESHOLD : Text = "Invalid cache policy threshold";
    public let ERROR_INVALID_CACHE_HITS : Text = "Invalid cache hits";
    public let ERROR_INVALID_CACHE_MISSES : Text = "Invalid cache misses";
    public let ERROR_INVALID_CACHE_EVICTIONS : Text = "Invalid cache evictions";
    public let ERROR_INVALID_CACHE_EXPIRATIONS : Text = "Invalid cache expirations";
    public let ERROR_INVALID_CACHE_POLICY : Text = "Invalid cache policy";

    // Status messages
    public let STATUS_CACHE_CREATED : Text = "Cache created successfully";
    public let STATUS_CACHE_DELETED : Text = "Cache deleted successfully";
    public let STATUS_CACHE_UPDATED : Text = "Cache updated successfully";
    public let STATUS_CACHE_CLEARED : Text = "Cache cleared successfully";
    public let STATUS_CACHE_ENTRY_CREATED : Text = "Cache entry created successfully";
    public let STATUS_CACHE_ENTRY_DELETED : Text = "Cache entry deleted successfully";
    public let STATUS_CACHE_ENTRY_UPDATED : Text = "Cache entry updated successfully";
    public let STATUS_CACHE_ENTRY_EXPIRED : Text = "Cache entry expired";
    public let STATUS_CACHE_ENTRY_EVICTED : Text = "Cache entry evicted";
    public let STATUS_CACHE_POLICY_CREATED : Text = "Cache policy created successfully";
    public let STATUS_CACHE_POLICY_DELETED : Text = "Cache policy deleted successfully";
    public let STATUS_CACHE_POLICY_UPDATED : Text = "Cache policy updated successfully";
    public let STATUS_CACHE_STATS_UPDATED : Text = "Cache statistics updated successfully";
    public let STATUS_CACHE_STATS_RESET : Text = "Cache statistics reset successfully";

    // Feature flags
    public let ENABLE_CACHE_CREATION : Bool = true;
    public let ENABLE_CACHE_DELETION : Bool = true;
    public let ENABLE_CACHE_UPDATE : Bool = true;
    public let ENABLE_CACHE_CLEAR : Bool = true;
    public let ENABLE_CACHE_ENTRY_CREATION : Bool = true;
    public let ENABLE_CACHE_ENTRY_DELETION : Bool = true;
    public let ENABLE_CACHE_ENTRY_UPDATE : Bool = true;
    public let ENABLE_CACHE_ENTRY_EXPIRATION : Bool = true;
    public let ENABLE_CACHE_ENTRY_EVICTION : Bool = true;
    public let ENABLE_CACHE_POLICY_CREATION : Bool = true;
    public let ENABLE_CACHE_POLICY_DELETION : Bool = true;
    public let ENABLE_CACHE_POLICY_UPDATE : Bool = true;
    public let ENABLE_CACHE_STATS_UPDATE : Bool = true;
    public let ENABLE_CACHE_STATS_RESET : Bool = true;
    public let ENABLE_CACHE_COMPRESSION : Bool = true;
    public let ENABLE_CACHE_ENCRYPTION : Bool = true;
    public let ENABLE_CACHE_PERSISTENCE : Bool = true;
    public let ENABLE_CACHE_DISTRIBUTION : Bool = true;
    public let ENABLE_CACHE_REPLICATION : Bool = true;
}; 