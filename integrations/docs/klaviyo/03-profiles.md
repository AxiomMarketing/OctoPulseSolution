# Klaviyo API — Profiles

## Overview

Profiles represent individual contacts (customers) in Klaviyo.

## List Profiles

```
GET /profiles
```

Query parameters:

| Param                | Type    | Description                            |
|----------------------|---------|----------------------------------------|
| page[cursor]         | string  | Pagination cursor                      |
| page[size]           | integer | Results per page (max: 100)            |
| filter               | string  | Filter expression                      |
| fields[profile]      | string  | Comma-separated fields to return       |
| additional-fields    | string  | `predictive_analytics` for ML scores   |

Common filter examples:

```
filter=equals(email,"user@example.com")
filter=greater-than(created,"2024-01-01T00:00:00+00:00")
filter=any(id,["id1","id2","id3"])
```

Example:

```bash
curl -s 'https://a.klaviyo.com/api/profiles?filter=equals(email,"test@example.com")' \
  -H "Authorization: Klaviyo-API-Key $TOKEN" \
  -H "revision: 2024-10-15"
```

## Get Profile

```
GET /profiles/{profile_id}
```

Optional query: `?additional-fields[profile]=predictive_analytics`

Response attributes:

```json
{
  "id": "01GDDKASAP8TKDDA2GRZDSVP4H",
  "type": "profile",
  "attributes": {
    "email": "jane@example.com",
    "phone_number": "+33612345678",
    "first_name": "Jane",
    "last_name": "Dupont",
    "created": "2023-06-01T12:00:00+00:00",
    "updated": "2024-01-15T08:30:00+00:00",
    "subscriptions": {
      "email": {
        "marketing": { "consent": "SUBSCRIBED" }
      }
    },
    "predictive_analytics": {
      "historic_clv": 120.50,
      "predicted_clv": 250.00,
      "churn_probability": 0.12
    }
  }
}
```

## Create/Update Profile (Upsert)

```
POST /profile-import
```

Upserts by email or phone_number:

```json
{
  "data": {
    "type": "profile",
    "attributes": {
      "email": "jane@example.com",
      "first_name": "Jane",
      "last_name": "Dupont",
      "phone_number": "+33612345678",
      "properties": {
        "loyalty_tier": "gold",
        "preferred_language": "fr"
      }
    }
  }
}
```

## Update Profile

```
PATCH /profiles/{profile_id}
```

Partial update — only send fields to change.

## Suppress Profile (Unsubscribe)

```
POST /profile-suppression-bulk-create-jobs
```

Suppresses one or more profiles from email marketing.

## Get Profile Memberships (Lists/Segments)

```
GET /profiles/{profile_id}/lists
GET /profiles/{profile_id}/segments
```
