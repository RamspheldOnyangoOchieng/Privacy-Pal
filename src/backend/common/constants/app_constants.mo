module {
    // Report Constants
    public let MAX_REPORT_LENGTH = 5000;
    public let MIN_REPORT_LENGTH = 50;
    public let MAX_MEDIA_COUNT = 5;
    public let MAX_FILE_SIZE = 10_000_000; // 10MB

    // Moderation Constants
    public let MODERATION_DEADLINE = 24 * 60 * 60 * 1_000_000_000; // 24 hours
    public let MAX_REPORTS_PER_MODERATOR = 10;
    public let MIN_ACCURACY_THRESHOLD = 0.8;
    public let MAX_APPEAL_WINDOW = 7 * 24 * 60 * 60 * 1_000_000_000; // 7 days

    // Identity Constants
    public let SESSION_DURATION = 24 * 60 * 60 * 1_000_000_000; // 24 hours
    public let MAX_DEVICES_PER_USER = 5;
    public let TRUST_SCORE_DECAY_RATE = 0.1;

    // Storage Constants
    public let MAX_STORAGE_PER_USER = 100_000_000; // 100MB
    public let BACKUP_INTERVAL = 24 * 60 * 60 * 1_000_000_000; // 24 hours
    public let RETENTION_PERIOD = 365 * 24 * 60 * 60 * 1_000_000_000; // 1 year

    // Security Constants
    public let MAX_LOGIN_ATTEMPTS = 5;
    public let LOCKOUT_DURATION = 30 * 60 * 1_000_000_000; // 30 minutes
    public let PASSWORD_MIN_LENGTH = 8;
    public let PASSWORD_MAX_LENGTH = 128;

    // Rate Limiting Constants
    public let MAX_REQUESTS_PER_MINUTE = 60;
    public let MAX_REQUESTS_PER_HOUR = 1000;
    public let RATE_LIMIT_WINDOW = 60 * 1_000_000_000; // 1 minute
}; 