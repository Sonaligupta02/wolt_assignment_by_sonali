# Wolt Snack Shop – Analytics Engineering Assignment

## Project Overview

This project was created as part of the **Wolt Analytics Engineering Assignment**.

The goal of the project is to transform raw Wolt Snack Shop data into **clean, tested, reusable, and analytics-ready datasets**.

The project has two main parts:

- **Task 1 – Data Transformation:** Build a reusable data model that allows the Analytics Team to answer business questions using simple SQL queries.
- **Task 2 – Business Analysis:** Use the transformed data to understand what is driving Wolt Snack Shop's growth and present the findings in a Looker Studio dashboard.

---

# Tools & Technologies

The following tools were used:

- **Google BigQuery** – Data warehouse and SQL analysis
- **dbt ** – Data transformation and modelling
- **SQL** – Data transformation and business analysis
- **Data Studio** – Dashboard and data visualization
- **Git & GitHub** – Version control
- **VS Code** – Development environment

---

# Data Transformation Architecture

The project follows a layered dbt modelling approach.

```text
Raw Data
   ↓
Staging Layer
   ↓
Intermediate Layer
   ↓
Mart Layer
   ↓
fct_order_items
   ↓
Business Analysis
   ↓
Looker Studio Dashboard
```

The main idea is to perform complex transformations once in dbt so that downstream analysts can work with clean datasets and simple SQL queries.

# dbt Model Structure

## 1. Staging Layer

The staging layer cleans and standardizes the raw source data.

- `stg_purchases`
- `stg_item_logs`
- `stg_promos`

The staging layer prepares the raw data before applying business logic.

## 2. Intermediate Layer

The intermediate layer contains reusable transformations, joins, and business logic.

Main intermediate models include:

- `int_item_history`
- `int_order_items`
- `int_order_item_pricing`
- `int_order_item_promotions`

This layer combines order, customer, product, pricing, and promotion information.

## 3. Mart Layer

The final business-ready fact table is:

### `fct_order_items`

This is the main dataset created for the Analytics Team.

It contains:

- `purchase_key`
- `customer_key`
- `order_received_at`
- `delivery_distance_meters`
- `item_key`
- `item_name`
- `item_category`
- `brand_name`
- `quantity`
- `product_base_price`
- `discount_percentage`
- `is_on_promotion`
- `discount_amount_per_unit`
- `final_item_price_per_unit`
- `final_item_value`
- `total_basket_value`
- `wolt_service_fee`
- `courier_base_fee`

This model provides a **single analytics-ready source** that can be reused for different business analyses and business questions. 

[Big Query Questions link to answer task 1 questions] (https://github.com/Sonaligupta02/wolt_assignment_by_sonali/edit/main/README.md#:~:text=.gitignore-,Big_query_task_1,-.sql) 

