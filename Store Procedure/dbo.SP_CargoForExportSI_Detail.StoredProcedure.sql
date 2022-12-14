USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CargoForExportSI_Detail]
	@CargoID bigint
AS
BEGIN

	select distinct ContainerNumber, ISNULL(ct.Name, '-') as ContainerType, ContainerSealNumber 
	from CargoItem ci
	left join (select Value, Name from MasterParameter where IsDeleted = 0 and [Group] = 'ContainerType') ct on ci.ContainerType = ct.Value
	where IdCargo = @CargoID and isDelete = 0

END
GO
