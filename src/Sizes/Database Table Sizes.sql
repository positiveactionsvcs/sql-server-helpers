/*
    Show row counts and space utilisation for all user tables.
    Ordered by largest table first.

    Rows       = Number of rows in the table.
    ReservedMB = Total space reserved for the table.
    UsedMB     = Space currently used.
    DataMB     = Space used by table/clustered index data.
    UnusedMB   = Reserved but currently unused space.
*/
SELECT
    -- Schema-qualified table name.
    s.[name] + '.' + t.[name] AS TableName,

    -- Total row count across all partitions.
    SUM(p.[rows]) AS [Rows],

    -- Total space reserved for the table (8 KB pages converted to MB).
    CAST(SUM(a.[total_pages]) * 8.0 / 1024 AS decimal(18,2)) AS ReservedMB,

    -- Space currently in use (8 KB pages converted to MB).
    CAST(SUM(a.[used_pages]) * 8.0 / 1024 AS decimal(18,2)) AS UsedMB,

    -- Data only (excludes non-clustered indexes)
    CAST(SUM(CASE WHEN i.[index_id] < 2 THEN a.[data_pages] ELSE 0 END) * 8.0 / 1024 AS decimal(18,2)) AS DataMB
FROM
    sys.tables t
    INNER JOIN
        sys.schemas s
        ON t.[schema_id] = s.[schema_id]
    INNER JOIN
        sys.indexes i
        ON t.[object_id] = i.[object_id]
    INNER JOIN
        sys.partitions p
        ON i.[object_id] = p.[object_id]
       AND i.[index_id] = p.[index_id]
    INNER JOIN
        sys.allocation_units a
        ON p.[partition_id] = a.[container_id]
GROUP BY
    s.[name],
    t.[name]
ORDER BY
    [Rows] DESC
