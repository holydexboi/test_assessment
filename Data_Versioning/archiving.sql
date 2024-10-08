CREATE TABLE afactsales_history (
    id SERIAL PRIMARY KEY,   
    salesId INT,       
    quantity INT,        
    amount double precision,   
    "productId" INT,
    "customerId" INT,
    "monthId" INT,
    invoicedate TIMESTAMP,
    "invoiceNo" TEXT,
    "createdAt" TIMESTAMP,
    "updatedAt" TIMESTAMP,    
    "actionType" VARCHAR(10)         
);

CREATE OR REPLACE FUNCTION public.update_archive()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    VOLATILE
    COST 100
AS $BODY$
BEGIN
  
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO factsales_history ("salesId", quantity, amount, "productId", "customerId", "monthId", invoicedate, "invoiceNo", "createdAt", "updatedAt", "actionType")
        VALUES (OLD."salesId", OLD.quantity, OLD.amount, OLD."productId", OLD."customerId", OLD."monthId", OLD.invoicedate, OLD."invoiceNo", OLD."createdAt", OLD."updatedAt", 'DELETE');
        RETURN OLD;

    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO factsales_history ("salesId", quantity, amount, "productId", "customerId", "monthId", invoicedate, "invoiceNo", "createdAt", "updatedAt", "actionType")
        VALUES (OLD."salesId", OLD.quantity, OLD.amount, OLD."productId", OLD."customerId", OLD."monthId", OLD.invoicedate, OLD."invoiceNo", OLD."createdAt", OLD."updatedAt", 'UPDATE');
        RETURN NEW;
    END IF;
END;
$BODY$;

CREATE OR REPLACE TRIGGER update_trigger
    AFTER DELETE OR UPDATE 
    ON public."FactSales"
    REFERENCING NEW TABLE AS factsales_history OLD TABLE AS "FactSales"
    FOR EACH ROW
    EXECUTE FUNCTION public.update_archive();