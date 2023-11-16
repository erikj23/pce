--*************************************************************************--
-- Title: Lab: Processing Transactions
-- Author: Erik Maldonado
-- Desc: This file demonstrates how to process data in a database
-- Change Log: When,Who,What
-- 2023-11-15, Erik Maldonado, Created File
--**************************************************************************--
Use Master;
go

If Exists (Select Name from SysDatabases Where Name = 'MyLabsDB_EMaldonado')
 Begin
  Alter Database [MyLabsDB_EMaldonado] set Single_user With Rollback Immediate;
  Drop Database MyLabsDB_EMaldonado;
 End
go

Create Database MyLabsDB_EMaldonado;
go

Use MyLabsDB_EMaldonado;
go

-- Create Tables (Module 01)--
drop table if exists Categories
Create Table Categories
(
  [CategoryID] [int] IDENTITY(1,1) NOT NULL,
  [CategoryName] [nvarchar](100) NOT NULL
);
go

drop table if exists Products
Create Table Products
(
  [ProductID] [int] IDENTITY(1,1) NOT NULL,
  [ProductName] [nvarchar](100) NOT NULL,
  [CategoryID] [int] NULL,
  [UnitPrice] [money] NOT NULL
);
go


-- Show the Current data in the Categories, Products, and Inventories Tables
Select * from Categories;
Select * from Products;
go


-- Question 1: How would you add the data 'CatA' to the Categories table?
insert into Categories (CategoryName)
  values ('CatA')
go

-- Question 2: How would you add the data 'ProdA', for CatA, with a price of $1.99 to the Products table?
insert into Products (CategoryID, ProductName, UnitPrice)
  values ((select CategoryID from Categories where CategoryName = 'CatA'), 'ProdA', 1.99)
go

select * from Categories;
select * from Products;
go

-- Question 3: How would you update the price of ProdA to $10.00 in the Products table?
update Products set UnitPrice = 10.00
  where ProductName = 'ProdA'
go

select * from Products;
go

-- Question 4: How would you delete the CatA data from the Categories table?
delete from Categories
  where CategoryName = 'CatA'
go

select * from Categories;
go
