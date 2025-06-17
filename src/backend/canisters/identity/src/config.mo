

actor class ConfigCanister() {
    // State variables
    private stable var configurations : HashMap.HashMap<Text, Configuration> = HashMap.new();
    private stable var environmentSettings : HashMap.HashMap<Text, EnvironmentSetting> = HashMap.new();
    private stable var featureFlags : HashMap.HashMap<Text, FeatureFlag> = HashMap.new();
    private stable var configHistory : HashMap.HashMap<Text, [ConfigChange]> = HashMap.new();
    private stable var configValidation : HashMap.HashMap<Text, ConfigValidation> = HashMap.new();

    // Types
    type Configuration = {
        id : Text;
        name : Text;
        value : ConfigValue;
        type : ConfigType;
        description : Text;
        lastModified : Time.Time;
        modifiedBy : Principal;
        version : Nat;
    };

    type ConfigValue = {
        #String : Text;
        #Number : Float;
        #Boolean : Bool;
        #Array : [ConfigValue];
        #Object : [(Text, ConfigValue)];
    };

    type ConfigType = {
        #SYSTEM;
        #APPLICATION;
        #USER;
        #CUSTOM;
    };

    type EnvironmentSetting = {
        id : Text;
        name : Text;
        value : Text;
        environment : Environment;
        isSecret : Bool;
        lastModified : Time.Time;
    };

    type Environment = {
        #DEVELOPMENT;
        #STAGING;
        #PRODUCTION;
        #CUSTOM;
    };

    type FeatureFlag = {
        id : Text;
        name : Text;
        enabled : Bool;
        conditions : [FeatureCondition];
        rolloutPercentage : Nat;
        lastModified : Time.Time;
    };

    type FeatureCondition = {
        field : Text;
        operator : Operator;
        value : Text;
    };

    type Operator = {
        #EQUALS;
        #NOT_EQUALS;
        #CONTAINS;
        #GREATER_THAN;
        #LESS_THAN;
    };

    type ConfigChange = {
        id : Text;
        configId : Text;
        oldValue : ConfigValue;
        newValue : ConfigValue;
        timestamp : Time.Time;
        changedBy : Principal;
        reason : Text;
    };

    type ConfigValidation = {
        id : Text;
        configId : Text;
        rules : [ValidationRule];
        enabled : Bool;
    };

    type ValidationRule = {
        field : Text;
        type : ValidationType;
        required : Bool;
        minLength : ?Nat;
        maxLength : ?Nat;
        pattern : ?Text;
        customValidation : ?Text;
    };

    type ValidationType = {
        #STRING;
        #NUMBER;
        #BOOLEAN;
        #ARRAY;
        #OBJECT;
    };

    // Private helper functions
    private func generateConfigId() : Text {
        "config-" # Nat.toText(Time.now());
    };

    private func validateConfigValue(value : ConfigValue, validation : ConfigValidation) : Bool {
        for (rule in validation.rules.vals()) {
            switch (value) {
                case (#String(s)) {
                    if (rule.type != #STRING) {
                        return false;
                    };
                    if (rule.required and s == "") {
                        return false;
                    };
                    switch (rule.minLength) {
                        case (?min) {
                            if (s.size() < min) {
                                return false;
                            };
                        };
                        case null {};
                    };
                    switch (rule.maxLength) {
                        case (?max) {
                            if (s.size() > max) {
                                return false;
                            };
                        };
                        case null {};
                    };
                    switch (rule.pattern) {
                        case (?pattern) {
                            if (not Text.contains(s, #text pattern)) {
                                return false;
                            };
                        };
                        case null {};
                    };
                };
                case (#Number(n)) {
                    if (rule.type != #NUMBER) {
                        return false;
                    };
                };
                case (#Boolean(b)) {
                    if (rule.type != #BOOLEAN) {
                        return false;
                    };
                };
                case (#Array(a)) {
                    if (rule.type != #ARRAY) {
                        return false;
                    };
                };
                case (#Object(o)) {
                    if (rule.type != #OBJECT) {
                        return false;
                    };
                };
            };
        };
        true;
    };

    private func recordConfigChange(config : Configuration, oldValue : ConfigValue, reason : Text) {
        let change = {
            id = "change-" # Nat.toText(Time.now());
            configId = config.id;
            oldValue = oldValue;
            newValue = config.value;
            timestamp = Time.now();
            changedBy = config.modifiedBy;
            reason = reason;
        };

        let history = Option.get(HashMap.get(configHistory, Principal.equal, Principal.hash, config.id), []);
        let updatedHistory = Array.append(history, [change]);
        ignore HashMap.put(configHistory, Principal.equal, Principal.hash, config.id, updatedHistory);
    };

    // Public shared functions
    public shared(msg) func setConfiguration(config : Configuration) : async () {
        switch (HashMap.get(configValidation, Principal.equal, Principal.hash, config.id)) {
            case (?validation) {
                if (not validateConfigValue(config.value, validation)) {
                    throw Error.reject("Configuration validation failed");
                };
            };
            case null {};
        };

        switch (HashMap.get(configurations, Principal.equal, Principal.hash, config.id)) {
            case (?oldConfig) {
                recordConfigChange(config, oldConfig.value, "Configuration updated");
            };
            case null {};
        };

        ignore HashMap.put(configurations, Principal.equal, Principal.hash, config.id, config);
    };

    public shared(msg) func setEnvironmentSetting(setting : EnvironmentSetting) : async () {
        ignore HashMap.put(environmentSettings, Principal.equal, Principal.hash, setting.id, setting);
    };

    public shared(msg) func setFeatureFlag(flag : FeatureFlag) : async () {
        ignore HashMap.put(featureFlags, Principal.equal, Principal.hash, flag.id, flag);
    };

    public shared(msg) func setConfigValidation(validation : ConfigValidation) : async () {
        ignore HashMap.put(configValidation, Principal.equal, Principal.hash, validation.configId, validation);
    };

    public query func getConfiguration(configId : Text) : async ?Configuration {
        HashMap.get(configurations, Principal.equal, Principal.hash, configId);
    };

    public query func getEnvironmentSetting(settingId : Text) : async ?EnvironmentSetting {
        HashMap.get(environmentSettings, Principal.equal, Principal.hash, settingId);
    };

    public query func isFeatureEnabled(featureId : Text, context : [Text]) : async Bool {
        switch (HashMap.get(featureFlags, Principal.equal, Principal.hash, featureId)) {
            case (?flag) {
                if (not flag.enabled) {
                    return false;
                };

                var conditionsMet = true;
                for (condition in flag.conditions.vals()) {
                    let fieldValue = switch (condition.field) {
                        case ("user") { context[0] };
                        case ("environment") { context[1] };
                        case _ { "" };
                    };

                    let matches = switch (condition.operator) {
                        case (#EQUALS) { fieldValue == condition.value };
                        case (#NOT_EQUALS) { fieldValue != condition.value };
                        case (#CONTAINS) { Text.contains(fieldValue, #text condition.value) };
                        case (#GREATER_THAN) { Nat.greater(Nat.fromText(fieldValue), Nat.fromText(condition.value)) };
                        case (#LESS_THAN) { Nat.less(Nat.fromText(fieldValue), Nat.fromText(condition.value)) };
                    };

                    if (not matches) {
                        conditionsMet := false;
                    };
                };

                conditionsMet;
            };
            case null {
                false;
            };
        };
    };

    public query func getConfigHistory(configId : Text) : async ?[ConfigChange] {
        HashMap.get(configHistory, Principal.equal, Principal.hash, configId);
    };
}; 