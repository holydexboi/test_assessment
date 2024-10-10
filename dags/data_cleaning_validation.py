#!/usr/bin/env python
# coding: utf-8

import argparse
import pandas as pd
from sqlalchemy import create_engine, text


# Function handling missing value
def handle_missing_value(df):

    # #### Removing null value in **Description** column
    df = df[df['Description'].notnull()]

    # #### Removing null value in **CustomerID** since it can not be predicted 
    df = df[df['CustomerID'].notnull()]

    # #### Verifying no more missing value
    df.isnull().sum()

    return df

# Function handling duplicate records
def handle_duplicate_value(df):
    # #### Dropping duplicate records

    df = df.drop_duplicates()

    return df

# Function handling Outliers
def handle_outliers(df):

    # #### Changing all negative value to Positive with an assumption that its input error
    df.loc[df['Quantity'] < 0, 'Quantity'] = df.loc[df['Quantity'] < 0, 'Quantity'] * -1

    # #### Setting all Quantity above 250 to 250
    df.loc[df['Quantity'] > 250, 'Quantity'] = 250

    # ### Setting all price above 2000 to 2000
    df.loc[df['UnitPrice'] > 2000, 'UnitPrice'] = 2000.00

    return df

# Function handling  Consistency and Integrity
def handle_integrity_consistency(df):

    # ### Making sure **InvoiceNo** column meets the rule: Invoice number. Nominal, a 6-digit integral number uniquely assigned to each transaction. If this code starts with letter 'c', it indicates a cancellation
    df.loc[:,'Valid_InvoiceNo'] = df['InvoiceNo'].apply(lambda x: x.isdigit() and len(x) == 6 or x.startswith('C'))

    df = df[df['Valid_InvoiceNo']]

    # ### Making sure **StockCode** column meet the rule: Product (item) code. Nominal, a 5-digit integral number uniquely assigned to each distinct product.

    df['StockCode'] = df['StockCode'].str.replace(r'[A-Za-z]', '', regex=True)

    df.loc[:,'Valid_StockCode'] = df['StockCode'].apply(lambda x: x.isdigit() and len(x) == 5)
    df = df[df['Valid_StockCode']]

    # ### Making sure CustomerID meet rule: Customer number. Nominal, a 5-digit integral number uniquely assigned to each customer
    df['CustomerID'] = df['CustomerID'].astype(int)

    df.loc[:,'Valid_CustomerID'] = df['CustomerID'].apply(lambda x: str(x).isdigit() and len(str(x)) == 5)
    df = df[df['Valid_CustomerID']]

    df = df.drop(columns=['Valid_InvoiceNo', 'Valid_StockCode', 'Valid_CustomerID'])

    df = df.reset_index(drop=True)

    return df


def main(params):

    user = params.user
    password = params.password
    db = params.db
    port = params.port
    host = params.host
    table_name = params.table_name

    conn = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')

    conn.connect()

    df = pd.read_sql('select * from retail_data', con=conn, index_col='Index')

    # Handling missing value
    clean_missing = handle_missing_value(df)

    no_null = clean_missing.isna().sum().sum()
    assert no_null == 0

    # # Handling duplicate records
    clean_duplicate = handle_duplicate_value(clean_missing)
    assert clean_duplicate.duplicated().sum() == 0
    
    # # Handling Outliers
    clean_outlier = handle_outliers(clean_duplicate)

    # # Handling  Consistency and Integrity
    clean_integrity = handle_integrity_consistency(clean_outlier) 


    clean_integrity.to_sql(name=table_name, con=conn, if_exists='replace', index=True, index_label='Id')
    print('Successfully load cleaned data')

    alter_query = """ 

    ALTER TABLE "retail_cleaned_data" ADD PRIMARY KEY ("Id");

    """
    with conn.connect() as connection:
        connection.execute(text(alter_query))

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Data cleaning and validation to Staging area")
    parser.add_argument("--user", help="username for postgres")
    parser.add_argument("--password", help="password for postgres")
    parser.add_argument("--host", help="host for postgres")
    parser.add_argument("--db", help="database name for the postgres")
    parser.add_argument("--port", help="port for postgres")
    parser.add_argument("--table_name", help="table where the result will be written to in postgres")

    args = parser.parse_args()
    main(args)