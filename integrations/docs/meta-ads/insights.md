# Meta Ads — Insights Endpoint

## Endpoint

```
GET https://graph.facebook.com/v21.0/act_{ad_account_id}/insights
GET https://graph.facebook.com/v21.0/{campaign_id}/insights
GET https://graph.facebook.com/v21.0/{adset_id}/insights
GET https://graph.facebook.com/v21.0/{ad_id}/insights
```

## HTTP Method

GET (synchronous for small datasets), POST for async jobs

## Required Parameters

| Parameter    | Type   | Description                          |
|-------------|--------|--------------------------------------|
| access_token | string | Valid Meta user or system access token with `ads_read` permission |
| fields       | string | Comma-separated metrics and dimensions to return |

## Optional Parameters

| Parameter        | Type    | Description                                                                              |
|-----------------|---------|------------------------------------------------------------------------------------------|
| date_preset      | string  | Preset time range (see enum below)                                                       |
| time_range       | object  | Custom date range: `{"since":"YYYY-MM-DD","until":"YYYY-MM-DD"}`                        |
| level            | string  | Aggregation level: ad, adset, campaign, account (default: account)                       |
| breakdowns       | string  | Comma-separated breakdown dimensions                                                     |
| filtering        | array   | JSON array of filter objects with field/operator/value                                   |
| sort             | string  | Sort field: `field_ascending` or `field_descending` (e.g. `spend_descending`)           |
| limit            | integer | Page size (default 25, max 5000)                                                         |
| time_increment   | integer | Split results by N days (1=daily, 7=weekly, etc.)                                       |
| use_account_attribution_setting | boolean | Use account-level attribution window setting |
| action_attribution_windows | array | Attribution windows: `["1d_click","7d_click","28d_click","1d_view","7d_view"]` |

## date_preset Enum Values

`today`, `yesterday`, `this_month`, `last_month`, `this_quarter`, `maximum`, `last_3d`, `last_7d`, `last_14d`, `last_28d`, `last_30d`, `last_90d`, `last_week_mon_sun`, `last_week_sun_sat`, `last_quarter`, `last_year`, `this_week_mon_today`, `this_week_sun_today`, `this_year`

## Breakdown Dimensions

`age`, `gender`, `country`, `region`, `impression_device`, `publisher_platform`, `platform_position`, `device_platform`, `product_id`

## Available Fields (Metrics)

| Field                   | Description                                                      |
|------------------------|------------------------------------------------------------------|
| spend                   | Total amount spent (in account currency)                         |
| impressions             | Total number of times ads were shown                             |
| clicks                  | Total clicks on ads                                              |
| reach                   | Unique users who saw the ad                                      |
| frequency               | Average times each person saw the ad                             |
| ctr                     | Click-through rate (clicks/impressions × 100)                    |
| cpm                     | Cost per 1000 impressions                                        |
| cpc                     | Cost per click                                                   |
| cpp                     | Cost per 1000 people reached                                     |
| actions                 | Array of conversion actions with type, value, 28d_click counts  |
| action_values           | Revenue attributed to actions                                    |
| purchase_roas           | Return on ad spend for purchases                                 |
| cost_per_action_type    | Cost per each action type                                        |
| conversions             | Total conversions (alias for purchase actions)                   |
| conversion_values       | Total conversion value                                           |
| video_p25_watched_actions | 25% video view completions                                   |
| video_p50_watched_actions | 50% video view completions                                   |
| video_p75_watched_actions | 75% video view completions                                   |
| video_p100_watched_actions | 100% video view completions (complete views)               |
| date_start              | Start date of the reporting window                               |
| date_stop               | End date of the reporting window                                 |
| account_id              | Ad account ID                                                    |
| account_name            | Ad account name                                                  |
| campaign_id             | Campaign ID (available at adset/ad level)                        |
| campaign_name           | Campaign name                                                    |
| adset_id                | Ad set ID (available at ad level)                                |
| adset_name              | Ad set name                                                      |
| ad_id                   | Ad ID                                                            |
| ad_name                 | Ad name                                                          |

## Example Request

```bash
curl -s "https://graph.facebook.com/v21.0/act_123456789/insights" \
  -G \
  --data-urlencode "fields=spend,impressions,clicks,ctr,cpm,actions,purchase_roas,cost_per_action_type" \
  --data-urlencode "date_preset=last_7d" \
  --data-urlencode "level=campaign" \
  --data-urlencode "limit=50" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

## Example Response

```json
{
  "data": [
    {
      "spend": "125.43",
      "impressions": "18432",
      "clicks": "342",
      "ctr": "1.856",
      "cpm": "6.805",
      "actions": [
        {"action_type": "link_click", "value": "342"},
        {"action_type": "purchase", "value": "12"}
      ],
      "purchase_roas": [{"action_type": "offsite_conversion.fb_pixel_purchase", "value": "4.21"}],
      "date_start": "2024-01-08",
      "date_stop": "2024-01-14",
      "campaign_id": "120200000000001",
      "campaign_name": "Brand Awareness Q1"
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

## Async Jobs (for large datasets)

For large date ranges or many campaigns, use async:

```bash
# 1. Create async job
curl -s -X POST "https://graph.facebook.com/v21.0/act_123456789/insights" \
  --data "fields=spend,impressions&date_preset=last_30d&level=ad" \
  -H "Authorization: Bearer <TOKEN>"
# Returns: {"report_run_id": "456789"}

# 2. Poll status
curl -s "https://graph.facebook.com/v21.0/456789?fields=async_status,async_percent_completion" \
  -H "Authorization: Bearer <TOKEN>"

# 3. Fetch results when complete
curl -s "https://graph.facebook.com/v21.0/456789/insights" \
  -H "Authorization: Bearer <TOKEN>"
```

## Rate Limit Notes

- Insights calls are more expensive: complex queries with many breakdowns count as 2-5 units
- Async jobs bypass most rate limits for large datasets
- Monitor `X-Business-Use-Case-Usage` header: `{"call_count":X,"total_cputime":Y,"total_time":Z}`
- Hard limit: 150 calls/hour for this integration
- Recommended: cache results for at least 15 minutes

## Common Errors

| Code  | Message                                 | Fix                                                         |
|------|-----------------------------------------|-------------------------------------------------------------|
| 100  | Invalid parameter                        | Check field names — typos cause silent empty results        |
| 190  | Invalid OAuth access token               | Token expired — use long-lived token or System User token   |
| 200  | Permission error                         | Ensure `ads_read` and `read_insights` permissions           |
| 17   | User request limit reached               | Implement exponential backoff                               |
| 80004| Too many API calls                       | Switch to async jobs for heavy queries                      |
| 2    | Service temporarily unavailable         | Retry with backoff                                          |
