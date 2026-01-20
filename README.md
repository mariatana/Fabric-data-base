# Fabric-data-base
Oracle PL/SQL Toy Factory Management System
## 🛠️ Tech Stack & Concepts
* **Database:** Oracle Database (21c/19c)
* **Language:** PL/SQL, SQL
* **Key Concepts Implemented:**
    * **Modular Architecture:** Used Packages (`CREATE PACKAGE`) to encapsulate business logic.
    * **Advanced Data Structures:** Utilized Collections (`VARRAY`, `NESTED TABLE`, `ASSOCIATIVE ARRAY`) for in-memory data processing.
    * **Automation:** Implemented Triggers (Row-level & Statement-level) for data synchronization and security enforcement.
    * **Auditing:** Built DDL Triggers (`AFTER CREATE/DROP`) to log structural changes in the schema.
    * **Complex Querying:** Used Parameterized Cursors and Joins across 5+ tables.
    * **Error Handling:** Custom User-Defined Exceptions and Transaction Control.

## 🚀 Key Features

### 1. Automated Monthly Processing (The Master Package)
A unified package that orchestrates the factory's closing month routine:
* **Resource Balancing:** Automatically updates production lines operating below average capacity.
* **Financial Dashboard:** Calculates key performance indicators (MVP Client, NGO Discounts).
* **Quality Audit:** Generates detailed reports on raw materials using complex collections.

### 2. Security & Compliance
* **Work-Hour Restrictions:** A Statement-Level Trigger prevents table modifications outside of business hours (08:00 - 18:00) and on weekends.
* **Schema Audit:** A DDL Trigger logs every `CREATE`, `ALTER`, or `DROP` command into a dedicated audit table using system context functions.

### 3. Data Synchronization
* **Real-time Inventory:** A Row-Level Trigger automatically updates the transporter's fleet count whenever a vehicle is inserted or deleted.

## 📂 Database Schema
The project is built upon a relational schema including:
* `CLIENT`, `COMANDA`, `DETALIU` (Sales flow)
* `JUCARIE`, `LINIE_PRODUCTIE`, `MATERIE_PRIMA` (Production flow)
* `TRANSPORTATOR`, `MIJLOC_DE_TRANSPORT` (Logistics)
