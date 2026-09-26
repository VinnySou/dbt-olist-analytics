"""Gera dados sintéticos no formato do dataset real da Olist, para os seeds do dbt.

Dataset real: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce
Os seeds aqui são pequenos de propósito (dbt seed não é feito para volumes
grandes) — servem para desenvolver e testar os models sem depender de um
data warehouse real ou do download do Kaggle.
"""
from pathlib import Path

import numpy as np
import pandas as pd

SEEDS_DIR = Path(__file__).resolve().parent.parent / "seeds"
RNG = np.random.default_rng(42)

N_CUSTOMERS = 40
N_SELLERS = 10
N_PRODUCTS = 20
N_ORDERS = 60

STATES = ["SP", "RJ", "MG", "ES", "BA", "RS", "PR"]
CATEGORIES = ["moveis_decoracao", "eletronicos", "beleza_saude", "esporte_lazer", "informatica_acessorios"]
CATEGORY_EN = {
    "moveis_decoracao": "furniture_decor",
    "eletronicos": "electronics",
    "beleza_saude": "health_beauty",
    "esporte_lazer": "sports_leisure",
    "informatica_acessorios": "computers_accessories",
}
PAYMENT_TYPES = ["credit_card", "boleto", "voucher", "debit_card"]
ORDER_STATUSES = ["delivered", "delivered", "delivered", "delivered", "shipped", "canceled"]


def generate() -> None:
    SEEDS_DIR.mkdir(parents=True, exist_ok=True)

    customers = pd.DataFrame({
        "customer_id": [f"cust_{i:04d}" for i in range(N_CUSTOMERS)],
        "customer_unique_id": [f"uniq_{i:04d}" for i in range(N_CUSTOMERS)],
        "customer_zip_code_prefix": RNG.integers(10000, 99999, N_CUSTOMERS),
        "customer_city": RNG.choice(["sao paulo", "rio de janeiro", "vitoria", "belo horizonte"], N_CUSTOMERS),
        "customer_state": RNG.choice(STATES, N_CUSTOMERS),
    })

    sellers = pd.DataFrame({
        "seller_id": [f"seller_{i:03d}" for i in range(N_SELLERS)],
        "seller_zip_code_prefix": RNG.integers(10000, 99999, N_SELLERS),
        "seller_city": RNG.choice(["sao paulo", "curitiba", "vitoria"], N_SELLERS),
        "seller_state": RNG.choice(STATES, N_SELLERS),
    })

    products = pd.DataFrame({
        "product_id": [f"prod_{i:03d}" for i in range(N_PRODUCTS)],
        "product_category_name": RNG.choice(CATEGORIES, N_PRODUCTS),
        "product_weight_g": RNG.integers(100, 15000, N_PRODUCTS),
        "product_length_cm": RNG.integers(10, 100, N_PRODUCTS),
        "product_height_cm": RNG.integers(5, 60, N_PRODUCTS),
        "product_width_cm": RNG.integers(10, 60, N_PRODUCTS),
    })

    category_translation = pd.DataFrame({
        "product_category_name": CATEGORIES,
        "product_category_name_english": [CATEGORY_EN[c] for c in CATEGORIES],
    })

    purchase_dates = pd.to_datetime("2024-01-01") + pd.to_timedelta(
        RNG.integers(0, 240, N_ORDERS), unit="D"
    )
    orders = pd.DataFrame({
        "order_id": [f"order_{i:04d}" for i in range(N_ORDERS)],
        "customer_id": RNG.choice(customers["customer_id"], N_ORDERS),
        "order_status": RNG.choice(ORDER_STATUSES, N_ORDERS),
        "order_purchase_timestamp": purchase_dates,
    })
    orders["order_approved_at"] = orders["order_purchase_timestamp"] + pd.to_timedelta(
        RNG.integers(1, 3, N_ORDERS), unit="h"
    )
    orders["order_delivered_customer_date"] = orders["order_purchase_timestamp"] + pd.to_timedelta(
        RNG.integers(4, 20, N_ORDERS), unit="D"
    )
    orders["order_estimated_delivery_date"] = orders["order_purchase_timestamp"] + pd.to_timedelta(15, unit="D")

    order_items_rows = []
    for order_id in orders["order_id"]:
        for item_id in range(1, RNG.integers(1, 3) + 1):
            order_items_rows.append({
                "order_id": order_id,
                "order_item_id": item_id,
                "product_id": RNG.choice(products["product_id"]),
                "seller_id": RNG.choice(sellers["seller_id"]),
                "price": round(float(RNG.uniform(20, 800)), 2),
                "freight_value": round(float(RNG.uniform(5, 60)), 2),
            })
    order_items = pd.DataFrame(order_items_rows)

    order_totals = (
        order_items.assign(item_total=order_items["price"] + order_items["freight_value"])
        .groupby("order_id")["item_total"]
        .sum()
    )

    payments_rows = []
    for order_id in orders["order_id"]:
        payments_rows.append({
            "order_id": order_id,
            "payment_sequential": 1,
            "payment_type": RNG.choice(PAYMENT_TYPES),
            "payment_installments": int(RNG.integers(1, 10)),
            "payment_value": round(float(order_totals[order_id]), 2),
        })
    payments = pd.DataFrame(payments_rows)

    reviews = pd.DataFrame({
        "review_id": [f"rev_{i:04d}" for i in range(N_ORDERS)],
        "order_id": orders["order_id"],
        "review_score": RNG.integers(1, 6, N_ORDERS),
    })

    customers.to_csv(SEEDS_DIR / "raw_customers.csv", index=False)
    sellers.to_csv(SEEDS_DIR / "raw_sellers.csv", index=False)
    products.to_csv(SEEDS_DIR / "raw_products.csv", index=False)
    category_translation.to_csv(SEEDS_DIR / "raw_category_translation.csv", index=False)
    orders.to_csv(SEEDS_DIR / "raw_orders.csv", index=False)
    order_items.to_csv(SEEDS_DIR / "raw_order_items.csv", index=False)
    payments.to_csv(SEEDS_DIR / "raw_payments.csv", index=False)
    reviews.to_csv(SEEDS_DIR / "raw_reviews.csv", index=False)

    print(f"Seeds sintéticos gerados em {SEEDS_DIR}")


if __name__ == "__main__":
    generate()
