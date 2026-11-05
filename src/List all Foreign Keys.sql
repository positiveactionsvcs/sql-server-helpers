SELECT 
  SCHEMA_NAME(src.schema_id) AS SourceSchema,
  OBJECT_NAME(fk.parent_object_id) AS TableName,
  COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS ColumnName,
  fk.object_id AS ForeignKeyId,
  fk.name AS ForeignKeyName,
  SCHEMA_NAME(ref.schema_id) AS ReferencedSchema,
  OBJECT_NAME(fk.referenced_object_id) AS ReferenceTableName,
  COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) AS ReferenceColumnName,
  fkc.constraint_column_id AS KeyOrdinal
FROM 
  sys.foreign_keys fk
INNER JOIN 
  sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
INNER JOIN
  sys.tables src ON fk.parent_object_id = src.object_id
INNER JOIN
  sys.tables ref ON fk.referenced_object_id = ref.object_id
ORDER BY 
  SourceSchema,
  TableName,
  ForeignKeyName,
  KeyOrdinal