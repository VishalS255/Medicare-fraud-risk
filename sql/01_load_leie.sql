CREATE DATABASE MedicareFraud;
GO
USE MedicareFraud;
GO

-- Staging table: everything as text first, we clean types later
CREATE TABLE dbo.stg_leie (
    LASTNAME   VARCHAR(255),
    FIRSTNAME  VARCHAR(255),
    MIDNAME    VARCHAR(255),
    BUSNAME    VARCHAR(500),
    GENERAL    VARCHAR(255),
    SPECIALTY  VARCHAR(255),
    UPIN       VARCHAR(50),
    NPI        VARCHAR(50),
    DOB        VARCHAR(50),
    ADDRESS    VARCHAR(500),
    CITY       VARCHAR(255),
    STATE      VARCHAR(50),
    ZIP        VARCHAR(50),
    EXCLTYPE   VARCHAR(50),
    EXCLDATE   VARCHAR(50),
    REINDATE   VARCHAR(50),
    WAIVERDATE VARCHAR(50),
    WVRSTATE   VARCHAR(50)
);
GO

BULK INSERT dbo.stg_leie
FROM 'C:\Users\surwa\medicare-fraud-risk\data\raw\leie.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDQUOTE = '"',
      ROWTERMINATOR = '0x0a', CODEPAGE = '65001', TABLOCK);
GO

SELECT COUNT(*) AS total_rows FROM dbo.stg_leie;
SELECT TOP 5 * FROM dbo.stg_leie;