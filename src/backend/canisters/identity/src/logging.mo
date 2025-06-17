

actor class LoggingCanister() {
    // State variables
    private stable var logs : Buffer.Buffer<LogEntry> = Buffer.Buffer(0);
    private stable var logFilters : HashMap.HashMap<Text, LogFilter> = HashMap.new();
    private stable var logMetrics : HashMap.HashMap<Text, LogMetrics> = HashMap.new();
    private stable var logRetention : HashMap.HashMap<Text, LogRetention> = HashMap.new();
    private stable var logAnalytics : HashMap.HashMap<Text, LogAnalytics> = HashMap.new();

    // Types
    type LogEntry = {
        id : Text;
        timestamp : Time.Time;
        level : LogLevel;
        source : Text;
        message : Text;
        metadata : [Metadata];
        traceId : ?Text;
        spanId : ?Text;
    };

    type LogLevel = {
        #DEBUG;
        #INFO;
        #WARNING;
        #ERROR;
        #CRITICAL;
    };

    type Metadata = {
        key : Text;
        value : Text;
    };

    type LogFilter = {
        id : Text;
        name : Text;
        conditions : [FilterCondition];
        enabled : Bool;
        action : FilterAction;
    };

    type FilterCondition = {
        field : Text;
        operator : Operator;
        value : Text;
    };

    type Operator = {
        #EQUALS;
        #NOT_EQUALS;
        #CONTAINS;
        #REGEX_MATCH;
        #GREATER_THAN;
        #LESS_THAN;
    };

    type FilterAction = {
        #KEEP;
        #DROP;
        #TRANSFORM;
    };

    type LogMetrics = {
        totalLogs : Nat;
        logsByLevel : HashMap.HashMap<LogLevel, Nat>;
        averageLogSize : Nat;
        lastUpdated : Time.Time;
    };

    type LogRetention = {
        id : Text;
        level : LogLevel;
        duration : Nat; // in seconds
        maxSize : Nat;
        compression : Bool;
    };

    type LogAnalytics = {
        id : Text;
        name : Text;
        query : Text;
        results : [AnalyticsResult];
        lastRun : Time.Time;
    };

    type AnalyticsResult = {
        timestamp : Time.Time;
        value : Float;
        metadata : [Metadata];
    };

    // Private helper functions
    private func generateLogId() : Text {
        "log-" # Nat.toText(Time.now());
    };

    private func applyFilters(entry : LogEntry) : Bool {
        var shouldKeep = true;
        for ((_, filter) in HashMap.entries(logFilters)) {
            if (filter.enabled) {
                for (condition in filter.conditions.vals()) {
                    let fieldValue = switch (condition.field) {
                        case ("level") { debug_show(entry.level) };
                        case ("source") { entry.source };
                        case ("message") { entry.message };
                        case _ { "" };
                    };

                    let matches = switch (condition.operator) {
                        case (#EQUALS) { fieldValue == condition.value };
                        case (#NOT_EQUALS) { fieldValue != condition.value };
                        case (#CONTAINS) { Text.contains(fieldValue, #text condition.value) };
                        case (#REGEX_MATCH) { Text.contains(fieldValue, #text condition.value) };
                        case (#GREATER_THAN) { Nat.greater(Nat.fromText(fieldValue), Nat.fromText(condition.value)) };
                        case (#LESS_THAN) { Nat.less(Nat.fromText(fieldValue), Nat.fromText(condition.value)) };
                    };

                    if (not matches) {
                        shouldKeep := false;
                    };
                };
            };
        };
        shouldKeep;
    };

    private func updateMetrics(entry : LogEntry) {
        let metrics = Option.get(HashMap.get(logMetrics, Principal.equal, Principal.hash, entry.source), {
            totalLogs = 0;
            logsByLevel = HashMap.new();
            averageLogSize = 0;
            lastUpdated = Time.now();
        });

        let levelCount = Option.get(HashMap.get(metrics.logsByLevel, LogLevel.equal, LogLevel.hash, entry.level), 0);
        ignore HashMap.put(metrics.logsByLevel, LogLevel.equal, LogLevel.hash, entry.level, levelCount + 1);

        let updatedMetrics = {
            metrics with
            totalLogs = metrics.totalLogs + 1;
            averageLogSize = (metrics.averageLogSize + entry.message.size()) / 2;
            lastUpdated = Time.now();
        };

        ignore HashMap.put(logMetrics, Principal.equal, Principal.hash, entry.source, updatedMetrics);
    };

    private func applyRetention() {
        let now = Time.now();
        let retainedLogs = Buffer.Buffer<LogEntry>(0);

        for (entry in Buffer.vals(logs)) {
            switch (HashMap.get(logRetention, Principal.equal, Principal.hash, debug_show(entry.level))) {
                case (?retention) {
                    if (now - entry.timestamp < retention.duration * 1_000_000_000) {
                        Buffer.add(retainedLogs, entry);
                    };
                };
                case null {
                    Buffer.add(retainedLogs, entry);
                };
            };
        };

        Buffer.clear(logs);
        for (entry in Buffer.vals(retainedLogs)) {
            Buffer.add(logs, entry);
        };
    };

    // Public shared functions
    public shared(msg) func log(level : LogLevel, source : Text, message : Text, metadata : [Metadata], traceId : ?Text, spanId : ?Text) : async Text {
        let entry = {
            id = generateLogId();
            timestamp = Time.now();
            level = level;
            source = source;
            message = message;
            metadata = metadata;
            traceId = traceId;
            spanId = spanId;
        };

        if (applyFilters(entry)) {
            Buffer.add(logs, entry);
            updateMetrics(entry);
        };

        entry.id;
    };

    public shared(msg) func setLogFilter(filter : LogFilter) : async () {
        ignore HashMap.put(logFilters, Principal.equal, Principal.hash, filter.id, filter);
    };

    public shared(msg) func setLogRetention(retention : LogRetention) : async () {
        ignore HashMap.put(logRetention, Principal.equal, Principal.hash, debug_show(retention.level), retention);
    };

    public shared(msg) func runLogAnalytics(analytics : LogAnalytics) : async () {
        // Implement log analytics
        ignore HashMap.put(logAnalytics, Principal.equal, Principal.hash, analytics.id, analytics);
    };

    public query func getLogs(filter : ?LogFilter) : async [LogEntry] {
        switch (filter) {
            case (?f) {
                let filtered = Buffer.Buffer<LogEntry>(0);
                for (entry in Buffer.vals(logs)) {
                    if (applyFilters(entry)) {
                        Buffer.add(filtered, entry);
                    };
                };
                Buffer.toArray(filtered);
            };
            case null {
                Buffer.toArray(logs);
            };
        };
    };

    public query func getLogMetrics(source : Text) : async ?LogMetrics {
        HashMap.get(logMetrics, Principal.equal, Principal.hash, source);
    };

    public query func getLogAnalytics(analyticsId : Text) : async ?LogAnalytics {
        HashMap.get(logAnalytics, Principal.equal, Principal.hash, analyticsId);
    };
}; 