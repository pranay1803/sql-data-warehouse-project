USE master;
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'Datawarehouse')
BEGIN
    CREATE DATABASE Datawarehouse;
END

USE Datawarehouse;
GO
CREATE SCHEMA Bronze;
GO
CREATE SCHEMA Silver;
GO
CREATE SCHEMA gold;
