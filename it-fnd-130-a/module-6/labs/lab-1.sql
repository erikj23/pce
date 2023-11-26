
use Master;
select * from Northwind.Sys.Tables where type = 'u' order by Name;

Begin Try
	If Exists(Select Name From SysDatabases Where Name = 'Mod06Labs_EMaldonado')
	 Begin 
	  Alter Database Mod06Labs_EMaldonado set Single_user With Rollback Immediate;
	  Drop Database Mod06Labs_EMaldonado;
	 End
	Create Database Mod06Labs_EMaldonado;
End Try
Begin Catch
	select [ErrorMessage] = Error_Number();
End Catch
go

use Mod06Labs_EMaldonado;
go

select top 3 * from Northwind.dbo.Customers;
go

-- Question 1: How can you create a view to show a list of customer names and their locations?
-- Use the IsNull() function to display null region names as the name of the customer's country?
-- Call the view vCustomersByLocation.
create or alter view vCustomersByLocation as
  select
      [CustomerName] = CompanyName,
      [City]         = City,
      [Region]       = ISNULL(Region, Country),
      [Country]      = Country
    from Northwind.dbo.Customers;
go

--select * from vCustomersByLocation order by CustomerName;
go

select top 3 * from Northwind.dbo.Orders;
go

-- Question 2: How can you create a view to show a list of customer names, their locations, and the number of orders they have placed (hint: use the count() function)?
-- Call the view vNumberOfCustomerOrdersByLocation.
create or alter view vNumberOfCustomerOrdersByLocation as
  select
      [CustomerName]   = CompanyName, 
      [City]           = City,
      [Region]         = ISNULL(Region, Country),
      [Country]        = Country,
      [NumberOfOrders] = (
        select count(OrderID) from Northwind.dbo.Orders [ord] where ord.CustomerID = cus.CustomerID
      ) 
    from Northwind.dbo.Customers [cus];
go

--select * from vNumberOfCustomerOrdersByLocation order by CustomerName;
go

-- Question 3: How can you create a view to shows a list of customer names, their locations, and the number of orders they have placed (hint: use the count() function) on a given year (hint: use the year() function)?
-- Call the view vNumberOfCustomerOrdersByLocationAndYears.
create or alter view vNumberOfCustomerOrdersByLocationAndYears as
  select
      [CustomerName]   = CompanyName,
      [City]           = City,
      [Region]         = ISNULL(Region, Country),
      [Country]        = Country,
      [NumberOfOrders] = count(OrderID),
      [OrderYear]      = year(OrderDate)  
    from Northwind.dbo.Customers [cus]
    join Northwind.dbo.Orders    [ord]
      on ord.CustomerID = cus.CustomerID
    group by CompanyName, City, Region, Country, year(OrderDate);
go

select * from vNumberOfCustomerOrdersByLocationAndYears order by CustomerName;
go