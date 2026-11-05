-- Return statistics for Stored Procedures being executed.
--
-- NOTE: Only returns procedures whose execution plans are currently in the
-- SQL Server plan cache.
SELECT
    DB_NAME(ps.database_id) AS DatabaseName,
    OBJECT_SCHEMA_NAME(ps.object_id, ps.database_id) AS SchemaName,
    OBJECT_NAME(ps.object_id, ps.database_id) AS StoredProcedureName,

    ps.last_execution_time AS LastExecutionTime,
    ps.last_elapsed_time / 1000000.0 AS ElapsedSeconds,

    ps.cached_time AS CachedTime,
    ps.execution_count AS ExecutionsSinceCache,

    (ps.total_elapsed_time * 1.0 /
        NULLIF(ps.execution_count, 0)) / 1000000.0
        AS AvgElapsedSecondsSinceCache
FROM
    sys.dm_exec_procedure_stats ps
WHERE
    OBJECT_NAME(ps.object_id, ps.database_id) IS NOT NULL
AND
    DB_NAME(ps.database_id) = 'PMA2'
ORDER BY
    ps.last_execution_time DESC