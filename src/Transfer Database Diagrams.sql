-- Transfer the Database Diagrams from one database to another.
DECLARE @SourceDatabase sysname = '<source_database>'
DECLARE @TargetDatabase sysname = '<target_database>'

DECLARE @SQL nvarchar(MAX)

SET @SQL = N'SET IDENTITY_INSERT ' + QUOTENAME(@TargetDatabase) + N'.dbo.sysdiagrams ON

INSERT INTO ' + QUOTENAME(@TargetDatabase) + N'.dbo.sysdiagrams
    ([name], [principal_id], [diagram_id], [version], [definition])
SELECT
    [name], [principal_id], [diagram_id], [version], [definition]
FROM ' + QUOTENAME(@SourceDatabase) + N'.dbo.sysdiagrams

SET IDENTITY_INSERT ' + QUOTENAME(@TargetDatabase) + N'.dbo.sysdiagrams OFF'

EXEC sp_executesql @SQL
