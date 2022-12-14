USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_NpePeb_Update]    
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
 @DraftPeb BIT,    
 @CreateBy NVARCHAR(50),    
 @CreateDate datetime,    
 @UpdateBy NVARCHAR(50),    
 @UpdateDate datetime,    
 @IsDelete BIT,    
 @RegistrationNumber NVARCHAR(MAX),    
    @NpeDateSubmitToCustomOffice datetime    
)    
AS    
BEGIN    
 DECLARE @LASTID bigint    
   
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
    ,[NpeDateSubmitToCustomOffice] = @NpeDateSubmitToCustomOffice    
     WHERE Id = @Id    
     SELECT C.Id as ID, CAST(C.IdCl AS nvarchar) as [NO], C.CreateDate as CREATEDATE FROM NpePeb C WHERE C.id = @Id    
END
GO
