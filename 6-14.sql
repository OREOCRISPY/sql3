--6
select C.City,count(distinct D.ProductID)
from Customers C left join Orders O on C.CustomerID=O.CustomerID left join [Order Details] D on O.OrderID=D.OrderID 
group by C.City
having count(distinct D.ProductID)>=2

--7
select C.CustomerID,C.City,O.ShipCity
from Customers C inner join Orders O on C.CustomerID=O.CustomerID
where C.City !=O.ShipCity

--8
;with BestProduct(ID,num,price) as(select top 5 ProductID,Count(O.OrderID),avg(UnitPrice)
from Orders O left join [Order Details] D on O.OrderID=D.OrderID 
group by ProductID
order by Count(O.OrderID) desc),
BestCity(City,pid,num,rk)as(
select C.City,D.ProductID,sum(D.Quantity),rank() over (partition by D.ProductID order by sum(D.Quantity) DESC)
from Orders O inner join (select * from [Order Details] where ProductID in (select ID from BestProduct))D on O.OrderID=D.OrderID Inner join Customers C on O.CustomerID=C.CustomerID
group by C.City,D.ProductID)
select C.City,C.pid as ProductID,C.num as selledNum,P.price as AvgPrice
from BestCity C left join BestProduct P on C.pid=P.ID
where C.rk=1

--9
--a
select City
from Employees
where City not in (select distinct City from Orders O inner join Customers C on C.CustomerID=O.CustomerID)
--b
Select distinct City
from Employees
except
select distinct City
From Orders O inner join Customers C on C.CustomerID=O.CustomerID

--10

select * from
(select City 
from Employees
where EmployeeID in (select top 1 O.EmployeeID
from Orders O inner join Employees E on O.EmployeeID=E.EmployeeID
group by O.EmployeeID
order by Count(OrderID) DESC))EmpMost 
inner join 
(select Top 1 C.City
from Orders O inner join [Order Details] DD on O.OrderID=DD.OrderID inner join Customers C on O.CustomerID=C.CustomerID
group by C.City
order by sum(DD.Quantity) DESC)MostCity
on EmpMost.City=MostCity.City

--11
/*
you can remove duplication by
union each row
eg:
select *
from table
union
select *
from table


you can also use group by

eg:
select *
from table
group by element1,element2,element3....elementn
*/

--12
/*
select *
from Employee E1 inner left join Employee E2 on E1.empid=E2.mgrid 
where E2.mgrid is null
*/

--13
/*
select *
from
	(select deptname,count(E.empid) as count,rank()over(Order by count(E.empid) DESC) as rk
	from Dept D inner join Employee E on D.dptid=E.deptid
	group by D.deptid)temp
where temp.rk=1
*/

--14
/*
select *
from(
select D.deptname,E.empid,E.salary,dense_rank()over(Partition by deptname order by salary DESC) as rk
from Employee E left join Dept D on E.empid=D.deptid
)temp
where temp.rk<=3
order by deptname DESC, salary DESC
*/