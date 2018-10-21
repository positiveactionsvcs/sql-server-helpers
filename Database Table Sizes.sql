DECLARE @tablename sysname

CREATE TABLE #Results (name varchar(100), rows bigint, reserved varchar(100), data varchar(100), index_size varchar(100), unused varchar(100))

DECLARE tables_cursor CURSOR FOR

	SELECT 
		SU.name + '.' + SO.name as name
	FROM 
		sysobjects SO
			INNER JOIN sysusers su on so.uid = su.uid
	WHERE 
		type = 'U' ORDER BY SU.name + '.' + SO.name

OPEN tables_cursor

FETCH NEXT FROM tables_cursor INTO @tablename

WHILE (@@FETCH_STATUS <> -1)
	BEGIN
		INSERT INTO #Results EXEC ('sp_spaceused [' + @tablename + ']') 
		
      	FETCH NEXT FROM tables_cursor INTO @tablename
	END

CLOSE tables_cursor
DEALLOCATE tables_cursor

SELECT * FROM #Results ORDER BY rows DESC

DROP TABLE #Results