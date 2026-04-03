-- ============================================================
-- Food Delivery Database - DQL Queries (T-SQL / SQL Server)
-- ============================================================

USE FoodDeliveryDB;
GO

-- ============================================================
-- USERS & ORDERS
-- ============================================================

-- 1. Get all users who have placed at least one order
--    π UserID (ORDERS)
-- ============================================================
SELECT DISTINCT
    U.UserID,
    U.FirstName,
    U.LastName,
    U.Email
FROM [USER] U
INNER JOIN ORDERS O ON U.UserID = O.UserID;
GO

-- 2. Get all orders with status 'delivered'
--    σ Status = 'delivered' (ORDERS)
-- ============================================================
SELECT
    OrderID,
    UserID,
    Status,
    TotalPrice,
    OrderDate
FROM ORDERS
WHERE Status = 'delivered';
GO

-- 3. Get the OrderID and TotalPrice of orders placed by UserID = 5
--    π OrderID, TotalPrice (σ UserID = 5 (ORDERS))
-- ============================================================
SELECT
    OrderID,
    TotalPrice
FROM ORDERS
WHERE UserID = 5;
GO

-- 4. Get all users who have NEVER placed an order
--    π UserID (USER) − π UserID (ORDERS)
-- ============================================================
SELECT
    U.UserID,
    U.FirstName,
    U.LastName,
    U.Email,
    U.UserType
FROM [USER] U
WHERE U.UserID NOT IN (
    SELECT DISTINCT UserID FROM ORDERS
);
GO

-- 5. Get full details of orders along with the user who placed them
--    USER ⨝ USER.UserID = ORDERS.UserID ORDERS
-- ============================================================
SELECT
    U.UserID,
    U.FirstName,
    U.LastName,
    U.Email,
    O.OrderID,
    O.Status,
    O.TotalPrice,
    O.OrderDate
FROM [USER] U
INNER JOIN ORDERS O ON U.UserID = O.UserID
ORDER BY O.OrderDate DESC;
GO

-- 6. Get all order items belonging to OrderID = 10
--    σ OrderID = 10 (ORDERITEM)
-- ============================================================
SELECT
    OrderItemID,
    OrderID,
    ItemID,
    Quantity,
    UnitPrice,
    (Quantity * UnitPrice) AS LineTotal
FROM ORDERITEM
WHERE OrderID = 10;
GO

-- 7. Get the Quantity and UnitPrice of all order items for ItemID = 3
--    π Quantity, UnitPrice (σ ItemID = 3 (ORDERITEM))
-- ============================================================
SELECT
    Quantity,
    UnitPrice
FROM ORDERITEM
WHERE ItemID = 3;
GO

-- ============================================================
-- RESTAURANT & MENU ITEMS
-- ============================================================

-- 8. Get all menu items offered by RestaurantID = 2
--    π ItemID, Name, Price (σ RestaurantID = 2 (MENUITEM))
-- ============================================================
SELECT
    ItemID,
    Name,
    Price,
    Description,
    IsAvailable
FROM MENUITEM
WHERE RestaurantID = 2;
GO

-- 9. Get all available menu items
--    σ IsAvailable = true (MENUITEM)
-- ============================================================
SELECT
    ItemID,
    RestaurantID,
    Name,
    Price,
    Description
FROM MENUITEM
WHERE IsAvailable = 1;
GO

-- 10. Get the names and ratings of all active restaurants
--     π Name, Rating (σ IsActive = true (RESTAURANT))
-- ============================================================
SELECT
    Name,
    Rating,
    City
FROM RESTAURANT
WHERE IsActive = 1
ORDER BY Rating DESC;
GO

-- 11. Get all menu items with their restaurant name
--     MENUITEM ⨝ MENUITEM.RestaurantID = RESTAURANT.RestaurantID RESTAURANT
-- ============================================================
SELECT
    M.ItemID,
    M.Name          AS MenuItemName,
    M.Price,
    M.IsAvailable,
    R.Name          AS RestaurantName,
    R.City
FROM MENUITEM M
INNER JOIN RESTAURANT R ON M.RestaurantID = R.RestaurantID
ORDER BY R.Name, M.Name;
GO

-- 12. Get all restaurants that offer cuisine type 'Italian'
--     RESTAURANT ⨝ σ CuisineType='Italian' (RESTAURANT_CUISINETYPE)
-- ============================================================
SELECT DISTINCT
    R.RestaurantID,
    R.Name,
    R.City,
    R.Rating
FROM RESTAURANT R
INNER JOIN RESTAURANT_CUISINETYPE RC ON R.RestaurantID = RC.RestaurantID
WHERE RC.CuisineType = 'Italian';
GO

-- 13. Get all menu items that are available AND belong to an active restaurant
--     σ IsAvailable=true (MENUITEM) ⨝ σ IsActive=true (RESTAURANT)
-- ============================================================
SELECT
    M.ItemID,
    M.Name    AS MenuItemName,
    M.Price,
    R.Name    AS RestaurantName,
    R.City
FROM MENUITEM M
INNER JOIN RESTAURANT R ON M.RestaurantID = R.RestaurantID
WHERE M.IsAvailable = 1
  AND R.IsActive    = 1
ORDER BY R.Name, M.Price;
GO

-- ============================================================
-- DELIVERIES & PAYMENTS
-- ============================================================

-- 14. Get all deliveries with status 'in_transit'
--     σ DeliveryStatus = 'in_transit' (DELIVERY)
-- ============================================================
SELECT
    DeliveryID,
    OrderID,
    UserID      AS DriverUserID,
    AddressID,
    PickupTime,
    DeliveryStatus
FROM DELIVERY
WHERE DeliveryStatus = 'in_transit';
GO

-- 15. Get all deliveries along with the order they fulfill
--     DELIVERY ⨝ DELIVERY.OrderID = ORDERS.OrderID ORDERS
-- ============================================================
SELECT
    D.DeliveryID,
    D.DeliveryStatus,
    D.PickupTime,
    D.DeliveryTime,
    O.OrderID,
    O.Status      AS OrderStatus,
    O.TotalPrice,
    O.OrderDate
FROM DELIVERY D
INNER JOIN ORDERS O ON D.OrderID = O.OrderID
ORDER BY O.OrderDate DESC;
GO

-- 16. Get all deliveries assigned to a specific rider (UserID = 7)
--     σ UserID = 7 (DELIVERY)
-- ============================================================
SELECT
    DeliveryID,
    OrderID,
    AddressID,
    PickupTime,
    DeliveryTime,
    DeliveryStatus
FROM DELIVERY
WHERE UserID = 7;
GO

-- 17. Get all payments made by method 'cash'
--     σ Method = 'cash' (PAYMENT)
-- ============================================================
SELECT
    PaymentID,
    OrderID,
    Amount,
    Method,
    PaymentTime,
    PaymentStatus
FROM PAYMENT
WHERE Method = 'cash';
GO

-- 18. Get all orders that have been PAID and DELIVERED
--     π OrderID (σ PaymentStatus='completed' (PAYMENT))
--     ⨝ PAYMENT.OrderID = DELIVERY.OrderID
--     (σ DeliveryStatus='delivered' (DELIVERY))
-- ============================================================
SELECT
    P.OrderID,
    P.Amount,
    P.Method,
    P.PaymentStatus,
    D.DeliveryStatus,
    D.DeliveryTime
FROM PAYMENT P
INNER JOIN DELIVERY D ON P.OrderID = D.OrderID
WHERE P.PaymentStatus  = 'completed'
  AND D.DeliveryStatus = 'delivered';
GO

-- 19. Get all orders that have a payment but NO delivery yet
--     π OrderID (PAYMENT) − π OrderID (DELIVERY)
-- ============================================================
SELECT
    P.OrderID,
    P.Amount,
    P.PaymentStatus,
    O.Status AS OrderStatus
FROM PAYMENT P
INNER JOIN ORDERS O ON P.OrderID = O.OrderID
WHERE P.OrderID NOT IN (
    SELECT DISTINCT OrderID FROM DELIVERY
);
GO

-- 20. Get full delivery details including the delivery address
--     DELIVERY ⨝ DELIVERY.AddressID = ADDRESS.AddressID ADDRESS
-- ============================================================
SELECT
    D.DeliveryID,
    D.OrderID,
    D.DeliveryStatus,
    D.PickupTime,
    D.DeliveryTime,
    A.City,
    A.StreetName,
    A.StreetNumber,
    A.Apartment,
    A.PostalCode
FROM DELIVERY D
INNER JOIN ADDRESS A ON D.AddressID = A.AddressID
ORDER BY D.DeliveryTime DESC;
GO

-- ============================================================
-- FEEDBACK & RATINGS
-- ============================================================

-- 21. Get all feedback for RestaurantID = 3
--     σ RestaurantID = 3 (FEEDBACK)
-- ============================================================
SELECT
    FeedbackID,
    UserID,
    OrderID,
    Rating,
    Comment,
    FeedbackDate
FROM FEEDBACK
WHERE RestaurantID = 3
ORDER BY FeedbackDate DESC;
GO

-- 22. Get all feedback with a rating above 4
--     σ Rating > 4 (FEEDBACK)
-- ============================================================
SELECT
    FeedbackID,
    UserID,
    RestaurantID,
    OrderID,
    Rating,
    Comment
FROM FEEDBACK
WHERE Rating > 4
ORDER BY Rating DESC;
GO

-- 23. Get all users who have given feedback
--     USER ⨝ USER.UserID = FEEDBACK.UserID FEEDBACK
-- ============================================================
SELECT DISTINCT
    U.UserID,
    U.FirstName,
    U.LastName,
    U.Email
FROM [USER] U
INNER JOIN FEEDBACK F ON U.UserID = F.UserID
ORDER BY U.LastName;
GO

-- 24. Get all users who have placed an order OR given feedback
--     π UserID (ORDERS) ∪ π UserID (FEEDBACK)
-- ============================================================
SELECT DISTINCT UserID FROM ORDERS
UNION
SELECT DISTINCT UserID FROM FEEDBACK;
GO

-- 25. Get all users who have placed an order AND given feedback
--     π UserID (ORDERS) ∩ π UserID (FEEDBACK)
-- ============================================================
SELECT DISTINCT UserID FROM ORDERS
INTERSECT
SELECT DISTINCT UserID FROM FEEDBACK;
GO

-- 26. Get feedback along with the order and restaurant it refers to
--     FEEDBACK ⨝ ORDERS ⨝ RESTAURANT
-- ============================================================
SELECT
    F.FeedbackID,
    F.Rating,
    F.Comment,
    F.FeedbackDate,
    O.OrderID,
    O.TotalPrice,
    O.OrderDate,
    R.Name   AS RestaurantName,
    R.City   AS RestaurantCity
FROM FEEDBACK F
INNER JOIN ORDERS     O ON F.OrderID      = O.OrderID
INNER JOIN RESTAURANT R ON F.RestaurantID = R.RestaurantID
ORDER BY F.FeedbackDate DESC;
GO

-- 27. Get all restaurants that have received feedback with rating below 3
--     RESTAURANT ⨝ σ Rating < 3 (FEEDBACK)
-- ============================================================
SELECT DISTINCT
    R.RestaurantID,
    R.Name,
    R.City,
    R.Rating AS OverallRating
FROM RESTAURANT R
INNER JOIN FEEDBACK F ON R.RestaurantID = F.RestaurantID
WHERE F.Rating < 3
ORDER BY R.Name;
GO