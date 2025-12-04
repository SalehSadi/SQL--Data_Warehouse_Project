-- Create Database and Schemas
-- Script Purpose:
-- This script creates a new database named 'Datawarehouse" after checking if it already exists. If the database exists, it is dropped and recreated. 
-- Additionally, the script sets up three schemas within the database: 'bronze', 'silver', and 'gold".
-- WARNING:
-- Running this script will drop the entire 'Datawarehouse database if it exists. All data in the database will be permanently deleted. 
-- Proceed with caution and ensure you have proper backups before running this script.

-- Create data Warehouse 
USE master;
GO

-- drop and recreate the 'dataWarehouse' database if it exists.
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN 
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO

Create DATABASE DataWarehouse;

USE DataWareHouse;

-- Create SCHEMAS

Create SCHEMA bronze;
GO 
Create SCHEMA silver;
GO
Create SCHEMA gold;
GO
