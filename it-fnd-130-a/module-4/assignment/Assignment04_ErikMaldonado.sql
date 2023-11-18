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
  Foreign Key (CategoryId) References Categories(CategoryId);
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
  Foreign Key (ProductId) References Products(ProductId);
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
end;
go

/************* PROCEDURES *************/
create proc ProcedureInsertCategories (
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
    print Error_Message()
    if @@trancount > 0 rollback transaction
  end catch
end
go

create proc ProcedureInsertProducts (
  @ProductName [nvarchar](100),
  @CategoryID  [int],
  @UnitPrice   [money]
) as begin
  begin try
    begin transaction
      insert into Products (
        ProductName, CategoryID, UnitPrice
      ) values (
        @ProductName, @CategoryID, @UnitPrice
      );
    commit transaction
  end try
  begin catch
    print Error_Message()
    if @@trancount > 0 rollback transaction
  end catch
end
go

create proc ProcedureInsertInventory (
  @InventoryDate [nvarchar](100),
  @ProductID     [int],
  @Count         [int]
) as begin
  begin try
    begin transaction
      insert into Inventories (
        InventoryDate, ProductID, Count
      ) values (
        @InventoryDate, @ProductID, @Count
      );
    commit transaction
  end try
  begin catch
    print Error_Message()
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
exec ProcedureInsertCategories
  @CategoryName = 'Beverages';

exec ProcedureInsertCategories
  @CategoryName = 'Condiments';  
go

select * from Categories;
go

-- Task 2 (20 pts): Add data to the Products table
-- TODO: Add Insert Code
-- exec ProcedureInsertProducts
--   @ProductName = 'Chai',
--   @CategoryID  = GetCategoryID('Beverages'),
--   @UnitPrice   = 18.00,


go
--Select * from Products;
go

-- Task 3 (20 pts): Add data to the Inventories table
-- TODO: Add Insert Code
go
--Select * from Products;
go

-- Task 4 (10 pts): Write code to update the Category "Beverages" to "Drinks"
-- TODO: Add Update Code
go
--Select * from Categories;
go


-- Task 5 (30 pts): Write code to delete all Condiments data from the database (in all three tables!)  
-- TODO: Add Delete Code
go
--Select * From Inventories;
--Select * From Products;
--Select * From Categories;
go

/***************************************************************************************/