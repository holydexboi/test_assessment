CREATE TABLE IF NOT EXISTS public."DimProduct"
(
    "productId" integer NOT NULL,
    description character varying(255) COLLATE pg_catalog."default" NOT NULL,
    price double precision NOT NULL,
    stockcode integer NOT NULL,
    CONSTRAINT "DimStock_pkey" PRIMARY KEY ("productId", stockcode)
) PARTITION BY LIST (stockcode);

CREATE TABLE public."DimProduct_20000" PARTITION OF public."DimProduct"
    FOR VALUES FROM (20000) TO (30000);

CREATE TABLE public."DimProduct_DFLT" PARTITION OF public."DimProduct"
    DEFAULT;

CREATE INDEX "DimProduct_stockcode"
    ON public."DimProduct" USING btree
    (stockcode)