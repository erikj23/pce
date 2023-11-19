--*************************************************************************--
-- Title: Assignment04
-- Desc: This file demonstrates how to process data in a database
-- Change Log: When,Who,What
-- 2023-01-01, RRoot, Created File
-- 2023-11-18, Erik Maldonado, Added Transaction Code
--**************************************************************************--
Use Master;
go

If Exists(Select Name from SysDatabases Where Name = 'Assignment04DB_ErikMaldonado')
 Begin
  Alter Database [Assignment04DB_ErikMaldonado] set Single_user With Rollback Immediate;
  Drop Database Assignment04DB_ErikMaldonado;
 End
go

Create Database Assignment04DB_ErikMaldonado;
go

Use Assignment04DB_ErikMaldonado;
go

-- Create Tables (Module 01)--
drop table if exists Categories;
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL
,[CategoryName] [nvarchar](100) NOT NULL
);
go

drop table if exists Products;
Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL
,[ProductName] [nvarchar](100) NOT NULL
,[CategoryID] [int] NULL
,[UnitPrice] [money] NOT NULL
);
go

drop table if exists Inventories;
Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[ProductID] [int] NOT NULL
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) --
Alter Table Categories
 Add Constraint pkCategories
  Primary Key (CategoryId);
go

Alter Table Categories
 Add Constraint ukCategories
  Unique (CategoryName);
go

Alter Table Products
 Add Constraint pkProducts
  Primary Key (ProductId);
go

Alter Table Products
 Add Constraint ukProducts
  Unique (ProductName);
go

Alter Table Products
 Add Constraint fkProductsToCategories
  Foreign Key (CategoryId) References Categories(CategoryId)
    on delete cascade;
go

Alter Table Products
 Add Constraint ckProductUnitPriceZeroOrHigher
  Check (UnitPrice >= 0);
go

Alter Table Inventories
 Add Constraint pkInventories
  Primary Key (InventoryId);
go

Alter Table Inventories
 Add Constraint dfInventoryDate
  Default GetDate() For InventoryDate;
go

Alter Table Inventories
 Add Constraint fkInventoriesToProducts
  Foreign Key (ProductId) References Products(ProductId)
    on delete cascade;
go

Alter Table Inventories
 Add Constraint ckInventoryCountZeroOrHigher
  Check ([Count] >= 0);
go


-- Show the Current data in the Categories, Products, and Inventories Tables
Select * from Categories;
go
Select * from Products;
go
Select * from Inventories;
go

/************* FUNCTIONS *************/
create or alter function SelectCategoryID (
  @CategoryName [nvarchar](100)
) returns int as begin
  return (
    select CategoryID from Categories where CategoryName = @CategoryName
  )
end
go

create or alter function SelectProductID (
  @ProductName [nvarchar](100)
) returns int as begin
  return (
    select ProductID from Products where ProductName = @ProductName
  )
end
go

/************* PROCEDURES *************/
create proc ProcedureInsertCategory (
  @CategoryName [nvarchar](100)
) as begin
  begin try
    begin transaction
      insert into Categories (
        CategoryName
      ) values (
        @CategoryName
      );
    commit transaction
  end try
  begin catch
    select error_line() as ErrorLine, error_message() AS ErrorMessage;
    if @@trancount > 0 rollback transaction
  end catch
end
go

create proc ProcedureDeleteCategory (
  @CategoryName [nvarchar](100)
) as begin -- added on delete cascade to fk references
  begin try
    begin transaction
      delete from Categories where CategoryID = dbo.SelectCategoryID(@CategoryName);
    commit transaction
  end try
  begin catch
    select error_line() as ErrorLine, error_message() AS ErrorMessage;
    if @@trancount > 0 rollback transaction
  end catch
end
go

create proc ProcedureUpdateCategoryName (
  @CategoryName    [nvarchar](100),
  @NewCategoryName [nvarchar](100)
) as begin
  begin try
    begin transaction
      update Categories set CategoryName = @NewCategoryName where CategoryID = dbo.SelectCategoryID(@CategoryName)
    commit transaction
  end try
  begin catch
    select error_line() as ErrorLine, error_message() AS ErrorMessage;
    if @@trancount > 0 rollback transaction
  end catch
end
go

create proc ProcedureInsertProduct (
  @ProductName  [nvarchar](100),
  @CategoryName [nvarchar](100),
  @UnitPrice    [money]
) as begin
  begin try
    begin transaction
      insert into Products (
        ProductName, CategoryID, UnitPrice
      ) values (
        @ProductName, dbo.SelectCategoryID(@CategoryName) , @UnitPrice
      );
    commit transaction
  end try
  begin catch
    select error_line() as ErrorLine, error_message() AS ErrorMessage;
    if @@trancount > 0 rollback transaction
  end catch
end
go

create proc ProcedureInsertInventory (
  @InventoryDate [date],
  @ProductName   [nvarchar](100),
  @Count         [int]
) as begin
  begin try
    begin transaction
      insert into Inventories (
        InventoryDate, ProductID, Count
      ) values (
        @InventoryDate, dbo.SelectProductID(@ProductName), @Count
      );
    commit transaction
  end try
  begin catch
    select error_line() as ErrorLine, error_message() AS ErrorMessage;
    if @@trancount > 0 rollback transaction
  end catch
end
go

/********************************* TASKS *********************************/

-- Add the following data to this database.
-- All answers must include the Begin Tran, Commit Tran, and Rollback Tran transaction statements.
-- All answers must include the Try/Catch blocks around your transaction processing code.
-- Display the Error message if the catch block is invoked.

/* Add the following data to this database:
Beverages	Chai	18.00	2017-01-01	61
Beverages	Chang	19.00	2017-01-01	87
Condiments	Aniseed Syrup	10.00	2017-01-01	19
Condiments	Chef Anton's Cajun Seasoning	22.00	2017-01-01	81
Beverages	Chai	18.00	2017-02-01	13
Beverages	Chang	19.00	2017-02-01	2
Condiments	Aniseed Syrup	10.00	2017-02-01	1
Condiments	Chef Anton's Cajun Seasoning	22.00	2017-02-01	79
Beverages	Chai	18.00	2017-03-02	18
Beverages	Chang	19.00	2017-03-02	12
Condiments	Aniseed Syrup	10.00	2017-03-02	84
Condiments	Chef Anton's Cajun Seasoning	22.00	2017-03-02	72
*/

-- Task 1 (20 pts): Add data to the Categories table
-- TODO: Add Insert Code
exec ProcedureInsertCategory
  @CategoryName = 'Beverages';

exec ProcedureInsertCategory
  @CategoryName = 'Condiments';
go

select * from Categories;
go

-- Task 2 (20 pts): Add data to the Products table
-- TODO: Add Insert Code
exec ProcedureInsertProduct
  @ProductName  = 'Chai',
  @CategoryName = 'Beverages',
  @UnitPrice    = 18.00;

exec ProcedureInsertProduct
  @ProductName  = 'Chang',
  @CategoryName = 'Beverages',
  @UnitPrice    = 19.00;

exec ProcedureInsertProduct
  @ProductName  = 'Aniseed Syrup',
  @CategoryName = 'Condiments',
  @UnitPrice    = 10.00;

exec ProcedureInsertProduct
  @ProductName  = "Chef Anton's Cajun Seasoning",
  @CategoryName = 'Condiments',
  @UnitPrice    = 22.00;
go

select * from Products;
go

-- Task 3 (20 pts): Add data to the Inventories table
-- TODO: Add Insert Code

declare @InventoryCatalogDate date;
set @InventoryCatalogDate = '2017-01-01';

exec ProcedureInsertInventory
  @InventoryDate = @InventoryCatalogDate,
  @ProductName   = 'Chai',
  @Count         = 61;

exec ProcedureInsertInventory
  @InventoryDate = @InventoryCatalogDate,
  @ProductName   = 'Chang',
  @Count         = 87;

exec ProcedureInsertInventory
  @InventoryDate = @InventoryCatalogDate,
  @ProductName   = 'Aniseed Syrup',
  @Count         = 19;

exec ProcedureInsertInventory
  @InventoryDate = @InventoryCatalogDate,
  @ProductName   = "Chef Anton's Cajun Seasoning",
  @Count         = 81;

go

declare @InventoryCatalogDate date;
set @InventoryCatalogDate = '2017-02-01';

exec ProcedureInsertInventory
  @InventoryDate = @InventoryCatalogDate,
  @ProductName   = 'Chai',
  @Count         = 13;

exec ProcedureInsertInventory
  @InventoryDate = @InventoryCatalogDate,
  @ProductName   = 'Chang',
  @Count         = 2;

exec ProcedureInsertInventory
  @InventoryDate = @InventoryCatalogDate,
  @ProductName   = 'Aniseed Syrup',
  @Count         = 1;

exec ProcedureInsertInventory
  @InventoryDate = @InventoryCatalogDate,
  @ProductName   = "Chef Anton's Cajun Seasoning",
  @Count         = 79;

go

declare @InventoryCatalogDate date;
set @InventoryCatalogDate = '2017-03-01';

exec ProcedureInsertInventory
  @InventoryDate = @InventoryCatalogDate,
  @ProductName   = 'Chai',
  @Count         = 18;

exec ProcedureInsertInventory
  @InventoryDate = @InventoryCatalogDate,
  @ProductName   = 'Chang',
  @Count         = 12;

exec ProcedureInsertInventory
  @InventoryDate = @InventoryCatalogDate,
  @ProductName   = 'Aniseed Syrup',
  @Count         =  84;

exec ProcedureInsertInventory
  @InventoryDate = @InventoryCatalogDate,
  @ProductName   = "Chef Anton's Cajun Seasoning",
  @Count         = 72 ;

go

select * from Inventories;
go

-- Task 4 (10 pts): Write code to update the Category "Beverages" to "Drinks"
-- TODO: Add Update Code
exec ProcedureUpdateCategoryName
  @CategoryName    = 'Beverages',
  @NewCategoryName = 'Drinks';
go

select * from Categories;
go

-- Task 5 (30 pts): Write code to delete all Condiments data from the database (in all three tables!)
-- TODO: Add Delete Code
exec ProcedureDeleteCategory
  @CategoryName = 'Condiments';
go

select * From Inventories;
select * From Products;
select * From Categories;
go

/***************************************************************************************/