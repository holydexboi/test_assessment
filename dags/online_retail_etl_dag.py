# importing the libraries

from datetime import timedelta
from airflow.models import DAG
from airflow.operators.bash import BashOperator
from airflow.utils.dates import days_ago



#defining DAG arguments

default_args = {
    'owner': 'Zulikif',
    'start_date': days_ago(0),
    'email': ['zulikiffolawiyo@gmail.com'],
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}


# defining DAG
dag = DAG(
    dag_id='online-retail-etl-dag',
    default_args=default_args,
    description='Online Retail ETL DAG',
    schedule_interval=timedelta(days=1),
)

data_ingestion = BashOperator(
        task_id='run_data_ingestion',
        bash_command="""
        python /opt/airflow/dags/data_ingestion.py \
        --user {{ var.value.postgres_user }} \
        --password {{ var.value.postgres_password }} \
        --host {{ var.value.postgres_host }} \
        --db {{ var.value.postgres_db }}  \
        --port {{ var.value.postgres_port }} \
        --table_name retail_data \
        --url {{ var.value.postgres_url }}
        """,
        dag=dag
    )

data_validation = BashOperator(
        task_id='run_data_validation',
        bash_command="""
        python /opt/airflow/dags/data_cleaning_validation.py \
        --user {{ var.value.postgres_user }} \
        --password {{ var.value.postgres_password }} \
        --host {{ var.value.postgres_host }} \
        --db {{ var.value.postgres_db }}  \
        --port {{ var.value.postgres_port }} \
        --table_name retail_cleaned_data
        """,
        dag=dag
    )

data_transformation = BashOperator(
        task_id='run_data_transformation',
        bash_command="""
        python /opt/airflow/dags/data_transform_load.py \
        --user {{ var.value.postgres_user }} \
        --password {{ var.value.postgres_password }} \
        --host {{ var.value.postgres_host }} \
        --db {{ var.value.postgres_db }}  \
        --port {{ var.value.postgres_port }} 
        """,
        dag=dag
    )

data_ingestion >> data_validation >> data_transformation