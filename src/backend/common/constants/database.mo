module {
    // Time constants
    public let ONE_SECOND : Nat = 1;
    public let ONE_MINUTE : Nat = 60;
    public let ONE_HOUR : Nat = 3600;
    public let ONE_DAY : Nat = 86400;
    public let ONE_WEEK : Nat = 604800;
    public let ONE_MONTH : Nat = 2592000;
    public let ONE_YEAR : Nat = 31536000;

    // Connection limits
    public let MIN_CONNECTIONS : Nat = 1;
    public let MAX_CONNECTIONS : Nat = 1000;
    public let DEFAULT_CONNECTIONS : Nat = 10;
    public let MIN_CONNECTION_TIMEOUT : Nat = 1;
    public let MAX_CONNECTION_TIMEOUT : Nat = 300;
    public let DEFAULT_CONNECTION_TIMEOUT : Nat = 30;
    public let MIN_IDLE_TIMEOUT : Nat = 1;
    public let MAX_IDLE_TIMEOUT : Nat = 3600;
    public let DEFAULT_IDLE_TIMEOUT : Nat = 300;
    public let MIN_KEEP_ALIVE : Nat = 1;
    public let MAX_KEEP_ALIVE : Nat = 3600;
    public let DEFAULT_KEEP_ALIVE : Nat = 60;

    // Query limits
    public let MIN_QUERY_TIMEOUT : Nat = 1;
    public let MAX_QUERY_TIMEOUT : Nat = 3600;
    public let DEFAULT_QUERY_TIMEOUT : Nat = 30;
    public let MIN_QUERY_LIMIT : Nat = 1;
    public let MAX_QUERY_LIMIT : Nat = 10000;
    public let DEFAULT_QUERY_LIMIT : Nat = 100;
    public let MIN_QUERY_OFFSET : Nat = 0;
    public let MAX_QUERY_OFFSET : Nat = 1000000;
    public let DEFAULT_QUERY_OFFSET : Nat = 0;
    public let MIN_QUERY_BATCH_SIZE : Nat = 1;
    public let MAX_QUERY_BATCH_SIZE : Nat = 1000;
    public let DEFAULT_QUERY_BATCH_SIZE : Nat = 100;

    // Transaction limits
    public let MIN_TRANSACTION_TIMEOUT : Nat = 1;
    public let MAX_TRANSACTION_TIMEOUT : Nat = 3600;
    public let DEFAULT_TRANSACTION_TIMEOUT : Nat = 30;
    public let MIN_TRANSACTION_RETRIES : Nat = 0;
    public let MAX_TRANSACTION_RETRIES : Nat = 10;
    public let DEFAULT_TRANSACTION_RETRIES : Nat = 3;
    public let MIN_TRANSACTION_BATCH_SIZE : Nat = 1;
    public let MAX_TRANSACTION_BATCH_SIZE : Nat = 1000;
    public let DEFAULT_TRANSACTION_BATCH_SIZE : Nat = 100;

    // Index limits
    public let MIN_INDEX_NAME_LENGTH : Nat = 1;
    public let MAX_INDEX_NAME_LENGTH : Nat = 64;
    public let MIN_INDEX_FIELDS : Nat = 1;
    public let MAX_INDEX_FIELDS : Nat = 32;
    public let DEFAULT_INDEX_FIELDS : Nat = 1;
    public let MIN_INDEX_SIZE : Nat = 0;
    public let MAX_INDEX_SIZE : Nat = 1073741824; // 1GB in bytes
    public let DEFAULT_INDEX_SIZE : Nat = 1048576; // 1MB in bytes

    // Table limits
    public let MIN_TABLE_NAME_LENGTH : Nat = 1;
    public let MAX_TABLE_NAME_LENGTH : Nat = 64;
    public let MIN_TABLE_FIELDS : Nat = 1;
    public let MAX_TABLE_FIELDS : Nat = 1000;
    public let DEFAULT_TABLE_FIELDS : Nat = 10;
    public let MIN_TABLE_SIZE : Nat = 0;
    public let MAX_TABLE_SIZE : Nat = 1099511627776; // 1TB in bytes
    public let DEFAULT_TABLE_SIZE : Nat = 1073741824; // 1GB in bytes
    public let MIN_TABLE_ROWS : Nat = 0;
    public let MAX_TABLE_ROWS : Nat = 1000000000;
    public let DEFAULT_TABLE_ROWS : Nat = 0;

    // Field limits
    public let MIN_FIELD_NAME_LENGTH : Nat = 1;
    public let MAX_FIELD_NAME_LENGTH : Nat = 64;
    public let MIN_FIELD_LENGTH : Nat = 0;
    public let MAX_FIELD_LENGTH : Nat = 65535;
    public let DEFAULT_FIELD_LENGTH : Nat = 255;
    public let MIN_FIELD_PRECISION : Nat = 0;
    public let MAX_FIELD_PRECISION : Nat = 65;
    public let DEFAULT_FIELD_PRECISION : Nat = 10;
    public let MIN_FIELD_SCALE : Nat = 0;
    public let MAX_FIELD_SCALE : Nat = 30;
    public let DEFAULT_FIELD_SCALE : Nat = 2;

    // Error messages
    public let ERROR_INVALID_CONNECTIONS : Text = "Invalid number of connections";
    public let ERROR_INVALID_CONNECTION_TIMEOUT : Text = "Invalid connection timeout";
    public let ERROR_INVALID_IDLE_TIMEOUT : Text = "Invalid idle timeout";
    public let ERROR_INVALID_KEEP_ALIVE : Text = "Invalid keep alive";
    public let ERROR_INVALID_QUERY_TIMEOUT : Text = "Invalid query timeout";
    public let ERROR_INVALID_QUERY_LIMIT : Text = "Invalid query limit";
    public let ERROR_INVALID_QUERY_OFFSET : Text = "Invalid query offset";
    public let ERROR_INVALID_QUERY_BATCH_SIZE : Text = "Invalid query batch size";
    public let ERROR_INVALID_TRANSACTION_TIMEOUT : Text = "Invalid transaction timeout";
    public let ERROR_INVALID_TRANSACTION_RETRIES : Text = "Invalid transaction retries";
    public let ERROR_INVALID_TRANSACTION_BATCH_SIZE : Text = "Invalid transaction batch size";
    public let ERROR_INVALID_INDEX_NAME_LENGTH : Text = "Invalid index name length";
    public let ERROR_INVALID_INDEX_FIELDS : Text = "Invalid number of index fields";
    public let ERROR_INVALID_INDEX_SIZE : Text = "Invalid index size";
    public let ERROR_INVALID_TABLE_NAME_LENGTH : Text = "Invalid table name length";
    public let ERROR_INVALID_TABLE_FIELDS : Text = "Invalid number of table fields";
    public let ERROR_INVALID_TABLE_SIZE : Text = "Invalid table size";
    public let ERROR_INVALID_TABLE_ROWS : Text = "Invalid number of table rows";
    public let ERROR_INVALID_FIELD_NAME_LENGTH : Text = "Invalid field name length";
    public let ERROR_INVALID_FIELD_LENGTH : Text = "Invalid field length";
    public let ERROR_INVALID_FIELD_PRECISION : Text = "Invalid field precision";
    public let ERROR_INVALID_FIELD_SCALE : Text = "Invalid field scale";

    // Status messages
    public let STATUS_CONNECTION_ESTABLISHED : Text = "Connection established successfully";
    public let STATUS_CONNECTION_CLOSED : Text = "Connection closed successfully";
    public let STATUS_CONNECTION_TIMEOUT : Text = "Connection timed out";
    public let STATUS_CONNECTION_ERROR : Text = "Connection error occurred";
    public let STATUS_QUERY_EXECUTED : Text = "Query executed successfully";
    public let STATUS_QUERY_TIMEOUT : Text = "Query timed out";
    public let STATUS_QUERY_ERROR : Text = "Query error occurred";
    public let STATUS_TRANSACTION_STARTED : Text = "Transaction started successfully";
    public let STATUS_TRANSACTION_COMMITTED : Text = "Transaction committed successfully";
    public let STATUS_TRANSACTION_ROLLED_BACK : Text = "Transaction rolled back successfully";
    public let STATUS_TRANSACTION_TIMEOUT : Text = "Transaction timed out";
    public let STATUS_TRANSACTION_ERROR : Text = "Transaction error occurred";
    public let STATUS_INDEX_CREATED : Text = "Index created successfully";
    public let STATUS_INDEX_DROPPED : Text = "Index dropped successfully";
    public let STATUS_INDEX_ERROR : Text = "Index error occurred";
    public let STATUS_TABLE_CREATED : Text = "Table created successfully";
    public let STATUS_TABLE_DROPPED : Text = "Table dropped successfully";
    public let STATUS_TABLE_ERROR : Text = "Table error occurred";
    public let STATUS_FIELD_CREATED : Text = "Field created successfully";
    public let STATUS_FIELD_DROPPED : Text = "Field dropped successfully";
    public let STATUS_FIELD_ERROR : Text = "Field error occurred";

    // Feature flags
    public let ENABLE_CONNECTION_POOLING : Bool = true;
    public let ENABLE_CONNECTION_TIMEOUT : Bool = true;
    public let ENABLE_IDLE_TIMEOUT : Bool = true;
    public let ENABLE_KEEP_ALIVE : Bool = true;
    public let ENABLE_QUERY_TIMEOUT : Bool = true;
    public let ENABLE_QUERY_LIMIT : Bool = true;
    public let ENABLE_QUERY_OFFSET : Bool = true;
    public let ENABLE_QUERY_BATCH : Bool = true;
    public let ENABLE_TRANSACTION_TIMEOUT : Bool = true;
    public let ENABLE_TRANSACTION_RETRIES : Bool = true;
    public let ENABLE_TRANSACTION_BATCH : Bool = true;
    public let ENABLE_INDEX_CREATION : Bool = true;
    public let ENABLE_INDEX_DELETION : Bool = true;
    public let ENABLE_TABLE_CREATION : Bool = true;
    public let ENABLE_TABLE_DELETION : Bool = true;
    public let ENABLE_FIELD_CREATION : Bool = true;
    public let ENABLE_FIELD_DELETION : Bool = true;
}; 