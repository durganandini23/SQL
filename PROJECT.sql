CREATE DATABASE E_COMMERCE_DATABASE_SYSTEM;
-----USERS TABLE
CREATE TABLE USERS
(
USER_ID INT IDENTITY(1,1) PRIMARY KEY,
USER_NAME VARCHAR(50) UNIQUE NOT NULL,
EMAIL_ID VARCHAR(80) NOT NULL,
IS_ADMIN BIT DEFAULT 0,
CREATED_AT DATETIME DEFAULT GETDATE()
);
ALTER TABLE USERS
ADD PASSWORD VARCHAR(50) NOT NULL;
----CATEGORIES
CREATE TABLE Categories (
    CATEGORY_ID INT IDENTITY(1,1) PRIMARY KEY,
    CATEGORY_NAME VARCHAR(100) NOT NULL)
	------PRODUCTS
CREATE TABLE PRODUCTS (
    PRODUCT_ID INT IDENTITY(1,1) PRIMARY KEY,
    PRODUCT_NAME VARCHAR(100) NOT NULL,
    DESCRIPTION TEXT,
    PRICE DECIMAL(10, 2) NOT NULL,
    STOCK_QUANTITY INT DEFAULT 0,
    CATEGORY_ID INT,
    CREATED_AT DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CATEGORY_ID) REFERENCES CATEGORIES(CATEGORY_ID)
);
----ORDER TABLE
CREATE TABLE ORDERS (
    ORDER_ID INT IDENTITY(1,1) PRIMARY KEY,
    USER_ID INT,
    ORDER_DATE DATETIME DEFAULT GETDATE(),
   TOTAL_AMOUNT DECIMAL(10, 2) NOT NULL,
    STATUS VARCHAR(50) DEFAULT 'Pending',
    FOREIGN KEY (USER_ID) REFERENCES Users(USER_ID)
);
ALTER TABLE ORDERS ADD USER_NAME VARCHAR(80);
---ORDER ITEMS
CREATE TABLE ORDER_ITEMS (
    ORDER_ITEM_ID INT IDENTITY(1,1) PRIMARY KEY,
    ORDER_ID INT,
    PRODUCT_ID INT,
    QNANTITY INT NOT NULL,
    PRICE_AT_PURCHASE DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (ORDER_ID) REFERENCES ORDERS(ORDER_ID),
    FOREIGN KEY (PRODUCT_ID) REFERENCES Products(PRODUCT_ID)
);
CREATE TABLE Payments (
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT,
    payment_method VARCHAR(50) NOT NULL,
    payment_date DATETIME DEFAULT GETDATE(),
    payment_status VARCHAR(50) DEFAULT 'Completed',
    amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);
CREATE TABLE ShoppingCart (
    cart_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    product_id INT,
    quantity INT NOT NULL DEFAULT 1,
    added_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (PRODUCT_ID) REFERENCES Products(PRODUCT_ID)
);
SELECT * FROM USERS
INSERT INTO Users (USER_NAME, EMAIL_ID,PASSWORD,is_admin) 
VALUES 
('NANDINI', 'NANDU@example.com', 'NANDUpassword1',0),
('SIRISHA', 'SIRI@example.com', 'SIRIpassword2',1)

-- Inserting Categories
INSERT INTO Categories (category_name) 
VALUES 
('Electronics'), 
('Clothing'), 
('Books');

-- Inserting Products
INSERT INTO PRODUCTS (product_name, description, price, stock_quantity, category_id) 
VALUES 
('TELEVISION', 'A high-performance TELEVISION', 999.99, 10, 1),
('SHORTS', 'A comfortable cotton t-shirt', 19.99, 50, 2),
('Fiction Novel', 'A bestselling novel', 9.99, 100, 3);

-- Inserting Orders
INSERT INTO Orders (user_id, total_amount, status) 
VALUES 
(1, 1019.98, 'Completed'),
(1, 9.99, 'Pending');

-- Inserting Order Items
INSERT INTO Order_Items (order_id,PRODUCT_ID,QNANTITY,price_at_purchase) 
VALUES 
(1, 1, 1, 999.99),
(1, 2, 1, 19.99),
(2, 3, 1, 9.99);

-- Inserting Payments
INSERT INTO Payments (order_id, payment_method, amount) 
VALUES 
(1, 'Credit Card', 1019.98),
(2, 'PayPal', 9.99);

-- Inserting Shopping Cart
INSERT INTO ShoppingCart (user_id,PRODUCT_ID,quantity) 
VALUES 
(1, 3, 2),
(1, 1, 1);
-----Retrieve all products in a specific category:
SELECT PRODUCT_ID,PRODUCT_NAME,PRICE,STOCK_QUANTITY FROM PRODUCTS WHERE CATEGORY_ID=
(SELECT CATEGORY_ID FROM Categories WHERE CATEGORY_NAME='ELECTRONICS')

 -----Get the details of a customerís order:
 SELECT O.ORDER_ID,U.USER_NAME,P.PRODUCT_ID,OI.PRICE_AT_PURCHASE FROM ORDERS O INNER JOIN USERS U ON O.USER_ID=U.USER_ID 
 INNER JOIN ORDER_ITEMS OI ON O.ORDER_ID=OI.ORDER_ID
 INNER JOIN  PRODUCTS P ON OI.PRODUCT_ID=P.PRODUCT_ID
 WHERE O.USER_ID=1;

 ----Calculate the total revenue generated:
 SELECT SUM(TOTAL_AMOUNT ) AS REVENUEGENERATED FROM ORDERS WHERE STATUS='COMPLETED';

 ----Check products that need to be restocked:
 SELECT PRODUCT_ID,PRODUCT_NAME,STOCK_QUANTITY FROM PRODUCTS WHERE STOCK_QUANTITY>29

 ----View shopping cart for a specific user:
 SELECT SC.cart_id ,SC.user_id , SC.product_iD, SC.quantity,(P.PRICE*SC.QUANTITY)AS TOTAL_PRICE FROM  shoppingcart sc
 INNER JOIN products P ON SC.product_id=P.PRODUCT_ID WHERE USER_ID=1;

 ----- TRIGGERS
 CREATE TRIGGER update_stock
 ON Order_Items
 AFTER  INSERT
 AS
BEGIN
IF EXISTS(SELECT * FROM inserted)
    INSERT INTO PRODUCTS(PRODUCT_ID)
	SELECT PRODUCT_ID 'INSERT' FROM inserted
END;
SELECT * FROM PRODUCTS

----PROCEDURES

CREATE PROCEDURE SP_PS2
@TOTAL_AMOUNT INT
AS
BEGIN
SELECT * FROM ORDERS S INNER JOIN PAYMENTS P ON S.ORDER_ID=P.order_id WHERE @TOTAL_AMOUNT>1 
END;
EXEC SP_PS2 @TOTAL_AMOUNT=1 

