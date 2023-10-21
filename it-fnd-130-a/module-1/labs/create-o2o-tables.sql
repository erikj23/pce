/*
// Open the SSMS or ADS and connect to a SQL Server.
// Use your database called Mod01Labs<Your Last Name And First Initial Here> (example: Mod01LabsRootR).
// Create a table called Customers with the columns CustomerID "int" CustomerFirstName "varchar(100) ", and CustomerLastName "varchar(100) ". (We are keeping the table simple for the lab)
// Insert the values 1, 'Bob’, ‘Smith' into the Customers table.
// Select the CustomerID and CustomerLastName from the Customers table.
// Create a table called Sales with the columns SalesID "int", SalesDate "date", and CustomerID " int".
// Insert a Sales ID of 1, Today’s date, and Customer ID 1 into the Sales table.
// Select the SalesID, SalesDate, and CustomerID from the Sales table.
*/
if not exists (
  select * from sys.databases where name = 'Mod01LabsMaldonadoE'
) create database Mod01LabsMaldonadoE
go

use Mod01LabsMaldonadoE;

create table Customers(
  [CustomerID] int primary key,
  [CustomerFirstName] text,
  [CustomerLastName] text,
);
insert into Customers values (1, 'Bob', 'Smith');
go

create table Sales(
  [SalesID] int primary key,
  [SalesDate] date,
  [CustomerID] int,
);

insert into Sales values(1, getdate(), 1);
go