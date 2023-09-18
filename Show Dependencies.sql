SELECT  
    OBJECT_NAME(referencing_id) AS DependentObjectName,
    o.type_desc AS DependentObjectType
FROM 
    sys.sql_expression_dependencies sed
INNER JOIN 
    sys.objects o ON sed.referencing_id = o.object_id
WHERE 
    referenced_id = OBJECT_ID('YourTableName');