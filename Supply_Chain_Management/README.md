# Supply Chain Management Data Warehouse Solution

## Overview

The Data Warehouse Solution is designed to have 7 Tables which include shipment, product, supplier, warehouse, time, order and shipment_history to manage historical data. The system is built using PostgreSQL.

## Project Structure
```bash
    .
    ├── Supply_Chain_Management/
    |   ├── Advance_Task_Images         # Folder Containing the images of the Advance Task query solution 
    |   ├── Task1_Images                # Folder Containing the images of the First Task query solution 
    |   ├── advance_task.sql            # SQL script containing the advance task query solution
    |   ├── create_table.sql            # SQL script for initializing the database
    |   ├── insert_data.sql             # SQL script for inserting sample data
    |   ├── supply_chain_schema.png     # Image of the ERD diagram of the Data Warehouse
    |   ├── task_1.sql                  # SQL script containing the first task query solution
    |   ├── README.md                   # Project documentation
    └── docker-compose.yaml
```
## Technologies Used
- Database: Postgres
- GUI: pgAdmin
- Language: SQL, PL/pgSQL

## Database Schema

- shipment: Tracks information about each shipment, including the product, supplier, warehouse, order, quantity, shipment value, shipment duration and shipment date.
- product: Contains information about product name, category and price.
- supplier: Contains supplier details.
- warehouse: Contains details of warehouse including name and location.\
- order: Contains information about customer orders.
- time: shipment date-related information, including year, month, and day.

## Schema Overview:
```bash
- shipment (shipmentId, productId, supplierId, warehouseId, orderId, shipmentDate, quantity, timeId, shippingDuration, shipmentValue)
- product (productId, productName, price, productCategory)
- supplier (supplierId, supplierName)
- warehouse (warehouseId, warehouseName, location)
- order (orderId, customerName, orderDate)
- time (timeId, year, month, monthName, day, dayname, week)
```

## Setup Instructions:
1. Clone this repository or download the project following the [link](#project-structure)
```bash

    git clone https://github.com/holydexboi/test_assessment.git
    cd test_assessment

```
2. Run docker-compose file to start the postgres database and pgAdmin
```bash
        docker-compose up -d
```
3. Get the container name running the postgres database
```bash
    docker-compose ps
```
4. Access the terminal running the database
```bash
    docker-compose exec pg-database bash
```
5. Login to the database
```bash
    psql --u root --db postgres
```
6. Create database for the Data Warehouse
```bash
    CREATE DATABASE shipment_dwh
```
7. Create all tables for the Data Warehouse
```bash
    psql -d shipment_dwh -f create_table.sql
```
#### Alternatively
- Access pgAdmin on http://localhost:8081/  in your browser
- Run all the querys in the sql file in the Query Tool of the pgAdmin

## Features
- ### Shipment Data Management
    - Manage and track shipment records using the shipment table

- ### Historical Tracking
    - Triggers are implemented to track any modifications or deletions to shipment data, ensuring auditability.

- ### Stored Procedures
    - Procedures to handle real-time business logic, like adjusting shipment data due to delays.

- ### Reports
    - Generate reports for analyzing shipment performance, such as total shipment quantities per product category.
     

