const Sentry = require('@sentry/node');
const { ProfilingIntegration } = require('@sentry/profiling-node');

Sentry.init({
  dsn: process.env.SENTRY_DSN,
  environment: process.env.NODE_ENV,
  release: process.env.APP_VERSION,
  integrations: [
    new ProfilingIntegration(),
  ],
  tracesSampleRate: 1.0,
  profilesSampleRate: 1.0,
  beforeSend(event) {
    // Don't send events in development
    if (process.env.NODE_ENV === 'development') {
      return null;
    }

    // Filter out sensitive data
    if (event.request) {
      if (event.request.cookies) {
        delete event.request.cookies;
      }
      if (event.request.headers) {
        const sensitiveHeaders = ['authorization', 'cookie', 'set-cookie'];
        sensitiveHeaders.forEach(header => {
          delete event.request.headers[header];
        });
      }
    }

    return event;
  },
  ignoreErrors: [
    // Ignore specific errors
    'Network request failed',
    'Failed to fetch',
    'NetworkError',
    'TimeoutError',
    // Ignore errors from specific domains
    /^https?:\/\/localhost/,
    /^https?:\/\/127\.0\.0\.1/,
  ],
  attachStacktrace: true,
  maxBreadcrumbs: 50,
  debug: process.env.NODE_ENV === 'development',
}); 