----------------------------------------------------------------------
-- Title: Assignment01
-- Desc: Creating a normalized database from sample data
-- Author: ErikMaldonado
-- ChangeLog: (When,Who,What)
-- 9/21/2021,RRoot,Created Script
-- TODO: 2023-10-18,Erik Maldonado,Completed Script
----------------------------------------------------------------------

--[ Create the Database ]--
--********************************************************************--
Use Master;
go
If exists (Select *
From sysdatabases
Where name='Assignment01DB_ErikMaldonado') -- See if the database already exists
  Begin
  Use [master];
  Alter Database Assignment01DB_ErikMaldonado Set Single_User With Rollback Immediate;
  -- If so, remove everyone from the DB
  Drop Database Assignment01DB_ErikMaldonado;
-- then drop the database.
End
go
Create Database Assignment01DB_ErikMaldonado; -- Now, make or remake the database
go
Use Assignment01DB_ErikMaldonado; -- and start using it.
go

--[ Create the Tables ]--
--********************************************************************--

/*
-- TODO: Create Multiple tables to hold the following data --
-- Code Hint: Create Table Example(Col1 int, Col2 nvarchar(100));
-- Data:
    Products,Price,Units,Customer,Address,Date
    Apples,$0.89,12,Bob Smith,123 Main Bellevue Wa,5/5/2006
    Milk,$1.59,2,Bob Smith,123 Main Bellevue Wa,5/5/2006
    Bread,$2.28,1,Bob Smith,123 Main Bellevue Wa,5/5/2006

*/

create or alter function SubTotal(@sale_id int)
returns money as
  begin
    return (
      select sum (price * units) as sub_total from (
        select (
          select price
          from Products
          where id = product_id
        ) as price, units
        from ProductsAndSales
        where sale_id = @sale_id
      ) as Sale
    )
  end
go

drop table if exists Sales
create table Sales (
  [id] int primary key,
  [customer_id] int not null,
  [date] date not null,
  [sub_total] as [dbo].[SubTotal](id),
)
go

drop table if exists Products
create table Products (
  [id] int primary key,
  [name] text not null,
  [price] money not null,
)
go

drop table if exists Streets
create table Streets (
  [id] int primary key,
  [name] text not null,
)
go

drop table if exists Cities
create table Cities (
  [id] int primary key,
  [name] text not null,
)
go

drop table if exists States
create table States (
  [id] int primary key,
  [code] varchar(2) not null,
)
go

drop table if exists Addresses
create table Addresses (
  [id] int primary key,
  [street_id] int not null,
  [unit] text,
  [city_id] int not null,
  [state_id] int not null,
)
go

drop table if exists Customers
create table Customers (
  [id] int primary key,
  [first] text not null,
  [last] text not null,
)
go

drop table if exists AddressesAndCustomers
create table AddressesAndCustomers (
  [id] int primary key,
  [customer_id] int not null,
  [address_id] int not null,
)
go

drop table if exists ProductsAndSales
create table ProductsAndSales (
  [id] int primary key,
  [sale_id] int not null,
  [product_id] int not null,
  [units] int not null,
)
go
-- TODO: Insert the provided data to test your design --
-- Code Hint: Insert Into Example(Col1, Col2) Values (1,'Test');
insert into Products values (1, 'Apples', 0.89)
insert into Products values (2, 'Milk', 1.59)
insert into Products values (3, 'Apples', 2.28)
select 'Products' as [table], * from Products
go

insert into Streets values (1, '123 Main')
select 'Streets' as [table], * from Streets
go

insert into Cities values (1, 'Bellevue')
select 'Cities' as [table], * from Cities
go

insert into States values (42, 'Wa')
select 'States' as [table], * from States
go

insert into Addresses values (1, 1, null, 1, 42)
select 'Addresses' as [table], * from Addresses
go

insert into Customers values (1, 'Bob', 'Smith')
select 'Customers' as [table], * from Customers
go

insert into AddressesAndCustomers values (1, 1, 1)
select 'AddressesAndCustomers' as [table], * from AddressesAndCustomers
go

insert into ProductsAndSales values (1, 1, 1, 12)
insert into ProductsAndSales values (2, 1, 2, 2)
insert into ProductsAndSales values (3, 1, 3, 1)
select 'ProductsAndSales' as [table], * from ProductsAndSales
go

insert into Sales values (1, 1, '5/5/2006')
select 'Sales' as [table], * from Sales
go


--[ Review the design ]--
--********************************************************************--
-- Note: This is advanced code and it is NOT expected that you should be able to read it yet.
-- However, you will be able to by the end of the course! :-)
-- Meta Data Query:
With
TablesAndColumns As
(
Select
  [SourceObjectName] = TABLE_CATALOG + '.' + TABLE_SCHEMA + '.' + TABLE_NAME + '.' + COLUMN_NAME
, [IS_NULLABLE]=[IS_NULLABLE]
, [DATA_TYPE] = Case [DATA_TYPE]
                When 'varchar' Then  [DATA_TYPE] + '(' + IIf(DATA_TYPE = 'int','', IsNull(Cast(CHARACTER_MAXIMUM_LENGTH as varchar(10)), '')) + ')'
                When 'nvarchar' Then [DATA_TYPE] + '(' + IIf(DATA_TYPE = 'int','', IsNull(Cast(CHARACTER_MAXIMUM_LENGTH as varchar(10)), '')) + ')'
                When 'money' Then [DATA_TYPE] + '(' + Cast(NUMERIC_PRECISION as varchar(10)) + ',' + Cast(NUMERIC_SCALE as varchar(10)) + ')'
                When 'decimal' Then [DATA_TYPE] + '(' + Cast(NUMERIC_PRECISION as varchar(10)) + ',' + Cast(NUMERIC_SCALE as varchar(10)) + ')'
                When 'float' Then [DATA_TYPE] + '(' + Cast(NUMERIC_PRECISION as varchar(10)) + ',' + Cast(NUMERIC_SCALE as varchar(10)) + ')'
                Else [DATA_TYPE]
                End
, [TABLE_NAME]
, [COLUMN_NAME]
, [ORDINAL_POSITION]
, [COLUMN_DEFAULT]
From Information_Schema.columns
)
,
Constraints As
(
Select
  [SourceObjectName] = TABLE_CATALOG + '.' + TABLE_SCHEMA + '.' + TABLE_NAME + '.' + COLUMN_NAME
, [CONSTRAINT_NAME]
From [INFORMATION_SCHEMA].[CONSTRAINT_COLUMN_USAGE]
)
,
IdentityColumns As
(
Select
  [ObjectName] = object_name(c.[object_id])
, [ColumnName] = c.[name]
, [IsIdentity] = IIF(is_identity = 1, 'Identity', Null)
From sys.columns as c Join Sys.tables as t on c.object_id = t.object_id
)
Select
  TablesAndColumns.[SourceObjectName]
, [IsNullable] = [Is_Nullable]
, [DataType] = [Data_Type]
, [ConstraintName] = IsNull([CONSTRAINT_NAME], 'NA')
, [COLUMN_DEFAULT] = IsNull(IIF([IsIdentity] Is Not Null, 'Identity', [COLUMN_DEFAULT]), 'NA')
--, [ORDINAL_POSITION]
From TablesAndColumns
  Full Join Constraints On TablesAndColumns.[SourceObjectName]= Constraints.[SourceObjectName]
  Full Join IdentityColumns On TablesAndColumns.COLUMN_NAME = IdentityColumns.[ColumnName]
    And TablesAndColumns.Table_NAME = IdentityColumns.[ObjectName]
Where [TABLE_NAME] Not In (Select [TABLE_NAME]
From [INFORMATION_SCHEMA].[VIEWS])
Order By [TABLE_NAME],[ORDINAL_POSITION]
