-- Select the Product Id, Product Name, and Product Price of all Products with the Seafood's Category Id.
-- Ordered by the highest to the lowest products price. 
-- select top 3 * from Northwind.dbo.Products -- view the structure of the database
select ProductID, ProductName, UnitPrice * UnitsInStock [ProductPrice]
  from Northwind.dbo.Products
  where CategoryID = (
    select CategoryID
    from Northwind.dbo.Categories
    where CategoryName = 'Seafood'
  )
  order by ProductPrice desc

-- Select the product Id, product name, and product price ordered by the products price highest to the lowest. 
-- Show only the products that have a price greater than $100.
select ProductID, ProductName, UnitPrice
  from Northwind.dbo.Products
  where UnitPrice > 100
  order by UnitPrice desc