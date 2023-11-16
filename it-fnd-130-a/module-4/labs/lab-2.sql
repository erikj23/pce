--*************************************************************************--
-- Title: Mod04 Labs Database
-- Author: YourNameHere
-- Desc: This file demonstrates how to process data in a database
-- Change Log: When,Who,What
-- 2021-01-01,YourNameHere,Created File
--**************************************************************************--
Use Master;
go

If Exists(Select Name from SysDatabases Where Name = 'MyLabsDB_EMaldonado')
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
  [CategoryID] [int] NOT NULL,
  [UnitPrice] [money] NOT NULL
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

-- Question 1: How would you add data to the Categories table?
begin try
  begin transaction 
    insert into Categories (CategoryName)
      values ('CatA');
  commit transaction
end try
begin catch
  if @@trancount > 0 rollback transaction
  print 'failed insert into Categories'
end catch
go

select * from Categories;
go

-- Question 2: How would you add data to the Products table?
begin try
  begin transaction
    insert into Products (CategoryID, ProductName, UnitPrice)
      values ((select CategoryID from Categories where CategoryName = 'CatA'), 'ProdA', 1.99)
  commit transaction
end try
begin catch
  if @@trancount > 0 rollback transaction
  print 'failed insert into Products'
end catch
go

select * from Products
go

-- Question 3: How would you update data in the Products table?
begin try
  begin transaction
    update Products set UnitPrice = 10.00 where ProductName = 'ProdA'
  commit transaction
end try
begin catch
  if @@trancount > 0 rollback transaction
  print 'failed update Products'
end catch
go

select * from Products
go

-- Question 4: How would you delete data from the Categories table?
begin try
  begin transaction
    delete from Products where CategoryID = (
      select CategoryID from Categories where CategoryName = 'CatA'
    )
    delete from Categories where CategoryName = 'CatA'
  commit transaction
end try
begin catch
  if @@trancount > 0 rollback transaction
  print Error_Message()
end catch
go

select * from Categories
go
