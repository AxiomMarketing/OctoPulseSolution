# Shopify Admin REST API — Metafields

Base URL: `https://rungraphik.myshopify.com/admin/api/2026-04`

Metafields store custom data attached to Shopify resources.

## GET /{resource}/{id}/metafields.json

List metafields for a resource.

```
GET /products/7891234567890/metafields.json
GET /customers/6789012345678/metafields.json
GET /orders/5012345678901/metafields.json
```

Valid resources: `products`, `customers`, `orders`, `collections`, `variants`, `shop`

### Query Parameters

| Param | Type | Description |
|-------|------|-------------|
| `namespace` | string | Filter by namespace |
| `key` | string | Filter by key |
| `limit` | integer | Max 250 (default 50) |
| `fields` | string | Comma-separated fields to return |

### Response Fields (Metafield)

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Metafield ID |
| `namespace` | string | Namespace (e.g. "custom") |
| `key` | string | Key name |
| `value` | string/number | Value |
| `type` | string | Value type (see below) |
| `owner_id` | integer | Resource ID |
| `owner_resource` | string | Resource type |
| `created_at` | datetime | ISO8601 |
| `updated_at` | datetime | ISO8601 |

### Metafield Types

| Type | Description |
|------|-------------|
| `single_line_text_field` | Short text |
| `multi_line_text_field` | Long text |
| `number_integer` | Integer |
| `number_decimal` | Decimal number |
| `boolean` | true/false |
| `date` | Date (YYYY-MM-DD) |
| `date_time` | ISO8601 datetime |
| `json` | JSON object |
| `url` | URL |
| `color` | Hex color |
| `weight` | Weight with unit |
| `dimension` | Dimension with unit |
| `rating` | Rating with scale |
| `product_reference` | GID reference |

## POST /{resource}/{id}/metafields.json

Create a metafield.

```json
POST /products/7891234567890/metafields.json
{
  "metafield": {
    "namespace": "custom",
    "key": "artist_name",
    "value": "Jean Dupont",
    "type": "single_line_text_field"
  }
}
```

## PUT /metafields/{id}.json

Update a metafield.

```json
PUT /metafields/123456789.json
{
  "metafield": {
    "id": 123456789,
    "value": "New value"
  }
}
```

## DELETE /metafields/{id}.json

Delete a metafield.

```
DELETE /metafields/123456789.json
```

## GET /shop/metafields.json

Get shop-level metafields.

```
GET /shop/metafields.json
```

## Example

```bash
TOKEN=$(~/octopulse/integrations/_lib/bw-get.sh shopify-access-token)
# List all metafields for a product in "custom" namespace
curl -s -H "X-Shopify-Access-Token: $TOKEN" \
  "https://rungraphik.myshopify.com/admin/api/2026-04/products/7891234567890/metafields.json?namespace=custom"
```
