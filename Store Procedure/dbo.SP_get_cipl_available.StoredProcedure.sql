USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_get_cipl_available] -- SP_get_cipl_available '', '1', '1' select * from dbo.Cipl
(
	@Search nvarchar(100) = '',
	@CargoId nvarchar(10) = '0',
	@CiplList nvarchar(max) = '',
	@Consignee nvarchar(max) = '',
	@Notify nvarchar(max) = '',
	@ExportType nvarchar(max) = '',
	@Category nvarchar(max) = '',
	@Incoterms nvarchar(max) = '',
	@ShippingMethod nvarchar(max) = ''
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @sql nvarchar(max);

	SET @sql = 'SELECT 
					--t0.*
					distinct t0.IdCipl As Id    
					,t0.DoNo    
					,t0.IdGr    
					,null As DaNo    
					,null As FileName    
					,t1.CreateDate    
					,t1.CreateBy    
					,t1.UpdateDate    
					,t1.UpdateBy    
					,t1.IsDelete    
					, t1.CiplNo
					, t1.Category
					, t1.CategoriItem
					, t1.ExportType
					, t1.ExportTypeItem
					, t1.ConsigneeName
					, t1.ConsigneeCountry
					, t1.NotifyName
					, t1.IncoTerm
					, t1.ShippingMethod
					, t1.id CiplId
					, t2.[Status] RequestStatus 
					--FROM dbo.ShippingFleet t0    
				FROM dbo.ShippingFleetRefrence t0
				JOIN dbo.Cipl t1 ON t1.id = t0.IdCipl
				JOIN dbo.RequestGr t2 ON t2.IdGr = t0.IdGr
				WHERE 
				--t0.isdelete = 0 AND
				t2.Status = ''Approve'' ';
	SET @sql = @sql + CASE WHEN ISNULL(@Consignee, '') <> '' THEN 'AND t1.ConsigneeName like ''%'+@Consignee+'%''' ELSE '' END + 
				CASE WHEN ISNULL(@Consignee, '') <> '' THEN 'AND t1.NotifyName like ''%'+@Notify+'%''' ELSE '' END +  
				CASE WHEN ISNULL(@Consignee, '') <> '' THEN 'AND t1.ExportType like ''%'+@ExportType+'%''' ELSE '' END + 
				CASE WHEN ISNULL(@Consignee, '') <> '' THEN 'AND UPPER(RTRIM(LTRIM(t1.Category))) like ''%'+UPPER(RTRIM(LTRIM(@Category)))+'%''' ELSE '' END +
				CASE WHEN ISNULL(@Consignee, '') <> '' THEN 'AND UPPER(RTRIM(LTRIM(t1.IncoTerm))) like ''%'+UPPER(RTRIM(LTRIM(@Incoterms)))+'%''' ELSE '' END +
				CASE WHEN ISNULL(@Consignee, '') <> '' THEN 'AND UPPER(RTRIM(LTRIM(t1.ShippingMethod))) like ''%'+UPPER(RTRIM(LTRIM(@ShippingMethod)))+'%''' ELSE '' END +
				' AND t1.id NOT IN (
					SELECT IdCipl FROM dbo.cargocipl WHERE 1=1 AND isDelete = 0 '+ CASE WHEN @CargoId <> '0' THEN 'AND IdCargo <> '+@CargoId ELSE '' END +
				')' +
				'AND (t1.CiplNo like ''%'+@Search+'%'' OR     
				--t0.DaNo like ''%'+@Search+'%'' OR    
				t0.DoNo like ''%'+@Search+'%'') ' +
				CASE WHEN ISNULL(@CiplList, '') <> '' THEN 'AND t1.id NOT IN ('+@CiplList+')' ELSE '' END;
	--SELECT @sql;
	EXECUTE(@sql);
END


GO
