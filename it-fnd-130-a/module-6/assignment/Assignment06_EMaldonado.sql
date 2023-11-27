--*************************************************************************--
-- Title: Assignment06
-- Author: Erik Maldonado
-- Desc: This file demonstrates how to use Views
-- Change Log: When,Who,What
-- 2017-01-01,Erik Maldonado,Created File
--**************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment06DB_EMaldonado')
	 Begin
	  Alter Database [Assignment06DB_EMaldonado] set Single_user With Rollback Immediate;
	  Drop Database Assignment06DB_EMaldonado;
	 End
	Create Database Assignment06DB_EMaldonado;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment06DB_EMaldonado;

-- Create Tables (Module 01)--
drop table if exists Categories;
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL
,[CategoryName] [nvarchar](100) NOT NULL
);
go

drop table if exists Products;
Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL
,[ProductName] [nvarchar](100) NOT NULL
,[CategoryID] [int] NULL
,[UnitPrice] [mOney] NOT NULL
);
go

drop table if exists Employees;
Create Table Employees -- New Table
([EmployeeID] [int] IDENTITY(1,1) NOT NULL
,[EmployeeFirstName] [nvarchar](100) NOT NULL
,[EmployeeLastName] [nvarchar](100) NOT NULL
,[ManagerID] [int] NULL
);
go

drop table if exists Inventories;
Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[EmployeeID] [int] NOT NULL -- New Column
,[ProductID] [int] NOT NULL
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) --
Begin  -- Categories
	Alter Table Categories
	 Add Constraint pkCategories
	  Primary Key (CategoryId);

	Alter Table Categories
	 Add Constraint ukCategories
	  Unique (CategoryName);
End
go

Begin -- Products
	Alter Table Products
	 Add Constraint pkProducts
	  Primary Key (ProductId);

	Alter Table Products
	 Add Constraint ukProducts
	  Unique (ProductName);

	Alter Table Products
	 Add Constraint fkProductsToCategories
	  Foreign Key (CategoryId) References Categories(CategoryId);

	Alter Table Products
	 Add Constraint ckProductUnitPriceZeroOrHigher
	  Check (UnitPrice >= 0);
End
go

Begin -- Employees
	Alter Table Employees
	 Add Constraint pkEmployees
	  Primary Key (EmployeeId);

	Alter Table Employees
	 Add Constraint fkEmployeesToEmployeesManager
	  Foreign Key (ManagerId) References Employees(EmployeeId);
End
go

Begin -- Inventories
	Alter Table Inventories
	 Add Constraint pkInventories
	  Primary Key (InventoryId);

	Alter Table Inventories
	 Add Constraint dfInventoryDate
	  Default GetDate() For InventoryDate;

	Alter Table Inventories
	 Add Constraint fkInventoriesToProducts
	  Foreign Key (ProductId) References Products(ProductId);

	Alter Table Inventories
	 Add Constraint ckInventoryCountZeroOrHigher
	  Check ([Count] >= 0);

	Alter Table Inventories
	 Add Constraint fkInventoriesToEmployees
	  Foreign Key (EmployeeId) References Employees(EmployeeId);
End
go

-- Adding Data (Module 04) --
Insert Into Categories
(CategoryName)
Select CategoryName
 From Northwind.dbo.Categories
 Order By CategoryID;
go

Insert Into Products
(ProductName, CategoryID, UnitPrice)
Select ProductName,CategoryID, UnitPrice
 From Northwind.dbo.Products
  Order By ProductID;
go

Insert Into Employees
(EmployeeFirstName, EmployeeLastName, ManagerID)
Select E.FirstName, E.LastName, IsNull(E.ReportsTo, E.EmployeeID)
 From Northwind.dbo.Employees as E
  Order By E.EmployeeID;
go

Insert Into Inventories
(InventoryDate, EmployeeID, ProductID, [Count])
Select '20170101' as InventoryDate, 5 as EmployeeID, ProductID, UnitsInStock
From Northwind.dbo.Products
UNIOn
Select '20170201' as InventoryDate, 7 as EmployeeID, ProductID, UnitsInStock + 10 -- Using this is to create a made up value
From Northwind.dbo.Products
UNIOn
Select '20170301' as InventoryDate, 9 as EmployeeID, ProductID, UnitsInStock + 20 -- Using this is to create a made up value
From Northwind.dbo.Products
Order By 1, 2
go

-- Show the Current data in the Categories, Products, and Inventories Tables
Select * From Categories;
go
Select * From Products;
go
Select * From Employees;
go
Select * From Inventories;
go

/********************************* Questions and Answers *********************************/
print
'NOTES------------------------------------------------------------------------------------
 1) You can use any name you like for you views, but be descriptive and consistent
 2) You can use your working code from assignment 5 for much of this assignment
 3) You must use the BASIC views for each table after they are created in Question 1
------------------------------------------------------------------------------------------'
go
-- Question 1 (5% pts): How can you create BACIC views to show data from each table in the database.
-- NOTES: x) Do not use a *, list out each column!
--        2) Create one view per table!
--		    3) Use SchemaBinding to protect the views from being orphaned!

create or alter view vCategories with schemabinding as
	select
			[ID]   = CategoryID,
			[Name] = CategoryName
		from dbo.Categories;
go

create or alter view vProducts with schemabinding as
	select
			[ID] 			   = ProductID,
			[Name] 		   = ProductName,
			[Price]      = UnitPrice,
			[CategoryFK] = CategoryID
		from dbo.Products;
go

create or alter view vEmployees with schemabinding as
	select
			[ID]        = EmployeeID,
			[Name]      = EmployeeFirstName + ' ' + EmployeeLastName,
			[ManagerFK] = ManagerID
		from dbo.Employees;
go

create or alter view vInventories with schemabinding as
	select
			[ID]         = InventoryID,
			[Date]       = InventoryDate,
			[Units]      = [Count],
			[EmployeeFK] = EmployeeID,
			[ProductFK]  = ProductID
		from dbo.Inventories;
go

-- Question 2 (5% pts): How can you set permissions, so that the public group CANNOT select data
-- from each table, but can select data from each view?
deny select on Categories to public;
grant select on vCategories to public;

deny select on Products to public;
grant select on vProducts to public;

deny select on Employees to public;
grant select on vEmployees to public;

deny select on Inventories to public;
grant select on vInventories to public;

go

-- Question 3 (10% pts): How can you create a view to show a list of Category and Product names,
-- and the price of each product?
-- Order the result by the Category and Product!
create or alter view vProductsByCategories with schemabinding as
	select top 10000
			[CategoryName] = Category.Name,
			[ProductName]	 = Product.Name,
			[UnitPrice]		 = Product.Price
		from dbo.vCategories [Category]
		join dbo.vProducts   [Product]
			on Category.ID = Product.CategoryFK
		order by Category.Name, Product.Name
go

grant select on vProductsByCategories to public;
go

-- Question 4 (10% pts): How can you create a view to show a list of Product names
-- and Inventory Counts on each Inventory Date?
-- Order the results by the Product, Date, and Count!
create or alter view vInventoriesByProductsByDates with schemabinding as
	select top 10000
			[ProductName]   = Product.Name,
			[InventoryDate]	= Inventory.Date,
			[Count]		 	    = Inventory.Units
		from dbo.vProducts    [Product]
		join dbo.vInventories [Inventory]
			on Product.ID = Inventory.ProductFK
		order by Product.Name, Inventory.Date, Inventory.Units
go

grant select on vInventoriesByProductsByDates to public;
go

-- Question 5 (10% pts): How can you create a view to show a list of Inventory Dates
-- and the Employee that took the count?
-- Order the results by the Date and return only one row per date!
create or alter view vInventoriesByEmployeesByDates with schemabinding as
	select distinct top 10000 
			[InventoryDate]	= Inventory.Date,
			[EmployeeName]	= Employee.Name
		from dbo.vEmployees		[Employee]
		join dbo.vInventories [Inventory]
			on Employee.ID = Inventory.EmployeeFK
		order by Inventory.Date
go

grant select on vInventoriesByEmployeesByDates to public;
go

-- Here is are the rows selected from the view:

-- InventoryDate	EmployeeName
-- 2017-01-01	    Steven Buchanan
-- 2017-02-01	    Robert King
-- 2017-03-01	    Anne Dodsworth

-- Question 6 (10% pts): How can you create a view show a list of Categories, Products,
-- and the Inventory Date and Count of each product?
-- Order the results by the Category, Product, Date, and Count!
create or alter view vInventoriesByProductsByCategories with schemabinding as
	select top 10000
			[CategoryName]  = Category.Name,
			[ProductName]   = Product.Name,
			[InventoryDate]	= Inventory.Date,
			[Count]				  = Inventory.Units
		from dbo.vCategories  [Category]
		join dbo.vProducts    [Product]
			on Category.ID = Product.CategoryFK
		join dbo.vInventories [Inventory]
			on Product.ID = Inventory.ProductFK
		order by Category.Name, Product.Name, Inventory.Date, Inventory.Units
go

grant select on vInventoriesByProductsByCategories to public;
go

-- Question 7 (10% pts): How can you create a view to show a list of Categories, Products,
-- the Inventory Date and Count of each product, and the EMPLOYEE who took the count?
-- Order the results by the Inventory Date, Category, Product and Employee!
create or alter view vInventoriesByProductsByEmployees with schemabinding as
	select top 10000
			[CategoryName]  = Category.Name,
			[ProductName]   = Product.Name,
			[InventoryDate]	= Inventory.Date,
			[Count]				  = Inventory.Units,
			[EmployeeName]  = Employee.Name
		from dbo.vCategories  [Category]
		join dbo.vProducts    [Product]
			on Category.ID = Product.CategoryFK
		join dbo.vInventories [Inventory]
			on Product.ID = Inventory.ProductFK
		join dbo.vEmployees 	[Employee]
			on Employee.ID = Inventory.EmployeeFK
		order by Inventory.Date, Category.Name, Product.Name, Employee.Name
go

grant select on vInventoriesByProductsByEmployees to public;
go

-- Question 8 (10% pts): How can you create a view to show a list of Categories, Products,
-- the Inventory Date and Count of each product, and the Employee who took the count
-- for the Products 'Chai' and 'Chang'?
create or alter view vInventoriesForChaiAndChangByEmployees with schemabinding as
	select top 10000
			[CategoryName]  = Category.Name,
			[ProductName]   = Product.Name,
			[InventoryDate]	= Inventory.Date,
			[Count]				  = Inventory.Units,
			[EmployeeName]  = Employee.Name
		from dbo.vCategories  [Category]
		join dbo.vProducts    [Product]
			on Category.ID = Product.CategoryFK
		join dbo.vInventories [Inventory]
			on Product.ID = Inventory.ProductFK
		join dbo.vEmployees 	[Employee]
			on Employee.ID = Inventory.EmployeeFK
		where Product.Name = 'Chai' or Product.Name = 'Chang'
		order by Inventory.Date, Category.Name, Product.Name, Employee.Name
go

grant select on vInventoriesForChaiAndChangByEmployees to public;
go

-- Question 9 (10% pts): How can you create a view to show a list of Employees and the Manager who manages them?
-- Order the results by the Manager's name!
create or alter view vEmployeesByManager with schemabinding as
	select top 10000 
			[Manager]  = Manager.Name,
			[Employee] = Employee.Name
		from dbo.vEmployees [Employee]
		join dbo.vEmployees [Manager]
		 	on Manager.ID = Employee.ManagerFK
		order by Manager.Name
go

grant select on vEmployeesByManager to public;
go

-- Question 10 (20% pts): How can you create one view to show all the data from all four
-- BASIC Views? Also show the Employee's Manager Name and order the data by
-- Category, Product, InventoryID, and Employee.
create or alter view vInventoriesByProductsByCategoriesByEmployees with schemabinding as
	select top 10000
			[CategoryID]	  = Category.ID,
			[CategoryName]  = Category.Name,
			[ProductID]	    = Product.ID,
			[ProductName]   = Product.Name,
			[UnitPrice]		  = Product.Price,
			[InventoryID]  	= Inventory.ID,
			[InventoryDate]	= Inventory.Date,
			[Count]				  = Inventory.Units,
			[EmployeeID]		= Employee.ID,
			[Employee]      = Employee.Name,
			[Manager]				= Manager.Name
		from dbo.vCategories  [Category]
		join dbo.vProducts    [Product]
			on Category.ID = Product.CategoryFK
		join dbo.vInventories [Inventory]
			on Product.ID = Inventory.ProductFK
		join dbo.vEmployees 	[Employee]
			on Employee.ID = Inventory.EmployeeFK
		join dbo.vEmployees   [Manager]
			on Manager.ID  = Employee.ManagerFK
		order by Category.Name, Product.Name, Inventory.ID, Employee.Name
go

grant select on vInventoriesByProductsByCategoriesByEmployees to public;
go

-- Test your Views (NOTE: You must change the your view names to match what I have below!)
Print 'Note: You will get an error until the views are created!'
Select * From [dbo].[vCategories]
Select * From [dbo].[vProducts]
Select * From [dbo].[vInventories]
Select * From [dbo].[vEmployees]

Select * From [dbo].[vProductsByCategories]
Select * From [dbo].[vInventoriesByProductsByDates]
Select * From [dbo].[vInventoriesByEmployeesByDates]
Select * From [dbo].[vInventoriesByProductsByCategories]
Select * From [dbo].[vInventoriesByProductsByEmployees]
Select * From [dbo].[vInventoriesForChaiAndChangByEmployees]
Select * From [dbo].[vEmployeesByManager]
Select * From [dbo].[vInventoriesByProductsByCategoriesByEmployees]

/***************************************************************************************/