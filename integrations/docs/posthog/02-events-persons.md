# PostHog API — Events & Persons

## Events

### List Events

```
GET /api/projects/{project_id}/events
```

Query parameters:

| Param      | Type    | Description                                  |
|------------|---------|----------------------------------------------|
| event      | string  | Filter by event name (e.g. `$pageview`)      |
| properties | string  | JSON-encoded property filters                |
| after      | string  | ISO datetime — events after this time        |
| before     | string  | ISO datetime — events before this time       |
| person_id  | string  | Filter by specific person UUID               |
| distinct_id| string  | Filter by distinct_id                        |
| limit      | integer | Results per page (default: 100, max: 1000)   |

Example:

```bash
curl -s "https://app.posthog.com/api/projects/$PROJECT_ID/events?event=Placed Order&limit=50" \
  -H "Authorization: Bearer $TOKEN"
```

Response:

```json
{
  "results": [
    {
      "id": "01234567-89ab-cdef-0123-456789abcdef",
      "distinct_id": "user@example.com",
      "event": "Placed Order",
      "properties": {
        "$current_url": "https://univile.re/checkout",
        "order_total": 59.99,
        "currency": "EUR"
      },
      "timestamp": "2024-01-15T14:30:00.000Z",
      "person": {
        "id": "uuid-here",
        "name": "Jane Dupont"
      }
    }
  ],
  "next": "https://app.posthog.com/api/projects/123/events?after=..."
}
```

---

## Persons

### List Persons

```
GET /api/projects/{project_id}/persons
```

Query parameters:

| Param        | Type    | Description                              |
|--------------|---------|------------------------------------------|
| search       | string  | Search by name, email, distinct_id       |
| properties   | string  | JSON-encoded property filters            |
| cohort       | integer | Filter by cohort ID                      |
| limit        | integer | Results per page (default: 100)          |

### Get Person

```
GET /api/projects/{project_id}/persons/{person_id}
```

### Get Person by Distinct ID

```
GET /api/projects/{project_id}/persons?distinct_id={distinct_id}
```

### Delete Person (GDPR)

```
DELETE /api/projects/{project_id}/persons/{person_id}
```

Optionally include `?delete_events=true` to also delete all their events.

### Person Properties

```
GET /api/projects/{project_id}/person_property_definitions
```

Returns all tracked person properties with type info.
