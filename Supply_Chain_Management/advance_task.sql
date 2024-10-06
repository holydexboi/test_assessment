--- STORE PROCEDURE TO UPDATE SHIPMENT RECORDS BASE ON DELAY
CREATE OR REPLACE PROCEDURE public.update_shipment(IN delay_in_day integer, IN shipment_id integer, IN shipment_value double precision)
    LANGUAGE 'plpgsql'
    
AS $BODY$
begin
	update shipment
	set "shipmentDate" = "shipmentDate" + INTERVAL '1 day' * delay_in_day,
	"shippingDuration" = "shippingDuration" + CONCAT(delay_in_day, ' ', 'DAY')::INTERVAL,
	"shipmentValue" = shipment_value
	where "shipmentId" = shipment_id;
end;
$BODY$;


--- CONSOLIDATED SUMMARY OF SHIPMENT AND PRODUCT PERFORMANCE USING GROUP BY
CREATE OR REPLACE VIEW public.shipment_product_summary_view
    AS
     SELECT pr."productName",
    pr."productCategory",
    avg(sh.quantity) AS average_quantity,
    sum(sh.quantity) AS total_quantity,
    min(sh.quantity) AS minimum_quantity,
    max(sh.quantity) AS maximum_quantity,
    count(sh."shipmentId") AS total_shipment
   FROM shipment sh
     JOIN product pr ON sh."productId" = pr."productId"
  GROUP BY pr."productName", pr."productCategory";

--- CONSOLIDATED SUMMARY OF SHIPMENT AND PRODUCT PERFORMANCE USING GROUP SET
CREATE OR REPLACE VIEW public.shipment_product_summary_view
    AS
     SELECT pr."productName",
    pr."productCategory",
    avg(sh.quantity) AS average_quantity,
    sum(sh.quantity) AS total_quantity,
    min(sh.quantity) AS minimum_quantity,
    max(sh.quantity) AS maximum_quantity,
    count(sh."shipmentId") AS total_shipment
   FROM shipment sh
     JOIN product pr ON sh."productId" = pr."productId"
  GROUP BY GROUPING SETS(pr."productName", pr."productCategory");


--- CONSOLIDATED SUMMARY OF SHIPMENT AND PRODUCT PERFORMANCE USING ROLL UP
CREATE OR REPLACE VIEW public.shipment_product_summary_view
    AS
     SELECT pr."productName",
    pr."productCategory",
    avg(sh.quantity) AS average_quantity,
    sum(sh.quantity) AS total_quantity,
    min(sh.quantity) AS minimum_quantity,
    max(sh.quantity) AS maximum_quantity,
    count(sh."shipmentId") AS total_shipment
   FROM shipment sh
   JOIN product pr ON sh."productId" = pr."productId"
  GROUP BY ROLLUP(pr."productName", pr."productCategory");

--- CONSOLIDATED SUMMARY OF SHIPMENT AND PRODUCT PERFORMANCE USING CUBE
CREATE OR REPLACE VIEW public.shipment_product_summary_view
    AS
     SELECT pr."productName",
    pr."productCategory",
    avg(sh.quantity) AS average_quantity,
    sum(sh.quantity) AS total_quantity,
    min(sh.quantity) AS minimum_quantity,
    max(sh.quantity) AS maximum_quantity,
    count(sh."shipmentId") AS total_shipment
   FROM shipment sh
   JOIN product pr ON sh."productId" = pr."productId"
  GROUP BY CUBE(pr."productName", pr."productCategory");


--- SUPPLIER WITH SIGNIFICANT INCREASE OR DECREASE IN SHIPMENT VALUES COMPARE TO PREVIOUS YEARS

WITH shipment_by_year AS (
    SELECT 
        s."supplierId",
        EXTRACT(YEAR FROM s."shipmentDate") AS shipment_year,
        SUM(s."shipmentValue") AS total_shipment_value
    FROM 
        shipment s
    GROUP BY 
        s."supplierId", shipment_year
),
shipment_comparison AS (
    SELECT 
        cur."supplierId",
        cur.shipment_year AS current_year,
        cur.total_shipment_value AS current_year_value,
        prev.total_shipment_value AS previous_year_value,
        CASE 
            WHEN prev.total_shipment_value IS NOT NULL 
            THEN ((cur.total_shipment_value - prev.total_shipment_value) / prev.total_shipment_value) * 100
            ELSE NULL
        END AS percentage_change
    FROM 
        shipment_by_year cur
    LEFT JOIN 
        shipment_by_year prev 
    ON cur."supplierId" = prev."supplierId" 
    AND cur.shipment_year = prev.shipment_year + 1
)
SELECT 
    "supplierId",
    current_year,
    current_year_value,
    previous_year_value,
    percentage_change
FROM 
    shipment_comparison
WHERE 
    percentage_change IS NOT NULL
ORDER BY 
    percentage_change DESC;


---- CREATING TABLE TO TRACK CHANGES IN THE SHIPMENT TABLE

CREATE TABLE IF NOT EXISTS shipment_history (
    history_id SERIAL PRIMARY KEY,
    shipment_id INTEGER,
    product_id INTEGER,
    supplier_id INTEGER,
    warehouse_id INTEGER,
    order_id INTEGER,
    shipment_date TIMESTAMP,
    quantity INTEGER,
    time_id INTEGER,
    shipping_duration INTERVAL,
    shipment_value DOUBLE PRECISION,
    action_type VARCHAR(10),  
    change_time TIMESTAMP DEFAULT NOW()
);


----- TRIGGER FUNCTION TO AUTOMATICALLY UPDATE HISTORICAL TRACKING TABLE
CREATE OR REPLACE FUNCTION log_shipment_changes()
RETURNS TRIGGER AS $$
BEGIN
   
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO shipment_history (shipment_id, product_id, supplier_id, warehouse_id, order_id, shipment_date, quantity, time_id, shipping_duration, shipment_value, action_type)
        VALUES (OLD."shipmentId", OLD."productId", OLD."supplierId", OLD."warehouseId", OLD."orderId", OLD."shipmentDate", OLD.quantity, OLD."timeId", OLD."shippingDuration", OLD."shipmentValue", 'DELETE');
        RETURN OLD;

    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO shipment_history (shipment_id, product_id, supplier_id, warehouse_id, order_id, shipment_date, quantity, time_id, shipping_duration, shipment_value, action_type)
        VALUES (OLD."shipmentId", OLD."productId", OLD."supplierId", OLD."warehouseId", OLD."orderId", OLD."shipmentDate", OLD.quantity, OLD."timeId", OLD."shippingDuration", OLD."shipmentValue", 'UPDATE');
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;


--- TRIGGER EVENT ON SHIPMENT TABLE TO TRACK DELETE AND UPDATE ACTION
CREATE OR REPLACE TRIGGER update_history
    AFTER DELETE OR UPDATE 
    ON public.shipment
    FOR EACH ROW
    EXECUTE FUNCTION public.log_shipment_changes();