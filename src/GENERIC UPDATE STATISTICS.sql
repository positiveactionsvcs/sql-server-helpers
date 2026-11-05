SELECT 
	TABLE_NAME,
	0 as processed
INTO
	#Tables
   FROM INFORMATION_SCHEMA.TABLES

DECLARE @table_name varchar(100)
DECLARE @execstr varchar(250)

WHILE EXISTS (SELECT * FROM #Tables WHERE processed = 0)
	BEGIN
		SELECT
			@table_name = TABLE_NAME 
		FROM	
			#Tables
		WHERE
			processed = 0

		SET @execstr = 'UPDATE STATISTICS ' + @table_name
		EXEC(@execstr)

		UPDATE
			#Tables
		SET 
			processed = 1
		WHERE
			table_name = @table_name
	END

DROP TABLE #Tables