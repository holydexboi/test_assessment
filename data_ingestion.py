#!/usr/bin/env python
# coding: utf-8

import argparse
from time import time
import pandas as pd
import os
from sqlalchemy import create_engine


def main(params):

    user = params.user
    password = params.password
    db = params.db
    port = params.port
    host = params.host
    table_name = params.table_name
    url = params.url
    file_name = '/opt/airflow/dags/online_retail.csv'

    os.system(f'wget {url} -O {file_name}')

    conn = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')

    conn.connect()

    df_iteration = pd.read_csv(file_name, iterator=True, chunksize=100000)

    df = next(df_iteration)

    df['Index'] = df.index

    df = df.set_index('Index')

    df.InvoiceDate = pd.to_datetime(df.InvoiceDate)

    df.head(n=0).to_sql(name=table_name, con=conn, if_exists="replace", index=True, index_label="Index")

    df.to_sql(name=table_name, con=conn, if_exists="append", index=True, index_label="Index")

    i = 1

    try:
        while True:
            start_time = time()
            df = next(df_iteration)
            df['Index'] = df.index
            df = df.set_index('Index')
            df.InvoiceDate = pd.to_datetime(df.InvoiceDate)
            df.to_sql(name=table_name, con=conn, if_exists="append", index=True, index_label='Index')
        
            end_time= time()
            time_diff = end_time-start_time
            print(f'Successfully ingest {i} chunk(s) of data in {time_diff} second(s)')
            i+=1
    except:
        print('Data ingested successfully')

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Data ingestion from CSV data to Postgres")
    parser.add_argument("--user", help="username for postgres")
    parser.add_argument("--password", help="password for postgres")
    parser.add_argument("--host", help="host for postgres")
    parser.add_argument("--db", help="database name for the postgres")
    parser.add_argument("--port", help="port for postgres")
    parser.add_argument("--table_name", help="table where the result will be written to in postgres")
    parser.add_argument("--url", help="url to the csv file")

    args = parser.parse_args()
    main(args)




