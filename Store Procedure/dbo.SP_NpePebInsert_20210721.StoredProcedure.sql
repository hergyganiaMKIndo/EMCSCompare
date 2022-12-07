USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_NpePebInsert_20210721]
(
	@Id BIGINT,
	@IdCl BIGINT,
	@AjuNumber NVARCHAR(200),
	@AjuDate datetime,
	@NpeNumber NVARCHAR(200),
	@NpeDate datetime,
	@Npwp NVARCHAR(50),
	@ReceiverName NVARCHAR(100),
	@PassPabeanOffice NVARCHAR(100),
	@Dhe DECIMAL(20,2),
	@PebFob DECIMAL(18,4),
	@Valuta NVARCHAR(20),
	@DescriptionPassword NVARCHAR(100),
	@DocumentComplete BIT,
	@Rate Decimal(20,2),
	@WarehouseLocation NVARCHAR(50),
	@FreightPayment Decimal(20,2),  
	@InsuranceAmount Decimal(20,2),
	@Status NVARCHAR(10),
	@DraftPeb BIT,
	@CreateBy NVARCHAR(50),
	@CreateDate datetime,
	@UpdateBy NVARCHAR(50),
	@UpdateDate datetime,
	@IsDelete BIT,
	@RegistrationNumber NVARCHAR(MAX)
)
AS
BEGIN
	DECLARE @LASTID bigint
	IF @Id = 0
	BEGIN
	INSERT INTO [dbo].[NpePeb]
           ([IdCl]
		   ,[AjuNumber]
           ,[AjuDate]
		   ,[PebNumber]
		   ,[PebDate]
		   ,[NpeNumber]
		   ,[NpeDate]
		   ,[Npwp]
		   ,[ReceiverName]
		   ,[PassPabeanOffice]
		   ,[Dhe]
		   ,[PebFob]
		   ,[Valuta]
		   ,[DescriptionPassword]
		   ,[DocumentComplete]
		   ,[Rate]
		   ,[WarehouseLocation]
		   ,[FreightPayment]
		   ,[InsuranceAmount]
		   ,[DraftPeb]
		   ,[CreateBy]
           ,[CreateDate]
           ,[UpdateBy]
           ,[UpdateDate]
           ,[IsDelete]
		   ,[RegistrationNumber]
           )
     VALUES
           (@IdCl
		   ,@AjuNumber
           ,@AjuDate
		   ,@AjuNumber
           ,@AjuDate
		   ,@NpeNumber
		   ,@NpeDate
		   ,@Npwp
		   ,@ReceiverName
		   ,@PassPabeanOffice
		   ,@Dhe
		   ,@PebFob
		   ,@Valuta
		   ,@DescriptionPassword
		   ,@DocumentComplete
		   ,@Rate
		   ,@WarehouseLocation
		   ,@FreightPayment
		   ,@InsuranceAmount
		   ,@DraftPeb
           ,@CreateBy
           ,@CreateDate
           ,@UpdateBy
           ,@UpdateDate
           ,@IsDelete
		   ,@RegistrationNumber)

	SELECT @LASTID = CAST(SCOPE_IDENTITY() as bigint)
	
	--EXEC [sp_update_request_cl] @IdCl, @CreateBy, 'SUBMIT', ''
	SELECT C.Id as ID, CAST(C.IdCl AS nvarchar) as [NO], C.CreateDate as CREATEDATE FROM NpePeb C WHERE C.id = @LASTID
	END 
	ELSE
	BEGIN
	UPDATE [dbo].[NpePeb]
		SET [AjuNumber] = @AjuNumber
		   ,[AjuDate] = @AjuDate
		   ,[PebNumber] = @AjuNumber
		   ,[PebDate] = @AjuDate
		   ,[NpeNumber] = @NpeNumber
		   ,[NpeDate] = @NpeDate
		   ,[Npwp] = @Npwp
		   ,[ReceiverName] = @ReceiverName
		   ,[PassPabeanOffice] = @PassPabeanOffice
		   ,[Dhe] = @Dhe
		   ,[PebFob] = @PebFob
		   ,[Valuta] = @Valuta
		   ,[DescriptionPassword] = @DescriptionPassword
		   ,[DocumentComplete] = @DocumentComplete
		   ,[Rate] = @Rate
		   ,[WarehouseLocation] = @WarehouseLocation
		   ,[FreightPayment] = @FreightPayment
		   ,[InsuranceAmount] = @InsuranceAmount
		   ,[DraftPeb] = @DraftPeb
           ,[CreateBy] = @CreateBy
           ,[CreateDate] = @CreateDate
           ,[UpdateBy] = @CreateBy
           ,[UpdateDate] = @CreateDate
           ,[IsDelete] = @IsDelete
		   ,[RegistrationNumber] = @RegistrationNumber
		   WHERE Id = @Id
		   SELECT C.Id as ID, CAST(C.IdCl AS nvarchar) as [NO], C.CreateDate as CREATEDATE FROM NpePeb C WHERE C.id = @Id
	END;

	IF(@Status <> 'Draft')
	BEGIN
	EXEC [sp_update_request_cl] @IdCl, @CreateBy, @Status, ''
	END

END
GO
