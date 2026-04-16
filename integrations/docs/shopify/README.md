# Shopify Admin REST API — OctoPulse Integration

## Approach: Plugin (installed) + REST Doc Cache

The **Shopify AI Toolkit** Claude plugin (`shopify-plugin@shopify-ai-toolkit`) is installed and enabled  
on this server. It provides GraphQL skills for app development.

For **store management** (products, orders, customers, inventory) OctoPulse agents use the  
**Admin REST API 2026-04** directly via `curl` + Bitwarden-stored token. Docs cached here.

## Auth

```
Header: X-Shopify-Access-Token: <token>
Bitwarden item: shopify-access-token
Store: rungraphik.myshopify.com
Base URL: https://rungraphik.myshopify.com/admin/api/2026-04
```

## Resources Documented

| File | Resource | Key Operations |
|------|----------|---------------|
| `products.md` | Products & Variants | list, get, create, update |
| `orders.md` | Orders | list, get, count, fulfillment |
| `customers.md` | Customers | list, get, search |
| `inventory.md` | Inventory Levels | list, adjust |
| `metafields.md` | Metafields | get, set, delete |

## Rate Limits

- 40 requests/minute (REST) — leaky bucket
- Use `_lib/rate-limit.sh` to stay within bounds
- Shopify returns `X-Shopify-Shop-Api-Call-Limit: N/40` in headers

## Pagination

All list endpoints support cursor pagination via `page_info`:
```bash
# First page
GET /products.json?limit=50

# Next page (from Link header)
# Link: <https://store.myshopify.com/admin/api/2026-04/products.json?page_info=CURSOR&limit=50>; rel="next"
```
