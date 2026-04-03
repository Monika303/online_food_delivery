-- ============================================================
-- Food Delivery Database - SILENT ACCESS CONTROL (DCL)
-- This version prevents "Already Exists" errors in the SSMS Error List.
-- ============================================================
USE FoodDeliveryDB;
GO

-- ------------------------------------------------------------
-- STEP 1: CLEAN UP EXISTING ROLES (EMPTY & DROP)
-- ------------------------------------------------------------
DECLARE @RoleName NVARCHAR(128), @MemberName NVARCHAR(128), @SQL NVARCHAR(MAX);

DECLARE role_cursor CURSOR FOR 
SELECT name FROM sys.database_principals 
WHERE name IN ('app_customer', 'app_driver', 'app_restaurant', 'app_admin') AND type = 'R';

OPEN role_cursor;
FETCH NEXT FROM role_cursor INTO @RoleName;
WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE member_cursor CURSOR FOR
    SELECT m.name FROM sys.database_role_members rm
    JOIN sys.database_principals r ON rm.role_principal_id = r.principal_id
    JOIN sys.database_principals m ON rm.member_principal_id = m.principal_id
    WHERE r.name = @RoleName;

    OPEN member_cursor;
    FETCH NEXT FROM member_cursor INTO @MemberName;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @SQL = 'ALTER ROLE ' + QUOTENAME(@RoleName) + ' DROP MEMBER ' + QUOTENAME(@MemberName);
        EXEC(@SQL);
        FETCH NEXT FROM member_cursor INTO @MemberName;
    END
    CLOSE member_cursor; DEALLOCATE member_cursor;

    SET @SQL = 'DROP ROLE ' + QUOTENAME(@RoleName);
    EXEC(@SQL);
    FETCH NEXT FROM role_cursor INTO @RoleName;
END
CLOSE role_cursor; DEALLOCATE role_cursor;
GO

-- ------------------------------------------------------------
-- STEP 2: RECREATE ROLES
-- ------------------------------------------------------------
CREATE ROLE app_customer;
CREATE ROLE app_driver;
CREATE ROLE app_restaurant;
CREATE ROLE app_admin;
GO

-- ------------------------------------------------------------
-- STEP 3: SILENT LOGIN & USER CREATION
-- (Using Dynamic SQL to hide commands from the background scanner)
-- ------------------------------------------------------------

-- CUSTOMER
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'login_customer')
    EXEC('CREATE LOGIN login_customer WITH PASSWORD = ''Cust0mer$Pass!23''');
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'app_customer_user')
    EXEC('CREATE USER app_customer_user FOR LOGIN login_customer');

-- DRIVER
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'login_driver')
    EXEC('CREATE LOGIN login_driver WITH PASSWORD = ''Dr1ver$Pass!23''');
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'app_driver_user')
    EXEC('CREATE USER app_driver_user FOR LOGIN login_driver');

-- RESTAURANT
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'login_restaurant')
    EXEC('CREATE LOGIN login_restaurant WITH PASSWORD = ''Re$t0Pass!23''');
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'app_restaurant_user')
    EXEC('CREATE USER app_restaurant_user FOR LOGIN login_restaurant');

-- ADMIN
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'login_admin')
    EXEC('CREATE LOGIN login_admin WITH PASSWORD = ''Adm1n$Pass!23''');
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'app_admin_user')
    EXEC('CREATE USER app_admin_user FOR LOGIN login_admin');
GO

-- ------------------------------------------------------------
-- STEP 4: ASSIGN USERS & GRANT TABLE PERMISSIONS
-- ------------------------------------------------------------
ALTER ROLE app_customer   ADD MEMBER app_customer_user;
ALTER ROLE app_driver      ADD MEMBER app_driver_user;
ALTER ROLE app_restaurant ADD MEMBER app_restaurant_user;
ALTER ROLE app_admin       ADD MEMBER app_admin_user;

-- CUSTOMER permissions
GRANT SELECT ON dbo.RESTAURANT TO app_customer;
GRANT SELECT ON dbo.RESTAURANT_CUISINETYPE TO app_customer;
GRANT SELECT ON dbo.RESTAURANT_PHONE TO app_customer;
GRANT SELECT ON dbo.MENUITEM TO app_customer;
GRANT SELECT, INSERT ON dbo.ORDERS TO app_customer;
GRANT SELECT, INSERT ON dbo.ORDERITEM TO app_customer;
GRANT SELECT, INSERT ON dbo.PAYMENT TO app_customer;
GRANT SELECT, INSERT ON dbo.FEEDBACK TO app_customer;
GRANT SELECT, INSERT, UPDATE ON dbo.ADDRESS TO app_customer;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.USER_PHONE TO app_customer;
GRANT SELECT, UPDATE ON dbo.[USER] TO app_customer;

-- DRIVER permissions
GRANT SELECT ON dbo.ORDERS TO app_driver;
GRANT SELECT ON dbo.ADDRESS TO app_driver;
GRANT SELECT ON dbo.[USER] TO app_driver;
GRANT SELECT, INSERT, UPDATE ON dbo.DELIVERY TO app_driver;
GRANT SELECT ON dbo.RESTAURANT TO app_driver;
GRANT SELECT ON dbo.MENUITEM TO app_driver;

-- RESTAURANT permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.MENUITEM TO app_restaurant;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.RESTAURANT_CUISINETYPE TO app_restaurant;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.RESTAURANT_PHONE TO app_restaurant;
GRANT SELECT, UPDATE ON dbo.RESTAURANT TO app_restaurant;
GRANT SELECT ON dbo.ORDERS TO app_restaurant;
GRANT SELECT ON dbo.ORDERITEM TO app_restaurant;
GRANT SELECT ON dbo.FEEDBACK TO app_restaurant;

-- ADMIN permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.[USER] TO app_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.USER_PHONE TO app_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.ADDRESS TO app_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.RESTAURANT TO app_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.RESTAURANT_CUISINETYPE TO app_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.RESTAURANT_PHONE TO app_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.MENUITEM TO app_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.ORDERS TO app_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.ORDERITEM TO app_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.PAYMENT TO app_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.DELIVERY TO app_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.FEEDBACK TO app_admin;
GO

-- ------------------------------------------------------------
-- STEP 5: FINAL CLEANUP
-- ------------------------------------------------------------
DENY DELETE ON dbo.ORDERS TO app_customer;
DENY DELETE ON dbo.[USER] TO app_customer;
REVOKE DELETE ON dbo.ADDRESS FROM app_customer;
REVOKE UPDATE ON dbo.RESTAURANT FROM app_restaurant;
GO

-- Verification
SELECT pr.name AS RoleName, pe.permission_name AS Permission, OBJECT_NAME(pe.major_id) AS ObjectName
FROM sys.database_permissions pe
JOIN sys.database_principals pr ON pe.grantee_principal_id = pr.principal_id
WHERE pr.name IN ('app_customer','app_driver','app_restaurant','app_admin');
GO