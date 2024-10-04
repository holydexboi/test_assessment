CREATE TABLE data_sources (
    source_id SERIAL PRIMARY KEY,
    source_name VARCHAR(255),
    source_type VARCHAR(255),  
    location_details TEXT,     
    last_updated TIMESTAMP
);


CREATE TABLE data_schema (
    schema_id SERIAL PRIMARY KEY,
    table_name VARCHAR(255),
    column_name VARCHAR(255),
    data_type VARCHAR(100),
    is_nullable BOOLEAN,
    is_primary_key BOOLEAN,
    source_id INT REFERENCES data_sources(source_id)
);