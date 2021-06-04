-- que 1
select CompanyName 
from customers 
where CustomerID NOT IN (select distinct(CustomerID) from orders);

-- que 2
select FirstName,LastName 
from employees 
where EmployeeID not in (select distinct(EmployeeID) from orders);

-- que 3
select c.CompanyName 
	from orders o join customers c on o.CustomerID = c.CustomerID
	group by c.CompanyName
    having count(o.OrderID)  = (
			select max(countView.orderCount) 
			from (
				select c.CompanyName ,count(o.OrderID) orderCount
				from orders o join customers c on o.CustomerID = c.CustomerID
				group by c.CompanyName) as countView);
                
-- que 4
select s.CompanyName
from products p join categories c on p.CategoryID = c.CategoryID
		join suppliers s on p.SupplierID = s.SupplierID
	where c.CategoryName = 'Seafood'
	group by s.SupplierID
    having count(p.ProductID) = (
				select max(supplyCountView.productCount) from (
					select count(p.ProductID) productCount ,s.SupplierID,s.CompanyName
					from products p join categories c on p.CategoryID = c.CategoryID
						join suppliers s on p.SupplierID = s.SupplierID
					where c.CategoryName = 'Seafood'
					group by s.SupplierID) as supplyCountView);

-- que 5
select productName
from products 
where Discontinued = 'n' and UnitPrice = (
											select max(UnitPrice) 
                                            from products
                                            where Discontinued = 'n');
                                            
-- que 7
select CompanyName from shippers where ShipperID = (
	select ShipVia from orders group by ShipVia having count(OrderID) = (
		select max(vt.orderCount)
		from (
			select ShipVia,count(OrderID) orderCount 
            from orders 
            group by ShipVia
            ) as vt)
    ) order by CompanyName;
    
-- que 8
select ContactName, concat(left(CompanyName,4),left(ContactName,4)) as username,
concat(right(CompanyName,4),'@123') as new_password
from customers;

-- que 9
select p.ProductName, od.ProductID, max(od.UnitPrice) as highest_unit_price 
from products p join order_details od
on p.ProductID=od.ProductID
group by ProductID;

-- que 10
select companyname 
from suppliers 
where supplierid not in (
						select supplierid from products); 
                        
-- que 11
select concat(e.FirstName,' ',e.LastName) as full_name 
from categories c join products p on c.CategoryID = p.CategoryID
	join order_details od on p.ProductID = od.ProductID
	join orders o on od.OrderID = o.OrderID
	join employees e on o.EmployeeID = e.EmployeeID
where c.CategoryName = 'Seafood' 
group by e.EmployeeID 
having count(o.OrderID) = (
	select max(vt.orderCount) from (
	select e.FirstName, e.EmployeeID, count(o.OrderID) as orderCount
	from categories c join products p on c.CategoryID = p.CategoryID
		join order_details od on p.ProductID = od.ProductID
		join orders o on od.OrderID = o.OrderID
		join employees e on o.EmployeeID = e.EmployeeID
	where c.CategoryName = 'Seafood' group by e.EmployeeID ) as vt);
    
-- que 12
select ProductName,ProductID from products where ProductID not in (
select ProductID from order_details);

-- que 13
select c.CategoryName , count(p.ProductID) num_of_products_available
from categories c join products p 
	on c.CategoryID = p.CategoryID
group by c.CategoryID; 

-- que 14
select s.CompanyName 
from suppliers s join products p on s.SupplierID = p.SupplierID
	join order_details od on p.ProductID = od.ProductID
    join orders o on od.OrderID = o.OrderID 
where od.OrderID = (
					select OrderID 
					from orders 
					where Freight = (select min(Freight) 
									from orders));

-- que 15 
select City ,count(CustomerID) 
from customers 
group by city 
order by city desc;

-- que 16
select p.ProductName,p.UnitsInStock ,s.CompanyName
from products p join suppliers s on p.SupplierID = s.SupplierID
where UnitsInStock < ReorderLevel and UnitsOnOrder = 0
order by p.UnitsInStock ;