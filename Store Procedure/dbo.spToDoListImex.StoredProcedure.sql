USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spToDoListImex]
@ReportName VARCHAR(100)
AS
BEGIN
	SELECT Name, Url, Value, TotalValue, TotalWeight
	FROM [PartsInformationSystem].[dbo].[RptToDoList]
	WHERE ReportName = @ReportName
	ORDER BY Name
END
GO
