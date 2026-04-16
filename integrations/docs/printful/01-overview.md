# Printful API — Overview

## Base URL

```
https://api.printful.com
```

## Authentication

All requests require a Bearer token:

```
Authorization: Bearer <TOKEN>
```

Tokens are store-specific (per Printful store). Retrieve from Bitwarden item `Printful`.

## API Version

Printful uses a versioned REST API. The current stable version is **v2** for some endpoints,
but many endpoints remain under the root (v1 implied). Check `_meta.yml` for fetch date.

OpenAPI spec available at: `https://api.printful.com/openapi.json`

## Rate Limits

- 120 requests/minute per store token
- Responses include `X-RateLimit-Remaining` and `X-RateLimit-Reset` headers
- On limit: HTTP 429 with `Retry-After` header

## Response Format

All responses follow:

```json
{
  "code": 200,
  "result": { ... },
  "extra": []
}
```

Error responses:

```json
{
  "code": 400,
  "result": "Error message",
  "error": { "reason": "BadRequest", "message": "..." }
}
```

## Pagination

List endpoints support `offset` and `limit` query params:

```
GET /orders?offset=0&limit=20
```

Response includes `paging` object:

```json
{
  "paging": {
    "total": 150,
    "offset": 0,
    "limit": 20
  }
}
```
