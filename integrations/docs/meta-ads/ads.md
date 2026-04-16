# Meta Ads — Ads Endpoint

## Endpoint

```
GET https://graph.facebook.com/v21.0/act_{ad_account_id}/ads
GET https://graph.facebook.com/v21.0/{adset_id}/ads
GET https://graph.facebook.com/v21.0/{campaign_id}/ads
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
| adset_id         | string  | Filter ads by parent ad set ID                                              |
| effective_status | array   | Filter: ACTIVE, PAUSED, DELETED, ARCHIVED, DISAPPROVED, PENDING_REVIEW     |
| limit            | integer | Number of results per page (default 25, max 5000)                           |
| after            | string  | Pagination cursor                                                           |

## Available Fields

| Field                   | Type     | Description                                                          |
|------------------------|----------|----------------------------------------------------------------------|
| id                      | string   | Ad ID                                                                |
| name                    | string   | Ad name                                                              |
| adset_id                | string   | Parent ad set ID                                                     |
| campaign_id             | string   | Parent campaign ID                                                   |
| status                  | string   | Configured status (ACTIVE, PAUSED, DELETED, ARCHIVED)               |
| effective_status        | string   | Actual delivery status including review/disapproval states           |
| creative                | object   | Creative spec with id, name, title, body, image_url, etc.           |
| tracking_specs          | array    | Conversion tracking pixel events attached to this ad                 |
| conversion_specs        | array    | Conversion event specs for optimization                              |
| created_time            | datetime | Creation timestamp (ISO 8601)                                        |
| updated_time            | datetime | Last update timestamp (ISO 8601)                                     |
| bid_amount              | integer  | Ad-level bid override (cents)                                        |
| review_feedback         | object   | Rejection reasons if effective_status = DISAPPROVED                  |
| ad_review_feedback      | object   | Detailed review feedback per placement                               |

## Creative Object Fields

| Field         | Description                              |
|--------------|------------------------------------------|
| id            | Creative ID                              |
| name          | Creative name                            |
| title         | Ad headline                              |
| body          | Ad body text                             |
| image_url     | Primary image URL                        |
| thumbnail_url | Video thumbnail URL                      |
| video_id      | Video asset ID (if video ad)             |
| call_to_action| CTA type and link (SHOP_NOW, LEARN_MORE) |
| object_url    | Destination URL                          |
| link_url      | Display URL                              |

## Example Request

```bash
curl -s "https://graph.facebook.com/v21.0/act_123456789/ads" \
  -G \
  --data-urlencode "fields=id,name,adset_id,campaign_id,status,effective_status,creative{id,title,body,image_url,call_to_action},created_time" \
  --data-urlencode "effective_status=[\"ACTIVE\",\"PAUSED\"]" \
  --data-urlencode "limit=50" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

## Example Response

```json
{
  "data": [
    {
      "id": "23844000000001",
      "name": "Retargeting — Product carousel v2",
      "adset_id": "23843000000001",
      "campaign_id": "120200000000001",
      "status": "ACTIVE",
      "effective_status": "ACTIVE",
      "creative": {
        "id": "23845000000001",
        "title": "Discover our art prints",
        "body": "Unique artworks for your home. Free delivery.",
        "image_url": "https://scontent.example.com/...",
        "call_to_action": {
          "type": "SHOP_NOW",
          "value": {"link": "https://univile.com/collections/art-mural"}
        }
      },
      "created_time": "2023-12-20T16:00:00+0000"
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

## Creative Nested Fields

Use subfield notation to fetch creative details inline:

```bash
--data-urlencode "fields=id,name,creative{id,name,title,body,image_url,object_url,call_to_action}"
```

## Rate Limit Notes

- Ads endpoint is frequently called — respect 150 calls/hour limit
- Filter by adset_id or campaign_id to reduce payload
- Fetching creative subfields increases response processing cost
- Avoid polling more frequently than every 5 minutes for status checks

## Common Errors

| Code  | Message                                 | Fix                                                          |
|------|-----------------------------------------|--------------------------------------------------------------|
| 100  | Invalid parameter                        | Check creative subfield syntax (use curly braces)            |
| 190  | Invalid OAuth access token               | Long-lived token required; refresh if expired                |
| 200  | Permission error                         | Need `ads_read` on the ad account                            |
| 1487478 | Creative field not accessible       | Some creative fields require `ads_management` permission     |
| 17   | User request limit reached               | Back off and retry with exponential delay                    |
