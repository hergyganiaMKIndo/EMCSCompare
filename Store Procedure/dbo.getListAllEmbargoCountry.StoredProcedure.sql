USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[getListAllEmbargoCountry]
AS
BEGIN
      select ID, CountryCode, Description from MasterEmbargoCountry 
	  where IsDeleted = 0
END
GO
