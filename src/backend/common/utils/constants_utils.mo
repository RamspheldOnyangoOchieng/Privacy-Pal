

module {
    // Time utilities
    public func isExpired(timestamp : Time.Time, ttl : Nat) : Bool {
        Time.now() > timestamp + ttl
    };

    public func isFuture(timestamp : Time.Time) : Bool {
        Time.now() < timestamp
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

    // Text utilities
    public func isValidLength(text : Text, minLength : Nat, maxLength : Nat) : Bool {
        let length = Text.size(text);
        length >= minLength and length <= maxLength
    };

    public func matchesPattern(text : Text, pattern : Text) : Bool {
        // TODO: Implement regex pattern matching
        true
    };

    // Number utilities
    public func isInRange(value : Nat, min : Nat, max : Nat) : Bool {
        value >= min and value <= max
    };

    public func isInRangeInt(value : Int, min : Int, max : Int) : Bool {
        value >= min and value <= max
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
            #err("Invalid principal: " # text)
        }
    };

    // Option utilities
    public func isSome<T>(option : Option.Option<T>) : Bool {
        Option.isSome(option)
    };

    public func isNone<T>(option : Option.Option<T>) : Bool {
        Option.isNone(option)
    };

    public func getOrElse<T>(option : Option.Option<T>, defaultValue : T) : T {
        Option.get(option, defaultValue)
    };

    // Result utilities
    public func isOk<T, E>(result : Result.Result<T, E>) : Bool {
        switch (result) {
            case (#ok(_)) { true };
            case (#err(_)) { false }
        }
    };

    public func isErr<T, E>(result : Result.Result<T, E>) : Bool {
        switch (result) {
            case (#ok(_)) { false };
            case (#err(_)) { true }
        }
    };

    public func getOk<T, E>(result : Result.Result<T, E>) : ?T {
        switch (result) {
            case (#ok(value)) { ?value };
            case (#err(_)) { null }
        }
    };

    public func getErr<T, E>(result : Result.Result<T, E>) : ?E {
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
        Array.find(array, func(x : T) : Bool { equal(x, element) }) != null
    };

    public func unique<T>(array : [T], equal : (T, T) -> Bool) : [T] {
        let list = List.fromArray(array);
        let uniqueList = List.filter(list, func(x : T) : Bool {
            List.find(list, func(y : T) : Bool { equal(x, y) }) != null
        });
        List.toArray(uniqueList)
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

    public func unique<T>(list : List.List<T>, equal : (T, T) -> Bool) : List.List<T> {
        List.filter(list, func(x : T) : Bool {
            List.find(list, func(y : T) : Bool { equal(x, y) }) != null
        })
    };

    // HashMap utilities
    public func isEmpty<K, V>(map : HashMap.HashMap<K, V>, equal : (K, K) -> Bool) : Bool {
        HashMap.size(map) == 0
    };

    public func isNotEmpty<K, V>(map : HashMap.HashMap<K, V>, equal : (K, K) -> Bool) : Bool {
        HashMap.size(map) > 0
    };

    public func contains<K, V>(map : HashMap.HashMap<K, V>, key : K, equal : (K, K) -> Bool) : Bool {
        HashMap.get(map, equal, key) != null
    };

    public func getOrElse<K, V>(map : HashMap.HashMap<K, V>, key : K, equal : (K, K) -> Bool, defaultValue : V) : V {
        switch (HashMap.get(map, equal, key)) {
            case (?value) { value };
            case null { defaultValue }
        }
    };

    // Debug utilities
    public func log(message : Text) : () {
        Debug.print(message)
    };

    public func logError(message : Text) : () {
        Debug.print("ERROR: " # message)
    };

    public func logWarning(message : Text) : () {
        Debug.print("WARNING: " # message)
    };

    public func logInfo(message : Text) : () {
        Debug.print("INFO: " # message)
    };

    public func logDebug(message : Text) : () {
        Debug.print("DEBUG: " # message)
    };

    public func logTrace(message : Text) : () {
        Debug.print("TRACE: " # message)
    };
}; 