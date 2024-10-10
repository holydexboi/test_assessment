CREATE TABLE IF NOT EXISTS public."FactSales"
(
    "salesId" integer NOT NULL,
    quantity bigint NOT NULL,
    amount double precision NOT NULL,
    "productId" integer NOT NULL,
    "customerId" integer NOT NULL,
    "monthId" integer NOT NULL,
    invoicedate timestamp without time zone NOT NULL,
    "invoiceNo" character varying(7) COLLATE pg_catalog."default",
    CONSTRAINT "FactSales_pkey" PRIMARY KEY ("salesId", invoicedate),
    CONSTRAINT "FactSales_customerId_fkey" FOREIGN KEY ("customerId")
    REFERENCES public."DimCustomer" ("customerId") MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE CASCADE,
    CONSTRAINT "FactSales_monthId_fkey" FOREIGN KEY ("monthId")
    REFERENCES public."DimMonth" ("monthId") MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE CASCADE,
    CONSTRAINT "FactSales_stockId_fkey" FOREIGN KEY ("productId")
    REFERENCES public."DimProduct" ("productId") MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE CASCADE
) PARTITION BY RANGE ("invoicedate");

CREATE TABLE public."FactSales_2010" PARTITION OF public."FactSales"
    FOR VALUES FROM ('2010-01-01') TO ('2011-01-01');

CREATE TABLE public."FactSales_2011" PARTITION OF public."FactSales"
    FOR VALUES FROM ('2011-01-01') TO ('2012-01-01');

CREATE TABLE public."FactSales_2012" PARTITION OF public."FactSales"
    FOR VALUES FROM ('2012-01-01') TO ('2013-01-01');

CREATE TABLE public."FactSales_2013" PARTITION OF public."FactSales"
    FOR VALUES FROM ('2013-01-01') TO ('2014-01-01');

CREATE TABLE public."FactSales_2014" PARTITION OF public."FactSales"
    FOR VALUES FROM ('2014-01-01') TO ('2015-01-01');

CREATE TABLE public."FactSales_2015" PARTITION OF public."FactSales"
    FOR VALUES FROM ('2015-01-01') TO ('2016-01-01');

CREATE TABLE public."FactSales_2016" PARTITION OF public."FactSales"
    FOR VALUES FROM ('2016-01-01') TO ('2017-01-01');

CREATE TABLE public."FactSales_2017" PARTITION OF public."FactSales"
    FOR VALUES FROM ('2017-01-01') TO ('2018-01-01');

CREATE TABLE public."FactSales_2018" PARTITION OF public."FactSales"
    FOR VALUES FROM ('2018-01-01') TO ('2019-01-01');

CREATE TABLE public."FactSales_2019" PARTITION OF public."FactSales"
    FOR VALUES FROM ('2019-01-01') TO ('2020-01-01');

CREATE TABLE public."FactSales_2020" PARTITION OF public."FactSales"
    FOR VALUES FROM ('2020-01-01') TO ('2021-01-01');

CREATE TABLE public."FactSales_2021" PARTITION OF public."FactSales"
    FOR VALUES FROM ('2021-01-01') TO ('2022-01-01');

CREATE TABLE public."FactSales_2022" PARTITION OF public."FactSales"
    FOR VALUES FROM ('2022-01-01') TO ('2023-01-01');

CREATE TABLE public."FactSales_2023" PARTITION OF public."FactSales"
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE public."FactSales_2024" PARTITION OF public."FactSales"
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');


CREATE INDEX "FactSales_productId"
    ON public."FactSales" USING btree
    ("productId");

CREATE INDEX "FactSales_customerId"
    ON public."FactSales" USING btree
    ("customerId");

CREATE INDEX "FactSales_monthId"
    ON public."FactSales" USING btree
    ("monthId");

CREATE INDEX "FactSales_quantity"
    ON public."FactSales" USING btree
    (quantity);

CREATE INDEX "FactSales_invoicedate"
    ON public."FactSales" USING btree
    (invoicedate);

CREATE INDEX "FactSales_amount"
    ON public."FactSales" USING btree
    (amount);