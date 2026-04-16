# Shopify Admin REST API — Orders

Base URL: `https://rungraphik.myshopify.com/admin/api/2026-04`

## GET /orders.json

List orders.

```
GET /orders.json
```

### Query Parameters

| Param | Type | Description |
|-------|------|-------------|
| `limit` | integer | Max 250 (default 50) |
| `since_id` | integer | Return only orders after this ID |
| `status` | string | `open`, `closed`, `cancelled`, `any` |
| `financial_status` | string | `authorized`, `pending`, `paid`, `refunded`, `voided`, `any` |
| `fulfillment_status` | string | `fulfilled`, `null`, `partial`, `unshipped`, `any` |
| `created_at_min` | datetime | ISO8601 min created_at |
| `created_at_max` | datetime | ISO8601 max created_at |
| `updated_at_min` | datetime | ISO8601 min updated_at |
| `ids` | string | Comma-separated order IDs |
| `fields` | string | Comma-separated fields to return |
| `page_info` | string | Cursor for pagination |

### Response Fields (Order)

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Order ID |
| `order_number` | integer | Human-readable #1001 |
| `name` | string | Order name (e.g. "#1001") |
| `email` | string | Customer email |
| `created_at` | datetime | ISO8601 |
| `updated_at` | datetime | ISO8601 |
| `processed_at` | datetime | ISO8601 |
| `financial_status` | string | `paid`, `pending`, etc. |
| `fulfillment_status` | string | `fulfilled`, null, `partial` |
| `total_price` | string | Total incl tax |
| `subtotal_price` | string | Subtotal before tax |
| `total_tax` | string | Tax amount |
| `currency` | string | ISO 4217 (e.g. "EUR") |
| `customer` | object | Customer object |
| `line_items` | array | Line item objects |
| `shipping_address` | object | Shipping address |
| `billing_address` | object | Billing address |
| `shipping_lines` | array | Shipping methods |
| `discount_codes` | array | Applied discount codes |
| `note` | string | Order note |
| `tags` | string | Comma-separated tags |
| `cancel_reason` | string | Cancellation reason |
| `cancelled_at` | datetime | ISO8601 or null |

### Line Item Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Line item ID |
| `product_id` | integer | Product ID |
| `variant_id` | integer | Variant ID |
| `title` | string | Product title |
| `variant_title` | string | Variant title |
| `quantity` | integer | Quantity ordered |
| `price` | string | Unit price |
| `sku` | string | SKU |
| `fulfillment_status` | string | `fulfilled`, null |
| `vendor` | string | Vendor |

## GET /orders/{id}.json

Get a single order.

```
GET /orders/5012345678901.json
```

## GET /orders/count.json

Count orders.

```
GET /orders/count.json?status=open&financial_status=paid
```

Returns: `{"count": 17}`

## Example — Orders last 24h

```bash
TOKEN=$(~/octopulse/integrations/_lib/bw-get.sh shopify-access-token)
SINCE=$(date -u -d "24 hours ago" +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || date -u -v-24H +"%Y-%m-%dT%H:%M:%SZ")
curl -s -H "X-Shopify-Access-Token: $TOKEN" \
  "https://rungraphik.myshopify.com/admin/api/2026-04/orders.json?status=any&created_at_min=${SINCE}&limit=50&fields=id,order_number,email,total_price,financial_status,fulfillment_status,created_at"
```
