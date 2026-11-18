#!/usr/bin/env python3
"""Generate deterministic synthetic retail CSV source tables for the Fabric POC.

Uses only the Python standard library. Output is synthetic and safe for demos.
"""
from __future__ import annotations
import argparse
import csv
import random
from datetime import datetime, timedelta
from decimal import Decimal
from pathlib import Path

CITIES = [
    ("Hyderabad", "Telangana", "India"), ("Bengaluru", "Karnataka", "India"),
    ("Pune", "Maharashtra", "India"), ("Chennai", "Tamil Nadu", "India"),
    ("Delhi", "Delhi", "India"), ("Mumbai", "Maharashtra", "India"),
    ("Bhubaneswar", "Odisha", "India"), ("Kolkata", "West Bengal", "India"),
]
CATEGORIES = ["Electronics", "Home", "Books", "Fitness", "Clothing"]
FIRST_NAMES = ["Aarav", "Ishita", "Rohan", "Ananya", "Vihaan", "Diya", "Arjun", "Meera"]
LAST_NAMES = ["Sharma", "Patel", "Reddy", "Das", "Kumar", "Nair", "Joshi", "Rao"]
STATUSES = ["PLACED", "SHIPPED", "DELIVERED", "CANCELLED"]


def stamp(value: datetime) -> str:
    return value.strftime("%Y-%m-%d %H:%M:%S")


def write_csv(path: Path, rows: list[dict], columns: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=columns)
        writer.writeheader()
        writer.writerows(rows)


def generate(output: Path, customers_n: int, products_n: int, orders_n: int, seed: int) -> None:
    rng = random.Random(seed)
    start = datetime(2025, 1, 1, 8, 0, 0)

    customers = []
    for cid in range(1, customers_n + 1):
        city, state, country = rng.choice(CITIES)
        created = start + timedelta(minutes=rng.randint(0, 180 * 24 * 60))
        customers.append({
            "customer_id": cid,
            "first_name": rng.choice(FIRST_NAMES),
            "last_name": rng.choice(LAST_NAMES),
            "email": f"customer{cid}@example.com",
            "city": city, "state": state, "country": country,
            "created_at": stamp(created),
            "modified_at": stamp(created),
        })

    products = []
    for pid in range(1, products_n + 1):
        created = start + timedelta(days=rng.randint(0, 120))
        category = rng.choice(CATEGORIES)
        products.append({
            "product_id": pid,
            "product_name": f"{category} Item {pid:03d}",
            "category": category,
            "unit_price": f"{Decimal(rng.randint(500, 50000)) / Decimal('100'):.2f}",
            "is_active": str(rng.random() > 0.05).lower(),
            "created_at": stamp(created),
            "modified_at": stamp(created),
        })

    orders = []
    details = []
    detail_id = 1
    for oid in range(1, orders_n + 1):
        customer_id = rng.randint(1, customers_n)
        ordered = start + timedelta(days=rng.randint(0, 240), minutes=rng.randint(0, 1439))
        modified = ordered + timedelta(minutes=rng.randint(0, 90))
        orders.append({
            "order_id": oid, "customer_id": customer_id,
            "order_date": ordered.strftime("%Y-%m-%d"),
            "order_status": rng.choice(STATUSES),
            "created_at": stamp(ordered), "modified_at": stamp(modified),
        })
        for _ in range(rng.randint(1, 4)):
            product = rng.choice(products)
            quantity = rng.randint(1, 5)
            details.append({
                "order_detail_id": detail_id, "order_id": oid,
                "product_id": product["product_id"], "quantity": quantity,
                "unit_price": product["unit_price"],
                "modified_at": stamp(modified),
            })
            detail_id += 1

    write_csv(output / "customers.csv", customers, list(customers[0]))
    write_csv(output / "products.csv", products, list(products[0]))
    write_csv(output / "orders.csv", orders, list(orders[0]))
    write_csv(output / "order_details.csv", details, list(details[0]))
    print(f"Generated customers={len(customers)}, products={len(products)}, "
          f"orders={len(orders)}, order_details={len(details)} in {output}")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=Path("data/generated"))
    parser.add_argument("--customers", type=int, default=1000)
    parser.add_argument("--products", type=int, default=120)
    parser.add_argument("--orders", type=int, default=5000)
    parser.add_argument("--seed", type=int, default=2026)
    args = parser.parse_args()
    if min(args.customers, args.products, args.orders) <= 0:
        parser.error("customers, products, and orders must be positive integers")
    generate(args.output, args.customers, args.products, args.orders, args.seed)


if __name__ == "__main__":
    main()
