CREATE TABLE #tt1 (c1 VARCHAR(100))

INSERT INTO #tt1
SELECT 'CREATE TABLE AllDataTypes ('

INSERT INTO #tt1
SELECT '[' + name + 'Null] [' + name + '] NULL,'
FROM sys.types WHERE is_nullable = 1
UNION
SELECT '[' + name + 'NotNull] [' + name + '] NOT NULL,'
FROM sys.types WHERE name <> 'xml'

INSERT INTO #tt1
SELECT '[xmlNotNull] [xml] NOT NULL)'

SELECT c1 FROM #tt1

DROP TABLE #tt1