-- ============================================================
-- Food Delivery Database - VIEWS (T-SQL / SQL Server)
-- Run this in SQL Server Management Studio (SSMS)
-- ============================================================

USE FoodDeliveryDB;
GO

-- ============================================================
-- VIEW 1: vw_ActiveRestaurantsWithCuisines
-- Shows all active restaurants with their cuisine types,
-- contact phones, and location details.
-- Reporting use: Restaurant directory / admin dashboard
-- ============================================================
IF OBJECT_ID('dbo.vw_ActiveRestaurantsWithCuisines', 'V') IS NOT NULL
    DROP VIEW dbo.vw_ActiveRestaurantsWithCuisines;
GO

CREATE VIEW vw_ActiveRestaurantsWithCuisines AS
SELECT
    R.RestaurantID,
    R.Name                              AS RestaurantName,
    R.Rating,
    R.City,
    R.StreetName,
    R.StreetNumber,
    R.Unit,
    RC.CuisineType,
    RP.Phone
FROM RESTAURANT R
INNER JOIN RESTAURANT_CUISINETYPE RC ON R.RestaurantID = RC.RestaurantID
INNER JOIN RESTAURANT_PHONE       RP ON R.RestaurantID = RP.RestaurantID
WHERE R.IsActive = 1;
GO

-- Sample usage:
-- SELECT * FROM vw_ActiveRestaurantsWithCuisines;
-- SELECT * FROM vw_ActiveRestaurantsWithCuisines WHERE CuisineType = 'Italian';
-- SELECT * FROM vw_ActiveRestaurantsWithCuisines WHERE City = 'New York';


-- ============================================================
-- VIEW 2: vw_FullOrderSummary
-- Every order with the customer name, itemized line totals,
-- payment status, and delivery status in one flat row.
-- Reporting use: Order management / operations dashboard
-- ============================================================
IF OBJECT_ID('dbo.vw_FullOrderSummary', 'V') IS NOT NULL
    DROP VIEW dbo.vw_FullOrderSummary;
GO

CREATE VIEW vw_FullOrderSummary AS
SELECT
    O.OrderID,
    O.OrderDate,
    O.Status                            AS OrderStatus,
    O.TotalPrice,
    U.UserID,
    U.FirstName + ' ' + U.LastName      AS CustomerName,
    U.Email                             AS CustomerEmail,
    P.PaymentID,
    P.Method                            AS PaymentMethod,
    P.PaymentStatus,
    P.Amount                            AS AmountPaid,
    D.DeliveryID,
    D.DeliveryStatus,
    D.PickupTime,
    D.DeliveryTime,
    A.City                              AS DeliveryCity,
    A.StreetName                        AS DeliveryStreet,
    A.StreetNumber                      AS DeliveryStreetNo,
    A.Apartment                         AS DeliveryApartment
FROM ORDERS O
INNER JOIN [USER]   U ON O.UserID     = U.UserID
INNER JOIN PAYMENT  P ON O.OrderID    = P.OrderID
LEFT  JOIN DELIVERY D ON O.OrderID    = D.OrderID
LEFT  JOIN ADDRESS  A ON D.AddressID  = A.AddressID;
GO

-- Sample usage:
-- SELECT * FROM vw_FullOrderSummary;
-- SELECT * FROM vw_FullOrderSummary WHERE OrderStatus = 'delivered';
-- SELECT * FROM vw_FullOrderSummary WHERE CustomerName = 'Alice Johnson';
-- SELECT * FROM vw_FullOrderSummary WHERE PaymentStatus = 'completed' AND DeliveryStatus = 'delivered';


-- ============================================================
-- VIEW 3: vw_MenuItemsWithRestaurant
-- All menu items joined with their restaurant info.
-- Reporting use: Menu catalog / customer-facing listings
-- ============================================================
IF OBJECT_ID('dbo.vw_MenuItemsWithRestaurant', 'V') IS NOT NULL
    DROP VIEW dbo.vw_MenuItemsWithRestaurant;
GO

CREATE VIEW vw_MenuItemsWithRestaurant AS
SELECT
    M.ItemID,
    M.Name                              AS MenuItemName,
    M.Price,
    M.Description,
    M.IsAvailable,
    R.RestaurantID,
    R.Name                              AS RestaurantName,
    R.City                              AS RestaurantCity,
    R.Rating                            AS RestaurantRating
FROM MENUITEM M
INNER JOIN RESTAURANT R ON M.RestaurantID = R.RestaurantID
WHERE M.IsAvailable = 1
  AND R.IsActive    = 1;
GO

-- Sample usage:
-- SELECT * FROM vw_MenuItemsWithRestaurant;
-- SELECT * FROM vw_MenuItemsWithRestaurant WHERE RestaurantCity = 'Chicago';
-- SELECT * FROM vw_MenuItemsWithRestaurant WHERE Price < 10.00 ORDER BY Price;
-- SELECT * FROM vw_MenuItemsWithRestaurant WHERE RestaurantName = 'Sushi Sensation';


-- ============================================================
-- VIEW 4: vw_CustomerOrderHistory
-- Full order history per customer including items ordered,
-- quantities, and line totals.
-- Reporting use: Customer profile / order history page
-- ============================================================
IF OBJECT_ID('dbo.vw_CustomerOrderHistory', 'V') IS NOT NULL
    DROP VIEW dbo.vw_CustomerOrderHistory;
GO

CREATE VIEW vw_CustomerOrderHistory AS
SELECT
    U.UserID,
    U.FirstName + ' ' + U.LastName      AS CustomerName,
    U.Email,
    O.OrderID,
    O.OrderDate,
    O.Status                            AS OrderStatus,
    O.TotalPrice                        AS OrderTotal,
    OI.OrderItemID,
    M.Name                              AS MenuItemName,
    OI.Quantity,
    OI.UnitPrice,
    OI.Quantity * OI.UnitPrice          AS LineTotal,
    R.Name                              AS RestaurantName
FROM [USER] U
INNER JOIN ORDERS     O  ON U.UserID       = O.UserID
INNER JOIN ORDERITEM  OI ON O.OrderID      = OI.OrderID
INNER JOIN MENUITEM   M  ON OI.ItemID      = M.ItemID
INNER JOIN RESTAURANT R  ON M.RestaurantID = R.RestaurantID;
GO

-- Sample usage:
-- SELECT * FROM vw_CustomerOrderHistory;
-- SELECT * FROM vw_CustomerOrderHistory WHERE UserID = 5;
-- SELECT * FROM vw_CustomerOrderHistory WHERE OrderStatus = 'delivered' ORDER BY OrderDate DESC;
-- SELECT CustomerName, SUM(OrderTotal) AS TotalSpent
--   FROM vw_CustomerOrderHistory
--   GROUP BY CustomerName
--   ORDER BY TotalSpent DESC;


-- ============================================================
-- VIEW 5: vw_DeliveryDriverPerformance
-- All deliveries with driver info and time-to-deliver
-- calculated in minutes.
-- Reporting use: Driver performance / logistics report
-- ============================================================
IF OBJECT_ID('dbo.vw_DeliveryDriverPerformance', 'V') IS NOT NULL
    DROP VIEW dbo.vw_DeliveryDriverPerformance;
GO

CREATE VIEW vw_DeliveryDriverPerformance AS
SELECT
    D.DeliveryID,
    U.UserID                            AS DriverID,
    U.FirstName + ' ' + U.LastName      AS DriverName,
    U.Email                             AS DriverEmail,
    D.OrderID,
    D.DeliveryStatus,
    D.PickupTime,
    D.DeliveryTime,
    CASE
        WHEN D.PickupTime IS NOT NULL AND D.DeliveryTime IS NOT NULL
        THEN DATEDIFF(MINUTE, D.PickupTime, D.DeliveryTime)
        ELSE NULL
    END                                 AS DeliveryDurationMinutes,
    A.City                              AS DeliveryCity,
    A.StreetName                        AS DeliveryStreet
FROM DELIVERY D
INNER JOIN [USER]  U ON D.UserID    = U.UserID
INNER JOIN ADDRESS A ON D.AddressID = A.AddressID;
GO

-- Sample usage:
-- SELECT * FROM vw_DeliveryDriverPerformance;
-- SELECT * FROM vw_DeliveryDriverPerformance WHERE DriverID = 31;
-- SELECT DriverName, COUNT(*) AS TotalDeliveries,
--        AVG(DeliveryDurationMinutes) AS AvgDeliveryMins
--   FROM vw_DeliveryDriverPerformance
--   WHERE DeliveryStatus = 'delivered'
--   GROUP BY DriverName
--   ORDER BY AvgDeliveryMins;


-- ============================================================
-- VIEW 6: vw_RestaurantRatingSummary
-- Aggregated feedback stats per restaurant.
-- Reporting use: Restaurant ratings dashboard / analytics
-- ============================================================
IF OBJECT_ID('dbo.vw_RestaurantRatingSummary', 'V') IS NOT NULL
    DROP VIEW dbo.vw_RestaurantRatingSummary;
GO

CREATE VIEW vw_RestaurantRatingSummary AS
SELECT
    R.RestaurantID,
    R.Name                              AS RestaurantName,
    R.City,
    R.Rating                            AS OverallRating,
    COUNT(F.FeedbackID)                 AS TotalReviews,
    AVG(CAST(F.Rating AS DECIMAL(4,2))) AS AverageUserRating,
    MAX(F.Rating)                       AS HighestRating,
    MIN(F.Rating)                       AS LowestRating,
    SUM(CASE WHEN F.Rating >= 4 THEN 1 ELSE 0 END) AS PositiveReviews,
    SUM(CASE WHEN F.Rating <= 2 THEN 1 ELSE 0 END) AS NegativeReviews
FROM RESTAURANT R
LEFT JOIN FEEDBACK F ON R.RestaurantID = F.RestaurantID
GROUP BY
    R.RestaurantID,
    R.Name,
    R.City,
    R.Rating;
GO

-- Sample usage:
-- SELECT * FROM vw_RestaurantRatingSummary ORDER BY AverageUserRating DESC;
-- SELECT * FROM vw_RestaurantRatingSummary WHERE TotalReviews > 5;
-- SELECT * FROM vw_RestaurantRatingSummary WHERE NegativeReviews > 0;


-- ============================================================
-- VIEW 7: vw_UnservedCustomers
-- Customers who registered but have never placed an order.
-- Reporting use: Marketing / re-engagement campaigns
-- ============================================================
IF OBJECT_ID('dbo.vw_UnservedCustomers', 'V') IS NOT NULL
    DROP VIEW dbo.vw_UnservedCustomers;
GO

CREATE VIEW vw_UnservedCustomers AS
SELECT
    U.UserID,
    U.FirstName,
    U.LastName,
    U.Email,
    U.UserName,
    U.CreatedAt                         AS RegisteredAt
FROM [USER] U
WHERE U.UserType = 'customer'
  AND U.UserID NOT IN (
      SELECT DISTINCT UserID FROM ORDERS
  );
GO

-- Sample usage:
-- SELECT * FROM vw_UnservedCustomers;
-- SELECT COUNT(*) AS InactiveCustomers FROM vw_UnservedCustomers;


-- ============================================================
-- VIEW 8: vw_RevenueByRestaurant
-- Total revenue generated through completed payments,
-- broken down per restaurant.
-- Reporting use: Finance / revenue reporting
-- ============================================================
IF OBJECT_ID('dbo.vw_RevenueByRestaurant', 'V') IS NOT NULL
    DROP VIEW dbo.vw_RevenueByRestaurant;
GO

CREATE VIEW vw_RevenueByRestaurant AS
SELECT
    R.RestaurantID,
    R.Name                              AS RestaurantName,
    R.City,
    COUNT(DISTINCT O.OrderID)           AS TotalOrders,
    SUM(OI.Quantity * OI.UnitPrice)     AS GrossRevenue,
    AVG(O.TotalPrice)                   AS AverageOrderValue,
    MIN(O.OrderDate)                    AS FirstOrderDate,
    MAX(O.OrderDate)                    AS LastOrderDate
FROM RESTAURANT R
INNER JOIN MENUITEM  M  ON R.RestaurantID = M.RestaurantID
INNER JOIN ORDERITEM OI ON M.ItemID       = OI.ItemID
INNER JOIN ORDERS    O  ON OI.OrderID     = O.OrderID
INNER JOIN PAYMENT   P  ON O.OrderID      = P.OrderID
WHERE P.PaymentStatus = 'completed'
  AND O.Status        != 'cancelled'
GROUP BY
    R.RestaurantID,
    R.Name,
    R.City;
GO

-- Sample usage:
-- SELECT * FROM vw_RevenueByRestaurant ORDER BY GrossRevenue DESC;
-- SELECT * FROM vw_RevenueByRestaurant WHERE TotalOrders > 3;


-- ============================================================
-- VIEW 9: vw_PendingAndActiveOrders
-- All orders that are not yet completed or cancelled,
-- with customer and payment info.
-- Reporting use: Live operations / kitchen display
-- ============================================================
IF OBJECT_ID('dbo.vw_PendingAndActiveOrders', 'V') IS NOT NULL
    DROP VIEW dbo.vw_PendingAndActiveOrders;
GO

CREATE VIEW vw_PendingAndActiveOrders AS
SELECT
    O.OrderID,
    O.OrderDate,
    O.Status                            AS OrderStatus,
    O.TotalPrice,
    U.FirstName + ' ' + U.LastName      AS CustomerName,
    U.Email                             AS CustomerEmail,
    P.Method                            AS PaymentMethod,
    P.PaymentStatus,
    D.DeliveryStatus
FROM ORDERS O
INNER JOIN [USER]  U ON O.UserID  = U.UserID
INNER JOIN PAYMENT P ON O.OrderID = P.OrderID
LEFT  JOIN DELIVERY D ON O.OrderID = D.OrderID
WHERE O.Status NOT IN ('delivered', 'cancelled');
GO

-- Sample usage:
-- SELECT * FROM vw_PendingAndActiveOrders ORDER BY OrderDate;
-- SELECT * FROM vw_PendingAndActiveOrders WHERE OrderStatus = 'preparing';
-- SELECT COUNT(*) AS ActiveOrders FROM vw_PendingAndActiveOrders;


-- ============================================================
-- VIEW 10: vw_TopMenuItems
-- Most ordered menu items with total quantity sold
-- and total revenue generated.
-- Reporting use: Menu performance / bestsellers report
-- ============================================================
IF OBJECT_ID('dbo.vw_TopMenuItems', 'V') IS NOT NULL
    DROP VIEW dbo.vw_TopMenuItems;
GO

CREATE VIEW vw_TopMenuItems AS
SELECT
    M.ItemID,
    M.Name                              AS MenuItemName,
    M.Price                             AS ListPrice,
    R.Name                              AS RestaurantName,
    COUNT(OI.OrderItemID)               AS TimesOrdered,
    SUM(OI.Quantity)                    AS TotalQuantitySold,
    SUM(OI.Quantity * OI.UnitPrice)     AS TotalRevenue,
    AVG(OI.UnitPrice)                   AS AverageSoldPrice
FROM MENUITEM M
INNER JOIN RESTAURANT R  ON M.RestaurantID = R.RestaurantID
INNER JOIN ORDERITEM  OI ON M.ItemID       = OI.ItemID
INNER JOIN ORDERS     O  ON OI.OrderID     = O.OrderID
WHERE O.Status != 'cancelled'
GROUP BY
    M.ItemID,
    M.Name,
    M.Price,
    R.Name;
GO

-- Sample usage:
-- SELECT * FROM vw_TopMenuItems ORDER BY TotalQuantitySold DESC;
-- SELECT TOP 5 * FROM vw_TopMenuItems ORDER BY TotalRevenue DESC;
-- SELECT * FROM vw_TopMenuItems WHERE RestaurantName = 'Sushi Sensation';