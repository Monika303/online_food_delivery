# 🍽️ Online Food Delivery System — Database Project

> A fully normalized relational database for an online food delivery platform, implemented in **Microsoft SQL Server (T-SQL)** with a connected web-based admin interface.

---

## 📌 Project Overview

This project designs and implements a complete **relational database** for an Online Food Delivery System (OFDS). It covers the full database engineering lifecycle:

- Conceptual design with an **ER Diagram**
- **Relational schema** mapping
- **Normalization** to 3NF
- Full **SQL implementation** (DDL, DML, DQL, DCL)
- **Views**, **Indexes**, **Triggers**, and **Stored Procedures**
- A connected **admin web interface** (Harvest Admin Platform)

---

## 🗂️ Repository Structure

```
online_food_delivery/
│
├── database/
│   ├── creating_database.sql   # DDL — Creates all 12 tables with constraints
│   ├── data.sql                # DML — 40+ sample rows per table
│   ├── queries.sql             # DQL — 27 relational algebra queries
│   ├── views.sql               # 6 named views for reporting
│   ├── indexes.sql             # 17 non-clustered performance indexes
│   ├── triggers.sql            # 3 AFTER triggers for business rules
│   ├── stored_procedures.sql   # 5 stored procedures for workflows
│   └── dcl.sql                 # DCL — Roles, logins, and access control
│
└── UI/
    └── ...                     # Harvest Admin Platform (web interface)
```

---

## 🗃️ Database Schema

The database consists of **12 tables** covering all platform operations:

| Table | Description |
|-------|-------------|
| `USER` | Platform accounts: customers, drivers, and admins |
| `USER_PHONE` | Multi-valued phone numbers per user |
| `ADDRESS` | Delivery addresses owned by users |
| `RESTAURANT` | Registered restaurants with location and rating |
| `RESTAURANT_CUISINETYPE` | Multi-valued cuisine categories per restaurant |
| `RESTAURANT_PHONE` | Multi-valued contact phones per restaurant |
| `MENUITEM` | Dishes offered by each restaurant with pricing |
| `ORDERS` | Customer order headers with status tracking |
| `ORDERITEM` | Line items within each order |
| `PAYMENT` | Payment records (1:1 with orders) |
| `DELIVERY` | Fulfilment records linking orders to drivers |
| `FEEDBACK` | Post-delivery customer ratings and comments |

---

## ⚙️ Technical Highlights

### ✅ Normalization
All tables satisfy **1NF**, **2NF**, and **3NF**:
- Multi-valued attributes (phone numbers, cuisine types) extracted into dedicated tables
- Composite attributes (Name, Address, Location) decomposed into atomic columns
- No transitive dependencies across any table

### 🔒 Triggers (Business Rules)
| Trigger | Table | Rule Enforced |
|---------|-------|---------------|
| `trg_OrderItem_SyncTotalPrice` | ORDERITEM | Auto-recalculates `ORDERS.TotalPrice` on any item change |
| `trg_Feedback_ValidateDeliveredOrder` | FEEDBACK | Blocks feedback on non-delivered orders |
| `trg_UpdateRestaurantRating` | FEEDBACK | Auto-updates `RESTAURANT.Rating` from avg feedback |

### 📊 Views
| View | Purpose |
|------|---------|
| `vw_ActiveRestaurantsWithCuisines` | Restaurant directory with cuisine tags and phones |
| `vw_FullOrderSummary` | Complete order lifecycle in one flat result |
| `vw_MenuItemsWithRestaurant` | Available menu items with restaurant info |
| `vw_RestaurantFeedbackSummary` | Per-restaurant average rating and review count |
| `vw_DeliveryDriverPerformance` | Driver completion rates and delivery durations |
| `vw_UnservedCustomers` | Customers with orders but no delivery yet |

### 🔑 Stored Procedures
| Procedure | Purpose |
|-----------|---------|
| `usp_RegisterUser` | Atomically creates user + phone + address |
| `usp_PlaceOrder` | Validates and inserts order with items via JSON |
| `usp_UpdateDeliveryStatus` | Updates delivery status with timestamp sync |
| `usp_ProcessPayment` | Records payment and updates order status |
| `usp_GetRestaurantAnalytics` | Returns revenue, orders, and top dish per restaurant |

### 🔐 Access Control (RBAC)
Four roles with least-privilege grants:
- `app_customer` — browse, order, pay, review
- `app_driver` — view and update deliveries
- `app_restaurant` — manage own menu and view feedback
- `app_admin` — full access to all tables and procedures

---

## 📐 ER Diagram

The conceptual model was designed in **ERDPlus** following standard ER notation:
- Rectangles → entity sets
- Ellipses → attributes (double = multi-valued, parentheses = composite)
- Underlined → primary key attributes
- Diamonds → relationships with cardinality and participation constraints

![ER Diagram](docs/erd.png)

---

## 🖥️ Admin Interface — Harvest Platform

The database is connected to a web-based admin platform with the following pages, each backed by live database queries:

| Page | Database Objects Used |
|------|-----------------------|
| **Dashboard** | Aggregate COUNT/SUM/AVG queries + `vw_FullOrderSummary` + `vw_RestaurantFeedbackSummary` |
| **Restaurants** | `vw_ActiveRestaurantsWithCuisines`, `RESTAURANT_CUISINETYPE` |
| **Menu Items** | `vw_MenuItemsWithRestaurant`, `MENUITEM` |
| **Users** | `USER` with `UserType` filter (customer / driver / admin) |
| **Orders** | `vw_FullOrderSummary`, `ORDERS` GROUP BY Status |
| **Deliveries** | `DELIVERY` ⨝ `USER` ⨝ `ADDRESS` |
| **Payments** | `PAYMENT` with status breakdown |
| **Feedback** | `FEEDBACK` ⨝ `USER` ⨝ `RESTAURANT` ⨝ `ORDERS` |

---

## 🚀 How to Run

### Requirements
- Microsoft SQL Server 2019+ (or SQL Server 2022)
- SQL Server Management Studio (SSMS) 18+

### Execution Order

Run the scripts in the following order to respect referential integrity:

```sql
-- Step 1: Create the database and all tables
-- File: database/creating_database.sql

-- Step 2: Insert sample data (40+ rows per table)
-- File: database/data.sql

-- Step 3: Create performance indexes
-- File: database/indexes.sql

-- Step 4: Create views
-- File: database/views.sql

-- Step 5: Create triggers
-- File: database/triggers.sql

-- Step 6: Create stored procedures
-- File: database/stored_procedures.sql

-- Step 7: Set up roles and access control
-- File: database/dcl.sql

-- Step 8 (optional): Run all 27 DQL queries to verify
-- File: database/queries.sql
```

---

## 📊 Relational Algebra Queries

The project includes **27 queries** with formal relational algebra expressions and SQL equivalents, covering:

| Operation | Symbol | Example Queries |
|-----------|--------|-----------------|
| Selection | σ | Filter delivered orders, active restaurants |
| Projection | π | Subset of columns per user or order |
| Natural Join | ⨝ | USER ⨝ ORDERS, DELIVERY ⨝ ADDRESS |
| Union | ∪ | Users who ordered OR gave feedback |
| Intersection | ∩ | Users who ordered AND gave feedback |
| Set Difference | − | Users who never ordered, orders without delivery |

---

## 🛠️ Technology Stack

| Layer | Technology |
|-------|-----------|
| Database | Microsoft SQL Server 2022 (T-SQL) |
| Admin Tool | SQL Server Management Studio (SSMS) |
| Web Interface | HTML / CSS / JavaScript + Python backend |
| ER Design | ERDPlus |

---

## 📁 Topics

`sql` `tsql` `sql-server` `database-design` `normalization` `er-diagram` `relational-algebra` `food-delivery` `stored-procedures` `triggers` `views` `academic-project`

---

## 👤 Authors

**Monika,Gayane** — Database Systems Course Project, April 2026
