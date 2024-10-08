CREATE TABLE IF NOT EXISTS public."DimCustomer"
(
    "customerId" integer NOT NULL,
    customernumber integer NOT NULL,
    customername character varying(50) COLLATE pg_catalog."default" NOT NULL,
    country character varying(50) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "DimCustomer_pkey" PRIMARY KEY ("customerId", country)
) PARTITION BY LIST (country);

ALTER TABLE IF EXISTS public."DimCustomer"
    OWNER to root;

CREATE TABLE public."DimCustomer_UK" PARTITION OF public."DimCustomer"
    FOR VALUES IN ("United Kingdom");

CREATE TABLE public."DimCustomer_FR" PARTITION OF public."DimCustomer"
    FOR VALUES IN ("France");

CREATE TABLE public."DimCustomer_GER" PARTITION OF public."DimCustomer"
    FOR VALUES IN ("Germany");

CREATE TABLE public."DimCustomer_SPN" PARTITION OF public."DimCustomer"
    FOR VALUES IN ("Spain");

CREATE TABLE public."DimCustomer_DFLT" PARTITION OF public."DimCustomer"
    DEFAULT;

CREATE INDEX "DimCustomer_country"
    ON public."DimCustomer" USING btree
    (country)

CREATE INDEX "DimCustomer_customernumber"
    ON public."DimCustomer" USING btree
    (customername)