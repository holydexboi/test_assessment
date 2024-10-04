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

CREATE TABLE DimMonth_2010 PARTITION OF "DimMonth"
FOR VALUES FROM (2010) TO (2011);


CREATE TABLE DimMonth_2011 PARTITION OF "DimMonth"
FOR VALUES FROM (2011) TO (2012);

CREATE TABLE DimMonth_2012 PARTITION OF "DimMonth"
FOR VALUES FROM (2012) TO (2013);

CREATE TABLE DimMonth_2013 PARTITION OF "DimMonth"
FOR VALUES FROM (2013) TO (2014);

CREATE TABLE DimMonth_2014 PARTITION OF "DimMonth"
FOR VALUES FROM (2014) TO (2015);

CREATE TABLE DimMonth_2015 PARTITION OF "DimMonth"
FOR VALUES FROM (2015) TO (2016);

CREATE TABLE DimMonth_2016 PARTITION OF "DimMonth"
FOR VALUES FROM (2016) TO (2017);

CREATE TABLE DimMonth_2017 PARTITION OF "DimMonth"
FOR VALUES FROM (2017) TO (2018);

CREATE TABLE DimMonth_2018 PARTITION OF "DimMonth"
FOR VALUES FROM (2018) TO (2019);

CREATE TABLE DimMonth_2019 PARTITION OF "DimMonth"
FOR VALUES FROM (2019) TO (2020);

CREATE TABLE DimMonth_2020 PARTITION OF "DimMonth"
FOR VALUES FROM (2020) TO (2021);

CREATE TABLE DimMonth_2021 PARTITION OF "DimMonth"
FOR VALUES FROM (2021) TO (2022);

CREATE TABLE DimMonth_2022 PARTITION OF "DimMonth"
FOR VALUES FROM (2022) TO (2023);

CREATE TABLE DimMonth_2023 PARTITION OF "DimMonth"
FOR VALUES FROM (2023) TO (2024);

CREATE TABLE DimMonth_2024 PARTITION OF "DimMonth"
FOR VALUES FROM (2024) TO (2025);


ALTER TABLE "DimMonth"
CLUSTER ON "ix_DimMonth_monthId"

CREATE INDEX "idx_DimMonth_year" ON "DimMonth"(year);

CREATE INDEX "idx_DimMonth_month" ON "DimMonth"(month);

CREATE INDEX "idx_DimMonth_day" ON "DimMonth"(day);

CREATE INDEX "idx_DimMonth_quater" ON "DimMonth"(quater);

CREATE INDEX "idx_DimMonth_week" ON "DimMonth"(week);
