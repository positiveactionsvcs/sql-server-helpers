/* change this to the relevant DB name */
USE [master]

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

INSERT INTO
	#FragList
EXEC ('DBCC SHOWCONTIG WITH TABLERESULTS, ALL_INDEXES')

SELECT
	*
FROM
	#Fraglist
WHERE
	LogicalFrag <> 0 OR
	ExtentFrag <> 0
ORDER BY
	LogicalFrag DESC,
	ExtentFrag DESC

DROP TABLE #Fraglist