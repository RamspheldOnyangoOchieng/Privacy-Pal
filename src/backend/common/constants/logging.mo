module {
    // Log levels
    public let LOG_LEVEL_TRACE : Nat = 0;
    public let LOG_LEVEL_DEBUG : Nat = 1;
    public let LOG_LEVEL_INFO : Nat = 2;
    public let LOG_LEVEL_WARN : Nat = 3;
    public let LOG_LEVEL_ERROR : Nat = 4;
    public let LOG_LEVEL_FATAL : Nat = 5;

    // Log retention
    public let MIN_LOG_RETENTION : Nat = 0;
    public let MAX_LOG_RETENTION : Nat = 31536000; // 1 year in seconds
    public let DEFAULT_LOG_RETENTION : Nat = 604800; // 1 week in seconds
    public let MIN_LOG_SIZE : Nat = 0;
    public let MAX_LOG_SIZE : Nat = 1073741824; // 1GB in bytes
    public let DEFAULT_LOG_SIZE : Nat = 10485760; // 10MB in bytes
    public let MIN_LOG_ROTATION : Nat = 1;
    public let MAX_LOG_ROTATION : Nat = 100;
    public let DEFAULT_LOG_ROTATION : Nat = 10;

    // Log formats
    public let LOG_FORMAT_JSON : Text = "json";
    public let LOG_FORMAT_TEXT : Text = "text";
    public let LOG_FORMAT_CSV : Text = "csv";
    public let LOG_FORMAT_XML : Text = "xml";
    public let LOG_FORMAT_YAML : Text = "yaml";
    public let LOG_FORMAT_HTML : Text = "html";
    public let LOG_FORMAT_MARKDOWN : Text = "markdown";
    public let LOG_FORMAT_PLAIN : Text = "plain";

    // Log categories
    public let LOG_CATEGORY_SYSTEM : Text = "system";
    public let LOG_CATEGORY_SECURITY : Text = "security";
    public let LOG_CATEGORY_PERFORMANCE : Text = "performance";
    public let LOG_CATEGORY_APPLICATION : Text = "application";
    public let LOG_CATEGORY_DATABASE : Text = "database";
    public let LOG_CATEGORY_NETWORK : Text = "network";
    public let LOG_CATEGORY_USER : Text = "user";
    public let LOG_CATEGORY_AUDIT : Text = "audit";
    public let LOG_CATEGORY_ERROR : Text = "error";
    public let LOG_CATEGORY_WARNING : Text = "warning";
    public let LOG_CATEGORY_INFO : Text = "info";
    public let LOG_CATEGORY_DEBUG : Text = "debug";
    public let LOG_CATEGORY_TRACE : Text = "trace";

    // Log fields
    public let LOG_FIELD_TIMESTAMP : Text = "timestamp";
    public let LOG_FIELD_LEVEL : Text = "level";
    public let LOG_FIELD_CATEGORY : Text = "category";
    public let LOG_FIELD_MESSAGE : Text = "message";
    public let LOG_FIELD_SOURCE : Text = "source";
    public let LOG_FIELD_USER : Text = "user";
    public let LOG_FIELD_SESSION : Text = "session";
    public let LOG_FIELD_REQUEST : Text = "request";
    public let LOG_FIELD_RESPONSE : Text = "response";
    public let LOG_FIELD_ERROR : Text = "error";
    public let LOG_FIELD_STACK : Text = "stack";
    public let LOG_FIELD_METRICS : Text = "metrics";
    public let LOG_FIELD_CONTEXT : Text = "context";

    // Log limits
    public let MIN_LOG_MESSAGE_LENGTH : Nat = 1;
    public let MAX_LOG_MESSAGE_LENGTH : Nat = 10000;
    public let MIN_LOG_SOURCE_LENGTH : Nat = 1;
    public let MAX_LOG_SOURCE_LENGTH : Nat = 255;
    public let MIN_LOG_USER_LENGTH : Nat = 1;
    public let MAX_LOG_USER_LENGTH : Nat = 255;
    public let MIN_LOG_SESSION_LENGTH : Nat = 1;
    public let MAX_LOG_SESSION_LENGTH : Nat = 255;
    public let MIN_LOG_REQUEST_LENGTH : Nat = 1;
    public let MAX_LOG_REQUEST_LENGTH : Nat = 10000;
    public let MIN_LOG_RESPONSE_LENGTH : Nat = 1;
    public let MAX_LOG_RESPONSE_LENGTH : Nat = 10000;
    public let MIN_LOG_ERROR_LENGTH : Nat = 1;
    public let MAX_LOG_ERROR_LENGTH : Nat = 10000;
    public let MIN_LOG_STACK_LENGTH : Nat = 1;
    public let MAX_LOG_STACK_LENGTH : Nat = 10000;
    public let MIN_LOG_METRICS_LENGTH : Nat = 1;
    public let MAX_LOG_METRICS_LENGTH : Nat = 10000;
    public let MIN_LOG_CONTEXT_LENGTH : Nat = 1;
    public let MAX_LOG_CONTEXT_LENGTH : Nat = 10000;

    // Log patterns
    public let LOG_PATTERN_TIMESTAMP : Text = "\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}\\.\\d{3}Z";
    public let LOG_PATTERN_LEVEL : Text = "^(TRACE|DEBUG|INFO|WARN|ERROR|FATAL)$";
    public let LOG_PATTERN_CATEGORY : Text = "^(SYSTEM|SECURITY|PERFORMANCE|APPLICATION|DATABASE|NETWORK|USER|AUDIT|ERROR|WARNING|INFO|DEBUG|TRACE)$";
    public let LOG_PATTERN_SOURCE : Text = "^[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)*$";
    public let LOG_PATTERN_USER : Text = "^[a-zA-Z0-9_-]+$";
    public let LOG_PATTERN_SESSION : Text = "^[a-zA-Z0-9_-]+$";
    public let LOG_PATTERN_REQUEST : Text = "^[a-zA-Z0-9_-]+$";
    public let LOG_PATTERN_RESPONSE : Text = "^[a-zA-Z0-9_-]+$";
    public let LOG_PATTERN_ERROR : Text = "^[a-zA-Z0-9_-]+$";
    public let LOG_PATTERN_STACK : Text = "^[a-zA-Z0-9_-]+$";
    public let LOG_PATTERN_METRICS : Text = "^[a-zA-Z0-9_-]+$";
    public let LOG_PATTERN_CONTEXT : Text = "^[a-zA-Z0-9_-]+$";

    // Error messages
    public let ERROR_INVALID_LOG_LEVEL : Text = "Invalid log level";
    public let ERROR_INVALID_LOG_RETENTION : Text = "Invalid log retention";
    public let ERROR_INVALID_LOG_SIZE : Text = "Invalid log size";
    public let ERROR_INVALID_LOG_ROTATION : Text = "Invalid log rotation";
    public let ERROR_INVALID_LOG_FORMAT : Text = "Invalid log format";
    public let ERROR_INVALID_LOG_CATEGORY : Text = "Invalid log category";
    public let ERROR_INVALID_LOG_FIELD : Text = "Invalid log field";
    public let ERROR_INVALID_LOG_MESSAGE_LENGTH : Text = "Invalid log message length";
    public let ERROR_INVALID_LOG_SOURCE_LENGTH : Text = "Invalid log source length";
    public let ERROR_INVALID_LOG_USER_LENGTH : Text = "Invalid log user length";
    public let ERROR_INVALID_LOG_SESSION_LENGTH : Text = "Invalid log session length";
    public let ERROR_INVALID_LOG_REQUEST_LENGTH : Text = "Invalid log request length";
    public let ERROR_INVALID_LOG_RESPONSE_LENGTH : Text = "Invalid log response length";
    public let ERROR_INVALID_LOG_ERROR_LENGTH : Text = "Invalid log error length";
    public let ERROR_INVALID_LOG_STACK_LENGTH : Text = "Invalid log stack length";
    public let ERROR_INVALID_LOG_METRICS_LENGTH : Text = "Invalid log metrics length";
    public let ERROR_INVALID_LOG_CONTEXT_LENGTH : Text = "Invalid log context length";

    // Status messages
    public let STATUS_LOG_CREATED : Text = "Log created successfully";
    public let STATUS_LOG_DELETED : Text = "Log deleted successfully";
    public let STATUS_LOG_UPDATED : Text = "Log updated successfully";
    public let STATUS_LOG_ROTATED : Text = "Log rotated successfully";
    public let STATUS_LOG_EXPORTED : Text = "Log exported successfully";
    public let STATUS_LOG_IMPORTED : Text = "Log imported successfully";
    public let STATUS_LOG_CLEARED : Text = "Log cleared successfully";
    public let STATUS_LOG_VALIDATED : Text = "Log validated successfully";
    public let STATUS_LOG_INVALID : Text = "Log validation failed";
    public let STATUS_LOG_ERROR : Text = "Log error occurred";
    public let STATUS_LOG_WARNING : Text = "Log warning occurred";
    public let STATUS_LOG_INFO : Text = "Log info message";
    public let STATUS_LOG_DEBUG : Text = "Log debug message";
    public let STATUS_LOG_TRACE : Text = "Log trace message";

    // Feature flags
    public let ENABLE_LOGGING : Bool = true;
    public let ENABLE_LOG_ROTATION : Bool = true;
    public let ENABLE_LOG_EXPORT : Bool = true;
    public let ENABLE_LOG_IMPORT : Bool = true;
    public let ENABLE_LOG_VALIDATION : Bool = true;
    public let ENABLE_LOG_COMPRESSION : Bool = true;
    public let ENABLE_LOG_ENCRYPTION : Bool = true;
    public let ENABLE_LOG_ARCHIVING : Bool = true;
    public let ENABLE_LOG_SEARCH : Bool = true;
    public let ENABLE_LOG_ANALYTICS : Bool = true;
}; 