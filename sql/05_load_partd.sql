USE MedicareFraud;
GO

-- ===== 2019 =====
TRUNCATE TABLE dbo.stg_partd_2019;
BULK INSERT dbo.stg_partd_2019
FROM 'C:\Users\surwa\medicare-fraud-risk\data\raw\partd_2019.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDQUOTE = '"',
      ROWTERMINATOR = '0x0a', CODEPAGE = '65001', TABLOCK);
GO

-- ===== 2021 =====
TRUNCATE TABLE dbo.stg_partd_2021;
BULK INSERT dbo.stg_partd_2021
FROM 'C:\Users\surwa\medicare-fraud-risk\data\raw\partd_2021.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDQUOTE = '"',
      ROWTERMINATOR = '0x0a', CODEPAGE = '65001', TABLOCK);
GO

-- ===== 2023 =====
TRUNCATE TABLE dbo.stg_partd_2023;
BULK INSERT dbo.stg_partd_2023
FROM 'C:\Users\surwa\medicare-fraud-risk\data\raw\partd_2023.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDQUOTE = '"',
      ROWTERMINATOR = '0x0a', CODEPAGE = '65001', TABLOCK);
GO

-- ===== Checks =====
SELECT '2019' AS data_year, COUNT(*) AS total_rows,
       SUM(CASE WHEN Bene_Avg_Risk_Scre LIKE '%' + CHAR(13) THEN 1 ELSE 0 END) AS hidden_chars
FROM dbo.stg_partd_2019
UNION ALL
SELECT '2021', COUNT(*), SUM(CASE WHEN Bene_Avg_Risk_Scre LIKE '%' + CHAR(13) THEN 1 ELSE 0 END)
FROM dbo.stg_partd_2021
UNION ALL
SELECT '2023', COUNT(*), SUM(CASE WHEN Bene_Avg_Risk_Scre LIKE '%' + CHAR(13) THEN 1 ELSE 0 END)
FROM dbo.stg_partd_2023;