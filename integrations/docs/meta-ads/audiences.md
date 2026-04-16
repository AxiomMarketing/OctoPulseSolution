# Meta Ads — Custom Audiences Endpoint

## Endpoint

```
GET https://graph.facebook.com/v21.0/act_{ad_account_id}/customaudiences
GET https://graph.facebook.com/v21.0/{audience_id}
```

## HTTP Method

GET

## Required Parameters

| Parameter    | Type   | Description                          |
|-------------|--------|--------------------------------------|
| access_token | string | Valid Meta user or system access token with `ads_read` permission |

## Optional Parameters

| Parameter    | Type    | Description                                                              |
|-------------|---------|--------------------------------------------------------------------------|
| fields       | string  | Comma-separated list of fields to return                                 |
| limit        | integer | Number of results per page (default 25, max 5000)                        |
| after        | string  | Pagination cursor                                                        |

## Available Fields

| Field                | Type     | Description                                                            |
|--------------------|----------|------------------------------------------------------------------------|
| id                  | string   | Audience ID                                                            |
| name                | string   | Audience name                                                          |
| description         | string   | Optional audience description                                          |
| subtype             | string   | Audience type (WEBSITE, CUSTOM, LOOKALIKE, ENGAGEMENT, APP, etc.)     |
| approximate_count   | integer  | Estimated audience size (rounded, -1 if too small to show)            |
| approximate_count_lower_bound | integer | Lower bound of size estimate                              |
| approximate_count_upper_bound | integer | Upper bound of size estimate                              |
| time_created        | datetime | Creation timestamp                                                     |
| time_updated        | datetime | Last update timestamp                                                  |
| delivery_status     | object   | Current delivery status and description                                |
| lookalike_spec      | object   | Lookalike configuration (source audience, country, ratio)              |
| rule                | string   | Website custom audience rule (JSON)                                    |
| pixel_id            | string   | Associated Meta Pixel ID (for website audiences)                       |
| retention_days      | integer  | Days to retain users in the audience (1-180)                           |
| account_id          | string   | Owning ad account ID                                                   |

## Audience Subtypes

| Subtype         | Description                                              |
|----------------|----------------------------------------------------------|
| WEBSITE         | Website Custom Audience (pixel-based)                    |
| CUSTOM          | Uploaded customer list (email, phone)                    |
| LOOKALIKE       | Lookalike of a source audience                           |
| ENGAGEMENT      | Users who engaged with Facebook/Instagram content        |
| APP             | Mobile app event audience                                |
| OFFLINE         | Offline event audience                                   |
| VIDEO           | Video engagement audience                                |

## Example Request

```bash
curl -s "https://graph.facebook.com/v21.0/act_123456789/customaudiences" \
  -G \
  --data-urlencode "fields=id,name,subtype,approximate_count,approximate_count_lower_bound,approximate_count_upper_bound,delivery_status,time_created,time_updated" \
  --data-urlencode "limit=50" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

## Example Response

```json
{
  "data": [
    {
      "id": "23842000000001",
      "name": "Website Visitors — 30 days",
      "subtype": "WEBSITE",
      "approximate_count": 15400,
      "approximate_count_lower_bound": 14000,
      "approximate_count_upper_bound": 17000,
      "delivery_status": {
        "code": 200,
        "description": "This audience is ready for use in ad sets."
      },
      "time_created": "2023-11-01T10:00:00+0000",
      "time_updated": "2024-01-14T08:00:00+0000"
    },
    {
      "id": "23842000000002",
      "name": "Lookalike FR 1% — Purchasers",
      "subtype": "LOOKALIKE",
      "approximate_count": 420000,
      "delivery_status": {
        "code": 200,
        "description": "This audience is ready for use in ad sets."
      },
      "time_created": "2023-11-15T12:00:00+0000"
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

## Delivery Status Codes

| Code | Meaning                                          |
|-----|--------------------------------------------------|
| 200  | Ready — can be used in ad sets                   |
| 400  | Too small — below minimum size for delivery      |
| 401  | Warming up — recently created, not yet ready     |
| 402  | Expired — audience has aged out (no recent fills)|
| 403  | Error in data source                             |

## Rate Limit Notes

- Audience reads count as standard GET calls
- Approximate counts update daily, not real-time — no need to poll frequently
- Cache audience lists for at least 1 hour
- Hard limit: 150 calls/hour for this integration

## Common Errors

| Code  | Message                                 | Fix                                                    |
|------|-----------------------------------------|--------------------------------------------------------|
| 100  | Invalid parameter                        | Check field names                                      |
| 190  | Invalid OAuth access token               | Refresh token                                          |
| 200  | Permission error                         | Need `ads_read` and possibly `ads_management`          |
| 278  | No permission to manage audience         | Check ad account role — need Advertiser or higher      |
| 17   | User request limit reached               | Back off, implement exponential retry                  |
