CREATE DATABASE OCasseroles;
USE OCasseroles;

CUSTOMERS
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE,
    email VARCHAR(100),
    city VARCHAR(50) DEFAULT 'London'
);


MENU ITEMS (YOUR FOOD)
CREATE TABLE MenuItems (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    item_name VARCHAR(100) NOT NULL,
    protein_type VARCHAR(20) CHECK (protein_type IN ('Beef', 'Chicken', 'Fish')),
    price DECIMAL(6,2) CHECK (price > 0),
    availability BOOLEAN DEFAULT TRUE
);



ORDERS
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) CHECK (status IN ('Pending', 'Completed', 'Cancelled')),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);



ORDER DETAILS
CREATE TABLE OrderDetails (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    item_id INT,
    quantity INT CHECK (quantity > 0),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (item_id) REFERENCES MenuItems(item_id)
);



INSERT INTO Customers (name, phone, email) 
VALUES
	('Alice Brown', '0711111111', 'alice@email.com'),
	('Brian Smith', '0722222222', 'brian@email.com'),
	('Chloe Adams', '0733333333', 'chloe@email.com'),
	('David Lee', '0744444444', 'david@email.com'),
	('Ella White', '0755555555', 'ella@email.com'),
	('Frank Green', '0766666666', 'frank@email.com'),
	('Grace Hall', '0777777777', 'grace@email.com'),
	('Henry King', '0788888888', 'henry@email.com');


INSERT INTO MenuItems (item_name, protein_type, price) 
VALUES
	('Jollof Rice with Beef', 'Beef', 8.50),
	('Jollof Rice with Chicken', 'Chicken', 7.50),
	('Jollof Rice with Fish', 'Fish', 9.00),
	('Large Jollof Rice with Beef', 'Beef', 10.50),
	('Large Jollof Rice with Chicken', 'Chicken', 9.50),
	('Large Jollof Rice with Fish', 'Fish', 11.00),
	('Family Tray (Beef)', 'Beef', 18.00),
	('Family Tray (Chicken)', 'Chicken', 17.00);


INSERT INTO Orders (customer_id, status) 
VALUES
	(1, 'Completed'),
	(2, 'Pending'),
	(3, 'Completed'),
	(4, 'Cancelled'),
	(5, 'Completed'),
	(6, 'Pending'),
	(7, 'Completed'),
	(8, 'Completed');




INSERT INTO OrderDetails (order_id, item_id, quantity) 
VALUES
	(1, 1, 2),
	(1, 2, 1),
	(2, 3, 1),
	(3, 4, 2),
	(4, 5, 1),
	(5, 6, 1),
	(6, 7, 2),
	(7, 8, 1);







Solutions 
USE OCasseroles;

SELECT * 
FROM Customers
ORDER BY name;


SELECT MenuItems.item_name, MenuItems.price
FROM MenuItems
ORDER BY MenuItems.price DESC;


SELECT Orders.order_id, MenuItems.item_name, OrderDetails.quantity
FROM Orders
JOIN OrderDetails ON Orders.order_id = OrderDetails.order_id
JOIN MenuItems ON OrderDetails.item_id = MenuItems.item_id;


SELECT Orders.order_id, MenuItems.item_name, OrderDetails.quantity
FROM Orders
inner JOIN OrderDetails ON Orders.order_id = OrderDetails.order_id
inner JOIN MenuItems ON OrderDetails.item_id = MenuItems.item_id;



SELECT Orders.order_id, MenuItems.item_name, OrderDetails.quantity
FROM Orders
left JOIN OrderDetails ON Orders.order_id = OrderDetails.order_id
left join MenuItems ON OrderDetails.item_id = MenuItems.item_id;


SELECT MenuItems.item_name
FROM OrderDetails
JOIN MenuItems ON OrderDetails.item_id = MenuItems.item_id
GROUP BY MenuItems.item_name;



SELECT * FROM Orders
WHERE status = 'Completed'
ORDER BY order_date;


SELECT * FROM MenuItems
WHERE price > 5
ORDER BY price;


SELECT AVG(price) FROM MenuItems;

SELECT SUM(price) FROM MenuItems;

SELECT COUNT(price) FROM MenuItems;

SELECT COUNT(price) FROM menuitems;

