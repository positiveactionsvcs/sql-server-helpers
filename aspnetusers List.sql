-- Get all users for a role.
SELECT u.Id, u.UserName, u.Email
FROM AspNetUsers u
JOIN AspNetUserRoles ur ON u.Id = ur.UserId
JOIN AspNetRoles r ON ur.RoleId = r.Id
WHERE r.Name = 'RoleName';

-- Get all roles for a user.
SELECT r.Id, r.Name
FROM AspNetRoles r
JOIN AspNetUserRoles ur ON r.Id = ur.RoleId
JOIN AspNetUsers u ON ur.UserId = u.Id
WHERE u.UserName = 'UserName';