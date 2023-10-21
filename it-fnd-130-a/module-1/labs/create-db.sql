/*
// Open the SSMS or ADS and connect to a SQL Server.
// Create a database called Mod01Labs<Your Last Name And First Initial Here> (example: Mod01LabsRootR).
// Change your connection's focus to use the new database with the Use command.
// Create a table called Categories with the columns CategoryID "int" and CategoryName "varchar(100)"
// Insert the values 1 and  'CatA' into the Categories table.
// Select the Category ID and Category Name from the Categories table.
// Update the value 'CatA' to 'CategoryA' in the Categories table.
// Select the Category ID and Category Name from the Categories table.
// Delete row one in the Categories table.
// Select the Category ID and Category Name from the Categoryies table.
*/

if not exists (
  select * from sys.databases where name = 'Mod01LabsMaldonadoE'
) create database Mod01LabsMaldonadoE
go

use Mod01LabsMaldonadoE
go

if not exists (
  select * from information_schema.tables where table_name = 'Categories'
) create table Categories
(
  CategoryID   int,
  CategoryName varchar(100)
)
go

merge Categories as dst
using (
  values (1, 'CatA')
) as src (
  CategoryID,
  CategoryName
)
on (dst.CategoryID = src.CategoryID AND dst.CategoryName = src.CategoryName)
when not matched then
  insert (
    CategoryID,
    CategoryName
  ) values (1, 'CatA');
GO

SELECT CategoryID, CategoryName FROM Categories;
UPDATE Categories SET CategoryName = 'CategoryA' WHERE CategoryID = 1;
GO

SELECT CategoryID, CategoryName FROM Categories;
GO

DELETE TOP(1) FROM Categories;
GO

SELECT CategoryID, CategoryName FROM Categories;
GO
