#!/usr/bin/env python
# coding: utf-8

import argparse
from sqlalchemy import create_engine
import pandas as pd
from time import time

# Function to load DimDate
def transform_load_DimDate(df_clean, conn):
    df_clean_date = pd.DataFrame({
        'year': df_clean['InvoiceDate'].dt.year,
        'month': df_clean['InvoiceDate'].dt.month,
        'monthname': df_clean['InvoiceDate'].dt.month_name(),
        'quater': df_clean['InvoiceDate'].dt.quarter,
        'quatername': 'Q' + df_clean['InvoiceDate'].dt.quarter.astype(str),
        'day': df_clean['InvoiceDate'].dt.day,
        'dayname': df_clean['InvoiceDate'].dt.day_name(),
        'week': df_clean['InvoiceDate'].dt.isocalendar().week,
        'hour': df_clean['InvoiceDate'].dt.hour,
        'minute': df_clean['InvoiceDate'].dt.minute,
    }).drop_duplicates()


    dateQuery = """
    SELECT year, month, monthname, quater, quatername, day, dayname, week, hour, minute FROM "DimMonth"
    """

    dimDate = pd.read_sql(dateQuery, con=conn)

    merged_df = df_clean_date.merge(dimDate, on=['year', 'month', 'monthname', 'quater', 'quatername', 'day', 'dayname', 'week', 'hour', 'minute'], how='left', indicator=True)

    update_date = merged_df[merged_df['_merge'] == 'left_only'].drop(columns='_merge')

    dimDate_Id = pd.read_sql("""
    SELECT max("monthId") From "DimMonth"
    """, con=conn)

    if dimDate_Id['max'][0] == None:
        update_date['monthId'] = range(1, len(update_date) + 1)
    else:
        update_date['monthId'] = range(dimDate_Id['max'][0] + 1, len(update_date) + dimDate_Id['max'][0] + 1 )



    update_date = update_date.set_index('monthId')

    start_time = time()
    update_date.to_sql(name='DimMonth', con=conn, if_exists='append')
    end_time = time()
    time_diff = end_time - start_time
    print(f"Successfully load data in DimMonth in {time_diff} seconds")

#Function to transform and load DimCustomer
def transform_load_DimCustomer(df_clean, conn):
    df_clean_customer = pd.DataFrame({
        'customernumber': df_clean['CustomerID'],
        'country': df_clean['Country'] 
    }).drop_duplicates()


    customerQuery = """
    SELECT customernumber, country FROM "DimCustomer"
    """

    dimCustomer = pd.read_sql(customerQuery, con=conn)

    merged_df = df_clean_customer.merge(dimCustomer, on=['customernumber', 'country'], how='left', indicator=True)

    update_customer = merged_df[merged_df['_merge'] == 'left_only'].drop(columns='_merge')


    dimCustomer_Id = pd.read_sql("""
    SELECT max("customerId") From "DimCustomer"
    """, con=conn)


    if dimCustomer_Id['max'][0] == None:
        update_customer['customerId'] = range(1, len(update_customer) + 1)
        update_customer['customername'] = ['Customer ' + str(i) for i in range(1, len(update_customer) + 1)]
    else:
        update_customer['customerId'] = range(dimCustomer_Id['max'][0] + 1, len(update_customer) + dimCustomer_Id['max'][0] + 1)
        update_customer['customername'] = ['Customer ' + str(i) for i in range(dimCustomer_Id['max'][0] + 1 , len(update_customer) + dimCustomer_Id['max'][0] + 1)]

    update_customer = update_customer.set_index('customerId')


    start_time = time()
    update_customer.to_sql(name='DimCustomer', con=conn, if_exists='append')
    end_time = time()
    time_diff = end_time - start_time
    print(f"Successfully load data in DimCustomer in {time_diff} seconds")

# Function to transform and load DimProduct 
def transform_load_DimProduct(df_clean, conn):
    df_clean_stock = pd.DataFrame({
        'description': df_clean['Description'],
        'price': df_clean['UnitPrice'],
        'stockcode': df_clean['StockCode'],
    }).drop_duplicates()


    stockQuery = """
    SELECT description, price, stockcode FROM "DimProduct"
    """

    dimStock = pd.read_sql(stockQuery, con=conn)

    df_clean_stock['stockcode'] = df_clean_stock['stockcode'].astype(int)

    merged_df = df_clean_stock.merge(dimStock, on=['description', 'price', 'stockcode'], how='left', indicator=True)

    update_stock = merged_df[merged_df['_merge'] == 'left_only'].drop(columns='_merge')


    dimStock_Id = pd.read_sql("""
    SELECT max("productId") From "DimProduct"
    """, con=conn)


    if dimStock_Id['max'][0] == None:
        update_stock['productId'] = range(1, len(update_stock) + 1)
    else:
        update_stock['productId'] = range(dimStock_Id['max'][0] + 1, len(update_stock) + dimStock_Id['max'][0] + 1)


    update_stock = update_stock.set_index('productId')


    start_time = time()
    update_stock.to_sql(name='DimProduct', con=conn, if_exists='append')
    end_time = time()
    time_diff = end_time - start_time
    print(f"Successfully load data in DimProduct in {time_diff} seconds")

# Function to transform and load FactSales Table
def transform_load_FactSales(conn):
    clean_data_fact_query = """
    SELECT rcd."Quantity", rcd."UnitPrice", 
    rcd."InvoiceNo", rcd."InvoiceDate", 
    rcd."StockCode", rcd."Description", 
    rcd."CustomerID", rcd."Country", 
    DimProduct."productId", dat."monthId",
    DimCustomer."customerId"
    FROM retail_cleaned_data AS rcd
    INNER JOIN "DimMonth" AS dat
    ON TO_TIMESTAMP(CONCAT(dat.year, '-', dat.month, '-', dat.day, ' ', dat.hour, ':', dat.minute), 'YYYY-MM-DD HH24:MI')  = rcd."InvoiceDate"
    INNER JOIN "DimCustomer" AS DimCustomer 
    ON DimCustomer.customernumber = rcd."CustomerID"
    AND DimCustomer.country = rcd."Country"
    INNER JOIN "DimProduct" AS DimProduct
    ON DimProduct.stockcode::text = rcd."StockCode"
    AND DimProduct.description = rcd."Description"
    AND DimProduct.price = rcd."UnitPrice"

    """

    clean_data_fact = pd.read_sql(clean_data_fact_query, con=conn)


    df_clean_sales = pd.DataFrame({
        'quantity': clean_data_fact['Quantity'],
        'amount': (clean_data_fact['UnitPrice'] * clean_data_fact['Quantity']).round(2),
        'invoiceNo': clean_data_fact['InvoiceNo'],
        'productId': clean_data_fact['productId'],
        'customerId': clean_data_fact['customerId'],
        'monthId': clean_data_fact['monthId'],
        'invoicedate': clean_data_fact['InvoiceDate'],
        'stockcode': clean_data_fact['StockCode'],
        'price': clean_data_fact['UnitPrice'],
        'description': clean_data_fact['Description'],
        'customernumber': clean_data_fact['CustomerID'],
        'country': clean_data_fact['Country']
        
    }).drop_duplicates()

    df_clean_sales['stockcode'] = df_clean_sales['stockcode'].astype(int)

    salesQuery = """
    SELECT factsal.quantity, factsal.amount, factsal."invoiceNo", factsal.invoicedate, sto."productId", cus."customerId", dat."monthId", sto.stockcode, sto.price, sto.description, cus.customernumber, cus.country FROM "FactSales" AS factsal
    INNER JOIN "DimProduct" AS sto
    ON factsal."productId" = sto."productId"
    INNER JOIN "DimCustomer" AS cus
    ON factsal."customerId" = cus."customerId"
    INNER JOIN "DimMonth" AS dat
    ON factsal."monthId" = dat."monthId"
    """


    factSales = pd.read_sql(salesQuery, con=conn)


    merged_df = df_clean_sales.merge(factSales, on=['quantity', 'amount', 'invoiceNo', 'invoicedate', 'productId', 'customerId', 'monthId', 'stockcode', 'price', 'description', 'customernumber', 'country'], how='left', indicator=True)

    update_sales = merged_df[merged_df['_merge'] == 'left_only'].drop(columns='_merge')


    factSales_Id = pd.read_sql("""
    SELECT max("salesId") From "FactSales"
    """, con=conn)

    
    if factSales_Id['max'][0] == None:
        update_sales['salesId'] = range(1, len(update_sales) + 1)
    else:
        update_sales['salesId'] = range(factSales_Id['max'][0] + 1, len(update_sales) + factSales_Id['max'][0] + 1)



    update_sales = update_sales.set_index('salesId')


    update_sales = update_sales.drop(columns=['stockcode', 'price', 'description', 'customernumber', 'country'])



    start_time = time()
    update_sales.to_sql(name='FactSales', con=conn, if_exists='append', chunksize=10000)
    end_time = time()
    time_diff = end_time - start_time
    print(f"Successfully load data in FactSales in {time_diff} seconds")


def main(params):

    user = params.user
    password = params.password
    db = params.db
    port = params.port
    host = params.host
    
    conn = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')

    clean_data_query = 'SELECT * FROM retail_cleaned_data'

    df_clean = pd.read_sql(clean_data_query, con=conn)

    # Transform and load DimMonth Table
    transform_load_DimDate(df_clean, conn)

    #Transform and load DimCustomer Table
    transform_load_DimCustomer(df_clean, conn)
    
    #Tranform and load DimProduct Table 
    transform_load_DimProduct(df_clean, conn)

    #Transform and load FactSales Table
    transform_load_FactSales(conn)
    

    
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Data cleaning and validation to Staging area")
    parser.add_argument("--user", help="username for postgres")
    parser.add_argument("--password", help="password for postgres")
    parser.add_argument("--host", help="host for postgres")
    parser.add_argument("--db", help="database name for the postgres")
    parser.add_argument("--port", help="port for postgres")

    args = parser.parse_args()
    main(args)



