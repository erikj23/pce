
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
  select [CustomerName] = ContactName, City, [Region] = ISNULL(Region, Country), Country from Northwind.dbo.Customers;
go

select * from vCustomersByLocation order by CustomerName;
go

select top 3 * from Northwind.dbo.Orders;
go

-- Question 2: How can you create a view to show a list of customer names, their locations, and the number of orders they have placed (hint: use the count() function)?
-- Call the view vNumberOfCustomerOrdersByLocation.
create or alter view vNumberOfCustomerOrdersByLocation as
  select * from Northwind.dbo.Customers;