const apm = require('elastic-apm-node').start({
  serviceName: 'privacy-pal',
  serverUrl: process.env.APM_SERVER_URL,
  environment: process.env.NODE_ENV,
  active: process.env.NODE_ENV !== 'development',
  captureBody: 'all',
  captureHeaders: true,
  captureExceptions: true,
  captureErrorLogStackTraces: 'always',
  transactionSampleRate: 1.0,
  transactionMaxSpans: 50,
  spanFramesMinDuration: 5,
  stackTraceLimit: 50,
  centralConfig: true,
  metricsInterval: '30s',
  breakdownMetrics: true,
  propagateTracestate: true,
  cloudProvider: 'auto',
  containerId: process.env.CONTAINER_ID,
  kubernetesNamespace: process.env.KUBERNETES_NAMESPACE,
  kubernetesNodeName: process.env.KUBERNETES_NODE_NAME,
  kubernetesPodName: process.env.KUBERNETES_POD_NAME,
  kubernetesPodUID: process.env.KUBERNETES_POD_UID,
  ignoreUrls: [
    '/health',
    '/metrics',
    '/status'
  ],
  ignoreUserAgents: [
    'kube-probe',
    'Prometheus'
  ],
  sourceLinesErrorAppFrames: 5,
  sourceLinesErrorLibraryFrames: 5,
  sourceLinesSpanAppFrames: 0,
  sourceLinesSpanLibraryFrames: 0,
  sanitizeFieldNames: [
    'password',
    'passwd',
    'pwd',
    'secret',
    'token',
    'authorization',
    'cookie',
    'set-cookie'
  ],
  customContext: {
    service: {
      version: process.env.APP_VERSION,
      environment: process.env.NODE_ENV
    }
  },
  labels: {
    service: 'privacy-pal',
    environment: process.env.NODE_ENV
  }
});

// Add custom transaction types
apm.setTransactionType('web');
apm.setTransactionName('GET /api/reports');

// Add custom context
apm.setCustomContext({
  user: {
    id: 'user-123',
    email: 'user@example.com'
  }
});

// Add custom labels
apm.setLabel('service', 'privacy-pal');
apm.setLabel('environment', process.env.NODE_ENV);

// Add custom tags
apm.addTags({
  service: 'privacy-pal',
  environment: process.env.NODE_ENV
});

module.exports = apm; 