USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_CiplDelete] (
	@id BIGINT
	,@UpdateBy NVARCHAR(50)
	,@UpdateDate DATETIME
	,@Status NVARCHAR(50)
	,@IsDelete BIT
	,@RFC nvarchar(max)
	)
AS
BEGIN
	UPDATE R
	SET R.AvailableQuantity = R.AvailableQuantity + CI.Quantity
	FROM Reference R
	INNER JOIN (
		SELECT CI.IdReference
			,SUM(CI.Quantity) Quantity
		FROM CiplItem CI
		WHERE CI.IdCipl = @id
			AND CI.IsDelete = 0
		GROUP BY CI.IdReference
		) CI ON CI.IdReference = R.Id

	IF (@Status = 'ALL')
	BEGIN
		UPDATE dbo.Cipl
		SET UpdateBy = @UpdateBy
			,UpdateDate = @UpdateDate
			,IsDelete = @IsDelete
		WHERE id = @id;

		UPDATE dbo.RequestCipl
		SET UpdateBy = @UpdateBy
			,UpdateDate = @UpdateDate
			,IsDelete = @IsDelete
		WHERE IdCipl = @id;

		UPDATE dbo.CiplForwader
		SET UpdateBy = @UpdateBy
			,UpdateDate = @UpdateDate
			,IsDelete = @IsDelete
		WHERE IdCipl = @id;

		UPDATE dbo.CiplItem
		SET UpdateBy = @UpdateBy
			,UpdateDate = @UpdateDate
			,IsDelete = @IsDelete
		WHERE IdCipl = @id
	END
	ELSE IF (@Status = 'CIPLITEM')
	BEGIN
		UPDATE dbo.CiplItem
		SET UpdateBy = @UpdateBy
			,UpdateDate = @UpdateDate
			,IsDelete = @IsDelete
		WHERE IdCipl = @id
	END
	ELSE IF (@Status = 'CIPLITEMID')
	BEGIN
	if(@RFC = 'true')

	begin
		declare @OID Nvarchar(max);
	set @OID = (select IdCiplItem from CiplItem_Change where IdCiplItem = @id)
	if(@OID Is Null)
	begin
	INSERT INTO [dbo].[CiplItem_Change](IdCiplItem,[IdCipl],[IdReference],[ReferenceNo],[IdCustomer],[Name],[Uom],[PartNumber],[Sn],[JCode],[Ccr],[CaseNumber],[Type],[IdNo],[YearMade],[Quantity]
           ,[UnitPrice],[ExtendedValue],[Length],[Width],[Height],[Volume],[GrossWeight],[NetWeight],[Currency],[CoO],[CreateBy],[CreateDate],[UpdateBy],[UpdateDate],[IsDelete]
		   ,[IdParent],[SIBNumber],[WONumber],[Claim],[ASNNumber],[Status]
           )
   select [Id],[IdCipl],[IdReference],[ReferenceNo],[IdCustomer],[Name],[Uom],[PartNumber],[Sn],[JCode],[Ccr],[CaseNumber],[Type],[IdNo],[YearMade],[Quantity]
           ,[UnitPrice],[ExtendedValue],[Length],[Width],[Height],[Volume],[GrossWeight],[NetWeight],[Currency],[CoO],[CreateBy],[CreateDate],[UpdateBy],[UpdateDate],[IsDelete]
		   ,[IdParent],[SIBNumber],[WONumber],[Claim],[ASNNumber],'Deleted' from CiplItem where Id = @id
	end
	else	
	begin
	UPDATE dbo.CiplItem_Change
	SET [Status] = 'Deleted',
	IsDelete = 'true'
	WHERE IdCiplItem = @id;
	end
	
	end
	else
	begin
		UPDATE dbo.CiplItem
		SET UpdateBy = @UpdateBy
			,UpdateDate = @UpdateDate
			,IsDelete = @IsDelete
		WHERE Id = @id

		UPDATE dbo.CiplItem
		SET UpdateBy = @UpdateBy
			,UpdateDate = @UpdateDate
			,IsDelete = @IsDelete
		WHERE IdParent = @id
	end
	END
END
GO
