CREATE TABLE IF NOT EXISTS public."DimCustomer"
(
    "customerId" integer NOT NULL,
    customernumber integer NOT NULL,
    customername character varying(50) COLLATE pg_catalog."default" NOT NULL,
    country character varying(50) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "DimCustomer_pkey" PRIMARY KEY ("customerId", country)
) PARTITION BY LIST (country);


CREATE TABLE DimCustomer_USA PARTITION OF "DimCustomer"
FOR VALUES IN ("USA");

CREATE TABLE DimCustomer_UK PARTITION OF "DimCustomer"
FOR VALUES IN ("United Kingdom");

CREATE TABLE DimCustomer_GER PARTITION OF "DimCustomer"
FOR VALUES IN ("Germany");

CREATE TABLE DimCustomer_FR PARTITION OF "DimCustomer"
FOR VALUES IN ("France");

CREATE TABLE DimCustomer_EIR PARTITION OF "DimCustomer"
FOR VALUES IN ("EIRE");

CREATE TABLE DimCustomer_SPN PARTITION OF "DimCustomer"
FOR VALUES IN ("Spain");

CREATE TABLE DimCustomer_NTH PARTITION OF "DimCustomer"
FOR VALUES IN ("Netherlands");

CREATE TABLE DimCustomer_BLG PARTITION OF "DimCustomer"
FOR VALUES IN ("Belgium");

CREATE TABLE DimCustomer_SWT PARTITION OF "DimCustomer"
FOR VALUES IN ("Switzerland");

CREATE TABLE DimCustomer_POR PARTITION OF "DimCustomer"
FOR VALUES IN ("Portugal");

CREATE TABLE DimCustomer_AUS PARTITION OF "DimCustomer"
FOR VALUES IN ("Australia");

CREATE TABLE DimCustomer_NOR PARTITION OF "DimCustomer"
FOR VALUES IN ("Norway");

CREATE TABLE DimCustomer_ITA PARTITION OF "DimCustomer"
FOR VALUES IN ("Italy");

CREATE TABLE DimCustomer_CHA PARTITION OF "DimCustomer"
FOR VALUES IN ("Channel Islands");

CREATE TABLE DimCustomer_CYP PARTITION OF "DimCustomer"
FOR VALUES IN ("Cyprus");

CREATE TABLE DimCustomer_FIN PARTITION OF "DimCustomer"
FOR VALUES IN ("Finland");

CREATE TABLE DimCustomer_SWE PARTITION OF "DimCustomer"
FOR VALUES IN ("Sweden");

CREATE TABLE DimCustomer_ASR PARTITION OF "DimCustomer"
FOR VALUES IN ("Austria");

CREATE TABLE DimCustomer_DNM PARTITION OF "DimCustomer"
FOR VALUES IN ("Denmark");

CREATE TABLE DimCustomer_JPN PARTITION OF "DimCustomer"
FOR VALUES IN ("Japan");

CREATE TABLE DimCustomer_PLD PARTITION OF "DimCustomer"
FOR VALUES IN ("Poland");

CREATE TABLE DimCustomer_ISR PARTITION OF "DimCustomer"
FOR VALUES IN ("Israel");

CREATE TABLE DimCustomer_SGP PARTITION OF "DimCustomer"
FOR VALUES IN ("Singapore");

CREATE TABLE DimCustomer_BRZ PARTITION OF "DimCustomer"
FOR VALUES IN ("Brazil");

CREATE TABLE DimCustomer_CZR PARTITION OF "DimCustomer"
FOR VALUES IN ("Czech Republic");

CREATE TABLE DimCustomer_BAH PARTITION OF "DimCustomer"
FOR VALUES IN ("Bahrain");

CREATE TABLE DimCustomer_SAR PARTITION OF "DimCustomer"
FOR VALUES IN ("Saudi Arabia");

CREATE TABLE DimCustomer_RSA PARTITION OF "DimCustomer"
FOR VALUES IN ("RSA");

CREATE TABLE DimCustomer_UNS PARTITION OF "DimCustomer"
FOR VALUES IN ("Unspecified");

CREATE TABLE DimCustomer_CAN PARTITION OF "DimCustomer"
FOR VALUES IN ("Canada");

CREATE TABLE DimCustomer_MLT PARTITION OF "DimCustomer"
FOR VALUES IN ("Malta");

CREATE TABLE DimCustomer_LTH PARTITION OF "DimCustomer"
FOR VALUES IN ("Lithuania");

CREATE TABLE DimCustomer_UAE PARTITION OF "DimCustomer"
FOR VALUES IN ("United Arab Emirates");

CREATE TABLE DimCustomer_GRE PARTITION OF "DimCustomer"
FOR VALUES IN ("Greece");

CREATE TABLE DimCustomer_ICL PARTITION OF "DimCustomer"
FOR VALUES IN ("Iceland");

CREATE TABLE DimCustomer_LBN PARTITION OF "DimCustomer"
FOR VALUES IN ("Lebanon");

CREATE TABLE DimCustomer_ERC PARTITION OF "DimCustomer"
FOR VALUES IN ("European Community");

CREATE INDEX "idx_DimCustomer_customernumber" ON "DimCustomer"("customernumber");