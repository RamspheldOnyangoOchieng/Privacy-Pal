

actor class MetricsCanister {
    // State variables
    private stable var reportMetrics = HashMap.new<Text, Types.ReportMetrics>();
    private stable var globalMetrics = HashMap.new<Text, Nat>();
    private stable var categoryMetrics = HashMap.new<Text, Nat>();
    private stable var timeMetrics = HashMap.new<Text, Nat>();
    private stable var userMetrics = HashMap.new<Text, Nat>();

    // Private helper functions
    private func updateReportMetrics(reportId : Text, metricType : Text, value : Nat) : () {
        let currentMetrics = Option.get(HashMap.get(reportMetrics, Text.equal, reportId), {
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
        HashMap.put(reportMetrics, Text.equal, reportId, updatedMetrics)
    };

    private func updateGlobalMetrics(metricType : Text, value : Nat) : () {
        let currentValue = Option.get(HashMap.get(globalMetrics, Text.equal, metricType), 0);
        HashMap.put(globalMetrics, Text.equal, metricType, currentValue + value)
    };

    private func updateCategoryMetrics(categoryId : Text, value : Nat) : () {
        let currentValue = Option.get(HashMap.get(categoryMetrics, Text.equal, categoryId), 0);
        HashMap.put(categoryMetrics, Text.equal, categoryId, currentValue + value)
    };

    private func updateTimeMetrics(timestamp : Time.Time, value : Nat) : () {
        let timeKey = Nat.toText(timestamp);
        let currentValue = Option.get(HashMap.get(timeMetrics, Text.equal, timeKey), 0);
        HashMap.put(timeMetrics, Text.equal, timeKey, currentValue + value)
    };

    private func updateUserMetrics(userId : Text, value : Nat) : () {
        let currentValue = Option.get(HashMap.get(userMetrics, Text.equal, userId), 0);
        HashMap.put(userMetrics, Text.equal, userId, currentValue + value)
    };

    // Public shared functions
    public shared(msg) func trackReportView(reportId : Text) : async () {
        updateReportMetrics(reportId, "view", 1);
        updateGlobalMetrics("total_views", 1);
        updateTimeMetrics(Time.now(), 1)
    };

    public shared(msg) func trackReportSubmission(reportId : Text) : async () {
        updateReportMetrics(reportId, "submission", 1);
        updateGlobalMetrics("total_submissions", 1);
        updateTimeMetrics(Time.now(), 1)
    };

    public shared(msg) func trackReportAttachment(reportId : Text) : async () {
        updateReportMetrics(reportId, "attachment", 1);
        updateGlobalMetrics("total_attachments", 1);
        updateTimeMetrics(Time.now(), 1)
    };

    public shared(msg) func trackReportComment(reportId : Text) : async () {
        updateReportMetrics(reportId, "comment", 1);
        updateGlobalMetrics("total_comments", 1);
        updateTimeMetrics(Time.now(), 1)
    };

    public shared(msg) func trackCategoryUsage(categoryId : Text) : async () {
        updateCategoryMetrics(categoryId, 1);
        updateGlobalMetrics("total_category_usage", 1);
        updateTimeMetrics(Time.now(), 1)
    };

    public shared(msg) func trackUserActivity(userId : Text) : async () {
        updateUserMetrics(userId, 1);
        updateGlobalMetrics("total_user_activity", 1);
        updateTimeMetrics(Time.now(), 1)
    };

    // Query functions
    public query func getReportMetrics(reportId : Text) : async ?Types.ReportMetrics {
        HashMap.get(reportMetrics, Text.equal, reportId)
    };

    public query func getGlobalMetrics() : async [(Text, Nat)] {
        HashMap.entries(globalMetrics)
    };

    public query func getCategoryMetrics() : async [(Text, Nat)] {
        HashMap.entries(categoryMetrics)
    };

    public query func getTimeMetrics(startTime : Time.Time, endTime : Time.Time) : async [(Text, Nat)] {
        let metrics = HashMap.entries(timeMetrics);
        let filteredMetrics = Array.filter(metrics, func((key, value) : (Text, Nat)) : Bool {
            let timestamp = Nat.fromText(key);
            switch (timestamp) {
                case (?ts) {
                    ts >= startTime and ts <= endTime
                };
                case null false
            }
        });
        filteredMetrics
    };

    public query func getUserMetrics(userId : Text) : async ?Nat {
        HashMap.get(userMetrics, Text.equal, userId)
    };

    public query func getTopReports(limit : Nat) : async [(Text, Types.ReportMetrics)] {
        let metrics = HashMap.entries(reportMetrics);
        let sortedMetrics = Array.sort(metrics, func((_, a) : (Text, Types.ReportMetrics), (_, b) : (Text, Types.ReportMetrics)) : Bool {
            a.views > b.views
        });
        Array.tabulate(limit, func(i : Nat) : (Text, Types.ReportMetrics) {
            sortedMetrics[i]
        })
    };

    public query func getTopCategories(limit : Nat) : async [(Text, Nat)] {
        let metrics = HashMap.entries(categoryMetrics);
        let sortedMetrics = Array.sort(metrics, func((_, a) : (Text, Nat), (_, b) : (Text, Nat)) : Bool {
            a > b
        });
        Array.tabulate(limit, func(i : Nat) : (Text, Nat) {
            sortedMetrics[i]
        })
    };

    public query func getTopUsers(limit : Nat) : async [(Text, Nat)] {
        let metrics = HashMap.entries(userMetrics);
        let sortedMetrics = Array.sort(metrics, func((_, a) : (Text, Nat), (_, b) : (Text, Nat)) : Bool {
            a > b
        });
        Array.tabulate(limit, func(i : Nat) : (Text, Nat) {
            sortedMetrics[i]
        })
    };

    public query func getMetricsByTimeRange(startTime : Time.Time, endTime : Time.Time) : async [(Text, Nat)] {
        let metrics = HashMap.entries(timeMetrics);
        let filteredMetrics = Array.filter(metrics, func((key, value) : (Text, Nat)) : Bool {
            let timestamp = Nat.fromText(key);
            switch (timestamp) {
                case (?ts) {
                    ts >= startTime and ts <= endTime
                };
                case null false
            }
        });
        filteredMetrics
    };

    public query func getMetricsByCategory(categoryId : Text) : async ?Nat {
        HashMap.get(categoryMetrics, Text.equal, categoryId)
    };

    public query func getMetricsByUser(userId : Text) : async ?Nat {
        HashMap.get(userMetrics, Text.equal, userId)
    };

    public query func getMetricsByReport(reportId : Text) : async ?Types.ReportMetrics {
        HashMap.get(reportMetrics, Text.equal, reportId)
    };

    public query func getMetricsByTime(timestamp : Time.Time) : async ?Nat {
        let timeKey = Nat.toText(timestamp);
        HashMap.get(timeMetrics, Text.equal, timeKey)
    };

    public query func getMetricsByType(metricType : Text) : async ?Nat {
        HashMap.get(globalMetrics, Text.equal, metricType)
    };
}; 