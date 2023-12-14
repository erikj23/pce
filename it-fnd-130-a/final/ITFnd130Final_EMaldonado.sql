--**********************************************************************************************--
-- Title: ITFnd130Final
-- Author: Erik Maldonado
-- Desc: This file demonstrates how to design and create;
--       tables, views, and stored procedures
-- Change Log: When,Who,What
-- 2023-012-09,Erik Maldonado,Created File
--***********************************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'ITFnd130FinalDB_EMaldonado')
	 Begin
	  Alter Database [ITFnd130FinalDB_EMaldonado] set Single_user With Rollback Immediate;
	  Drop Database ITFnd130FinalDB_EMaldonado;
	 End
	Create Database ITFnd130FinalDB_EMaldonado;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use ITFnd130FinalDB_EMaldonado;

-- Create Tables (Review Module 01)--
--< Courses >--
drop table if exists [Courses];
create table [Courses] (
  [ID] 					 int primary key identity(1, 1),
  [Name] 			   nvarchar(100) not null,
  [StartDate]    date,
  [EndDate]      date,
  [StartTime]    time,
  [EndTime] 	   time,
  [Weekdays]     nvarchar(100),
  [CurrentPrice] decimal(19, 2)
)
go

--< Students >--
drop table if exists [Students];
create table [Students] (
  [ID] 						int primary key identity(1, 1),
  [FirstName]     nvarchar(100) not null,
  [LastName]      nvarchar(100) not null,
  [UserName]      nvarchar(100) not null,
  [EMailAddress]  nvarchar(100) not null,
  [MailAddress]   nvarchar(100) not null,
  [ContactNumber] nvarchar(100) not null
)
go

--< Registrations >--
drop table if exists [Registrations];
create table [Registrations] (
  [ID] 	      int identity(1, 1),
  [Date]      date not null,
  [Payment]   decimal(19, 2) not null,
  [CourseID]  int not null,
  [StudentID] int not null
	
	primary key (CourseID, StudentID)
)
go

-- Helper Functions --
create or alter function CheckRegistrationDateBeforeCourseStartDate
(
	@RegistrationDate date,
	@CourseID int
)
returns bit as begin
	declare @Result bit
	select @Result = case when @RegistrationDate <= StartDate then 1 else 0 end
		from Courses where ID = @CourseID
	return @Result
end;
go

-- Add Constraints (Review Module 02) --
--< Courses >--

--alter table [Courses] drop constraint cCoursesStartDate;
--alter table [Courses] drop constraint cCoursesEndDate;
--alter table [Courses] drop constraint cCoursesStartTime;
--alter table [Courses] drop constraint cCoursesEndTime;
go

--alter table [Courses] drop constraint uCoursesName;
alter table [Courses] add constraint uCoursesName
	unique ([Name]);
go

alter table [Courses] add constraint cCoursesStartDate
	check (StartDate < EndDate or StartDate is null);
go

alter table [Courses] add constraint cCoursesEndDate
	check (StartDate < EndDate or EndDate is null);
go

alter table [Courses] add constraint cCoursesStartTime
	check (StartTime < EndTime or StartTime is null);
go

alter table [Courses] add constraint cCoursesEndTime
	check (StartTime < EndTime or EndTime is null);
go

--< Students >--
--alter table [Students] drop constraint uStudentsUserName;
alter table [Students] add constraint uStudentsUserName
	unique (UserName);
go

--alter table [Students] drop constraint uStudentsEMailAddress;
alter table [Students] add constraint uStudentsEMailAddress
	unique (EMailAddress);
go

--alter table [Students] drop constraint uStudentsContactNumber;
alter table [Students] add constraint uStudentsContactNumber
	unique (ContactNumber);
go

--< Registrations >--
--todo chk registration date before course start date
--alter table [Registrations] drop constraint uRegistrationsDate;
alter table [Registrations] add constraint uRegistrationsDate
	check (dbo.CheckRegistrationDateBeforeCourseStartDate([Date], [CourseID]) = 1);
go

--alter table [Registrations] drop constraint fkRegistrationsCourseID;
alter table [Registrations] add constraint fkRegistrationsCourseID
	foreign key ([CourseID]) references [Courses] ([ID])
		on delete cascade
go

--alter table [Registrations] drop constraint fkRegistrationsStudentID;
alter table [Registrations] add constraint fkRegistrationsStudentID
	foreign key ([StudentID]) references [Students] ([ID])
		on delete cascade
go

-- Add Views (Review Module 03 and 06) --
--< Courses >--
create or alter view vCourses with schemabinding as
  select
      [ID] 					 = [ID],
			[Name] 			   = [Name],
			[StartDate]    = [StartDate],
			[EndDate]      = [EndDate],
			[StartTime]    = [StartTime],
			[EndTime] 	   = [EndTime],
			[Weekdays]     = [Weekdays],
			[CurrentPrice] = [CurrentPrice]
    from dbo.Courses;
go

--< Students >--
create or alter view vStudents with schemabinding as
  select
      [ID]            = [ID],
			[FirstName]     = [FirstName],
			[LastName]      = [LastName],
			[UserName]      = [UserName],
			[EMailAddress]  = [EMailAddress],
			[MailAddress]   = [MailAddress],
			[ContactNumber] = [ContactNumber]
    from dbo.Students;
go

--< Registrations >--
create or alter view vRegistrations with schemabinding as
  select
      [ID] 	      = [ID],
			[Date]      = [Date],
			[Payment]   = [Payment],
			[CourseID]  = [CourseID],
			[StudentID] = [StudentID]
    from dbo.Registrations;
go

--< Test Tables by adding Sample Data >--
insert into [Courses] (
	[Name], [StartDate], [EndDate], [StartTime], [EndTime], [Weekdays],	[CurrentPrice]
) values (
	'SQL1 - Winter 2017', '2017-01-10', '2017-01-24', '18:00', '20:50', 'T', 399.00
);
go

insert into [Students] (
  [FirstName], [LastName], [UserName], [EMailAddress], [MailAddress], [ContactNumber]
) values (
	'Bob', 'Smith', 'B-Smith-071', 'BSmith@HipMail.com', '123 Main St. Seattle, WA., 98001', '(206)-111-2222'
);
go

insert into [Registrations] (
  [Date], [Payment], [CourseID], [StudentID]
) values (
	'2017-01-03', 399.00, 1, 1
);
go

select * from vCourses;
select * from vStudents;
select * from vRegistrations;
go

-- Add Stored Procedures (Review Module 04 and 08) --
create proc ProcedureInsertCourse (
  @Name 			  nvarchar(100),
  @StartDate    date,
  @EndDate      date,
  @StartTime    time,
  @EndTime 	    time,
  @Weekdays     nvarchar(100),
  @CurrentPrice decimal(19, 2)
) as begin
  begin try
    begin transaction
      insert into [Courses] (
        [Name], [StartDate], [EndDate], [StartTime], [EndTime], [Weekdays],	[CurrentPrice]
      ) values (
        @Name, @StartDate, @EndDate, @StartTime, @EndTime, @Weekdays, @CurrentPrice
      );
    commit transaction
  end try
  begin catch
    select error_line() as ErrorLine, error_message() AS ErrorMessage;
    if @@trancount > 0 rollback transaction
  end catch
end
go

create proc ProcedureInsertStudent (
  @FirstName     nvarchar(100),
  @LastName      nvarchar(100),
  @UserName      nvarchar(100),
  @EMailAddress  nvarchar(100),
  @MailAddress   nvarchar(100),
  @ContactNumber nvarchar(100)
) as begin
  begin try
    begin transaction
      insert into [Students] (
        [FirstName], [LastName], [UserName], [EMailAddress], [MailAddress], [ContactNumber]
      ) values (
        @FirstName, @LastName, @UserName, @EMailAddress, @MailAddress, @ContactNumber
      );
    commit transaction
  end try
  begin catch
    select error_line() as ErrorLine, error_message() AS ErrorMessage;
    if @@trancount > 0 rollback transaction
  end catch
end
go

create proc ProcedureInsertRegistration (
  @Date      date,
  @Payment   decimal(19, 2),
  @CourseID  int,
  @StudentID int
) as begin
  begin try
    begin transaction
      insert into [Registrations] (
        [Date], [Payment], [CourseID], [StudentID]
			) values (
        @Date, @Payment, @CourseID, @StudentID
      );
    commit transaction
  end try
  begin catch
    select error_line() as ErrorLine, error_message() AS ErrorMessage;
    if @@trancount > 0 rollback transaction
  end catch
end
go

create proc ProcedureUpdateCourse (
	@ID						int,
  @Name 			  nvarchar(100),
  @StartDate    date,
  @EndDate      date,
  @StartTime    time,
  @EndTime 	    time,
  @Weekdays     nvarchar(100),
  @CurrentPrice decimal(19, 2)
) as begin
  begin try
    begin transaction
      update [Courses] set 
					[Name] 			   = @Name,
					[StartDate]    = @StartDate,
					[EndDate]		   = @EndDate, 
					[StartTime]    = @StartTime, 
					[EndTime]      = @EndTime, 
					[Weekdays]     = @Weekdays,	
					[CurrentPrice] = @CurrentPrice
				where ID = @ID;
    commit transaction
  end try
  begin catch
    select error_line() as ErrorLine, error_message() AS ErrorMessage;
    if @@trancount > 0 or @@ROWCOUNT > 1 rollback transaction
  end catch
end
go

create proc ProcedureUpdateStudent (
	@ID						 int,
  @FirstName     nvarchar(100),
  @LastName      nvarchar(100),
  @UserName      nvarchar(100),
  @EMailAddress  nvarchar(100),
  @MailAddress   nvarchar(100),
  @ContactNumber nvarchar(100)
) as begin
  begin try
    begin transaction
      update [Students] set
					[FirstName]     = @FirstName, 
					[LastName]      = @LastName, 
					[UserName]      = @UserName, 
					[EMailAddress]  = @EMailAddress, 
					[MailAddress]   = @MailAddress, 
					[ContactNumber] = @ContactNumber
				where ID = @ID;
    commit transaction
  end try
  begin catch
    select error_line() as ErrorLine, error_message() AS ErrorMessage;
    if @@trancount > 0 or @@ROWCOUNT > 1 rollback transaction
  end catch
end
go

create proc ProcedureUpdateRegistration (
  @Date      date,
  @Payment   decimal(19, 2),
  @CourseID  int,
  @StudentID int
) as begin
  begin try
    begin transaction
      update [Registrations] set
					[Date] 		= @Date,
					[Payment] = @Payment
				where CourseID = @CourseID and StudentID = @StudentID
    commit transaction
  end try
  begin catch
    select error_line() as ErrorLine, error_message() AS ErrorMessage;
    if @@trancount > 0 or @@ROWCOUNT > 1 rollback transaction
  end catch
end
go

create proc ProcedureDeleteCourse (
  @ID int
) as begin -- added on delete cascade to fk references
  begin try
    begin transaction
      delete from Courses where ID = @ID;
    commit transaction
  end try
  begin catch
    select error_line() as ErrorLine, error_message() AS ErrorMessage;
    if @@trancount > 0 rollback transaction
  end catch
end
go


create proc ProcedureDeleteStudent (
  @ID int
) as begin -- added on delete cascade to fk references
  begin try
    begin transaction
      delete from Students where ID = @ID;
    commit transaction
  end try
  begin catch
    select error_line() as ErrorLine, error_message() AS ErrorMessage;
    if @@trancount > 0 rollback transaction
  end catch
end
go

create proc ProcedureDeleteRegistration (
  @CourseID int,
	@StudentID int
) as begin
  begin try
    begin transaction
      delete from Registrations where CourseID = @CourseID and StudentID = @StudentID;
    commit transaction
  end try
  begin catch
    select error_line() as ErrorLine, error_message() AS ErrorMessage;
    if @@trancount > 0 rollback transaction
  end catch
end
go

--< Test Sprocs >--
exec ProcedureInsertCourse -- will fail check, dates are bad
  @Name 			  = 'SQL2 - Winter 2017',
  @StartDate    = '1/31/2018',
  @EndDate      = '2/14/2017',
  @StartTime    = '06:00',
  @EndTime 	    = '08:50',
  @Weekdays     = 'T',
  @CurrentPrice = 399;
go

exec ProcedureInsertCourse -- will fail check, times are bad
  @Name 			  = 'SQL2 - Winter 2017',
  @StartDate    = '1/31/2017',
  @EndDate      = '2/14/2017',
  @StartTime    = '14:00',
  @EndTime 	    = '11:50',
  @Weekdays     = 'T',
  @CurrentPrice = 399;
go

exec ProcedureInsertCourse
  @Name 			  = 'SQL2 - Winter 2017',
  @StartDate    = '1/31/2017',
  @EndDate      = '2/14/2017',
  @StartTime    = '06:00',
  @EndTime 	    = '08:50',
  @Weekdays     = 'T',
  @CurrentPrice = 399;
go

exec ProcedureInsertStudent
  @FirstName     = 'Sue',
  @LastName      = 'Jones',
  @UserName      = 'S-Jones-003',
  @EMailAddress  = 'SueJones@YaYou.com',
  @MailAddress   = '333 1st Ave. Seattle, WA., 98001',
  @ContactNumber = '(206)-231-4321';
go

exec ProcedureInsertRegistration -- will fail check, date after course start
  @Date      = '12/14/18',
  @Payment   = 349,
  @CourseID  = 1,
  @StudentID = 2;
go

exec ProcedureInsertRegistration
  @Date      = '12/14/16',
  @Payment   = 349,
  @CourseID  = 1,
  @StudentID = 2;
go

exec ProcedureInsertRegistration
  @Date      = '1/12/17',
  @Payment   = 399,
  @CourseID  = 4, -- check failures bump this value
  @StudentID = 1;
go

exec ProcedureInsertRegistration
  @Date      = '12/14/16',
  @Payment   = 349,
  @CourseID  = 4, -- check failures bump this value
  @StudentID = 2;
go

select * from vCourses;
select * from vStudents;
select * from vRegistrations;
go

exec ProcedureUpdateStudent
	@ID						 = 1,
	@FirstName     = 'Erik',
  @LastName      = 'Maldonado',
  @UserName      = 'E-Maldonado-096',
  @EMailAddress  = 'em@whycloud.com',
  @MailAddress   = '987 House Ln, Larson, MD., 68001',
  @ContactNumber = '(509)-231-4321';

select * from vCourses;
select * from vStudents;
select * from vRegistrations;
go

exec ProcedureDeleteCourse
  @ID = 1; -- deletes two registrations due to cascades
go

select * from vCourses;
select * from vStudents;
select * from vRegistrations;
go

-- Set Permissions --
deny select on Courses to public;
grant select on vCourses to public;
go

deny select on Students to public;
grant select on vStudents to public;
go

deny select on Registrations to public;
grant select on vRegistrations to public;
go

--{ IMPORTANT!!! }--
-- To get full credit, your script must run without having to highlight individual statements!!!
/**************************************************************************************************/