# Data Dictionary (Initial Design)

The generated source schema will be authoritative; this document records the intended starting model.

## customers

| Column | Type | Meaning |
|---|---|---|
| customer_id | integer | Customer business key |
| first_name | string | Given name |
| last_name | string | Family name |
| email | string | Synthetic email |
| city | string | City |
| state | string | State or region |
| country | string | Country |
| created_at | timestamp | Creation timestamp |
| modified_at | timestamp | Last modification timestamp |

## products

| Column | Type | Meaning |
|---|---|---|
| product_id | integer | Product business key |
| product_name | string | Product name |
| category | string | Product category |
| unit_price | decimal | Selling price |
| is_active | boolean | Active product indicator |
| created_at | timestamp | Creation timestamp |
| modified_at | timestamp | Last modification timestamp |

## orders

| Column | Type | Meaning |
|---|---|---|
| order_id | integer | Order business key |
| customer_id | integer | Customer business key |
| order_date | date | Order date |
| order_status | string | Order status |
| modified_at | timestamp | Last modification timestamp |

## order_details

| Column | Type | Meaning |
|---|---|---|
| order_detail_id | integer | Order-line business key |
| order_id | integer | Parent order key |
| product_id | integer | Product business key |
| quantity | integer | Quantity |
| unit_price | decimal | Price at order time |
| modified_at | timestamp | Last modification timestamp |

The synthetic data generator and its schema tests will define exact constraints and distributions.
