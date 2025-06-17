const Dynatrace = require('@dynatrace/oneagent');

Dynatrace.init({
  // Connection settings
  endpoint: process.env.DYNATRACE_ENDPOINT,
  tenant: process.env.DYNATRACE_TENANT,
  token: process.env.DYNATRACE_TOKEN,

  // Application settings
  applicationName: 'Privacy Pal',
  applicationVersion: process.env.APP_VERSION,
  environment: process.env.NODE_ENV,

  // Monitoring settings
  monitoring: {
    enabled: true,
    debug: process.env.NODE_ENV === 'development',
    logLevel: 'info',
    captureExceptions: true,
    captureUnhandledRejections: true,
    captureUncaughtExceptions: true,
    captureConsoleLogs: true,
    captureConsoleErrors: true,
    captureConsoleWarnings: true,
    captureConsoleInfo: true,
    captureConsoleDebug: true,
    captureConsoleTrace: true,
    captureHttpRequests: true,
    captureHttpResponses: true,
    captureDatabaseQueries: true,
    captureRedisCommands: true,
    captureMongoDBQueries: true,
    captureExpressRoutes: true,
    captureGraphQLOperations: true,
    captureWebSocketMessages: true,
    captureCustomMetrics: true,
    captureCustomEvents: true,
    captureCustomTraces: true,
    captureCustomSpans: true,
    captureCustomTransactions: true,
    captureCustomErrors: true,
    captureCustomLogs: true,
    captureCustomContext: true,
    captureCustomTags: true,
    captureCustomLabels: true,
    captureCustomAttributes: true,
    captureCustomProperties: true,
    captureCustomDimensions: true,
    captureCustomMetrics: true,
    captureCustomEvents: true,
    captureCustomTraces: true,
    captureCustomSpans: true,
    captureCustomTransactions: true,
    captureCustomErrors: true,
    captureCustomLogs: true,
    captureCustomContext: true,
    captureCustomTags: true,
    captureCustomLabels: true,
    captureCustomAttributes: true,
    captureCustomProperties: true,
    captureCustomDimensions: true
  },

  // Security settings
  security: {
    enabled: true,
    captureSensitiveData: false,
    maskSensitiveData: true,
    sensitiveDataPatterns: [
      'password',
      'passwd',
      'pwd',
      'secret',
      'token',
      'authorization',
      'cookie',
      'set-cookie'
    ]
  },

  // Performance settings
  performance: {
    enabled: true,
    captureResponseTime: true,
    captureThroughput: true,
    captureErrorRate: true,
    captureApdex: true,
    captureUserExperience: true,
    captureBusinessTransactions: true,
    captureServiceEndpoints: true,
    captureDatabaseOperations: true,
    captureExternalCalls: true,
    captureBackgroundJobs: true,
    captureAsyncOperations: true,
    captureWebTransactions: true,
    captureMobileTransactions: true,
    captureCustomTransactions: true
  },

  // Custom settings
  custom: {
    service: 'privacy-pal',
    environment: process.env.NODE_ENV,
    version: process.env.APP_VERSION,
    instance: process.env.INSTANCE_ID,
    host: process.env.HOSTNAME,
    region: process.env.AWS_REGION,
    availabilityZone: process.env.AWS_AVAILABILITY_ZONE
  }
});

// Add custom transaction types
Dynatrace.addTransactionType('web');
Dynatrace.addTransactionType('api');
Dynatrace.addTransactionType('background');
Dynatrace.addTransactionType('scheduled');

// Add custom metrics
Dynatrace.addCustomMetric('report.submissions', 0);
Dynatrace.addCustomMetric('media.uploads', 0);
Dynatrace.addCustomMetric('user.registrations', 0);

// Add custom events
Dynatrace.addCustomEvent('report.created', {
  type: 'report',
  action: 'created'
});

Dynatrace.addCustomEvent('media.uploaded', {
  type: 'media',
  action: 'uploaded'
});

// Add custom traces
Dynatrace.addCustomTrace('report.processing', {
  type: 'report',
  action: 'processing'
});

Dynatrace.addCustomTrace('media.processing', {
  type: 'media',
  action: 'processing'
});

module.exports = Dynatrace; 