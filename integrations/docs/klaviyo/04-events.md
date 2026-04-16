# Klaviyo API — Events

## Overview

Events track customer actions and trigger flows. Use the Events API for server-side
tracking to complement client-side JS tracking.

## Create Event

```
POST /events
```

Headers:

```
Authorization: Klaviyo-API-Key <TOKEN>
revision: 2024-10-15
Content-Type: application/json
```

Request body:

```json
{
  "data": {
    "type": "event",
    "attributes": {
      "profile": {
        "data": {
          "type": "profile",
          "attributes": {
            "email": "jane@example.com",
            "first_name": "Jane",
            "properties": {
              "locale": "fr"
            }
          }
        }
      },
      "metric": {
        "data": {
          "type": "metric",
          "attributes": {
            "name": "Placed Order"
          }
        }
      },
      "properties": {
        "order_id": "shopify-order-123",
        "total": 59.99,
        "currency": "EUR",
        "items": [
          {
            "product_id": "poster-sunrise",
            "name": "Affiche Sunrise",
            "quantity": 1,
            "price": 29.99
          }
        ]
      },
      "time": "2024-01-15T14:30:00+00:00",
      "unique_id": "order-123-placed-1705329000"
    }
  }
}
```

`unique_id` prevents duplicate events — use order ID + event type + timestamp.

## List Events

```
GET /events
```

Query parameters:

| Param          | Type    | Description                            |
|----------------|---------|----------------------------------------|
| page[cursor]   | string  | Pagination cursor                      |
| page[size]     | integer | Results per page (max: 200)            |
| filter         | string  | Filter by metric, profile, datetime    |
| fields[event]  | string  | Sparse fieldset                        |

Filter examples:

```
filter=equals(metric_id,"abc123")
filter=greater-than(datetime,"2024-01-01T00:00:00+00:00")
filter=equals(profile_id,"01GDDKASAP8TKDDA2GRZDSVP4H")
```

## Common Custom Event Names (Univile)

| Event Name          | Trigger                                |
|---------------------|----------------------------------------|
| Placed Order        | Order confirmed (also Shopify native)  |
| Viewed Product      | Product page view                      |
| Added to Cart       | Cart add action                        |
| Started Checkout    | Checkout page entered                  |
| Refunded Order      | Refund issued                          |
| Artwork Downloaded  | Digital download completed             |

## Bulk Event Creation

For batches, use the Events API in a loop — no bulk endpoint exists.
Rate limit: 75 req/s; batch imports recommend a 50ms sleep between calls.
