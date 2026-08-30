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
- **dbt** – Data transformation and modelling
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
Performance Analysis
   ↓
Data Studio Dashboard
```

The main idea is to perform complex transformations once in dbt so that downstream analysts can work with clean datasets and simple SQL queries.

# dbt Model Structure

## 1. Staging Layer

Clean and standardize raw purchases, product logs, and promotion data while keeping the source information consistent.

- `stg_purchases`
- `stg_item_logs`
- `stg_promos`

The staging layer prepares the raw data before applying business logic.

## 2. Intermediate Layer 

This intermediate layer contains reusable transformations, joins, and business logic, combining orders, products, pricing, and promotion data to create a consistent dataset ready for further analysis.

Main intermediate models include:

- `int_item_history`
- `int_order_items`
- `int_order_item_pricing`
- `int_order_item_promotions`

This layer combines order, customer, product, pricing, and promotion information.

## 3. Mart Layer

The final business-ready fact table, fct_order_items, combines customer, product, revenue, promotion, delivery, and fee information into a single analytics-ready dataset for business analysis.

### `fct_order_items`


This is the main dataset created for the Analytics Team. 


This model provides a **single analytics-ready source** that can be reused for different business analyses and business questions. 

#### Data Grain

The main `fct_order_items` mart is built at the **order-item level**.

Each row represents an item within a customer order.

Order-level values such as basket value, Wolt service fee, and courier fee may repeat across multiple item rows. Therefore, these metrics are first aggregated to the order level when calculating total or average order-level costs.

## Task 1 Questions
[Open BigQuery SQL File] (https://github.com/Sonaligupta02/wolt_assignment_by_sonali/blob/main/Big_query_task_1.sql) 
Queries used to analyze the transformed data and answer the Task 1 business questions.

## Task 2 – Business Analysis & Dashboard
[Open Data Studio Dashboard] [https://datastudio.google.com/u/0/reporting/fce98fd5-bb32-4a51-8218-3920c75b23b9/page/xrY7F]
Interactive dashboard showing category performance, star products, customer behaviour, trends, insights, and recommendations.


