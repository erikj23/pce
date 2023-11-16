/*
// Open the SSMS or ADS and connect to a SQL Server.
// Use your database called Mod01Labs<Your Last Name And First Initial Here> (example: Mod01LabsRootR).
// Create a table called Products with the columns ProductID "int" ProductName "varchar(100) ", and ProductPrice "money". 
// Insert the values 1, ProductA’, 9.99 into the Products table.
// Insert the values 2, ProductB’, 59.99 into the Products table.
// Select the ProductID, ProductName, and ProductPrice from the Products table.
// Create a table called SalesDetails with the columns SalesID "int", LineItemID "int", ProductID "int", and Qty "int".
// Insert a Sales ID of 1, Line Item of 1, Product ID of 1, and a quantity of 10 into the SalesDetails table.
// Insert a Sales ID of 1, Line Item of 2, Product ID of 2, and a quantity of 1 into the SalesDetails table.
// Select the SalesID, LineItemId, ProductID, and Qty from the SalesDetails table.
*/

if not exists (
  select * from sys.databases where name = 'Mod01LabsMaldonadoE'
) create database Mod01LabsMaldonadoE
go

use Mod01LabsMaldonadoE
go

drop table if exists Products
go

create table Products(
    [id] int primary key,
    [name] text,
    [price] money
)
go

insert into Products values(1, 'ProductA', 9.99)
insert into Products values(2, 'ProductB', 59.99)
select * from Products
go

drop table if exists SalesDetails
go

create table SalesDetails(
    [id] int,
    [line_item_id] int,
    [product_id] int,
    [quantity] int,
    primary key (id, line_item_id, product_id)
)
go

insert into SalesDetails values(1, 1, 1, 10)
insert into SalesDetails values(1, 2, 2, 1)
select * from SalesDetails
go
