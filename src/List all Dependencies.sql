DECLARE @ObjectName VARCHAR(255) = 'CAPACITY_LPN_Base'
DECLARE @ObjectId INT = OBJECT_ID(@ObjectName);

IF @ObjectId IS NULL
BEGIN
    RAISERROR('Object not found: %s', 16, 1, @ObjectName);
    RETURN
END

-------------------------------------
-- Objects that depend ON this object
-------------------------------------
SELECT DISTINCT
    ReferencingSchema = OBJECT_SCHEMA_NAME(d.referencing_id),
    ReferencingObject = OBJECT_NAME(d.referencing_id),
    ReferencingType = o.type_desc
FROM
    sys.sql_expression_dependencies d
INNER JOIN
    sys.objects o
    ON d.referencing_id = o.object_id
WHERE
    d.referenced_id = OBJECT_ID(@ObjectName)
ORDER BY
    ReferencingSchema,
    ReferencingObject

---------------------------------
-- Objects this object depends ON
---------------------------------
SELECT DISTINCT
    ReferencedSchema = OBJECT_SCHEMA_NAME(d.referenced_id),
    ReferencedObject = OBJECT_NAME(d.referenced_id),
    ReferencedType = o.type_desc
FROM
    sys.sql_expression_dependencies d
INNER JOIN
    sys.objects o
    ON d.referenced_id = o.object_id
WHERE
    d.referencing_id = OBJECT_ID(@ObjectName)
ORDER BY
    ReferencedSchema,
    ReferencedObject