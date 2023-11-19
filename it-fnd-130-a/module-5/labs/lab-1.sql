use Northwind;
go

-- Step 1: Review Database Tables using the following code in a SQL query editor and review the names of the tables you have to work with.
select * from Northwind.Sys.Tables where type = 'u' order by Name;

-- Step 2: Answer the following questions by writing and executing SQL code.

-- Question 1: How can you show a list of category names? Order the result by the category!
select CategoryName from Categories order by CategoryName;

-- Question 2: How can you show a list of product names and the price of each product? Order the result by the product!
select ProductName, UnitPrice from Products order by ProductName;

-- Question 3: How can you show a list of category and product names, and the price of each product? Order the result by the category and product!
select CategoryName, ProductName, UnitPrice
  from Products as pro
  inner join Categories as cat
    on pro.CategoryID = cat.CategoryID
  order by CategoryName, ProductName;
go