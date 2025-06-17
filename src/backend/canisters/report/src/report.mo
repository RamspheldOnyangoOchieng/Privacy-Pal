

actor class ReportCanister {
    // State variables
    private stable var reports = HashMap.new<Text, Types.Report>();
    private stable var submissions = HashMap.new<Text, Types.ReportSubmission>();
    private stable var categories = HashMap.new<Text, Types.ReportCategory>();
    private stable var attachments = HashMap.new<Text, Types.Attachment>();
    private stable var comments = HashMap.new<Text, Types.Comment>();
    private stable var metrics = HashMap.new<Text, Types.ReportMetrics>();
    private stable var history = HashMap.new<Text, Types.ReportHistory>();

    // Private helper functions
    private func generateReportId() : Text {
        "report_" # Nat.toText(Time.now())
    };

    private func generateSubmissionId() : Text {
        "submission_" # Nat.toText(Time.now())
    };

    private func generateCategoryId() : Text {
        "category_" # Nat.toText(Time.now())
    };

    private func generateAttachmentId() : Text {
        "attachment_" # Nat.toText(Time.now())
    };

    private func generateCommentId() : Text {
        "comment_" # Nat.toText(Time.now())
    };

    private func validateReport(report : Types.Report) : Result.Result<(), Text> {
        if (Utils.isEmpty(report.title)) {
            #err("Report title cannot be empty")
        } else if (Utils.isEmpty(report.description)) {
            #err("Report description cannot be empty")
        } else if (report.priority < 0 or report.priority > 10) {
            #err("Report priority must be between 0 and 10")
        } else if (Array.size(report.categories) == 0) {
            #err("Report must have at least one category")
        } else {
            #ok()
        }
    };

    private func validateSubmission(submission : Types.ReportSubmission) : Result.Result<(), Text> {
        if (Utils.isEmpty(submission.content)) {
            #err("Submission content cannot be empty")
        } else if (submission.priority < 0 or submission.priority > 10) {
            #err("Submission priority must be between 0 and 10")
        } else {
            #ok()
        }
    };

    private func validateCategory(category : Types.ReportCategory) : Result.Result<(), Text> {
        if (Utils.isEmpty(category.name)) {
            #err("Category name cannot be empty")
        } else if (Utils.isEmpty(category.description)) {
            #err("Category description cannot be empty")
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
        } else {
            #ok()
        }
    };

    private func validateComment(comment : Types.Comment) : Result.Result<(), Text> {
        if (Utils.isEmpty(comment.content)) {
            #err("Comment content cannot be empty")
        } else if (comment.priority < 0 or comment.priority > 10) {
            #err("Comment priority must be between 0 and 10")
        } else {
            #ok()
        }
    };

    private func updateReportMetrics(reportId : Text, metricType : Text, value : Nat) : () {
        let currentMetrics = Option.get(HashMap.get(metrics, Text.equal, reportId), {
            views = 0;
            submissions = 0;
            attachments = 0;
            comments = 0;
            lastUpdated = Time.now()
        });
        let updatedMetrics = {
            currentMetrics with
            views = currentMetrics.views + value;
            lastUpdated = Time.now()
        };
        HashMap.put(metrics, Text.equal, reportId, updatedMetrics)
    };

    private func updateReportHistory(reportId : Text, action : Text, submissionId : Text) : () {
        let currentHistory = Option.get(HashMap.get(history, Text.equal, reportId), {
            actions = [];
            lastUpdated = Time.now()
        });
        let newAction = {
            action = action;
            submissionId = submissionId;
            timestamp = Time.now()
        };
        let updatedHistory = {
            currentHistory with
            actions = Array.append(currentHistory.actions, [newAction]);
            lastUpdated = Time.now()
        };
        HashMap.put(history, Text.equal, reportId, updatedHistory)
    };

    // Public shared functions
    public shared(msg) func createReport(report : Types.Report) : async Result.Result<Text, Text> {
        switch (validateReport(report)) {
            case (#ok()) {
                let reportId = generateReportId();
                let newReport = {
                    report with
                    id = reportId;
                    status = #pending;
                    createdBy = msg.caller;
                    createdAt = Time.now();
                    updatedAt = Time.now()
                };
                HashMap.put(reports, Text.equal, reportId, newReport);
                updateReportMetrics(reportId, "created", 1);
                updateReportHistory(reportId, "created", "");
                #ok(reportId)
            };
            case (#err(msg)) #err(msg)
        }
    };

    public shared(msg) func createSubmission(submission : Types.ReportSubmission) : async Result.Result<Text, Text> {
        switch (validateSubmission(submission)) {
            case (#ok()) {
                let submissionId = generateSubmissionId();
                let newSubmission = {
                    submission with
                    id = submissionId;
                    status = #pending;
                    createdBy = msg.caller;
                    createdAt = Time.now();
                    updatedAt = Time.now()
                };
                HashMap.put(submissions, Text.equal, submissionId, newSubmission);
                updateReportMetrics(submission.reportId, "submission_added", 1);
                updateReportHistory(submission.reportId, "submission_created", submissionId);
                #ok(submissionId)
            };
            case (#err(msg)) #err(msg)
        }
    };

    public shared(msg) func createCategory(category : Types.ReportCategory) : async Result.Result<Text, Text> {
        switch (validateCategory(category)) {
            case (#ok()) {
                let categoryId = generateCategoryId();
                let newCategory = {
                    category with
                    id = categoryId;
                    createdBy = msg.caller;
                    createdAt = Time.now();
                    updatedAt = Time.now()
                };
                HashMap.put(categories, Text.equal, categoryId, newCategory);
                #ok(categoryId)
            };
            case (#err(msg)) #err(msg)
        }
    };

    public shared(msg) func createAttachment(attachment : Types.Attachment) : async Result.Result<Text, Text> {
        switch (validateAttachment(attachment)) {
            case (#ok()) {
                let attachmentId = generateAttachmentId();
                let newAttachment = {
                    attachment with
                    id = attachmentId;
                    createdBy = msg.caller;
                    createdAt = Time.now();
                    updatedAt = Time.now()
                };
                HashMap.put(attachments, Text.equal, attachmentId, newAttachment);
                updateReportMetrics(attachment.reportId, "attachment_added", 1);
                #ok(attachmentId)
            };
            case (#err(msg)) #err(msg)
        }
    };

    public shared(msg) func createComment(comment : Types.Comment) : async Result.Result<Text, Text> {
        switch (validateComment(comment)) {
            case (#ok()) {
                let commentId = generateCommentId();
                let newComment = {
                    comment with
                    id = commentId;
                    createdBy = msg.caller;
                    createdAt = Time.now();
                    updatedAt = Time.now()
                };
                HashMap.put(comments, Text.equal, commentId, newComment);
                updateReportMetrics(comment.reportId, "comment_added", 1);
                #ok(commentId)
            };
            case (#err(msg)) #err(msg)
        }
    };

    public shared(msg) func updateReportStatus(reportId : Text, status : Types.ReportStatus) : async Result.Result<(), Text> {
        switch (HashMap.get(reports, Text.equal, reportId)) {
            case (?report) {
                let updatedReport = {
                    report with
                    status = status;
                    updatedAt = Time.now()
                };
                HashMap.put(reports, Text.equal, reportId, updatedReport);
                updateReportHistory(reportId, "status_updated", "");
                #ok()
            };
            case null #err("Report not found")
        }
    };

    public shared(msg) func updateSubmissionStatus(submissionId : Text, status : Types.ReportSubmissionStatus) : async Result.Result<(), Text> {
        switch (HashMap.get(submissions, Text.equal, submissionId)) {
            case (?submission) {
                let updatedSubmission = {
                    submission with
                    status = status;
                    updatedAt = Time.now()
                };
                HashMap.put(submissions, Text.equal, submissionId, updatedSubmission);
                updateReportHistory(submission.reportId, "submission_status_updated", submissionId);
                #ok()
            };
            case null #err("Submission not found")
        }
    };

    public shared(msg) func addCategoryToReport(reportId : Text, categoryId : Text) : async Result.Result<(), Text> {
        switch (HashMap.get(reports, Text.equal, reportId)) {
            case (?report) {
                switch (HashMap.get(categories, Text.equal, categoryId)) {
                    case (?category) {
                        let updatedReport = {
                            report with
                            categories = Array.append(report.categories, [categoryId]);
                            updatedAt = Time.now()
                        };
                        HashMap.put(reports, Text.equal, reportId, updatedReport);
                        updateReportHistory(reportId, "category_added", categoryId);
                        #ok()
                    };
                    case null #err("Category not found")
                }
            };
            case null #err("Report not found")
        }
    };

    // Query functions
    public query func getReport(reportId : Text) : async ?Types.Report {
        HashMap.get(reports, Text.equal, reportId)
    };

    public query func getSubmission(submissionId : Text) : async ?Types.ReportSubmission {
        HashMap.get(submissions, Text.equal, submissionId)
    };

    public query func getCategory(categoryId : Text) : async ?Types.ReportCategory {
        HashMap.get(categories, Text.equal, categoryId)
    };

    public query func getAttachment(attachmentId : Text) : async ?Types.Attachment {
        HashMap.get(attachments, Text.equal, attachmentId)
    };

    public query func getComment(commentId : Text) : async ?Types.Comment {
        HashMap.get(comments, Text.equal, commentId)
    };

    public query func getReportMetrics(reportId : Text) : async ?Types.ReportMetrics {
        HashMap.get(metrics, Text.equal, reportId)
    };

    public query func getReportHistory(reportId : Text) : async ?Types.ReportHistory {
        HashMap.get(history, Text.equal, reportId)
    };

    public query func getReportSubmissions(reportId : Text) : async [Types.ReportSubmission] {
        let submissions = HashMap.entries(submissions);
        let filteredSubmissions = Array.filter(submissions, func((id, submission) : (Text, Types.ReportSubmission)) : Bool {
            submission.reportId == reportId
        });
        Array.map(filteredSubmissions, func((id, submission) : (Text, Types.ReportSubmission)) : Types.ReportSubmission { submission })
    };

    public query func getReportCategories(reportId : Text) : async [Types.ReportCategory] {
        switch (HashMap.get(reports, Text.equal, reportId)) {
            case (?report) {
                let categories = Array.map(report.categories, func(categoryId : Text) : ?Types.ReportCategory {
                    HashMap.get(categories, Text.equal, categoryId)
                });
                Array.filterMap(categories, func(category : ?Types.ReportCategory) : ?Types.ReportCategory { category })
            };
            case null []
        }
    };

    public query func getReportAttachments(reportId : Text) : async [Types.Attachment] {
        let attachments = HashMap.entries(attachments);
        let filteredAttachments = Array.filter(attachments, func((id, attachment) : (Text, Types.Attachment)) : Bool {
            attachment.reportId == reportId
        });
        Array.map(filteredAttachments, func((id, attachment) : (Text, Types.Attachment)) : Types.Attachment { attachment })
    };

    public query func getReportComments(reportId : Text) : async [Types.Comment] {
        let comments = HashMap.entries(comments);
        let filteredComments = Array.filter(comments, func((id, comment) : (Text, Types.Comment)) : Bool {
            comment.reportId == reportId
        });
        Array.map(filteredComments, func((id, comment) : (Text, Types.Comment)) : Types.Comment { comment })
    };

    public query func getReportsByStatus(status : Types.ReportStatus) : async [Types.Report] {
        let reports = HashMap.entries(reports);
        let filteredReports = Array.filter(reports, func((id, report) : (Text, Types.Report)) : Bool {
            report.status == status
        });
        Array.map(filteredReports, func((id, report) : (Text, Types.Report)) : Types.Report { report })
    };

    public query func getSubmissionsByStatus(status : Types.ReportSubmissionStatus) : async [Types.ReportSubmission] {
        let submissions = HashMap.entries(submissions);
        let filteredSubmissions = Array.filter(submissions, func((id, submission) : (Text, Types.ReportSubmission)) : Bool {
            submission.status == status
        });
        Array.map(filteredSubmissions, func((id, submission) : (Text, Types.ReportSubmission)) : Types.ReportSubmission { submission })
    };

    public query func getReportsByCategory(categoryId : Text) : async [Types.Report] {
        let reports = HashMap.entries(reports);
        let filteredReports = Array.filter(reports, func((id, report) : (Text, Types.Report)) : Bool {
            Array.contains(report.categories, categoryId, Text.equal)
        });
        Array.map(filteredReports, func((id, report) : (Text, Types.Report)) : Types.Report { report })
    };

    public query func getReportsByTimeRange(startTime : Time.Time, endTime : Time.Time) : async [Types.Report] {
        let reports = HashMap.entries(reports);
        let filteredReports = Array.filter(reports, func((id, report) : (Text, Types.Report)) : Bool {
            report.createdAt >= startTime and report.createdAt <= endTime
        });
        Array.map(filteredReports, func((id, report) : (Text, Types.Report)) : Types.Report { report })
    };

    public query func getSubmissionsByTimeRange(startTime : Time.Time, endTime : Time.Time) : async [Types.ReportSubmission] {
        let submissions = HashMap.entries(submissions);
        let filteredSubmissions = Array.filter(submissions, func((id, submission) : (Text, Types.ReportSubmission)) : Bool {
            submission.createdAt >= startTime and submission.createdAt <= endTime
        });
        Array.map(filteredSubmissions, func((id, submission) : (Text, Types.ReportSubmission)) : Types.ReportSubmission { submission })
    };
}; 