

module {
    // ===== Helper Functions =====

    /// Checks if a text value's length is within the specified range
    public func isValidLength(text : Text, minLength : Nat, maxLength : Nat) : Bool {
        let length = Text.size(text);
        length >= minLength and length <= maxLength
    };

    /// Checks if a number is within the specified range
    public func isInRange(value : Nat, min : Nat, max : Nat) : Bool {
        value >= min and value <= max
    };

    /// Checks if a text matches a regular expression pattern
    public func matchesPattern(text : Text, pattern : Text) : Bool {
        // TODO: Implement regex pattern matching
        // For now, return true as a placeholder
        true
    };

    /// Checks if a text contains only alphanumeric characters
    public func isAlphanumeric(text : Text) : Bool {
        Text.toIter(text)
        |> Iter.forAll(func(c : Char) : Bool {
            Char.isAlphabetic(c) or Char.isDigit(c)
        })
    };

    /// Checks if a text contains only alphabetic characters
    public func isAlphabetic(text : Text) : Bool {
        Text.toIter(text)
        |> Iter.forAll(Char.isAlphabetic)
    };

    /// Checks if a text contains only numeric characters
    public func isNumeric(text : Text) : Bool {
        Text.toIter(text)
        |> Iter.forAll(Char.isDigit)
    };

    /// Checks if a text contains only whitespace characters
    public func isWhitespace(text : Text) : Bool {
        Text.toIter(text)
        |> Iter.forAll(Char.isWhitespace)
    };

    /// Checks if a text is empty or contains only whitespace
    public func isBlank(text : Text) : Bool {
        Text.trim(text, #both) == ""
    };

    /// Checks if a text contains a specific substring
    public func contains(text : Text, substring : Text) : Bool {
        Text.contains(text, #text substring)
    };

    /// Checks if a text starts with a specific prefix
    public func startsWith(text : Text, prefix : Text) : Bool {
        Text.startsWith(text, #text prefix)
    };

    /// Checks if a text ends with a specific suffix
    public func endsWith(text : Text, suffix : Text) : Bool {
        Text.endsWith(text, #text suffix)
    };

    /// Checks if a text is a valid UUID
    public func isValidUUID(text : Text) : Bool {
        // TODO: Implement UUID validation
        // For now, return true as a placeholder
        true
    };

    /// Checks if a text is a valid IP address
    public func isValidIPAddress(text : Text) : Bool {
        // TODO: Implement IP address validation
        // For now, return true as a placeholder
        true
    };

    /// Checks if a text is a valid MAC address
    public func isValidMACAddress(text : Text) : Bool {
        // TODO: Implement MAC address validation
        // For now, return true as a placeholder
        true
    };

    /// Checks if a text is a valid domain name
    public func isValidDomainName(text : Text) : Bool {
        // TODO: Implement domain name validation
        // For now, return true as a placeholder
        true
    };

    /// Checks if a text is a valid hostname
    public func isValidHostname(text : Text) : Bool {
        // TODO: Implement hostname validation
        // For now, return true as a placeholder
        true
    };

    /// Checks if a text is a valid port number
    public func isValidPortNumber(port : Nat) : Bool {
        port > 0 and port <= 65535
    };

    /// Checks if a text is a valid file path
    public func isValidFilePath(text : Text) : Bool {
        // TODO: Implement file path validation
        // For now, return true as a placeholder
        true
    };

    /// Checks if a text is a valid file name
    public func isValidFileName(text : Text) : Bool {
        // TODO: Implement file name validation
        // For now, return true as a placeholder
        true
    };

    /// Checks if a text is a valid file extension
    public func isValidFileExtension(text : Text) : Bool {
        // TODO: Implement file extension validation
        // For now, return true as a placeholder
        true
    };

    /// Checks if a text is a valid MIME type
    public func isValidMimeType(text : Text) : Bool {
        // TODO: Implement MIME type validation
        // For now, return true as a placeholder
        true
    };

    /// Checks if a text is a valid date string
    public func isValidDateString(text : Text) : Bool {
        // TODO: Implement date string validation
        // For now, return true as a placeholder
        true
    };

    /// Checks if a text is a valid time string
    public func isValidTimeString(text : Text) : Bool {
        // TODO: Implement time string validation
        // For now, return true as a placeholder
        true
    };

    /// Checks if a text is a valid datetime string
    public func isValidDateTimeString(text : Text) : Bool {
        // TODO: Implement datetime string validation
        // For now, return true as a placeholder
        true
    };

    /// Checks if a text is a valid timezone string
    public func isValidTimezoneString(text : Text) : Bool {
        // TODO: Implement timezone string validation
        // For now, return true as a placeholder
        true
    };

    /// Checks if a text is a valid currency code
    public func isValidCurrencyCode(text : Text) : Bool {
        // TODO: Implement currency code validation
        // For now, return true as a placeholder
        true
    };

    /// Checks if a text is a valid language code
    public func isValidLanguageCode(text : Text) : Bool {
        // TODO: Implement language code validation
        // For now, return true as a placeholder
        true
    };

    /// Checks if a text is a valid country code
    public func isValidCountryCode(text : Text) : Bool {
        // TODO: Implement country code validation
        // For now, return true as a placeholder
        true
    };

    /// Checks if a text is a valid locale string
    public func isValidLocaleString(text : Text) : Bool {
        // TODO: Implement locale string validation
        // For now, return true as a placeholder
        true
    };

    /// Checks if a text is a valid color code
    public func isValidColorCode(text : Text) : Bool {
        // TODO: Implement color code validation
        // For now, return true as a placeholder
        true
    };

    /// Checks if a text is a valid hex color code
    public func isValidHexColorCode(text : Text) : Bool {
        // TODO: Implement hex color code validation
        // For now, return true as a placeholder
        true
    };

    /// Checks if a text is a valid RGB color code
    public func isValidRGBColorCode(text : Text) : Bool {
        // TODO: Implement RGB color code validation
        // For now, return true as a placeholder
        true
    };

    /// Checks if a text is a valid RGBA color code
    public func isValidRGBAColorCode(text : Text) : Bool {
        // TODO: Implement RGBA color code validation
        // For now, return true as a placeholder
        true
    };

    /// Checks if a text is a valid HSL color code
    public func isValidHSLColorCode(text : Text) : Bool {
        // TODO: Implement HSL color code validation
        // For now, return true as a placeholder
        true
    };

    /// Checks if a text is a valid HSLA color code
    public func isValidHSLAColorCode(text : Text) : Bool {
        // TODO: Implement HSLA color code validation
        // For now, return true as a placeholder
        true
    };

    // ===== Additional Security Validation =====

    /// Validates a password strength
    public func validatePasswordStrength(password : Text) : Result.Result<(), Text> {
        if (not contains(password, #text "[A-Z]")) {
            return #err(SecurityConstants.ERROR_PASSWORD_NO_UPPERCASE)
        };
        if (not contains(password, #text "[a-z]")) {
            return #err(SecurityConstants.ERROR_PASSWORD_NO_LOWERCASE)
        };
        if (not contains(password, #text "[0-9]")) {
            return #err(SecurityConstants.ERROR_PASSWORD_NO_NUMBER)
        };
        if (not contains(password, #text "[^A-Za-z0-9]")) {
            return #err(SecurityConstants.ERROR_PASSWORD_NO_SPECIAL)
        };
        #ok()
    };

    /// Validates a password complexity
    public func validatePasswordComplexity(password : Text) : Result.Result<(), Text> {
        if (Text.size(password) < SecurityConstants.MIN_PASSWORD_LENGTH) {
            return #err(SecurityConstants.ERROR_PASSWORD_TOO_SHORT)
        };
        if (Text.size(password) > SecurityConstants.MAX_PASSWORD_LENGTH) {
            return #err(SecurityConstants.ERROR_PASSWORD_TOO_LONG)
        };
        #ok()
    };

    /// Validates a password history
    public func validatePasswordHistory(password : Text, history : [Text]) : Result.Result<(), Text> {
        if (Array.find(history, func(p : Text) : Bool { p == password }) != null) {
            return #err(SecurityConstants.ERROR_PASSWORD_IN_HISTORY)
        };
        #ok()
    };

    /// Validates a password expiration
    public func validatePasswordExpiration(expirationTime : Time.Time) : Result.Result<(), Text> {
        if (Time.now() > expirationTime) {
            return #err(SecurityConstants.ERROR_PASSWORD_EXPIRED)
        };
        #ok()
    };

    /// Validates a password reset token
    public func validatePasswordResetToken(token : Text) : Result.Result<(), Text> {
        if (not isValidLength(token, SecurityConstants.MIN_TOKEN_LENGTH, SecurityConstants.MAX_TOKEN_LENGTH)) {
            return #err(SecurityConstants.ERROR_INVALID_TOKEN)
        };
        #ok()
    };

    /// Validates a password reset token expiration
    public func validatePasswordResetTokenExpiration(expirationTime : Time.Time) : Result.Result<(), Text> {
        if (Time.now() > expirationTime) {
            return #err(SecurityConstants.ERROR_TOKEN_EXPIRED)
        };
        #ok()
    };

    /// Validates a password reset token usage
    public func validatePasswordResetTokenUsage(used : Bool) : Result.Result<(), Text> {
        if (used) {
            return #err(SecurityConstants.ERROR_TOKEN_USED)
        };
        #ok()
    };

    /// Validates a password reset token validity
    public func validatePasswordResetTokenValidity(token : Text, validToken : Text) : Result.Result<(), Text> {
        if (token != validToken) {
            return #err(SecurityConstants.ERROR_INVALID_TOKEN)
        };
        #ok()
    };

    /// Validates a password reset token format
    public func validatePasswordResetTokenFormat(token : Text) : Result.Result<(), Text> {
        if (not matchesPattern(token, SecurityConstants.TOKEN_PATTERN)) {
            return #err(SecurityConstants.ERROR_INVALID_TOKEN_FORMAT)
        };
        #ok()
    };

    /// Validates a password reset token length
    public func validatePasswordResetTokenLength(token : Text) : Result.Result<(), Text> {
        if (not isValidLength(token, SecurityConstants.MIN_TOKEN_LENGTH, SecurityConstants.MAX_TOKEN_LENGTH)) {
            return #err(SecurityConstants.ERROR_INVALID_TOKEN_LENGTH)
        };
        #ok()
    };

    // ===== Additional Validation Functions =====

    /// Validates a file path
    public func validateFilePath(path : Text) : Result.Result<(), Text> {
        if (not isValidFilePath(path)) {
            return #err(ValidationConstants.ERROR_INVALID_FILE_PATH)
        };
        #ok()
    };

    /// Validates a file name
    public func validateFileName(name : Text) : Result.Result<(), Text> {
        if (not isValidFileName(name)) {
            return #err(ValidationConstants.ERROR_INVALID_FILE_NAME)
        };
        #ok()
    };

    /// Validates a file extension
    public func validateFileExtension(extension : Text) : Result.Result<(), Text> {
        if (not isValidFileExtension(extension)) {
            return #err(ValidationConstants.ERROR_INVALID_FILE_EXTENSION)
        };
        #ok()
    };

    /// Validates a MIME type
    public func validateMimeType(mimeType : Text) : Result.Result<(), Text> {
        if (not isValidMimeType(mimeType)) {
            return #err(ValidationConstants.ERROR_INVALID_MIME_TYPE)
        };
        #ok()
    };

    /// Validates a date string
    public func validateDateString(date : Text) : Result.Result<(), Text> {
        if (not isValidDateString(date)) {
            return #err(ValidationConstants.ERROR_INVALID_DATE)
        };
        #ok()
    };

    /// Validates a time string
    public func validateTimeString(time : Text) : Result.Result<(), Text> {
        if (not isValidTimeString(time)) {
            return #err(ValidationConstants.ERROR_INVALID_TIME)
        };
        #ok()
    };

    /// Validates a datetime string
    public func validateDateTimeString(datetime : Text) : Result.Result<(), Text> {
        if (not isValidDateTimeString(datetime)) {
            return #err(ValidationConstants.ERROR_INVALID_DATETIME)
        };
        #ok()
    };

    /// Validates a timezone string
    public func validateTimezoneString(timezone : Text) : Result.Result<(), Text> {
        if (not isValidTimezoneString(timezone)) {
            return #err(ValidationConstants.ERROR_INVALID_TIMEZONE)
        };
        #ok()
    };

    /// Validates a currency code
    public func validateCurrencyCode(code : Text) : Result.Result<(), Text> {
        if (not isValidCurrencyCode(code)) {
            return #err(ValidationConstants.ERROR_INVALID_CURRENCY)
        };
        #ok()
    };

    /// Validates a language code
    public func validateLanguageCode(code : Text) : Result.Result<(), Text> {
        if (not isValidLanguageCode(code)) {
            return #err(ValidationConstants.ERROR_INVALID_LANGUAGE)
        };
        #ok()
    };

    /// Validates a country code
    public func validateCountryCode(code : Text) : Result.Result<(), Text> {
        if (not isValidCountryCode(code)) {
            return #err(ValidationConstants.ERROR_INVALID_COUNTRY)
        };
        #ok()
    };

    /// Validates a locale string
    public func validateLocaleString(locale : Text) : Result.Result<(), Text> {
        if (not isValidLocaleString(locale)) {
            return #err(ValidationConstants.ERROR_INVALID_LOCALE)
        };
        #ok()
    };

    /// Validates a color code
    public func validateColorCode(code : Text) : Result.Result<(), Text> {
        if (not isValidColorCode(code)) {
            return #err(ValidationConstants.ERROR_INVALID_COLOR)
        };
        #ok()
    };

    /// Validates a hex color code
    public func validateHexColorCode(code : Text) : Result.Result<(), Text> {
        if (not isValidHexColorCode(code)) {
            return #err(ValidationConstants.ERROR_INVALID_HEX_COLOR)
        };
        #ok()
    };

    /// Validates a RGB color code
    public func validateRGBColorCode(code : Text) : Result.Result<(), Text> {
        if (not isValidRGBColorCode(code)) {
            return #err(ValidationConstants.ERROR_INVALID_RGB_COLOR)
        };
        #ok()
    };

    /// Validates a RGBA color code
    public func validateRGBAColorCode(code : Text) : Result.Result<(), Text> {
        if (not isValidRGBAColorCode(code)) {
            return #err(ValidationConstants.ERROR_INVALID_RGBA_COLOR)
        };
        #ok()
    };

    /// Validates a HSL color code
    public func validateHSLColorCode(code : Text) : Result.Result<(), Text> {
        if (not isValidHSLColorCode(code)) {
            return #err(ValidationConstants.ERROR_INVALID_HSL_COLOR)
        };
        #ok()
    };

    /// Validates a HSLA color code
    public func validateHSLAColorCode(code : Text) : Result.Result<(), Text> {
        if (not isValidHSLAColorCode(code)) {
            return #err(ValidationConstants.ERROR_INVALID_HSLA_COLOR)
        };
        #ok()
    };

    // Security validation
    public func validatePassword(password : Text) : Result.Result<(), Text> {
        if (not isValidLength(password, SecurityConstants.MIN_PASSWORD_LENGTH, SecurityConstants.MAX_PASSWORD_LENGTH)) {
            return #err(SecurityConstants.ERROR_INVALID_PASSWORD)
        };
        if (not matchesPattern(password, SecurityConstants.PASSWORD_PATTERN)) {
            return #err(SecurityConstants.ERROR_INVALID_PASSWORD)
        };
        #ok()
    };

    public func validateUsername(username : Text) : Result.Result<(), Text> {
        if (not isValidLength(username, SecurityConstants.MIN_USERNAME_LENGTH, SecurityConstants.MAX_USERNAME_LENGTH)) {
            return #err(SecurityConstants.ERROR_INVALID_USERNAME)
        };
        if (not matchesPattern(username, SecurityConstants.USERNAME_PATTERN)) {
            return #err(SecurityConstants.ERROR_INVALID_USERNAME)
        };
        #ok()
    };

    public func validateEmail(email : Text) : Result.Result<(), Text> {
        if (not matchesPattern(email, SecurityConstants.EMAIL_PATTERN)) {
            return #err(SecurityConstants.ERROR_INVALID_EMAIL)
        };
        #ok()
    };

    public func validatePhone(phone : Text) : Result.Result<(), Text> {
        if (not matchesPattern(phone, SecurityConstants.PHONE_PATTERN)) {
            return #err(SecurityConstants.ERROR_INVALID_PHONE)
        };
        #ok()
    };

    public func validateUrl(url : Text) : Result.Result<(), Text> {
        if (not matchesPattern(url, SecurityConstants.URL_PATTERN)) {
            return #err(SecurityConstants.ERROR_INVALID_URL)
        };
        #ok()
    };

    // Validation validation
    public func validateText(text : Text, minLength : Nat, maxLength : Nat) : Result.Result<(), Text> {
        if (not isValidLength(text, minLength, maxLength)) {
            return #err(ValidationConstants.ERROR_INVALID_TEXT_LENGTH)
        };
        #ok()
    };

    public func validateName(name : Text) : Result.Result<(), Text> {
        if (not isValidLength(name, ValidationConstants.MIN_NAME_LENGTH, ValidationConstants.MAX_NAME_LENGTH)) {
            return #err(ValidationConstants.ERROR_INVALID_NAME_LENGTH)
        };
        #ok()
    };

    public func validateDescription(description : Text) : Result.Result<(), Text> {
        if (not isValidLength(description, ValidationConstants.MIN_DESCRIPTION_LENGTH, ValidationConstants.MAX_DESCRIPTION_LENGTH)) {
            return #err(ValidationConstants.ERROR_INVALID_DESCRIPTION_LENGTH)
        };
        #ok()
    };

    public func validateComment(comment : Text) : Result.Result<(), Text> {
        if (not isValidLength(comment, ValidationConstants.MIN_COMMENT_LENGTH, ValidationConstants.MAX_COMMENT_LENGTH)) {
            return #err(ValidationConstants.ERROR_INVALID_COMMENT_LENGTH)
        };
        #ok()
    };

    public func validateTitle(title : Text) : Result.Result<(), Text> {
        if (not isValidLength(title, ValidationConstants.MIN_TITLE_LENGTH, ValidationConstants.MAX_TITLE_LENGTH)) {
            return #err(ValidationConstants.ERROR_INVALID_TITLE_LENGTH)
        };
        #ok()
    };

    public func validateSummary(summary : Text) : Result.Result<(), Text> {
        if (not isValidLength(summary, ValidationConstants.MIN_SUMMARY_LENGTH, ValidationConstants.MAX_SUMMARY_LENGTH)) {
            return #err(ValidationConstants.ERROR_INVALID_SUMMARY_LENGTH)
        };
        #ok()
    };

    // Metrics validation
    public func validateStorageSize(size : Nat) : Result.Result<(), Text> {
        if (not isInRange(size, MetricsConstants.MIN_STORAGE_SIZE, MetricsConstants.MAX_STORAGE_SIZE)) {
            return #err(MetricsConstants.ERROR_INVALID_STORAGE_SIZE)
        };
        #ok()
    };

    public func validateFileSize(size : Nat) : Result.Result<(), Text> {
        if (not isInRange(size, MetricsConstants.MIN_FILE_SIZE, MetricsConstants.MAX_FILE_SIZE)) {
            return #err(MetricsConstants.ERROR_INVALID_FILE_SIZE)
        };
        #ok()
    };

    public func validateChunkSize(size : Nat) : Result.Result<(), Text> {
        if (not isInRange(size, MetricsConstants.MIN_CHUNK_SIZE, MetricsConstants.MAX_CHUNK_SIZE)) {
            return #err(MetricsConstants.ERROR_INVALID_CHUNK_SIZE)
        };
        #ok()
    };

    public func validateLatency(latency : Nat) : Result.Result<(), Text> {
        if (not isInRange(latency, MetricsConstants.MIN_LATENCY, MetricsConstants.MAX_LATENCY)) {
            return #err(MetricsConstants.ERROR_INVALID_LATENCY)
        };
        #ok()
    };

    public func validateThroughput(throughput : Nat) : Result.Result<(), Text> {
        if (not isInRange(throughput, MetricsConstants.MIN_THROUGHPUT, MetricsConstants.MAX_THROUGHPUT)) {
            return #err(MetricsConstants.ERROR_INVALID_THROUGHPUT)
        };
        #ok()
    };

    // Notification validation
    public func validateNotificationLength(notification : Text) : Result.Result<(), Text> {
        if (not isValidLength(notification, NotificationConstants.MIN_NOTIFICATION_LENGTH, NotificationConstants.MAX_NOTIFICATION_LENGTH)) {
            return #err(NotificationConstants.ERROR_INVALID_NOTIFICATION_LENGTH)
        };
        #ok()
    };

    public func validateNotificationTitle(title : Text) : Result.Result<(), Text> {
        if (not isValidLength(title, NotificationConstants.MIN_NOTIFICATION_TITLE_LENGTH, NotificationConstants.MAX_NOTIFICATION_TITLE_LENGTH)) {
            return #err(NotificationConstants.ERROR_INVALID_NOTIFICATION_TITLE_LENGTH)
        };
        #ok()
    };

    public func validateNotificationBody(body : Text) : Result.Result<(), Text> {
        if (not isValidLength(body, NotificationConstants.MIN_NOTIFICATION_BODY_LENGTH, NotificationConstants.MAX_NOTIFICATION_BODY_LENGTH)) {
            return #err(NotificationConstants.ERROR_INVALID_NOTIFICATION_BODY_LENGTH)
        };
        #ok()
    };

    public func validateNotificationPriority(priority : Nat) : Result.Result<(), Text> {
        if (not isInRange(priority, NotificationConstants.MIN_NOTIFICATION_PRIORITY, NotificationConstants.MAX_NOTIFICATION_PRIORITY)) {
            return #err(NotificationConstants.ERROR_INVALID_NOTIFICATION_PRIORITY)
        };
        #ok()
    };

    public func validateNotificationRetention(retention : Nat) : Result.Result<(), Text> {
        if (not isInRange(retention, NotificationConstants.MIN_NOTIFICATION_RETENTION, NotificationConstants.MAX_NOTIFICATION_RETENTION)) {
            return #err(NotificationConstants.ERROR_INVALID_NOTIFICATION_RETENTION)
        };
        #ok()
    };

    // Logging validation
    public func validateLogLevel(level : Nat) : Result.Result<(), Text> {
        if (not isInRange(level, LoggingConstants.LOG_LEVEL_TRACE, LoggingConstants.LOG_LEVEL_FATAL)) {
            return #err(LoggingConstants.ERROR_INVALID_LOG_LEVEL)
        };
        #ok()
    };

    public func validateLogRetention(retention : Nat) : Result.Result<(), Text> {
        if (not isInRange(retention, LoggingConstants.MIN_LOG_RETENTION, LoggingConstants.MAX_LOG_RETENTION)) {
            return #err(LoggingConstants.ERROR_INVALID_LOG_RETENTION)
        };
        #ok()
    };

    public func validateLogSize(size : Nat) : Result.Result<(), Text> {
        if (not isInRange(size, LoggingConstants.MIN_LOG_SIZE, LoggingConstants.MAX_LOG_SIZE)) {
            return #err(LoggingConstants.ERROR_INVALID_LOG_SIZE)
        };
        #ok()
    };

    public func validateLogRotation(rotation : Nat) : Result.Result<(), Text> {
        if (not isInRange(rotation, LoggingConstants.MIN_LOG_ROTATION, LoggingConstants.MAX_LOG_ROTATION)) {
            return #err(LoggingConstants.ERROR_INVALID_LOG_ROTATION)
        };
        #ok()
    };

    // Database validation
    public func validateConnections(connections : Nat) : Result.Result<(), Text> {
        if (not isInRange(connections, DatabaseConstants.MIN_CONNECTIONS, DatabaseConstants.MAX_CONNECTIONS)) {
            return #err(DatabaseConstants.ERROR_INVALID_CONNECTIONS)
        };
        #ok()
    };

    public func validateConnectionTimeout(timeout : Nat) : Result.Result<(), Text> {
        if (not isInRange(timeout, DatabaseConstants.MIN_CONNECTION_TIMEOUT, DatabaseConstants.MAX_CONNECTION_TIMEOUT)) {
            return #err(DatabaseConstants.ERROR_INVALID_CONNECTION_TIMEOUT)
        };
        #ok()
    };

    public func validateIdleTimeout(timeout : Nat) : Result.Result<(), Text> {
        if (not isInRange(timeout, DatabaseConstants.MIN_IDLE_TIMEOUT, DatabaseConstants.MAX_IDLE_TIMEOUT)) {
            return #err(DatabaseConstants.ERROR_INVALID_IDLE_TIMEOUT)
        };
        #ok()
    };

    public func validateKeepAlive(keepAlive : Nat) : Result.Result<(), Text> {
        if (not isInRange(keepAlive, DatabaseConstants.MIN_KEEP_ALIVE, DatabaseConstants.MAX_KEEP_ALIVE)) {
            return #err(DatabaseConstants.ERROR_INVALID_KEEP_ALIVE)
        };
        #ok()
    };

    // Network validation
    public func validateProtocol(protocol : Text) : Result.Result<(), Text> {
        let validProtocols = [
            NetworkConstants.PROTOCOL_HTTP,
            NetworkConstants.PROTOCOL_HTTPS,
            NetworkConstants.PROTOCOL_WS,
            NetworkConstants.PROTOCOL_WSS,
            NetworkConstants.PROTOCOL_TCP,
            NetworkConstants.PROTOCOL_UDP,
            NetworkConstants.PROTOCOL_ICMP,
            NetworkConstants.PROTOCOL_ARP,
            NetworkConstants.PROTOCOL_DNS,
            NetworkConstants.PROTOCOL_DHCP,
            NetworkConstants.PROTOCOL_FTP,
            NetworkConstants.PROTOCOL_SFTP,
            NetworkConstants.PROTOCOL_SSH,
            NetworkConstants.PROTOCOL_TELNET,
            NetworkConstants.PROTOCOL_SMTP,
            NetworkConstants.PROTOCOL_POP3,
            NetworkConstants.PROTOCOL_IMAP,
            NetworkConstants.PROTOCOL_RTMP,
            NetworkConstants.PROTOCOL_RTSP,
            NetworkConstants.PROTOCOL_SIP,
            NetworkConstants.PROTOCOL_H323,
            NetworkConstants.PROTOCOL_RTP,
            NetworkConstants.PROTOCOL_SRTP,
            NetworkConstants.PROTOCOL_DTLS,
            NetworkConstants.PROTOCOL_TLS,
            NetworkConstants.PROTOCOL_SSL
        ];
        if (not Array.find(validProtocols, func(p : Text) : Bool { p == protocol }) != null) {
            return #err(NetworkConstants.ERROR_INVALID_PROTOCOL)
        };
        #ok()
    };

    public func validatePort(port : Nat) : Result.Result<(), Text> {
        let validPorts = [
            NetworkConstants.PORT_HTTP,
            NetworkConstants.PORT_HTTPS,
            NetworkConstants.PORT_WS,
            NetworkConstants.PORT_WSS,
            NetworkConstants.PORT_FTP,
            NetworkConstants.PORT_SFTP,
            NetworkConstants.PORT_SSH,
            NetworkConstants.PORT_TELNET,
            NetworkConstants.PORT_SMTP,
            NetworkConstants.PORT_POP3,
            NetworkConstants.PORT_IMAP,
            NetworkConstants.PORT_RTMP,
            NetworkConstants.PORT_RTSP,
            NetworkConstants.PORT_SIP,
            NetworkConstants.PORT_H323,
            NetworkConstants.PORT_RTP,
            NetworkConstants.PORT_SRTP,
            NetworkConstants.PORT_DTLS,
            NetworkConstants.PORT_TLS,
            NetworkConstants.PORT_SSL
        ];
        if (not Array.find(validPorts, func(p : Nat) : Bool { p == port }) != null) {
            return #err(NetworkConstants.ERROR_INVALID_PORT)
        };
        #ok()
    };

    // Cache validation
    public func validateCacheSize(size : Nat) : Result.Result<(), Text> {
        if (not isInRange(size, CacheConstants.MIN_CACHE_SIZE, CacheConstants.MAX_CACHE_SIZE)) {
            return #err(CacheConstants.ERROR_INVALID_CACHE_SIZE)
        };
        #ok()
    };

    public func validateCacheEntries(entries : Nat) : Result.Result<(), Text> {
        if (not isInRange(entries, CacheConstants.MIN_CACHE_ENTRIES, CacheConstants.MAX_CACHE_ENTRIES)) {
            return #err(CacheConstants.ERROR_INVALID_CACHE_ENTRIES)
        };
        #ok()
    };

    public func validateCacheEntrySize(size : Nat) : Result.Result<(), Text> {
        if (not isInRange(size, CacheConstants.MIN_CACHE_ENTRY_SIZE, CacheConstants.MAX_CACHE_ENTRY_SIZE)) {
            return #err(CacheConstants.ERROR_INVALID_CACHE_ENTRY_SIZE)
        };
        #ok()
    };

    public func validateCacheTTL(ttl : Nat) : Result.Result<(), Text> {
        if (not isInRange(ttl, CacheConstants.MIN_CACHE_TTL, CacheConstants.MAX_CACHE_TTL)) {
            return #err(CacheConstants.ERROR_INVALID_CACHE_TTL)
        };
        #ok()
    };

    // Queue validation
    public func validateQueueSize(size : Nat) : Result.Result<(), Text> {
        if (not isInRange(size, QueueConstants.MIN_QUEUE_SIZE, QueueConstants.MAX_QUEUE_SIZE)) {
            return #err(QueueConstants.ERROR_INVALID_QUEUE_SIZE)
        };
        #ok()
    };

    public func validateQueueItems(items : Nat) : Result.Result<(), Text> {
        if (not isInRange(items, QueueConstants.MIN_QUEUE_ITEMS, QueueConstants.MAX_QUEUE_ITEMS)) {
            return #err(QueueConstants.ERROR_INVALID_QUEUE_ITEMS)
        };
        #ok()
    };

    public func validateQueueItemSize(size : Nat) : Result.Result<(), Text> {
        if (not isInRange(size, QueueConstants.MIN_QUEUE_ITEM_SIZE, QueueConstants.MAX_QUEUE_ITEM_SIZE)) {
            return #err(QueueConstants.ERROR_INVALID_QUEUE_ITEM_SIZE)
        };
        #ok()
    };

    public func validateQueueTimeout(timeout : Nat) : Result.Result<(), Text> {
        if (not isInRange(timeout, QueueConstants.MIN_QUEUE_TIMEOUT, QueueConstants.MAX_QUEUE_TIMEOUT)) {
            return #err(QueueConstants.ERROR_INVALID_QUEUE_TIMEOUT)
        };
        #ok()
    };

    public func validateQueueRetry(retry : Nat) : Result.Result<(), Text> {
        if (not isInRange(retry, QueueConstants.MIN_QUEUE_RETRY, QueueConstants.MAX_QUEUE_RETRY)) {
            return #err(QueueConstants.ERROR_INVALID_QUEUE_RETRY)
        };
        #ok()
    };

    public func validateQueueDelay(delay : Nat) : Result.Result<(), Text> {
        if (not isInRange(delay, QueueConstants.MIN_QUEUE_DELAY, QueueConstants.MAX_QUEUE_DELAY)) {
            return #err(QueueConstants.ERROR_INVALID_QUEUE_DELAY)
        };
        #ok()
    };

    public func validateQueueInterval(interval : Nat) : Result.Result<(), Text> {
        if (not isInRange(interval, QueueConstants.MIN_QUEUE_INTERVAL, QueueConstants.MAX_QUEUE_INTERVAL)) {
            return #err(QueueConstants.ERROR_INVALID_QUEUE_INTERVAL)
        };
        #ok()
    };

    public func validateQueuePriority(priority : Nat) : Result.Result<(), Text> {
        if (not isInRange(priority, QueueConstants.MIN_QUEUE_PRIORITY, QueueConstants.MAX_QUEUE_PRIORITY)) {
            return #err(QueueConstants.ERROR_INVALID_QUEUE_PRIORITY)
        };
        #ok()
    };

    public func validateQueueWeight(weight : Nat) : Result.Result<(), Text> {
        if (not isInRange(weight, QueueConstants.MIN_QUEUE_WEIGHT, QueueConstants.MAX_QUEUE_WEIGHT)) {
            return #err(QueueConstants.ERROR_INVALID_QUEUE_WEIGHT)
        };
        #ok()
    };

    public func validateQueueThreshold(threshold : Nat) : Result.Result<(), Text> {
        if (not isInRange(threshold, QueueConstants.MIN_QUEUE_THRESHOLD, QueueConstants.MAX_QUEUE_THRESHOLD)) {
            return #err(QueueConstants.ERROR_INVALID_QUEUE_THRESHOLD)
        };
        #ok()
    };

    public func validateQueueStatus(status : Text) : Result.Result<(), Text> {
        let validStatuses = [
            QueueConstants.QUEUE_STATUS_PENDING,
            QueueConstants.QUEUE_STATUS_PROCESSING,
            QueueConstants.QUEUE_STATUS_COMPLETED,
            QueueConstants.QUEUE_STATUS_FAILED,
            QueueConstants.QUEUE_STATUS_CANCELLED,
            QueueConstants.QUEUE_STATUS_TIMEOUT,
            QueueConstants.QUEUE_STATUS_RETRY,
            QueueConstants.QUEUE_STATUS_DELAYED,
            QueueConstants.QUEUE_STATUS_SCHEDULED,
            QueueConstants.QUEUE_STATUS_PAUSED,
            QueueConstants.QUEUE_STATUS_RESUMED,
            QueueConstants.QUEUE_STATUS_STOPPED,
            QueueConstants.QUEUE_STATUS_STARTED,
            QueueConstants.QUEUE_STATUS_RESTARTED,
            QueueConstants.QUEUE_STATUS_CLEARED,
            QueueConstants.QUEUE_STATUS_DRAINED,
            QueueConstants.QUEUE_STATUS_FLUSHED,
            QueueConstants.QUEUE_STATUS_RESET,
            QueueConstants.QUEUE_STATUS_INITIALIZED,
            QueueConstants.QUEUE_STATUS_DESTROYED
        ];
        if (not Array.find(validStatuses, func(s : Text) : Bool { s == status }) != null) {
            return #err(QueueConstants.ERROR_INVALID_QUEUE_STATUS)
        };
        #ok()
    };

    public func validateQueueType(type : Text) : Result.Result<(), Text> {
        let validTypes = [
            QueueConstants.QUEUE_TYPE_FIFO,
            QueueConstants.QUEUE_TYPE_LIFO,
            QueueConstants.QUEUE_TYPE_PRIORITY,
            QueueConstants.QUEUE_TYPE_WEIGHTED,
            QueueConstants.QUEUE_TYPE_DELAY,
            QueueConstants.QUEUE_TYPE_SCHEDULED,
            QueueConstants.QUEUE_TYPE_RETRY,
            QueueConstants.QUEUE_TYPE_DEAD_LETTER,
            QueueConstants.QUEUE_TYPE_BATCH,
            QueueConstants.QUEUE_TYPE_STREAM,
            QueueConstants.QUEUE_TYPE_PUBLISH_SUBSCRIBE,
            QueueConstants.QUEUE_TYPE_REQUEST_REPLY,
            QueueConstants.QUEUE_TYPE_WORK_QUEUE,
            QueueConstants.QUEUE_TYPE_TASK_QUEUE,
            QueueConstants.QUEUE_TYPE_JOB_QUEUE,
            QueueConstants.QUEUE_TYPE_MESSAGE_QUEUE,
            QueueConstants.QUEUE_TYPE_EVENT_QUEUE,
            QueueConstants.QUEUE_TYPE_COMMAND_QUEUE,
            QueueConstants.QUEUE_TYPE_NOTIFICATION_QUEUE,
            QueueConstants.QUEUE_TYPE_ALERT_QUEUE
        ];
        if (not Array.find(validTypes, func(t : Text) : Bool { t == type }) != null) {
            return #err(QueueConstants.ERROR_INVALID_QUEUE_TYPE)
        };
        #ok()
    };
}; 