-- Eample of using STRING_AGG (the SQL Server 2022) version.
CROSS APPLY (
    SELECT
        STRING_AGG(DISTINCT TRIM(O2.CustomerPartNumber), '|')
        WITHIN GROUP (ORDER BY TRIM(O2.CustomerPartNumber)) AS CustomerPartNumber
    FROM
        #CAPACITYLPN_EBOM AS O2
    WHERE
        O2.LearBase = O.LearBase
        AND TRIM(O2.CustomerPartNumber) <> ''  -- exclude blank/whitespace-only
        -- (NULLs are ignored by STRING_AGG, so no need for IS NOT NULL)
) AS CPNS
