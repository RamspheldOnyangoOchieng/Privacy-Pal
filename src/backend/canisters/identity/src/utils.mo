
import Int "mo:base/Int";
import List "mo:base/List";
import Result "mo:base/Result";
import Error "mo:base/Error";

module {
    public func generateSessionId() : Text {
        let timestamp = Nat.toText(Time.now());
        let random = Nat.toText(Nat.random(1000000));
        return timestamp # "-" # random;
    };

    public func generateDeviceId() : Text {
        let timestamp = Nat.toText(Time.now());
        let random = Nat.toText(Nat.random(1000000));
        return "device-" # timestamp # "-" # random;
    };

    public func calculateTrustScore(factors: [Types.TrustFactor]) : Float {
        var totalScore : Float = 0.0;
        var totalWeight : Float = 0.0;
        
        for (factor in factors.vals()) {
            totalScore += factor.value * factor.weight;
            totalWeight += factor.weight;
        };
        
        return if (totalWeight > 0.0) {
            totalScore / totalWeight
        } else {
            0.0
        };
    };

    public func validateEmail(email: Text) : Bool {
        let emailRegex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
        // TODO: Implement proper email validation using regex
        return true;
    };

    public func isSessionExpired(session: Types.Session) : Bool {
        Time.now() > session.expiresAt
    };

    public func updateTrustLevel(score: Float) : Types.TrustLevel {
        if (score >= 0.8) {
            #High
        } else if (score >= 0.5) {
            #Medium
        } else if (score >= 0.2) {
            #Low
        } else {
            #Blocked
        }
    };

    public func formatSecurityLog(log: Types.SecurityLog) : Text {
        let timestamp = Nat.toText(log.timestamp);
        let event = switch(log.event) {
            case (#LoginAttempt) "Login Attempt";
            case (#PasswordChange) "Password Change";
            case (#DeviceAdded) "Device Added";
            case (#DeviceRemoved) "Device Removed";
            case (#TrustScoreUpdate) "Trust Score Update";
            case (#SecurityAlert) "Security Alert";
        };
        let severity = switch(log.severity) {
            case (#Low) "Low";
            case (#Medium) "Medium";
            case (#High) "High";
            case (#Critical) "Critical";
        };
        return timestamp # " - " # severity # " - " # event # ": " # log.details;
    };

    // ID Generation
    public func generateId(prefix : Text) : Text {
        let randomBytes = Random.blob(16);
        let id = Blob.toArray(randomBytes);
        let hexId = Array.foldLeft<Nat8, Text>(
            id,
            "",
            func (acc : Text, byte : Nat8) : Text {
                acc # Nat8.toText(byte)
            }
        );
        prefix # "-" # hexId
    };

    // Validation
    public func validateUsername(username : Text) : Bool {
        let minLength = 3;
        let maxLength = 30;
        let length = Text.size(username);
        length >= minLength and length <= maxLength
    };

    public func validatePassword(password : Text) : Bool {
        let minLength = 8;
        let hasUpperCase = Text.contains(password, #char 'A');
        let hasLowerCase = Text.contains(password, #char 'a');
        let hasNumber = Text.contains(password, #char '0');
        let hasSpecialChar = Text.contains(password, #char '!');
        
        Text.size(password) >= minLength and
        hasUpperCase and
        hasLowerCase and
        hasNumber and
        hasSpecialChar
    };

    // Time Utilities
    public func isExpired(timestamp : Int) : Bool {
        Time.now() > timestamp
    };

    public func getExpirationTime(durationInSeconds : Nat) : Int {
        Time.now() + (durationInSeconds * 1_000_000_000)
    };

    // String Manipulation
    public func truncateText(text : Text, maxLength : Nat) : Text {
        if (Text.size(text) <= maxLength) {
            text
        } else {
            Text.substring(text, 0, maxLength) # "..."
        }
    };

    public func sanitizeText(text : Text) : Text {
        // TODO: Implement text sanitization
        text
    };

    // Array Utilities
    public func findFirst<T>(array : [T], predicate : T -> Bool) : ?T {
        Array.find(array, predicate)
    };

    public func filter<T>(array : [T], predicate : T -> Bool) : [T] {
        Array.filter(array, predicate)
    };

    public func map<T, U>(array : [T], transform : T -> U) : [U] {
        Array.map(array, transform)
    };

    // Option Utilities
    public func unwrapOr<T>(option : ?T, defaultValue : T) : T {
        switch (option) {
            case (null) { defaultValue };
            case (?value) { value };
        }
    };

    public func isSome<T>(option : ?T) : Bool {
        switch (option) {
            case (null) { false };
            case (_) { true };
        }
    };

    // Principal Utilities
    public func isAnonymous(principal : Principal) : Bool {
        Principal.isAnonymous(principal)
    };

    public func toText(principal : Principal) : Text {
        Principal.toText(principal)
    };

    // Error Handling
    public func handleError<T>(result : { #ok : T; #err : Text }) : T {
        switch (result) {
            case (#ok(value)) { value };
            case (#err(message)) {
                Debug.trap("Error: " # message)
            };
        }
    };

    // Logging
    public func log(message : Text) {
        Debug.print(message)
    };

    public func logError(message : Text) {
        Debug.print("ERROR: " # message)
    };

    public func logWarning(message : Text) {
        Debug.print("WARNING: " # message)
    };

    public func logInfo(message : Text) {
        Debug.print("INFO: " # message)
    };

    // Metrics
    public func calculateAverage(numbers : [Float]) : Float {
        if (Array.size(numbers) == 0) {
            return 0.0
        };
        
        let sum = Array.foldLeft<Float, Float>(
            numbers,
            0.0,
            func (acc : Float, num : Float) : Float {
                acc + num
            }
        );
        
        sum / Float.fromInt(Array.size(numbers))
    };

    public func calculatePercentage(value : Float, total : Float) : Float {
        if (total == 0.0) {
            return 0.0
        };
        (value / total) * 100.0
    };

    // Constants
    public let DEFAULT_PAGE_SIZE = 20;
    public let MAX_PAGE_SIZE = 100;
    public let DEFAULT_CACHE_DURATION = 300; // 5 minutes in seconds
    public let MAX_RETRY_ATTEMPTS = 3;
    public let DEFAULT_TIMEOUT = 30; // 30 seconds

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

    public func isZero(n : Nat) : Bool {
        n == 0
    };

    public func max(a : Nat, b : Nat) : Nat {
        if (a > b) a else b
    };

    public func min(a : Nat, b : Nat) : Nat {
        if (a < b) a else b
    };

    // Time utilities
    public func isExpired(timestamp : Time.Time) : Bool {
        Time.now() > timestamp
    };

    public func isFuture(timestamp : Time.Time) : Bool {
        Time.now() < timestamp
    };

    public func addSeconds(timestamp : Time.Time, seconds : Nat) : Time.Time {
        timestamp + (seconds * 1_000_000_000)
    };

    public func subtractSeconds(timestamp : Time.Time, seconds : Nat) : Time.Time {
        timestamp - (seconds * 1_000_000_000)
    };

    // Principal utilities
    public func isAnonymous(principal : Principal) : Bool {
        Principal.isAnonymous(principal)
    };

    public func toText(principal : Principal) : Text {
        Principal.toText(principal)
    };

    public func fromText(text : Text) : Result.Result<Principal, Text> {
        try {
            #ok(Principal.fromText(text))
        } catch (e) {
            #err("Invalid principal: " # Error.message(e))
        }
    };

    // Option utilities
    public func isSome<T>(option : Option.Option<T>) : Bool {
        Option.isSome(option)
    };

    public func isNone<T>(option : Option.Option<T>) : Bool {
        Option.isNone(option)
    };

    public func getOrElse<T>(option : Option.Option<T>, default : T) : T {
        Option.get(option, default)
    };

    // Result utilities
    public func isOk<T, E>(result : Result.Result<T, E>) : Bool {
        Result.isOk(result)
    };

    public func isErr<T, E>(result : Result.Result<T, E>) : Bool {
        Result.isErr(result)
    };

    public func getOrElse<T, E>(result : Result.Result<T, E>, default : T) : T {
        switch (result) {
            case (#ok(value)) value;
            case (#err(_)) default;
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
        Array.find(array, func(x : T) : Bool { equal(x, element) }) != null
    };

    // List utilities
    public func isEmpty<T>(list : List.List<T>) : Bool {
        List.size(list) == 0
    };

    public func isNotEmpty<T>(list : List.List<T>) : Bool {
        List.size(list) > 0
    };

    public func contains<T>(list : List.List<T>, element : T, equal : (T, T) -> Bool) : Bool {
        List.find(list, func(x : T) : Bool { equal(x, element) }) != null
    };

    // Validation utilities
    public func isValidEmail(email : Text) : Bool {
        let pattern = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
        Text.matches(email, #text pattern)
    };

    public func isValidPhone(phone : Text) : Bool {
        let pattern = "^\\+?[1-9]\\d{1,14}$";
        Text.matches(phone, #text pattern)
    };

    public func isValidUrl(url : Text) : Bool {
        let pattern = "^(https?|ftp)://[^\\s/$.?#].[^\\s]*$";
        Text.matches(url, #text pattern)
    };

    public func isValidUsername(username : Text) : Bool {
        let pattern = "^[a-zA-Z0-9_-]{3,16}$";
        Text.matches(username, #text pattern)
    };

    public func isValidPassword(password : Text) : Bool {
        let pattern = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$";
        Text.matches(password, #text pattern)
    };

    // Error utilities
    public func createError(code : Nat, message : Text, details : ?Text) : Types.Error {
        {
            code = code;
            message = message;
            details = details;
        }
    };

    public func getErrorMessage(error : Types.Error) : Text {
        switch (error.details) {
            case (null) error.message;
            case (?details) error.message # ": " # details;
        }
    };

    // Debug utilities
    public func debug<T>(value : T) : () {
        Debug.print(debug_show(value))
    };

    public func debugError(error : Types.Error) : () {
        Debug.print("Error: " # getErrorMessage(error))
    };
}; 