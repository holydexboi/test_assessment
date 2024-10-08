
BEGIN;


CREATE TABLE IF NOT EXISTS public."FactSales"
(
    "salesId" integer NOT NULL,
    quantity bigint NOT NULL,
    amount double precision NOT NULL,
    "invoiceNo" character varying(7) NOT NULL,
    "productId" integer NOT NULL,
    "customerId" integer NOT NULL,
    "monthId" integer NOT NULL,
    invoicedate timestamp without time zone NOT NULL,
    PRIMARY KEY ("salesId")
);

CREATE TABLE IF NOT EXISTS public."DimProduct"
(
    "productId" integer NOT NULL,
    "stockCode" integer NOT NULL,
    description character varying(255) NOT NULL,
    price double precision NOT NULL,
    PRIMARY KEY ("productId")
);

CREATE TABLE IF NOT EXISTS public."DimCustomer"
(
    "customerId" integer NOT NULL,
    customernumber integer NOT NULL,
    customername character varying(50) NOT NULL,
    country character varying(50) NOT NULL,
    PRIMARY KEY ("customerId")
);

CREATE TABLE IF NOT EXISTS public."DimMonth"
(
    "monthId" integer NOT NULL,
    year integer NOT NULL,
    month integer NOT NULL,
    monthname character varying(10) NOT NULL,
    quater integer NOT NULL,
    quatername character varying(2) NOT NULL,
    day integer NOT NULL,
    dayname character varying(10) NOT NULL,
    week integer NOT NULL,
    hour integer NOT NULL,
    minute integer NOT NULL,
    PRIMARY KEY ("monthId")
);

ALTER TABLE IF EXISTS public."FactSales"
    ADD FOREIGN KEY ("monthId")
    REFERENCES public."DimMonth" ("monthId") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public."FactSales"
    ADD FOREIGN KEY ("productId")
    REFERENCES public."DimProduct" ("productId") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public."FactSales"
    ADD FOREIGN KEY ("customerId")
    REFERENCES public."DimCustomer" ("customerId") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

END;