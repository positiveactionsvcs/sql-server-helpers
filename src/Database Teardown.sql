-- Database Teardown script.
-- Drop Foreign Keys, Default Constraints, Check Constraints, Primary Keys, Indexes.
SET NOCOUNT ON;

DECLARE @SQL nvarchar(MAX) = N'';

-------------------------------------------------------------------------------
-- DROP FOREIGN KEYS
-------------------------------------------------------------------------------
PRINT 'Dropping Foreign Keys...';

SELECT @SQL +=
    N'ALTER TABLE '
    + QUOTENAME(s.name) + N'.' + QUOTENAME(t.name)
    + N' DROP CONSTRAINT '
    + QUOTENAME(fk.name)
    + N';' + CHAR(13) + CHAR(10)
FROM sys.foreign_keys fk
JOIN sys.tables t
    ON fk.parent_object_id = t.object_id
JOIN sys.schemas s
    ON t.schema_id = s.schema_id;

-------------------------------------------------------------------------------
-- DROP DEFAULT CONSTRAINTS
-------------------------------------------------------------------------------
SELECT @SQL +=
    N'ALTER TABLE '
    + QUOTENAME(s.name) + N'.' + QUOTENAME(t.name)
    + N' DROP CONSTRAINT '
    + QUOTENAME(dc.name)
    + N';' + CHAR(13) + CHAR(10)
FROM sys.default_constraints dc
JOIN sys.tables t
    ON dc.parent_object_id = t.object_id
JOIN sys.schemas s
    ON t.schema_id = s.schema_id;

-------------------------------------------------------------------------------
-- DROP CHECK CONSTRAINTS
-------------------------------------------------------------------------------
SELECT @SQL +=
    N'ALTER TABLE '
    + QUOTENAME(s.name) + N'.' + QUOTENAME(t.name)
    + N' DROP CONSTRAINT '
    + QUOTENAME(cc.name)
    + N';' + CHAR(13) + CHAR(10)
FROM sys.check_constraints cc
JOIN sys.tables t
    ON cc.parent_object_id = t.object_id
JOIN sys.schemas s
    ON t.schema_id = s.schema_id;

-------------------------------------------------------------------------------
-- DROP PRIMARY KEYS
-------------------------------------------------------------------------------
SELECT @SQL +=
    N'ALTER TABLE '
    + QUOTENAME(s.name) + N'.' + QUOTENAME(t.name)
    + N' DROP CONSTRAINT '
    + QUOTENAME(kc.name)
    + N';' + CHAR(13) + CHAR(10)
FROM sys.key_constraints kc
JOIN sys.tables t
    ON kc.parent_object_id = t.object_id
JOIN sys.schemas s
    ON t.schema_id = s.schema_id
WHERE kc.type = 'PK';

-------------------------------------------------------------------------------
-- DROP UNIQUE CONSTRAINTS
-------------------------------------------------------------------------------
SELECT @SQL +=
    N'ALTER TABLE '
    + QUOTENAME(s.name) + N'.' + QUOTENAME(t.name)
    + N' DROP CONSTRAINT '
    + QUOTENAME(kc.name)
    + N';' + CHAR(13) + CHAR(10)
FROM sys.key_constraints kc
JOIN sys.tables t
    ON kc.parent_object_id = t.object_id
JOIN sys.schemas s
    ON t.schema_id = s.schema_id
WHERE kc.type = 'UQ';

-------------------------------------------------------------------------------
-- DROP NON-CONSTRAINT INDEXES
-------------------------------------------------------------------------------
SELECT @SQL +=
    N'DROP INDEX '
    + QUOTENAME(i.name)
    + N' ON '
    + QUOTENAME(s.name) + N'.' + QUOTENAME(t.name)
    + N';' + CHAR(13) + CHAR(10)
FROM sys.indexes i
JOIN sys.tables t
    ON i.object_id = t.object_id
JOIN sys.schemas s
    ON t.schema_id = s.schema_id
WHERE i.name IS NOT NULL
    AND i.type > 0
    AND i.is_primary_key = 0
    AND i.is_unique_constraint = 0
    AND i.is_hypothetical = 0;

-------------------------------------------------------------------------------
-- REVIEW GENERATED SQL
-------------------------------------------------------------------------------
PRINT @SQL;

-------------------------------------------------------------------------------
-- EXECUTE
-------------------------------------------------------------------------------
--EXEC sp_executesql @SQL;