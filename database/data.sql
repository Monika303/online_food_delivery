USE FoodDeliveryDB;
GO

-- ============================================================
-- 1. USER (45 records)
-- Note: USER is a reserved word in T-SQL, so we use [USER]
-- Note: SHA2 is replaced with HASHBYTES
-- ============================================================
INSERT INTO [USER] (FirstName, LastName, Email, PasswordHash, UserName, CreatedAt, UserType) VALUES
('Alice',     'Johnson',   'alice.johnson@email.com',    CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'alicej',      '2024-01-05 09:00:00', 'customer'),
('Bob',       'Smith',     'bob.smith@email.com',        CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'bobsmith',    '2024-01-06 10:00:00', 'customer'),
('Carol',     'Williams',  'carol.w@email.com',          CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'carolw',      '2024-01-07 11:00:00', 'customer'),
('David',     'Brown',     'david.b@email.com',          CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'davidb',      '2024-01-08 08:30:00', 'customer'),
('Eva',       'Davis',     'eva.davis@email.com',        CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'evad',        '2024-01-09 14:00:00', 'customer'),
('Frank',     'Miller',    'frank.m@email.com',          CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'frankm',      '2024-01-10 09:15:00', 'customer'),
('Grace',     'Wilson',    'grace.w@email.com',          CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'gracew',      '2024-01-11 10:45:00', 'customer'),
('Henry',     'Moore',     'henry.mo@email.com',         CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'henrym',      '2024-01-12 13:00:00', 'customer'),
('Isla',      'Taylor',    'isla.t@email.com',           CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'islat',       '2024-01-13 15:30:00', 'customer'),
('Jack',      'Anderson',  'jack.a@email.com',           CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'jacka',       '2024-01-14 08:00:00', 'customer'),
('Karen',     'Thomas',    'karen.t@email.com',          CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'karent',      '2024-01-15 11:20:00', 'customer'),
('Liam',      'Jackson',   'liam.j@email.com',           CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'liamj',       '2024-01-16 12:00:00', 'customer'),
('Mia',       'White',     'mia.w@email.com',            CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'miaw',        '2024-01-17 09:30:00', 'customer'),
('Noah',      'Harris',    'noah.h@email.com',           CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'noahh',       '2024-01-18 16:00:00', 'customer'),
('Olivia',    'Martin',    'olivia.m@email.com',         CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'oliviam',     '2024-01-19 10:10:00', 'customer'),
('Paul',      'Garcia',    'paul.g@email.com',           CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'paulg',       '2024-01-20 14:45:00', 'customer'),
('Quinn',     'Martinez',  'quinn.m@email.com',          CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'quinnm',      '2024-01-21 08:50:00', 'customer'),
('Rachel',    'Robinson',  'rachel.r@email.com',         CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'rachelr',     '2024-01-22 13:15:00', 'customer'),
('Sam',       'Clark',     'sam.c@email.com',            CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'samc',        '2024-01-23 11:00:00', 'customer'),
('Tina',      'Rodriguez', 'tina.r@email.com',           CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'tinar',       '2024-01-24 09:45:00', 'customer'),
('Uma',       'Lewis',     'uma.l@email.com',            CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'umal',        '2024-01-25 15:00:00', 'customer'),
('Victor',    'Lee',       'victor.l@email.com',         CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'victorl',     '2024-01-26 10:30:00', 'customer'),
('Wendy',     'Walker',    'wendy.w@email.com',          CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'wendyw',      '2024-01-27 08:15:00', 'customer'),
('Xander',    'Hall',      'xander.h@email.com',         CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'xanderh',     '2024-01-28 12:30:00', 'customer'),
('Yara',      'Allen',     'yara.a@email.com',           CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'yaraa',       '2024-01-29 14:00:00', 'customer'),
('Zoe',       'Young',     'zoe.y@email.com',            CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'zoey',        '2024-01-30 09:00:00', 'customer'),
('Aaron',     'Hernandez', 'aaron.h@email.com',          CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'aaronh',      '2024-02-01 10:00:00', 'customer'),
('Bella',     'King',      'bella.k@email.com',          CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'bellak',      '2024-02-02 11:00:00', 'customer'),
('Carlos',    'Wright',    'carlos.w@email.com',         CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'carlosw',     '2024-02-03 13:00:00', 'customer'),
('Diana',     'Lopez',     'diana.l@email.com',          CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'dianal',      '2024-02-04 15:00:00', 'customer'),
('Ethan',     'Hill',      'ethan.h@email.com',          CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'ethanh',      '2024-02-05 08:00:00', 'driver'),
('Fiona',     'Scott',     'fiona.s@email.com',          CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'fionas',      '2024-02-06 09:00:00', 'driver'),
('George',    'Green',     'george.g@email.com',         CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'georgeg',     '2024-02-07 10:00:00', 'driver'),
('Hannah',    'Adams',     'hannah.a@email.com',         CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'hannaha',     '2024-02-08 11:00:00', 'driver'),
('Ivan',      'Baker',     'ivan.b@email.com',           CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'ivanb',       '2024-02-09 12:00:00', 'driver'),
('Julia',     'Gonzalez',  'julia.g@email.com',          CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'juliag',      '2024-02-10 13:00:00', 'driver'),
('Kevin',     'Nelson',    'kevinn@email.com',           CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'kevinn',      '2024-02-11 14:00:00', 'driver'),
('Laura',     'Carter',    'laura.c@email.com',          CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'laurac',      '2024-02-12 15:00:00', 'driver'),
('Mike',      'Mitchell',  'mike.m@email.com',           CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'mikem',       '2024-02-13 08:30:00', 'driver'),
('Nina',      'Perez',     'nina.p@email.com',           CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'ninap',       '2024-02-14 09:30:00', 'driver'),
('Oscar',     'Roberts',   'oscar.r@email.com',          CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'oscarr',      '2024-02-15 10:30:00', 'driver'),
('Paula',     'Turner',    'paula.t@email.com',          CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'paulat',      '2024-02-16 11:30:00', 'driver'),
('Robert',    'Phillips',  'robert.p@email.com',         CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'robertp',     '2024-02-17 12:30:00', 'admin'),
('Susan',     'Campbell',  'susan.c@email.com',          CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'susanc',      '2024-02-18 13:30:00', 'admin'),
('Thomas',    'Parker',    'thomas.p@email.com',         CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'pass1234'), 2),  'thomasp',     '2024-02-19 14:30:00', 'admin');

-- Remaining inserts (USER_PHONE, ADDRESS, etc.) follow standard SQL and 
-- don't require MySQL-specific functions, but ensure you refer to [USER] if needed.
-- (Full remaining data follows below)

-- ============================================================
-- 2. USER_PHONE (45 records)
-- ============================================================
INSERT INTO USER_PHONE (Phone, UserID) VALUES
('+1-555-0101', 1), ('+1-555-0102', 2), ('+1-555-0103', 3), ('+1-555-0104', 4), ('+1-555-0105', 5),
('+1-555-0106', 6), ('+1-555-0107', 7), ('+1-555-0108', 8), ('+1-555-0109', 9), ('+1-555-0110', 10),
('+1-555-0111', 11), ('+1-555-0112', 12), ('+1-555-0113', 13), ('+1-555-0114', 14), ('+1-555-0115', 15),
('+1-555-0116', 16), ('+1-555-0117', 17), ('+1-555-0118', 18), ('+1-555-0119', 19), ('+1-555-0120', 20),
('+1-555-0121', 21), ('+1-555-0122', 22), ('+1-555-0123', 23), ('+1-555-0124', 24), ('+1-555-0125', 25),
('+1-555-0126', 26), ('+1-555-0127', 27), ('+1-555-0128', 28), ('+1-555-0129', 29), ('+1-555-0130', 30),
('+1-555-0131', 31), ('+1-555-0132', 32), ('+1-555-0133', 33), ('+1-555-0134', 34), ('+1-555-0135', 35),
('+1-555-0136', 36), ('+1-555-0137', 37), ('+1-555-0138', 38), ('+1-555-0139', 39), ('+1-555-0140', 40),
('+1-555-9001', 1), ('+1-555-9002', 5), ('+1-555-9003', 10), ('+1-555-9004', 15), ('+1-555-9005', 20);
GO

-- ============================================================
-- 3. ADDRESS (45 records)
-- ============================================================
INSERT INTO ADDRESS (City, StreetName, StreetNumber, Apartment, PostalCode, IsDefault, UserID) VALUES
('New York',      'Broadway',          '101',  'Apt 2A',  '10001', 1, 1),
('New York',      '5th Avenue',        '200',  NULL,      '10002', 1, 2),
('Los Angeles',   'Sunset Blvd',       '305',  'Unit 3',  '90028', 1, 3),
('Los Angeles',   'Hollywood Blvd',    '410',  NULL,      '90029', 1, 4),
('Chicago',       'Michigan Ave',      '520',  'Apt 5B',  '60601', 1, 5),
('Chicago',       'Lake Shore Dr',     '630',  NULL,      '60602', 1, 6),
('Houston',       'Main St',           '740',  'Suite 1', '77001', 1, 7),
('Houston',       'Richmond Ave',      '850',  NULL,      '77002', 1, 8),
('Phoenix',       'Camelback Rd',      '960',  'Apt 9C',  '85001', 1, 9),
('Phoenix',       'Scottsdale Rd',     '1070', NULL,      '85002', 1, 10),
('Philadelphia',  'Market St',         '1180', 'Apt 11D', '19101', 1, 11),
('Philadelphia',  'Chestnut St',       '1290', NULL,      '19102', 1, 12),
('San Antonio',   'Commerce St',       '1300', 'Unit 13', '78201', 1, 13),
('San Antonio',   'Alamo Plaza',       '1410', NULL,      '78202', 1, 14),
('San Diego',     'Harbor Dr',         '1520', 'Apt 15E', '92101', 1, 15),
('San Diego',     'Gaslamp Blvd',      '1630', NULL,      '92102', 1, 16),
('Dallas',        'Commerce St',       '1740', 'Suite 2', '75201', 1, 17),
('Dallas',        'Elm St',            '1850', NULL,      '75202', 1, 18),
('San Jose',      'Santa Clara St',    '1960', 'Apt 19F', '95101', 1, 19),
('San Jose',      'Almaden Blvd',      '2070', NULL,      '95102', 1, 20),
('Austin',        'Congress Ave',      '2180', 'Unit 21', '78701', 1, 21),
('Austin',        '6th St',            '2290', NULL,      '78702', 1, 22),
('Jacksonville',  'Bay St',            '2300', 'Apt 23G', '32201', 1, 23),
('Jacksonville',  'Adams St',          '2410', NULL,      '32202', 1, 24),
('Columbus',      'High St',           '2520', 'Suite 3', '43201', 1, 25),
('Columbus',      'Broad St',          '2630', NULL,      '43202', 1, 26),
('Charlotte',     'Trade St',          '2740', 'Apt 27H', '28201', 1, 27),
('Charlotte',     'Tryon St',          '2850', NULL,      '28202', 1, 28),
('Indianapolis',  'Meridian St',       '2960', 'Unit 29', '46201', 1, 29),
('Indianapolis',  'Washington St',     '3070', NULL,      '46202', 1, 30),
('Seattle',       'Pike St',           '3180', 'Apt 31I', '98101', 1, 31),
('Seattle',       '1st Ave',           '3290', NULL,      '98102', 1, 32),
('Denver',        'Colfax Ave',        '3300', 'Suite 4', '80201', 1, 33),
('Denver',        '16th St',           '3410', NULL,      '80202', 1, 34),
('Washington',    'Pennsylvania Ave',  '3520', 'Apt 35J', '20001', 1, 35),
('Washington',    'Constitution Ave',  '3630', NULL,      '20002', 1, 36),
('Nashville',     'Broadway',          '3740', 'Unit 37', '37201', 1, 37),
('Nashville',     'Church St',         '3850', NULL,      '37202', 1, 38),
('El Paso',       'Montana Ave',       '3960', 'Apt 39K', '79901', 1, 39),
('El Paso',       'Mesa St',           '4070', NULL,      '79902', 1, 40),
('Boston',        'Boylston St',       '4180', 'Apt 41L', '02101', NULL, NULL),
('Boston',        'Newbury St',        '4290', NULL,      '02102', NULL, NULL),
('Miami',         'Ocean Dr',          '4300', 'Unit 43', '33101', NULL, NULL),
('Miami',         'Collins Ave',       '4410', NULL,      '33102', NULL, NULL),
('Portland',      'Burnside St',       '4520', 'Apt 45M', '97201', NULL, NULL);
GO

-- ============================================================
-- 4. RESTAURANT (10 records)
-- ============================================================
INSERT INTO RESTAURANT (Name, Rating, IsActive, City, StreetName, StreetNumber, Unit) VALUES
('The Burger Barn',       4.50, 1, 'New York',     'Broadway',       '12',  NULL),
('Pizza Palace',          4.20, 1, 'Los Angeles',  'Sunset Blvd',    '88',  'Unit A'),
('Sushi Sensation',       4.80, 1, 'Chicago',      'Michigan Ave',   '234', NULL),
('Taco Town',             4.10, 1, 'Houston',      'Main St',        '56',  NULL),
('The Pasta Place',       4.60, 1, 'Phoenix',      'Camelback Rd',   '300', 'Suite 2'),
('Curry Corner',          4.30, 1, 'Philadelphia', 'Market St',      '78',  NULL),
('BBQ Brothers',          4.70, 1, 'San Antonio',  'Commerce St',    '145', NULL),
('Green Garden',          4.40, 1, 'San Diego',    'Harbor Dr',      '22',  'Unit B'),
('Noodle House',          4.55, 1, 'Dallas',       'Elm St',         '99',  NULL),
('The Breakfast Club',    4.25, 1, 'Seattle',      'Pike St',        '7',   NULL);
GO

-- ============================================================
-- 5. RESTAURANT_CUISINETYPE (40 records)
-- ============================================================
INSERT INTO RESTAURANT_CUISINETYPE (RestaurantID, CuisineType) VALUES
(1, 'American'), (1, 'Fast Food'), (1, 'Burgers'),
(2, 'Italian'), (2, 'Pizza'), (2, 'Mediterranean'),
(3, 'Japanese'), (3, 'Sushi'), (3, 'Asian'), (3, 'Seafood'),
(4, 'Mexican'), (4, 'Tex-Mex'), (4, 'Fast Food'),
(5, 'Italian'), (5, 'Pasta'), (5, 'European'),
(6, 'Indian'), (6, 'Asian'), (6, 'Vegetarian'), (6, 'Vegan'),
(7, 'American'), (7, 'BBQ'), (7, 'Southern'), (7, 'Comfort Food'),
(8, 'Healthy'), (8, 'Salads'), (8, 'Vegan'), (8, 'Vegetarian'),
(9, 'Chinese'), (9, 'Asian'), (9, 'Noodles'), (9, 'Soup'),
(10,'American'), (10,'Breakfast'), (10,'Brunch'), (10,'Cafe'),
(2, 'Gluten-Free'), (6, 'Halal'), (7, 'Gluten-Free'), (3, 'Gluten-Free');
GO

-- ============================================================
-- 6. RESTAURANT_PHONE (40 records)
-- ============================================================
INSERT INTO RESTAURANT_PHONE (Phone, RestaurantID) VALUES
('+1-212-100-0001', 1), ('+1-212-100-0002', 1), ('+1-212-100-0003', 1), ('+1-212-100-0004', 1),
('+1-310-200-0001', 2), ('+1-310-200-0002', 2), ('+1-310-200-0003', 2), ('+1-310-200-0004', 2),
('+1-312-300-0001', 3), ('+1-312-300-0002', 3), ('+1-312-300-0003', 3), ('+1-312-300-0004', 3),
('+1-713-400-0001', 4), ('+1-713-400-0002', 4), ('+1-713-400-0003', 4), ('+1-713-400-0004', 4),
('+1-602-500-0001', 5), ('+1-602-500-0002', 5), ('+1-602-500-0003', 5), ('+1-602-500-0004', 5),
('+1-215-600-0001', 6), ('+1-215-600-0002', 6), ('+1-215-600-0003', 6), ('+1-215-600-0004', 6),
('+1-210-700-0001', 7), ('+1-210-700-0002', 7), ('+1-210-700-0003', 7), ('+1-210-700-0004', 7),
('+1-619-800-0001', 8), ('+1-619-800-0002', 8), ('+1-619-800-0003', 8), ('+1-619-800-0004', 8),
('+1-214-900-0001', 9), ('+1-214-900-0002', 9), ('+1-214-900-0003', 9), ('+1-214-900-0004', 9),
('+1-206-100-1001',10), ('+1-206-100-1002',10), ('+1-206-100-1003',10), ('+1-206-100-1004',10);
GO

-- ============================================================
-- 7. MENUITEM (50 records)
-- ============================================================
INSERT INTO MENUITEM (RestaurantID, Name, Price, Description, IsAvailable) VALUES
(1, 'Classic Cheeseburger',    9.99,  'Beef patty, cheddar, lettuce, tomato',          1),
(1, 'Bacon Double Burger',     13.49, 'Double patty, crispy bacon, special sauce',      1),
(1, 'Veggie Burger',           10.99, 'Plant-based patty with avocado',                 1),
(1, 'Loaded Fries',             5.99, 'Fries with cheese sauce and jalapeños',          1),
(1, 'Chocolate Milkshake',      4.99, 'Thick chocolate milkshake',                     1),
(2, 'Margherita Pizza',        11.99, 'Tomato, mozzarella, fresh basil',                1),
(2, 'Pepperoni Pizza',         13.99, 'Classic pepperoni with mozzarella',              1),
(2, 'BBQ Chicken Pizza',       14.99, 'Grilled chicken, BBQ sauce, red onion',          1),
(2, 'Garlic Bread',             4.49, 'Toasted with garlic butter',                     1),
(2, 'Tiramisu',                 5.99, 'Classic Italian dessert',                        1),
(3, 'Salmon Nigiri (x6)',      12.99, 'Fresh Atlantic salmon over sushi rice',          1),
(3, 'Dragon Roll',             15.99, 'Shrimp tempura, avocado, cucumber',              1),
(3, 'Tuna Sashimi (x8)',       16.99, 'Premium bluefin tuna slices',                   1),
(3, 'Miso Soup',                2.99, 'Traditional dashi broth with tofu',              1),
(3, 'Edamame',                  3.49, 'Steamed salted soybeans',                        1),
(4, 'Street Tacos (x3)',        8.99, 'Corn tortillas, carnitas, cilantro, onion',     1),
(4, 'Burrito Bowl',            10.99, 'Rice, beans, pico de gallo, sour cream',        1),
(4, 'Nachos Grande',           11.99, 'Chips, cheese, guacamole, jalapeños',            1),
(4, 'Quesadilla',               8.49, 'Flour tortilla, cheese, grilled chicken',       1),
(4, 'Churros',                  4.49, 'Fried dough with cinnamon sugar and dipping sauce', 1),
(5, 'Spaghetti Carbonara',     13.99, 'Pancetta, egg, pecorino, black pepper',          1),
(5, 'Fettuccine Alfredo',      12.99, 'Creamy parmesan sauce',                          1),
(5, 'Lasagna',                 14.99, 'Layered beef ragù and béchamel',                 1),
(5, 'Bruschetta',               5.99, 'Toasted bread, tomato, basil, olive oil',        1),
(5, 'Panna Cotta',              5.49, 'Vanilla with berry coulis',                      1),
(6, 'Butter Chicken',          14.99, 'Tender chicken in creamy tomato sauce',          1),
(6, 'Lamb Rogan Josh',         16.99, 'Slow-cooked lamb with Kashmiri spices',          1),
(6, 'Vegetable Biryani',       12.99, 'Fragrant basmati with seasonal vegetables',      1),
(6, 'Garlic Naan (x2)',         3.99, 'Freshly baked leavened bread',                   1),
(6, 'Mango Lassi',              3.49, 'Chilled yogurt mango drink',                     1),
(7, 'Full Rack Ribs',          24.99, 'Slow-smoked pork ribs with house BBQ sauce',     1),
(7, 'Pulled Pork Sandwich',    11.99, 'Brioche bun, coleslaw, pickles',                 1),
(7, 'Brisket Plate',           18.99, '6oz smoked brisket with two sides',              1),
(7, 'Mac and Cheese',           6.99, 'Creamy four-cheese blend',                       1),
(7, 'Banana Pudding',           4.99, 'House-made with vanilla wafers',                 1),
(8, 'Quinoa Power Bowl',       12.99, 'Quinoa, roasted vegetables, tahini dressing',    1),
(8, 'Caesar Salad',             9.99, 'Romaine, parmesan, croutons, caesar dressing',   1),
(8, 'Avocado Toast',            8.99, 'Sourdough, smashed avocado, chili flakes',       1),
(8, 'Green Smoothie',           5.99, 'Spinach, banana, almond milk, chia seeds',       1),
(8, 'Acai Bowl',               10.99, 'Acai blend, granola, fresh fruit',               1),
(9, 'Beef Pho',                13.99, 'Rich bone broth, rice noodles, herbs',           1),
(9, 'Pad Thai',                12.99, 'Rice noodles, shrimp, bean sprouts, peanuts',    1),
(9, 'Ramen',                   14.99, 'Tonkotsu broth, chashu pork, soft-boiled egg',   1),
(9, 'Spring Rolls (x4)',        6.99, 'Fresh rice paper with shrimp and herbs',         1),
(9, 'Bubble Tea',               4.99, 'Taro milk tea with tapioca pearls',              1),
(10,'Pancake Stack',            9.99, 'Three fluffy pancakes with maple syrup',         1),
(10,'Eggs Benedict',           12.99, 'Poached eggs, Canadian bacon, hollandaise',      1),
(10,'Avocado Omelette',        11.99, 'Three-egg omelette with avocado and feta',       1),
(10,'French Toast',             8.99, 'Brioche, cinnamon, powdered sugar',              1),
(10,'Fresh Orange Juice',       3.99, 'Freshly squeezed',                               1);
GO

-- ============================================================
-- 8. ORDERS (45 records)
-- ============================================================
INSERT INTO ORDERS (UserID, Status, TotalPrice, OrderDate) VALUES
(1,  'delivered', 24.97, '2024-03-01 12:00:00'), (2,  'delivered', 27.98, '2024-03-01 12:30:00'),
(3,  'delivered', 31.96, '2024-03-01 13:00:00'), (4,  'delivered', 19.98, '2024-03-02 11:00:00'),
(5,  'delivered', 43.97, '2024-03-02 12:00:00'), (6,  'delivered', 28.97, '2024-03-02 13:30:00'),
(7,  'delivered', 36.98, '2024-03-03 11:30:00'), (8,  'delivered', 15.98, '2024-03-03 12:00:00'),
(9,  'delivered', 26.98, '2024-03-03 13:00:00'), (10, 'delivered', 41.97, '2024-03-04 11:00:00'),
(11, 'delivered', 22.98, '2024-03-04 12:30:00'), (12, 'delivered', 33.98, '2024-03-04 13:00:00'),
(13, 'delivered', 19.48, '2024-03-05 11:00:00'), (14, 'delivered', 29.98, '2024-03-05 12:00:00'),
(15, 'delivered', 38.97, '2024-03-05 13:30:00'), (16, 'delivered', 24.48, '2024-03-06 11:00:00'),
(17, 'delivered', 31.98, '2024-03-06 12:00:00'), (18, 'delivered', 27.98, '2024-03-07 11:30:00'),
(19, 'delivered', 22.98, '2024-03-07 12:00:00'), (20, 'delivered', 35.97, '2024-03-07 13:00:00'),
(21, 'delivered', 18.98, '2024-03-08 11:00:00'), (22, 'delivered', 44.97, '2024-03-08 12:30:00'),
(23, 'delivered', 26.98, '2024-03-08 13:00:00'), (24, 'delivered', 31.48, '2024-03-09 11:00:00'),
(25, 'delivered', 23.98, '2024-03-09 12:00:00'), (26, 'delivered', 39.97, '2024-03-09 13:30:00'),
(27, 'delivered', 28.48, '2024-03-10 11:00:00'), (28, 'delivered', 33.97, '2024-03-10 12:00:00'),
(29, 'delivered', 21.98, '2024-03-10 13:00:00'), (30, 'delivered', 47.97, '2024-03-11 11:00:00'),
(1,  'delivered', 15.98, '2024-03-12 12:00:00'), (3,  'delivered', 28.98, '2024-03-12 13:00:00'),
(5,  'cancelled', 22.98, '2024-03-13 11:00:00'), (7,  'delivered', 36.97, '2024-03-13 12:30:00'),
(9,  'delivered', 19.98, '2024-03-14 11:00:00'), (11, 'preparing', 31.97, '2024-03-15 12:00:00'),
(13, 'confirmed', 26.98, '2024-03-15 13:00:00'), (15, 'pending',   18.98, '2024-03-16 11:00:00'),
(17, 'out_for_delivery', 42.97, '2024-03-16 12:00:00'), (19, 'delivered', 24.98, '2024-03-17 11:30:00'),
(21, 'delivered', 33.97, '2024-03-17 12:00:00'), (23, 'delivered', 27.48, '2024-03-18 11:00:00'),
(25, 'delivered', 21.98, '2024-03-18 12:30:00'), (27, 'cancelled', 16.98, '2024-03-19 11:00:00'),
(29, 'delivered', 38.97, '2024-03-19 12:00:00');
GO

-- ============================================================
-- 9. ORDERITEM (45 records)
-- ============================================================
INSERT INTO ORDERITEM (OrderID, ItemID, Quantity, UnitPrice) VALUES
(1,  1, 2,  9.99), (1,  4, 1,  4.99), (2,  6, 1, 11.99), (2,  9, 2,  4.49),
(3, 11, 1, 12.99), (3, 12, 1, 15.99), (4, 16, 2,  8.99), (5, 21, 1, 13.99),
(5, 23, 1, 14.99), (5, 25, 2,  5.49), (6, 26, 1, 14.99), (6, 29, 2,  3.99),
(7, 31, 1, 24.99), (7, 34, 1,  6.99), (8, 36, 1, 12.99), (9, 41, 1, 13.99),
(9, 43, 1, 14.99), (10,46, 2,  9.99), (10,47, 1, 12.99), (11, 2, 1, 13.49),
(11, 5, 2,  4.99), (12,13, 1, 16.99), (12,14, 2,  2.99), (13,18, 1, 11.99),
(13,20, 1,  4.49), (14,22, 1, 12.99), (14,24, 1,  5.99), (15,27, 1, 16.99),
(15,28, 1, 12.99), (15,30, 2,  3.49), (16,32, 1, 11.99), (16,35, 1,  4.99),
(17,37, 1,  9.99), (17,40, 1, 10.99), (18,42, 1, 12.99), (18,44, 1,  6.99),
(19,49, 1,  8.99), (19,50, 2,  3.99), (20, 1, 1,  9.99), (20, 3, 1, 10.99),
(20, 4, 2,  5.99), (21, 7, 1, 13.99), (22,11, 2, 12.99), (22,15, 2,  3.49);
GO

-- ============================================================
-- 10. PAYMENT (45 records)
-- ============================================================
INSERT INTO PAYMENT (OrderID, Amount, Method, PaymentTime, PaymentStatus) VALUES
(1,  24.97, 'credit_card',   '2024-03-01 12:05:00', 'completed'),
(2,  27.98, 'online_wallet', '2024-03-01 12:35:00', 'completed'),
(3,  31.96, 'credit_card',   '2024-03-01 13:05:00', 'completed'),
(4,  19.98, 'debit_card',    '2024-03-02 11:05:00', 'completed'),
(5,  43.97, 'credit_card',   '2024-03-02 12:05:00', 'completed'),
(6,  28.97, 'cash',          '2024-03-02 13:35:00', 'completed'),
(7,  36.98, 'credit_card',   '2024-03-03 11:35:00', 'completed'),
(8,  15.98, 'online_wallet', '2024-03-03 12:05:00', 'completed'),
(9,  26.98, 'debit_card',    '2024-03-03 13:05:00', 'completed'),
(10, 41.97, 'credit_card',   '2024-03-04 11:05:00', 'completed'),
(11, 22.98, 'cash',          '2024-03-04 12:35:00', 'completed'),
(12, 33.98, 'credit_card',   '2024-03-04 13:05:00', 'completed'),
(13, 19.48, 'online_wallet', '2024-03-05 11:05:00', 'completed'),
(14, 29.98, 'debit_card',    '2024-03-05 12:05:00', 'completed'),
(15, 38.97, 'credit_card',   '2024-03-05 13:35:00', 'completed'),
(16, 24.48, 'cash',          '2024-03-06 11:05:00', 'completed'),
(17, 31.98, 'credit_card',   '2024-03-06 12:05:00', 'completed'),
(18, 27.98, 'online_wallet', '2024-03-07 11:35:00', 'completed'),
(19, 22.98, 'debit_card',    '2024-03-07 12:05:00', 'completed'),
(20, 35.97, 'credit_card',   '2024-03-07 13:05:00', 'completed'),
(21, 18.98, 'cash',          '2024-03-08 11:05:00', 'completed'),
(22, 44.97, 'credit_card',   '2024-03-08 12:35:00', 'completed'),
(23, 26.98, 'online_wallet', '2024-03-08 13:05:00', 'completed'),
(24, 31.48, 'debit_card',    '2024-03-09 11:05:00', 'completed'),
(25, 23.98, 'credit_card',   '2024-03-09 12:05:00', 'completed'),
(26, 39.97, 'cash',          '2024-03-09 13:35:00', 'completed'),
(27, 28.48, 'credit_card',   '2024-03-10 11:05:00', 'completed'),
(28, 33.97, 'online_wallet', '2024-03-10 12:05:00', 'completed'),
(29, 21.98, 'debit_card',    '2024-03-10 13:05:00', 'completed'),
(30, 47.97, 'credit_card',   '2024-03-11 11:05:00', 'completed'),
(31, 15.98, 'cash',          '2024-03-12 12:05:00', 'completed'),
(32, 28.98, 'credit_card',   '2024-03-12 13:05:00', 'completed'),
(33, 22.98, 'online_wallet', '2024-03-13 11:05:00', 'refunded'),
(34, 36.97, 'debit_card',    '2024-03-13 12:35:00', 'completed'),
(35, 19.98, 'credit_card',   '2024-03-14 11:05:00', 'completed'),
(36, 31.97, 'cash',          '2024-03-15 12:05:00', 'pending'),
(37, 26.98, 'credit_card',   '2024-03-15 13:05:00', 'pending'),
(38, 18.98, 'online_wallet', '2024-03-16 11:05:00', 'pending'),
(39, 42.97, 'debit_card',    '2024-03-16 12:05:00', 'completed'),
(40, 24.98, 'credit_card',   '2024-03-17 11:35:00', 'completed'),
(41, 33.97, 'cash',          '2024-03-17 12:05:00', 'completed'),
(42, 27.48, 'credit_card',   '2024-03-18 11:05:00', 'completed'),
(43, 21.98, 'online_wallet', '2024-03-18 12:35:00', 'completed'),
(44, 16.98, 'debit_card',    '2024-03-19 11:05:00', 'refunded'),
(45, 38.97, 'credit_card',   '2024-03-19 12:05:00', 'completed');
GO

-- ============================================================
-- 11. DELIVERY (40 records)
-- ============================================================
INSERT INTO DELIVERY (OrderID, UserID, AddressID, PickupTime, DeliveryTime, DeliveryStatus) VALUES
(1,  31, 1,  '2024-03-01 12:20:00', '2024-03-01 12:55:00', 'delivered'),
(2,  32, 2,  '2024-03-01 12:50:00', '2024-03-01 13:25:00', 'delivered'),
(3,  33, 3,  '2024-03-01 13:20:00', '2024-03-01 13:55:00', 'delivered'),
(4,  34, 4,  '2024-03-02 11:20:00', '2024-03-02 11:55:00', 'delivered'),
(5,  35, 5,  '2024-03-02 12:20:00', '2024-03-02 12:55:00', 'delivered'),
(6,  36, 6,  '2024-03-02 13:50:00', '2024-03-02 14:25:00', 'delivered'),
(7,  37, 7,  '2024-03-03 11:50:00', '2024-03-03 12:25:00', 'delivered'),
(8,  38, 8,  '2024-03-03 12:20:00', '2024-03-03 12:55:00', 'delivered'),
(9,  39, 9,  '2024-03-03 13:20:00', '2024-03-03 13:55:00', 'delivered'),
(10, 40, 10, '2024-03-04 11:20:00', '2024-03-04 11:55:00', 'delivered'),
(11, 41, 11, '2024-03-04 12:50:00', '2024-03-04 13:25:00', 'delivered'),
(12, 42, 12, '2024-03-04 13:20:00', '2024-03-04 13:55:00', 'delivered'),
(13, 31, 13, '2024-03-05 11:20:00', '2024-03-05 11:55:00', 'delivered'),
(14, 32, 14, '2024-03-05 12:20:00', '2024-03-05 12:55:00', 'delivered'),
(15, 33, 15, '2024-03-05 13:50:00', '2024-03-05 14:25:00', 'delivered'),
(16, 34, 16, '2024-03-06 11:20:00', '2024-03-06 11:55:00', 'delivered'),
(17, 35, 17, '2024-03-06 12:20:00', '2024-03-06 12:55:00', 'delivered'),
(18, 36, 18, '2024-03-07 11:50:00', '2024-03-07 12:25:00', 'delivered'),
(19, 37, 19, '2024-03-07 12:20:00', '2024-03-07 12:55:00', 'delivered'),
(20, 38, 20, '2024-03-07 13:20:00', '2024-03-07 13:55:00', 'delivered'),
(21, 39, 21, '2024-03-08 11:20:00', '2024-03-08 11:55:00', 'delivered'),
(22, 40, 22, '2024-03-08 12:50:00', '2024-03-08 13:25:00', 'delivered'),
(23, 41, 23, '2024-03-08 13:20:00', '2024-03-08 13:55:00', 'delivered'),
(24, 42, 24, '2024-03-09 11:20:00', '2024-03-09 11:55:00', 'delivered'),
(25, 31, 25, '2024-03-09 12:20:00', '2024-03-09 12:55:00', 'delivered'),
(26, 32, 26, '2024-03-09 13:50:00', '2024-03-09 14:25:00', 'delivered'),
(27, 33, 27, '2024-03-10 11:20:00', '2024-03-10 11:55:00', 'delivered'),
(28, 34, 28, '2024-03-10 12:20:00', '2024-03-10 12:55:00', 'delivered'),
(29, 35, 29, '2024-03-10 13:20:00', '2024-03-10 13:55:00', 'delivered'),
(30, 36, 30, '2024-03-11 11:20:00', '2024-03-11 11:55:00', 'delivered'),
(31, 37, 31, '2024-03-12 12:20:00', '2024-03-12 12:55:00', 'delivered'),
(32, 38, 32, '2024-03-12 13:20:00', '2024-03-12 13:55:00', 'delivered'),
(34, 39, 33, '2024-03-13 12:50:00', '2024-03-13 13:25:00', 'delivered'),
(35, 40, 34, '2024-03-14 11:20:00', '2024-03-14 11:55:00', 'delivered'),
(39, 41, 35, '2024-03-16 12:20:00', NULL,                  'in_transit'),
(40, 42, 36, '2024-03-17 11:50:00', '2024-03-17 12:25:00', 'delivered'),
(41, 31, 37, '2024-03-17 12:20:00', '2024-03-17 12:55:00', 'delivered'),
(42, 32, 38, '2024-03-18 11:20:00', '2024-03-18 11:55:00', 'delivered'),
(43, 33, 39, '2024-03-18 12:50:00', '2024-03-18 13:25:00', 'delivered'),
(45, 34, 40, '2024-03-19 12:20:00', '2024-03-19 12:55:00', 'delivered');
GO

-- ============================================================
-- 12. FEEDBACK (40 records)
-- ============================================================
INSERT INTO FEEDBACK (UserID, OrderID, RestaurantID, Rating, Comment, FeedbackDate) VALUES
(1,  1,  1, 5, 'Amazing burgers, super fresh!',                    '2024-03-01 14:00:00'),
(2,  2,  2, 4, 'Great pizza, could use more toppings.',            '2024-03-01 15:00:00'),
(3,  3,  3, 5, 'Best sushi in town, incredibly fresh.',            '2024-03-01 16:00:00'),
(4,  4,  4, 4, 'Tacos were good but a bit small.',                 '2024-03-02 13:00:00'),
(5,  5,  5, 5, 'Perfect pasta, will definitely order again!',      '2024-03-02 14:00:00'),
(6,  6,  6, 4, 'Delicious curry, naan was a bit cold.',            '2024-03-02 16:00:00'),
(7,  7,  7, 5, 'Best BBQ ribs I have ever had.',                   '2024-03-03 14:00:00'),
(8,  8,  8, 4, 'Healthy and tasty, great portion size.',           '2024-03-03 15:00:00'),
(9,  9,  9, 5, 'Pho was outstanding, rich broth.',                 '2024-03-03 16:00:00'),
(10, 10, 10, 4, 'Great breakfast, pancakes were fluffy.',          '2024-03-04 14:00:00'),
(11, 11,  1, 3, 'Burger was average, fries were cold.',            '2024-03-04 15:00:00'),
(12, 12,  3, 5, 'Sashimi was melt-in-the-mouth quality.',          '2024-03-04 16:00:00'),
(13, 13,  4, 4, 'Good nachos, generous toppings.',                 '2024-03-05 14:00:00'),
(14, 14,  5, 4, 'Alfredo was creamy and rich.',                    '2024-03-05 15:00:00'),
(15, 15,  6, 5, 'Lamb rogan josh was phenomenal.',                 '2024-03-05 16:00:00'),
(16, 16,  7, 4, 'Pulled pork sandwich was juicy.',                 '2024-03-06 14:00:00'),
(17, 17,  8, 5, 'Caesar salad was fresh, acai bowl was perfect.',  '2024-03-06 15:00:00'),
(18, 18,  9, 4, 'Pad thai was tasty, spring rolls were crispy.',   '2024-03-07 14:00:00'),
(19, 19, 10, 4, 'French toast was delicious.',                     '2024-03-07 15:00:00'),
(20, 20,  1, 5, 'Loved the variety, everything was hot.',          '2024-03-07 16:00:00'),
(21, 21,  2, 3, 'Pizza arrived lukewarm, taste was okay.',         '2024-03-08 14:00:00'),
(22, 22,  3, 5, 'Salmon nigiri and edamame were superb.',          '2024-03-08 15:00:00'),
(23, 23,  4, 4, 'Solid tacos, great value.',                       '2024-03-08 16:00:00'),
(24, 24,  5, 4, 'Pasta was good but portions felt small.',         '2024-03-09 14:00:00'),
(25, 25,  6, 5, 'Biryani was fragrant and filling.',               '2024-03-09 15:00:00'),
(26, 26,  7, 5, 'Brisket was perfectly smoked.',                   '2024-03-09 16:00:00'),
(27, 27,  8, 4, 'Quinoa bowl was nutritious and tasty.',           '2024-03-10 14:00:00'),
(28, 28,  9, 5, 'Ramen broth was incredibly deep and rich.',       '2024-03-10 15:00:00'),
(29, 29, 10, 4, 'Eggs Benedict were well-prepared.',               '2024-03-10 16:00:00'),
(30, 30,  1, 5, 'Outstanding burgers, fast delivery.',             '2024-03-11 14:00:00'),
(1,  31,  1, 4, 'Still great, consistent quality.',                '2024-03-12 15:00:00'),
(3,  32,  3, 5, 'Dragon roll was exceptional as always.',          '2024-03-12 16:00:00'),
(7,  34,  7, 5, 'Mac and cheese was the highlight.',               '2024-03-13 15:00:00'),
(9,  35,  9, 4, 'Pho was good, delivery was quick.',               '2024-03-14 14:00:00'),
(19, 40,  9, 5, 'Bubble tea and pho combo was perfect.',           '2024-03-17 14:00:00'),
(21, 41,  2, 4, 'BBQ chicken pizza was a great choice.',           '2024-03-17 15:00:00'),
(23, 42,  3, 5, 'Sushi quality never disappoints.',                '2024-03-18 14:00:00'),
(25, 43,  4, 3, 'Tacos were okay, salsa could be spicier.',        '2024-03-18 15:00:00'),
(29, 45,  5, 5, 'Carbonara was restaurant quality at home.',       '2024-03-19 15:00:00'),
(2,  2,   2, 5, 'Second review — garlic bread was phenomenal!',    '2024-03-20 10:00:00');
GO