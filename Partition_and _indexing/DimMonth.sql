CREATE TABLE IF NOT EXISTS public."DimMonth"
(
    "monthId" integer NOT NULL,
    year integer NOT NULL,
    month integer NOT NULL,
    monthname character varying(10) COLLATE pg_catalog."default" NOT NULL,
    quater integer NOT NULL,
    quatername character varying(2) COLLATE pg_catalog."default" NOT NULL,
    day integer NOT NULL,
    dayname character varying(10) COLLATE pg_catalog."default" NOT NULL,
    week integer NOT NULL,
    hour integer,
    minute integer,
    CONSTRAINT "DimMonth_pkey" PRIMARY KEY ("monthId", year)
) PARTITION BY RANGE (year);


CREATE TABLE public."DimMonth_2010" PARTITION OF public."DimMonth"
    FOR VALUES FROM (2010-01-01) TO (2011-01-01);

CREATE TABLE public."DimMonth_2011" PARTITION OF public."DimMonth"
    FOR VALUES FROM (2011-01-01) TO (2012-01-01);

CREATE TABLE public."DimMonth_2012" PARTITION OF public."DimMonth"
    FOR VALUES FROM (2012-01-01) TO (2013-01-01);

CREATE TABLE public."DimMonth_2013" PARTITION OF public."DimMonth"
    FOR VALUES FROM (2013-01-01) TO (2014-01-01);

CREATE TABLE public."DimMonth_2014" PARTITION OF public."DimMonth"
    FOR VALUES FROM (2014-01-01) TO (2015-01-01);

CREATE TABLE public."DimMonth_2015" PARTITION OF public."DimMonth"
    FOR VALUES FROM (2015-01-01) TO (2016-01-01);

CREATE TABLE public."DimMonth_2016" PARTITION OF public."DimMonth"
    FOR VALUES FROM (2016-01-01) TO (2017-01-01);

CREATE TABLE public."DimMonth_2017" PARTITION OF public."DimMonth"
    FOR VALUES FROM (2017-01-01) TO (2018-01-01);

CREATE TABLE public."DimMonth_2018" PARTITION OF public."DimMonth"
    FOR VALUES FROM (2018-01-01) TO (2019-01-01);

CREATE TABLE public."DimMonth_2019" PARTITION OF public."DimMonth"
    FOR VALUES FROM (2019-01-01) TO (2020-01-01);

CREATE TABLE public."DimMonth_2020" PARTITION OF public."DimMonth"
    FOR VALUES FROM (2020-01-01) TO (2021-01-01);

CREATE TABLE public."DimMonth_2021" PARTITION OF public."DimMonth"
    FOR VALUES FROM (2021-01-01) TO (2022-01-01);

CREATE TABLE public."DimMonth_2022" PARTITION OF public."DimMonth"
    FOR VALUES FROM (2022-01-01) TO (2023-01-01);

CREATE TABLE public."DimMonth_2023" PARTITION OF public."DimMonth"
    FOR VALUES FROM (2023-01-01) TO (2024-01-01);

CREATE TABLE public."DimMonth_2024" PARTITION OF public."DimMonth"
    FOR VALUES FROM (2024-01-01) TO (2025-01-01);



CREATE INDEX "DimMonth_year"
    ON public."DimMonth" USING btree
    (year)

CREATE INDEX "DimMonth_month"
    ON public."DimMonth" USING btree
    (month)

CREATE INDEX "DimMonth_week"
    ON public."DimMonth" USING btree
    (week)

CREATE INDEX "DimMonth_day"
    ON public."DimMonth" USING btree
    (day)