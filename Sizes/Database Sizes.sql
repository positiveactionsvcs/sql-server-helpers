CREATE TABLE #Results (name varchar(100), [size in kb] bigint, comments varchar(100))

INSERT INTO #Results EXEC sp_databases 

SELECT 
	name,
	CONVERT(decimal(18,2), CONVERT(decimal(18,2), [size in kb]/CONVERT(decimal(18, 2),1024))) AS SizeInMB
 FROM #Results

DROP TABLE #Results