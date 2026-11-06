-- Create a table with all SQL Server data types typically used for development.
DECLARE @sql NVARCHAR(MAX) = '';
SELECT @sql += 'CREATE TABLE AllDataTypes (' + CHAR(13) + CHAR(10);

SELECT
    @sql += '[' + [name] + 'Null] ' +
    CASE
        -- Give decimal and numeric (which are identical) a meaningful precision and scale.
        WHEN [name] IN ('decimal', 'numeric') THEN '[' + [name] + '](18,2)'

        -- Give text fields the maximum value.
        WHEN [name] IN ('varchar', 'nvarchar', 'varbinary') THEN [name] + '(MAX)'

        -- Give these others a more sensible length.
        WHEN [name] IN ('char', 'nchar', 'binary') THEN [name] + '(10)'
        ELSE '[' + [name] + ']'
    END +
    ' NULL,' + CHAR(13) + CHAR(10)
    FROM
    sys.types
WHERE
    [is_user_defined] = 0
    AND [is_nullable] = 1
    -- Exclude deprecated and internal system types
    AND [name] NOT IN ('text', 'ntext', 'image', 'sysname', 'timestamp')
ORDER BY
    [name]

SELECT
    @sql += '[' + [name] + 'NotNull] ' +
    CASE
        -- Give decimal and numeric (which are identical) a meaningful precision and scale.
        WHEN [name] IN ('decimal', 'numeric') THEN '[' + [name] + '](18,2)'

        -- Give text fields the maximum value.
        WHEN [name] IN ('varchar', 'nvarchar', 'varbinary') THEN [name] + '(MAX)'

        -- Give these others a more sensible length.
        WHEN [name] IN ('char', 'nchar', 'binary') THEN [name] + '(10)'
        ELSE '[' + [name] + ']'
    END +
    ' NOT NULL,' + CHAR(13) + CHAR(10)
FROM
    sys.types
WHERE
    [is_user_defined] = 0
    -- Exclude deprecated types
    AND [name] NOT IN ('text', 'ntext', 'image', 'sysname', 'timestamp')
ORDER BY
    [name]

-- Remove the last comma
SET @sql = LEFT(@sql, LEN(@sql) - 3) + ')'

PRINT @sql
EXEC sys.sp_executesql @sql

-- Insert a test record into this table
INSERT INTO AllDataTypes
(
    bigintNull,
    binaryNull,
    bitNull,
    charNull,
    dateNull,
    datetimeNull,
    datetime2Null,
    datetimeoffsetNull,
    decimalNull,
    floatNull,
    geographyNull,
    geometryNull,
    hierarchyidNull,
    intNull,
    moneyNull,
    ncharNull,
    numericNull,
    nvarcharNull,
    realNull,
    smalldatetimeNull,
    smallintNull,
    smallmoneyNull,
    sql_variantNull,
    timeNull,
    tinyintNull,
    uniqueidentifierNull,
    varbinaryNull,
    varcharNull,
    xmlNull,
    bigintNotNull,
    binaryNotNull,
    bitNotNull,
    charNotNull,
    dateNotNull,
    datetimeNotNull,
    datetime2NotNull,
    datetimeoffsetNotNull,
    decimalNotNull,
    floatNotNull,
    geographyNotNull,
    geometryNotNull,
    hierarchyidNotNull,
    intNotNull,
    moneyNotNull,
    ncharNotNull,
    numericNotNull,
    nvarcharNotNull,
    realNotNull,
    smalldatetimeNotNull,
    smallintNotNull,
    smallmoneyNotNull,
    sql_variantNotNull,
    timeNotNull,
    tinyintNotNull,
    uniqueidentifierNotNull,
    varbinaryNotNull,
    varcharNotNull,
    xmlNotNull
)
VALUES
(
    1234567890123,
    0x0102030405060708090A,
    1,
    'ABCDEFGHIJ',
    '2026-01-01',
    '2026-01-01T12:34:56.997',
    '2026-01-01T12:34:56.1234567',
    '2026-01-01T12:34:56.1234567+00:00',
    12345.67,
    12345.6789,
    geography::Point(52.4068, -1.5197, 4326),
    geometry::Point(10, 20, 0),
    hierarchyid::Parse('/1/2/'),
    123456,
    1234.56,
    N'ABCDEFGHIJ',
    98765.43,
    N'Test NVARCHAR(MAX)',
    CAST(123.45 AS REAL),
    '2026-01-01T12:34:00',
    12345,
    123.45,
    CAST('SQL Variant' AS sql_variant),
    '12:34:56.1234567',
    255,
    '550E8400-E29B-41D4-A716-446655440000',
    0xDEADBEEF,
    'Test VARCHAR(MAX)',
    '<root><value>123</value></root>',

    1234567890123,
    0x0102030405060708090A,
    1,
    'ABCDEFGHIJ',
    '2026-01-01',
    '2026-01-01T12:34:56.997',
    '2026-01-01T12:34:56.1234567',
    '2026-01-01T12:34:56.1234567+00:00',
    12345.67,
    12345.6789,
    geography::Point(52.4068, -1.5197, 4326),
    geometry::Point(10, 20, 0),
    hierarchyid::Parse('/1/2/'),
    123456,
    1234.56,
    N'ABCDEFGHIJ',
    98765.43,
    N'Test NVARCHAR(MAX)',
    CAST(123.45 AS REAL),
    '2026-01-01T12:34:00',
    12345,
    123.45,
    CAST('SQL Variant' AS sql_variant),
    '12:34:56.1234567',
    255,
    '550E8400-E29B-41D4-A716-446655440000',
    0xDEADBEEF,
    'Test VARCHAR(MAX)',
    '<root><value>123</value></root>'
);
