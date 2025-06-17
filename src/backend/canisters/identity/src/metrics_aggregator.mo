

actor class MetricsAggregatorCanister() {
    // State variables
    private stable var metrics : HashMap.HashMap<Text, MetricSeries> = HashMap.new();
    private stable var aggregations : HashMap.HashMap<Text, Aggregation> = HashMap.new();
    private stable var alerts : Buffer.Buffer<MetricAlert> = Buffer.Buffer(0);
    private stable var dashboards : HashMap.HashMap<Text, Dashboard> = HashMap.new();

    // Types
    type MetricSeries = {
        id : Text;
        name : Text;
        type : MetricType;
        values : Buffer.Buffer<MetricValue>;
        labels : [Label];
        lastUpdated : Time.Time;
    };

    type MetricType = {
        #COUNTER;
        #GAUGE;
        #HISTOGRAM;
        #SUMMARY;
    };

    type MetricValue = {
        timestamp : Time.Time;
        value : Float;
        labels : [Label];
    };

    type Label = {
        key : Text;
        value : Text;
    };

    type Aggregation = {
        id : Text;
        name : Text;
        metricIds : [Text];
        function : AggregationFunction;
        interval : Nat; // in seconds
        lastRun : Time.Time;
        result : ?Float;
    };

    type AggregationFunction = {
        #SUM;
        #AVERAGE;
        #MIN;
        #MAX;
        #COUNT;
        #PERCENTILE;
    };

    type MetricAlert = {
        id : Text;
        name : Text;
        metricId : Text;
        condition : AlertCondition;
        threshold : Float;
        severity : AlertSeverity;
        status : AlertStatus;
        lastTriggered : ?Time.Time;
    };

    type AlertCondition = {
        #GREATER_THAN;
        #LESS_THAN;
        #EQUALS;
        #NOT_EQUALS;
    };

    type AlertSeverity = {
        #LOW;
        #MEDIUM;
        #HIGH;
        #CRITICAL;
    };

    type AlertStatus = {
        #ACTIVE;
        #TRIGGERED;
        #RESOLVED;
    };

    type Dashboard = {
        id : Text;
        name : Text;
        widgets : [Widget];
        layout : Layout;
        lastUpdated : Time.Time;
    };

    type Widget = {
        id : Text;
        type : WidgetType;
        metricId : Text;
        title : Text;
        config : WidgetConfig;
    };

    type WidgetType = {
        #LINE_CHART;
        #BAR_CHART;
        #GAUGE;
        #STAT;
        #TABLE;
    };

    type WidgetConfig = {
        timeRange : TimeRange;
        aggregation : ?AggregationFunction;
        thresholds : ?[Threshold];
    };

    type TimeRange = {
        start : Time.Time;
        end : Time.Time;
    };

    type Threshold = {
        value : Float;
        color : Text;
    };

    type Layout = {
        rows : Nat;
        columns : Nat;
        positions : [(Text, Position)];
    };

    type Position = {
        row : Nat;
        column : Nat;
        width : Nat;
        height : Nat;
    };

    // Private helper functions
    private func generateMetricId() : Text {
        "metric-" # Nat.toText(Time.now());
    };

    private func calculateAggregation(aggregation : Aggregation) : Float {
        var result : Float = 0;
        var count : Nat = 0;

        for (metricId in aggregation.metricIds.vals()) {
            switch (HashMap.get(metrics, Principal.equal, Principal.hash, metricId)) {
                case (?series) {
                    for (value in Buffer.vals(series.values)) {
                        switch (aggregation.function) {
                            case (#SUM) {
                                result += value.value;
                            };
                            case (#AVERAGE) {
                                result += value.value;
                                count += 1;
                            };
                            case (#MIN) {
                                if (count == 0 or value.value < result) {
                                    result := value.value;
                                };
                            };
                            case (#MAX) {
                                if (count == 0 or value.value > result) {
                                    result := value.value;
                                };
                            };
                            case (#COUNT) {
                                count += 1;
                            };
                            case (#PERCENTILE) {
                                // Implement percentile calculation
                            };
                        };
                    };
                };
                case null {};
            };
        };

        switch (aggregation.function) {
            case (#AVERAGE) {
                if (count > 0) {
                    result / Float.fromInt(count);
                } else {
                    0;
                };
            };
            case (#COUNT) {
                Float.fromInt(count);
            };
            case _ {
                result;
            };
        };
    };

    private func checkAlerts(metricId : Text, value : Float) {
        for ((_, alert) in HashMap.entries(aggregations)) {
            if (alert.metricId == metricId) {
                let triggered = switch (alert.condition) {
                    case (#GREATER_THAN) { value > alert.threshold };
                    case (#LESS_THAN) { value < alert.threshold };
                    case (#EQUALS) { value == alert.threshold };
                    case (#NOT_EQUALS) { value != alert.threshold };
                };

                if (triggered) {
                    let updatedAlert = {
                        alert with
                        status = #TRIGGERED;
                        lastTriggered = ?Time.now();
                    };
                    Buffer.add(alerts, updatedAlert);
                };
            };
        };
    };

    // Public shared functions
    public shared(msg) func recordMetric(metricId : Text, value : Float, labels : [Label]) : async () {
        switch (HashMap.get(metrics, Principal.equal, Principal.hash, metricId)) {
            case (?series) {
                let metricValue = {
                    timestamp = Time.now();
                    value = value;
                    labels = labels;
                };
                Buffer.add(series.values, metricValue);
                checkAlerts(metricId, value);
            };
            case null {
                let newSeries = {
                    id = metricId;
                    name = metricId;
                    type = #GAUGE;
                    values = Buffer.Buffer<MetricValue>(0);
                    labels = labels;
                    lastUpdated = Time.now();
                };
                ignore HashMap.put(metrics, Principal.equal, Principal.hash, metricId, newSeries);
            };
        };
    };

    public shared(msg) func createAggregation(aggregation : Aggregation) : async () {
        ignore HashMap.put(aggregations, Principal.equal, Principal.hash, aggregation.id, aggregation);
    };

    public shared(msg) func createAlert(alert : MetricAlert) : async () {
        Buffer.add(alerts, alert);
    };

    public shared(msg) func createDashboard(dashboard : Dashboard) : async () {
        ignore HashMap.put(dashboards, Principal.equal, Principal.hash, dashboard.id, dashboard);
    };

    public query func getMetricValues(metricId : Text, startTime : Time.Time, endTime : Time.Time) : async [MetricValue] {
        switch (HashMap.get(metrics, Principal.equal, Principal.hash, metricId)) {
            case (?series) {
                let filtered = Buffer.Buffer<MetricValue>(0);
                for (value in Buffer.vals(series.values)) {
                    if (value.timestamp >= startTime and value.timestamp <= endTime) {
                        Buffer.add(filtered, value);
                    };
                };
                Buffer.toArray(filtered);
            };
            case null {
                [];
            };
        };
    };

    public query func getAggregationResult(aggregationId : Text) : async ?Float {
        switch (HashMap.get(aggregations, Principal.equal, Principal.hash, aggregationId)) {
            case (?aggregation) {
                ?calculateAggregation(aggregation);
            };
            case null {
                null;
            };
        };
    };

    public query func getActiveAlerts() : async [MetricAlert] {
        let active = Buffer.Buffer<MetricAlert>(0);
        for (alert in Buffer.vals(alerts)) {
            if (alert.status == #ACTIVE or alert.status == #TRIGGERED) {
                Buffer.add(active, alert);
            };
        };
        Buffer.toArray(active);
    };

    public query func getDashboard(dashboardId : Text) : async ?Dashboard {
        HashMap.get(dashboards, Principal.equal, Principal.hash, dashboardId);
    };
}; 