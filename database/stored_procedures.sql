-- ============================================================
-- Food Delivery Database - STORED PROCEDURES (T-SQL / SQL Server)
-- FIXED VERSION: Added semicolons to satisfy IntelliSense scanner.
-- ============================================================

USE FoodDeliveryDB;
GO

-- ============================================================
-- STORED PROCEDURE 1: usp_RegisterUser
-- ============================================================
IF OBJECT_ID('dbo.usp_RegisterUser', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_RegisterUser;
GO

CREATE PROCEDURE usp_RegisterUser
    @FirstName    NVARCHAR(100),
    @LastName     NVARCHAR(100),
    @Email        NVARCHAR(255),
    @PasswordHash NVARCHAR(255),
    @UserName     NVARCHAR(100),
    @UserType     NVARCHAR(20)  = 'customer',
    @Phone        NVARCHAR(20),
    @City         NVARCHAR(100) = NULL,
    @StreetName   NVARCHAR(150) = NULL,
    @StreetNumber NVARCHAR(20)  = NULL,
    @Apartment    NVARCHAR(50)  = NULL,
    @PostalCode   NVARCHAR(20)  = NULL,
    @NewUserID    INT           = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM [USER] WHERE Email = @Email)
    BEGIN
        ;THROW 52001, 'A user with this email already exists.', 1;
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM [USER] WHERE UserName = @UserName)
    BEGIN
        ;THROW 52002, 'This username is already taken.', 1;
        RETURN;
    END

    BEGIN TRANSACTION;
    BEGIN TRY
        INSERT INTO [USER] (FirstName, LastName, Email, PasswordHash, UserName, UserType)
        VALUES (@FirstName, @LastName, @Email, @PasswordHash, @UserName, @UserType);

        SET @NewUserID = SCOPE_IDENTITY();

        INSERT INTO USER_PHONE (Phone, UserID)
        VALUES (@Phone, @NewUserID);

        IF @City IS NOT NULL AND @StreetName IS NOT NULL AND @StreetNumber IS NOT NULL
        BEGIN
            INSERT INTO ADDRESS (City, StreetName, StreetNumber, Apartment, PostalCode, IsDefault, UserID)
            VALUES (@City, @StreetName, @StreetNumber, @Apartment, @PostalCode, 1, @NewUserID);
        END

        COMMIT TRANSACTION;

        SELECT
            @NewUserID          AS NewUserID,
            @FirstName + ' ' + @LastName AS FullName,
            @Email              AS Email,
            @UserName           AS UserName,
            'Registration successful' AS Message;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        ;THROW;
    END CATCH
END;
GO

-- ============================================================
-- STORED PROCEDURE 2: usp_PlaceOrder
-- ============================================================
IF OBJECT_ID('dbo.usp_PlaceOrder', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_PlaceOrder;
GO

CREATE PROCEDURE usp_PlaceOrder
    @UserID       INT,
    @ItemsJSON    NVARCHAR(MAX),
    @NewOrderID   INT = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM [USER] WHERE UserID = @UserID AND UserType = 'customer')
    BEGIN
        ;THROW 52003, 'UserID does not exist or is not a customer.', 1;
        RETURN;
    END

    DECLARE @Items TABLE (ItemID INT, Quantity INT);

    INSERT INTO @Items (ItemID, Quantity)
    SELECT ItemID, Quantity
    FROM OPENJSON(@ItemsJSON)
    WITH (
        ItemID   INT 'strict $.ItemID',
        Quantity INT 'strict $.Quantity'
    );

    IF EXISTS (
        SELECT 1 FROM @Items I
        LEFT JOIN MENUITEM M ON I.ItemID = M.ItemID
        WHERE M.ItemID IS NULL OR M.IsAvailable = 0
    )
    BEGIN
        ;THROW 52004, 'One or more menu items are unavailable or do not exist.', 1;
        RETURN;
    END

    BEGIN TRANSACTION;
    BEGIN TRY
        INSERT INTO ORDERS (UserID, Status, TotalPrice)
        VALUES (@UserID, 'pending', 0);

        SET @NewOrderID = SCOPE_IDENTITY();

        INSERT INTO ORDERITEM (OrderID, ItemID, Quantity, UnitPrice)
        SELECT @NewOrderID, I.ItemID, I.Quantity, M.Price
        FROM @Items I
        INNER JOIN MENUITEM M ON I.ItemID = M.ItemID;

        COMMIT TRANSACTION;

        SELECT O.OrderID, O.Status, O.TotalPrice, O.OrderDate, COUNT(OI.OrderItemID) AS TotalItems
        FROM ORDERS O
        INNER JOIN ORDERITEM OI ON O.OrderID = OI.OrderID
        WHERE O.OrderID = @NewOrderID
        GROUP BY O.OrderID, O.Status, O.TotalPrice, O.OrderDate;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        ;THROW;
    END CATCH
END;
GO

-- ============================================================
-- STORED PROCEDURE 3: usp_ProcessPayment
-- ============================================================
IF OBJECT_ID('dbo.usp_ProcessPayment', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_ProcessPayment;
GO

CREATE PROCEDURE usp_ProcessPayment
    @OrderID        INT,
    @Method         NVARCHAR(20),
    @NewPaymentID   INT = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM ORDERS WHERE OrderID = @OrderID)
    BEGIN
        ;THROW 52005, 'Order does not exist.', 1;
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM ORDERS WHERE OrderID = @OrderID AND Status = 'cancelled')
    BEGIN
        ;THROW 52006, 'Cannot process payment for a cancelled order.', 1;
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM PAYMENT WHERE OrderID = @OrderID)
    BEGIN
        ;THROW 52007, 'A payment already exists for this order.', 1;
        RETURN;
    END

    BEGIN TRANSACTION;
    BEGIN TRY
        DECLARE @Amount DECIMAL(10,2);
        SELECT @Amount = TotalPrice FROM ORDERS WHERE OrderID = @OrderID;

        INSERT INTO PAYMENT (OrderID, Amount, Method, PaymentStatus)
        VALUES (@OrderID, @Amount, @Method, 'completed');

        SET @NewPaymentID = SCOPE_IDENTITY();

        UPDATE ORDERS SET Status = 'confirmed'
        WHERE OrderID = @OrderID AND Status = 'pending';

        COMMIT TRANSACTION;

        SELECT @NewPaymentID AS PaymentID, @OrderID AS OrderID, @Amount AS Amount, 'completed' AS PaymentStatus;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        ;THROW;
    END CATCH
END;
GO

-- ============================================================
-- STORED PROCEDURE 4: usp_AssignDelivery
-- ============================================================
IF OBJECT_ID('dbo.usp_AssignDelivery', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_AssignDelivery;
GO

CREATE PROCEDURE usp_AssignDelivery
    @OrderID        INT,
    @DriverUserID   INT,
    @AddressID      INT,
    @NewDeliveryID  INT = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM [USER] WHERE UserID = @DriverUserID AND UserType = 'driver')
    BEGIN
        ;THROW 52008, 'The specified UserID is not a registered driver.', 1;
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM ORDERS WHERE OrderID = @OrderID AND Status IN ('confirmed','preparing'))
    BEGIN
        ;THROW 52009, 'Order must be confirmed or preparing before a delivery can be assigned.', 1;
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM DELIVERY WHERE OrderID = @OrderID)
    BEGIN
        ;THROW 52010, 'A delivery has already been assigned for this order.', 1;
        RETURN;
    END

    BEGIN TRANSACTION;
    BEGIN TRY
        INSERT INTO DELIVERY (OrderID, UserID, AddressID, DeliveryStatus)
        VALUES (@OrderID, @DriverUserID, @AddressID, 'assigned');

        SET @NewDeliveryID = SCOPE_IDENTITY();
        COMMIT TRANSACTION;

        SELECT @NewDeliveryID AS DeliveryID, 'assigned' AS DeliveryStatus;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        ;THROW;
    END CATCH
END;
GO

-- ============================================================
-- STORED PROCEDURE 5: usp_UpdateDeliveryStatus
-- ============================================================
IF OBJECT_ID('dbo.usp_UpdateDeliveryStatus', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_UpdateDeliveryStatus;
GO

CREATE PROCEDURE usp_UpdateDeliveryStatus
    @DeliveryID     INT,
    @NewStatus      NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM DELIVERY WHERE DeliveryID = @DeliveryID)
    BEGIN
        ;THROW 52012, 'DeliveryID does not exist.', 1;
        RETURN;
    END

    IF @NewStatus NOT IN ('assigned','picked_up','in_transit','delivered','failed')
    BEGIN
        ;THROW 52013, 'Invalid delivery status.', 1;
        RETURN;
    END

    BEGIN TRANSACTION;
    BEGIN TRY
        UPDATE DELIVERY
        SET DeliveryStatus = @NewStatus,
            PickupTime  = CASE WHEN @NewStatus = 'picked_up' THEN GETDATE() ELSE PickupTime END,
            DeliveryTime = CASE WHEN @NewStatus = 'delivered' THEN GETDATE() ELSE DeliveryTime END
        WHERE DeliveryID = @DeliveryID;

        COMMIT TRANSACTION;
        SELECT DeliveryID, DeliveryStatus FROM DELIVERY WHERE DeliveryID = @DeliveryID;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        ;THROW;
    END CATCH
END;
GO

-- ============================================================
-- STORED PROCEDURE 6: usp_SubmitFeedback
-- ============================================================
IF OBJECT_ID('dbo.usp_SubmitFeedback', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_SubmitFeedback;
GO

CREATE PROCEDURE usp_SubmitFeedback
    @UserID          INT,
    @OrderID         INT,
    @RestaurantID    INT,
    @Rating          TINYINT,
    @Comment         NVARCHAR(MAX) = NULL,
    @NewFeedbackID   INT = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM ORDERS WHERE OrderID = @OrderID AND UserID = @UserID)
    BEGIN
        ;THROW 52015, 'This order does not belong to the specified user.', 1;
        RETURN;
    END

    IF @Rating < 1 OR @Rating > 5
    BEGIN
        ;THROW 52017, 'Rating must be between 1 and 5.', 1;
        RETURN;
    END

    BEGIN TRANSACTION;
    BEGIN TRY
        INSERT INTO FEEDBACK (UserID, OrderID, RestaurantID, Rating, Comment)
        VALUES (@UserID, @OrderID, @RestaurantID, @Rating, @Comment);

        SET @NewFeedbackID = SCOPE_IDENTITY();
        COMMIT TRANSACTION;
        SELECT @NewFeedbackID AS FeedbackID, 'Feedback submitted successfully' AS Message;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        ;THROW;
    END CATCH
END;
GO

-- ============================================================
-- STORED PROCEDURE 7: usp_GetOrderDetails
-- ============================================================
IF OBJECT_ID('dbo.usp_GetOrderDetails', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_GetOrderDetails;
GO

CREATE PROCEDURE usp_GetOrderDetails
    @OrderID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM ORDERS WHERE OrderID = @OrderID)
    BEGIN
        ;THROW 52019, 'Order does not exist.', 1;
        RETURN;
    END

    SELECT O.OrderID, O.OrderDate, O.Status, O.TotalPrice, U.FirstName + ' ' + U.LastName AS CustomerName
    FROM ORDERS O INNER JOIN [USER] U ON O.UserID = U.UserID WHERE O.OrderID = @OrderID;

    SELECT OI.OrderItemID, M.Name AS MenuItemName, OI.Quantity, OI.UnitPrice
    FROM ORDERITEM OI INNER JOIN MENUITEM M ON OI.ItemID = M.ItemID WHERE OI.OrderID = @OrderID;
END;
GO

-- ============================================================
-- STORED PROCEDURE 8: usp_GetRestaurantReport
-- ============================================================
IF OBJECT_ID('dbo.usp_GetRestaurantReport', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_GetRestaurantReport;
GO

CREATE PROCEDURE usp_GetRestaurantReport
    @RestaurantID   INT,
    @FromDate       DATE = NULL,
    @ToDate         DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM RESTAURANT WHERE RestaurantID = @RestaurantID)
    BEGIN
        ;THROW 52020, 'Restaurant does not exist.', 1;
        RETURN;
    END

    SET @FromDate = ISNULL(@FromDate, '2000-01-01');
    SET @ToDate   = ISNULL(@ToDate, CAST(GETDATE() AS DATE));

    SELECT R.RestaurantID, R.Name, R.Rating, COUNT(DISTINCT O.OrderID) AS TotalOrders
    FROM RESTAURANT R
    LEFT JOIN MENUITEM M ON R.RestaurantID = M.RestaurantID
    LEFT JOIN ORDERITEM OI ON M.ItemID = OI.ItemID
    LEFT JOIN ORDERS O ON OI.OrderID = O.OrderID AND CAST(O.OrderDate AS DATE) BETWEEN @FromDate AND @ToDate
    WHERE R.RestaurantID = @RestaurantID
    GROUP BY R.RestaurantID, R.Name, R.Rating;
END;
GO

-- ============================================================
-- STORED PROCEDURE 9: usp_SearchMenuItems
-- ============================================================
IF OBJECT_ID('dbo.usp_SearchMenuItems', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_SearchMenuItems;
GO

CREATE PROCEDURE usp_SearchMenuItems
    @Keyword        NVARCHAR(100) = NULL,
    @CuisineType    NVARCHAR(100) = NULL,
    @MaxPrice       DECIMAL(10,2) = NULL,
    @City           NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT DISTINCT M.ItemID, M.Name, M.Price, R.Name AS RestaurantName, R.City
    FROM MENUITEM M
    INNER JOIN RESTAURANT R ON M.RestaurantID = R.RestaurantID
    LEFT JOIN RESTAURANT_CUISINETYPE RC ON R.RestaurantID = RC.RestaurantID
    WHERE M.IsAvailable = 1 AND R.IsActive = 1
      AND (@Keyword IS NULL OR M.Name LIKE '%' + @Keyword + '%')
      AND (@CuisineType IS NULL OR RC.CuisineType = @CuisineType)
      AND (@MaxPrice IS NULL OR M.Price <= @MaxPrice)
      AND (@City IS NULL OR R.City = @City);
END;
GO

-- ============================================================
-- STORED PROCEDURE 10: usp_CancelOrder
-- ============================================================
IF OBJECT_ID('dbo.usp_CancelOrder', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_CancelOrder;
GO

CREATE PROCEDURE usp_CancelOrder
    @OrderID    INT,
    @UserID     INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM ORDERS WHERE OrderID = @OrderID AND UserID = @UserID)
    BEGIN
        ;THROW 52021, 'Order not found or does not belong to this user.', 1;
        RETURN;
    END

    BEGIN TRANSACTION;
    BEGIN TRY
        UPDATE ORDERS SET Status = 'cancelled' WHERE OrderID = @OrderID;
        UPDATE PAYMENT SET PaymentStatus = 'refunded' WHERE OrderID = @OrderID AND PaymentStatus = 'completed';
        COMMIT TRANSACTION;
        SELECT @OrderID AS OrderID, 'cancelled' AS NewOrderStatus;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        ;THROW;
    END CATCH
END;
GO

-- ============================================================
-- VERIFY
-- ============================================================
SELECT name, create_date FROM sys.procedures WHERE name LIKE 'usp_%';
GO