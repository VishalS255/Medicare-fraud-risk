USE MedicareFraud;
GO

DROP TABLE IF EXISTS dbo.stg_partd_2019, dbo.stg_partd_2021, dbo.stg_partd_2023;
GO

CREATE TABLE dbo.stg_partd_2019 (
    Prscrbr_NPI VARCHAR(20),
    Prscrbr_Last_Org_Name VARCHAR(255),
    Prscrbr_First_Name VARCHAR(255),
    Prscrbr_MI VARCHAR(50),
    Prscrbr_Crdntls VARCHAR(255),
    Prscrbr_Ent_Cd VARCHAR(10),
    Prscrbr_St1 VARCHAR(255),
    Prscrbr_St2 VARCHAR(255),
    Prscrbr_City VARCHAR(255),
    Prscrbr_State_Abrvtn VARCHAR(10),
    Prscrbr_State_FIPS VARCHAR(10),
    Prscrbr_zip5 VARCHAR(10),
    Prscrbr_RUCA VARCHAR(20),
    Prscrbr_RUCA_Desc VARCHAR(500),
    Prscrbr_Cntry VARCHAR(10),
    Prscrbr_Type VARCHAR(255),
    Prscrbr_Type_Src VARCHAR(50),
    Tot_Clms VARCHAR(50),
    Tot_30day_Fills VARCHAR(50),
    Tot_Drug_Cst VARCHAR(50),
    Tot_Day_Suply VARCHAR(50),
    Tot_Benes VARCHAR(50),
    GE65_Sprsn_Flag VARCHAR(50),
    GE65_Tot_Clms VARCHAR(50),
    GE65_Tot_30day_Fills VARCHAR(50),
    GE65_Tot_Drug_Cst VARCHAR(50),
    GE65_Tot_Day_Suply VARCHAR(50),
    GE65_Bene_Sprsn_Flag VARCHAR(50),
    GE65_Tot_Benes VARCHAR(50),
    Brnd_Sprsn_Flag VARCHAR(50),
    Brnd_Tot_Clms VARCHAR(50),
    Brnd_Tot_Drug_Cst VARCHAR(50),
    Gnrc_Sprsn_Flag VARCHAR(50),
    Gnrc_Tot_Clms VARCHAR(50),
    Gnrc_Tot_Drug_Cst VARCHAR(50),
    Othr_Sprsn_Flag VARCHAR(50),
    Othr_Tot_Clms VARCHAR(50),
    Othr_Tot_Drug_Cst VARCHAR(50),
    MAPD_Sprsn_Flag VARCHAR(50),
    MAPD_Tot_Clms VARCHAR(50),
    MAPD_Tot_Drug_Cst VARCHAR(50),
    PDP_Sprsn_Flag VARCHAR(50),
    PDP_Tot_Clms VARCHAR(50),
    PDP_Tot_Drug_Cst VARCHAR(50),
    LIS_Sprsn_Flag VARCHAR(50),
    LIS_Tot_Clms VARCHAR(50),
    LIS_Drug_Cst VARCHAR(50),
    NonLIS_Sprsn_Flag VARCHAR(50),
    NonLIS_Tot_Clms VARCHAR(50),
    NonLIS_Drug_Cst VARCHAR(50),
    Opioid_Tot_Clms VARCHAR(50),
    Opioid_Tot_Drug_Cst VARCHAR(50),
    Opioid_Tot_Suply VARCHAR(50),
    Opioid_Tot_Benes VARCHAR(50),
    Opioid_Prscrbr_Rate VARCHAR(50),
    Opioid_LA_Tot_Clms VARCHAR(50),
    Opioid_LA_Tot_Drug_Cst VARCHAR(50),
    Opioid_LA_Tot_Suply VARCHAR(50),
    Opioid_LA_Tot_Benes VARCHAR(50),
    Opioid_LA_Prscrbr_Rate VARCHAR(50),
    Antbtc_Tot_Clms VARCHAR(50),
    Antbtc_Tot_Drug_Cst VARCHAR(50),
    Antbtc_Tot_Benes VARCHAR(50),
    Antpsyct_GE65_Sprsn_Flag VARCHAR(50),
    Antpsyct_GE65_Tot_Clms VARCHAR(50),
    Antpsyct_GE65_Tot_Drug_Cst VARCHAR(50),
    Antpsyct_GE65_Bene_Suprsn_Flag VARCHAR(50),
    Antpsyct_GE65_Tot_Benes VARCHAR(50),
    Bene_Avg_Age VARCHAR(50),
    Bene_Age_LT_65_Cnt VARCHAR(50),
    Bene_Age_65_74_Cnt VARCHAR(50),
    Bene_Age_75_84_Cnt VARCHAR(50),
    Bene_Age_GT_84_Cnt VARCHAR(50),
    Bene_Feml_Cnt VARCHAR(50),
    Bene_Male_Cnt VARCHAR(50),
    Bene_Race_Wht_Cnt VARCHAR(50),
    Bene_Race_Black_Cnt VARCHAR(50),
    Bene_Race_Api_Cnt VARCHAR(50),
    Bene_Race_Hspnc_Cnt VARCHAR(50),
    Bene_Race_Natind_Cnt VARCHAR(50),
    Bene_Race_Othr_Cnt VARCHAR(50),
    Bene_Dual_Cnt VARCHAR(50),
    Bene_Ndual_Cnt VARCHAR(50),
    Bene_Avg_Risk_Scre VARCHAR(50)
);
GO

-- Copy the same empty structure for 2021 and 2023
SELECT TOP 0 * INTO dbo.stg_partd_2021 FROM dbo.stg_partd_2019;
SELECT TOP 0 * INTO dbo.stg_partd_2023 FROM dbo.stg_partd_2019;
GO

-- Check: each table should have 84 columns
SELECT t.name AS table_name, COUNT(c.column_id) AS col_count
FROM sys.tables t
JOIN sys.columns c ON c.object_id = t.object_id
WHERE t.name LIKE 'stg_partd%'
GROUP BY t.name;