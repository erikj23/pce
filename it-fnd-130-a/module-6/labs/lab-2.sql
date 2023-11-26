
use Mod06Labs_EMaldonado;
go

-- dbo.fCustomersByLocation
create or alter function dbo.fCustomersByLocation() returns table as
  return (
    select * from vCustomersByLocation
  );
go

select * from dbo.fCustomersByLocation() order by CustomerName;
go

-- dbo.fNumberOfCustomerOrdersByLocation
create or alter function dbo.fNumberOfCustomerOrdersByLocation() returns table as
  return (
    select * from vNumberOfCustomerOrdersByLocation
  );
go

select * from dbo.fNumberOfCustomerOrdersByLocation() order by CustomerName;
go

-- dbo.fNumberOfCustomerOrdersByLocationAndYears
create or alter function dbo.fNumberOfCustomerOrdersByLocationAndYears() returns table as
  return (
    select * from vNumberOfCustomerOrdersByLocationAndYears
  );
go

select * from dbo.fNumberOfCustomerOrdersByLocationAndYears() order by CustomerName;
go
