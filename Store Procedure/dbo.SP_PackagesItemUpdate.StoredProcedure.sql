USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_PackagesItemUpdate]
(
	@Id BIGINT,
	@PackagesInsured DECIMAL(20,2) = 0,
	@CustReferences NVARCHAR(50) = '',
	@UpdateBy NVARCHAR(50),
	@UpdateDate datetime
)
AS
BEGIN

	UPDATE dbo.DHLPackage
	SET Insured = @PackagesInsured
		   ,CustReferences = @CustReferences
		   ,UpdateBy = @UpdateBy
           ,UpdateDate = UpdateDate
	WHERE DHLPackageID = @Id;

END
GO
