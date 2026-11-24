USE MedicareFraud;
GO

-- 1. One view over all 3 staging tables
CREATE OR ALTER VIEW dbo.v_stg_partd_all AS
SELECT 2019 AS data_year, * FROM dbo.stg_partd_2019
UNION ALL
SELECT 2021, * FROM dbo.stg_partd_2021
UNION ALL
SELECT 2023, * FROM dbo.stg_partd_2023;
GO

-- 2. Clean, typed table joined with labels
DROP TABLE IF EXISTS dbo.partd_clean;
GO

SELECT
    l.data_year, l.npi, l.fraud_label, l.split,

    -- Doctor profile
    s.Prscrbr_Type                                   AS prscrbr_type,
    s.Prscrbr_State_Abrvtn                           AS state,
    s.Prscrbr_Ent_Cd                                 AS entity_cd,
    TRY_CAST(s.Prscrbr_RUCA AS FLOAT)                AS ruca,

    -- Overall volume
    TRY_CAST(s.Tot_Clms AS INT)                      AS tot_clms,
    TRY_CAST(s.Tot_30day_Fills AS FLOAT)             AS tot_30day_fills,
    TRY_CAST(s.Tot_Drug_Cst AS DECIMAL(18,2))        AS tot_drug_cst,
    TRY_CAST(s.Tot_Day_Suply AS INT)                 AS tot_day_suply,
    TRY_CAST(s.Tot_Benes AS INT)                     AS tot_benes,
    TRY_CAST(s.GE65_Tot_Clms AS INT)                 AS ge65_tot_clms,

    -- Brand vs generic
    TRY_CAST(s.Brnd_Tot_Clms AS INT)                 AS brnd_tot_clms,
    TRY_CAST(s.Brnd_Tot_Drug_Cst AS DECIMAL(18,2))   AS brnd_tot_drug_cst,
    TRY_CAST(s.Gnrc_Tot_Clms AS INT)                 AS gnrc_tot_clms,
    TRY_CAST(s.Gnrc_Tot_Drug_Cst AS DECIMAL(18,2))   AS gnrc_tot_drug_cst,

    -- Low-income patients
    TRY_CAST(s.LIS_Tot_Clms AS INT)                  AS lis_tot_clms,

    -- Opioids
    TRY_CAST(s.Opioid_Tot_Clms AS INT)               AS opioid_tot_clms,
    TRY_CAST(s.Opioid_Tot_Drug_Cst AS DECIMAL(18,2)) AS opioid_tot_drug_cst,
    TRY_CAST(s.Opioid_Tot_Benes AS INT)              AS opioid_tot_benes,
    TRY_CAST(s.Opioid_Prscrbr_Rate AS FLOAT)         AS opioid_prscrbr_rate,
    TRY_CAST(s.Opioid_LA_Tot_Clms AS INT)            AS opioid_la_tot_clms,
    TRY_CAST(s.Opioid_LA_Prscrbr_Rate AS FLOAT)      AS opioid_la_prscrbr_rate,

    -- Other drug groups
    TRY_CAST(s.Antbtc_Tot_Clms AS INT)               AS antbtc_tot_clms,
    TRY_CAST(s.Antpsyct_GE65_Tot_Clms AS INT)        AS antpsyct_ge65_tot_clms,

    -- Patient profile
    TRY_CAST(s.Bene_Avg_Age AS FLOAT)                AS bene_avg_age,
    TRY_CAST(s.Bene_Avg_Risk_Scre AS FLOAT)          AS bene_avg_risk_scre,
    TRY_CAST(s.Bene_Dual_Cnt AS INT)                 AS bene_dual_cnt,
    TRY_CAST(s.Bene_Ndual_Cnt AS INT)                AS bene_ndual_cnt
INTO dbo.partd_clean
FROM dbo.labels l
JOIN dbo.v_stg_partd_all s
  ON s.data_year = l.data_year
 AND s.Prscrbr_NPI = l.npi;
GO

ALTER TABLE dbo.partd_clean ALTER COLUMN data_year INT NOT NULL;
ALTER TABLE dbo.partd_clean ALTER COLUMN npi VARCHAR(20) NOT NULL;
GO
ALTER TABLE dbo.partd_clean ADD CONSTRAINT PK_partd_clean PRIMARY KEY (data_year, npi);
GO

-- Check 1: rows and fraud per year (should match the labels table)
SELECT data_year, COUNT(*) AS doctors, SUM(fraud_label) AS fraud
FROM dbo.partd_clean
GROUP BY data_year ORDER BY data_year;

-- Check 2: missing values in key columns
SELECT
    SUM(CASE WHEN tot_clms IS NULL THEN 1 ELSE 0 END)            AS null_tot_clms,
    SUM(CASE WHEN tot_drug_cst IS NULL THEN 1 ELSE 0 END)        AS null_tot_drug_cst,
    SUM(CASE WHEN opioid_tot_clms IS NULL THEN 1 ELSE 0 END)     AS null_opioid_clms,
    SUM(CASE WHEN bene_avg_risk_scre IS NULL THEN 1 ELSE 0 END)  AS null_risk_score
FROM dbo.partd_clean;