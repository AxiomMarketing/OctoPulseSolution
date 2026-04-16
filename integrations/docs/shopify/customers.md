# Shopify Admin REST API — Customers

Base URL: `https://rungraphik.myshopify.com/admin/api/2026-04`

## GET /customers.json

List customers.

```
GET /customers.json
```

### Query Parameters

| Param | Type | Description |
|-------|------|-------------|
| `limit` | integer | Max 250 (default 50) |
| `since_id` | integer | Return only customers after this ID |
| `created_at_min` | datetime | ISO8601 min created_at |
| `created_at_max` | datetime | ISO8601 max created_at |
| `updated_at_min` | datetime | ISO8601 min updated_at |
| `ids` | string | Comma-separated customer IDs |
| `fields` | string | Comma-separated fields to return |
| `page_info` | string | Cursor for pagination |

### Response Fields (Customer)

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Customer ID |
| `email` | string | Email address |
| `first_name` | string | First name |
| `last_name` | string | Last name |
| `phone` | string | Phone number |
| `orders_count` | integer | Total orders placed |
| `total_spent` | string | Lifetime spend |
| `state` | string | `enabled`, `disabled` |
| `tags` | string | Comma-separated tags |
| `created_at` | datetime | ISO8601 |
| `updated_at` | datetime | ISO8601 |
| `last_order_id` | integer | ID of last order |
| `last_order_name` | string | Name of last order |
| `accepts_marketing` | boolean | Marketing opt-in |
| `default_address` | object | Default address |
| `verified_email` | boolean | Email verified |

## GET /customers/search.json

Search customers.

```
GET /customers/search.json?query=email:test@example.com
```

### Query Syntax

| Pattern | Description |
|---------|-------------|
| `email:test@example.com` | By email |
| `first_name:Jean` | By first name |
| `last_name:Dupont` | By last name |
| `phone:+33612345678` | By phone |
| `tag:vip` | By tag |

## GET /customers/{id}.json

Get a single customer.

```
GET /customers/6789012345678.json
```

## GET /customers/{id}/orders.json

Get all orders for a customer.

```
GET /customers/6789012345678/orders.json?status=any
```

## GET /customers/count.json

Count customers.

Returns: `{"count": 1542}`

## Example

```bash
TOKEN=$(~/octopulse/integrations/_lib/bw-get.sh shopify-access-token)
curl -s -H "X-Shopify-Access-Token: $TOKEN" \
  "https://rungraphik.myshopify.com/admin/api/2026-04/customers.json?limit=50&fields=id,email,first_name,last_name,orders_count,total_spent,created_at"
```
