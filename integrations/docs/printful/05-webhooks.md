# Printful API — Webhooks

## Overview

Printful webhooks notify your endpoint when order status changes occur.

## Register Webhook

```
POST /webhooks
```

Request body:

```json
{
  "url": "https://your-site.com/webhooks/printful",
  "types": [
    "order_created",
    "order_updated",
    "order_shipped",
    "order_canceled"
  ]
}
```

## List Webhooks

```
GET /webhooks
```

## Delete Webhook

```
DELETE /webhooks/{id}
```

## Event Types

| Event                | Trigger                            |
|----------------------|------------------------------------|
| order_created        | New order created in Printful      |
| order_updated        | Order status changed               |
| order_shipped        | Order shipped (includes tracking)  |
| order_canceled       | Order canceled                     |
| order_failed         | Order processing failed            |
| product_synced       | Product sync completed             |
| product_updated      | Sync product updated               |
| stock_updated        | Variant stock level changed        |

## Webhook Payload Structure

```json
{
  "type": "order_shipped",
  "created": 1704067200,
  "retries": 0,
  "store": 123456,
  "data": {
    "order": { ... },
    "shipment": {
      "id": 789,
      "carrier": "USPS",
      "service": "Priority",
      "tracking_number": "9400111899220000000000",
      "tracking_url": "https://tools.usps.com/go/TrackConfirmAction?tLabels=..."
    }
  }
}
```

## Security

Printful does not sign webhook payloads by default. Restrict your endpoint by IP:
- Printful webhook IPs are published in their documentation.
- Alternatively, include a secret token in the URL path.
