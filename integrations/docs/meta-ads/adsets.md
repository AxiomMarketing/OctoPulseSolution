# Meta Ads — Ad Sets Endpoint

## Endpoint

```
GET https://graph.facebook.com/v21.0/act_{ad_account_id}/adsets
GET https://graph.facebook.com/v21.0/{campaign_id}/adsets
```

## HTTP Method

GET

## Required Parameters

| Parameter    | Type   | Description                          |
|-------------|--------|--------------------------------------|
| access_token | string | Valid Meta user or system access token with `ads_read` permission |

## Optional Parameters

| Parameter        | Type    | Description                                                                 |
|-----------------|---------|-----------------------------------------------------------------------------|
| fields           | string  | Comma-separated list of fields to return                                    |
| campaign_id      | string  | Filter ad sets by parent campaign ID                                        |
| effective_status | array   | Filter by status: ACTIVE, PAUSED, DELETED, ARCHIVED, IN_PROCESS, WITH_ISSUES |
| limit            | integer | Number of results per page (default 25, max 5000)                           |
| after            | string  | Pagination cursor (next page)                                               |

## Available Fields

| Field                   | Type     | Description                                                          |
|------------------------|----------|----------------------------------------------------------------------|
| id                      | string   | Ad set ID                                                            |
| name                    | string   | Ad set name                                                          |
| campaign_id             | string   | Parent campaign ID                                                   |
| status                  | string   | Configured status (ACTIVE, PAUSED, DELETED, ARCHIVED)               |
| effective_status        | string   | Actual delivery status                                               |
| daily_budget            | integer  | Daily budget in account currency cents                               |
| lifetime_budget         | integer  | Lifetime budget in account currency cents                            |
| budget_remaining        | integer  | Remaining budget for lifetime campaigns                              |
| bid_amount              | integer  | Manual bid amount in cents                                           |
| bid_strategy            | string   | LOWEST_COST, TARGET_COST, COST_CAP, BID_CAP                        |
| billing_event           | string   | IMPRESSIONS, LINK_CLICKS, APP_INSTALLS, PAGE_LIKES                 |
| optimization_goal       | string   | REACH, LINK_CLICKS, CONVERSIONS, LEAD_GENERATION, etc.             |
| targeting               | object   | Targeting spec (age, gender, geo, interests, behaviors)              |
| start_time              | datetime | Start time (ISO 8601)                                                |
| end_time                | datetime | End time (ISO 8601)                                                  |
| created_time            | datetime | Creation timestamp                                                   |
| updated_time            | datetime | Last update timestamp                                                |
| attribution_spec        | array    | Attribution windows for this ad set                                  |
| promoted_object         | object   | Object being promoted (pixel_id, custom_event_type, etc.)           |
| destination_type        | string   | WEBSITE, APP, MESSENGER, INSTAGRAM_DIRECT                           |

## Targeting Object Structure

```json
{
  "age_min": 18,
  "age_max": 65,
  "genders": [1, 2],
  "geo_locations": {
    "countries": ["FR", "BE"],
    "regions": [{"key": "2623"}],
    "cities": [{"key": "2988507", "radius": 25, "distance_unit": "kilometer"}]
  },
  "interests": [{"id": "6003107902433", "name": "E-commerce"}],
  "behaviors": [],
  "flexible_spec": [],
  "exclusions": {}
}
```

## Example Request

```bash
curl -s "https://graph.facebook.com/v21.0/act_123456789/adsets" \
  -G \
  --data-urlencode "fields=id,name,campaign_id,status,effective_status,daily_budget,lifetime_budget,bid_strategy,optimization_goal,targeting,start_time,end_time,created_time" \
  --data-urlencode "effective_status=[\"ACTIVE\"]" \
  --data-urlencode "limit=50" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

## Example Response

```json
{
  "data": [
    {
      "id": "23843000000001",
      "name": "Retargeting — Website Visitors 30d",
      "campaign_id": "120200000000001",
      "status": "ACTIVE",
      "effective_status": "ACTIVE",
      "daily_budget": "2000",
      "bid_strategy": "LOWEST_COST",
      "optimization_goal": "CONVERSIONS",
      "start_time": "2024-01-01T00:00:00+0000",
      "created_time": "2023-12-20T15:30:00+0000"
    }
  ],
  "paging": {
    "cursors": {
      "before": "MQZDZD",
      "after": "MTAwMDA"
    }
  }
}
```

## Rate Limit Notes

- Same rate limit pool as campaigns: 150 calls/hour for this integration
- Filtering by campaign_id reduces response size significantly
- Include only needed fields to minimize payload and unit cost

## Common Errors

| Code  | Message                                 | Fix                                              |
|------|-----------------------------------------|--------------------------------------------------|
| 100  | Invalid parameter                        | Check effective_status array format (JSON array) |
| 190  | Invalid OAuth access token               | Refresh or reauthorize token                     |
| 200  | Permission error                         | Ensure `ads_read` permission on ad account       |
| 17   | User request limit reached               | Implement exponential backoff                    |
