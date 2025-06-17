'use strict';

exports.config = {
  app_name: ['Privacy Pal'],
  license_key: process.env.NEW_RELIC_LICENSE_KEY,
  distributed_tracing: {
    enabled: true
  },
  logging: {
    level: 'info'
  },
  allow_all_headers: true,
  attributes: {
    exclude: [
      'request.headers.cookie',
      'request.headers.authorization',
      'request.headers.proxyAuthorization',
      'request.headers.setCookie*',
      'request.headers.x*',
      'response.headers.cookie',
      'response.headers.authorization',
      'response.headers.proxyAuthorization',
      'response.headers.setCookie*',
      'response.headers.x*'
    ]
  },
  transaction_tracer: {
    enabled: true,
    transaction_threshold: 'apdex_f',
    record_sql: 'obfuscated',
    stack_trace_threshold: '0.5'
  },
  error_collector: {
    enabled: true,
    ignore_status_codes: [404, 403]
  },
  browser_monitoring: {
    enabled: true,
    auto_instrument: true
  },
  transaction_events: {
    attributes: {
      exclude: [
        'request.headers.cookie',
        'request.headers.authorization',
        'request.headers.proxyAuthorization',
        'request.headers.setCookie*',
        'request.headers.x*',
        'response.headers.cookie',
        'response.headers.authorization',
        'response.headers.proxyAuthorization',
        'response.headers.setCookie*',
        'response.headers.x*'
      ]
    }
  },
  custom_insights_events: {
    enabled: true
  },
  distributed_tracing: {
    enabled: true,
    exclude_newrelic_header: false
  },
  span_events: {
    enabled: true
  },
  datastore_tracer: {
    enabled: true,
    record_sql: 'obfuscated',
    slow_sql: {
      enabled: true,
      threshold: 1000
    }
  },
  slow_sql: {
    enabled: true,
    max_samples: 20
  },
  apdex_t: 0.5,
  host: process.env.NEW_RELIC_HOST || 'collector.newrelic.com',
  port: process.env.NEW_RELIC_PORT || 443,
  ssl: true,
  proxy: process.env.NEW_RELIC_PROXY || '',
  proxy_host: process.env.NEW_RELIC_PROXY_HOST || '',
  proxy_port: process.env.NEW_RELIC_PROXY_PORT || '',
  proxy_user: process.env.NEW_RELIC_PROXY_USER || '',
  proxy_pass: process.env.NEW_RELIC_PROXY_PASS || '',
  ignore_server_configuration: false,
  serverless_mode: {
    enabled: false
  },
  security_policies_token: process.env.NEW_RELIC_SECURITY_POLICIES_TOKEN || '',
  high_security: false,
  labels: {
    environment: process.env.NODE_ENV,
    application: 'privacy-pal'
  }
}; 