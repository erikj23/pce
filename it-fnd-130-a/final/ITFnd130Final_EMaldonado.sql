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
drop table if exists [Courses]
create table [Courses] (
  [ID] 					 int primary key identity(1, 1),
  [Name] 			   nvarchar(100) not null,
  [StartDate]    date,
  [EndDate]      date,
  [StartTime]    date,
  [EndTime] 	   date,
  [Weekdays]     nvarchar(100),
  [CurrentPrice] decimal(19, 4),
)
go

--< Students >--
drop table if exists [Students]
create table [Students] (
  [ID] 						int primary key identity(1, 1),
  [FirstName]     nvarchar(100) not null,
  [LastName]      nvarchar(100) not null,
  [UserName]      nvarchar(100) not null,
  [EMailAddress]  nvarchar(100) not null,
  [MailAddress]   nvarchar(100) not null,
  [ContactNumber] nvarchar(100) not null,
)
go

--< Registrations >--
drop table if exists [Registrations]
create table [Registrations] (
  [ID] 	      int primary key identity(1, 1),
  [Date]      date  not null,
  [Payment]   decimal(19,4) not null,
  [CourseID]  int not null,
  [StudentID] int not null,
)
go

-- Add Constraints (Review Module 02) --
--< Courses >--
alter table [Courses] add constraint uCoursesName
	unique ([Name]);

alter table [Courses] add constraint cCoursesStartDate
	check (StartDate < EndDate or StartDate = null);

alter table [Courses] add constraint cCoursesEndDate
	check (StartDate < EndDate or EndDate = null);

alter table [Courses] add constraint cCoursesStartTime
	check (StartTime < EndTime or StartTime = null);

alter table [Courses] add constraint cCoursesEndTime
	check (StartTime < EndTime or EndTime = null);

go

--< Students >--
alter table [Students] add constraint uStudentsUserName
	unique (UserName);

alter table [Students] add constraint uStudentsEMailAddress
	unique (EMailAddress);

alter table [Students] add constraint uStudentsContactNumber
	unique (ContactNumber);

go

--< Registrations >--
alter table [Registrations] add constraint fkRegistrationsCourseID
	foreign key ([CourseID]) references [Courses] ([ID])
		on delete cascade

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
    from ITFnd130FinalDB_EMaldonado.dbo.Courses;
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
    from ITFnd130FinalDB_EMaldonado.dbo.Students;
go

--< Registrations >--
create or alter view vRegistrations with schemabinding as
  select
      [ID] 	      = [ID],
			[Date]      = [Date],
			[Payment]   = [Payment],
			[CourseID]  = [CourseID],
			[StudentID] = [StudentID]
    from ITFnd130FinalDB_EMaldonado.dbo.Registrations;
go

--< Test Tables by adding Sample Data >--


-- Add Stored Procedures (Review Module 04 and 08) --
--< Test Sprocs >--


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