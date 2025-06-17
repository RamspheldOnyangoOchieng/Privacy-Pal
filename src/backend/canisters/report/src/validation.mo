

actor class ValidationCanister {
    // Private helper functions
    private func validateReport(report : Types.Report) : Result.Result<(), Text> {
        if (Utils.isEmpty(report.title)) {
            #err("Report title cannot be empty")
        } else if (Utils.isEmpty(report.description)) {
            #err("Report description cannot be empty")
        } else if (report.priority < 0 or report.priority > 10) {
            #err("Report priority must be between 0 and 10")
        } else if (Array.size(report.categories) == 0) {
            #err("Report must have at least one category")
        } else if (Text.size(report.title) > Constants.MAX_REPORT_TITLE_LENGTH) {
            #err("Report title exceeds maximum length")
        } else if (Text.size(report.description) > Constants.MAX_REPORT_DESCRIPTION_LENGTH) {
            #err("Report description exceeds maximum length")
        } else if (Array.size(report.categories) > Constants.MAX_REPORT_CATEGORIES) {
            #err("Report exceeds maximum number of categories")
        } else {
            #ok()
        }
    };

    private func validateSubmission(submission : Types.ReportSubmission) : Result.Result<(), Text> {
        if (Utils.isEmpty(submission.content)) {
            #err("Submission content cannot be empty")
        } else if (submission.priority < 0 or submission.priority > 10) {
            #err("Submission priority must be between 0 and 10")
        } else if (Text.size(submission.content) > Constants.MAX_SUBMISSION_CONTENT_LENGTH) {
            #err("Submission content exceeds maximum length")
        } else {
            #ok()
        }
    };

    private func validateCategory(category : Types.ReportCategory) : Result.Result<(), Text> {
        if (Utils.isEmpty(category.name)) {
            #err("Category name cannot be empty")
        } else if (Utils.isEmpty(category.description)) {
            #err("Category description cannot be empty")
        } else if (Text.size(category.name) > Constants.MAX_CATEGORY_NAME_LENGTH) {
            #err("Category name exceeds maximum length")
        } else if (Text.size(category.description) > Constants.MAX_CATEGORY_DESCRIPTION_LENGTH) {
            #err("Category description exceeds maximum length")
        } else {
            #ok()
        }
    };

    private func validateAttachment(attachment : Types.Attachment) : Result.Result<(), Text> {
        if (Utils.isEmpty(attachment.name)) {
            #err("Attachment name cannot be empty")
        } else if (Utils.isEmpty(attachment.type)) {
            #err("Attachment type cannot be empty")
        } else if (Utils.isEmpty(attachment.data)) {
            #err("Attachment data cannot be empty")
        } else if (Text.size(attachment.name) > Constants.MAX_ATTACHMENT_NAME_LENGTH) {
            #err("Attachment name exceeds maximum length")
        } else if (Text.size(attachment.type) > Constants.MAX_ATTACHMENT_TYPE_LENGTH) {
            #err("Attachment type exceeds maximum length")
        } else if (Text.size(attachment.data) > Constants.MAX_ATTACHMENT_DATA_LENGTH) {
            #err("Attachment data exceeds maximum length")
        } else {
            #ok()
        }
    };

    private func validateComment(comment : Types.Comment) : Result.Result<(), Text> {
        if (Utils.isEmpty(comment.content)) {
            #err("Comment content cannot be empty")
        } else if (comment.priority < 0 or comment.priority > 10) {
            #err("Comment priority must be between 0 and 10")
        } else if (Text.size(comment.content) > Constants.MAX_COMMENT_CONTENT_LENGTH) {
            #err("Comment content exceeds maximum length")
        } else {
            #ok()
        }
    };

    // Public shared functions
    public shared(msg) func validateReportData(report : Types.Report) : async Result.Result<(), Text> {
        validateReport(report)
    };

    public shared(msg) func validateSubmissionData(submission : Types.ReportSubmission) : async Result.Result<(), Text> {
        validateSubmission(submission)
    };

    public shared(msg) func validateCategoryData(category : Types.ReportCategory) : async Result.Result<(), Text> {
        validateCategory(category)
    };

    public shared(msg) func validateAttachmentData(attachment : Types.Attachment) : async Result.Result<(), Text> {
        validateAttachment(attachment)
    };

    public shared(msg) func validateCommentData(comment : Types.Comment) : async Result.Result<(), Text> {
        validateComment(comment)
    };

    // Query functions
    public query func validateReportTitle(title : Text) : async Result.Result<(), Text> {
        if (Utils.isEmpty(title)) {
            #err("Report title cannot be empty")
        } else if (Text.size(title) > Constants.MAX_REPORT_TITLE_LENGTH) {
            #err("Report title exceeds maximum length")
        } else {
            #ok()
        }
    };

    public query func validateReportDescription(description : Text) : async Result.Result<(), Text> {
        if (Utils.isEmpty(description)) {
            #err("Report description cannot be empty")
        } else if (Text.size(description) > Constants.MAX_REPORT_DESCRIPTION_LENGTH) {
            #err("Report description exceeds maximum length")
        } else {
            #ok()
        }
    };

    public query func validateReportPriority(priority : Nat) : async Result.Result<(), Text> {
        if (priority < 0 or priority > 10) {
            #err("Report priority must be between 0 and 10")
        } else {
            #ok()
        }
    };

    public query func validateReportCategories(categories : [Text]) : async Result.Result<(), Text> {
        if (Array.size(categories) == 0) {
            #err("Report must have at least one category")
        } else if (Array.size(categories) > Constants.MAX_REPORT_CATEGORIES) {
            #err("Report exceeds maximum number of categories")
        } else {
            #ok()
        }
    };

    public query func validateSubmissionContent(content : Text) : async Result.Result<(), Text> {
        if (Utils.isEmpty(content)) {
            #err("Submission content cannot be empty")
        } else if (Text.size(content) > Constants.MAX_SUBMISSION_CONTENT_LENGTH) {
            #err("Submission content exceeds maximum length")
        } else {
            #ok()
        }
    };

    public query func validateSubmissionPriority(priority : Nat) : async Result.Result<(), Text> {
        if (priority < 0 or priority > 10) {
            #err("Submission priority must be between 0 and 10")
        } else {
            #ok()
        }
    };

    public query func validateCategoryName(name : Text) : async Result.Result<(), Text> {
        if (Utils.isEmpty(name)) {
            #err("Category name cannot be empty")
        } else if (Text.size(name) > Constants.MAX_CATEGORY_NAME_LENGTH) {
            #err("Category name exceeds maximum length")
        } else {
            #ok()
        }
    };

    public query func validateCategoryDescription(description : Text) : async Result.Result<(), Text> {
        if (Utils.isEmpty(description)) {
            #err("Category description cannot be empty")
        } else if (Text.size(description) > Constants.MAX_CATEGORY_DESCRIPTION_LENGTH) {
            #err("Category description exceeds maximum length")
        } else {
            #ok()
        }
    };

    public query func validateAttachmentName(name : Text) : async Result.Result<(), Text> {
        if (Utils.isEmpty(name)) {
            #err("Attachment name cannot be empty")
        } else if (Text.size(name) > Constants.MAX_ATTACHMENT_NAME_LENGTH) {
            #err("Attachment name exceeds maximum length")
        } else {
            #ok()
        }
    };

    public query func validateAttachmentType(type : Text) : async Result.Result<(), Text> {
        if (Utils.isEmpty(type)) {
            #err("Attachment type cannot be empty")
        } else if (Text.size(type) > Constants.MAX_ATTACHMENT_TYPE_LENGTH) {
            #err("Attachment type exceeds maximum length")
        } else {
            #ok()
        }
    };

    public query func validateAttachmentData(data : Text) : async Result.Result<(), Text> {
        if (Utils.isEmpty(data)) {
            #err("Attachment data cannot be empty")
        } else if (Text.size(data) > Constants.MAX_ATTACHMENT_DATA_LENGTH) {
            #err("Attachment data exceeds maximum length")
        } else {
            #ok()
        }
    };

    public query func validateCommentContent(content : Text) : async Result.Result<(), Text> {
        if (Utils.isEmpty(content)) {
            #err("Comment content cannot be empty")
        } else if (Text.size(content) > Constants.MAX_COMMENT_CONTENT_LENGTH) {
            #err("Comment content exceeds maximum length")
        } else {
            #ok()
        }
    };

    public query func validateCommentPriority(priority : Nat) : async Result.Result<(), Text> {
        if (priority < 0 or priority > 10) {
            #err("Comment priority must be between 0 and 10")
        } else {
            #ok()
        }
    };
}; 