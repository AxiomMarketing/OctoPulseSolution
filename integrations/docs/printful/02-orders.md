# Printful API — Orders

## List Orders

```
GET /orders
```

Query parameters:

| Param    | Type    | Description                          |
|----------|---------|--------------------------------------|
| status   | string  | Filter by status (draft, pending, failed, canceled, inprocess, onhold, partial, fulfilled) |
| offset   | integer | Pagination offset (default: 0)       |
| limit    | integer | Items per page (default: 20, max: 100) |

Example:

```bash
curl -s "https://api.printful.com/orders?status=fulfilled&limit=10" \
  -H "Authorization: Bearer $TOKEN"
```

Response includes array of order objects in `result`.

## Get Single Order

```
GET /orders/{id}
```

Use the Printful internal order ID or external ID prefixed with `@`:

```bash
curl -s "https://api.printful.com/orders/@MY_STORE_ORDER_ID" \
  -H "Authorization: Bearer $TOKEN"
```

## Create Order

```
POST /orders
```

Request body (JSON):

```json
{
  "recipient": {
    "name": "John Doe",
    "address1": "123 Main St",
    "city": "Paris",
    "country_code": "FR",
    "zip": "75001",
    "email": "john@example.com"
  },
  "items": [
    {
      "sync_variant_id": 123456789,
      "quantity": 1
    }
  ],
  "retail_costs": {
    "currency": "EUR",
    "subtotal": "29.99",
    "shipping": "4.99",
    "total": "34.98"
  }
}
```

Set `confirm: true` to submit immediately (skips draft state).

## Order Statuses

| Status      | Meaning                                |
|-------------|----------------------------------------|
| draft       | Not yet confirmed                      |
| pending     | Awaiting fulfillment                   |
| inprocess   | Being manufactured                     |
| onhold      | On hold (payment issue, etc.)          |
| partial     | Partially shipped                      |
| fulfilled   | Fully shipped                          |
| canceled    | Canceled                               |
| failed      | Failed to process                      |

## Cancel Order

```
DELETE /orders/{id}
```

Only cancels orders in `draft` or `pending` status.

## Estimate Order Cost

```
POST /orders/estimate-costs
```

Same body as create order — returns cost breakdown without creating the order.
