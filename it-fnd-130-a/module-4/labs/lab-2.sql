use MyLabsDB_EMaldonado;
go

-- Question 1: How would you add the data 'CatA' to the Categories table?
insert into Categories (CategoryName)
  values ('CatA')
go

-- Question 2: How would you add the data 'ProdA', for CatA, with a price of $1.99 to the Products table?
insert into Products (CategoryID, ProductName, UnitPrice)
  values ((select CategoryID from Categories where CategoryName = 'CatA'), 'ProdA', 1.99)
go

select * from Categories
select * from Products
go

-- Question 3: How would you update the price of ProdA to $10.00 in the Products table?
update Products
  set UnitPrice = 10.00
  where ProductName = 'ProdA'
go

select * from Products
go

-- Question 4: How would you delete the CatA data from the Categories table?
delete from Categories
  where CategoryName = 'CatA'
go 

select * from Categories
go
