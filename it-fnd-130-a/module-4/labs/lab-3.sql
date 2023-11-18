
Use Master;
go

If Exists(Select Name from SysDatabases Where Name = 'MyLabsDB_EMaldonado')
 Begin
  Alter Database [MyLabsDB_EMaldonado] set Single_user With Rollback Immediate;
  Drop Database MyLabsDB_EMaldonado;
 End
go

Create Database MyLabsDB_EMaldonado;
go

Use MyLabsDB_EMaldonado;
go

-- Create Tables (Module 01)--
drop table if exists Categories
Create Table Categories
(
  [CategoryID] [int] IDENTITY(1,1) NOT NULL,
  [CategoryName] [nvarchar](100) NOT NULL
);
go

drop table if exists Products
Create Table Products
(
  [ProductID] [int] IDENTITY(1,1) NOT NULL,
  [ProductName] [nvarchar](100) NOT NULL,
  [CategoryID] [int] NOT NULL,
  [UnitPrice] [money] NOT NULL
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

--drop proc if exists ProcedureInsertCategories
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
    if @@trancount > 0 rollback transaction
    print 'failed insert into Categories'
  end catch 
end
go

exec ProcedureInsertCategories
  @CategoryName = 'CatA';
go

select * from Categories;
go