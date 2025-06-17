module {
    // Text validation constants
    public let MIN_TEXT_LENGTH : Nat = 1;
    public let MAX_TEXT_LENGTH : Nat = 1000;
    public let MIN_NAME_LENGTH : Nat = 2;
    public let MAX_NAME_LENGTH : Nat = 100;
    public let MIN_DESCRIPTION_LENGTH : Nat = 10;
    public let MAX_DESCRIPTION_LENGTH : Nat = 5000;
    public let MIN_COMMENT_LENGTH : Nat = 1;
    public let MAX_COMMENT_LENGTH : Nat = 1000;
    public let MIN_TITLE_LENGTH : Nat = 3;
    public let MAX_TITLE_LENGTH : Nat = 200;
    public let MIN_SUMMARY_LENGTH : Nat = 10;
    public let MAX_SUMMARY_LENGTH : Nat = 500;

    // Number validation constants
    public let MIN_NUMBER : Int = -9223372036854775808;
    public let MAX_NUMBER : Int = 9223372036854775807;
    public let MIN_POSITIVE_NUMBER : Nat = 0;
    public let MAX_POSITIVE_NUMBER : Nat = 18446744073709551615;
    public let MIN_NEGATIVE_NUMBER : Int = -9223372036854775808;
    public let MAX_NEGATIVE_NUMBER : Int = -1;
    public let MIN_DECIMAL_PLACES : Nat = 0;
    public let MAX_DECIMAL_PLACES : Nat = 18;

    // Date validation constants
    public let MIN_DATE : Int = 0;
    public let MAX_DATE : Int = 9223372036854775807;
    public let MIN_YEAR : Int = 1900;
    public let MAX_YEAR : Int = 2100;
    public let MIN_MONTH : Nat = 1;
    public let MAX_MONTH : Nat = 12;
    public let MIN_DAY : Nat = 1;
    public let MAX_DAY : Nat = 31;
    public let MIN_HOUR : Nat = 0;
    public let MAX_HOUR : Nat = 23;
    public let MIN_MINUTE : Nat = 0;
    public let MAX_MINUTE : Nat = 59;
    public let MIN_SECOND : Nat = 0;
    public let MAX_SECOND : Nat = 59;

    // File validation constants
    public let MIN_FILE_SIZE : Nat = 0;
    public let MAX_FILE_SIZE : Nat = 1073741824; // 1GB in bytes
    public let MIN_FILE_NAME_LENGTH : Nat = 1;
    public let MAX_FILE_NAME_LENGTH : Nat = 255;
    public let MIN_FILE_EXTENSION_LENGTH : Nat = 1;
    public let MAX_FILE_EXTENSION_LENGTH : Nat = 10;
    public let MIN_FILE_PATH_LENGTH : Nat = 1;
    public let MAX_FILE_PATH_LENGTH : Nat = 4096;
    public let MIN_FILE_URL_LENGTH : Nat = 10;
    public let MAX_FILE_URL_LENGTH : Nat = 2048;

    // Array validation constants
    public let MIN_ARRAY_LENGTH : Nat = 0;
    public let MAX_ARRAY_LENGTH : Nat = 1000;
    public let MIN_LIST_LENGTH : Nat = 0;
    public let MAX_LIST_LENGTH : Nat = 1000;
    public let MIN_SET_LENGTH : Nat = 0;
    public let MAX_SET_LENGTH : Nat = 1000;
    public let MIN_MAP_LENGTH : Nat = 0;
    public let MAX_MAP_LENGTH : Nat = 1000;

    // Validation patterns
    public let ALPHANUMERIC_PATTERN : Text = "^[a-zA-Z0-9]+$";
    public let ALPHABETIC_PATTERN : Text = "^[a-zA-Z]+$";
    public let NUMERIC_PATTERN : Text = "^[0-9]+$";
    public let DECIMAL_PATTERN : Text = "^[0-9]+(\\.[0-9]+)?$";
    public let HEXADECIMAL_PATTERN : Text = "^[0-9a-fA-F]+$";
    public let BASE64_PATTERN : Text = "^[A-Za-z0-9+/]+={0,2}$";
    public let UUID_PATTERN : Text = "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$";
    public let IPV4_PATTERN : Text = "^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$";
    public let IPV6_PATTERN : Text = "^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$";
    public let MAC_ADDRESS_PATTERN : Text = "^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$";

    // Error messages
    public let ERROR_INVALID_TEXT_LENGTH : Text = "Invalid text length";
    public let ERROR_INVALID_NAME_LENGTH : Text = "Invalid name length";
    public let ERROR_INVALID_DESCRIPTION_LENGTH : Text = "Invalid description length";
    public let ERROR_INVALID_COMMENT_LENGTH : Text = "Invalid comment length";
    public let ERROR_INVALID_TITLE_LENGTH : Text = "Invalid title length";
    public let ERROR_INVALID_SUMMARY_LENGTH : Text = "Invalid summary length";
    public let ERROR_INVALID_NUMBER : Text = "Invalid number";
    public let ERROR_INVALID_POSITIVE_NUMBER : Text = "Invalid positive number";
    public let ERROR_INVALID_NEGATIVE_NUMBER : Text = "Invalid negative number";
    public let ERROR_INVALID_DECIMAL_PLACES : Text = "Invalid decimal places";
    public let ERROR_INVALID_DATE : Text = "Invalid date";
    public let ERROR_INVALID_YEAR : Text = "Invalid year";
    public let ERROR_INVALID_MONTH : Text = "Invalid month";
    public let ERROR_INVALID_DAY : Text = "Invalid day";
    public let ERROR_INVALID_HOUR : Text = "Invalid hour";
    public let ERROR_INVALID_MINUTE : Text = "Invalid minute";
    public let ERROR_INVALID_SECOND : Text = "Invalid second";
    public let ERROR_INVALID_FILE_SIZE : Text = "Invalid file size";
    public let ERROR_INVALID_FILE_NAME : Text = "Invalid file name";
    public let ERROR_INVALID_FILE_EXTENSION : Text = "Invalid file extension";
    public let ERROR_INVALID_FILE_PATH : Text = "Invalid file path";
    public let ERROR_INVALID_FILE_URL : Text = "Invalid file URL";
    public let ERROR_INVALID_ARRAY_LENGTH : Text = "Invalid array length";
    public let ERROR_INVALID_LIST_LENGTH : Text = "Invalid list length";
    public let ERROR_INVALID_SET_LENGTH : Text = "Invalid set length";
    public let ERROR_INVALID_MAP_LENGTH : Text = "Invalid map length";
    public let ERROR_INVALID_ALPHANUMERIC : Text = "Invalid alphanumeric value";
    public let ERROR_INVALID_ALPHABETIC : Text = "Invalid alphabetic value";
    public let ERROR_INVALID_NUMERIC : Text = "Invalid numeric value";
    public let ERROR_INVALID_DECIMAL : Text = "Invalid decimal value";
    public let ERROR_INVALID_HEXADECIMAL : Text = "Invalid hexadecimal value";
    public let ERROR_INVALID_BASE64 : Text = "Invalid base64 value";
    public let ERROR_INVALID_UUID : Text = "Invalid UUID";
    public let ERROR_INVALID_IPV4 : Text = "Invalid IPv4 address";
    public let ERROR_INVALID_IPV6 : Text = "Invalid IPv6 address";
    public let ERROR_INVALID_MAC_ADDRESS : Text = "Invalid MAC address";

    // Status messages
    public let STATUS_VALIDATION_SUCCESS : Text = "Validation successful";
    public let STATUS_VALIDATION_FAILURE : Text = "Validation failed";
    public let STATUS_VALIDATION_PENDING : Text = "Validation pending";
    public let STATUS_VALIDATION_IN_PROGRESS : Text = "Validation in progress";
    public let STATUS_VALIDATION_COMPLETED : Text = "Validation completed";
    public let STATUS_VALIDATION_ERROR : Text = "Validation error";
    public let STATUS_VALIDATION_WARNING : Text = "Validation warning";
    public let STATUS_VALIDATION_INFO : Text = "Validation info";
    public let STATUS_VALIDATION_DEBUG : Text = "Validation debug";
    public let STATUS_VALIDATION_TRACE : Text = "Validation trace";

    // Feature flags
    public let ENABLE_TEXT_VALIDATION : Bool = true;
    public let ENABLE_NUMBER_VALIDATION : Bool = true;
    public let ENABLE_DATE_VALIDATION : Bool = true;
    public let ENABLE_FILE_VALIDATION : Bool = true;
    public let ENABLE_ARRAY_VALIDATION : Bool = true;
    public let ENABLE_PATTERN_VALIDATION : Bool = true;
    public let ENABLE_LENGTH_VALIDATION : Bool = true;
    public let ENABLE_RANGE_VALIDATION : Bool = true;
    public let ENABLE_FORMAT_VALIDATION : Bool = true;
    public let ENABLE_TYPE_VALIDATION : Bool = true;
}; 