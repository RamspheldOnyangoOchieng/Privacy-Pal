

module {
    // Time constants
    public let ONE_MINUTE : Nat = 60;
    public let ONE_HOUR : Nat = 3600;
    public let ONE_DAY : Nat = 86400;
    public let ONE_WEEK : Nat = 604800;
    public let ONE_MONTH : Nat = 2592000;
    public let ONE_YEAR : Nat = 31536000;

    // Rate limiting constants
    public let DEFAULT_RATE_LIMIT : Nat = 100;
    public let MAX_RATE_LIMIT : Nat = 1000;
    public let RATE_LIMIT_WINDOW : Nat = 60;
    public let BURST_LIMIT : Nat = 10;

    // Cache constants
    public let DEFAULT_CACHE_TTL : Nat = 3600;
    public let MAX_CACHE_SIZE : Nat = 1000;
    public let CACHE_CLEANUP_INTERVAL : Nat = 300;

    // Security constants
    public let MIN_PASSWORD_LENGTH : Nat = 8;
    public let MAX_LOGIN_ATTEMPTS : Nat = 5;
    public let LOCKOUT_DURATION : Nat = 900;
    public let SESSION_TIMEOUT : Nat = 3600;
    public let TOKEN_EXPIRY : Nat = 86400;

    // Validation constants
    public let MAX_STRING_LENGTH : Nat = 1000;
    public let MAX_ARRAY_SIZE : Nat = 100;
    public let MAX_OBJECT_SIZE : Nat = 100;
    public let MAX_FILE_SIZE : Nat = 10_000_000;

    // Notification constants
    public let MAX_NOTIFICATIONS : Nat = 100;
    public let NOTIFICATION_RETENTION : Nat = 30;
    public let NOTIFICATION_BATCH_SIZE : Nat = 10;

    // Backup constants
    public let BACKUP_RETENTION : Nat = 90;
    public let MAX_BACKUPS : Nat = 10;
    public let BACKUP_INTERVAL : Nat = 86400;

    // Logging constants
    public let MAX_LOG_SIZE : Nat = 1000;
    public let LOG_RETENTION : Nat = 30;
    public let LOG_BATCH_SIZE : Nat = 100;

    // Error messages
    public let ERR_INVALID_INPUT : Text = "Invalid input provided";
    public let ERR_UNAUTHORIZED : Text = "Unauthorized access";
    public let ERR_RATE_LIMITED : Text = "Rate limit exceeded";
    public let ERR_SESSION_EXPIRED : Text = "Session has expired";
    public let ERR_INVALID_TOKEN : Text = "Invalid or expired token";
    public let ERR_SERVER_ERROR : Text = "Internal server error";

    // Status messages
    public let MSG_SUCCESS : Text = "Operation completed successfully";
    public let MSG_PENDING : Text = "Operation is pending";
    public let MSG_FAILED : Text = "Operation failed";
    public let MSG_RETRY : Text = "Please retry the operation";

    // Feature flags
    public let FEATURE_ANONYMIZATION : Bool = true;
    public let FEATURE_WHISTLEBLOWER : Bool = true;
    public let FEATURE_COMMUNITY : Bool = true;
    public let FEATURE_MONITORING : Bool = true;
    public let FEATURE_BACKUP : Bool = true;

    // API versions
    public let API_VERSION : Text = "1.0.0";
    public let MIN_API_VERSION : Text = "1.0.0";
    public let MAX_API_VERSION : Text = "2.0.0";

    // System limits
    public let MAX_USERS : Nat = 10000;
    public let MAX_REPORTS : Nat = 1000;
    public let MAX_REVIEWS : Nat = 100;
    public let MAX_COMMENTS : Nat = 1000;
    public let MAX_ATTACHMENTS : Nat = 10;

    // Performance thresholds
    public let MAX_RESPONSE_TIME : Nat = 5000;
    public let MAX_PROCESSING_TIME : Nat = 10000;
    public let MAX_QUEUE_SIZE : Nat = 1000;
    public let MAX_CONCURRENT_REQUESTS : Nat = 100;

    // Security thresholds
    public let MIN_TRUST_SCORE : Nat = 50;
    public let MAX_RISK_SCORE : Nat = 100;
    public let MIN_REVIEWER_RATING : Nat = 3;
    public let MAX_REPORT_AGE : Nat = 365;

    // Integration settings
    public let DEFAULT_TIMEOUT : Nat = 30000;
    public let MAX_RETRIES : Nat = 3;
    public let RETRY_DELAY : Nat = 1000;
    public let BATCH_SIZE : Nat = 100;

    // Monitoring thresholds
    public let CPU_THRESHOLD : Nat = 80;
    public let MEMORY_THRESHOLD : Nat = 80;
    public let DISK_THRESHOLD : Nat = 80;
    public let ERROR_RATE_THRESHOLD : Nat = 5;

    // Cache keys
    public let CACHE_KEY_USER : Text = "user:";
    public let CACHE_KEY_SESSION : Text = "session:";
    public let CACHE_KEY_REPORT : Text = "report:";
    public let CACHE_KEY_REVIEW : Text = "review:";
    public let CACHE_KEY_METRICS : Text = "metrics:";

    // Queue names
    public let QUEUE_NOTIFICATIONS : Text = "notifications";
    public let QUEUE_REPORTS : Text = "reports";
    public let QUEUE_REVIEWS : Text = "reviews";
    public let QUEUE_BACKUPS : Text = "backups";
    public let QUEUE_LOGS : Text = "logs";

    // Event types
    public let EVENT_USER_CREATED : Text = "user.created";
    public let EVENT_USER_UPDATED : Text = "user.updated";
    public let EVENT_REPORT_CREATED : Text = "report.created";
    public let EVENT_REVIEW_CREATED : Text = "review.created";
    public let EVENT_SYSTEM_ERROR : Text = "system.error";

    // Channel types
    public let CHANNEL_EMAIL : Text = "email";
    public let CHANNEL_SMS : Text = "sms";
    public let CHANNEL_PUSH : Text = "push";
    public let CHANNEL_IN_APP : Text = "in_app";
    public let CHANNEL_WEBHOOK : Text = "webhook";

    // Status codes
    public let STATUS_ACTIVE : Text = "active";
    public let STATUS_INACTIVE : Text = "inactive";
    public let STATUS_PENDING : Text = "pending";
    public let STATUS_COMPLETED : Text = "completed";
    public let STATUS_FAILED : Text = "failed";

    // Permission levels
    public let PERMISSION_NONE : Nat = 0;
    public let PERMISSION_READ : Nat = 1;
    public let PERMISSION_WRITE : Nat = 2;
    public let PERMISSION_ADMIN : Nat = 3;
    public let PERMISSION_SUPER : Nat = 4;

    // Validation patterns
    public let PATTERN_EMAIL : Text = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
    public let PATTERN_PHONE : Text = "^\\+?[1-9]\\d{1,14}$";
    public let PATTERN_URL : Text = "^(https?|ftp)://[^\\s/$.?#].[^\\s]*$";
    public let PATTERN_USERNAME : Text = "^[a-zA-Z0-9_-]{3,16}$";
    public let PATTERN_PASSWORD : Text = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$";

    // File types
    public let FILE_TYPE_PDF : Text = "application/pdf";
    public let FILE_TYPE_IMAGE : Text = "image/*";
    public let FILE_TYPE_DOCUMENT : Text = "application/msword";
    public let FILE_TYPE_SPREADSHEET : Text = "application/vnd.ms-excel";
    public let FILE_TYPE_PRESENTATION : Text = "application/vnd.ms-powerpoint";

    // MIME types
    public let MIME_JSON : Text = "application/json";
    public let MIME_XML : Text = "application/xml";
    public let MIME_HTML : Text = "text/html";
    public let MIME_TEXT : Text = "text/plain";
    public let MIME_BINARY : Text = "application/octet-stream";

    // HTTP methods
    public let METHOD_GET : Text = "GET";
    public let METHOD_POST : Text = "POST";
    public let METHOD_PUT : Text = "PUT";
    public let METHOD_DELETE : Text = "DELETE";
    public let METHOD_PATCH : Text = "PATCH";

    // HTTP status codes
    public let STATUS_OK : Nat = 200;
    public let STATUS_CREATED : Nat = 201;
    public let STATUS_BAD_REQUEST : Nat = 400;
    public let STATUS_UNAUTHORIZED : Nat = 401;
    public let STATUS_FORBIDDEN : Nat = 403;
    public let STATUS_NOT_FOUND : Nat = 404;
    public let STATUS_SERVER_ERROR : Nat = 500;

    // Time zones
    public let TIMEZONE_UTC : Text = "UTC";
    public let TIMEZONE_EST : Text = "America/New_York";
    public let TIMEZONE_PST : Text = "America/Los_Angeles";
    public let TIMEZONE_GMT : Text = "GMT";
    public let TIMEZONE_IST : Text = "Asia/Kolkata";

    // Languages
    public let LANGUAGE_EN : Text = "en";
    public let LANGUAGE_ES : Text = "es";
    public let LANGUAGE_FR : Text = "fr";
    public let LANGUAGE_DE : Text = "de";
    public let LANGUAGE_ZH : Text = "zh";

    // Currencies
    public let CURRENCY_USD : Text = "USD";
    public let CURRENCY_EUR : Text = "EUR";
    public let CURRENCY_GBP : Text = "GBP";
    public let CURRENCY_JPY : Text = "JPY";
    public let CURRENCY_INR : Text = "INR";

    // Units
    public let UNIT_BYTE : Text = "B";
    public let UNIT_KB : Text = "KB";
    public let UNIT_MB : Text = "MB";
    public let UNIT_GB : Text = "GB";
    public let UNIT_TB : Text = "TB";

    // Date formats
    public let DATE_FORMAT_ISO : Text = "YYYY-MM-DD";
    public let DATE_FORMAT_US : Text = "MM/DD/YYYY";
    public let DATE_FORMAT_EU : Text = "DD/MM/YYYY";
    public let DATE_FORMAT_FULL : Text = "YYYY-MM-DD HH:mm:ss";
    public let DATE_FORMAT_SHORT : Text = "MM/DD/YY";

    // Number formats
    public let NUMBER_FORMAT_DECIMAL : Text = "#,##0.00";
    public let NUMBER_FORMAT_CURRENCY : Text = "$#,##0.00";
    public let NUMBER_FORMAT_PERCENT : Text = "#,##0.00%";
    public let NUMBER_FORMAT_SCIENTIFIC : Text = "0.00E+00";
    public let NUMBER_FORMAT_INTEGER : Text = "#,##0";
}; 