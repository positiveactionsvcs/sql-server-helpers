-- List logins that have been granted VIEW SERVER STATE permissions.
-- Allows users to see internal health, performance and status info.
SELECT
    sp.name AS LoginName,
    sp.type_desc,
    pe.permission_name,
    pe.state_desc
FROM
    sys.server_permissions pe
JOIN
    sys.server_principals sp ON pe.grantee_principal_id = sp.principal_id
WHERE
    pe.permission_name = 'VIEW SERVER STATE'
ORDER BY
    sp.name;
	
-- Grant/revoke these permissions.
--GRANT VIEW SERVER STATE TO [XXXX]
--REVOKE VIEW SERVER STATE TO [XXXX]