-------------------- SQL Project 'OnlineBookStore' --------------------

----- Create Database OnlineBookStore -----

DROP DATABASE IF EXISTS OnlineBookStore;

CREATE DATABASE OnlineBookStore;

-- switch to the database
\c  OnlineBookStore;

-- Create Tables

DROP TABLE IF EXISTS Books;

CREATE TABLE Books (
	   Book_id SERIAL PRIMARY KEY,
	   Title VARCHAR(100),
	   Author VARCHAR(100),
	   Genre VARCHAR(50),
	   Published_year INT,
	   Price NUMERIC(10,2),
	   Stock INT

);

DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers (
	   Customer_id SERIAL PRIMARY KEY,
	   Name VARCHAR(100),
	   Email VARCHAR(100),
	   Phone VARCHAR(15),
	   City VARCHAR(50),
	   Country VARCHAR(150)
	  
);

DROP TABLE IF EXISTS Orders;

CREATE TABLE Orders (
	   Order_id SERIAL PRIMARY KEY,
	   Customer_id INT REFERENCES Customers(Customer_id),
	   Book_id INT REFERENCES Books(Book_id),
	   Order_date DATE,
	   Quantity INT,
	   Total_amount NUMERIC(10,2)
	   
);

SELECT * FROM Books;

SELECT * FROM Customers;

SELECT * FROM Orders;


---- Import data into books table

COPY Books(Book_id, Title, Author, Genre, Published_year, Price, Stock)
FROM  'E:\SQL Tutorial 2025\Practice files\Project Files\Books.csv'
CSV HEADER;


---- Import data into customers table 

COPY Customers(Customer_id, Name, Email, Phone, City, Country)
FROM  'E:\SQL Tutorial 2025\Practice files\Project Files\Customers.csv'
CSV HEADER;


---- Import data into orders table

COPY Orders(Order_id, Customer_id, Book_id, Order_date, Quantity, Total_amount)
FROM  'E:\SQL Tutorial 2025\Practice files\Project Files\Orders.csv'
CSV HEADER;


------ Basic Queries --------

-- Q1. Retrieve all books in the "Fiction" genre
-- ANS

SELECT * FROM Books
WHERE Genre='Fiction';


-- Q2. Find books published after the year 1950
-- ANS

SELECT * FROM Books
WHERE Published_year>1950;


-- Q3. List all customers from the Canada
-- ANS

SELECT * FROM Customers
WHERE Country='Canada';


-- Q4. Show orders placed in November 2023
-- ANS

SELECT * FROM Orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';


-- Q5. Retrieve the total stock of books available
-- ANS

SELECT SUM(stock) AS total_stock
FROM Books;


-- Q6. Find the details of the most expensive book
-- ANS

SELECT * FROM Books ORDER BY price DESC LIMIT 1;


-- Q7. Show all customers who ordered more than 1 quantity of a book
-- ANS

SELECT * FROM Orders
WHERE quantity>1;

-- Q8. Retrieve all orders where the total amount exceeds $20
-- ANS

SELECT * FROM Orders
WHERE total_amount>20;

-- Q9. List all genres available in the Books table
-- ANS

SELECT DISTINCT(genre) FROM Books;

-- Q10. Find the book with the lowest stock
-- ANS

SELECT * FROM Books
ORDER BY stock
LIMIT 4;


-- Q11. Calculate the total revenue generated from all orders
-- ANS

SELECT SUM(total_amount) AS total_revenue FROM Orders;


------ Advanced Queries ---------

-- Q1. Retrieve the total number of books sold for each genre
-- ANS

SELECT b.genre, SUM(o.quantity) AS total_books_sold
FROM Orders o
JOIN Books b
ON o.book_id=b.book_id
GROUP BY b.genre;


-- Q2. Find the average price of books in the "Fantasy" genre
-- ANS

SELECT AVG(price) AS average_price
FROM Books
WHERE Genre='Fantasy';


-- Q3. List customers who have placed at least 2 orders
-- ANS

SELECT o.customer_id, c.name, COUNT(o.order_id) AS order_count
FROM Orders o
JOIN Customers c
ON o.customer_id=c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(o.order_id) >= 2;


-- Q4. Find the most frequently ordered book
-- ANS

SELECT o.book_id, b.title, COUNT(o.order_id) AS order_count
FROM Orders o
JOIN Books b ON o.book_id=b.book_id
GROUP BY o.book_id, b.title
ORDER BY order_count DESC
LIMIT 1;


-- Q5. Show the top 3 most expensive books of 'Fantasy' Genre
-- ANS

SELECT * FROM Books
WHERE genre = 'Fantasy'
ORDER BY price DESC
LIMIT 3;


-- Q6. Retrieve the total quantity of books sold by each author
-- ANS

SELECT b.author, b.title, SUM(o.quantity) AS total_Books_sold
FROM Orders o
JOIN Books b ON o.book_id=b.book_id
GROUP BY b.author, b.title, o.quantity
ORDER BY o.quantity DESC;


-- Q7. List the cities where customers who spent over $30 are located
-- ANS

SELECT DISTINCT(c.city), c.name, o.total_amount
FROM Orders o
JOIN Customers c ON o.customer_id=c.customer_id
WHERE o.total_amount>30
ORDER BY o.total_amount DESC;


-- Q8. Find the customer who spent the most on orders
-- ANS

SELECT c.customer_id, c.name, c.city, SUM(o.total_amount) AS total_spent
FROM Orders o
JOIN Customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC;


-- Q9. Calculate the stock remaining after fulfilling all orders
-- ANS

SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS order_quantity,
					 b.stock - COALESCE(SUM(o.quantity),0) AS remaining_quantity
FROM Books b
LEFT JOIN Orders o ON b.book_id=o.book_id
GROUP BY b.book_id
ORDER BY b.book_id;
