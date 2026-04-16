# Printful API — Mockup Generator & Shipping

## Mockup Generator

Generate product mockup images for a catalog product.

### Step 1 — Create Mockup Task

```
POST /mockup-generator/create-task/{product_id}
```

Request body:

```json
{
  "variant_ids": [4012, 4013],
  "format": "jpg",
  "files": [
    {
      "placement": "front",
      "image_url": "https://example.com/my-design.png",
      "position": {
        "area_width": 1800,
        "area_height": 2400,
        "width": 1800,
        "height": 2400,
        "top": 0,
        "left": 0
      }
    }
  ]
}
```

Response includes `task_key`.

### Step 2 — Poll Mockup Task

```
GET /mockup-generator/task?task_key={task_key}
```

Poll until `status` is `completed`. Response:

```json
{
  "task_key": "abc123",
  "status": "completed",
  "mockups": [
    {
      "placement": "front",
      "variant_ids": [4012],
      "mockup_url": "https://mockup.printful.com/..."
    }
  ]
}
```

Status values: `waiting`, `processing`, `completed`, `failed`

### List Catalog Product Mockup Styles

```
GET /mockup-generator/styles/{product_id}
```

Returns available placement options and template dimensions.

---

## Shipping Rates

```
POST /shipping/rates
```

Request body:

```json
{
  "recipient": {
    "address1": "123 Rue de la Paix",
    "city": "Paris",
    "country_code": "FR",
    "zip": "75002"
  },
  "items": [
    {
      "variant_id": 4012,
      "quantity": 1,
      "value": "29.99"
    }
  ],
  "currency": "EUR",
  "locale": "fr_FR"
}
```

Response:

```json
{
  "code": 200,
  "result": [
    {
      "id": "STANDARD",
      "name": "Flat Rate (3-4 business days)",
      "rate": "4.95",
      "currency": "EUR",
      "minDeliveryDate": "2024-01-10",
      "maxDeliveryDate": "2024-01-12"
    }
  ]
}
```

Note: For La Reunion (RE), country_code stays `FR` but shipping costs differ.
Always estimate shipping before displaying to customer.
