## A. Table Inventory

| Table Name | Approx Row Count | What it Stores | Grain |
|---|---|---|---|
| addresses | 16,000 | Stores address details | One row per `address_id` |
| attribution_campaigns | 38,405 | Stores cost per touch | One row per touch id |
| attribution_touches | 100,000 | Stores touch details | One row per touch id |
| brands | 120 | Stores brand names | One row per brand |
| categories | 18 | Stores category names | One row per category |
| collection_products | 0 | Blank table | - |
| collections | 0 | Blank table | - |
| consents | 0 | Blank table | - |
| coupons | 50 | Stores coupon details | One row per coupon |
| customer_addresses | 16,000 | Stores address type (shipping/billing) | One row per address id |
| customer_segments | 10 | Stores customer segment names | One row per segment |
| customers | 10,000 | Stores customer details | One row per customer |
| devices | 85,168 | Stores device details (type, model, OS) | One row per device |
| experiment_assignments | 140,670 | Stores details about the date of experiments | Multiple rows per experiment |
| experiment_variants | 12 | Stores details about different variants of experiment | Multiple rows per experiment |
| experiments | 6 | Stores details about experiment and hypothesis | One row per experiment |
| inventory_items | 2,000 | Stores details about inventory on hand and reserved | One row per variant |
| inventory_movements | 30,207 | Stores details about inventory movement | One row per event |
| loyalty_accounts | 3,000 | Details about customer loyalty tier (bronze, silver, gold) | One row per customer |
| loyalty_transactions | 21,475 | Stores loyalty reasons and points for each customer | One row per transaction |
| marketing_campaigns | 100 | Stores details about campaigns | One row per campaign |
| notifications | 6,856 | Details about how customer was notified (SMS, email) | Multiple rows per customer |
| order_items | 81,806 | Stores line item details per order | Multiple rows per order |
| order_status_history | 158,414 | Details about order status | Multiple rows per order |
| orders | 40,000 | Stores details about each order | One row per order |
| payment_intents | 40,000 | Details about payment status and method used | One row per order |
| payment_methods | 5 | Payment method names | One row per method |
| payment_transactions | 40,034 | Stores payment gateway and status details | One row per transaction |
| price_lists | 2 | Stores currency details | One row per currency |
| prices | 24,180 | Stores price details for variants in INR and USD | Two rows per variant |
| product_images | 7,188 | Stores image links for each product | Multiple rows per product |
| product_reviews | 8,000 | Stores reviews about each product | Multiple rows per product, customer, and order |
| product_variants | 12,090 | Stores details about each SKU | One row per SKU |
| products | 4,000 | Stores product details | One row per product |
| promotion_rules | 30 | Stores promo rules and maps to product and category | One row per product and category |
| promotions | 20 | Stores details about promo and discount value | One row per promo |
| refunds | 260 | Stores details about order refunds | One row per order |
| return_items | 2,004 | Stores return item details | Multiple rows per variant |
| return_reasons | 8 | Details about return reasons | One row per reason |
| return_requests | 1,603 | Stores details about return requests | One row per order |
| segment_memberships | 16,461 | Stores customer's membership validity | Multiple rows per customer |
| session_events | 292,903 | Stores session event details (product view, add to cart, etc.) | Multiple rows per customer |
| sessions | 100,000 | Stores details about the session (duration, device, customer, etc.) | Multiple rows per customer |
| shipments | 32,089 | Stores details about shipment carrier, shipping and delivery date | One row per order |
| shipping_carriers | 3 | Details about shipment carriers | One row per carrier |
| shipping_methods | 3 | Details about shipment method and prices | One row per method |
