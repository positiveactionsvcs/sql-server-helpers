USE [master]

/*Perform a 'USE <database name>' to select the database in which to run the script.*/
-- Declare variables
SET NOCOUNT ON
DECLARE @tablename VARCHAR (128)
DECLARE @execstr   VARCHAR (255)
DECLARE @objectid  INT
DECLARE @indexname VARCHAR(128)
DECLARE @indexid   INT
DECLARE @frag      DECIMAL
DECLARE @maxfrag   DECIMAL

-- Decide on the maximum fragmentation to allow
SELECT @maxfrag = 0.0

-- Declare cursor
DECLARE tables CURSOR FOR
   SELECT TABLE_NAME
   FROM INFORMATION_SCHEMA.TABLES
   WHERE TABLE_TYPE = 'BASE TABLE'

-- Create the table
CREATE TABLE #fraglist (
   ObjectName CHAR (255),
   ObjectId INT,
   IndexName CHAR (255),
   IndexId INT,
   Lvl INT,
   CountPages INT,
   CountRows INT,
   MinRecSize INT,
   MaxRecSize INT,
   AvgRecSize INT,
   ForRecCount INT,
   Extents INT,
   ExtentSwitches INT,
   AvgFreeBytes INT,
   AvgPageDensity INT,
   ScanDensity DECIMAL,
   BestCount INT,
   ActualCount INT,
   LogicalFrag DECIMAL,
   ExtentFrag DECIMAL)

-- Open the cursor
OPEN tables

-- Loop through all the tables in the database
FETCH NEXT
   FROM tables
   INTO @tablename

WHILE @@FETCH_STATUS = 0
BEGIN
-- Do the showcontig of all indexes of the table
   INSERT INTO #fraglist 
   EXEC ('DBCC SHOWCONTIG (''' + @tablename + ''') 
      WITH TABLERESULTS, ALL_INDEXES, NO_INFOMSGS')
   FETCH NEXT
      FROM tables
      INTO @tablename
END

-- Close and deallocate the cursor
CLOSE tables
DEALLOCATE tables

-- Declare cursor for list of indexes to be defragged
DECLARE indexes CURSOR FOR
   SELECT ObjectName, ObjectId, LTRIM(RTRIM(IndexName)), IndexId, LogicalFrag
   FROM #fraglist
   WHERE LogicalFrag >= @maxfrag or ExtentFrag >= @maxfrag
		AND INDEXPROPERTY (ObjectId, IndexName, 'IndexDepth') > 0
		AND ObjectName NOT LIKE '%sys%' 
		AND IndexName NOT LIKE '%CalculationReports%'
		

-- Open the cursor
OPEN indexes

-- loop through the indexes
FETCH NEXT
   FROM indexes
   INTO @tablename, @objectid, @indexname, @indexid, @frag

WHILE @@FETCH_STATUS = 0
BEGIN
	--SQL 2005 version
	--SELECT @execstr = 'ALTER INDEX ' + @indexname + ' ON ' + RTRIM(@tablename) + ' REBUILD WITH (ONLINE = ON)'
	
	-- SQL 2000 version
	SELECT @execstr = 'DBCC DBREINDEX(''' + RTRIM(@tablename) + ''', ''' + @indexname + ''', 100)'
	
	PRINT @execstr + '- fragmentation currently '
       + RTRIM(CONVERT(varchar(15),@frag)) + '%'   

	EXEC (@execstr)

   FETCH NEXT
      FROM indexes
      INTO @tablename, @objectid, @indexname, @indexid, @frag
END

-- Close and deallocate the cursor
CLOSE indexes
DEALLOCATE indexes

-- Delete the temporary table

SELECT * FROM #Fraglist
DROP TABLE #fraglist
GO