# Klaviyo API — Overview

## Base URL

```
https://a.klaviyo.com/api
```

## Authentication

All requests require:

```
Authorization: Klaviyo-API-Key <TOKEN>
revision: 2024-10-15
```

The `revision` header is mandatory — it pins the API version and ensures stable behavior.
Retrieve token from Bitwarden item `klaviyo-api-key`.

## Current Stable Revision

`2024-10-15` — Use this unless a newer revision is confirmed.

## Rate Limits

- Default: 75 requests/second per API key
- Burst allowed up to 700 requests/minute
- HTTP 429 on limit with `Retry-After` header

## Response Format (JSON:API)

Klaviyo uses the JSON:API specification:

```json
{
  "data": {
    "type": "flow",
    "id": "abc123",
    "attributes": {
      "name": "Welcome Series",
      "status": "live"
    },
    "links": { "self": "https://a.klaviyo.com/api/flows/abc123" }
  },
  "links": { "self": "...", "next": "..." }
}
```

List responses use `data` as an array.

## Pagination

Cursor-based pagination:

```
GET /flows?page[cursor]=<cursor_value>&page[size]=50
```

Response includes `links.next` with the next cursor URL.

## Filtering

Klaviyo supports filter expressions:

```
GET /profiles?filter=equals(email,"user@example.com")
GET /events?filter=greater-than(datetime,"2024-01-01T00:00:00+00:00")
```

Filter operators: `equals`, `contains`, `greater-than`, `less-than`, `any`

## Sparse Fieldsets

Request only needed fields to reduce payload:

```
GET /profiles?fields[profile]=email,first_name,last_name
```
