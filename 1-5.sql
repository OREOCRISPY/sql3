--1
select O.City
from (select distinct City from Employees) O inner join (select distinct City from Customers) M on O.City=M.City

--2£º
--a
select O.City
from (select distinct City from Customers) O
where City not in (select distinct City from Employees)

--b
select distinct City
from Customers 
except 
select distinct City
from Employees

--3£º
select D.ProductID,sum(D.Quantity) 
from [Order Details] D inner join Products P on D.ProductID=P.ProductID
group by D.ProductID

--4£º
select City,count(O.OrderID)
from Customers C left join Orders O on C.CustomerID=O.CustomerID left join [Order Details] D on O.OrderID=D.OrderID
group by City;

--5£º
--a:

select C.City
from Orders O inner join Customers C on O.CustomerID=C.CustomerID
group by C.City
having count(distinct C.CustomerId)>=2
union 
select City
from Customers
group by City
having Count(CustomerID)>=2

--b:
select City
from (select C.City,C.CustomerID as Ccustomer,O.OrderID,O.CustomerID as Ocustomer from Customers C left join Orders O on C.CustomerID=O.CustomerID)M
group by City 
having count(distinct M.Ccustomer)>=2