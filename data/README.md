# Data

This POC uses generated synthetic retail data for customers, products, orders, and order details. No real customer or production information is used.

## Generate source CSVs

From the repository root, run:

```bash
python data/generate_retail_data.py
```

Defaults: 1,000 customers, 120 products, 5,000 orders, and approximately 12,500 order lines. The seed is fixed for reproducible output. Generated files are written to `data/generated/`, which is ignored by Git to avoid committing bulky derived data.

Change the scale:

```bash
python data/generate_retail_data.py --customers 200 --products 30 --orders 500 --seed 7
```

Outputs: `customers.csv`, `products.csv`, `orders.csv`, and `order_details.csv`.

## Change batches

Deterministic insert/update batches and schema-change scenarios will be added in the incremental-load implementation phase.