--*************************************************************************--
-- Title: Assignment04
-- Desc: This file demonstrates how to process data in a database
-- Change Log: When,Who,What
-- 2023-01-01,RRoot,Created File
-- <Date>,<YourNameHere>,Added transaction code
--**************************************************************************--
Use Master;
go

If Exists(Select Name from SysDatabases Where Name = 'Assignment04DB_YourNameHere')
 Begin 
  Alter Database [Assignment04DB_YourNameHere] set Single_user With Rollback Immediate;
  Drop Database Assignment04DB_YourNameHere;
 End
go

Create Database Assignment04DB_YourNameHere;
go

Use Assignment04DB_YourNameHere;
go

-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [money] NOT NULL
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[ProductID] [int] NOT NULL
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Alter Table Categories 
 Add Constraint pkCategories 
  Primary Key (CategoryId);
go

Alter Table Categories 
 Add Constraint ukCategories 
  Unique (CategoryName);
go

Alter Table Products 
 Add Constraint pkProducts 
  Primary Key (ProductId);
go

Alter Table Products 
 Add Constraint ukProducts 
  Unique (ProductName);
go

Alter Table Products 
 Add Constraint fkProductsToCategories 
  Foreign Key (CategoryId) References Categories(CategoryId);
go

Alter Table Products 
 Add Constraint ckProductUnitPriceZeroOrHigher 
  Check (UnitPrice >= 0);
go

Alter Table Inventories 
 Add Constraint pkInventories 
  Primary Key (InventoryId);
go

Alter Table Inventories
 Add Constraint dfInventoryDate
  Default GetDate() For InventoryDate;
go

Alter Table Inventories
 Add Constraint fkInventoriesToProducts
  Foreign Key (ProductId) References Products(ProductId);
go

Alter Table Inventories 
 Add Constraint ckInventoryCountZeroOrHigher 
  Check ([Count] >= 0);
go


-- Show the Current data in the Categories, Products, and Inventories Tables
Select * from Categories;
go
Select * from Products;
go
Select * from Inventories;
go

/********************************* TASKS *********************************/

-- Add the following data to this database.
-- All answers must include the Begin Tran, Commit Tran, and Rollback Tran transaction statements. 
-- All answers must include the Try/Catch blocks around your transaction processing code.
-- Display the Error message if the catch block is invoked.

/* Add the following data to this database:
Beverages	Chai	18.00	2017-01-01	61
Beverages	Chang	19.00	2017-01-01	87
Condiments	Aniseed Syrup	10.00	2017-01-01	19
Condiments	Chef Anton's Cajun Seasoning	22.00	2017-01-01	81
Beverages	Chai	18.00	2017-02-01	13
Beverages	Chang	19.00	2017-02-01	2
Condiments	Aniseed Syrup	10.00	2017-02-01	1
Condiments	Chef Anton's Cajun Seasoning	22.00	2017-02-01	79
Beverages	Chai	18.00	2017-03-02	18
Beverages	Chang	19.00	2017-03-02	12
Condiments	Aniseed Syrup	10.00	2017-03-02	84
Condiments	Chef Anton's Cajun Seasoning	22.00	2017-03-02	72
*/

-- Task 1 (20 pts): Add data to the Categories table
-- TODO: Add Insert Code
go
Select * from Categories;
go

-- Task 2 (20 pts): Add data to the Products table
-- TODO: Add Insert Code
go
Select * from Products;
go

-- Task 3 (20 pts): Add data to the Inventories table
-- TODO: Add Insert Code
go
Select * from Products;
go

-- Task 4 (10 pts): Write code to update the Category "Beverages" to "Drinks"
-- TODO: Add Update Code
go
Select * from Categories;
go


-- Task 5 (30 pts): Write code to delete all Condiments data from the database (in all three tables!)  
-- TODO: Add Delete Code
go
Select * From Inventories;
Select * From Products;
Select * From Categories;
go

/***************************************************************************************/