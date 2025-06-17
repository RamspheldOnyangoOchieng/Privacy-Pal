import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Time "mo:base/Time";
import Principal "mo:base/Principal";
import Array "mo:base/Array";
import List "mo:base/List";
import Option "mo:base/Option";
import Result "mo:base/Result";
import Error "mo:base/Error";
import Debug "mo:base/Debug";
import Types "../types";
import Utils "../utils";
import Constants "../constants";

actor class NotificationCanister {
    // State variables
    private stable var notifications = HashMap.new<Text, Types.Notification>();
    private stable var alerts = HashMap.new<Text, Types.Alert>();
    private stable var channels = HashMap.new<Text, Types.Channel>();
    private stable var preferences = HashMap.new<Principal, Types.NotificationPreferences>();
    private stable var metrics = HashMap.new<Text, Types.NotificationMetrics>();
    private stable var history = HashMap.new<Text, Types.NotificationHistory>();

    // Private helper functions
    private func generateNotificationId() : Text {
        "notification_" # Nat.toText(Time.now())
    };

    private func generateAlertId() : Text {
        "alert_" # Nat.toText(Time.now())
    };

    private func generateChannelId() : Text {
        "channel_" # Nat.toText(Time.now())
    };

    private func validateNotification(notification : Types.Notification) : Result.Result<(), Text> {
        if (Utils.isEmpty(notification.title)) {
            #err("Notification title cannot be empty")
        } else if (Utils.isEmpty(notification.content)) {
            #err("Notification content cannot be empty")
        } else if (notification.priority < 0 or notification.priority > 10) {
            #err("Notification priority must be between 0 and 10")
        } else {
            #ok()
        }
    };

    private func validateAlert(alert : Types.Alert) : Result.Result<(), Text> {
        if (Utils.isEmpty(alert.title)) {
            #err("Alert title cannot be empty")
        } else if (Utils.isEmpty(alert.content)) {
            #err("Alert content cannot be empty")
        } else if (alert.priority < 0 or alert.priority > 10) {
            #err("Alert priority must be between 0 and 10")
        } else {
            #ok()
        }
    };

    private func validateChannel(channel : Types.Channel) : Result.Result<(), Text> {
        if (Utils.isEmpty(channel.name)) {
            #err("Channel name cannot be empty")
        } else if (Utils.isEmpty(channel.type)) {
            #err("Channel type cannot be empty")
        } else if (Utils.isEmpty(channel.config)) {
            #err("Channel config cannot be empty")
        } else {
            #ok()
        }
    };

    private func validatePreferences(preferences : Types.NotificationPreferences) : Result.Result<(), Text> {
        if (Array.size(preferences.channels) == 0) {
            #err("Preferences must have at least one channel")
        } else {
            #ok()
        }
    };

    private func updateNotificationMetrics(notificationId : Text, metricType : Text, value : Nat) : () {
        let currentMetrics = Option.get(HashMap.get(metrics, Text.equal, notificationId), {
            sent = 0;
            delivered = 0;
            read = 0;
            lastUpdated = Time.now()
        });
        let updatedMetrics = {
            currentMetrics with
            sent = currentMetrics.sent + value;
            lastUpdated = Time.now()
        };
        HashMap.put(metrics, Text.equal, notificationId, updatedMetrics)
    };

    private func updateNotificationHistory(notificationId : Text, action : Text, channelId : Text) : () {
        let currentHistory = Option.get(HashMap.get(history, Text.equal, notificationId), {
            actions = [];
            lastUpdated = Time.now()
        });
        let newAction = {
            action = action;
            channelId = channelId;
            timestamp = Time.now()
        };
        let updatedHistory = {
            currentHistory with
            actions = Array.append(currentHistory.actions, [newAction]);
            lastUpdated = Time.now()
        };
        HashMap.put(history, Text.equal, notificationId, updatedHistory)
    };

    private func deliverNotification(notification : Types.Notification, channel : Types.Channel) : Result.Result<(), Text> {
        switch (channel.type) {
            case ("email") {
                // Implement email delivery
                #ok()
            };
            case ("sms") {
                // Implement SMS delivery
                #ok()
            };
            case ("push") {
                // Implement push notification delivery
                #ok()
            };
            case ("in-app") {
                // Implement in-app notification delivery
                #ok()
            };
            case ("webhook") {
                // Implement webhook delivery
                #ok()
            };
            case (_) #err("Unsupported channel type")
        }
    };

    // Public shared functions
    public shared(msg) func createNotification(notification : Types.Notification) : async Result.Result<Text, Text> {
        switch (validateNotification(notification)) {
            case (#ok()) {
                let notificationId = generateNotificationId();
                let newNotification = {
                    notification with
                    id = notificationId;
                    status = #pending;
                    createdBy = msg.caller;
                    createdAt = Time.now();
                    updatedAt = Time.now()
                };
                HashMap.put(notifications, Text.equal, notificationId, newNotification);
                updateNotificationMetrics(notificationId, "created", 1);
                updateNotificationHistory(notificationId, "created", "");
                #ok(notificationId)
            };
            case (#err(msg)) #err(msg)
        }
    };

    public shared(msg) func createAlert(alert : Types.Alert) : async Result.Result<Text, Text> {
        switch (validateAlert(alert)) {
            case (#ok()) {
                let alertId = generateAlertId();
                let newAlert = {
                    alert with
                    id = alertId;
                    status = #pending;
                    createdBy = msg.caller;
                    createdAt = Time.now();
                    updatedAt = Time.now()
                };
                HashMap.put(alerts, Text.equal, alertId, newAlert);
                #ok(alertId)
            };
            case (#err(msg)) #err(msg)
        }
    };

    public shared(msg) func createChannel(channel : Types.Channel) : async Result.Result<Text, Text> {
        switch (validateChannel(channel)) {
            case (#ok()) {
                let channelId = generateChannelId();
                let newChannel = {
                    channel with
                    id = channelId;
                    status = #active;
                    createdBy = msg.caller;
                    createdAt = Time.now();
                    updatedAt = Time.now()
                };
                HashMap.put(channels, Text.equal, channelId, newChannel);
                #ok(channelId)
            };
            case (#err(msg)) #err(msg)
        }
    };

    public shared(msg) func setPreferences(preferences : Types.NotificationPreferences) : async Result.Result<(), Text> {
        switch (validatePreferences(preferences)) {
            case (#ok()) {
                let updatedPreferences = {
                    preferences with
                    updatedAt = Time.now()
                };
                HashMap.put(preferences, Principal.equal, msg.caller, updatedPreferences);
                #ok()
            };
            case (#err(msg)) #err(msg)
        }
    };

    public shared(msg) func sendNotification(notificationId : Text, channelId : Text) : async Result.Result<(), Text> {
        switch (HashMap.get(notifications, Text.equal, notificationId)) {
            case (?notification) {
                switch (HashMap.get(channels, Text.equal, channelId)) {
                    case (?channel) {
                        switch (deliverNotification(notification, channel)) {
                            case (#ok()) {
                                let updatedNotification = {
                                    notification with
                                    status = #sent;
                                    sentAt = Time.now();
                                    updatedAt = Time.now()
                                };
                                HashMap.put(notifications, Text.equal, notificationId, updatedNotification);
                                updateNotificationMetrics(notificationId, "sent", 1);
                                updateNotificationHistory(notificationId, "sent", channelId);
                                #ok()
                            };
                            case (#err(msg)) #err(msg)
                        }
                    };
                    case null #err("Channel not found")
                }
            };
            case null #err("Notification not found")
        }
    };

    public shared(msg) func markNotificationAsRead(notificationId : Text) : async Result.Result<(), Text> {
        switch (HashMap.get(notifications, Text.equal, notificationId)) {
            case (?notification) {
                let updatedNotification = {
                    notification with
                    status = #read;
                    readAt = Time.now();
                    updatedAt = Time.now()
                };
                HashMap.put(notifications, Text.equal, notificationId, updatedNotification);
                updateNotificationMetrics(notificationId, "read", 1);
                updateNotificationHistory(notificationId, "read", "");
                #ok()
            };
            case null #err("Notification not found")
        }
    };

    // Query functions
    public query func getNotification(notificationId : Text) : async ?Types.Notification {
        HashMap.get(notifications, Text.equal, notificationId)
    };

    public query func getAlert(alertId : Text) : async ?Types.Alert {
        HashMap.get(alerts, Text.equal, alertId)
    };

    public query func getChannel(channelId : Text) : async ?Types.Channel {
        HashMap.get(channels, Text.equal, channelId)
    };

    public query func getPreferences(userId : Principal) : async ?Types.NotificationPreferences {
        HashMap.get(preferences, Principal.equal, userId)
    };

    public query func getNotificationMetrics(notificationId : Text) : async ?Types.NotificationMetrics {
        HashMap.get(metrics, Text.equal, notificationId)
    };

    public query func getNotificationHistory(notificationId : Text) : async ?Types.NotificationHistory {
        HashMap.get(history, Text.equal, notificationId)
    };

    public query func getNotificationsByStatus(status : Types.NotificationStatus) : async [Types.Notification] {
        let notifications = HashMap.entries(notifications);
        let filteredNotifications = Array.filter(notifications, func((id, notification) : (Text, Types.Notification)) : Bool {
            notification.status == status
        });
        Array.map(filteredNotifications, func((id, notification) : (Text, Types.Notification)) : Types.Notification { notification })
    };

    public query func getAlertsByStatus(status : Types.AlertStatus) : async [Types.Alert] {
        let alerts = HashMap.entries(alerts);
        let filteredAlerts = Array.filter(alerts, func((id, alert) : (Text, Types.Alert)) : Bool {
            alert.status == status
        });
        Array.map(filteredAlerts, func((id, alert) : (Text, Types.Alert)) : Types.Alert { alert })
    };

    public query func getChannelsByType(channelType : Text) : async [Types.Channel] {
        let channels = HashMap.entries(channels);
        let filteredChannels = Array.filter(channels, func((id, channel) : (Text, Types.Channel)) : Bool {
            channel.type == channelType
        });
        Array.map(filteredChannels, func((id, channel) : (Text, Types.Channel)) : Types.Channel { channel })
    };
}; 