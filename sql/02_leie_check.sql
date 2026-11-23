USE MedicareFraud;
GO

-- 1. How many records have an NPI?
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN NPI <> '0' THEN 1 ELSE 0 END) AS with_npi
FROM dbo.stg_leie;

-- 2. Count by exclusion type (all records vs. records with NPI)
SELECT
    EXCLTYPE,
    COUNT(*) AS total,
    SUM(CASE WHEN NPI <> '0' THEN 1 ELSE 0 END) AS with_npi
FROM dbo.stg_leie
GROUP BY EXCLTYPE
ORDER BY total DESC;

-- 3. Records with NPI, by exclusion year
SELECT
    LEFT(EXCLDATE, 4) AS excl_year,
    COUNT(*) AS with_npi
FROM dbo.stg_leie
WHERE NPI <> '0'
GROUP BY LEFT(EXCLDATE, 4)
ORDER BY excl_year;