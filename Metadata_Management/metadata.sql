CREATE TABLE data_sources (
    source_id SERIAL PRIMARY KEY,
    source_name VARCHAR(255),
    source_type VARCHAR(255),  
    location_details TEXT,     
    last_updated TIMESTAMP
);

CREATE TABLE data_tables (
    table_id SERIAL PRIMARY KEY,
    source_id INT REFERENCES data_sources(source_id),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);


CREATE TABLE table_schema (
    column_id SERIAL PRIMARY KEY,
    table_name VARCHAR(255),
    column_name VARCHAR(255),
    data_type VARCHAR(100),
    is_nullable BOOLEAN,
    is_primary_key BOOLEAN,
    table_id INT REFERENCES data_sources(table_id)
);

CREATE TABLE data_transformations (
    transformation_id SERIAL PRIMARY KEY,
    transformation_description TEXT, 
    input_table VARCHAR(255),
    output_table VARCHAR(255),
    applied_on TIMESTAMP DEFAULT NOW(),
    source_id INT REFERENCES data_sources(source_id)
);

CREATE TABLE storage_locations (
    storage_id SERIAL PRIMARY KEY,
    location_name VARCHAR(255),   
    storage_type VARCHAR(255),    
    connection_details TEXT,
    source_id VARCHAR(255),
    last_updated TIMESTAMP
);
