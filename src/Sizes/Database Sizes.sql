-- List the size of all databases in MB.
SELECT
    d.[name] AS DatabaseName,
    CONVERT(decimal(18,2), SUM(mf.size) * 8.0 / 1024) AS SizeInMB
FROM
    sys.databases d
    INNER JOIN
        sys.master_files mf
        ON d.database_id = mf.database_id
GROUP BY
    d.[name]
ORDER BY
    d.[name]
