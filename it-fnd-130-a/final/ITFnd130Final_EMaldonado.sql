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


-- Add Constraints (Review Module 02) -- 	


-- Add Views (Review Module 03 and 06) -- 


--< Test Tables by adding Sample Data >--  


-- Add Stored Procedures (Review Module 04 and 08) --
-- Set Permissions --
--< Test Sprocs >-- 
--{ IMPORTANT!!! }--
-- To get full credit, your script must run without having to highlight individual statements!!!  
/**************************************************************************************************/