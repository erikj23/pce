select top 3 * from Northwind.dbo.[Order Details]

-- Select the product Id and order quantities from the order details table.
select top 3 ProductID, Quantity
  from Northwind.dbo.[Order Details]

-- Select the product Id and the sum of the order quantities from the order details table.
select top 3 ProductID, sum(Quantity) [ProductVolume]
  from Northwind.dbo.[Order Details]
  group by ProductID

-- Select the product Id and the sum of the order quantities from the order details table. 
-- Only for product ids 1 to 5.
select ProductID, sum(Quantity) [ProductVolume]
  from Northwind.dbo.[Order Details]
  where ProductID between 1 and 5
  group by ProductID

-- Select the product Id and the sum of the order quantities from the order details table.
-- Only for product ids 1 to 5.
-- Only if the sum of the quantity is greater than 500.
select ProductID, sum(Quantity) [ProductVolume]
  from Northwind.dbo.[Order Details]
  where ProductID between 1 and 5
  group by ProductID
    having sum(Quantity) > 500
