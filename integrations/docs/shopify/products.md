# Shopify Admin REST API — Products

Base URL: `https://rungraphik.myshopify.com/admin/api/2026-04`

## GET /products.json

List products.

```
GET /products.json
```

### Query Parameters

| Param | Type | Description |
|-------|------|-------------|
| `limit` | integer | Max 250 (default 50) |
| `since_id` | integer | Return only products after this ID |
| `title` | string | Filter by title (exact match) |
| `status` | string | `active`, `archived`, `draft` |
| `ids` | string | Comma-separated product IDs |
| `fields` | string | Comma-separated fields to return |
| `page_info` | string | Cursor for pagination |
| `published_status` | string | `published`, `unpublished`, `any` |
| `vendor` | string | Filter by vendor |
| `product_type` | string | Filter by product type |
| `collection_id` | integer | Filter by collection |
| `updated_at_min` | datetime | ISO8601 min updated_at |
| `updated_at_max` | datetime | ISO8601 max updated_at |
| `created_at_min` | datetime | ISO8601 min created_at |

### Response Fields (Product)

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Product ID |
| `title` | string | Product title |
| `body_html` | string | HTML description |
| `vendor` | string | Product vendor |
| `product_type` | string | Product type |
| `status` | string | `active`, `archived`, `draft` |
| `handle` | string | URL-friendly name |
| `variants` | array | Variant objects (see below) |
| `options` | array | Option names (e.g. Size, Color) |
| `images` | array | Image objects |
| `tags` | string | Comma-separated tags |
| `created_at` | datetime | ISO8601 |
| `updated_at` | datetime | ISO8601 |
| `published_at` | datetime | ISO8601 or null |
| `template_suffix` | string | Template suffix |

### Variant Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Variant ID |
| `product_id` | integer | Parent product ID |
| `title` | string | Variant title (e.g. "S / Red") |
| `sku` | string | SKU |
| `price` | string | Price (string, e.g. "29.99") |
| `compare_at_price` | string | Compare-at price |
| `inventory_item_id` | integer | For inventory tracking |
| `inventory_quantity` | integer | Stock quantity |
| `inventory_management` | string | `shopify` or null |
| `inventory_policy` | string | `deny` or `continue` |
| `weight` | float | Weight in grams |
| `option1`, `option2`, `option3` | string | Option values |

## GET /products/{id}.json

Get a single product.

```
GET /products/7891234567890.json
```

## GET /products/count.json

Count products.

```
GET /products/count.json?status=active
```

Returns: `{"count": 42}`

## POST /products.json

Create a product.

```json
POST /products.json
{
  "product": {
    "title": "My Product",
    "body_html": "<p>Description</p>",
    "vendor": "Univile",
    "product_type": "Art Print",
    "status": "draft",
    "variants": [
      {
        "price": "29.99",
        "sku": "SKU-001",
        "inventory_management": "shopify"
      }
    ]
  }
}
```

## PUT /products/{id}.json

Update a product.

```json
PUT /products/7891234567890.json
{
  "product": {
    "id": 7891234567890,
    "status": "active"
  }
}
```

## Example

```bash
TOKEN=$(~/octopulse/integrations/_lib/bw-get.sh shopify-access-token)
curl -s -H "X-Shopify-Access-Token: $TOKEN" \
  "https://rungraphik.myshopify.com/admin/api/2026-04/products.json?limit=10&status=active&fields=id,title,status,variants"
```
