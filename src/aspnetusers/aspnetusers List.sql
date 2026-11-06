-- Get all users for a role.
SELECT u.UserId, u.UserName
FROM aspnet_Users u
JOIN aspnet_UsersInRoles ur ON u.UserId = ur.UserId
JOIN aspnet_Roles r ON ur.RoleId = r.RoleId
WHERE r.RoleName = '<role_name>'

-- Get all roles for a user.
SELECT r.RoleId, r.RoleName
FROM aspnet_Roles r
JOIN aspnet_UsersInRoles ur ON r.RoleId = ur.RoleId
JOIN aspnet_Users u ON ur.UserId = u.UserId
WHERE u.UserName = '<user_name>'