CREATE TABLE #Table(table_name varchar(500), index_name varchar(500), index_description varchar(500), index_keys varchar(500), index_size bigint)

DECLARE GetTables CURSOR READ_ONLY
FOR
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
AND OBJECTPROPERTY (OBJECT_ID(TABLE_NAME), 'IsMSShipped') = 0

DECLARE @TableName sysname
OPEN GetTables

FETCH NEXT FROM GetTables INTO @TableName
WHILE (@@fetch_status = 0)
BEGIN

INSERT INTO #Table(index_name, index_description, index_keys) EXEC sp_helpindex @TableName
UPDATE #Table SET table_name = @TableName WHERE table_name IS NULL

FETCH NEXT FROM GetTables INTO @TableName
END

CLOSE GetTables
DEALLOCATE GetTables

DECLARE @index_name varchar(200)
DECLARE @table_name varchar(200)
DECLARE @dpages bigint

DECLARE IndexDetail CURSOR FOR
	SELECT
		index_name
	FROM
		#Table

OPEN IndexDetail

FETCH NEXT FROM IndexDetail INTO @index_name

WHILE (@@fetch_status = 0)
BEGIN

SELECT @dpages = dpages FROM sysindexes WHERE name = @Index_Name
PRINT @Index_Name
PRINT CONVERT( varchar(200), @dpages)

UPDATE
	#Table
SET
	index_size = (@dpages*8192/(1024*1024))
WHERE
	index_name = @Index_Name

FETCH NEXT FROM IndexDetail INTO @index_name
END

CLOSE IndexDetail
DEALLOCATE IndexDetail

SELECT * FROM #Table ORDER BY index_size DESC

DROP TABLE #Table
GO
