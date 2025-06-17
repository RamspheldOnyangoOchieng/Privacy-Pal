module {
    // Authentication constants
    public let MIN_PASSWORD_LENGTH : Nat = 8;
    public let MAX_PASSWORD_LENGTH : Nat = 128;
    public let MIN_USERNAME_LENGTH : Nat = 3;
    public let MAX_USERNAME_LENGTH : Nat = 32;
    public let MAX_LOGIN_ATTEMPTS : Nat = 5;
    public let LOGIN_TIMEOUT : Nat = 300; // 5 minutes in seconds
    public let SESSION_DURATION : Nat = 86400; // 24 hours in seconds
    public let REFRESH_TOKEN_DURATION : Nat = 604800; // 7 days in seconds

    // Encryption constants
    public let MIN_KEY_SIZE : Nat = 128;
    public let MAX_KEY_SIZE : Nat = 4096;
    public let DEFAULT_KEY_SIZE : Nat = 256;
    public let MIN_SALT_LENGTH : Nat = 16;
    public let MAX_SALT_LENGTH : Nat = 64;
    public let DEFAULT_SALT_LENGTH : Nat = 32;
    public let MIN_IV_LENGTH : Nat = 12;
    public let MAX_IV_LENGTH : Nat = 16;
    public let DEFAULT_IV_LENGTH : Nat = 12;

    // Rate limiting constants
    public let MAX_REQUESTS_PER_MINUTE : Nat = 60;
    public let MAX_REQUESTS_PER_HOUR : Nat = 1000;
    public let MAX_REQUESTS_PER_DAY : Nat = 10000;
    public let RATE_LIMIT_WINDOW : Nat = 60; // 1 minute in seconds
    public let RATE_LIMIT_BURST : Nat = 10;

    // Token constants
    public let MIN_TOKEN_LENGTH : Nat = 32;
    public let MAX_TOKEN_LENGTH : Nat = 512;
    public let DEFAULT_TOKEN_LENGTH : Nat = 64;
    public let TOKEN_EXPIRY : Nat = 3600; // 1 hour in seconds
    public let REFRESH_TOKEN_EXPIRY : Nat = 604800; // 7 days in seconds

    // Validation patterns
    public let PASSWORD_PATTERN : Text = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$";
    public let USERNAME_PATTERN : Text = "^[a-zA-Z0-9_-]{3,32}$";
    public let EMAIL_PATTERN : Text = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
    public let PHONE_PATTERN : Text = "^\\+?[1-9]\\d{1,14}$";
    public let URL_PATTERN : Text = "^(https?|ftp)://[^\\s/$.?#].[^\\s]*$";

    // Error messages
    public let ERROR_INVALID_PASSWORD : Text = "Invalid password format";
    public let ERROR_INVALID_USERNAME : Text = "Invalid username format";
    public let ERROR_INVALID_EMAIL : Text = "Invalid email format";
    public let ERROR_INVALID_PHONE : Text = "Invalid phone format";
    public let ERROR_INVALID_URL : Text = "Invalid URL format";
    public let ERROR_MAX_LOGIN_ATTEMPTS : Text = "Maximum login attempts exceeded";
    public let ERROR_SESSION_EXPIRED : Text = "Session has expired";
    public let ERROR_INVALID_TOKEN : Text = "Invalid token";
    public let ERROR_TOKEN_EXPIRED : Text = "Token has expired";
    public let ERROR_RATE_LIMIT_EXCEEDED : Text = "Rate limit exceeded";
    public let ERROR_INVALID_KEY_SIZE : Text = "Invalid key size";
    public let ERROR_INVALID_SALT_LENGTH : Text = "Invalid salt length";
    public let ERROR_INVALID_IV_LENGTH : Text = "Invalid IV length";

    // Status messages
    public let STATUS_PASSWORD_CHANGED : Text = "Password changed successfully";
    public let STATUS_USERNAME_CHANGED : Text = "Username changed successfully";
    public let STATUS_EMAIL_CHANGED : Text = "Email changed successfully";
    public let STATUS_PHONE_CHANGED : Text = "Phone changed successfully";
    public let STATUS_TOKEN_REFRESHED : Text = "Token refreshed successfully";
    public let STATUS_SESSION_ENDED : Text = "Session ended successfully";
    public let STATUS_RATE_LIMIT_RESET : Text = "Rate limit reset successfully";

    // Feature flags
    public let ENABLE_TWO_FACTOR : Bool = true;
    public let ENABLE_PASSWORD_RESET : Bool = true;
    public let ENABLE_EMAIL_VERIFICATION : Bool = true;
    public let ENABLE_PHONE_VERIFICATION : Bool = true;
    public let ENABLE_RATE_LIMITING : Bool = true;
    public let ENABLE_SESSION_MANAGEMENT : Bool = true;
    public let ENABLE_TOKEN_REFRESH : Bool = true;
    public let ENABLE_PASSWORD_HISTORY : Bool = true;
    public let ENABLE_LOGIN_HISTORY : Bool = true;
    public let ENABLE_SECURITY_LOGS : Bool = true;
}; 