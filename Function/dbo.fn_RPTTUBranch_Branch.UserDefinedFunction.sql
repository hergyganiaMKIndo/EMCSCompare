USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[fn_RPTTUBranch_Branch]
(	
	-- Add the parameters for the function here
	
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	select 
			Branch
		, count(DISTINCT AjuNumber) as TotalPEB
			, IIF(DATEPART(MONTH, PebDateNumeric) = 1, count(DISTINCT AjuNumber), 0) as TotalPEBJan
			, IIF(DATEPART(MONTH, PebDateNumeric) = 2, count(DISTINCT AjuNumber), 0) as TotalPEBFeb
			, IIF(DATEPART(MONTH, PebDateNumeric) = 3, count(DISTINCT AjuNumber), 0) as TotalPEBMar
			, IIF(DATEPART(MONTH, PebDateNumeric) = 4, count(DISTINCT AjuNumber), 0) as TotalPEBApr
			, IIF(DATEPART(MONTH, PebDateNumeric) = 5, count(DISTINCT AjuNumber), 0) as TotalPEBMay
			, IIF(DATEPART(MONTH, PebDateNumeric) = 6, count(DISTINCT AjuNumber), 0) as TotalPEBJun
			, IIF(DATEPART(MONTH, PebDateNumeric) = 7, count(DISTINCT AjuNumber), 0) as TotalPEBJul
			, IIF(DATEPART(MONTH, PebDateNumeric) = 8, count(DISTINCT AjuNumber), 0) as TotalPEBAug
			, IIF(DATEPART(MONTH, PebDateNumeric) = 9, count(DISTINCT AjuNumber), 0) as TotalPEBSep
			, IIF(DATEPART(MONTH, PebDateNumeric) = 10, count(DISTINCT AjuNumber), 0) as TotalPEBOct
			, IIF(DATEPART(MONTH, PebDateNumeric) = 11, count(DISTINCT AjuNumber), 0) as TotalPEBNov
			, IIF(DATEPART(MONTH, PebDateNumeric) = 12, count(DISTINCT AjuNumber), 0) as TotalPEBDec 
		from [dbo].[fn_get_approved_npe_peb]() 		
		group by Branch, DATEPART(MONTH, PebDateNumeric)
)
GO
