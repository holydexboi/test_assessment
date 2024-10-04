CREATE TABLE archive_table (
    id SERIAL PRIMARY KEY,   
    customerId INT,       
    customernumber INT,        
    customername TEXT,   
    country TEXT,
    createdAt TIMESTAMP,
    updated_at TIMESTAMP,     
    operation VARCHAR(10)         
);

CREATE OR REPLACE FUNCTION archive_data() 
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        
        INSERT INTO "DimCustomer_archive" ("customerId", customernumber, customername, country, "createdAt", "updatedAt", operation)
        VALUES (OLD."customerId", OLD.customernumber, OLD.customername, OLD.country, OLD."createdAt", NOW(), 'DELETE');
        RETURN OLD;

    ELSIF TG_OP = 'UPDATE' THEN
        
        INSERT INTO "DimCustomer_archive" ("customerId", customernumber, customername, country, "createdAt", "updatedAt", operation)
        VALUES (OLD."customerId", OLD.customernumber, OLD.customername, OLD.country, OLD."createdAt", NOW(), 'DELETE');
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION archive_data() 
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        
        INSERT INTO "DimCustomer_archive" ("customerId", customernumber, customername, country, "createdAt", "updatedAt", operation)
        VALUES (OLD."customerId", OLD.customernumber, OLD.customername, OLD.country, OLD."createdAt", NOW(), 'DELETE');
        RETURN OLD;

    ELSIF TG_OP = 'UPDATE' THEN
        
        INSERT INTO "DimCustomer_archive" ("customerId", customernumber, customername, country, "createdAt", "updatedAt", operation)
        VALUES (OLD."customerId", OLD.customernumber, OLD.customername, OLD.country, OLD."createdAt", NOW(), 'DELETE');
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;