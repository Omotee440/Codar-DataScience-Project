
-- ---E-Commerce Database Design and Analysis for a Grocery Store---------
-- -----------------SECTION A-----------------

-- 1. Select customer name together with each order the customer made.

select customers.customerID, customername, orderID
from customers
inner join orders on customers.customerID = orders.customerID;


-- 2. Select order id together with name of employee who handled the order.

select orderID, concat(firstname,lastname) as "employee name"
from employees as e
inner join orders as o on o.employeeID = e.employeeID;

-- 3. Select customers who did not placed any order yet.

select customername, orderID, c.customerID
from customers as c
left join orders as o on c.customerID = o.customerID
where o.customerID is null;

-- 4. Select order id together with the name of products.

select orderID, productname
from order_details as od
inner join products as p on od.productID =p.productID;

-- 5 --Select products that no one bought

select *
from products
where productID not IN  (select productid from order_details);

-- 6 Select customer together with the products that he bought.
select c.customerID, c.customername, p.productID, p.productname
from customers as c
inner join orders as o on c.customerID=o.customerID
inner join order_details as od on o.orderID= od.orderID
inner join products as p on od.productID= p.productID;

-- 7 Select product names together with the name of corresponding category.
select productname, categoryname
from categories as c
inner join products as p on p.categoryID=c.categoryID;

-- 8 Select orders together with the name of the shipping company.
select orderID, shippername
from shippers as s
inner join orders as o on o.shipperID=s.shipperID;

-- 9 Select customers with id greater than 50 together with each order they made
select c.customerID, customername, orderID
from customers as c
inner join orders as o on c.customerID= o.customerID
where c.customerID > 50;

-- 10 Select employees together with orders with order id greater than 10400.
select e.employeeID, concat(firstname,lastname) as "employeename", o.orderID
from employees as e
inner join orders as o on o.employeeID= e.employeeID
where o.orderID > 10400;

-- 11 Select the most expensive product
select productID, productname, price
from products
order by price desc
limit 1;

-- 12 Select the second most expensive product.
select productID, productname, price
from products
order by price desc
limit 1,1;

-- 13 Select name and price of each product, sort the result by price in decreasing order.
select productID, productname, price
from products
order by price desc;

-- 14 . Select 5 most expensive products
select productID, productname, price
from products
order by price desc
limit 5;

-- 15 Select 5 most expensive products without the most expensive (in final 4 products)
select *
from products
order by price desc
limit 1,5;

-- 16 . Select name of the cheapest product (only name) without using LIMIT and OFFSET.
select p1.productname
from products as p1
left join products as p2 on p1.price > p2.price
where p2.price is null;

-- 17 Select name of the cheapest product (only name) using subquery.
select productname
from products
where price= (select min(price) from products);

-- 18 Select number of employees with LastName that starts with 'D'.
select count(employeeID)
from employees
where lastname like 'D%';

-- 19 Select customer name together with the number of orders made by the corresponding 
-- customer, sort the result by number of orders in decreasing order.
select c.customerID, customername, count(orderID) as "Number Of Orders"
from customers as c
inner join orders as o on c.customerID= o.customerID
group by customerID
order by count(orderID) desc;

-- 20 Add up the price of all products. 
select sum(price) as "Price of all products"
from products;

-- 21 Select orderID together with the total price of that Order, order the result by total 
-- price of order in increasing order.
select o.orderID, sum(price) as "Total Price of Order"
from order_details as o
inner join products as p on o.productID= p.productID
group by orderID
order by sum(price);

-- 22 -Select customer who spend the most money.
select c.customerID, customername, sum(price)
from customers as c 
inner join orders as o on o.customerID= c.customerID
inner join order_details as od on o.orderID= od.orderID
inner join products as p on od.productID= p.productID
group by customerID
order by sum(price) desc
limit 1;

-- 22 Select customer who spend the most money and lives in Canada
select c.customerID, customername, sum(price), country
from customers as c 
inner join orders as o on o.customerID= c.customerID
inner join order_details as od on o.orderID= od.orderID
inner join products as p on od.productID= p.productID
where country in ('canada')
group by customerID
order by sum(price) desc
limit 1;

-- 24 . Select customer who spend the second most money.
select c.customerID, customername, sum(price)
from customers as c 
inner join orders as o on o.customerID= c.customerID
inner join order_details as od on o.orderID= od.orderID
inner join products as p on od.productID= p.productID
group by customerID
order by sum(price) desc
limit 1,1;

-- 25 Select shipper together with the total price of proceed orders.
select shippername, sum(price) as " Total Price of Proceed Orders"
from shippers as s
inner join orders as o on s.shipperID=o.shipperID
inner join order_details as od on o.orderID= od.orderID
inner join products as p on p.productID= od.productID
group by s.shipperID;


-- ------------------------------SECTION B------------------------------------------------------
-- ---------------------EXPLANATORY DATA ANALYSIS-------------------------------------------------

-- 1-- Total number of products sold so far.
select count(productID) as "Total Products"
from products;

-- 2-- Total Revenue So far
select round(sum(price*quantity),2) as "Total Revenue"
from products as p
inner join order_details as od on  p.productID= od.productID;

-- 3-- Total Unique Products sold based on category
select distinct p.productID, productname, categoryname
from categories as c
inner join products as p on c.categoryID =p.categoryID
inner join order_details as od on p.productID =od.productID;

-- 4-- Total Number of Purchase Transactions from customers
select count(orderID) as "Total Number of Purchase"
from orders;

-- 5-- Compare Orders made between 2021 – 2022
select year(orderdate), count(orderID)
from orders
group by (year(orderdate));

-- 6-- What is total number of customers? Compare those that have made transaction and 
-- those that haven’t at all.
select count(customerID)
from customers;

select count(c.customerID) as "NO of Customers",
	case
     when  o.customerID is null then "yet to make an order"
     else "made an order"
     end as TransactionStatus
from customers as c 
left join orders as o on c.customerID = o.customerID
group by TransactionStatus;

-- 7-- Who are the Top 5 customers with the highest purchase value?
select count(c.customerID) as "Customer ID", customername as "Customer Name",
round(sum(price*quantity),2) as "Purchase Amount"
from customers as c
inner join orders as o on c.customerID= o.customerID
inner join order_details as od on o.orderID = od.orderID
inner join products as p on od.productID= p.productID
group by c.customerID
order by sum(price) desc
limit 5;

-- 8--Top 5 best-selling products.
select productID,  sum(quantity)
from order_details
group by productID
order by sum(quantity) desc
limit 5;

-- 9-- What is the Transaction value per month?
select concat(month(orderdate),"-", year(orderdate)) as "Month-Year", count(o.orderID) as 
"No of Orders", round(sum(price),2) as "Total Amount"
from orders as o
inner join order_details as od on o.orderID =od.orderID
inner join products as p on od.productID = p.productID
group by concat(month(orderdate),"-", year(orderdate));

-- 10--  Best Selling Product Category?
select c.categoryID, categoryname, count(orderID) as "No of Orders"
from categories as c
inner join products as p on c.categoryID = p.categoryID
inner join order_details as od on p.productID = od.productID
group by categoryID
order by count(orderID) desc;

-- 11--Buyers who have Transacted more than two times
select customerID, count(orderID)
from orders
group by customerID
having count(orderID)> 2;

-- 12-- Most Successful Employee.
select count(orderID), e.employeeID
from employees as e
inner join orders as o on e.employeeID = o.employeeID
group by e.employeeID
order by count(orderID) desc
limit 1;

-- 13-- Most used Shipper
select s.shipperID, shippername, count(orderID) as "No of Orders"
from shippers as s
inner join orders as o on s.shipperID = o.shipperID
group by s.shipperID
order by count(orderID) desc
limit 1;

-- 14--Most used Supplier
select s.supplierID, suppliername, count(o.orderID) as "No of Orders"
from suppliers as s
inner join products as p on s.supplierID = p.supplierID
inner join order_details as od on p.productID= od.productID
inner join orders as o on od.orderID= o.orderID
group by s.supplierID
order by count(o.orderID) desc
limit 1;
















