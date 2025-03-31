-- Create customers table
CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    address TEXT
);

-- Create products table
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    description TEXT
);

-- Create orders table
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- Insert sample data into customers table
INSERT INTO customers (name, email, address) VALUES
('John Doe', 'john@example.com', '123 Elm Street'),
('Jane Smith', 'jane@example.com', '456 Oak Avenue'),
('Alice Johnson', 'alice@example.com', '789 Pine Road');

-- Insert sample data into products table
INSERT INTO products (name, price, description) VALUES
('Product A', 30.00, 'Description for Product A'),
('Product B', 25.00, 'Description for Product B'),
('Product C', 40.00, 'Description for Product C');

-- Insert sample data into orders table
INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, CURDATE(), 75.00),
(2, CURDATE() - INTERVAL 10 DAY, 120.00),
(3, CURDATE() - INTERVAL 40 DAY, 60.00);

-- 1. Retrieve all customers who have placed an order in the last 30 days
SELECT DISTINCT c.* FROM customers c
JOIN orders o ON c.id = o.customer_id
WHERE o.order_date >= CURDATE() - INTERVAL 30 DAY;

-- 2. Get the total amount of all orders placed by each customer
SELECT c.id, c.name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.name;

-- 3. Update the price of Product C to 45.00
UPDATE products SET price = 45.00 WHERE name = 'Product C';

-- 4. Add a new column 'discount' to the products table
ALTER TABLE products ADD COLUMN discount DECIMAL(5,2) DEFAULT 0.00;

-- 5. Retrieve the top 3 products with the highest price
SELECT * FROM products ORDER BY price DESC LIMIT 3;

-- 6. Get the names of customers who have ordered Product A
SELECT DISTINCT c.name FROM customers c
JOIN orders o ON c.id = o.customer_id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE p.name = 'Product A';

-- 7. Join the orders and customers tables to retrieve the customer's name and order date for each order
SELECT c.name, o.order_date FROM orders o
JOIN customers c ON o.customer_id = c.id;

-- 8. Retrieve the orders with a total amount greater than 150.00
SELECT * FROM orders WHERE total_amount > 150.00;

-- 9. Normalize by creating an order_items table and updating the orders table
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

ALTER TABLE orders DROP COLUMN total_amount;

-- 10. Retrieve the average total of all orders
SELECT AVG(o.total_amount) AS average_order_value FROM orders o;
