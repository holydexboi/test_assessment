CREATE TABLE IF NOT EXISTS public."DimProduct"
(
    "productId" integer NOT NULL,
    description character varying(255) COLLATE pg_catalog."default" NOT NULL,
    price double precision NOT NULL,
    stockcode integer NOT NULL,
    CONSTRAINT "DimStock_pkey" PRIMARY KEY ("productId", stockcode)
) PARTITION BY LIST (stockcode);

