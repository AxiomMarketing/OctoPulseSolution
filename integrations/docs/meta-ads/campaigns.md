# Meta Ads — Campaigns Endpoint

## Endpoint

```
GET https://graph.facebook.com/v21.0/act_{ad_account_id}/campaigns
```

## HTTP Method

GET

## Required Parameters

| Parameter    | Type   | Description                          |
|-------------|--------|--------------------------------------|
| access_token | string | Valid Meta user or system access token |

## Optional Parameters

| Parameter        | Type    | Description                                                                 |
|-----------------|---------|-----------------------------------------------------------------------------|
| fields           | string  | Comma-separated list of fields to return                                    |
| effective_status | array   | Filter by status: ACTIVE, PAUSED, DELETED, ARCHIVED, IN_PROCESS, WITH_ISSUES |
| limit            | integer | Number of results per page (default 25, max 5000)                           |
| after            | string  | Cursor for pagination (next page)                                           |
| before           | string  | Cursor for pagination (previous page)                                       |
| date_preset      | string  | Preset date range for time-filtered fields                                  |

## Available Fields

| Field              | Type     | Description                                              |
|-------------------|----------|----------------------------------------------------------|
| id                 | string   | Campaign ID                                              |
| name               | string   | Campaign name                                            |
| status             | string   | Configured status (ACTIVE, PAUSED, DELETED, ARCHIVED)   |
| effective_status   | string   | Actual delivery status including parent-level factors    |
| objective          | string   | Campaign objective (LINK_CLICKS, CONVERSIONS, etc.)     |
| bid_strategy       | string   | Bid strategy (LOWEST_COST, TARGET_COST, COST_CAP, etc.) |
| daily_budget       | integer  | Daily budget in account currency (cents)                 |
| lifetime_budget    | integer  | Lifetime budget in account currency (cents)              |
| buying_type        | string   | Buying type (AUCTION, RESERVED)                          |
| start_time         | datetime | Campaign start time (ISO 8601)                           |
| stop_time          | datetime | Campaign stop time (ISO 8601)                            |
| created_time       | datetime | Creation timestamp (ISO 8601)                            |
| updated_time       | datetime | Last update timestamp (ISO 8601)                         |
| spend_cap          | integer  | Maximum total spend cap (cents)                          |
| account_id         | string   | Ad account ID owning this campaign                       |
| special_ad_categories | array | Special ad category (HOUSING, EMPLOYMENT, CREDIT, etc.) |

## Example Request

```bash
curl -s "https://graph.facebook.com/v21.0/act_123456789/campaigns" \
  -G \
  --data-urlencode "fields=id,name,status,effective_status,objective,daily_budget,lifetime_budget,start_time,stop_time,created_time" \
  --data-urlencode "effective_status=[\"ACTIVE\",\"PAUSED\"]" \
  --data-urlencode "limit=50" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

## Example Response

```json
{
  "data": [
    {
      "id": "120200000000001",
      "name": "Brand Awareness Q1",
      "status": "ACTIVE",
      "effective_status": "ACTIVE",
      "objective": "LINK_CLICKS",
      "daily_budget": "5000",
      "start_time": "2024-01-01T00:00:00+0000",
      "created_time": "2023-12-20T14:00:00+0000"
    }
  ],
  "paging": {
    "cursors": {
      "before": "MQZDZD",
      "after": "MTAwMDA"
    },
    "next": "https://graph.facebook.com/v21.0/act_123456789/campaigns?after=MTAwMDA&..."
  }
}
```

## Rate Limit Notes

- Standard Business Use Case: 200 score units per hour per ad account
- Each GET counts as 1 unit
- Large field lists or high limits count as more units
- Monitor `X-Business-Use-Case-Usage` response header
- Hard limit: 150 calls/hour for this integration

## Common Errors

| Code  | Message                                 | Fix                                              |
|------|-----------------------------------------|--------------------------------------------------|
| 100  | Invalid parameter                        | Check field names and parameter format           |
| 190  | Invalid OAuth access token               | Refresh token or reauthorize                     |
| 200  | Permission error                         | Ensure token has `ads_read` permission           |
| 17   | User request limit reached               | Back off, respect rate limits                    |
| 80004| Too many API calls to this ad account    | Implement exponential backoff                    |
