

module {
    // Time constants
    public let ONE_MINUTE : Nat = 60;
    public let ONE_HOUR : Nat = 3600;
    public let ONE_DAY : Nat = 86400;
    public let ONE_WEEK : Nat = 604800;
    public let ONE_MONTH : Nat = 2592000;
    public let ONE_YEAR : Nat = 31536000;

    // Report constants
    public let MAX_REPORT_TITLE_LENGTH : Nat = 200;
    public let MAX_REPORT_DESCRIPTION_LENGTH : Nat = 5000;
    public let MAX_REPORT_CATEGORY_LENGTH : Nat = 100;
    public let MAX_REPORTS_PER_USER : Nat = 100;
    public let REPORT_RETENTION_PERIOD : Nat = 365 * ONE_DAY;

    // Action constants
    public let MAX_ACTION_REASON_LENGTH : Nat = 1000;
    public let MAX_ACTION_CUSTOM_TYPE_LENGTH : Nat = 100;
    public let MAX_ACTION_DURATION : Nat = 365 * ONE_DAY;
    public let MIN_ACTION_DURATION : Nat = ONE_DAY;
    public let DEFAULT_ACTION_DURATION : Nat = 7 * ONE_DAY;

    // Rule constants
    public let MAX_RULE_NAME_LENGTH : Nat = 200;
    public let MAX_RULE_DESCRIPTION_LENGTH : Nat = 1000;
    public let MAX_RULE_CUSTOM_TYPE_LENGTH : Nat = 100;
    public let MAX_RULE_CONDITIONS : Nat = 10;
    public let MAX_RULE_ACTIONS : Nat = 5;

    // Moderator constants
    public let MAX_MODERATOR_NAME_LENGTH : Nat = 200;
    public let MAX_MODERATOR_EMAIL_LENGTH : Nat = 200;
    public let MAX_MODERATOR_SPECIALIZATIONS : Nat = 10;
    public let MAX_MODERATOR_LANGUAGES : Nat = 10;
    public let MAX_MODERATOR_REGIONS : Nat = 10;
    public let MIN_MODERATOR_ACCURACY : Float = 0.8;
    public let MAX_MODERATOR_RESPONSE_TIME : Nat = 24 * ONE_HOUR;

    // Content constants
    public let MAX_CONTENT_DATA_LENGTH : Nat = 10000;
    public let MAX_CONTENT_METADATA_FIELDS : Nat = 20;
    public let MAX_CONTENT_METADATA_VALUE_LENGTH : Nat = 1000;
    public let CONTENT_RETENTION_PERIOD : Nat = 30 * ONE_DAY;

    // Category constants
    public let MAX_CATEGORY_NAME_LENGTH : Nat = 200;
    public let MAX_CATEGORY_DESCRIPTION_LENGTH : Nat = 1000;
    public let MAX_CATEGORY_RULES : Nat = 50;
    public let MAX_CATEGORY_DEPTH : Nat = 5;

    // Filter constants
    public let MAX_FILTER_NAME_LENGTH : Nat = 200;
    public let MAX_FILTER_PATTERN_LENGTH : Nat = 1000;
    public let MAX_FILTER_PRIORITY : Nat = 100;
    public let MIN_FILTER_PRIORITY : Nat = 1;
    public let DEFAULT_FILTER_PRIORITY : Nat = 50;

    // Template constants
    public let MAX_TEMPLATE_NAME_LENGTH : Nat = 200;
    public let MAX_TEMPLATE_CONTENT_LENGTH : Nat = 5000;
    public let MAX_TEMPLATE_VARIABLES : Nat = 20;
    public let MAX_TEMPLATE_VARIABLE_LENGTH : Nat = 100;

    // Queue constants
    public let MAX_QUEUE_NAME_LENGTH : Nat = 200;
    public let MAX_QUEUE_ITEMS : Nat = 1000;
    public let MAX_QUEUE_ITEM_DATA_LENGTH : Nat = 10000;
    public let MAX_QUEUE_ITEM_PRIORITY : Nat = 100;
    public let MIN_QUEUE_ITEM_PRIORITY : Nat = 1;
    public let DEFAULT_QUEUE_ITEM_PRIORITY : Nat = 50;

    // Appeal constants
    public let MAX_APPEAL_REASON_LENGTH : Nat = 2000;
    public let MAX_APPEALS_PER_REPORT : Nat = 3;
    public let APPEAL_RETENTION_PERIOD : Nat = 90 * ONE_DAY;

    // Comment constants
    public let MAX_COMMENT_CONTENT_LENGTH : Nat = 1000;
    public let MAX_COMMENTS_PER_REPORT : Nat = 100;
    public let COMMENT_RETENTION_PERIOD : Nat = 180 * ONE_DAY;

    // Attachment constants
    public let MAX_ATTACHMENT_NAME_LENGTH : Nat = 200;
    public let MAX_ATTACHMENT_SIZE : Nat = 10 * 1024 * 1024; // 10MB
    public let MAX_ATTACHMENTS_PER_REPORT : Nat = 10;
    public let ATTACHMENT_RETENTION_PERIOD : Nat = 90 * ONE_DAY;

    // Notification constants
    public let MAX_NOTIFICATION_TITLE_LENGTH : Nat = 200;
    public let MAX_NOTIFICATION_CONTENT_LENGTH : Nat = 1000;
    public let MAX_NOTIFICATIONS_PER_USER : Nat = 100;
    public let NOTIFICATION_RETENTION_PERIOD : Nat = 30 * ONE_DAY;

    // Alert constants
    public let MAX_ALERT_MESSAGE_LENGTH : Nat = 1000;
    public let MAX_ALERTS : Nat = 1000;
    public let ALERT_RETENTION_PERIOD : Nat = 30 * ONE_DAY;

    // Audit constants
    public let MAX_AUDIT_ACTION_LENGTH : Nat = 200;
    public let MAX_AUDIT_DETAILS_LENGTH : Nat = 1000;
    public let AUDIT_RETENTION_PERIOD : Nat = 365 * ONE_DAY;

    // Error messages
    public let ERR_INVALID_INPUT : Text = "Invalid input provided";
    public let ERR_UNAUTHORIZED : Text = "Unauthorized access";
    public let ERR_NOT_FOUND : Text = "Resource not found";
    public let ERR_ALREADY_EXISTS : Text = "Resource already exists";
    public let ERR_INVALID_STATE : Text = "Invalid state";
    public let ERR_INVALID_OPERATION : Text = "Invalid operation";
    public let ERR_INVALID_PERMISSION : Text = "Invalid permission";
    public let ERR_INVALID_ROLE : Text = "Invalid role";
    public let ERR_INVALID_STATUS : Text = "Invalid status";
    public let ERR_INVALID_TYPE : Text = "Invalid type";
    public let ERR_INVALID_VALUE : Text = "Invalid value";
    public let ERR_INVALID_FORMAT : Text = "Invalid format";
    public let ERR_INVALID_LENGTH : Text = "Invalid length";
    public let ERR_INVALID_RANGE : Text = "Invalid range";
    public let ERR_INVALID_PATTERN : Text = "Invalid pattern";
    public let ERR_INVALID_CONDITION : Text = "Invalid condition";
    public let ERR_INVALID_ACTION : Text = "Invalid action";
    public let ERR_INVALID_RULE : Text = "Invalid rule";
    public let ERR_INVALID_FILTER : Text = "Invalid filter";
    public let ERR_INVALID_TEMPLATE : Text = "Invalid template";
    public let ERR_INVALID_QUEUE : Text = "Invalid queue";
    public let ERR_INVALID_APPEAL : Text = "Invalid appeal";
    public let ERR_INVALID_COMMENT : Text = "Invalid comment";
    public let ERR_INVALID_ATTACHMENT : Text = "Invalid attachment";
    public let ERR_INVALID_NOTIFICATION : Text = "Invalid notification";
    public let ERR_INVALID_ALERT : Text = "Invalid alert";
    public let ERR_INVALID_AUDIT : Text = "Invalid audit";

    // Status messages
    public let MSG_SUCCESS : Text = "Operation completed successfully";
    public let MSG_PENDING : Text = "Operation is pending";
    public let MSG_FAILED : Text = "Operation failed";
    public let MSG_RETRY : Text = "Please retry the operation";
    public let MSG_WAIT : Text = "Please wait for the operation to complete";
    public let MSG_CONTACT_SUPPORT : Text = "Please contact support for assistance";
    public let MSG_CHECK_LOGS : Text = "Please check the logs for more information";
    public let MSG_TRY_AGAIN : Text = "Please try again later";
    public let MSG_TRY_DIFFERENT : Text = "Please try a different approach";
    public let MSG_TRY_SIMPLER : Text = "Please try a simpler approach";
    public let MSG_TRY_MORE : Text = "Please try with more information";
    public let MSG_TRY_LESS : Text = "Please try with less information";
    public let MSG_TRY_OTHER : Text = "Please try a different resource";
    public let MSG_TRY_SAME : Text = "Please try the same resource again";
    public let MSG_TRY_NEW : Text = "Please try a new resource";
    public let MSG_TRY_OLD : Text = "Please try an existing resource";
    public let MSG_TRY_CUSTOM : Text = "Please try a custom approach";
    public let MSG_TRY_DEFAULT : Text = "Please try the default approach";
    public let MSG_TRY_ALTERNATIVE : Text = "Please try an alternative approach";
    public let MSG_TRY_BACKUP : Text = "Please try the backup approach";
    public let MSG_TRY_FALLBACK : Text = "Please try the fallback approach";
    public let MSG_TRY_PRIMARY : Text = "Please try the primary approach";
    public let MSG_TRY_SECONDARY : Text = "Please try the secondary approach";
    public let MSG_TRY_TERTIARY : Text = "Please try the tertiary approach";
    public let MSG_TRY_QUATERNARY : Text = "Please try the quaternary approach";
    public let MSG_TRY_QUINARY : Text = "Please try the quinary approach";
    public let MSG_TRY_SENARY : Text = "Please try the senary approach";
    public let MSG_TRY_SEPTENARY : Text = "Please try the septenary approach";
    public let MSG_TRY_OCTONARY : Text = "Please try the octonary approach";
    public let MSG_TRY_NONARY : Text = "Please try the nonary approach";
    public let MSG_TRY_DENARY : Text = "Please try the denary approach";

    // Feature flags
    public let FEATURE_REPORT_AUTO_ASSIGNMENT : Bool = true;
    public let FEATURE_REPORT_PRIORITY : Bool = true;
    public let FEATURE_REPORT_CATEGORIES : Bool = true;
    public let FEATURE_REPORT_ATTACHMENTS : Bool = true;
    public let FEATURE_REPORT_COMMENTS : Bool = true;
    public let FEATURE_REPORT_APPEALS : Bool = true;
    public let FEATURE_REPORT_NOTIFICATIONS : Bool = true;
    public let FEATURE_REPORT_ALERTS : Bool = true;
    public let FEATURE_REPORT_AUDITS : Bool = true;
    public let FEATURE_ACTION_AUTO_APPROVAL : Bool = true;
    public let FEATURE_ACTION_PRIORITY : Bool = true;
    public let FEATURE_ACTION_DURATION : Bool = true;
    public let FEATURE_ACTION_NOTIFICATIONS : Bool = true;
    public let FEATURE_ACTION_ALERTS : Bool = true;
    public let FEATURE_ACTION_AUDITS : Bool = true;
    public let FEATURE_RULE_AUTO_APPLICATION : Bool = true;
    public let FEATURE_RULE_PRIORITY : Bool = true;
    public let FEATURE_RULE_CONDITIONS : Bool = true;
    public let FEATURE_RULE_ACTIONS : Bool = true;
    public let FEATURE_RULE_NOTIFICATIONS : Bool = true;
    public let FEATURE_RULE_ALERTS : Bool = true;
    public let FEATURE_RULE_AUDITS : Bool = true;
    public let FEATURE_MODERATOR_AUTO_ASSIGNMENT : Bool = true;
    public let FEATURE_MODERATOR_PRIORITY : Bool = true;
    public let FEATURE_MODERATOR_SPECIALIZATION : Bool = true;
    public let FEATURE_MODERATOR_LANGUAGES : Bool = true;
    public let FEATURE_MODERATOR_REGIONS : Bool = true;
    public let FEATURE_MODERATOR_METRICS : Bool = true;
    public let FEATURE_MODERATOR_NOTIFICATIONS : Bool = true;
    public let FEATURE_MODERATOR_ALERTS : Bool = true;
    public let FEATURE_MODERATOR_AUDITS : Bool = true;
    public let FEATURE_CONTENT_AUTO_FILTERING : Bool = true;
    public let FEATURE_CONTENT_PRIORITY : Bool = true;
    public let FEATURE_CONTENT_METADATA : Bool = true;
    public let FEATURE_CONTENT_NOTIFICATIONS : Bool = true;
    public let FEATURE_CONTENT_ALERTS : Bool = true;
    public let FEATURE_CONTENT_AUDITS : Bool = true;
    public let FEATURE_CATEGORY_AUTO_ASSIGNMENT : Bool = true;
    public let FEATURE_CATEGORY_PRIORITY : Bool = true;
    public let FEATURE_CATEGORY_RULES : Bool = true;
    public let FEATURE_CATEGORY_NOTIFICATIONS : Bool = true;
    public let FEATURE_CATEGORY_ALERTS : Bool = true;
    public let FEATURE_CATEGORY_AUDITS : Bool = true;
    public let FEATURE_FILTER_AUTO_APPLICATION : Bool = true;
    public let FEATURE_FILTER_PRIORITY : Bool = true;
    public let FEATURE_FILTER_PATTERNS : Bool = true;
    public let FEATURE_FILTER_ACTIONS : Bool = true;
    public let FEATURE_FILTER_NOTIFICATIONS : Bool = true;
    public let FEATURE_FILTER_ALERTS : Bool = true;
    public let FEATURE_FILTER_AUDITS : Bool = true;
    public let FEATURE_TEMPLATE_AUTO_APPLICATION : Bool = true;
    public let FEATURE_TEMPLATE_PRIORITY : Bool = true;
    public let FEATURE_TEMPLATE_VARIABLES : Bool = true;
    public let FEATURE_TEMPLATE_NOTIFICATIONS : Bool = true;
    public let FEATURE_TEMPLATE_ALERTS : Bool = true;
    public let FEATURE_TEMPLATE_AUDITS : Bool = true;
    public let FEATURE_QUEUE_AUTO_PROCESSING : Bool = true;
    public let FEATURE_QUEUE_PRIORITY : Bool = true;
    public let FEATURE_QUEUE_ITEMS : Bool = true;
    public let FEATURE_QUEUE_NOTIFICATIONS : Bool = true;
    public let FEATURE_QUEUE_ALERTS : Bool = true;
    public let FEATURE_QUEUE_AUDITS : Bool = true;
    public let FEATURE_APPEAL_AUTO_PROCESSING : Bool = true;
    public let FEATURE_APPEAL_PRIORITY : Bool = true;
    public let FEATURE_APPEAL_REASONS : Bool = true;
    public let FEATURE_APPEAL_NOTIFICATIONS : Bool = true;
    public let FEATURE_APPEAL_ALERTS : Bool = true;
    public let FEATURE_APPEAL_AUDITS : Bool = true;
    public let FEATURE_COMMENT_AUTO_MODERATION : Bool = true;
    public let FEATURE_COMMENT_PRIORITY : Bool = true;
    public let FEATURE_COMMENT_CONTENT : Bool = true;
    public let FEATURE_COMMENT_NOTIFICATIONS : Bool = true;
    public let FEATURE_COMMENT_ALERTS : Bool = true;
    public let FEATURE_COMMENT_AUDITS : Bool = true;
    public let FEATURE_ATTACHMENT_AUTO_SCANNING : Bool = true;
    public let FEATURE_ATTACHMENT_PRIORITY : Bool = true;
    public let FEATURE_ATTACHMENT_SIZE : Bool = true;
    public let FEATURE_ATTACHMENT_TYPE : Bool = true;
    public let FEATURE_ATTACHMENT_NOTIFICATIONS : Bool = true;
    public let FEATURE_ATTACHMENT_ALERTS : Bool = true;
    public let FEATURE_ATTACHMENT_AUDITS : Bool = true;
    public let FEATURE_NOTIFICATION_AUTO_SENDING : Bool = true;
    public let FEATURE_NOTIFICATION_PRIORITY : Bool = true;
    public let FEATURE_NOTIFICATION_CONTENT : Bool = true;
    public let FEATURE_NOTIFICATION_CHANNELS : Bool = true;
    public let FEATURE_NOTIFICATION_ALERTS : Bool = true;
    public let FEATURE_NOTIFICATION_AUDITS : Bool = true;
    public let FEATURE_ALERT_AUTO_TRIGGERING : Bool = true;
    public let FEATURE_ALERT_PRIORITY : Bool = true;
    public let FEATURE_ALERT_MESSAGES : Bool = true;
    public let FEATURE_ALERT_SEVERITY : Bool = true;
    public let FEATURE_ALERT_NOTIFICATIONS : Bool = true;
    public let FEATURE_ALERT_AUDITS : Bool = true;
    public let FEATURE_AUDIT_AUTO_LOGGING : Bool = true;
    public let FEATURE_AUDIT_PRIORITY : Bool = true;
    public let FEATURE_AUDIT_ACTIONS : Bool = true;
    public let FEATURE_AUDIT_DETAILS : Bool = true;
    public let FEATURE_AUDIT_NOTIFICATIONS : Bool = true;
    public let FEATURE_AUDIT_ALERTS : Bool = true;
}; 