USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetRTaxAudit]
(
	@StartDate nvarchar(100) = '1/1/1990 00:00:00',
	@EndDate nvarchar(100) = '1/1/2025 00:00:00',
	@noaju nvarchar(100) = '-'
)
AS
BEGIN
	DECLARE @sql nvarchar(MAX);
	DECLARE @where nvarchar(MAX);
	
	SET @where = ''

	IF @noaju != '-'
		SET @where = 'and t4.AjuNumber = ''' + @noaju +''''

	--print(@where);

	SET @sql = '
	SELECT PebNo, PebDate, SUM(sumvalue) AS sumvalue, NpeDate, Nopen, FilePeb, FileBlAwb, UrlFilePeb, UrlFileBlAwb
	FROM(
	SELECT  
		ISNULL(t4.PebNumber,''-'') AS pebNo,		
		FORMAT( t4.PebDate,''dd/MM/yyyy hh:mm:ss'') PebDate,
		sum(t1.CurrValue) as sumvalue,
		FORMAT(t4.NpeDate,''dd/MM/yyyy'') NpeDate,
		ISNULL(t4.RegistrationNumber,''-'') as Nopen, --add nunu
		( SELECT TOP 1 [Filename] FROM Documents WHERE idrequest = t4.idcl AND Category = ''NPE/PEB'' AND Tag = ''COMPLETEDOCUMENT'') AS FilePeb,
		( SELECT TOP 1 [Filename] FROM Documents WHERE idrequest = t4.idcl AND Category = ''BL/AWB'' AND Status = ''Approve'') AS FileBlAwb,
		''https://scis.trakindo.co.id/Upload/EMCS/NPEPEB/'' + ( SELECT TOP 1 [Filename] FROM Documents WHERE idrequest = t4.idcl AND Category = ''NPE/PEB'' AND Tag = ''COMPLETEDOCUMENT'') AS UrlFilePeb,
		''https://scis.trakindo.co.id/Upload/EMCS/BLAWB/'' + ( SELECT TOP 1 [Filename] FROM Documents WHERE idrequest = t4.idcl AND Category = ''BL/AWB'' AND Status = ''Approve'') AS UrlFileBlAwb		 
	FROM
		Cipl t0
		JOIN (SELECT 
			DISTINCT IdCipl, 
					SUM(ExtendedValue) CurrValue  --update nunu
			FROM CiplItem 
			GROUP BY Currency, IdCipl
			) as t1 on t1.IdCipl = t0.id
		JOIN CargoCipl t2 on t2.IdCipl = t0.id and t2.IsDelete= 0
		JOIN Cargo t3 on t3.Id = t2.IdCargo and t3.IsDelete= 0
		JOIN NpePeb t4 on t4.IdCl = t3.id and t4.IsDelete= 0
		JOIN GoodsReceiveItem t6 on t6.DoNo = t0.EdoNo and t6.IsDelete= 0
		JOIN (SELECT  max(CreateDate) as ApprovedDate, IdCipl
				FROM CiplHistory
				WHERE Status = ''Approve''
				GROUP BY IdCipl
			) t7 on t7.IdCipl = t0.id 
		JOIN BlAwb t8 on t8.IdCl = t3.Id and  t8.IsDelete= 0
		JOIN RequestCl t9 on t9.IdCl = t3.Id and t9.IsDelete= 0
	WHERE t9.IdStep = 10022
		and t9.[Status] = ''Approve''
		and t4.NpeDate between ''' + @StartDate + ''' and '''+ @EndDate +''' '
	set @sql = @sql + @where
	
	set @sql = @sql + ' 
	group by 
	t4.PebNumber,t4.PebDate,t4.Rate,t4.WarehouseLocation,t3.PortOfLoading
	,t4.NpeNumber,t4.NpeDate,t4.RegistrationNumber,t8.Publisher,t8.Number,t8.BlAwbDate,t3.PortOfDestination,t0.Remarks
	,t4.idcl
	) t GROUP BY PebNo, PebDate, NpeDate, Nopen, FilePeb, FileBlAwb, UrlFilePeb, UrlFileBlAwb'

	print(@sql);
	execute(@sql);
END



GO
