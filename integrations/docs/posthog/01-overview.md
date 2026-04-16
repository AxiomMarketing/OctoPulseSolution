# PostHog API — Overview

## Base URL

Cloud (EU):  `https://eu.posthog.com/api`
Cloud (US):  `https://app.posthog.com/api`
Self-hosted: `https://<your-instance>/api`

Check Bitwarden item `posthog-api-key` notes field for the correct base URL and project ID.

## Authentication

Personal API key (for server-to-server / private API):

```
Authorization: Bearer <PERSONAL_API_KEY>
```

Project API key (for ingestion / capture only):
Used in the `api_key` body field when capturing events.

## Project ID

All data endpoints are scoped to a project:

```
GET /api/projects/{project_id}/events
```

Find project_id in:
1. Bitwarden item `posthog-api-key` notes field
2. PostHog UI: Settings > Project > Project ID

## Rate Limits

- No hard published rate limit for the API
- Capture endpoint: effectively unlimited for event ingestion
- Query API: ~1 request/second recommended for heavy HogQL queries

## Response Format

Standard REST JSON responses:

```json
{
  "results": [ ... ],
  "next": "https://app.posthog.com/api/projects/123/events?after=...",
  "previous": null,
  "count": 100
}
```

## Pagination

Cursor-based via `next` link in response, or `after` / `before` timestamp params.

## API Key Types

| Type             | Use                                   |
|------------------|---------------------------------------|
| Personal API key | Querying data, managing projects       |
| Project API key  | Capturing events (client/server-side) |

Never expose personal API key client-side.
