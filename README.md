# CFG-Assignments4
ASSIGNMENT 4: 
Project: CREATING APIs IN PYTHON
food4All Complete Flask + MySQL API 
Work setup:
•	Flask API
•	MySQL database
•	DBeaver-compatible SQL
•	Connected foreign keys
Work:
•	MySQL 8+
•	Flask
•	mysql-connector-python
________________________________________
1. INSTALL REQUIRED PACKAGES
Python: pip install flask mysql-connector-python
________________________________________
2. DATABASE IN DBEAVER / MYSQL
SQL script:
CREATE DATABASE IF NOT EXISTS Food4All;

USE Food4All;

-- DROP TABLES
DROP TABLE IF EXISTS food4all_orders;
DROP TABLE IF EXISTS food4all_buyers;
DROP TABLE IF EXISTS food4all_menu_items;

-- BUYERS TABLE
CREATE TABLE food4all_buyers (
    buyer_id INT AUTO_INCREMENT PRIMARY KEY,
    buyer_name VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

-- MENU ITEMS TABLE
CREATE TABLE food4all_menu_items (
    menu_item_id INT AUTO_INCREMENT PRIMARY KEY,
    menu_item_name VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

-- ORDERS TABLE WITH FOREIGN KEYS
CREATE TABLE food4all_orders (

    order_id INT AUTO_INCREMENT PRIMARY KEY,

    buyer_id INT NOT NULL,

    menu_item_id INT NOT NULL,

    quantity INT NOT NULL,

    order_date DATE NOT NULL,

    CONSTRAINT fk_food4all_orders_buyer
        FOREIGN KEY (buyer_id)
        REFERENCES food4all_buyers(buyer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_food4all_orders_menu_item
        FOREIGN KEY (menu_item_id)
        REFERENCES food4all_menu_items(menu_item_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE

) ENGINE=InnoDB;

-- INDEXES
CREATE INDEX idx_food4all_orders_buyer
ON food4all_orders(buyer_id);

CREATE INDEX idx_food4all_orders_menu_item
ON food4all_orders(menu_item_id);

-- INSERT BUYERS
INSERT INTO food4all_buyers (buyer_name) VALUES
('John'),
('Alice'),
('Maria'),
('David'),
('Chris');

-- INSERT MENU ITEMS
INSERT INTO food4all_menu_items (menu_item_name) VALUES
('Jollof Rice'),
('Egusi Soup Marmite'),
('Chicken Yassa'),
('Maffe'),
('Beef Stew'),
('Grilled Plantain'),
('Spicy Suya Chicken'),
('Tilapia Pepper Soup'),
('Bobotie');

-- INSERT ORDERS
INSERT INTO food4all_orders (
    buyer_id,
    menu_item_id,
    quantity,
    order_date
) VALUES
(1,1,2,'2026-05-01'),
(2,2,1,'2026-05-02'),
(1,3,3,'2026-05-03'),
(3,4,2,'2026-05-04'),
(4,5,1,'2026-05-05');
________________________________________
3. PYTHON PROJECT STRUCTURE
food4AllAPI/
main.py
app.py
client.py
db_config.py
db_utils.py
________________________________________
4. db_config.py
import mysql.connector


def get_db_connection():

    try:
        connection = mysql.connector.connect(
            host="localhost",
            user="root",
            password="YOUR_PASSWORD",
            database="Food4All"
        )

        return connection

    except mysql.connector.Error as err:
        print(f"Database connection failed: {err}")
        return None
________________________________________
5. db_utils.py
from db_config import get_db_connection


# FETCH ALL ORDERS
def fetch_all_orders():

    connection = get_db_connection()

    if connection is None:
        return []

    cursor = connection.cursor(dictionary=True)

    query = """
    SELECT
        o.order_id,
        b.buyer_name,
        m.menu_item_name,
        o.quantity,
        o.order_date
    FROM food4all_orders o
    JOIN food4all_buyers b
        ON o.buyer_id = b.buyer_id
    JOIN food4all_menu_items m
        ON o.menu_item_id = m.menu_item_id
    """

    cursor.execute(query)

    results = cursor.fetchall()

    cursor.close()
    connection.close()

    return results


# FETCH SINGLE ORDER
def fetch_single_order(order_id):

    connection = get_db_connection()

    if connection is None:
        return None

    cursor = connection.cursor(dictionary=True)

    query = """
    SELECT
        o.order_id,
        b.buyer_name,
        m.menu_item_name,
        o.quantity,
        o.order_date
    FROM food4all_orders o
    JOIN food4all_buyers b
        ON o.buyer_id = b.buyer_id
    JOIN food4all_menu_items m
        ON o.menu_item_id = m.menu_item_id
    WHERE o.order_id = %s
    """

    cursor.execute(query, (order_id,))

    result = cursor.fetchone()

    cursor.close()
    connection.close()

    return result


# CREATE ORDER
def insert_order(buyer_id, menu_item_id, quantity, order_date):

    connection = get_db_connection()

    if connection is None:
        return False

    cursor = connection.cursor()

    query = """
    INSERT INTO food4all_orders (
        buyer_id,
        menu_item_id,
        quantity,
        order_date
    )
    VALUES (%s, %s, %s, %s)
    """

    values = (
        buyer_id,
        menu_item_id,
        quantity,
        order_date
    )

    cursor.execute(query, values)

    connection.commit()

    cursor.close()
    connection.close()

    return True


# DELETE ORDER
def remove_order(order_id):

    connection = get_db_connection()

    if connection is None:
        return False

    cursor = connection.cursor()

    query = "DELETE FROM food4all_orders WHERE order_id = %s"

    cursor.execute(query, (order_id,))

    connection.commit()

    cursor.close()
    connection.close()

    return True
________________________________________
6. client.py
import requests

BASE_URL = "http://127.0.0.1:5000"


# GET ALL ORDERS
response = requests.get(f"{BASE_URL}/orders")

print("ALL ORDERS")
print(response.json())


# CREATE ORDER
new_order = {
    "buyer_id": 1,
    "menu_item_id": 2,
    "quantity": 5,
    "order_date": "2026-05-20"
}

response = requests.post(
    f"{BASE_URL}/orders",
    json=new_order
)

print("NEW ORDER RESPONSE")
print(response.json())
________________________________________
7. main.py
main.py is the entry point for the application.
from app import app


if __name__ == '__main__':
    app.run(debug=True)
Now run the project using:
python main.py
________________________________________
8. app.py
from flask import Flask, jsonify, request
from db_config import get_db_connection

app = Flask(__name__)


# GET ALL ORDERS
@app.route('/orders', methods=['GET'])
def get_orders():

    connection = get_db_connection()

    if connection is None:
        return jsonify({"error": "Database connection failed"}), 500

    cursor = connection.cursor(dictionary=True)

    query = """
    SELECT
        o.order_id,
        b.buyer_name,
        m.menu_item_name,
        o.quantity,
        o.order_date
    FROM food4all_orders o
    JOIN food4all_buyers b
        ON o.buyer_id = b.buyer_id
    JOIN food4all_menu_items m
        ON o.menu_item_id = m.menu_item_id
    """

    cursor.execute(query)

    orders = cursor.fetchall()

    cursor.close()
    connection.close()

    return jsonify(orders)


# GET SINGLE ORDER
@app.route('/orders/<int:order_id>', methods=['GET'])
def get_single_order(order_id):

    connection = get_db_connection()

    if connection is None:
        return jsonify({"error": "Database connection failed"}), 500

    cursor = connection.cursor(dictionary=True)

    query = """
    SELECT
        o.order_id,
        b.buyer_name,
        m.menu_item_name,
        o.quantity,
        o.order_date
    FROM food4all_orders o
    JOIN food4all_buyers b
        ON o.buyer_id = b.buyer_id
    JOIN food4all_menu_items m
        ON o.menu_item_id = m.menu_item_id
    WHERE o.order_id = %s
    """

    cursor.execute(query, (order_id,))

    order = cursor.fetchone()

    cursor.close()
    connection.close()

    return jsonify(order)


# CREATE ORDER
@app.route('/orders', methods=['POST'])
def create_order():

    data = request.get_json()

    buyer_id = data['buyer_id']
    menu_item_id = data['menu_item_id']
    quantity = data['quantity']
    order_date = data['order_date']

    connection = get_db_connection()

    if connection is None:
        return jsonify({"error": "Database connection failed"}), 500

    cursor = connection.cursor()

    query = """
    INSERT INTO food4all_orders (
        buyer_id,
        menu_item_id,
        quantity,
        order_date
    )
    VALUES (%s, %s, %s, %s)
    """

    values = (
        buyer_id,
        menu_item_id,
        quantity,
        order_date
    )

    cursor.execute(query, values)

    connection.commit()

    cursor.close()
    connection.close()

    return jsonify({
        "message": "Order created successfully"
    })


# DELETE ORDER
@app.route('/orders/<int:order_id>', methods=['DELETE'])
def delete_order(order_id):

    connection = get_db_connection()

    if connection is None:
        return jsonify({"error": "Database connection failed"}), 500

    cursor = connection.cursor()

    query = "DELETE FROM food4all_orders WHERE order_id = %s"

    cursor.execute(query, (order_id,))

    connection.commit()

    cursor.close()
    connection.close()

    return jsonify({
        "message": "Order deleted successfully"
    })


# RUN APP
if __name__ == '__main__':
    app.run(debug=True)
________________________________________
9. FLASK APP
In PyCharm terminal:
python app.py
APY
Running on http://127.0.0.1:5000
________________________________________
10. TEST API ROUTES
GET ALL ORDERS
GET http://127.0.0.1:5000/orders
________________________________________
GET SINGLE ORDER
GET http://127.0.0.1:5000/orders/1
________________________________________

CREATE ORDER 
POST http://127.0.0.1:5000/orders
Headers:
Content-Type: application/json
JSON Body:
{
  "buyer_id": 1,
  "menu_item_id": 2,
  "quantity": 3,
  "order_date": "2026-05-20"
}
________________________________________
DELETE ORDER
DELETE http://127.0.0.1:5000/orders/1
________________________________________
11. VERIFY FOREIGN KEYS
In DBeaver:
SHOW CREATE TABLE food4all_orders;
To see:
FOREIGN KEY (`buyer_id`)
REFERENCES `food4all_buyers` (`buyer_id`)

FOREIGN KEY (`menu_item_id`)
REFERENCES `food4all_menu_items` (`menu_item_id`)
________________________________________
