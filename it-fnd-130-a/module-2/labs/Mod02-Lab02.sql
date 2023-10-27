/***********************************************************
Title: Mod02-Lab02
Dev: RRoot
ChangeLog(When,Who,What)
1/1/30,RRoot,Created Script
*************************************************************/
Use Master;
go

if not exists (
  select * from sys.databases where name = 'Mod2_Lab2_EMaldonado'
) create database [Mod2_Lab2_EMaldonado]
go

use [Mod2_Lab2_EMaldonado];
go

drop table if exists Categories
create table Categories
(
  CategoryID int identity Constraint pkCategories Primary Key,
  CategoryName nvarchar(100) Constraint uqCategoryNameName Unique
)
go

drop table if exists Products
create table Products
(
  ProductID int identity constraint pkProducts primary key,
  ProductName nvarchar(100) Constraint uqProductName not null unique,
  ProductListPrice nvarchar(1000) Constraint ckProductListPriceGTOrEqZero Check (ProductListPrice >= 0),
  CategoryID int constraint fkProductName not null foreign key (CategoryID) 
    references Categories (CategoryID)
    on delete CASCADE
    on update CASCADE
)
go