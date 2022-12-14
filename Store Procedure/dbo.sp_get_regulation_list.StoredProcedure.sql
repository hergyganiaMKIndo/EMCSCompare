USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_get_regulation_list]
AS
BEGIN
    SET NOCOUNT ON;
    
	DECLARE @MasterRegulation TABLE (
		[ID] [bigint] IDENTITY(1,1),
		ParentID [bigint], 
		[Instansi] [nvarchar](50),
		[Nomor] [nvarchar](50),
		[RegulationType] [nvarchar](50),
		[Category] [nvarchar](50),
		[Reference] [nvarchar](50),
		[Description] [nvarchar](max),
		[RegulationNo] [nvarchar](50),
		[TanggalPenetapan] [nvarchar](50),
		[TanggalDiUndangkan] [nvarchar](50),
		[TanggalBerlaku] [nvarchar](50),
		[TanggalBerakhir] [nvarchar](50),
		[Keterangan] [nvarchar](max),
		[Files] [nvarchar](max),
		[CreateBy] [nvarchar](50),
		[CreateDate] [nvarchar](50),
		[UpdateBy] [nvarchar](50),
		[UpdateDate] [nvarchar](50),
		[IsDelete] [bit]
	)

	insert into @MasterRegulation
	select 0 as ParentID, Instansi, NULL, NULL, NULL, NULL, NULL, NULL, '-', '-', '-', '-', NULL, NULL, NULL, '-', NULL, '-', 0 from
	(select distinct Instansi from MasterRegulation) data

	insert into @MasterRegulation
	select instansi.ID, data.Instansi, NULL, NULL, data.Category, NULL, NULL, NULL, '-', '-', '-', '-', NULL, NULL, NULL, '-', NULL, '-', 0 
	from (
		select distinct Instansi, Category from MasterRegulation
	) data
	inner join @MasterRegulation instansi on data.Instansi = Instansi.Instansi

	insert into @MasterRegulation
	select t.ID, 
		r.[Instansi], 
		r.[Nomor], 
		r.[RegulationType], 
		r.[Category], 
		r.[Reference], 
		r.[Description], 
		r.[RegulationNo], 
		ISNULL(convert(varchar, r.[TanggalPenetapan], 106), '-') as TanggalPenetapan, 
		ISNULL(convert(varchar, r.[TanggalDiUndangkan], 106), '-') as TanggalDiUndangkan, 
		ISNULL(convert(varchar, r.[TanggalBerlaku], 106), '-')  as TanggalBerlaku, 
		ISNULL(convert(varchar, r.[TanggalBerakhir], 106), '-') as TanggalBerakhir, 
		r.[Keterangan], 
		r.[Files], 
		r.[CreateBy], 
		ISNULL(convert(varchar, r.[CreateDate], 106), '-') as CreateDate, 
		r.[UpdateBy], 
		ISNULL(convert(varchar, r.[UpdateDate], 106), '-') AS UpdateDate, 
		r.[IsDelete] 
	from MasterRegulation r
	inner join @MasterRegulation t on r.Instansi = t.Instansi and r.Category = t.Category

	select * from @MasterRegulation

END
GO
