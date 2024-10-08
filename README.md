# Test_assessment

## Overview

Online retail sales ETL pipeline solution. The solution uses apache airflow for automating and scheduling the data pipeline, ensuring data integrity, and optimizing performance.

## Project Structure
```bash
    .
    ├── dags/                       # Folder Containing all the ETL file use by apache airflow for orchestration
    ├── Data_Quality_Monitoring     # Folder Containing the images of alert and monitoring setup for the ETL pipeline 
    ├── Data_Versioning             # Folder Containing SQL file used for implementing data versioning and update tracking
    ├── Datawarehouse_Schema        # Folder Containing SQL file and image to create Data Warehouse for Online retail
    ├── Metadata_Management         # Folder Containing SQL file to create metadata for the dataset and tables
    ├── Partition_and_index         # Folder containing SQL file to create partition and index on the FACT and DIMENSIONAL table of DWH
    ├── Performance_optimization    # Folder Containing SQL file and image of evaluation and analysis of the DWH tables
    ├── .gitignore                  # Containing list of files and folder of the project not push to github
    ├── data_cleaning_validation.ipynb  # Jupyter file used to initially implement data cleaning and validation 
    ├── data_cleaning_validation.py # Python file used to implement data cleaning and validation 
    ├── data_ingestion.ipynb        # Jupyter file used to initially implement data ingestion 
    ├── data_ingestion.py           # Python file used to implement data ingestion 
    ├── data_transform_load.ipynb   # Jupyter file used to initially implement data tranformation and loading 
    ├── data_transform_load.py      # Python file used to implement data transformation and loading
    ├── docker-compose.yaml         # Containing docker images use for running the project
    ├── online_retail_etl_dag.py    # Python file use for defining the ETL and dag implementation  
    ├── README.md                   # Project documentation
    
```

## Technologies Used
- Database: Postgres
- GUI: pgAdmin
- Language: Python, SQL, PL/pgSQL
- Libraries: Pandas, SQLalchemy, matplotlib
- Orchestration: Apache Airflow

## Setup Instructions:
1. Clone this repository or download the project zip file
```bash

    git clone https://github.com/holydexboi/test_assessment.git
    cd test_assessment

```
2. Create volume folder to mount your docker container files and data
```bash
        mkdir online_retail_data plugins redis_data logs data_pgadmin
```

3. Run docker-compose file to start the postgres database, pgAdmin and apache airflow
```bash
        docker-compose up -d
```

4. Access pgAdmin from your browser with the link below and create database "online_retail"
```bash
    http://localhost:8081/ 
```
5. Access pgAdmin from your browser with the link below and look for "online-retail-etl-dag" DAG and trigger start
```bash
    http://localhost:8080/ 
```
6. You can then view the Data Warehouse table on PgAdmin on your browser