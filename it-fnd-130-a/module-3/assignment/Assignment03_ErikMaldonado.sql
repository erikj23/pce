--*************************************************************************--
-- Title: Assignment03 
-- Desc: This script demonstrates the creation of a typical database with:
--       1) Tables
--       2) Constraints
--       3) Views
-- Dev: ErikMaldonado
-- Change Log: When,Who,What
-- 9/21/2021,ErikMaldonado,Created File
-- TODO: 9/21/2021,ErikMaldonado,Completed File
--**************************************************************************--

--[ Create the Database ]--
--********************************************************************--
Use Master;
go
If exists (Select *
From sysdatabases
Where name='Assignment03DB_ErikMaldonado')
  Begin
	Use [master];
	Alter Database Assignment03DB_ErikMaldonado Set Single_User With Rollback Immediate;
	-- Kick everyone out of the DB
	Drop Database Assignment03DB_ErikMaldonado;
End
go
Create Database Assignment03DB_ErikMaldonado;
go
Use Assignment03DB_ErikMaldonado
go

--[ Create the Tables ]--
--********************************************************************--
Create Table Categories
(
	[CategoryID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
(
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[ProductName] [nvarchar](100) NOT NULL,
	[ProductCurrentPrice] [money] NULL,
	[CategoryID] [int] NOT NULL
);
go

Create Table Inventories
(
	[InventoryID] [int] IDENTITY(1,1) NOT NULL,
	[InventoryDate] [Date] NOT NULL,
	[InventoryCount] [int] NOT NULL,
	[ProductID] [int] NOT NULL
);
go

--[ Add Addtional Constaints ]--
--********************************************************************--
ALTER TABLE dbo.Categories
	ADD CONSTRAINT pkCategories PRIMARY KEY CLUSTERED (CategoryID);
go
ALTER TABLE dbo.Categories 
	ADD CONSTRAINT uCategoryName UNIQUE NonCLUSTERED (CategoryName);
go

ALTER TABLE dbo.Products
	ADD CONSTRAINT pkProducts PRIMARY KEY CLUSTERED (ProductID);
go
ALTER TABLE dbo.Products
	ADD CONSTRAINT uProductName UNIQUE NonCLUSTERED (ProductName);
go
ALTER TABLE dbo.Products  
	ADD CONSTRAINT fkProductsCategories  
		FOREIGN KEY (CategoryID)
		REFERENCES dbo.Categories (CategoryID);
go
ALTER TABLE dbo.Products  
	ADD CONSTRAINT pkProductsProductCurrentPriceMoreThanZero CHECK (ProductCurrentPrice > 0);
go

ALTER TABLE dbo.Inventories
	ADD CONSTRAINT pkInventories PRIMARY KEY CLUSTERED (InventoryID);
go
ALTER TABLE dbo.Inventories  
	ADD CONSTRAINT fkInventoriesProducts
		FOREIGN KEY (ProductID)
		REFERENCES dbo.Products (ProductID);
go
ALTER TABLE dbo.Inventories 
	ADD CONSTRAINT ckInventoriesInventoryCountMoreThanZero CHECK (InventoryCount >= 0);
go
ALTER TABLE dbo.Inventories  
	ADD	CONSTRAINT dfInventoriesCountIsZero DEFAULT (0)
	FOR [InventoryCount];
go

--[ Create the Views ]--
--********************************************************************--
Create View vCategories
As
	Select[CategoryID], [CategoryName]
	From Categories;
;
go

Create View vProducts
As
	Select [ProductID], [ProductName], [CategoryID], [ProductCurrentPrice]
	From Products;
;
go

Create View vInventories
As
	Select [InventoryID], [InventoryDate], [ProductID], [InventoryCount]
	From Inventories
;
go

--[Insert Test Data ]--
--********************************************************************--
Insert Into Categories
	(CategoryName)
Select CategoryName
From Northwind.dbo.Categories
Order By CategoryID;
go

Insert Into Products
	(ProductName, CategoryID, ProductCurrentPrice)
Select ProductName, CategoryID, UnitPrice
From Northwind.dbo.Products
Order By ProductID;
go

Insert Into Inventories
	(InventoryDate, ProductID, [InventoryCount])
	Select '20200101' as InventoryDate, ProductID, UnitsInStock
	From Northwind.dbo.Products
UNION
	Select '20200201' as InventoryDate, ProductID, UnitsInStock + 10
	-- Using this is to create a made up value
	From Northwind.dbo.Products
UNION
	Select '20200302' as InventoryDate, ProductID, UnitsInStock + 20
	-- Using this is to create a made up value
	From Northwind.dbo.Products
Order By 1, 2
go

-- Show all of the data in the Categories, Products, and Inventories Tables
select * from vCategories;
go

select * from vProducts;
go

select * from vInventories;
go

/********************************* TODO: Questions and Answers *********************************/

/********************************* Questions and Answers *********************************/

-- Question 1 (5% pts): How can you show the Category ID and Category Name for 'Seafood'?
-- TODO: Add Your Code Here
select CategoryID, CategoryName
	from vCategories
	where CategoryName = 'Seafood'
go

-- Question 2 (5% pts): How can you show the Product ID, Product Name, and Product Price 
-- of all Products with the Seafood's Category Id? With the results ordered By the Products Price
-- highest to the lowest!
-- TODO: Add Your Code Here
select ProductID, ProductName, ProductCurrentPrice
	from vProducts
	where CategoryID = (
		select CategoryID
			from Categories
			where CategoryName = 'Seafood'
	)
	order by ProductCurrentPrice desc
go

-- Question 3 (5% pts):  How can you show the Product ID, Product Name, and Product Price 
-- Ordered By the Products Price highest to the lowest?
-- With only the products that have a price Greater than $100! 
-- TODO: Add Your Code Here
select ProductID, ProductName, ProductCurrentPrice
	from vProducts
	where ProductCurrentPrice > 100
	order by ProductCurrentPrice desc
go

-- Question 4 (10% pts): How can you show the CATEGORY NAME, product name, and Product Price 
-- from both Categories and Products? Order the results by Category Name 
-- and then Product Name, in alphabetical order!
-- (Hint: Join Products to Category)
-- TODO: Add Your Code Here
select cat.CategoryName, pro.ProductName, pro.ProductCurrentPrice
	from vCategories [cat]
	join vProducts   [pro]
		on cat.CategoryID = pro.CategoryID
	order by cat.CategoryName asc, pro.ProductName asc
go

-- Question 5 (5% pts): How can you show the Product ID and Number of Products in Inventory
-- for the Month of JANUARY? Order the results by the ProductIDs! 
-- TODO: Add Your Code Here
select ProductID, InventoryCount, InventoryDate
	from vInventories
	where month(InventoryDate) = 1
	order by ProductID
go

-- Question 6 (10% pts): How can you show the Category Name, Product Name, and Product Price 
-- from both Categories and Products. Order the results by price highest to lowest?
-- Show only the products that have a PRICE FROM $10 TO $20! 
-- TODO: Add Your Code Here
select cat.CategoryName, pro.ProductName, pro.ProductCurrentPrice
	from vCategories [cat]
	join vProducts   [pro]
		on cat.CategoryID = pro.CategoryID
	where pro.ProductCurrentPrice between 10 and 20
	order by pro.ProductCurrentPrice desc
go

-- Question 7 (10% pts) How can you show the Product ID and Number of Products in Inventory
-- for the Month of JANUARY? Order the results by the ProductIDs
-- and where the Product IDs are only in the seafood category!
-- (Hint: Use a subquery to get the list of productIds with a category ID of 8)
-- TODO: Add Your Code Here
select pro.ProductID, inv.InventoryCount
	from vInventories [inv]
	join vProducts    [pro]
		on inv.ProductID = pro.ProductID
	where month(inv.InventoryDate) = 1 and pro.CategoryID = (
		select cat.CategoryID
			from vCategories [cat]
			where cat.CategoryName = 'Seafood'
	)
	order by pro.ProductID
go

-- Question 8 (10% pts) How can you show the PRODUCT NAME and Number of Products in Inventory
-- for January? Order the results by the Product Names
-- and where the ProductID as only the ones in the seafood category!
-- (Hint: Use a Join between Inventories and Products to get the Name)
-- TODO: Add Your Code Here
select pro.ProductName, inv.InventoryCount
	from vInventories [inv]
	join vProducts    [pro]
		on inv.ProductID = pro.ProductID
	where month(inv.InventoryDate) = 1 and pro.CategoryID = (
		select cat.CategoryID
			from vCategories [cat]
			where cat.CategoryName = 'Seafood'
	)
	order by pro.ProductName
go 

-- Question 9 (20% pts) How can you show the Product Name and Number of Products in Inventory
-- for both JANUARY and FEBRUARY? Show what the AVERAGE AMOUNT IN INVENTORY was 
-- and where the ProductID as only the ones in the seafood category
-- and Order the results by the Product Names! 
-- TODO: Add Your Code Here
select pro.ProductName, avg(inv.InventoryCount)[AvgInventory Jan-Feb], sum(inv.InventoryCount)[TotalInventory Jan-Feb] 
	from vInventories [inv]
	join vProducts		[pro]
	 on inv.ProductID = pro.ProductID
	where month(inv.InventoryDate) <= 2 
		and pro.CategoryID = (
			select cat.CategoryID
			from vCategories [cat]
			where cat.CategoryName = 'Seafood'
		)
	group by pro.ProductName
	order by pro.ProductName asc
go

-- Question 10 (20% pts) How can you show the Product Name and Number of Products in Inventory
-- for both JANUARY and FEBRUARY? Show what the AVERAGE AMOUNT IN INVENTORY was 
-- and where the ProductID as only the ones in the seafood category
-- and Order the results by the Product Names! 
-- Restrict the results to rows with a Average COUNT OF 100 OR HIGHER!
-- TODO: Add Your Code Here
select pro.ProductName, avg(inv.InventoryCount)[AvgInventory Jan-Feb], sum(inv.InventoryCount)[TotalInventory Jan-Feb] 
	from vInventories [inv]
	join vProducts		[pro]
	 on inv.ProductID = pro.ProductID
	where month(inv.InventoryDate) <= 2 
		and pro.CategoryID = (
			select cat.CategoryID
			from vCategories [cat]
			where cat.CategoryName = 'Seafood'
		) 
	group by pro.ProductName
		having avg(inv.InventoryCount) >= 100
	order by pro.ProductName asc
go

/***************************************************************************************/
