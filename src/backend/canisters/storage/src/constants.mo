module Constants {
    // Time constants
    public let ONE_MINUTE : Nat = 60;
    public let ONE_HOUR : Nat = 3600;
    public let ONE_DAY : Nat = 86400;
    public let ONE_WEEK : Nat = 604800;
    public let ONE_MONTH : Nat = 2592000;
    public let ONE_YEAR : Nat = 31536000;

    // File size limits
    public let MAX_FILE_SIZE : Nat = 100_000_000; // 100MB
    public let MAX_CHUNK_SIZE : Nat = 1_000_000; // 1MB
    public let MIN_FILE_SIZE : Nat = 1;
    public let MIN_CHUNK_SIZE : Nat = 1;

    // Cache settings
    public let DEFAULT_CACHE_TTL : Nat = 3600; // 1 hour
    public let MAX_CACHE_TTL : Nat = 86400; // 24 hours
    public let MIN_CACHE_TTL : Nat = 60; // 1 minute
    public let MAX_CACHE_ENTRIES : Nat = 1000;
    public let CACHE_CLEANUP_INTERVAL : Nat = 300; // 5 minutes

    // Queue settings
    public let MAX_QUEUE_PRIORITY : Nat = 10;
    public let MIN_QUEUE_PRIORITY : Nat = 1;
    public let MAX_QUEUE_RETRIES : Nat = 3;
    public let QUEUE_PROCESSING_INTERVAL : Nat = 60; // 1 minute
    public let MAX_QUEUE_ITEMS : Nat = 1000;

    // Storage limits
    public let MAX_STORAGE_SIZE : Nat = 1_000_000_000; // 1GB
    public let MAX_FILES_PER_USER : Nat = 1000;
    public let MAX_CHUNKS_PER_FILE : Nat = 1000;
    public let MAX_METADATA_SIZE : Nat = 1000;
    public let MAX_PERMISSIONS_PER_FILE : Nat = 100;

    // Validation patterns
    public let EMAIL_PATTERN : Text = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
    public let PHONE_PATTERN : Text = "^\\+?[1-9]\\d{1,14}$";
    public let URL_PATTERN : Text = "^(https?|ftp)://[^\\s/$.?#].[^\\s]*$";
    public let USERNAME_PATTERN : Text = "^[a-zA-Z0-9_-]{3,16}$";
    public let PASSWORD_PATTERN : Text = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$";
    public let MIME_TYPE_PATTERN : Text = "^[a-zA-Z0-9.-]+/[a-zA-Z0-9.-]+$";
    public let FILE_NAME_PATTERN : Text = "^[a-zA-Z0-9._-]+$";
    public let FILE_PATH_PATTERN : Text = "^[a-zA-Z0-9/._-]+$";
    public let FILE_URL_PATTERN : Text = "^(https?|ftp)://[^\\s/$.?#].[^\\s]*$";

    // Error messages
    public let ERROR_INVALID_FILE : Text = "Invalid file";
    public let ERROR_INVALID_CHUNK : Text = "Invalid chunk";
    public let ERROR_FILE_NOT_FOUND : Text = "File not found";
    public let ERROR_CHUNK_NOT_FOUND : Text = "Chunk not found";
    public let ERROR_INVALID_METADATA : Text = "Invalid metadata";
    public let ERROR_INVALID_PERMISSION : Text = "Invalid permission";
    public let ERROR_INVALID_CACHE_ENTRY : Text = "Invalid cache entry";
    public let ERROR_INVALID_QUEUE_ITEM : Text = "Invalid queue item";
    public let ERROR_INVALID_STORAGE_ACTION : Text = "Invalid storage action";
    public let ERROR_INVALID_STORAGE_METRICS : Text = "Invalid storage metrics";
    public let ERROR_INVALID_STORAGE_HISTORY : Text = "Invalid storage history";
    public let ERROR_INVALID_SECURITY_EVENT : Text = "Invalid security event";
    public let ERROR_INVALID_SECURITY_LOG : Text = "Invalid security log";
    public let ERROR_INVALID_INTEGRATION_HISTORY : Text = "Invalid integration history";
    public let ERROR_INVALID_ANALYTICS_ACTION : Text = "Invalid analytics action";
    public let ERROR_INVALID_ANALYTICS_HISTORY : Text = "Invalid analytics history";
    public let ERROR_INVALID_FILTER : Text = "Invalid filter";
    public let ERROR_INVALID_FILTER_TEMPLATE : Text = "Invalid filter template";
    public let ERROR_INVALID_FILTER_HISTORY : Text = "Invalid filter history";
    public let ERROR_INVALID_SORT_BY : Text = "Invalid sort by";
    public let ERROR_INVALID_SORT_DIRECTION : Text = "Invalid sort direction";
    public let ERROR_FILE_TOO_LARGE : Text = "File too large";
    public let ERROR_CHUNK_TOO_LARGE : Text = "Chunk too large";
    public let ERROR_STORAGE_FULL : Text = "Storage full";
    public let ERROR_TOO_MANY_FILES : Text = "Too many files";
    public let ERROR_TOO_MANY_CHUNKS : Text = "Too many chunks";
    public let ERROR_TOO_MANY_METADATA : Text = "Too many metadata";
    public let ERROR_TOO_MANY_PERMISSIONS : Text = "Too many permissions";
    public let ERROR_CACHE_FULL : Text = "Cache full";
    public let ERROR_QUEUE_FULL : Text = "Queue full";
    public let ERROR_INVALID_CANISTER_ID : Text = "Invalid canister ID";
    public let ERROR_CANISTER_NOT_SET : Text = "Canister not set";
    public let ERROR_FILTER_APPLICATION_FAILED : Text = "Filter application failed";
    public let ERROR_PRINCIPAL_BLACKLISTED : Text = "Principal is blacklisted";
    public let ERROR_RATE_LIMIT_EXCEEDED : Text = "Rate limit exceeded";
    public let ERROR_ACCESS_DENIED : Text = "Access denied";

    // Status messages
    public let STATUS_SUCCESS : Text = "Success";
    public let STATUS_FAILURE : Text = "Failure";
    public let STATUS_PENDING : Text = "Pending";
    public let STATUS_PROCESSING : Text = "Processing";
    public let STATUS_COMPLETED : Text = "Completed";
    public let STATUS_FAILED : Text = "Failed";
    public let STATUS_CANCELLED : Text = "Cancelled";
    public let STATUS_EXPIRED : Text = "Expired";
    public let STATUS_DELETED : Text = "Deleted";
    public let STATUS_UPDATED : Text = "Updated";
    public let STATUS_CREATED : Text = "Created";
    public let STATUS_SHARED : Text = "Shared";
    public let STATUS_UNSHARED : Text = "Unshared";
    public let STATUS_BLACKLISTED : Text = "Blacklisted";
    public let STATUS_WHITELISTED : Text = "Whitelisted";
    public let STATUS_RATE_LIMITED : Text = "Rate limited";
    public let STATUS_ACCESS_GRANTED : Text = "Access granted";
    public let STATUS_ACCESS_DENIED : Text = "Access denied";

    // Feature flags
    public let ENABLE_CACHE : Bool = true;
    public let ENABLE_QUEUE : Bool = true;
    public let ENABLE_SECURITY : Bool = true;
    public let ENABLE_INTEGRATION : Bool = true;
    public let ENABLE_ANALYTICS : Bool = true;
    public let ENABLE_FILTER : Bool = true;
    public let ENABLE_SORT : Bool = true;
    public let ENABLE_COMPRESSION : Bool = true;
    public let ENABLE_ENCRYPTION : Bool = true;
    public let ENABLE_SHARING : Bool = true;
    public let ENABLE_VERSIONING : Bool = true;
    public let ENABLE_METADATA : Bool = true;
    public let ENABLE_PERMISSIONS : Bool = true;
    public let ENABLE_HISTORY : Bool = true;
    public let ENABLE_METRICS : Bool = true;
    public let ENABLE_LOGGING : Bool = true;
    public let ENABLE_DEBUG : Bool = true;
}; 