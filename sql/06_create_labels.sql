USE MedicareFraud;
GO

DROP TABLE IF EXISTS dbo.labels;
GO

WITH all_years AS (
    SELECT 2019 AS data_year, Prscrbr_NPI AS npi FROM dbo.stg_partd_2019
    UNION ALL
    SELECT 2021, Prscrbr_NPI FROM dbo.stg_partd_2021
    UNION ALL
    SELECT 2023, Prscrbr_NPI FROM dbo.stg_partd_2023
)
SELECT
    a.data_year,
    a.npi,
    -- 1 if banned in the 2 years after the data year
    CASE WHEN f.excl_date >= DATEFROMPARTS(a.data_year + 1, 1, 1)
          AND f.excl_date <  DATEFROMPARTS(a.data_year + 3, 1, 1)
         THEN 1 ELSE 0 END AS fraud_label,
    CASE WHEN a.data_year = 2023 THEN 'test' ELSE 'train' END AS split
INTO dbo.labels
FROM all_years a
LEFT JOIN dbo.leie_fraud f ON f.npi = a.npi
WHERE f.excl_date IS NULL                                   -- never banned
   OR f.excl_date >= DATEFROMPARTS(a.data_year + 1, 1, 1);  -- banned after the data year
GO

-- Check: doctors and fraud count per year
SELECT data_year, split, COUNT(*) AS doctors, SUM(fraud_label) AS fraud
FROM dbo.labels
GROUP BY data_year, split
ORDER BY data_year;



-- Check 1: same doctor twice in the same year? (should return NO rows)
SELECT data_year, npi, COUNT(*) AS cnt
FROM dbo.labels
GROUP BY data_year, npi
HAVING COUNT(*) > 1;

-- Check 2: missing or bad NPIs? (should be 0)
SELECT SUM(CASE WHEN npi IS NULL OR LEN(npi) <> 10 THEN 1 ELSE 0 END) AS bad_npi
FROM dbo.labels;


ALTER TABLE dbo.labels ALTER COLUMN data_year INT NOT NULL;
ALTER TABLE dbo.labels ALTER COLUMN npi VARCHAR(20) NOT NULL;
GO

ALTER TABLE dbo.labels ADD CONSTRAINT PK_labels PRIMARY KEY (data_year, npi);
GO