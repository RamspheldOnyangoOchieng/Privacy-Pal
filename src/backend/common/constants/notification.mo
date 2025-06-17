module {
    // Time constants
    public let ONE_SECOND : Nat = 1;
    public let ONE_MINUTE : Nat = 60;
    public let ONE_HOUR : Nat = 3600;
    public let ONE_DAY : Nat = 86400;
    public let ONE_WEEK : Nat = 604800;
    public let ONE_MONTH : Nat = 2592000;
    public let ONE_YEAR : Nat = 31536000;

    // Notification limits
    public let MIN_NOTIFICATION_LENGTH : Nat = 1;
    public let MAX_NOTIFICATION_LENGTH : Nat = 1000;
    public let MIN_NOTIFICATION_TITLE_LENGTH : Nat = 1;
    public let MAX_NOTIFICATION_TITLE_LENGTH : Nat = 200;
    public let MIN_NOTIFICATION_BODY_LENGTH : Nat = 1;
    public let MAX_NOTIFICATION_BODY_LENGTH : Nat = 5000;
    public let MIN_NOTIFICATION_PRIORITY : Nat = 0;
    public let MAX_NOTIFICATION_PRIORITY : Nat = 10;
    public let DEFAULT_NOTIFICATION_PRIORITY : Nat = 5;
    public let MIN_NOTIFICATION_RETENTION : Nat = 0;
    public let MAX_NOTIFICATION_RETENTION : Nat = 31536000; // 1 year in seconds
    public let DEFAULT_NOTIFICATION_RETENTION : Nat = 604800; // 1 week in seconds
    public let MIN_NOTIFICATIONS_PER_USER : Nat = 0;
    public let MAX_NOTIFICATIONS_PER_USER : Nat = 1000;
    public let MIN_NOTIFICATIONS_PER_DAY : Nat = 0;
    public let MAX_NOTIFICATIONS_PER_DAY : Nat = 100;
    public let MIN_NOTIFICATIONS_PER_HOUR : Nat = 0;
    public let MAX_NOTIFICATIONS_PER_HOUR : Nat = 10;

    // Template limits
    public let MIN_TEMPLATE_LENGTH : Nat = 1;
    public let MAX_TEMPLATE_LENGTH : Nat = 5000;
    public let MIN_TEMPLATE_NAME_LENGTH : Nat = 1;
    public let MAX_TEMPLATE_NAME_LENGTH : Nat = 100;
    public let MIN_TEMPLATE_DESCRIPTION_LENGTH : Nat = 1;
    public let MAX_TEMPLATE_DESCRIPTION_LENGTH : Nat = 500;
    public let MIN_TEMPLATES_PER_USER : Nat = 0;
    public let MAX_TEMPLATES_PER_USER : Nat = 100;
    public let MIN_TEMPLATE_VARIABLES : Nat = 0;
    public let MAX_TEMPLATE_VARIABLES : Nat = 50;

    // Channel limits
    public let MIN_CHANNEL_NAME_LENGTH : Nat = 1;
    public let MAX_CHANNEL_NAME_LENGTH : Nat = 100;
    public let MIN_CHANNEL_DESCRIPTION_LENGTH : Nat = 1;
    public let MAX_CHANNEL_DESCRIPTION_LENGTH : Nat = 500;
    public let MIN_CHANNELS_PER_USER : Nat = 0;
    public let MAX_CHANNELS_PER_USER : Nat = 50;
    public let MIN_SUBSCRIBERS_PER_CHANNEL : Nat = 0;
    public let MAX_SUBSCRIBERS_PER_CHANNEL : Nat = 10000;
    public let MIN_CHANNEL_PRIORITY : Nat = 0;
    public let MAX_CHANNEL_PRIORITY : Nat = 10;
    public let DEFAULT_CHANNEL_PRIORITY : Nat = 5;

    // Subscription limits
    public let MIN_SUBSCRIPTION_NAME_LENGTH : Nat = 1;
    public let MAX_SUBSCRIPTION_NAME_LENGTH : Nat = 100;
    public let MIN_SUBSCRIPTION_DESCRIPTION_LENGTH : Nat = 1;
    public let MAX_SUBSCRIPTION_DESCRIPTION_LENGTH : Nat = 500;
    public let MIN_SUBSCRIPTIONS_PER_USER : Nat = 0;
    public let MAX_SUBSCRIPTIONS_PER_USER : Nat = 100;
    public let MIN_SUBSCRIPTION_PRIORITY : Nat = 0;
    public let MAX_SUBSCRIPTION_PRIORITY : Nat = 10;
    public let DEFAULT_SUBSCRIPTION_PRIORITY : Nat = 5;
    public let MIN_SUBSCRIPTION_RETENTION : Nat = 0;
    public let MAX_SUBSCRIPTION_RETENTION : Nat = 31536000; // 1 year in seconds
    public let DEFAULT_SUBSCRIPTION_RETENTION : Nat = 604800; // 1 week in seconds

    // Error messages
    public let ERROR_INVALID_NOTIFICATION_LENGTH : Text = "Invalid notification length";
    public let ERROR_INVALID_NOTIFICATION_TITLE_LENGTH : Text = "Invalid notification title length";
    public let ERROR_INVALID_NOTIFICATION_BODY_LENGTH : Text = "Invalid notification body length";
    public let ERROR_INVALID_NOTIFICATION_PRIORITY : Text = "Invalid notification priority";
    public let ERROR_INVALID_NOTIFICATION_RETENTION : Text = "Invalid notification retention";
    public let ERROR_INVALID_NOTIFICATIONS_PER_USER : Text = "Invalid notifications per user";
    public let ERROR_INVALID_NOTIFICATIONS_PER_DAY : Text = "Invalid notifications per day";
    public let ERROR_INVALID_NOTIFICATIONS_PER_HOUR : Text = "Invalid notifications per hour";
    public let ERROR_INVALID_TEMPLATE_LENGTH : Text = "Invalid template length";
    public let ERROR_INVALID_TEMPLATE_NAME_LENGTH : Text = "Invalid template name length";
    public let ERROR_INVALID_TEMPLATE_DESCRIPTION_LENGTH : Text = "Invalid template description length";
    public let ERROR_INVALID_TEMPLATES_PER_USER : Text = "Invalid templates per user";
    public let ERROR_INVALID_TEMPLATE_VARIABLES : Text = "Invalid template variables";
    public let ERROR_INVALID_CHANNEL_NAME_LENGTH : Text = "Invalid channel name length";
    public let ERROR_INVALID_CHANNEL_DESCRIPTION_LENGTH : Text = "Invalid channel description length";
    public let ERROR_INVALID_CHANNELS_PER_USER : Text = "Invalid channels per user";
    public let ERROR_INVALID_SUBSCRIBERS_PER_CHANNEL : Text = "Invalid subscribers per channel";
    public let ERROR_INVALID_CHANNEL_PRIORITY : Text = "Invalid channel priority";
    public let ERROR_INVALID_SUBSCRIPTION_NAME_LENGTH : Text = "Invalid subscription name length";
    public let ERROR_INVALID_SUBSCRIPTION_DESCRIPTION_LENGTH : Text = "Invalid subscription description length";
    public let ERROR_INVALID_SUBSCRIPTIONS_PER_USER : Text = "Invalid subscriptions per user";
    public let ERROR_INVALID_SUBSCRIPTION_PRIORITY : Text = "Invalid subscription priority";
    public let ERROR_INVALID_SUBSCRIPTION_RETENTION : Text = "Invalid subscription retention";

    // Status messages
    public let STATUS_NOTIFICATION_SENT : Text = "Notification sent successfully";
    public let STATUS_NOTIFICATION_DELETED : Text = "Notification deleted successfully";
    public let STATUS_NOTIFICATION_UPDATED : Text = "Notification updated successfully";
    public let STATUS_NOTIFICATION_READ : Text = "Notification marked as read";
    public let STATUS_NOTIFICATION_UNREAD : Text = "Notification marked as unread";
    public let STATUS_TEMPLATE_CREATED : Text = "Template created successfully";
    public let STATUS_TEMPLATE_DELETED : Text = "Template deleted successfully";
    public let STATUS_TEMPLATE_UPDATED : Text = "Template updated successfully";
    public let STATUS_CHANNEL_CREATED : Text = "Channel created successfully";
    public let STATUS_CHANNEL_DELETED : Text = "Channel deleted successfully";
    public let STATUS_CHANNEL_UPDATED : Text = "Channel updated successfully";
    public let STATUS_SUBSCRIPTION_CREATED : Text = "Subscription created successfully";
    public let STATUS_SUBSCRIPTION_DELETED : Text = "Subscription deleted successfully";
    public let STATUS_SUBSCRIPTION_UPDATED : Text = "Subscription updated successfully";

    // Feature flags
    public let ENABLE_NOTIFICATIONS : Bool = true;
    public let ENABLE_TEMPLATES : Bool = true;
    public let ENABLE_CHANNELS : Bool = true;
    public let ENABLE_SUBSCRIPTIONS : Bool = true;
    public let ENABLE_NOTIFICATION_PRIORITY : Bool = true;
    public let ENABLE_NOTIFICATION_RETENTION : Bool = true;
    public let ENABLE_NOTIFICATION_TEMPLATES : Bool = true;
    public let ENABLE_NOTIFICATION_CHANNELS : Bool = true;
    public let ENABLE_NOTIFICATION_SUBSCRIPTIONS : Bool = true;
    public let ENABLE_NOTIFICATION_LOGGING : Bool = true;
}; 