

actor class MonitoringCanister() {
    // State variables
    private stable var systemMetrics : HashMap.HashMap<Text, SystemMetric> = HashMap.new();
    private stable var performanceMetrics : HashMap.HashMap<Text, PerformanceMetric> = HashMap.new();
    private stable var resourceUsage : HashMap.HashMap<Text, ResourceUsage> = HashMap.new();
    private stable var healthChecks : HashMap.HashMap<Text, HealthCheck> = HashMap.new();
    private stable var alerts : Buffer.Buffer<Alert> = Buffer.Buffer(0);
    private stable var thresholds : HashMap.HashMap<Text, Threshold> = HashMap.new();

    // Types
    type SystemMetric = {
        id : Text;
        name : Text;
        value : Float;
        unit : Text;
        timestamp : Time.Time;
        category : MetricCategory;
    };

    type MetricCategory = {
        #CPU;
        #MEMORY;
        #STORAGE;
        #NETWORK;
        #CUSTOM;
    };

    type PerformanceMetric = {
        id : Text;
        name : Text;
        value : Float;
        unit : Text;
        timestamp : Time.Time;
        percentile : Nat;
        min : Float;
        max : Float;
        avg : Float;
    };

    type ResourceUsage = {
        id : Text;
        name : Text;
        current : Float;
        limit : Float;
        unit : Text;
        timestamp : Time.Time;
        trend : Trend;
    };

    type Trend = {
        #INCREASING;
        #DECREASING;
        #STABLE;
        #FLUCTUATING;
    };

    type HealthCheck = {
        id : Text;
        name : Text;
        status : HealthStatus;
        lastCheck : Time.Time;
        nextCheck : Time.Time;
        details : Text;
    };

    type HealthStatus = {
        #HEALTHY;
        #DEGRADED;
        #UNHEALTHY;
        #UNKNOWN;
    };

    type Alert = {
        id : Text;
        type : AlertType;
        severity : Severity;
        message : Text;
        timestamp : Time.Time;
        source : Text;
        status : AlertStatus;
    };

    type AlertType = {
        #THRESHOLD;
        #ANOMALY;
        #ERROR;
        #WARNING;
    };

    type Severity = {
        #LOW;
        #MEDIUM;
        #HIGH;
        #CRITICAL;
    };

    type AlertStatus = {
        #ACTIVE;
        #ACKNOWLEDGED;
        #RESOLVED;
    };

    type Threshold = {
        id : Text;
        metric : Text;
        operator : Operator;
        value : Float;
        severity : Severity;
        enabled : Bool;
    };

    type Operator = {
        #GREATER_THAN;
        #LESS_THAN;
        #EQUALS;
        #NOT_EQUALS;
    };

    // Private helper functions
    private func generateMetricId() : Text {
        "metric-" # Nat.toText(Time.now());
    };

    private func checkThresholds(metric : SystemMetric) {
        for ((_, threshold) in HashMap.entries(thresholds)) {
            if (threshold.enabled and threshold.metric == metric.name) {
                let triggered = switch (threshold.operator) {
                    case (#GREATER_THAN) { metric.value > threshold.value };
                    case (#LESS_THAN) { metric.value < threshold.value };
                    case (#EQUALS) { metric.value == threshold.value };
                    case (#NOT_EQUALS) { metric.value != threshold.value };
                };

                if (triggered) {
                    let alert = {
                        id = "alert-" # Nat.toText(Time.now());
                        type = #THRESHOLD;
                        severity = threshold.severity;
                        message = "Threshold exceeded for metric: " # metric.name;
                        timestamp = Time.now();
                        source = metric.id;
                        status = #ACTIVE;
                    };
                    Buffer.add(alerts, alert);
                };
            };
        };
    };

    private func calculateTrend(history : [Float]) : Trend {
        if (history.size() < 2) {
            return #STABLE;
        };

        var increasing = 0;
        var decreasing = 0;
        var stable = 0;

        for (i in Iter.range(1, history.size() - 1)) {
            if (history[i] > history[i - 1]) {
                increasing += 1;
            } else if (history[i] < history[i - 1]) {
                decreasing += 1;
            } else {
                stable += 1;
            };
        };

        if (increasing > decreasing and increasing > stable) {
            #INCREASING;
        } else if (decreasing > increasing and decreasing > stable) {
            #DECREASING;
        } else if (stable > increasing and stable > decreasing) {
            #STABLE;
        } else {
            #FLUCTUATING;
        };
    };

    // Public shared functions
    public shared(msg) func recordSystemMetric(metric : SystemMetric) : async () {
        ignore HashMap.put(systemMetrics, Principal.equal, Principal.hash, metric.id, metric);
        checkThresholds(metric);
    };

    public shared(msg) func recordPerformanceMetric(metric : PerformanceMetric) : async () {
        ignore HashMap.put(performanceMetrics, Principal.equal, Principal.hash, metric.id, metric);
    };

    public shared(msg) func updateResourceUsage(usage : ResourceUsage) : async () {
        ignore HashMap.put(resourceUsage, Principal.equal, Principal.hash, usage.id, usage);
    };

    public shared(msg) func setHealthCheck(check : HealthCheck) : async () {
        ignore HashMap.put(healthChecks, Principal.equal, Principal.hash, check.id, check);
    };

    public shared(msg) func setThreshold(threshold : Threshold) : async () {
        ignore HashMap.put(thresholds, Principal.equal, Principal.hash, threshold.id, threshold);
    };

    public shared(msg) func acknowledgeAlert(alertId : Text) : async () {
        for (i in Iter.range(0, Buffer.size(alerts) - 1)) {
            let alert = Buffer.get(alerts, i);
            if (alert.id == alertId) {
                let updatedAlert = {
                    alert with
                    status = #ACKNOWLEDGED;
                };
                Buffer.put(alerts, i, updatedAlert);
            };
        };
    };

    public query func getSystemMetrics(category : MetricCategory) : async [SystemMetric] {
        let filtered = Buffer.Buffer<SystemMetric>(0);
        for ((_, metric) in HashMap.entries(systemMetrics)) {
            if (metric.category == category) {
                Buffer.add(filtered, metric);
            };
        };
        Buffer.toArray(filtered);
    };

    public query func getPerformanceMetrics(name : Text) : async [PerformanceMetric] {
        let filtered = Buffer.Buffer<PerformanceMetric>(0);
        for ((_, metric) in HashMap.entries(performanceMetrics)) {
            if (metric.name == name) {
                Buffer.add(filtered, metric);
            };
        };
        Buffer.toArray(filtered);
    };

    public query func getResourceUsage(name : Text) : async ?ResourceUsage {
        for ((_, usage) in HashMap.entries(resourceUsage)) {
            if (usage.name == name) {
                return ?usage;
            };
        };
        null;
    };

    public query func getHealthChecks() : async [HealthCheck] {
        Iter.toArray(HashMap.vals(healthChecks));
    };

    public query func getActiveAlerts() : async [Alert] {
        let active = Buffer.Buffer<Alert>(0);
        for (alert in Buffer.vals(alerts)) {
            if (alert.status == #ACTIVE) {
                Buffer.add(active, alert);
            };
        };
        Buffer.toArray(active);
    };
}; 