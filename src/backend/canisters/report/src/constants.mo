

module {
    // Time constants
    public let ONE_MINUTE : Nat = 60;
    public let ONE_HOUR : Nat = 60 * ONE_MINUTE;
    public let ONE_DAY : Nat = 24 * ONE_HOUR;
    public let ONE_WEEK : Nat = 7 * ONE_DAY;
    public let ONE_MONTH : Nat = 30 * ONE_DAY;
    public let ONE_YEAR : Nat = 365 * ONE_DAY;

    // Report constants
    public let MAX_REPORT_TITLE_LENGTH : Nat = 100;
    public let MAX_REPORT_DESCRIPTION_LENGTH : Nat = 1000;
    public let MAX_REPORT_CATEGORIES : Nat = 5;
    public let REPORT_RETENTION_PERIOD : Nat = ONE_YEAR;
    public let REPORT_ARCHIVE_THRESHOLD : Nat = ONE_MONTH;

    // Submission constants
    public let MAX_SUBMISSION_CONTENT_LENGTH : Nat = 500;
    public let MAX_SUBMISSIONS_PER_REPORT : Nat = 10;
    public let SUBMISSION_RETENTION_PERIOD : Nat = ONE_MONTH;
    public let SUBMISSION_ARCHIVE_THRESHOLD : Nat = ONE_WEEK;

    // Category constants
    public let MAX_CATEGORY_NAME_LENGTH : Nat = 50;
    public let MAX_CATEGORY_DESCRIPTION_LENGTH : Nat = 200;
    public let MAX_CATEGORIES : Nat = 20;
    public let CATEGORY_RETENTION_PERIOD : Nat = ONE_YEAR;

    // Attachment constants
    public let MAX_ATTACHMENT_NAME_LENGTH : Nat = 100;
    public let MAX_ATTACHMENT_TYPE_LENGTH : Nat = 50;
    public let MAX_ATTACHMENT_DATA_LENGTH : Nat = 10_000_000; // 10MB
    public let MAX_ATTACHMENTS_PER_REPORT : Nat = 5;
    public let ATTACHMENT_RETENTION_PERIOD : Nat = ONE_MONTH;

    // Comment constants
    public let MAX_COMMENT_CONTENT_LENGTH : Nat = 500;
    public let MAX_COMMENTS_PER_REPORT : Nat = 100;
    public let COMMENT_RETENTION_PERIOD : Nat = ONE_MONTH;
    public let COMMENT_ARCHIVE_THRESHOLD : Nat = ONE_WEEK;

    // Validation patterns
    public let EMAIL_PATTERN : Text = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
    public let PHONE_PATTERN : Text = "^\\+?[1-9]\\d{1,14}$";
    public let URL_PATTERN : Text = "^(https?|ftp)://[^\\s/$.?#].[^\\s]*$";
    public let USERNAME_PATTERN : Text = "^[a-zA-Z0-9_-]{3,16}$";
    public let PASSWORD_PATTERN : Text = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$";

    // Error messages
    public let ERROR_REPORT_NOT_FOUND : Text = "Report not found";
    public let ERROR_SUBMISSION_NOT_FOUND : Text = "Submission not found";
    public let ERROR_CATEGORY_NOT_FOUND : Text = "Category not found";
    public let ERROR_ATTACHMENT_NOT_FOUND : Text = "Attachment not found";
    public let ERROR_COMMENT_NOT_FOUND : Text = "Comment not found";
    public let ERROR_INVALID_REPORT_TITLE : Text = "Invalid report title";
    public let ERROR_INVALID_REPORT_DESCRIPTION : Text = "Invalid report description";
    public let ERROR_INVALID_REPORT_PRIORITY : Text = "Invalid report priority";
    public let ERROR_INVALID_SUBMISSION_CONTENT : Text = "Invalid submission content";
    public let ERROR_INVALID_SUBMISSION_PRIORITY : Text = "Invalid submission priority";
    public let ERROR_INVALID_CATEGORY_NAME : Text = "Invalid category name";
    public let ERROR_INVALID_CATEGORY_DESCRIPTION : Text = "Invalid category description";
    public let ERROR_INVALID_ATTACHMENT_NAME : Text = "Invalid attachment name";
    public let ERROR_INVALID_ATTACHMENT_TYPE : Text = "Invalid attachment type";
    public let ERROR_INVALID_ATTACHMENT_DATA : Text = "Invalid attachment data";
    public let ERROR_INVALID_COMMENT_CONTENT : Text = "Invalid comment content";
    public let ERROR_INVALID_COMMENT_PRIORITY : Text = "Invalid comment priority";
    public let ERROR_REPORT_ALREADY_EXISTS : Text = "Report already exists";
    public let ERROR_SUBMISSION_ALREADY_EXISTS : Text = "Submission already exists";
    public let ERROR_CATEGORY_ALREADY_EXISTS : Text = "Category already exists";
    public let ERROR_ATTACHMENT_ALREADY_EXISTS : Text = "Attachment already exists";
    public let ERROR_COMMENT_ALREADY_EXISTS : Text = "Comment already exists";
    public let ERROR_REPORT_LIMIT_EXCEEDED : Text = "Report limit exceeded";
    public let ERROR_SUBMISSION_LIMIT_EXCEEDED : Text = "Submission limit exceeded";
    public let ERROR_CATEGORY_LIMIT_EXCEEDED : Text = "Category limit exceeded";
    public let ERROR_ATTACHMENT_LIMIT_EXCEEDED : Text = "Attachment limit exceeded";
    public let ERROR_COMMENT_LIMIT_EXCEEDED : Text = "Comment limit exceeded";
    public let ERROR_REPORT_RETENTION_EXPIRED : Text = "Report retention period expired";
    public let ERROR_SUBMISSION_RETENTION_EXPIRED : Text = "Submission retention period expired";
    public let ERROR_CATEGORY_RETENTION_EXPIRED : Text = "Category retention period expired";
    public let ERROR_ATTACHMENT_RETENTION_EXPIRED : Text = "Attachment retention period expired";
    public let ERROR_COMMENT_RETENTION_EXPIRED : Text = "Comment retention period expired";

    // Status messages
    public let STATUS_REPORT_CREATED : Text = "Report created successfully";
    public let STATUS_SUBMISSION_CREATED : Text = "Submission created successfully";
    public let STATUS_CATEGORY_CREATED : Text = "Category created successfully";
    public let STATUS_ATTACHMENT_CREATED : Text = "Attachment created successfully";
    public let STATUS_COMMENT_CREATED : Text = "Comment created successfully";
    public let STATUS_REPORT_UPDATED : Text = "Report updated successfully";
    public let STATUS_SUBMISSION_UPDATED : Text = "Submission updated successfully";
    public let STATUS_CATEGORY_UPDATED : Text = "Category updated successfully";
    public let STATUS_ATTACHMENT_UPDATED : Text = "Attachment updated successfully";
    public let STATUS_COMMENT_UPDATED : Text = "Comment updated successfully";
    public let STATUS_REPORT_DELETED : Text = "Report deleted successfully";
    public let STATUS_SUBMISSION_DELETED : Text = "Submission deleted successfully";
    public let STATUS_CATEGORY_DELETED : Text = "Category deleted successfully";
    public let STATUS_ATTACHMENT_DELETED : Text = "Attachment deleted successfully";
    public let STATUS_COMMENT_DELETED : Text = "Comment deleted successfully";
    public let STATUS_REPORT_ARCHIVED : Text = "Report archived successfully";
    public let STATUS_SUBMISSION_ARCHIVED : Text = "Submission archived successfully";
    public let STATUS_COMMENT_ARCHIVED : Text = "Comment archived successfully";

    // Feature flags
    public let FEATURE_REPORT_ARCHIVING : Bool = true;
    public let FEATURE_SUBMISSION_ARCHIVING : Bool = true;
    public let FEATURE_COMMENT_ARCHIVING : Bool = true;
    public let FEATURE_REPORT_RETENTION : Bool = true;
    public let FEATURE_SUBMISSION_RETENTION : Bool = true;
    public let FEATURE_CATEGORY_RETENTION : Bool = true;
    public let FEATURE_ATTACHMENT_RETENTION : Bool = true;
    public let FEATURE_COMMENT_RETENTION : Bool = true;
    public let FEATURE_REPORT_METRICS : Bool = true;
    public let FEATURE_REPORT_HISTORY : Bool = true;
    public let FEATURE_REPORT_FILTERING : Bool = true;
    public let FEATURE_REPORT_SORTING : Bool = true;
    public let FEATURE_REPORT_SEARCH : Bool = true;
    public let FEATURE_REPORT_EXPORT : Bool = true;
    public let FEATURE_REPORT_IMPORT : Bool = true;
    public let FEATURE_REPORT_SHARING : Bool = true;
    public let FEATURE_REPORT_COLLABORATION : Bool = true;
    public let FEATURE_REPORT_NOTIFICATIONS : Bool = true;
    public let FEATURE_REPORT_ANALYTICS : Bool = true;
    public let FEATURE_REPORT_AUDITING : Bool = true;
    public let FEATURE_REPORT_BACKUP : Bool = true;
    public let FEATURE_REPORT_RESTORE : Bool = true;
}; 