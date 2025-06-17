import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Time "mo:base/Time";
import Array "mo:base/Array";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Types "../types";
import Constants "../constants";

module Utils {
    // Text utilities
    public func isEmpty(text : Text) : Bool {
        Text.size(text) == 0
    };

    public func isNotEmpty(text : Text) : Bool {
        Text.size(text) > 0
    };

    public func contains(text : Text, substring : Text) : Bool {
        Text.contains(text, #text substring)
    };

    public func startsWith(text : Text, prefix : Text) : Bool {
        Text.startsWith(text, #text prefix)
    };

    public func endsWith(text : Text, suffix : Text) : Bool {
        Text.endsWith(text, #text suffix)
    };

    // Number utilities
    public func isPositive(n : Nat) : Bool {
        n > 0
    };

    public func isNegative(n : Int) : Bool {
        n < 0
    };

    public func max(a : Nat, b : Nat) : Nat {
        if (a > b) { a } else { b }
    };

    public func min(a : Nat, b : Nat) : Nat {
        if (a < b) { a } else { b }
    };

    // Time utilities
    public func isExpired(timestamp : Time.Time, ttl : Nat) : Bool {
        Time.now() - timestamp > ttl
    };

    public func isInFuture(timestamp : Time.Time) : Bool {
        timestamp > Time.now()
    };

    public func addSeconds(timestamp : Time.Time, seconds : Nat) : Time.Time {
        timestamp + seconds
    };

    public func subtractSeconds(timestamp : Time.Time, seconds : Nat) : Time.Time {
        if (timestamp > seconds) {
            timestamp - seconds
        } else {
            0
        }
    };

    // Principal utilities
    public func isAnonymous(principal : Principal) : Bool {
        Principal.isAnonymous(principal)
    };

    public func principalToText(principal : Principal) : Text {
        Principal.toText(principal)
    };

    public func textToPrincipal(text : Text) : ?Principal {
        try {
            ?Principal.fromText(text)
        } catch {
            null
        }
    };

    // Option utilities
    public func isSome<T>(option : Types.Option<T>) : Bool {
        Option.isSome(option)
    };

    public func isNone<T>(option : Types.Option<T>) : Bool {
        Option.isNull(option)
    };

    public func getOrElse<T>(option : Types.Option<T>, defaultValue : T) : T {
        Option.get(option, defaultValue)
    };

    // Result utilities
    public func isOk<T>(result : Types.Result<T>) : Bool {
        switch (result) {
            case (#ok(_)) { true };
            case (#err(_)) { false }
        }
    };

    public func isErr<T>(result : Types.Result<T>) : Bool {
        switch (result) {
            case (#ok(_)) { false };
            case (#err(_)) { true }
        }
    };

    public func getOk<T>(result : Types.Result<T>) : ?T {
        switch (result) {
            case (#ok(value)) { ?value };
            case (#err(_)) { null }
        }
    };

    public func getErr<T>(result : Types.Result<T>) : ?Text {
        switch (result) {
            case (#ok(_)) { null };
            case (#err(error)) { ?error }
        }
    };

    // Array utilities
    public func isEmpty<T>(array : [T]) : Bool {
        Array.size(array) == 0
    };

    public func isNotEmpty<T>(array : [T]) : Bool {
        Array.size(array) > 0
    };

    public func contains<T>(array : [T], element : T, equal : (T, T) -> Bool) : Bool {
        Array.some(array, func(x : T) : Bool { equal(x, element) })
    };

    public func unique<T>(array : [T], equal : (T, T) -> Bool) : [T] {
        let uniqueArray = Array.filter(array, func(x : T) : Bool {
            not contains(array, x, equal)
        });
        uniqueArray
    };

    // List utilities
    public func isEmpty<T>(list : List.List<T>) : Bool {
        List.size(list) == 0
    };

    public func isNotEmpty<T>(list : List.List<T>) : Bool {
        List.size(list) > 0
    };

    public func contains<T>(list : List.List<T>, element : T, equal : (T, T) -> Bool) : Bool {
        List.some(list, func(x : T) : Bool { equal(x, element) })
    };

    public func unique<T>(list : List.List<T>, equal : (T, T) -> Bool) : List.List<T> {
        let uniqueList = List.filter(list, func(x : T) : Bool {
            not contains(list, x, equal)
        });
        uniqueList
    };

    // Validation utilities
    public func isValidEmail(email : Text) : Bool {
        let pattern = Constants.EMAIL_PATTERN;
        Text.matches(email, #text pattern)
    };

    public func isValidPhone(phone : Text) : Bool {
        let pattern = Constants.PHONE_PATTERN;
        Text.matches(phone, #text pattern)
    };

    public func isValidUrl(url : Text) : Bool {
        let pattern = Constants.URL_PATTERN;
        Text.matches(url, #text pattern)
    };

    public func isValidUsername(username : Text) : Bool {
        let pattern = Constants.USERNAME_PATTERN;
        Text.matches(username, #text pattern)
    };

    public func isValidPassword(password : Text) : Bool {
        let pattern = Constants.PASSWORD_PATTERN;
        Text.matches(password, #text pattern)
    };

    public func isValidMimeType(mimeType : Text) : Bool {
        let pattern = Constants.MIME_TYPE_PATTERN;
        Text.matches(mimeType, #text pattern)
    };

    // Error utilities
    public func createError(message : Text) : Types.Error {
        message
    };

    public func getErrorMessage(error : Types.Error) : Text {
        error
    };

    // Debug utilities
    public func debug(message : Text) : () {
        // Implement debug logging
    };

    public func debugWithData<T>(message : Text, data : T) : () {
        // Implement debug logging with data
    };

    // File utilities
    public func isValidFileSize(size : Nat) : Bool {
        size > 0 and size <= Constants.MAX_FILE_SIZE
    };

    public func isValidChunkSize(size : Nat) : Bool {
        size > 0 and size <= Constants.MAX_CHUNK_SIZE
    };

    public func isValidFileName(name : Text) : Bool {
        let pattern = Constants.FILE_NAME_PATTERN;
        Text.matches(name, #text pattern)
    };

    public func isValidFilePath(path : Text) : Bool {
        let pattern = Constants.FILE_PATH_PATTERN;
        Text.matches(path, #text pattern)
    };

    public func isValidFileUrl(url : Text) : Bool {
        let pattern = Constants.FILE_URL_PATTERN;
        Text.matches(url, #text pattern)
    };

    // Storage utilities
    public func isValidStorageAction(action : Types.StorageAction) : Bool {
        switch (action) {
            case (#upload) { true };
            case (#download) { true };
            case (#delete) { true };
            case (#update) { true };
            case (#share) { true }
        }
    };

    public func isValidStorageMetrics(metrics : Types.StorageMetrics) : Bool {
        metrics.uploads >= 0 and
        metrics.downloads >= 0 and
        metrics.deletes >= 0
    };

    public func isValidStorageHistory(history : Types.StorageHistory) : Bool {
        isValidStorageAction(history.action)
    };

    // Cache utilities
    public func isValidCacheEntry<T>(entry : Types.CacheEntry<T>) : Bool {
        entry.ttl > 0
    };

    public func isValidCacheStats(stats : Types.CacheStats) : Bool {
        stats.hits >= 0 and
        stats.misses >= 0
    };

    // Queue utilities
    public func isValidQueueItem<T>(item : Types.QueueItem<T>) : Bool {
        item.priority >= 0 and
        item.priority <= Constants.MAX_QUEUE_PRIORITY and
        item.retries <= Constants.MAX_QUEUE_RETRIES
    };

    public func isValidQueueStatus(status : Types.QueueStatus) : Bool {
        switch (status) {
            case (#pending) { true };
            case (#processing) { true };
            case (#completed) { true };
            case (#failed) { true }
        }
    };

    public func isValidQueueStats(stats : Types.QueueStats) : Bool {
        stats.enqueued >= 0 and
        stats.dequeued >= 0 and
        stats.failed >= 0
    };

    public func isValidQueueHistory(history : Types.QueueHistory) : Bool {
        isValidQueueAction(history.action)
    };

    public func isValidQueueAction(action : Types.QueueAction) : Bool {
        switch (action) {
            case (#enqueue) { true };
            case (#dequeue) { true };
            case (#fail) { true }
        }
    };

    // Security utilities
    public func isValidSecurityEvent(event : Types.SecurityEvent) : Bool {
        isValidSecurityEventType(event.type)
    };

    public func isValidSecurityEventType(type : Types.SecurityEventType) : Bool {
        switch (type) {
            case (#accessGranted) { true };
            case (#accessDenied) { true };
            case (#rateLimitExceeded) { true };
            case (#principalBlacklisted) { true };
            case (#principalWhitelisted) { true };
            case (#rateLimitSet) { true };
            case (#accessControlSet) { true }
        }
    };

    public func isValidSecurityLog(log : Types.SecurityLog) : Bool {
        isValidSecurityEvent(log.event)
    };

    // Integration utilities
    public func isValidIntegrationHistory(history : Types.IntegrationHistory) : Bool {
        isNotEmpty(history.source) and
        isNotEmpty(history.target) and
        isNotEmpty(history.action) and
        isNotEmpty(history.status)
    };

    // Analytics utilities
    public func isValidAnalyticsAction(action : Types.AnalyticsAction) : Bool {
        switch (action) {
            case (#reportCreated) { true };
            case (#reportViewed) { true };
            case (#submissionMade) { true };
            case (#commentPosted) { true };
            case (#attachmentUploaded) { true }
        }
    };

    public func isValidAnalyticsHistory(history : Types.AnalyticsHistory) : Bool {
        isValidAnalyticsAction(history.action)
    };

    // Filter utilities
    public func isValidFilter(filter : Types.Filter) : Bool {
        isNotEmpty(filter.name) and
        isNotEmpty(filter.conditions) and
        isValidFilterOperator(filter.operator)
    };

    public func isValidFilterCondition(condition : Types.FilterCondition) : Bool {
        isNotEmpty(condition.field) and
        isValidFilterOperator(condition.operator)
    };

    public func isValidFilterOperator(operator : Types.FilterOperator) : Bool {
        switch (operator) {
            case (#equals) { true };
            case (#contains) { true };
            case (#startsWith) { true };
            case (#endsWith) { true };
            case (#greaterThan) { true };
            case (#lessThan) { true };
            case (#between) { true };
            case (#inList) { true };
            case (#regex) { true }
        }
    };

    public func isValidFilterTemplate(template : Types.FilterTemplate) : Bool {
        isNotEmpty(template.name) and
        isNotEmpty(template.filters)
    };

    public func isValidFilterHistory(history : Types.FilterHistory) : Bool {
        isNotEmpty(history.userId) and
        isNotEmpty(history.filterId) and
        isNotEmpty(history.action)
    };

    // Sort utilities
    public func isValidSortBy(sortBy : Types.SortBy) : Bool {
        isNotEmpty(sortBy.field) and
        isValidSortDirection(sortBy.direction)
    };

    public func isValidSortDirection(direction : Types.SortDirection) : Bool {
        switch (direction) {
            case (#ascending) { true };
            case (#descending) { true }
        }
    };
}; 