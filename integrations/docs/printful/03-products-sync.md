# Printful API — Products & Sync

## Sync Products (Store Products)

Sync products represent products connected between your store and Printful.

### List Sync Products

```
GET /sync/products
```

Query parameters:

| Param  | Type    | Description              |
|--------|---------|--------------------------|
| offset | integer | Pagination offset         |
| limit  | integer | Max results (default: 20) |
| status | string  | all, synced, unsynced     |

Example response:

```json
{
  "code": 200,
  "result": [
    {
      "id": 123456,
      "external_id": "shopify-product-id",
      "name": "Affiche Sunrise",
      "synced": 2,
      "out_of_stock": 0,
      "thumbnail_url": "https://..."
    }
  ]
}
```

### Get Sync Product

```
GET /sync/products/{id}
```

Returns full product including all sync variants.

### Get Sync Variant

```
GET /sync/variants/{id}
```

Returns variant-level detail including Printful variant ID, retail price, and files.

### Catalog Products (Printful Catalog)

```
GET /products
```

Browse all available Printful print products (not store-specific).

### Get Catalog Variant

```
GET /products/{product_id}/variants
```

Returns all variants for a catalog product with pricing.

## Product Files

Each sync variant requires print files. File types:

| Type     | Description              |
|----------|--------------------------|
| front    | Front print area         |
| back     | Back print area          |
| default  | Main print file          |
| preview  | Mockup preview image     |

Files must be uploaded to Printful first:

```
POST /files
```

Then referenced by URL or file_id in product creation.
