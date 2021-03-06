declare @old sysname, @new sysname

DECLARE rename_cursor CURSOR FOR 
WITH AllFKs AS (
  SELECT DISTINCT constraint_object_id, parent_object_id, referenced_object_id, MIN(parent_column_id) parent_column_id
    FROM sys.foreign_key_columns
GROUP BY constraint_object_id, parent_object_id, referenced_object_id
),
Relations AS (
  SELECT FK.name AS Relation, P.name AS Parent, R.name AS Referenced, ROW_NUMBER() OVER(PARTITION BY P.Name, R.Name ORDER BY P.Name, R.Name, AllFKs.parent_column_id) Prog
    FROM AllFKs INNER JOIN
         sys.objects AS FK ON FK.object_id = AllFKs.constraint_object_id INNER JOIN
         sys.objects AS P ON AllFKs.parent_object_id = P.object_id INNER JOIN
         sys.objects AS R ON AllFKs.referenced_object_id = R.object_id 
),
Transforms AS (
SELECT Relation AS OldName, 'FK_'+Parent+'_'+Referenced+
       CASE
        WHEN EXISTS(SELECT * FROM Relations R2 WHERE Prog>1 AND R2.Parent=R1.Parent AND R2.Referenced=R1.Referenced ) THEN CAST(Prog AS NVARCHAR(2))
        ELSE ''
       END NewName
  FROM Relations R1
)
SELECT * FROM Transforms
WHERE NewName NOT IN (SELECT OldName FROM Transforms)

OPEN rename_cursor

FETCH NEXT FROM rename_cursor 
INTO @old, @new

WHILE @@FETCH_STATUS = 0
BEGIN

EXEC sp_rename @old, @new, 'OBJECT'

FETCH NEXT FROM rename_cursor 
INTO @old, @new
END
CLOSE rename_cursor
DEALLOCATE rename_cursor