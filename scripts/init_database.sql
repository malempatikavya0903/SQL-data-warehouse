/*
====================================
Create Database and Schemas
====================================
Script Purpose:
This script creates a new database named 'Datawarehouse' after checking if it already exists. If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas within the database: 'bronze', 'silver', and 'gold'.

WARNING:
Running this script will drop the entire 'DataWarehouse' database if it exists.
All data in the database will be permanently deleted. Proceed with caution and ensure you have proper backups before running this script.
/*


USE master;
GO



-- 2. Drop the database if it already exists--  



IF EXISTS (SELECT name FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    DROP DATABASE DataWarehouse;
END
GO



-- 2. Create the DataWarehouse database--

CREATE DATABASE DataWarehouse;
GO


-- 3. Switch context to the new DataWarehouse DB--

USE DataWarehouse;
GO


-- 5. Create schemas  
--    Bronze: Raw data  
--    Silver: Cleaned/Conformed data  
--    Gold:   Business-ready curated data


-- Bronze schema - stores raw ingested data--

CREATE SCHEMA bronze;
GO

-- Silver schema - stores cleaned and transformed data
CREATE SCHEMA silver;
GO

-- Gold schema - stores analytical, aggregated, 
-- business-ready tables for reporting
CREATE SCHEMA gold;
GO
