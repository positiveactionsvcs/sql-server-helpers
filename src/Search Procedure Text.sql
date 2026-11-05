-- Search stored procedure text for a string.
DECLARE @SearchText VARCHAR(MAX) = '%SOMETEXT%'

SELECT
	OBJECT_NAME(id) 
FROM
	syscomments 
WHERE
	[text] LIKE @SearchText
AND
	OBJECTPROPERTY(id, 'IsProcedure') = 1 
GROUP BY
	OBJECT_NAME(id)
 