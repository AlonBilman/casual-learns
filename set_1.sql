-- SQL Test – 9 Technical Questions

-- Base Table Schema (imagine you are working with these tables):

-- Customers(CustomerID, FirstName, LastName, City)
-- Orders(OrderID, CustomerID, OrderDate, TotalAmount)
-- Products(ProductID, ProductName, Price)
-- OrderItems(OrderItemID, OrderID, ProductID, Quantity)
-- Employees(EmployeeID, FirstName, DepartmentID)
-- Departments(DepartmentID, DepartmentName)

-- Part A – Queries with JOINs

-- Q1:
-- Retrieve the full name of each customer and the total sum of all their orders.
-- Show only customers who have made at least one order.

select c.FirstName, c.LastName , sum(o.TotalAmount) 
from Customers c
join Orders o
on c.CustomerID = o.CustomerID
group by c.CustomerID, c.FirstName, c.LastName

-- Q2:
-- Display a list of all products that have been sold,
-- along with the number of times each product was sold.

select p.ProductName, count(*)
from Products p 
join OrderItems o
on p.ProductID = o.ProductID
group by p.ProductName 

-- Q3:
-- Retrieve the names of customers who have never placed an order.
select c.FirstName, c.LastName 
from Customers c
where c.CustomerID 
not in (select CustomerID from Orders)

-- Part B – Aggregates, GROUP BY, Subqueries
-- Customers(CustomerID, FirstName, LastName, City)
-- Orders(OrderID, CustomerID, OrderDate, TotalAmount)
-- Products(ProductID, ProductName, Price)
-- OrderItems(OrderItemID, OrderID, ProductID, Quantity)
-- Employees(EmployeeID, FirstName, DepartmentID)
-- Departments(DepartmentID, DepartmentName)

-- Q4:
-- Display the name of the customer who made the most expensive order (by TotalAmount).
select FirstName, LastName from 
(
    select c.FirstName, c.LastName , sum(o.TotalAmount) as total
    from Customers c
    join Orders o
    on c.CustomerID = o.CustomerID 
    group by c.CustomerID, c.FirstName, c.LastName
    order by total desc 
    limit 1
) as TopCustomer;


-- Q5:
-- Show the average order total per city (City),
-- but only for cities with at least 3 orders.

select c.city, avg(o.TotalAmount)
from Customers c 
join Orders o 
on c.CustomerID = o.CustomerID
group by c.city
having count(o.OrderID) >= 3


-- Q6:
-- Find the list of products that have never been ordered.
select p.ProductName
from Products p
left join OrderItems oi 
on p.ProductID = oi.ProductID
where oi.ProductID is null;

-- Q7:
-- Retrieve the name of each product that was ordered
-- with an average quantity greater than 2 per order (in OrderItems).

with avgQuantity as 
(
    select ProductID, avg(Quantity) as avg_qty
    from OrderItems
    group by ProductID
    having avg(Quantity) > 2
)
select p.ProductName
from Products p
join avgQuantity a
on p.ProductID = a.ProductID

-- Part C – Subqueries and Logic

-- Q8:
-- Find all customers who made an order
-- with a total greater than the average of all orders.

select c.customerID, c.FirstName, c.LastName 
from Customers c 
join Orders o 
on c.CustomerID = o.CustomerID
group by c.customerID
having sum(TotalAmount) > (select avg(TotalAmount) from Orders)

-- Q9:
-- Find the name of the employee
-- who belongs to the department with the largest number of employees.
with largestDep as 
(select DepartmentID , count(*)
from Employees 
group by DepartmentID 
order by count(*)
limit 1)

select FirstName 
from Employees 
where DepartmentID in (select DepartmentID from largestDep)