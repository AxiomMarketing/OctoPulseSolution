# Shopify Admin REST API — Inventory

Base URL: `https://rungraphik.myshopify.com/admin/api/2026-04`

## GET /inventory_levels.json

List inventory levels. Requires `inventory_item_ids` OR `location_ids`.

```
GET /inventory_levels.json?inventory_item_ids=123,456
```

### Query Parameters

| Param | Type | Description |
|-------|------|-------------|
| `inventory_item_ids` | string | Comma-separated inventory item IDs (required if no location_ids) |
| `location_ids` | string | Comma-separated location IDs |
| `limit` | integer | Max 250 (default 50) |
| `updated_at_min` | datetime | ISO8601 min updated_at |

### Response Fields (Inventory Level)

| Field | Type | Description |
|-------|------|-------------|
| `inventory_item_id` | integer | Inventory item ID |
| `location_id` | integer | Location ID |
| `available` | integer | Units available |
| `updated_at` | datetime | ISO8601 |

## GET /locations.json

List all locations (needed to get location_ids).

```
GET /locations.json
```

### Response Fields (Location)

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Location ID |
| `name` | string | Location name |
| `address1` | string | Street address |
| `city` | string | City |
| `country_code` | string | ISO 3166-1 alpha-2 |
| `active` | boolean | Is location active |

## POST /inventory_levels/adjust.json

Adjust inventory quantity (relative adjustment).

```json
POST /inventory_levels/adjust.json
{
  "location_id": 12345678,
  "inventory_item_id": 98765432,
  "available_adjustment": 5
}
```

## POST /inventory_levels/set.json

Set inventory quantity (absolute value).

```json
POST /inventory_levels/set.json
{
  "location_id": 12345678,
  "inventory_item_id": 98765432,
  "available": 100
}
```

## GET /inventory_items/{id}.json

Get a specific inventory item (by variant's `inventory_item_id`).

```
GET /inventory_items/98765432.json
```

### Response Fields (Inventory Item)

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Inventory item ID |
| `sku` | string | SKU |
| `cost` | string | Cost per unit |
| `tracked` | boolean | Whether tracking is enabled |
| `created_at` | datetime | ISO8601 |
| `updated_at` | datetime | ISO8601 |

## Example — Get inventory for all products

```bash
TOKEN=$(~/octopulse/integrations/_lib/bw-get.sh shopify-access-token)
# Step 1: get locations
LOCATIONS=$(curl -s -H "X-Shopify-Access-Token: $TOKEN" \
  "https://rungraphik.myshopify.com/admin/api/2026-04/locations.json")
LOC_ID=$(echo "$LOCATIONS" | python3 -c "import json,sys; locs=json.load(sys.stdin)['locations']; print(locs[0]['id'])" 2>/dev/null)

# Step 2: get inventory levels for that location
curl -s -H "X-Shopify-Access-Token: $TOKEN" \
  "https://rungraphik.myshopify.com/admin/api/2026-04/inventory_levels.json?location_ids=${LOC_ID}&limit=250"
```
