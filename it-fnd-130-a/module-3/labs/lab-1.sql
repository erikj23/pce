-- View the structure of the database
select top 3 * from Northwind.dbo.Products 

-- Select the Category Id and Category Name of the Category 'Seafood'.
select CategoryID, CategoryName from Northwind.dbo.Categories where CategoryName = 'Seafood'