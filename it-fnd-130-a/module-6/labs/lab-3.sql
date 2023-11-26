
use Mod06Labs_EMaldonado;
go

-- pCustomersByLocation
create or alter procedure pCustomersByLocation as begin
  select * from vCustomersByLocation;
end
go

exec pCustomersByLocation;
go

-- pNumberOfCustomerOrdersByLocation
create or alter procedure pNumberOfCustomerOrdersByLocation as begin  
  select * from vNumberOfCustomerOrdersByLocation;
end
go

exec pNumberOfCustomerOrdersByLocation;
go

-- pNumberOfCustomerOrdersByLocationAndYears
create or alter procedure pNumberOfCustomerOrdersByLocationAndYears as begin
  select * from vNumberOfCustomerOrdersByLocationAndYears;
end
go

exec pNumberOfCustomerOrdersByLocationAndYears;
go
