SELECT
    s.name AS SchemaName,
    t.name AS TableName,
    i.name AS IndexName,
    ips.avg_fragmentation_in_percent AS FragPct
FROM
    sys.dm_db_index_physical_stats
(
    DB_ID(),
    NULL,
    NULL,
    NULL,
    'LIMITED'
) ips
INNER JOIN
    sys.indexes i
    ON ips.object_id = i.object_id AND ips.index_id = i.index_id
INNER JOIN
    sys.tables t
    ON t.object_id = i.object_id
INNER JOIN
    sys.schemas s
    ON s.schema_id = t.schema_id
WHERE
    i.index_id > 0
    AND ips.page_count > 100
    AND i.is_disabled = 0;

--ALTER INDEX PK_CAPACITY_LPN_Base
--ON dbo.CAPACITY_LPN_Base
--REBUILD;