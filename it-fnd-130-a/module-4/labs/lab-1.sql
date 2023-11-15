--*************************************************************************--
-- Title: Lab: Processing Transactions
-- Author: Erik Maldonado
-- Desc: This file demonstrates how to process data in a database
-- Change Log: When,Who,What
-- 2023-11-15, Erik Maldonado, Created File
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
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL,[CategoryName] [nvarchar](100) NOT NULL);
go
Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [money] NOT NULL
);
go


-- Show the Current data in the Categories, Products, and Inventories Tables
Select * from Categories;
go
Select * from Products;
go
