SET NOCOUNT ON;

DECLARE @SchemaName sysname,
        @TableName sysname,
        @IndexName sysname,
        @FragPct decimal(10,2),
        @SQL nvarchar(max);

IF OBJECT_ID('tempdb..#Indexes') IS NOT NULL DROP TABLE #Indexes;

SELECT
    s.name AS SchemaName,
    t.name AS TableName,
    i.name AS IndexName,
    ips.avg_fragmentation_in_percent AS FragPct
INTO #Indexes
FROM sys.dm_db_index_physical_stats
(
    DB_ID(),
    NULL,
    NULL,
    NULL,
    'LIMITED'
) ips
INNER JOIN sys.indexes i
    ON ips.object_id = i.object_id
   AND ips.index_id = i.index_id
INNER JOIN sys.tables t
    ON t.object_id = i.object_id
INNER JOIN sys.schemas s
    ON s.schema_id = t.schema_id
WHERE i.index_id > 0
  AND ips.page_count > 100
  AND i.is_disabled = 0;

DECLARE idx CURSOR LOCAL FAST_FORWARD FOR
SELECT
    SchemaName,
    TableName,
    IndexName,
    FragPct
FROM #Indexes;

OPEN idx;

FETCH NEXT FROM idx
INTO @SchemaName, @TableName, @IndexName, @FragPct;

WHILE @@FETCH_STATUS = 0
BEGIN

    IF @FragPct BETWEEN 5 AND 30
    BEGIN
        SET @SQL =
            N'ALTER INDEX [' + @IndexName + N'] ON [' +
            @SchemaName + N'].[' + @TableName +
            N'] REORGANIZE';

        PRINT @SQL;
        EXEC sp_executesql @SQL;
    END
    ELSE IF @FragPct > 30
    BEGIN
        SET @SQL =
            N'ALTER INDEX [' + @IndexName + N'] ON [' +
            @SchemaName + N'].[' + @TableName +
            N'] REBUILD';

        PRINT @SQL;
        EXEC sp_executesql @SQL;
    END;

    FETCH NEXT FROM idx
    INTO @SchemaName, @TableName, @IndexName, @FragPct;
END

CLOSE idx;
DEALLOCATE idx;

DROP TABLE #Indexes;