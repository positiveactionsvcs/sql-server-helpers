-- List the column information for a temporary table.
DECLARE @TableName VARCHAR(MAX) = '#CAPACITYLPN_EBOMGrouped'

SELECT
    COLUMN_NAME AS ColumnName,
    DATA_TYPE As DataType,
    CHARACTER_MAXIMUM_LENGTH AS MaximumLength
FROM
	tempdb.INFORMATION_SCHEMA.COLUMNS
WHERE
	TABLE_NAME LIKE @TableName + '%';
