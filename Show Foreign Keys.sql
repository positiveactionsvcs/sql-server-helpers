SELECT 
  OBJECT_NAME(fk.parent_object_id) AS TableName,
  COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS ColumnName,
  fk.name AS ForeignKeyName,
  OBJECT_NAME(fk.referenced_object_id) AS ReferenceTableName,
  COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) AS ReferenceColumnName
FROM 
  sys.foreign_keys fk
INNER JOIN 
  sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
ORDER BY 
  TableName,
  ColumnName;