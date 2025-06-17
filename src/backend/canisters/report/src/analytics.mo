

actor class AnalyticsCanister {
    // State variables
    private stable var reportMetrics = HashMap.new<Text, Types.ReportMetrics>();
    private stable var userMetrics = HashMap.new<Text, Types.UserMetrics>();
    private stable var categoryMetrics = HashMap.new<Text, Types.CategoryMetrics>();
    private stable var timeMetrics = HashMap.new<Text, Types.TimeMetrics>();
    private stable var trendMetrics = HashMap.new<Text, Types.TrendMetrics>();
    private stable var analyticsHistory = HashMap.new<Text, Types.AnalyticsHistory>();

    // Private helper functions
    private func generateAnalyticsId() : Text {
        "analytics_" # Nat.toText(Time.now())
    };

    private func updateReportMetrics(report : Types.Report) : () {
        let metrics = switch (HashMap.get(reportMetrics, Text.equal, report.id)) {
            case (?m) { m };
            case null {
                {
                    reportId = report.id;
                    views = 0;
                    submissions = 0;
                    comments = 0;
                    attachments = 0;
                    statusChanges = 0;
                    lastUpdated = Time.now()
                }
            }
        };
        HashMap.put(reportMetrics, Text.equal, report.id, metrics)
    };

    private func updateUserMetrics(userId : Text, action : Types.AnalyticsAction) : () {
        let metrics = switch (HashMap.get(userMetrics, Text.equal, userId)) {
            case (?m) { m };
            case null {
                {
                    userId = userId;
                    reportsCreated = 0;
                    reportsViewed = 0;
                    submissionsMade = 0;
                    commentsPosted = 0;
                    attachmentsUploaded = 0;
                    lastActive = Time.now()
                }
            }
        };
        let updatedMetrics = switch (action) {
            case (#reportCreated) { { metrics with reportsCreated = metrics.reportsCreated + 1 } };
            case (#reportViewed) { { metrics with reportsViewed = metrics.reportsViewed + 1 } };
            case (#submissionMade) { { metrics with submissionsMade = metrics.submissionsMade + 1 } };
            case (#commentPosted) { { metrics with commentsPosted = metrics.commentsPosted + 1 } };
            case (#attachmentUploaded) { { metrics with attachmentsUploaded = metrics.attachmentsUploaded + 1 } }
        };
        HashMap.put(userMetrics, Text.equal, userId, updatedMetrics)
    };

    private func updateCategoryMetrics(category : Types.ReportCategory) : () {
        let metrics = switch (HashMap.get(categoryMetrics, Text.equal, category.id)) {
            case (?m) { m };
            case null {
                {
                    categoryId = category.id;
                    reportCount = 0;
                    submissionCount = 0;
                    commentCount = 0;
                    attachmentCount = 0;
                    lastUpdated = Time.now()
                }
            }
        };
        HashMap.put(categoryMetrics, Text.equal, category.id, metrics)
    };

    private func updateTimeMetrics(timestamp : Time.Time) : () {
        let timeKey = Nat.toText(timestamp / Constants.ONE_HOUR);
        let metrics = switch (HashMap.get(timeMetrics, Text.equal, timeKey)) {
            case (?m) { m };
            case null {
                {
                    timeKey = timeKey;
                    reportCount = 0;
                    submissionCount = 0;
                    commentCount = 0;
                    attachmentCount = 0;
                    userCount = 0
                }
            }
        };
        HashMap.put(timeMetrics, Text.equal, timeKey, metrics)
    };

    private func updateTrendMetrics(metric : Text, value : Nat) : () {
        let metrics = switch (HashMap.get(trendMetrics, Text.equal, metric)) {
            case (?m) { m };
            case null {
                {
                    metric = metric;
                    values = [];
                    timestamps = [];
                    lastUpdated = Time.now()
                }
            }
        };
        let updatedMetrics = {
            metric = metrics.metric;
            values = Array.append(metrics.values, [value]);
            timestamps = Array.append(metrics.timestamps, [Time.now()]);
            lastUpdated = Time.now()
        };
        HashMap.put(trendMetrics, Text.equal, metric, updatedMetrics)
    };

    // Public shared functions
    public shared(msg) func trackReportView(reportId : Text) : async Result.Result<(), Text> {
        switch (HashMap.get(reportMetrics, Text.equal, reportId)) {
            case (?metrics) {
                let updatedMetrics = {
                    metrics with
                    views = metrics.views + 1;
                    lastUpdated = Time.now()
                };
                HashMap.put(reportMetrics, Text.equal, reportId, updatedMetrics);
                updateUserMetrics(Principal.toText(msg.caller), #reportViewed);
                updateTimeMetrics(Time.now());
                updateTrendMetrics("report_views", updatedMetrics.views);
                #ok()
            };
            case null { #err(Constants.ERROR_REPORT_NOT_FOUND) }
        }
    };

    public shared(msg) func trackReportSubmission(reportId : Text, submissionId : Text) : async Result.Result<(), Text> {
        switch (HashMap.get(reportMetrics, Text.equal, reportId)) {
            case (?metrics) {
                let updatedMetrics = {
                    metrics with
                    submissions = metrics.submissions + 1;
                    lastUpdated = Time.now()
                };
                HashMap.put(reportMetrics, Text.equal, reportId, updatedMetrics);
                updateUserMetrics(Principal.toText(msg.caller), #submissionMade);
                updateTimeMetrics(Time.now());
                updateTrendMetrics("report_submissions", updatedMetrics.submissions);
                #ok()
            };
            case null { #err(Constants.ERROR_REPORT_NOT_FOUND) }
        }
    };

    public shared(msg) func trackComment(reportId : Text, commentId : Text) : async Result.Result<(), Text> {
        switch (HashMap.get(reportMetrics, Text.equal, reportId)) {
            case (?metrics) {
                let updatedMetrics = {
                    metrics with
                    comments = metrics.comments + 1;
                    lastUpdated = Time.now()
                };
                HashMap.put(reportMetrics, Text.equal, reportId, updatedMetrics);
                updateUserMetrics(Principal.toText(msg.caller), #commentPosted);
                updateTimeMetrics(Time.now());
                updateTrendMetrics("report_comments", updatedMetrics.comments);
                #ok()
            };
            case null { #err(Constants.ERROR_REPORT_NOT_FOUND) }
        }
    };

    public shared(msg) func trackAttachment(reportId : Text, attachmentId : Text) : async Result.Result<(), Text> {
        switch (HashMap.get(reportMetrics, Text.equal, reportId)) {
            case (?metrics) {
                let updatedMetrics = {
                    metrics with
                    attachments = metrics.attachments + 1;
                    lastUpdated = Time.now()
                };
                HashMap.put(reportMetrics, Text.equal, reportId, updatedMetrics);
                updateUserMetrics(Principal.toText(msg.caller), #attachmentUploaded);
                updateTimeMetrics(Time.now());
                updateTrendMetrics("report_attachments", updatedMetrics.attachments);
                #ok()
            };
            case null { #err(Constants.ERROR_REPORT_NOT_FOUND) }
        }
    };

    // Query functions
    public query func getReportMetrics(reportId : Text) : async ?Types.ReportMetrics {
        HashMap.get(reportMetrics, Text.equal, reportId)
    };

    public query func getUserMetrics(userId : Text) : async ?Types.UserMetrics {
        HashMap.get(userMetrics, Text.equal, userId)
    };

    public query func getCategoryMetrics(categoryId : Text) : async ?Types.CategoryMetrics {
        HashMap.get(categoryMetrics, Text.equal, categoryId)
    };

    public query func getTimeMetrics(timeKey : Text) : async ?Types.TimeMetrics {
        HashMap.get(timeMetrics, Text.equal, timeKey)
    };

    public query func getTrendMetrics(metric : Text) : async ?Types.TrendMetrics {
        HashMap.get(trendMetrics, Text.equal, metric)
    };

    public query func getAnalyticsHistory() : async [Types.AnalyticsHistory] {
        let history = HashMap.entries(analyticsHistory);
        Array.map(history, func((id, h) : (Text, Types.AnalyticsHistory)) : Types.AnalyticsHistory { h })
    };

    public query func getAnalyticsHistoryByTimeRange(startTime : Time.Time, endTime : Time.Time) : async [Types.AnalyticsHistory] {
        let history = HashMap.entries(analyticsHistory);
        let filteredHistory = Array.filter(history, func((id, h) : (Text, Types.AnalyticsHistory)) : Bool {
            h.timestamp >= startTime and h.timestamp <= endTime
        });
        Array.map(filteredHistory, func((id, h) : (Text, Types.AnalyticsHistory)) : Types.AnalyticsHistory { h })
    };

    public query func getAnalyticsHistoryByMetric(metric : Text) : async [Types.AnalyticsHistory] {
        let history = HashMap.entries(analyticsHistory);
        let filteredHistory = Array.filter(history, func((id, h) : (Text, Types.AnalyticsHistory)) : Bool {
            h.metric == metric
        });
        Array.map(filteredHistory, func((id, h) : (Text, Types.AnalyticsHistory)) : Types.AnalyticsHistory { h })
    };

    public query func getAnalyticsHistoryByUser(userId : Text) : async [Types.AnalyticsHistory] {
        let history = HashMap.entries(analyticsHistory);
        let filteredHistory = Array.filter(history, func((id, h) : (Text, Types.AnalyticsHistory)) : Bool {
            h.userId == userId
        });
        Array.map(filteredHistory, func((id, h) : (Text, Types.AnalyticsHistory)) : Types.AnalyticsHistory { h })
    };
}; 