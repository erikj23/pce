-- View the structure of the database
select top 3 * from Northwind..Categories
select top 3 * from Northwind..Products

-- Select the category name, product name, and product price from both categories and products.
-- Order the results by category name and then product name, in alphabetical order.
-- (Hint: Join Products to Category)
select cat.CategoryName, pro.ProductName, pro.UnitPrice
  from Northwind..Categories [cat]
  join Northwind..Products   [pro]
    on cat.CategoryID = pro.CategoryID
  order by cat.CategoryName asc, pro.ProductName asc

-- Select the Category Name, Product Name, and Product Price from both Categories and Products.
-- Order the results by price highest to lowest.
-- Show only the products that have a price from $10 to $20.
select cat.CategoryName, pro.ProductName, pro.UnitPrice
  from Northwind..Categories [cat]
  join Northwind..Products   [pro]
    on cat.CategoryID = pro.CategoryID
  where pro.UnitPrice between 10 and 20
  order by pro.UnitPrice desc