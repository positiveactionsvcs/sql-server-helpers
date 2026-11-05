DECLARE @sql nvarchar(MAX) = '';

SELECT @sql += 'CREATE TABLE AllDataTypes (' + CHAR(13) + CHAR(10);

SELECT @sql +=
    '[' + name + 'Null] [' + name + '] NULL,' + CHAR(13) + CHAR(10)
FROM sys.types
WHERE is_user_defined = 0
AND is_nullable = 1

SELECT @sql +=
    '[' + name + 'NotNull] [' + name + '] NOT NULL,' + CHAR(13) + CHAR(10)
FROM sys.types
WHERE is_user_defined = 0
AND name <> 'xml';

SELECT @sql +=
    '[xmlNotNull] [xml] NOT NULL)';

SELECT @sql AS CreateStatement;