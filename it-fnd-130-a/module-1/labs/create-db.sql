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

IF NOT EXISTS (
  SELECT * FROM sys.databases WHERE name = 'Mod01LabsMaldonadoE'
) CREATE DATABASE Mod01LabsMaldonadoE
GO

USE Mod01LabsMaldonadoE
GO

IF NOT EXISTS (
  SELECT * FROM information_schema.tables WHERE table_name = 'Categories'
) CREATE TABLE Categories
(
  CategoryID   int,
  CategoryName varchar(100)
)
GO

MERGE Categories as dst
USING (
  VALUES (
    1, 'CatA'
  )
) as src (
  CategoryID,
  CategoryName
)
ON (dst.CategoryID = src.CategoryID AND dst.CategoryName = src.CategoryName)
WHEN NOT MATCHED THEN
  INSERT (
    CategoryID,
    CategoryName
  ) 
  VALUES (
    1, 'CatA'
  );
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
