module {
    // Time constants
    public let ONE_SECOND : Nat = 1;
    public let ONE_MINUTE : Nat = 60;
    public let ONE_HOUR : Nat = 3600;
    public let ONE_DAY : Nat = 86400;
    public let ONE_WEEK : Nat = 604800;
    public let ONE_MONTH : Nat = 2592000;
    public let ONE_YEAR : Nat = 31536000;

    // Protocol constants
    public let PROTOCOL_HTTP : Text = "http";
    public let PROTOCOL_HTTPS : Text = "https";
    public let PROTOCOL_WS : Text = "ws";
    public let PROTOCOL_WSS : Text = "wss";
    public let PROTOCOL_TCP : Text = "tcp";
    public let PROTOCOL_UDP : Text = "udp";
    public let PROTOCOL_ICMP : Text = "icmp";
    public let PROTOCOL_ARP : Text = "arp";
    public let PROTOCOL_DNS : Text = "dns";
    public let PROTOCOL_DHCP : Text = "dhcp";
    public let PROTOCOL_FTP : Text = "ftp";
    public let PROTOCOL_SFTP : Text = "sftp";
    public let PROTOCOL_SSH : Text = "ssh";
    public let PROTOCOL_TELNET : Text = "telnet";
    public let PROTOCOL_SMTP : Text = "smtp";
    public let PROTOCOL_POP3 : Text = "pop3";
    public let PROTOCOL_IMAP : Text = "imap";
    public let PROTOCOL_RTMP : Text = "rtmp";
    public let PROTOCOL_RTSP : Text = "rtsp";
    public let PROTOCOL_SIP : Text = "sip";
    public let PROTOCOL_H323 : Text = "h323";
    public let PROTOCOL_RTP : Text = "rtp";
    public let PROTOCOL_SRTP : Text = "srtp";
    public let PROTOCOL_DTLS : Text = "dtls";
    public let PROTOCOL_TLS : Text = "tls";
    public let PROTOCOL_SSL : Text = "ssl";

    // Port constants
    public let PORT_HTTP : Nat = 80;
    public let PORT_HTTPS : Nat = 443;
    public let PORT_WS : Nat = 80;
    public let PORT_WSS : Nat = 443;
    public let PORT_FTP : Nat = 21;
    public let PORT_SFTP : Nat = 22;
    public let PORT_SSH : Nat = 22;
    public let PORT_TELNET : Nat = 23;
    public let PORT_SMTP : Nat = 25;
    public let PORT_POP3 : Nat = 110;
    public let PORT_IMAP : Nat = 143;
    public let PORT_RTMP : Nat = 1935;
    public let PORT_RTSP : Nat = 554;
    public let PORT_SIP : Nat = 5060;
    public let PORT_H323 : Nat = 1720;
    public let PORT_RTP : Nat = 5004;
    public let PORT_SRTP : Nat = 5004;
    public let PORT_DTLS : Nat = 443;
    public let PORT_TLS : Nat = 443;
    public let PORT_SSL : Nat = 443;

    // Connection limits
    public let MIN_CONNECTIONS : Nat = 1;
    public let MAX_CONNECTIONS : Nat = 10000;
    public let DEFAULT_CONNECTIONS : Nat = 100;
    public let MIN_CONNECTION_TIMEOUT : Nat = 1;
    public let MAX_CONNECTION_TIMEOUT : Nat = 300;
    public let DEFAULT_CONNECTION_TIMEOUT : Nat = 30;
    public let MIN_IDLE_TIMEOUT : Nat = 1;
    public let MAX_IDLE_TIMEOUT : Nat = 3600;
    public let DEFAULT_IDLE_TIMEOUT : Nat = 300;
    public let MIN_KEEP_ALIVE : Nat = 1;
    public let MAX_KEEP_ALIVE : Nat = 3600;
    public let DEFAULT_KEEP_ALIVE : Nat = 60;

    // Request limits
    public let MIN_REQUEST_TIMEOUT : Nat = 1;
    public let MAX_REQUEST_TIMEOUT : Nat = 3600;
    public let DEFAULT_REQUEST_TIMEOUT : Nat = 30;
    public let MIN_REQUEST_SIZE : Nat = 0;
    public let MAX_REQUEST_SIZE : Nat = 1073741824; // 1GB in bytes
    public let DEFAULT_REQUEST_SIZE : Nat = 1048576; // 1MB in bytes
    public let MIN_REQUEST_RATE : Nat = 0;
    public let MAX_REQUEST_RATE : Nat = 1000;
    public let DEFAULT_REQUEST_RATE : Nat = 100;
    public let MIN_REQUEST_BURST : Nat = 0;
    public let MAX_REQUEST_BURST : Nat = 100;
    public let DEFAULT_REQUEST_BURST : Nat = 10;

    // Response limits
    public let MIN_RESPONSE_TIMEOUT : Nat = 1;
    public let MAX_RESPONSE_TIMEOUT : Nat = 3600;
    public let DEFAULT_RESPONSE_TIMEOUT : Nat = 30;
    public let MIN_RESPONSE_SIZE : Nat = 0;
    public let MAX_RESPONSE_SIZE : Nat = 1073741824; // 1GB in bytes
    public let DEFAULT_RESPONSE_SIZE : Nat = 1048576; // 1MB in bytes
    public let MIN_RESPONSE_RATE : Nat = 0;
    public let MAX_RESPONSE_RATE : Nat = 1000;
    public let DEFAULT_RESPONSE_RATE : Nat = 100;
    public let MIN_RESPONSE_BURST : Nat = 0;
    public let MAX_RESPONSE_BURST : Nat = 100;
    public let DEFAULT_RESPONSE_BURST : Nat = 10;

    // Error messages
    public let ERROR_INVALID_PROTOCOL : Text = "Invalid protocol";
    public let ERROR_INVALID_PORT : Text = "Invalid port";
    public let ERROR_INVALID_CONNECTIONS : Text = "Invalid number of connections";
    public let ERROR_INVALID_CONNECTION_TIMEOUT : Text = "Invalid connection timeout";
    public let ERROR_INVALID_IDLE_TIMEOUT : Text = "Invalid idle timeout";
    public let ERROR_INVALID_KEEP_ALIVE : Text = "Invalid keep alive";
    public let ERROR_INVALID_REQUEST_TIMEOUT : Text = "Invalid request timeout";
    public let ERROR_INVALID_REQUEST_SIZE : Text = "Invalid request size";
    public let ERROR_INVALID_REQUEST_RATE : Text = "Invalid request rate";
    public let ERROR_INVALID_REQUEST_BURST : Text = "Invalid request burst";
    public let ERROR_INVALID_RESPONSE_TIMEOUT : Text = "Invalid response timeout";
    public let ERROR_INVALID_RESPONSE_SIZE : Text = "Invalid response size";
    public let ERROR_INVALID_RESPONSE_RATE : Text = "Invalid response rate";
    public let ERROR_INVALID_RESPONSE_BURST : Text = "Invalid response burst";

    // Status messages
    public let STATUS_CONNECTION_ESTABLISHED : Text = "Connection established successfully";
    public let STATUS_CONNECTION_CLOSED : Text = "Connection closed successfully";
    public let STATUS_CONNECTION_TIMEOUT : Text = "Connection timed out";
    public let STATUS_CONNECTION_ERROR : Text = "Connection error occurred";
    public let STATUS_REQUEST_SENT : Text = "Request sent successfully";
    public let STATUS_REQUEST_TIMEOUT : Text = "Request timed out";
    public let STATUS_REQUEST_ERROR : Text = "Request error occurred";
    public let STATUS_RESPONSE_RECEIVED : Text = "Response received successfully";
    public let STATUS_RESPONSE_TIMEOUT : Text = "Response timed out";
    public let STATUS_RESPONSE_ERROR : Text = "Response error occurred";

    // Feature flags
    public let ENABLE_CONNECTION_POOLING : Bool = true;
    public let ENABLE_CONNECTION_TIMEOUT : Bool = true;
    public let ENABLE_IDLE_TIMEOUT : Bool = true;
    public let ENABLE_KEEP_ALIVE : Bool = true;
    public let ENABLE_REQUEST_TIMEOUT : Bool = true;
    public let ENABLE_REQUEST_SIZE_LIMIT : Bool = true;
    public let ENABLE_REQUEST_RATE_LIMIT : Bool = true;
    public let ENABLE_REQUEST_BURST_LIMIT : Bool = true;
    public let ENABLE_RESPONSE_TIMEOUT : Bool = true;
    public let ENABLE_RESPONSE_SIZE_LIMIT : Bool = true;
    public let ENABLE_RESPONSE_RATE_LIMIT : Bool = true;
    public let ENABLE_RESPONSE_BURST_LIMIT : Bool = true;
    public let ENABLE_PROTOCOL_VALIDATION : Bool = true;
    public let ENABLE_PORT_VALIDATION : Bool = true;
    public let ENABLE_CONNECTION_VALIDATION : Bool = true;
    public let ENABLE_REQUEST_VALIDATION : Bool = true;
    public let ENABLE_RESPONSE_VALIDATION : Bool = true;
}; 