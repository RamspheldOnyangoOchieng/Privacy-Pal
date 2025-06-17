import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Buffer "mo:base/Buffer";
import Debug "mo:base/Debug";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Random "mo:base/Random";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Types "./types";
import Constants "./constants";

actor class MetricsCanister() {
    // State variables
    private var systemMetrics = HashMap.new<Text, Types.SystemMetrics>();
    private var userMetrics = HashMap.new<Text, Types.UserMetrics>();
    private var performanceMetrics = HashMap.new<Text, Types.PerformanceMetrics>();
    private var securityMetrics = HashMap.new<Text, Types.SecurityMetrics>();
    private var usageMetrics = HashMap.new<Text, Types.UsageMetrics>();

    // Helper functions
    private func calculateSystemHealth(metrics : Types.SystemMetrics) : Types.HealthStatus {
        if (metrics.errorRate > 0.1) {
            #Critical
        } else if (metrics.errorRate > 0.05) {
            #Warning
        } else if (metrics.errorRate > 0.01) {
            #Degraded
        } else {
            #Healthy
        }
    };

    private func calculatePerformanceScore(metrics : Types.PerformanceMetrics) : Float {
        let responseTimeScore = 1.0 - (metrics.averageResponseTime / 1000.0);
        let throughputScore = metrics.requestsPerSecond / 100.0;
        let errorRateScore = 1.0 - metrics.errorRate;
        
        (responseTimeScore + throughputScore + errorRateScore) / 3.0
    };

    private func updateSystemMetrics(metric : Types.SystemMetric) {
        let currentMetrics = switch (HashMap.get(systemMetrics, Text.hash(metric.name), metric.name)) {
            case (null) {
                {
                    name = metric.name;
                    value = metric.value;
                    timestamp = Time.now();
                    errorRate = 0.0;
                    healthStatus = #Healthy;
                }
            };
            case (?metrics) { metrics };
        };

        let updatedMetrics = {
            currentMetrics with
            value = metric.value;
            timestamp = Time.now();
            errorRate = calculateErrorRate(metric);
            healthStatus = calculateSystemHealth(currentMetrics);
        };

        HashMap.put(systemMetrics, Text.hash(metric.name), metric.name, updatedMetrics);
    };

    private func calculateErrorRate(metric : Types.SystemMetric) : Float {
        // Implement error rate calculation based on metric type
        0.0
    };

    private func updateUserMetrics(userId : Text, metric : Types.UserMetric) {
        let currentMetrics = switch (HashMap.get(userMetrics, Text.hash(userId), userId)) {
            case (null) {
                {
                    userId = userId;
                    activeSessions = 0;
                    totalSessions = 0;
                    lastActive = Time.now();
                    trustScore = 1.0;
                    riskLevel = #Low;
                }
            };
            case (?metrics) { metrics };
        };

        let updatedMetrics = switch (metric) {
            case (#sessionCreated) {
                {
                    currentMetrics with
                    activeSessions = currentMetrics.activeSessions + 1;
                    totalSessions = currentMetrics.totalSessions + 1;
                    lastActive = Time.now();
                }
            };
            case (#sessionEnded) {
                {
                    currentMetrics with
                    activeSessions = currentMetrics.activeSessions - 1;
                    lastActive = Time.now();
                }
            };
            case (#trustScoreUpdated(score)) {
                {
                    currentMetrics with
                    trustScore = score;
                    lastActive = Time.now();
                }
            };
            case (#riskLevelUpdated(level)) {
                {
                    currentMetrics with
                    riskLevel = level;
                    lastActive = Time.now();
                }
            };
        };

        HashMap.put(userMetrics, Text.hash(userId), userId, updatedMetrics);
    };

    private func updatePerformanceMetrics(metric : Types.PerformanceMetric) {
        let currentMetrics = switch (HashMap.get(performanceMetrics, Text.hash(metric.name), metric.name)) {
            case (null) {
                {
                    name = metric.name;
                    averageResponseTime = 0.0;
                    requestsPerSecond = 0.0;
                    errorRate = 0.0;
                    timestamp = Time.now();
                }
            };
            case (?metrics) { metrics };
        };

        let updatedMetrics = switch (metric) {
            case (#responseTime(time)) {
                {
                    currentMetrics with
                    averageResponseTime = (currentMetrics.averageResponseTime + time) / 2.0;
                    timestamp = Time.now();
                }
            };
            case (#requestCount(count)) {
                {
                    currentMetrics with
                    requestsPerSecond = Float.fromInt(count);
                    timestamp = Time.now();
                }
            };
            case (#errorCount(count)) {
                {
                    currentMetrics with
                    errorRate = Float.fromInt(count) / currentMetrics.requestsPerSecond;
                    timestamp = Time.now();
                }
            };
        };

        HashMap.put(performanceMetrics, Text.hash(metric.name), metric.name, updatedMetrics);
    };

    // Public functions
    public shared(msg) func recordSystemMetric(metric : Types.SystemMetric) : async { #ok; #err : Text } {
        updateSystemMetrics(metric);
        #ok
    };

    public shared(msg) func recordUserMetric(userId : Text, metric : Types.UserMetric) : async { #ok; #err : Text } {
        updateUserMetrics(userId, metric);
        #ok
    };

    public shared(msg) func recordPerformanceMetric(metric : Types.PerformanceMetric) : async { #ok; #err : Text } {
        updatePerformanceMetrics(metric);
        #ok
    };

    public query func getSystemMetrics() : async [Types.SystemMetrics] {
        Iter.toArray(HashMap.vals(systemMetrics))
    };

    public query func getUserMetrics(userId : Text) : async { #ok : Types.UserMetrics; #err : Text } {
        switch (HashMap.get(userMetrics, Text.hash(userId), userId)) {
            case (null) {
                #err("User metrics not found")
            };
            case (?metrics) {
                #ok(metrics)
            };
        }
    };

    public query func getPerformanceMetrics() : async [Types.PerformanceMetrics] {
        Iter.toArray(HashMap.vals(performanceMetrics))
    };

    public query func getSystemHealth() : async Types.HealthStatus {
        let metrics = Iter.toArray(HashMap.vals(systemMetrics));
        let worstHealth = Array.foldLeft<Types.SystemMetrics, Types.HealthStatus>(
            metrics,
            #Healthy,
            func (acc : Types.HealthStatus, metric : Types.SystemMetrics) : Types.HealthStatus {
                switch (acc, metric.healthStatus) {
                    case (#Critical, _) { #Critical };
                    case (_, #Critical) { #Critical };
                    case (#Warning, _) { #Warning };
                    case (_, #Warning) { #Warning };
                    case (#Degraded, _) { #Degraded };
                    case (_, #Degraded) { #Degraded };
                    case (#Healthy, #Healthy) { #Healthy };
                }
            }
        );
        worstHealth
    };

    public query func getPerformanceScore() : async Float {
        let metrics = Iter.toArray(HashMap.vals(performanceMetrics));
        let averageScore = Array.foldLeft<Types.PerformanceMetrics, Float>(
            metrics,
            0.0,
            func (acc : Float, metric : Types.PerformanceMetrics) : Float {
                acc + calculatePerformanceScore(metric)
            }
        ) / Float.fromInt(Array.size(metrics));
        averageScore
    };
}; 