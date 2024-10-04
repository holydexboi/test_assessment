BEGIN;


CREATE TABLE IF NOT EXISTS public.shipment
(
    "shipmentId" integer NOT NULL,
    "productId" integer,
    "supplierId" integer,
    "warehouseId" integer,
    "orderId" integer,
    "shipmentDate" timestamp without time zone,
    quantity integer,
    "timeId" integer,
    "shippingDuration" interval,
    "shipmentValue" double precision,
    PRIMARY KEY ("shipmentId")
);

CREATE TABLE IF NOT EXISTS public.product
(
    "productId" integer NOT NULL,
    "productName" character varying(255),
    price double precision,
    "productCategory" character varying(255),
    PRIMARY KEY ("productId")
);

CREATE TABLE IF NOT EXISTS public.supplier
(
    "supplierId" integer NOT NULL,
    "supplierName" character varying(255),
    PRIMARY KEY ("supplierId")
);

CREATE TABLE IF NOT EXISTS public.warehouse
(
    "warehouseId" integer NOT NULL,
    "warehouseName" character varying(255),
    location character varying(255),
    PRIMARY KEY ("warehouseId")
);

CREATE TABLE IF NOT EXISTS public."order"
(
    "orderId" integer NOT NULL,
    "customerName" character varying,
    "orderDate" timestamp without time zone,
    PRIMARY KEY ("orderId")
);

CREATE TABLE IF NOT EXISTS public."time"
(
    "timeId" integer NOT NULL,
    year integer,
    month integer,
    "monthName" character varying(50),
    day integer,
    dayname character varying(50),
    week integer,
    PRIMARY KEY ("timeId")
);

ALTER TABLE IF EXISTS public.shipment
    ADD FOREIGN KEY ("productId")
    REFERENCES public.product ("productId") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.shipment
    ADD FOREIGN KEY ("supplierId")
    REFERENCES public.supplier ("supplierId") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.shipment
    ADD FOREIGN KEY ("warehouseId")
    REFERENCES public.warehouse ("warehouseId") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.shipment
    ADD FOREIGN KEY ("orderId")
    REFERENCES public."order" ("orderId") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.shipment
    ADD FOREIGN KEY ("timeId")
    REFERENCES public."time" ("timeId") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

END;