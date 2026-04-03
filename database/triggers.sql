-- ============================================================
-- Food Delivery Database - TRIGGERS (T-SQL / SQL Server)
-- Run this in SQL Server Management Studio (SSMS)
-- ============================================================

USE FoodDeliveryDB;
GO

-- ============================================================
-- TRIGGER 1: trg_Orders_UpdateTotalPrice
-- BUSINESS RULE: Whenever an order item is inserted, updated,
-- or deleted, automatically recalculate and sync the
-- TotalPrice in the ORDERS table.
-- This ensures ORDERS.TotalPrice is never out of sync
-- with the actual ORDERITEM rows.
-- ============================================================
IF OBJECT_ID('dbo.trg_OrderItem_SyncTotalPrice', 'TR') IS NOT NULL
    DROP TRIGGER dbo.trg_OrderItem_SyncTotalPrice;
GO

CREATE TRIGGER trg_OrderItem_SyncTotalPrice
ON ORDERITEM
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Collect all affected OrderIDs from both inserted and deleted
    -- (deleted handles UPDATE old rows and DELETE operations)
    DECLARE @AffectedOrders TABLE (OrderID INT);

    INSERT INTO @AffectedOrders (OrderID)
    SELECT DISTINCT OrderID FROM inserted
    UNION
    SELECT DISTINCT OrderID FROM deleted;

    -- Recalculate TotalPrice for every affected order
    UPDATE O
    SET O.TotalPrice = ISNULL((
        SELECT SUM(OI.Quantity * OI.UnitPrice)
        FROM ORDERITEM OI
        WHERE OI.OrderID = O.OrderID
    ), 0)
    FROM ORDERS O
    INNER JOIN @AffectedOrders A ON O.OrderID = A.OrderID;
END;
GO

-- ✅ TEST TRIGGER 1:
-- Step 1 — check current TotalPrice for OrderID = 1
-- SELECT OrderID, TotalPrice FROM ORDERS WHERE OrderID = 1;
--
-- Step 2 — insert a new item into that order
-- INSERT INTO ORDERITEM (OrderID, ItemID, Quantity, UnitPrice)
-- VALUES (1, 5, 2, 4.99);
--
-- Step 3 — TotalPrice should have increased automatically
-- SELECT OrderID, TotalPrice FROM ORDERS WHERE OrderID = 1;


-- ============================================================
-- TRIGGER 2: trg_Feedback_ValidateDeliveredOrder
-- BUSINESS RULE: A user can only leave feedback for an order
-- that has status 'delivered'. Feedback on pending, preparing,
-- or cancelled orders must be blocked.
-- ============================================================
IF OBJECT_ID('dbo.trg_Feedback_ValidateDeliveredOrder', 'TR') IS NOT NULL
    DROP TRIGGER dbo.trg_Feedback_ValidateDeliveredOrder;
GO

CREATE TRIGGER trg_Feedback_ValidateDeliveredOrder
ON FEEDBACK
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if any inserted feedback references a non-delivered order
    IF EXISTS (
        SELECT 1
        FROM inserted I
        INNER JOIN ORDERS O ON I.OrderID = O.OrderID
        WHERE O.Status != 'delivered'
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 51001,
            'Feedback can only be submitted for orders with status ''delivered''.',
            1;
    END
END;
GO

-- ✅ TEST TRIGGER 2:
-- This should FAIL (order 36 has status 'preparing'):
-- INSERT INTO FEEDBACK (UserID, OrderID, RestaurantID, Rating, Comment)
-- VALUES (11, 36, 1, 4, 'Great food!');
--
-- This should SUCCEED (order 1 is 'delivered'):
-- INSERT INTO FEEDBACK (UserID, OrderID, RestaurantID, Rating, Comment)
-- VALUES (11, 1, 1, 5, 'Loved it!');


-- ============================================================
-- TRIGGER 3: trg_Order_BlockEditIfDelivered
-- BUSINESS RULE: Once an order has been delivered, its
-- Status and TotalPrice must not be changed. Any attempt
-- to modify a delivered order is blocked.
-- ============================================================
IF OBJECT_ID('dbo.trg_Order_BlockEditIfDelivered', 'TR') IS NOT NULL
    DROP TRIGGER dbo.trg_Order_BlockEditIfDelivered;
GO

CREATE TRIGGER trg_Order_BlockEditIfDelivered
ON ORDERS
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Block changes to Status or TotalPrice on already-delivered orders
    IF EXISTS (
        SELECT 1
        FROM deleted D
        WHERE D.Status = 'delivered'
          AND EXISTS (
              SELECT 1 FROM inserted I
              WHERE I.OrderID = D.OrderID
                AND (I.Status != D.Status OR I.TotalPrice != D.TotalPrice)
          )
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 51002,
            'Cannot modify Status or TotalPrice of an order that has already been delivered.',
            1;
    END
END;
GO

-- ✅ TEST TRIGGER 3:
-- This should FAIL (OrderID 1 is already delivered):
-- UPDATE ORDERS SET Status = 'cancelled' WHERE OrderID = 1;
--
-- This should SUCCEED (OrderID 36 is 'preparing', not delivered):
-- UPDATE ORDERS SET Status = 'confirmed' WHERE OrderID = 36;


-- ============================================================
-- TRIGGER 4: trg_Delivery_AutoSetOrderStatus
-- BUSINESS RULE: When a delivery status changes, automatically
-- keep the parent order status in sync:
--   delivered   → order becomes 'delivered'
--   in_transit  → order becomes 'out_for_delivery'
--   picked_up   → order becomes 'preparing'
--   failed      → order becomes 'confirmed'
-- ============================================================
IF OBJECT_ID('dbo.trg_Delivery_AutoSetOrderStatus', 'TR') IS NOT NULL
    DROP TRIGGER dbo.trg_Delivery_AutoSetOrderStatus;
GO

CREATE TRIGGER trg_Delivery_AutoSetOrderStatus
ON DELIVERY
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Only fire when DeliveryStatus actually changed
    IF NOT UPDATE(DeliveryStatus) RETURN;

    UPDATE O
    SET O.Status = CASE I.DeliveryStatus
                        WHEN 'delivered'  THEN 'delivered'
                        WHEN 'in_transit' THEN 'out_for_delivery'
                        WHEN 'picked_up'  THEN 'preparing'
                        WHEN 'failed'     THEN 'confirmed'
                        ELSE O.Status
                   END
    FROM ORDERS O
    INNER JOIN inserted I ON O.OrderID = I.OrderID;
END;
GO

-- ✅ TEST TRIGGER 4:
-- Step 1 — check current order status
-- SELECT OrderID, Status FROM ORDERS WHERE OrderID = 39;
--
-- Step 2 — update the delivery to 'delivered'
-- UPDATE DELIVERY SET DeliveryStatus = 'delivered'
-- WHERE OrderID = 39;
--
-- Step 3 — order status should now be 'delivered' automatically
-- SELECT OrderID, Status FROM ORDERS WHERE OrderID = 39;


-- ============================================================
-- TRIGGER 5: trg_Payment_BlockDuplicatePayment
-- BUSINESS RULE: An order can only have one payment record.
-- If someone tries to insert a second payment for the same
-- OrderID, the insert is blocked with a clear error.
-- (Supplements the UNIQUE constraint with a friendly message)
-- ============================================================
IF OBJECT_ID('dbo.trg_Payment_BlockDuplicatePayment', 'TR') IS NOT NULL
    DROP TRIGGER dbo.trg_Payment_BlockDuplicatePayment;
GO

CREATE TRIGGER trg_Payment_BlockDuplicatePayment
ON PAYMENT
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted I
        INNER JOIN PAYMENT P ON I.OrderID = P.OrderID
        WHERE P.PaymentID != I.PaymentID  -- exclude the row just inserted
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 51003,
            'A payment record already exists for this order. Each order can only have one payment.',
            1;
    END
END;
GO

-- ✅ TEST TRIGGER 5:
-- This should FAIL (OrderID 1 already has a payment):
-- INSERT INTO PAYMENT (OrderID, Amount, Method, PaymentStatus)
-- VALUES (1, 24.97, 'cash', 'pending');
--
-- This should SUCCEED (OrderID 38 has no second payment yet):
-- (already has one, so this will also fail — which is correct)


-- ============================================================
-- TRIGGER 6: trg_User_PreventDeleteWithOrders
-- BUSINESS RULE: A customer account cannot be deleted if
-- they have any order history. Protects referential and
-- business data integrity beyond what the FK alone enforces.
-- ============================================================
IF OBJECT_ID('dbo.trg_User_PreventDeleteWithOrders', 'TR') IS NOT NULL
    DROP TRIGGER dbo.trg_User_PreventDeleteWithOrders;
GO

CREATE TRIGGER trg_User_PreventDeleteWithOrders
ON [USER]
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Block delete if the user has any order history
    IF EXISTS (
        SELECT 1
        FROM deleted D
        INNER JOIN ORDERS O ON D.UserID = O.UserID
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 51004,
            'Cannot delete a user who has existing order history. Deactivate the account instead.',
            1;
    END

    -- Safe to delete — no orders found
    DELETE FROM [USER]
    WHERE UserID IN (SELECT UserID FROM deleted);
END;
GO

-- ✅ TEST TRIGGER 6:
-- This should FAIL (UserID 1 has placed orders):
-- DELETE FROM [USER] WHERE UserID = 1;
--
-- This should SUCCEED (UserID 43 is an admin with no orders):
-- DELETE FROM [USER] WHERE UserID = 43;


-- ============================================================
-- TRIGGER 7: trg_Restaurant_UpdateRatingOnFeedback
-- BUSINESS RULE: Whenever feedback is inserted or deleted,
-- automatically recalculate and update the restaurant's
-- overall Rating as the average of all its feedback ratings.
-- ============================================================
IF OBJECT_ID('dbo.trg_Restaurant_UpdateRatingOnFeedback', 'TR') IS NOT NULL
    DROP TRIGGER dbo.trg_Restaurant_UpdateRatingOnFeedback;
GO

CREATE TRIGGER trg_Restaurant_UpdateRatingOnFeedback
ON FEEDBACK
AFTER INSERT, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Collect all affected RestaurantIDs
    DECLARE @AffectedRestaurants TABLE (RestaurantID INT);

    INSERT INTO @AffectedRestaurants (RestaurantID)
    SELECT DISTINCT RestaurantID FROM inserted
    UNION
    SELECT DISTINCT RestaurantID FROM deleted;

    -- Recalculate and update the restaurant rating
    UPDATE R
    SET R.Rating = (
        SELECT ROUND(AVG(CAST(F.Rating AS DECIMAL(4,2))), 2)
        FROM FEEDBACK F
        WHERE F.RestaurantID = R.RestaurantID
    )
    FROM RESTAURANT R
    INNER JOIN @AffectedRestaurants A ON R.RestaurantID = A.RestaurantID;
END;
GO

-- ✅ TEST TRIGGER 7:
-- Step 1 — check current rating for RestaurantID = 1
-- SELECT RestaurantID, Name, Rating FROM RESTAURANT WHERE RestaurantID = 1;
--
-- Step 2 — insert a low rating
-- INSERT INTO FEEDBACK (UserID, OrderID, RestaurantID, Rating, Comment)
-- VALUES (2, 2, 1, 1, 'Very disappointing experience.');
--
-- Step 3 — rating should have dropped automatically
-- SELECT RestaurantID, Name, Rating FROM RESTAURANT WHERE RestaurantID = 1;


-- ============================================================
-- VERIFY ALL TRIGGERS CREATED
-- ============================================================
SELECT
    t.name      AS TableName,
    tr.name     AS TriggerName,
    tr.type_desc,
    CASE WHEN tr.is_instead_of_trigger = 1
         THEN 'INSTEAD OF'
         ELSE 'AFTER'
    END         AS TriggerType,
    tr.is_disabled
FROM sys.triggers tr
INNER JOIN sys.tables t ON tr.parent_id = t.object_id
ORDER BY t.name, tr.name;
GO