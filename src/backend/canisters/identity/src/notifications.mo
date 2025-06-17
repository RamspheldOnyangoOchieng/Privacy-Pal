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
import Types "../types";
import Constants "./constants";

actor class NotificationsCanister() {
    // State variables
    private stable var notifications : HashMap.HashMap<Text, Types.Notification> = HashMap.new();
    private stable var templates : HashMap.HashMap<Text, Types.NotificationTemplate> = HashMap.new();
    private stable var channels : HashMap.HashMap<Text, Types.Channel> = HashMap.new();
    private stable var preferences : HashMap.HashMap<Principal, Types.NotificationPreferences> = HashMap.new();
    private stable var deliveryStatus : HashMap.HashMap<Text, Types.DeliveryStatus> = HashMap.new();

    // Types
    type Notification = {
        id : Text;
        type : Types.NotificationType;
        title : Text;
        content : Text;
        priority : Types.Priority;
        timestamp : Time.Time;
        sender : Principal;
        recipients : [Principal];
        metadata : [Types.Metadata];
        status : Types.NotificationStatus;
    };

    type NotificationType = {
        #ALERT;
        #UPDATE;
        #REMINDER;
        #SYSTEM;
        #CUSTOM;
    };

    type Priority = {
        #LOW;
        #MEDIUM;
        #HIGH;
        #URGENT;
    };

    type Metadata = {
        key : Text;
        value : Text;
    };

    type Template = {
        id : Text;
        name : Text;
        type : Types.NotificationType;
        title : Text;
        content : Text;
        variables : [Text];
        lastModified : Time.Time;
    };

    type Channel = {
        id : Text;
        name : Text;
        type : Types.ChannelType;
        config : Types.ChannelConfig;
        status : Types.ChannelStatus;
        lastUsed : Time.Time;
    };

    type ChannelType = {
        #EMAIL;
        #SMS;
        #PUSH;
        #IN_APP;
        #WEBHOOK;
    };

    type ChannelConfig = {
        #EmailConfig : Types.EmailConfig;
        #SMSConfig : Types.SMSConfig;
        #PushConfig : Types.PushConfig;
        #WebhookConfig : Types.WebhookConfig;
    };

    type EmailConfig = {
        smtpServer : Text;
        port : Nat;
        username : Text;
        password : Text;
        fromAddress : Text;
    };

    type SMSConfig = {
        provider : Text;
        apiKey : Text;
        fromNumber : Text;
    };

    type PushConfig = {
        provider : Text;
        apiKey : Text;
        appId : Text;
    };

    type WebhookConfig = {
        url : Text;
        method : Text;
        headers : [(Text, Text)];
    };

    type ChannelStatus = {
        #ACTIVE;
        #INACTIVE;
        #ERROR;
    };

    type NotificationPreferences = {
        channels : [Text];
        types : [Types.NotificationType];
        quietHours : ?Types.QuietHours;
        language : Text;
    };

    type QuietHours = {
        start : Time.Time;
        end : Time.Time;
        timezone : Text;
    };

    type DeliveryStatus = {
        notificationId : Text;
        recipient : Principal;
        channel : Text;
        status : Types.DeliveryState;
        attempts : Nat;
        lastAttempt : Time.Time;
        error : ?Text;
    };

    type DeliveryState = {
        #PENDING;
        #SENT;
        #DELIVERED;
        #FAILED;
    };

    // Helper functions
    private func generateNotificationId() : Text {
        let randomBytes = Random.blob(16);
        let id = Blob.toArray(randomBytes);
        let hexId = Array.foldLeft<Nat8, Text>(
            id,
            "",
            func (acc : Text, byte : Nat8) : Text {
                acc # Nat8.toText(byte)
            }
        );
        "notif-" # hexId
    };

    private func getNotificationTemplate(type : Types.NotificationType) : ?Types.NotificationTemplate {
        HashMap.get(templates, Text.hash(type), type)
    };

    private func formatNotificationMessage(template : Types.NotificationTemplate, data : Types.NotificationData) : Text {
        // Replace placeholders in template with actual data
        var message = template.message;
        for ((key, value) in data.vals()) {
            message := Text.replace(message, "{" # key # "}", value);
        };
        message
    };

    private func shouldSendNotification(userId : Text, type : Types.NotificationType) : Bool {
        switch (HashMap.get(preferences, Principal.equal, Principal.hash, userId)) {
            case (null) { true }; // Default to true if no preferences set
            case (?preferences) {
                switch (type) {
                    case (#SecurityAlert) { preferences.securityAlerts };
                    case (#SystemUpdate) { preferences.systemUpdates };
                    case (#UserActivity) { preferences.userActivity };
                    case (#CommunityUpdate) { preferences.communityUpdates };
                    case (#WhistleblowerAlert) { preferences.whistleblowerAlerts };
                }
            };
        }
    };

    private func queueNotification(notification : Types.Notification) {
        // Update notification history
        switch (HashMap.get(notifications, Text.hash(notification.userId), notification.userId)) {
            case (null) {
                HashMap.put(notifications, Text.hash(notification.userId), notification.userId, [notification]);
            };
            case (?history) {
                let updatedHistory = Array.append(history, [notification]);
                HashMap.put(notifications, Text.hash(notification.userId), notification.userId, updatedHistory);
            };
        };
    };

    private func processNotificationQueue() {
        while (Buffer.size(notificationQueue) > 0) {
            let notification = Buffer.removeLast(notificationQueue);
            if (shouldSendNotification(notification.userId, notification.type)) {
                // TODO: Implement actual notification delivery
                Debug.print("Sending notification: " # notification.message);
            };
        };
    };

    // Public functions
    public shared(msg) func createNotification(
        userId : Text,
        type : Types.NotificationType,
        data : Types.NotificationData
    ) : async { #ok : Text; #err : Text } {
        let template = getNotificationTemplate(type);
        switch (template) {
            case (null) {
                #err("Notification template not found")
            };
            case (?t) {
                let notificationId = generateNotificationId();
                let message = formatNotificationMessage(t, data);
                
                let notification : Types.Notification = {
                    id = notificationId;
                    userId = userId;
                    type = type;
                    message = message;
                    data = data;
                    createdAt = Time.now();
                    status = #Pending;
                    priority = t.priority;
                };

                HashMap.put(notifications, Text.hash(notificationId), notificationId, notification);
                queueNotification(notification);
                
                #ok(notificationId)
            };
        }
    };

    public shared(msg) func updateNotificationPreferences(
        userId : Text,
        preferences : Types.NotificationPreferences
    ) : async { #ok; #err : Text } {
        HashMap.put(preferences, Principal.equal, Principal.hash, userId, preferences);
        #ok
    };

    public shared(msg) func markNotificationAsRead(notificationId : Text) : async { #ok; #err : Text } {
        switch (HashMap.get(notifications, Text.hash(notificationId), notificationId)) {
            case (null) {
                #err("Notification not found")
            };
            case (?notification) {
                let updatedNotification = {
                    notification with
                    status = #Read;
                };
                HashMap.put(notifications, Text.hash(notificationId), notificationId, updatedNotification);
                #ok
            };
        }
    };

    public query func getNotifications(userId : Text) : async { #ok : [Types.Notification]; #err : Text } {
        switch (HashMap.get(notifications, Text.hash(userId), userId)) {
            case (null) {
                #err("No notifications found")
            };
            case (?notifications) {
                #ok(notifications)
            };
        }
    };

    public query func getUnreadNotifications(userId : Text) : async { #ok : [Types.Notification]; #err : Text } {
        switch (HashMap.get(notifications, Text.hash(userId), userId)) {
            case (null) {
                #err("No notifications found")
            };
            case (?notifications) {
                let unread = Array.filter(notifications, func (n : Types.Notification) : Bool {
                    n.status == #Pending
                });
                #ok(unread)
            };
        }
    };

    public query func getNotificationPreferences(userId : Text) : async { #ok : Types.NotificationPreferences; #err : Text } {
        switch (HashMap.get(preferences, Principal.equal, Principal.hash, userId)) {
            case (null) {
                #err("Preferences not found")
            };
            case (?preferences) {
                #ok(preferences)
            };
        }
    };

    // System functions
    public shared(msg) func processQueue() : async { #ok; #err : Text } {
        processNotificationQueue();
        #ok
    };

    public shared(msg) func clearOldNotifications(days : Nat) : async { #ok; #err : Text } {
        let cutoffTime = Time.now() - (days * 24 * 60 * 60 * 1_000_000_000);
        
        for ((userId, notifications) in HashMap.entries(notifications)) {
            let recentNotifications = Array.filter(notifications, func (n : Types.Notification) : Bool {
                n.createdAt > cutoffTime
            });
            HashMap.put(notifications, Text.hash(userId), userId, recentNotifications);
        };
        
        #ok
    };

    public shared(msg) func sendNotification(notification : Types.Notification) : async Text {
        let notificationId = generateNotificationId();
        let updatedNotification = {
            notification with
            id = notificationId;
            status = #PENDING;
        };

        ignore HashMap.put(notifications, Principal.equal, Principal.hash, notificationId, updatedNotification);

        for (recipient in notification.recipients.vals()) {
            switch (HashMap.get(preferences, Principal.equal, Principal.hash, recipient)) {
                case (?prefs) {
                    if (shouldSendNotification(notification.userId, notification.type)) {
                        for (channelId in prefs.channels.vals()) {
                            switch (HashMap.get(channels, Principal.equal, Principal.hash, channelId)) {
                                case (?channel) {
                                    if (channel.status == #ACTIVE) {
                                        let deliveryStatus = {
                                            notificationId = notificationId;
                                            recipient = recipient;
                                            channel = channelId;
                                            status = #PENDING;
                                            attempts = 0;
                                            lastAttempt = Time.now();
                                            error = null;
                                        };
                                        ignore HashMap.put(deliveryStatus, Principal.equal, Principal.hash, notificationId, deliveryStatus);

                                        let success = await deliverNotification(notification, channel);
                                        if (success) {
                                            let updatedStatus = {
                                                deliveryStatus with
                                                status = #SENT;
                                                attempts = deliveryStatus.attempts + 1;
                                                lastAttempt = Time.now();
                                            };
                                            ignore HashMap.put(deliveryStatus, Principal.equal, Principal.hash, notificationId, updatedStatus);
                                        } else {
                                            let failedStatus = {
                                                deliveryStatus with
                                                status = #FAILED;
                                                attempts = deliveryStatus.attempts + 1;
                                                lastAttempt = Time.now();
                                                error = ?"Delivery failed";
                                            };
                                            ignore HashMap.put(deliveryStatus, Principal.equal, Principal.hash, notificationId, failedStatus);
                                        };
                                    };
                                };
                                case null {};
                            };
                        };
                    };
                };
                case null {};
            };
        };

        notificationId;
    };

    public shared(msg) func createTemplate(template : Types.NotificationTemplate) : async () {
        ignore HashMap.put(templates, Principal.equal, Principal.hash, template.id, template);
    };

    public shared(msg) func registerChannel(channel : Types.Channel) : async () {
        ignore HashMap.put(channels, Principal.equal, Principal.hash, channel.id, channel);
    };

    public query func getNotification(notificationId : Text) : async ?Types.Notification {
        HashMap.get(notifications, Principal.equal, Principal.hash, notificationId);
    };

    public query func getTemplate(templateId : Text) : async ?Types.NotificationTemplate {
        HashMap.get(templates, Principal.equal, Principal.hash, templateId);
    };

    public query func getChannel(channelId : Text) : async ?Types.Channel {
        HashMap.get(channels, Principal.equal, Principal.hash, channelId);
    };

    public query func getPreferences(user : Principal) : async ?Types.NotificationPreferences {
        HashMap.get(preferences, Principal.equal, Principal.hash, user);
    };

    public query func getDeliveryStatus(notificationId : Text) : async ?Types.DeliveryStatus {
        HashMap.get(deliveryStatus, Principal.equal, Principal.hash, notificationId);
    };

    private func shouldDeliver(notification : Types.Notification, preferences : Types.NotificationPreferences) : Bool {
        // Check if notification type is allowed
        if (not Array.contains(preferences.types, notification.type, Types.NotificationType.equal)) {
            return false;
        };

        // Check quiet hours
        switch (preferences.quietHours) {
            case (?quietHours) {
                let now = Time.now();
                if (now >= quietHours.start and now <= quietHours.end) {
                    return false;
                };
            };
            case null {};
        };

        true;
    };

    private func deliverNotification(notification : Types.Notification, channel : Types.Channel) : async Bool {
        switch (channel.type) {
            case (#EMAIL) {
                // Implement email delivery
                true;
            };
            case (#SMS) {
                // Implement SMS delivery
                true;
            };
            case (#PUSH) {
                // Implement push notification delivery
                true;
            };
            case (#IN_APP) {
                // Implement in-app notification delivery
                true;
            };
            case (#WEBHOOK) {
                // Implement webhook delivery
                true;
            };
        };
    };
}; 