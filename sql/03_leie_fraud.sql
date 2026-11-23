USE MedicareFraud;
GO

-- Lets you re-run this script safely
DROP TABLE IF EXISTS dbo.leie_fraud;
GO

WITH fraud AS (
    SELECT
        LTRIM(RTRIM(NPI))                AS npi,
        EXCLTYPE                         AS excl_type,
        TRY_CONVERT(DATE, EXCLDATE, 112) AS excl_date,   -- '20200319' -> 2020-03-19
        GENERAL                          AS provider_group,
        SPECIALTY                        AS specialty,
        STATE                            AS state,
        ROW_NUMBER() OVER (
            PARTITION BY LTRIM(RTRIM(NPI))
            ORDER BY TRY_CONVERT(DATE, EXCLDATE, 112)
        ) AS rn                                          -- 1 = first ban
    FROM dbo.stg_leie
    WHERE NPI <> '0'
      AND EXCLTYPE IN ('1128a1','1128a2','1128a3','1128a4','1128b4','1128b7')
)
SELECT npi, excl_type, excl_date, provider_group, specialty, state
INTO dbo.leie_fraud
FROM fraud
WHERE rn = 1;
GO

-- Check 1: total rows (should equal distinct NPIs)
SELECT COUNT(*) AS fraud_rows, COUNT(DISTINCT npi) AS distinct_npis
FROM dbo.leie_fraud;

-- Check 2: any bad NPIs or dates? (both should be 0)
SELECT
    SUM(CASE WHEN LEN(npi) <> 10 THEN 1 ELSE 0 END) AS bad_npi,
    SUM(CASE WHEN excl_date IS NULL THEN 1 ELSE 0 END) AS bad_date
FROM dbo.leie_fraud;

-- Check 3: fraud doctors per year from 2020
SELECT YEAR(excl_date) AS excl_year, COUNT(*) AS cnt
FROM dbo.leie_fraud
WHERE excl_date >= '2020-01-01'
GROUP BY YEAR(excl_date)
ORDER BY excl_year;