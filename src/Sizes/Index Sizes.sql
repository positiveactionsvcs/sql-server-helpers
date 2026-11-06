/*
    Shows all indexes and their sizes.
    Ordered by largest index size.

    Rows      = Number of rows in the index.
    SizeMB    = Space used by the index.
    IndexType = Clustered, Nonclustered, XML, etc.
*/
SELECT
    s.[name] + '.' + t.[name] AS TableName,     -- Fully qualified table name
    i.[name] AS IndexName,                      -- Index name
    i.[type_desc] AS IndexType,                 -- CLUSTERED, NONCLUSTERED
    SUM(p.[rows]) AS [Rows],                    -- How many rows are represented in the index

    -- Index size in MB (8 KB pages converted to MB)
    CAST(SUM(a.used_pages) * 8.0 / 1024 AS decimal(18,2)) AS SizeMB
FROM
    sys.tables t
    JOIN
        sys.schemas s ON t.[schema_id] = s.[schema_id]
    JOIN
        sys.indexes i ON t.[object_id] = i.[object_id]
    JOIN
        sys.partitions p ON i.[object_id] = p.[object_id]
        AND i.index_id = p.index_id
    JOIN
        sys.allocation_units a ON p.[partition_id] = a.[container_id]
WHERE
    i.[index_id] > 0      -- Exclude heaps
    AND i.[name] IS NOT NULL  -- Exclude unnamed indexes
GROUP BY
    s.[name],
    t.[name],
    i.[name],
    i.[type_desc]
ORDER BY
    SizeMB DESC
