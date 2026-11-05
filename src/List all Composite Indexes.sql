-- List composite indexes.
SELECT 
    t.name AS TableName,
    STRING_AGG(c.name, ', ') WITHIN GROUP (ORDER BY ic.key_ordinal) + ' must be unique' AS IndexColumns
FROM 
    sys.indexes i
INNER JOIN 
    sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
INNER JOIN 
    sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
INNER JOIN 
    sys.tables t ON i.object_id = t.object_id
WHERE 
    i.is_unique = 1
	AND t.name <> 'sysdiagrams'  -- Exclude the sysdiagrams table
GROUP BY 
    t.name, i.name
HAVING 
    COUNT(ic.column_id) > 1
ORDER BY 
    t.name;