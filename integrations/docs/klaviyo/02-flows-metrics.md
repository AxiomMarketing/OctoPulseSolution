# Klaviyo API — Flows & Metrics

## Flows

Flows are automated email/SMS sequences triggered by events.

### List Flows

```
GET /flows
```

Query parameters:

| Param          | Type    | Description                          |
|----------------|---------|--------------------------------------|
| page[cursor]   | string  | Pagination cursor                    |
| page[size]     | integer | Results per page (max: 50)           |
| filter         | string  | e.g. `equals(status,"live")`         |
| sort           | string  | e.g. `-updated` (desc), `name` (asc) |

Example:

```bash
curl -s "https://a.klaviyo.com/api/flows?page[size]=50&filter=equals(status,\"live\")" \
  -H "Authorization: Klaviyo-API-Key $TOKEN" \
  -H "revision: 2024-10-15"
```

Response attributes:

```json
{
  "id": "RKTMwT",
  "type": "flow",
  "attributes": {
    "name": "Post-Purchase Flow",
    "status": "live",
    "archived": false,
    "created": "2023-06-01T12:00:00+00:00",
    "updated": "2024-01-15T08:30:00+00:00",
    "trigger_type": "Placed Order"
  }
}
```

Flow statuses: `draft`, `live`, `manual`

### Get Flow

```
GET /flows/{flow_id}
```

### Get Flow Actions

```
GET /flows/{flow_id}/flow-actions
```

Returns all actions (emails, SMS, waits) in the flow.

---

## Metrics

Metrics are Klaviyo's event types (e.g., "Placed Order", "Viewed Product").

### List Metrics

```
GET /metrics
```

Query parameters:

| Param        | Type    | Description                |
|--------------|---------|----------------------------|
| page[cursor] | string  | Pagination cursor           |
| page[size]   | integer | Results per page (max: 50) |

Example response:

```json
{
  "data": [
    {
      "id": "abc123",
      "type": "metric",
      "attributes": {
        "name": "Placed Order",
        "service": "shopify",
        "created": "2023-01-01T00:00:00+00:00",
        "updated": "2024-01-01T00:00:00+00:00"
      }
    }
  ]
}
```

### Query Metric Aggregates

```
POST /metric-aggregates
```

Request body:

```json
{
  "data": {
    "type": "metric-aggregate",
    "attributes": {
      "metric_id": "abc123",
      "measurements": ["count", "sum_value", "unique"],
      "interval": "day",
      "page_size": 100,
      "timezone": "Europe/Paris",
      "filter": [
        "greater-than(datetime,2024-01-01T00:00:00+00:00)",
        "less-than(datetime,2024-12-31T23:59:59+00:00)"
      ]
    }
  }
}
```

Returns time-series data for the metric.
