# PostHog API — Insights & HogQL Query

## HogQL Query (Recommended)

PostHog's primary query interface for programmatic data access.

```
POST /api/projects/{project_id}/query
```

Request body:

```json
{
  "query": {
    "kind": "HogQLQuery",
    "query": "SELECT event, count() as cnt FROM events WHERE timestamp > now() - interval 7 day GROUP BY event ORDER BY cnt DESC LIMIT 20"
  }
}
```

Response:

```json
{
  "results": [
    ["Placed Order", 142],
    ["$pageview", 8930],
    ["Added to Cart", 512]
  ],
  "columns": ["event", "cnt"],
  "types": ["String", "UInt64"],
  "timings": [{ "k": "query", "t": 0.045 }]
}
```

## Trends Query

```json
{
  "query": {
    "kind": "TrendsQuery",
    "series": [
      {
        "kind": "EventsNode",
        "event": "Placed Order",
        "name": "Orders"
      }
    ],
    "interval": "day",
    "dateRange": {
      "date_from": "-30d",
      "date_to": "today"
    },
    "breakdownFilter": {
      "breakdown": "$browser",
      "breakdown_type": "event"
    }
  }
}
```

## Funnel Query

```json
{
  "query": {
    "kind": "FunnelsQuery",
    "series": [
      { "kind": "EventsNode", "event": "$pageview", "name": "Page View" },
      { "kind": "EventsNode", "event": "Added to Cart", "name": "Add to Cart" },
      { "kind": "EventsNode", "event": "Placed Order", "name": "Order Placed" }
    ],
    "dateRange": { "date_from": "-30d" },
    "funnelWindowInterval": 14,
    "funnelWindowIntervalUnit": "day"
  }
}
```

## Saved Insights (Legacy Insights API)

### List Insights

```
GET /api/projects/{project_id}/insights
```

Query parameters:

| Param    | Type    | Description                       |
|----------|---------|-----------------------------------|
| insight  | string  | Filter by type (TRENDS, FUNNELS)  |
| saved    | boolean | Only return saved insights        |
| limit    | integer | Results per page                  |

### Get Insight

```
GET /api/projects/{project_id}/insights/{insight_id}
```

### Get Insight Results (cached)

```
GET /api/projects/{project_id}/insights/{insight_id}/?refresh=false
```

## Feature Flags

```
GET /api/projects/{project_id}/feature_flags
```

Returns all feature flags with rollout conditions.

### Evaluate Flag for Person

```
POST /api/projects/{project_id}/feature_flags/evaluate_all_flags_for_person
```

Body: `{ "distinct_id": "user@example.com" }`
