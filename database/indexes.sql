-- ============================================================
-- Food Delivery Database - INDEXES (T-SQL / SQL Server)
-- Run this in SQL Server Management Studio (SSMS)
-- ============================================================

USE FoodDeliveryDB;
GO

-- ============================================================
-- HOW TO READ THIS FILE
-- Each index block contains:
--   WHY     → which query / view / join benefits
--   TYPE    → Nonclustered / Unique / Composite / Filtered
--   COLUMNS → key column(s) + optional INCLUDEd columns
-- ============================================================


-- ============================================================
-- TABLE: USER
-- ============================================================

-- WHY: Login lookups always search by Email (unique, frequent)
-- TYPE: Unique Nonclustered
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_USER_Email' AND object_id = OBJECT_ID('dbo.[USER]'))
    DROP INDEX IX_USER_Email ON [USER];
GO
CREATE UNIQUE NONCLUSTERED INDEX IX_USER_Email
    ON [USER] (Email)
    INCLUDE (FirstName, LastName, UserType);
GO

-- WHY: Username lookups at login / profile pages
-- TYPE: Unique Nonclustered
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_USER_UserName' AND object_id = OBJECT_ID('dbo.[USER]'))
    DROP INDEX IX_USER_UserName ON [USER];
GO
CREATE UNIQUE NONCLUSTERED INDEX IX_USER_UserName
    ON [USER] (UserName)
    INCLUDE (Email, UserType);
GO

-- WHY: Filter users by type (customer / driver / admin)
--      Used in vw_UnservedCustomers and driver assignment queries
-- TYPE: Nonclustered
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_USER_UserType' AND object_id = OBJECT_ID('dbo.[USER]'))
    DROP INDEX IX_USER_UserType ON [USER];
GO
CREATE NONCLUSTERED INDEX IX_USER_UserType
    ON [USER] (UserType)
    INCLUDE (FirstName, LastName, Email);
GO


-- ============================================================
-- TABLE: USER_PHONE
-- ============================================================

-- WHY: JOIN USER_PHONE → USER on UserID (FK lookup)
-- TYPE: Nonclustered
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_USER_PHONE_UserID' AND object_id = OBJECT_ID('dbo.USER_PHONE'))
    DROP INDEX IX_USER_PHONE_UserID ON USER_PHONE;
GO
CREATE NONCLUSTERED INDEX IX_USER_PHONE_UserID
    ON USER_PHONE (UserID)
    INCLUDE (Phone);
GO


-- ============================================================
-- TABLE: ADDRESS
-- ============================================================

-- WHY: JOIN DELIVERY → ADDRESS on AddressID (FK lookup)
--      Used heavily in vw_FullOrderSummary and vw_DeliveryDriverPerformance
-- TYPE: Nonclustered
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_ADDRESS_UserID' AND object_id = OBJECT_ID('dbo.ADDRESS'))
    DROP INDEX IX_ADDRESS_UserID ON ADDRESS;
GO
CREATE NONCLUSTERED INDEX IX_ADDRESS_UserID
    ON ADDRESS (UserID)
    INCLUDE (City, StreetName, StreetNumber, IsDefault);
GO

-- WHY: Filter or group deliveries by city
-- TYPE: Nonclustered
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_ADDRESS_City' AND object_id = OBJECT_ID('dbo.ADDRESS'))
    DROP INDEX IX_ADDRESS_City ON ADDRESS;
GO
CREATE NONCLUSTERED INDEX IX_ADDRESS_City
    ON ADDRESS (City)
    INCLUDE (StreetName, StreetNumber, PostalCode);
GO


-- ============================================================
-- TABLE: RESTAURANT
-- ============================================================

-- WHY: Filter active restaurants (IsActive = 1) — used in almost
--      every restaurant query and all menu-related views
-- TYPE: Filtered Nonclustered (only indexes active rows → smaller, faster)
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_RESTAURANT_IsActive' AND object_id = OBJECT_ID('dbo.RESTAURANT'))
    DROP INDEX IX_RESTAURANT_IsActive ON RESTAURANT;
GO
CREATE NONCLUSTERED INDEX IX_RESTAURANT_IsActive
    ON RESTAURANT (IsActive)
    INCLUDE (Name, Rating, City)
    WHERE IsActive = 1;
GO

-- WHY: Sort / filter restaurants by rating
--      Used in vw_RestaurantRatingSummary ORDER BY AverageUserRating
-- TYPE: Nonclustered
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_RESTAURANT_Rating' AND object_id = OBJECT_ID('dbo.RESTAURANT'))
    DROP INDEX IX_RESTAURANT_Rating ON RESTAURANT;
GO
CREATE NONCLUSTERED INDEX IX_RESTAURANT_Rating
    ON RESTAURANT (Rating DESC)
    INCLUDE (Name, City, IsActive);
GO

-- WHY: Filter restaurants by city
-- TYPE: Nonclustered
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_RESTAURANT_City' AND object_id = OBJECT_ID('dbo.RESTAURANT'))
    DROP INDEX IX_RESTAURANT_City ON RESTAURANT;
GO
CREATE NONCLUSTERED INDEX IX_RESTAURANT_City
    ON RESTAURANT (City)
    INCLUDE (Name, Rating, IsActive);
GO


-- ============================================================
-- TABLE: RESTAURANT_CUISINETYPE
-- ============================================================

-- WHY: Filter restaurants by cuisine type (Query 12, vw_ActiveRestaurantsWithCuisines)
--      Most frequent WHERE clause on this table
-- TYPE: Nonclustered
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_RCT_CuisineType' AND object_id = OBJECT_ID('dbo.RESTAURANT_CUISINETYPE'))
    DROP INDEX IX_RCT_CuisineType ON RESTAURANT_CUISINETYPE;
GO
CREATE NONCLUSTERED INDEX IX_RCT_CuisineType
    ON RESTAURANT_CUISINETYPE (CuisineType)
    INCLUDE (RestaurantID);
GO

-- WHY: JOIN RESTAURANT → RESTAURANT_CUISINETYPE on RestaurantID (FK lookup)
-- TYPE: Nonclustered
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_RCT_RestaurantID' AND object_id = OBJECT_ID('dbo.RESTAURANT_CUISINETYPE'))
    DROP INDEX IX_RCT_RestaurantID ON RESTAURANT_CUISINETYPE;
GO
CREATE NONCLUSTERED INDEX IX_RCT_RestaurantID
    ON RESTAURANT_CUISINETYPE (RestaurantID)
    INCLUDE (CuisineType);
GO


-- ============================================================
-- TABLE: RESTAURANT_PHONE
-- ============================================================

-- WHY: JOIN RESTAURANT → RESTAURANT_PHONE on RestaurantID (FK lookup)
--      Used in vw_ActiveRestaurantsWithCuisines
-- TYPE: Nonclustered
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_RPHONE_RestaurantID' AND object_id = OBJECT_ID('dbo.RESTAURANT_PHONE'))
    DROP INDEX IX_RPHONE_RestaurantID ON RESTAURANT_PHONE;
GO
CREATE NONCLUSTERED INDEX IX_RPHONE_RestaurantID
    ON RESTAURANT_PHONE (RestaurantID)
    INCLUDE (Phone);
GO


-- ============================================================
-- TABLE: MENUITEM
-- ============================================================

-- WHY: JOIN MENUITEM → RESTAURANT on RestaurantID (FK lookup)
--      Used in vw_MenuItemsWithRestaurant, vw_RevenueByRestaurant, vw_TopMenuItems
-- TYPE: Nonclustered
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_MENUITEM_RestaurantID' AND object_id = OBJECT_ID('dbo.MENUITEM'))
    DROP INDEX IX_MENUITEM_RestaurantID ON MENUITEM;
GO
CREATE NONCLUSTERED INDEX IX_MENUITEM_RestaurantID
    ON MENUITEM (RestaurantID)
    INCLUDE (Name, Price, IsAvailable);
GO

-- WHY: Filter available items (IsAvailable = 1) — very frequent filter
-- TYPE: Filtered Nonclustered
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_MENUITEM_IsAvailable' AND object_id = OBJECT_ID('dbo.MENUITEM'))
    DROP INDEX IX_MENUITEM_IsAvailable ON MENUITEM;
GO
CREATE NONCLUSTERED INDEX IX_MENUITEM_IsAvailable
    ON MENUITEM (IsAvailable)
    INCLUDE (RestaurantID, Name, Price)
    WHERE IsAvailable = 1;
GO

-- WHY: Filter / sort by price range
-- TYPE: Nonclustered
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_MENUITEM_Price' AND object_id = OBJECT_ID('dbo.MENUITEM'))
    DROP INDEX IX_MENUITEM_Price ON MENUITEM;
GO
CREATE NONCLUSTERED INDEX IX_MENUITEM_Price
    ON MENUITEM (Price ASC)
    INCLUDE (Name, RestaurantID, IsAvailable);
GO


-- ============================================================
-- TABLE: ORDERS
-- ============================================================

-- WHY: JOIN ORDERS → USER on UserID (FK lookup)
--      Used in vw_FullOrderSummary, vw_CustomerOrderHistory, Query 5
-- TYPE: Nonclustered
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_ORDERS_UserID' AND object_id = OBJECT_ID('dbo.ORDERS'))
    DROP INDEX IX_ORDERS_UserID ON ORDERS;
GO
CREATE NONCLUSTERED INDEX IX_ORDERS_UserID
    ON ORDERS (UserID)
    INCLUDE (Status, TotalPrice, OrderDate);
GO

-- WHY: Filter orders by status — most frequent WHERE clause on ORDERS
--      Used in Query 2, vw_PendingAndActiveOrders, vw_FullOrderSummary filters
-- TYPE: Nonclustered
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_ORDERS_Status' AND object_id = OBJECT_ID('dbo.ORDERS'))
    DROP INDEX IX_ORDERS_Status ON ORDERS;
GO
CREATE NONCLUSTERED INDEX IX_ORDERS_Status
    ON ORDERS (Status)
    INCLUDE (UserID, TotalPrice, OrderDate);
GO

-- WHY: Range queries and sorting by date (ORDER BY OrderDate DESC)
--      Used in vw_FullOrderSummary, vw_CustomerOrderHistory
-- TYPE: Nonclustered
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_ORDERS_OrderDate' AND object_id = OBJECT_ID('dbo.ORDERS'))
    DROP INDEX IX_ORDERS_OrderDate ON ORDERS;
GO
CREATE NONCLUSTERED INDEX IX_ORDERS_OrderDate
    ON ORDERS (OrderDate DESC)
    INCLUDE (UserID, Status, TotalPrice);
GO


-- ============================================================
-- TABLE: ORDERITEM
-- ============================================================

-- WHY: JOIN ORDERITEM → ORDERS on OrderID (FK lookup)
--      Used in vw_CustomerOrderHistory, vw_TopMenuItems, vw_RevenueByRestaurant
-- TYPE: Nonclustered
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_ORDERITEM_OrderID' AND object_id = OBJECT_ID('dbo.ORDERITEM'))
    DROP INDEX IX_ORDERITEM_OrderID ON ORDERITEM;
GO
CREATE NONCLUSTERED INDEX IX_ORDERITEM_OrderID
    ON ORDERITEM (OrderID)
    INCLUDE (ItemID, Quantity, UnitPrice);
GO

-- WHY: JOIN ORDERITEM → MENUITEM on ItemID (FK lookup)
--      Used in vw_TopMenuItems, vw_RevenueByRestaurant, Query 7
-- TYPE: Nonclustered
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_ORDERITEM_ItemID' AND object_id = OBJECT_ID('dbo.ORDERITEM'))
    DROP INDEX IX_ORDERITEM_ItemID ON ORDERITEM;
GO
CREATE NONCLUSTERED INDEX IX_ORDERITEM_ItemID
    ON ORDERITEM (ItemID)
    INCLUDE (OrderID, Quantity, UnitPrice);
GO

-- WHY: Composite index for aggregation queries that GROUP BY OrderID + ItemID
--      Covers vw_TopMenuItems SUM(Quantity) and revenue calculations
-- TYPE: Composite Nonclustered
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_ORDERITEM_OrderID_ItemID' AND object_id = OBJECT_ID('dbo.ORDERITEM'))
    DROP INDEX IX_ORDERITEM_OrderID_ItemID ON ORDERITEM;
GO
CREATE NONCLUSTERED INDEX IX_ORDERITEM_OrderID_ItemID
    ON ORDERITEM (OrderID, ItemID)
    INCLUDE (Quantity, UnitPrice);
GO


-- ============================================================
-- TABLE: PAYMENT
-- ============================================================

-- WHY: JOIN PAYMENT → ORDERS on OrderID (FK lookup, 1-to-1)
--      Used in vw_FullOrderSummary, vw_PendingAndActiveOrders, Query 18-19
-- TYPE: Unique Nonclustered (OrderID is unique in PAYMENT)
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_PAYMENT_OrderID' AND object_id = OBJECT_ID('dbo.PAYMENT'))
    DROP INDEX IX_PAYMENT_OrderID ON PAYMENT;
GO
CREATE UNIQUE NONCLUSTERED INDEX IX_PAYMENT_OrderID
    ON PAYMENT (OrderID)
    INCLUDE (Amount, Method, PaymentStatus, PaymentTime);
GO

-- WHY: Filter payments by status (completed / refunded / pending)
--      Used in Query 18, vw_RevenueByRestaurant
-- TYPE: Nonclustered
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_PAYMENT_PaymentStatus' AND object_id = OBJECT_ID('dbo.PAYMENT'))
    DROP INDEX IX_PAYMENT_PaymentStatus ON PAYMENT;
GO
CREATE NONCLUSTERED INDEX IX_PAYMENT_PaymentStatus
    ON PAYMENT (PaymentStatus)
    INCLUDE (OrderID, Amount, Method);
GO

-- WHY: Filter payments by method (cash, credit_card, etc.) — Query 17
-- TYPE: Nonclustered
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_PAYMENT_Method' AND object_id = OBJECT_ID('dbo.PAYMENT'))
    DROP INDEX IX_PAYMENT_Method ON PAYMENT;
GO
CREATE NONCLUSTERED INDEX IX_PAYMENT_Method
    ON PAYMENT (Method)
    INCLUDE (OrderID, Amount, PaymentStatus);
GO


-- ============================================================
-- TABLE: DELIVERY
-- ============================================================

-- WHY: JOIN DELIVERY → ORDERS on OrderID (FK lookup)
--      Used in vw_FullOrderSummary, vw_DeliveryDriverPerformance, Query 15, 18
-- TYPE: Nonclustered
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_DELIVERY_OrderID' AND object_id = OBJECT_ID('dbo.DELIVERY'))
    DROP INDEX IX_DELIVERY_OrderID ON DELIVERY;
GO
CREATE NONCLUSTERED INDEX IX_DELIVERY_OrderID
    ON DELIVERY (OrderID)
    INCLUDE (UserID, AddressID, DeliveryStatus, PickupTime, DeliveryTime);
GO

-- WHY: Filter deliveries by driver (UserID) — Query 16, vw_DeliveryDriverPerformance
-- TYPE: Nonclustered
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_DELIVERY_UserID' AND object_id = OBJECT_ID('dbo.DELIVERY'))
    DROP INDEX IX_DELIVERY_UserID ON DELIVERY;
GO
CREATE NONCLUSTERED INDEX IX_DELIVERY_UserID
    ON DELIVERY (UserID)
    INCLUDE (OrderID, AddressID, DeliveryStatus, PickupTime, DeliveryTime);
GO

-- WHY: JOIN DELIVERY → ADDRESS on AddressID (FK lookup)
--      Used in vw_FullOrderSummary, vw_DeliveryDriverPerformance, Query 20
-- TYPE: Nonclustered
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_DELIVERY_AddressID' AND object_id = OBJECT_ID('dbo.DELIVERY'))
    DROP INDEX IX_DELIVERY_AddressID ON DELIVERY;
GO
CREATE NONCLUSTERED INDEX IX_DELIVERY_AddressID
    ON DELIVERY (AddressID)
    INCLUDE (OrderID, DeliveryStatus, DeliveryTime);
GO

-- WHY: Filter deliveries by status — Query 14, vw_PendingAndActiveOrders
-- TYPE: Nonclustered
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_DELIVERY_DeliveryStatus' AND object_id = OBJECT_ID('dbo.DELIVERY'))
    DROP INDEX IX_DELIVERY_DeliveryStatus ON DELIVERY;
GO
CREATE NONCLUSTERED INDEX IX_DELIVERY_DeliveryStatus
    ON DELIVERY (DeliveryStatus)
    INCLUDE (OrderID, UserID, PickupTime, DeliveryTime);
GO


-- ============================================================
-- TABLE: FEEDBACK
-- ============================================================

-- WHY: JOIN FEEDBACK → RESTAURANT on RestaurantID (FK lookup)
--      Used in vw_RestaurantRatingSummary, Query 21, 27
-- TYPE: Nonclustered
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FEEDBACK_RestaurantID' AND object_id = OBJECT_ID('dbo.FEEDBACK'))
    DROP INDEX IX_FEEDBACK_RestaurantID ON FEEDBACK;
GO
CREATE NONCLUSTERED INDEX IX_FEEDBACK_RestaurantID
    ON FEEDBACK (RestaurantID)
    INCLUDE (UserID, OrderID, Rating, FeedbackDate);
GO

-- WHY: JOIN FEEDBACK → USER on UserID (FK lookup) — Query 23, 25
-- TYPE: Nonclustered
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FEEDBACK_UserID' AND object_id = OBJECT_ID('dbo.FEEDBACK'))
    DROP INDEX IX_FEEDBACK_UserID ON FEEDBACK;
GO
CREATE NONCLUSTERED INDEX IX_FEEDBACK_UserID
    ON FEEDBACK (UserID)
    INCLUDE (RestaurantID, OrderID, Rating);
GO

-- WHY: JOIN FEEDBACK → ORDERS on OrderID (FK lookup) — Query 26
-- TYPE: Nonclustered
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FEEDBACK_OrderID' AND object_id = OBJECT_ID('dbo.FEEDBACK'))
    DROP INDEX IX_FEEDBACK_OrderID ON FEEDBACK;
GO
CREATE NONCLUSTERED INDEX IX_FEEDBACK_OrderID
    ON FEEDBACK (OrderID)
    INCLUDE (UserID, RestaurantID, Rating);
GO

-- WHY: Filter feedback by rating — Query 22 (> 4), Query 27 (< 3)
--      Also used in vw_RestaurantRatingSummary aggregation
-- TYPE: Nonclustered
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FEEDBACK_Rating' AND object_id = OBJECT_ID('dbo.FEEDBACK'))
    DROP INDEX IX_FEEDBACK_Rating ON FEEDBACK;
GO
CREATE NONCLUSTERED INDEX IX_FEEDBACK_Rating
    ON FEEDBACK (Rating)
    INCLUDE (RestaurantID, UserID, OrderID, Comment);
GO


-- ============================================================
-- VERIFY ALL INDEXES CREATED
-- ============================================================
SELECT
    t.name          AS TableName,
    i.name          AS IndexName,
    i.type_desc     AS IndexType,
    i.is_unique     AS IsUnique,
    i.has_filter    AS IsFiltered,
    i.filter_definition AS FilterCondition
FROM sys.indexes i
INNER JOIN sys.tables t ON i.object_id = t.object_id
WHERE i.type > 0                          -- exclude heaps
  AND t.name IN (
      'USER','USER_PHONE','ADDRESS',
      'RESTAURANT','RESTAURANT_CUISINETYPE','RESTAURANT_PHONE',
      'MENUITEM','ORDERS','ORDERITEM',
      'PAYMENT','DELIVERY','FEEDBACK'
  )
ORDER BY t.name, i.name;
GO