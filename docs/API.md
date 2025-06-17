# Privacy Pal API Documentation

## Overview

This document provides detailed information about the Privacy Pal API endpoints, request/response formats, and usage examples.

## Base URL

```
https://api.privacypal.ic0.app
```

## Authentication

Privacy Pal uses Internet Identity for authentication. All API requests require a valid authentication token.

### Headers

```
Authorization: Bearer <token>
Content-Type: application/json
```

## API Endpoints

### 1. Report Management

#### Submit Report
```http
POST /api/v1/reports
```

Request Body:
```json
{
  "content": "string",
  "category": "string",
  "metadata": {
    "location": "string",
    "timestamp": "string",
    "language": "string"
  }
}
```

Response:
```json
{
  "trackingId": "string",
  "status": "string",
  "timestamp": "string"
}
```

#### Get Report Status
```http
GET /api/v1/reports/{trackingId}
```

Response:
```json
{
  "status": "string",
  "moderationStatus": "string",
  "lastUpdated": "string"
}
```

### 2. Moderation

#### Submit Vote
```http
POST /api/v1/moderate/{reportId}/vote
```

Request Body:
```json
{
  "vote": "string",
  "reason": "string"
}
```

Response:
```json
{
  "status": "string",
  "consensus": "string"
}
```

#### Get Moderation Status
```http
GET /api/v1/moderate/{reportId}/status
```

Response:
```json
{
  "status": "string",
  "votes": "number",
  "consensus": "string"
}
```

### 3. Authentication

#### Initialize Session
```http
POST /api/v1/auth/session
```

Request Body:
```json
{
  "deviceId": "string"
}
```

Response:
```json
{
  "sessionId": "string",
  "token": "string",
  "expiresAt": "string"
}
```

#### Validate Session
```http
GET /api/v1/auth/session/validate
```

Response:
```json
{
  "valid": "boolean",
  "expiresAt": "string"
}
```

## Error Codes

| Code | Description |
|------|-------------|
| 400  | Bad Request |
| 401  | Unauthorized |
| 403  | Forbidden |
| 404  | Not Found |
| 500  | Internal Server Error |

## Rate Limiting

- 100 requests per minute per IP
- 1000 requests per hour per session

## Security

### Encryption

All API requests and responses are encrypted using:
- TLS 1.3
- End-to-end encryption
- Zero-knowledge proofs

### Data Protection

- No personal data collection
- Anonymous session management
- Secure data storage

## Examples

### Submit Report

```typescript
const submitReport = async (content: string, category: string) => {
  const response = await fetch('/api/v1/reports', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      content,
      category,
      metadata: {
        timestamp: new Date().toISOString(),
        language: 'en'
      }
    })
  });
  
  return response.json();
};
```

### Get Report Status

```typescript
const getReportStatus = async (trackingId: string) => {
  const response = await fetch(`/api/v1/reports/${trackingId}`, {
    headers: {
      'Authorization': `Bearer ${token}`
    }
  });
  
  return response.json();
};
```

## Best Practices

1. Always use HTTPS
2. Implement proper error handling
3. Cache responses when appropriate
4. Handle rate limiting
5. Implement retry logic
6. Validate all inputs
7. Sanitize all outputs

## Versioning

API versions are specified in the URL path. Current version is v1.

## Support

For API support, contact:
- Email: support@privacypal.ic0.app
- Documentation: docs.privacypal.ic0.app
- GitHub: github.com/privacypal 