module.exports = {
  // Connection settings
  controllerHostName: process.env.APPDYNAMICS_CONTROLLER_HOST_NAME,
  controllerPort: process.env.APPDYNAMICS_CONTROLLER_PORT || 443,
  controllerSslEnabled: true,
  accountName: process.env.APPDYNAMICS_ACCOUNT_NAME,
  accountAccessKey: process.env.APPDYNAMICS_ACCOUNT_ACCESS_KEY,
  applicationName: 'Privacy Pal',
  tierName: process.env.APPDYNAMICS_TIER_NAME || 'Web',
  nodeName: process.env.APPDYNAMICS_NODE_NAME || 'Node1',

  // Monitoring settings
  monitoring: {
    // Transaction monitoring
    transactionMonitoring: {
      enabled: true,
      samplingRate: 1.0,
      captureHeaders: true,
      captureCookies: false,
      captureQueryParams: true,
      captureRequestBody: true,
      captureResponseBody: true,
      maxBodySize: 1024 * 1024, // 1MB
    },

    // Error monitoring
    errorMonitoring: {
      enabled: true,
      captureExceptions: true,
      captureErrors: true,
      captureWarnings: true,
      captureConsoleLogs: true,
      maxErrorsPerMinute: 100,
    },

    // Database monitoring
    databaseMonitoring: {
      enabled: true,
      captureQueries: true,
      captureQueryParams: true,
      slowQueryThreshold: 1000, // ms
      maxQueriesPerMinute: 1000,
    },

    // HTTP monitoring
    httpMonitoring: {
      enabled: true,
      captureHeaders: true,
      captureCookies: false,
      captureQueryParams: true,
      captureRequestBody: true,
      captureResponseBody: true,
      maxBodySize: 1024 * 1024, // 1MB
    },

    // Custom metrics
    customMetrics: {
      enabled: true,
      maxMetricsPerMinute: 1000,
      metrics: [
        {
          name: 'user_registrations',
          type: 'COUNTER',
          description: 'Number of user registrations',
        },
        {
          name: 'reports_submitted',
          type: 'COUNTER',
          description: 'Number of reports submitted',
        },
        {
          name: 'response_time',
          type: 'AVERAGE',
          description: 'Average response time',
        },
      ],
    },

    // Business transactions
    businessTransactions: {
      enabled: true,
      transactions: [
        {
          name: 'User Registration',
          matchRules: [
            {
              type: 'URL',
              pattern: '/api/auth/register',
            },
          ],
        },
        {
          name: 'Report Submission',
          matchRules: [
            {
              type: 'URL',
              pattern: '/api/reports',
            },
          ],
        },
      ],
    },
  },

  // Security settings
  security: {
    // Data masking
    dataMasking: {
      enabled: true,
      patterns: [
        {
          type: 'CREDIT_CARD',
          pattern: '\\d{4}[- ]?\\d{4}[- ]?\\d{4}[- ]?\\d{4}',
          replacement: '****-****-****-****',
        },
        {
          type: 'EMAIL',
          pattern: '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}',
          replacement: '***@***.***',
        },
        {
          type: 'PHONE',
          pattern: '\\+?\\d{1,3}[- ]?\\d{3}[- ]?\\d{3}[- ]?\\d{4}',
          replacement: '***-***-****',
        },
      ],
    },

    // SSL/TLS settings
    ssl: {
      enabled: true,
      verifyServerCertificate: true,
      protocols: ['TLSv1.2', 'TLSv1.3'],
    },
  },

  // Performance settings
  performance: {
    // Response time thresholds
    responseTimeThresholds: {
      warning: 1000, // ms
      critical: 3000, // ms
    },

    // Error rate thresholds
    errorRateThresholds: {
      warning: 0.01, // 1%
      critical: 0.05, // 5%
    },

    // Resource usage thresholds
    resourceThresholds: {
      cpu: {
        warning: 70, // %
        critical: 90, // %
      },
      memory: {
        warning: 80, // %
        critical: 95, // %
      },
    },
  },

  // Custom settings
  custom: {
    // Service information
    service: {
      name: 'privacy-pal',
      version: process.env.APP_VERSION,
      environment: process.env.NODE_ENV,
    },

    // Instance information
    instance: {
      id: process.env.INSTANCE_ID,
      name: process.env.INSTANCE_NAME,
      type: process.env.INSTANCE_TYPE,
    },

    // Host information
    host: {
      name: process.env.HOSTNAME,
      ip: process.env.HOST_IP,
      region: process.env.AWS_REGION,
      availabilityZone: process.env.AWS_AVAILABILITY_ZONE,
    },

    // Custom tags
    tags: {
      project: 'Privacy Pal',
      team: 'Security',
      costCenter: 'SEC-001',
    },
  },
}; 