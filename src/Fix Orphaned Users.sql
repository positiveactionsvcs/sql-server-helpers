-- Attempt to repair orphaned database users by ensuring that every database user has a
-- corresponding server login, then remap the user to that login.
SET NOCOUNT ON;

-- Loop counter used to process each database user.
DECLARE @Index INT

-- Current database user being processed.
DECLARE @User sysname

-- Dynamic SQL command buffer.
DECLARE @SQLCmd NVARCHAR(MAX) = ''

-- Temporary list of database users to process.
IF OBJECT_ID('tempdb..#Orphaned') IS NOT NULL DROP TABLE #Orphaned
CREATE TABLE #Orphaned (UserName sysname, Ident INT IDENTITY(1,1))

-- Populate the list with all non-system users.
-- Excludes built-in users and fixed database roles.
INSERT INTO #Orphaned (UserName)
    SELECT
        [name]
    FROM
        sys.database_principals
    WHERE
        [type] IN ('U', 'S')
        AND is_fixed_role = 0
        AND [Name] NOT IN ('dbo', 'guest', 'sys', 'INFORMATION_SCHEMA')

-- Continue only if there are users to process.
IF (SELECT COUNT(*) FROM #Orphaned) > 0
BEGIN
    SET @Index = 1

    -- Iterate through each database user.
    WHILE @Index <= (SELECT MAX(Ident) FROM #Orphaned)
    BEGIN
        SET @User = (SELECT UserName FROM #Orphaned WHERE Ident = @Index)

        -- If a matching server login does not exist, create one.
        IF (SELECT COUNT(*) FROM sys.server_principals WHERE [Name] = @User) <= 0
        BEGIN
            -- Missing Windows logins
            IF EXISTS
            (
                SELECT 1 FROM sys.database_principals WHERE [Name] = @User AND type_desc = 'WINDOWS_USER'
            )
            BEGIN
                SET @SQLCmd = 'CREATE LOGIN [' + @User + '] FROM WINDOWS'
                EXEC (@SQLCmd)
                PRINT @SQLCmd
            END

            -- Missing SQL authentication logins
            IF EXISTS
            (
                SELECT 1 FROM sys.database_principals WHERE [Name] = @User AND type_desc = 'SQL_USER'
            )
            BEGIN
                SET @SQLCmd = 'CREATE LOGIN [' + @User + '] WITH PASSWORD = N''password'''
                EXEC (@SQLCmd)
                PRINT @SQLCmd
            END
        END

        -- Map the database user to the corresponding login.
        SET @SQLCmd = 'ALTER USER [' + @User + '] WITH LOGIN = [' + @User + ']'
        EXEC (@SQLCmd)
        PRINT @User + ' link to database user reset.'

        SET @Index = @Index + 1
    END
END
