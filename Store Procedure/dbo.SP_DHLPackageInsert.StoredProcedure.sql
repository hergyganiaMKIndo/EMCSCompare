USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[SP_DHLPackageInsert](@dtDHLDataType DHLDataType ReadOnly)  

As
Begin  
	Declare @DHLShipmentID bigint
	Select @DHLShipmentID = a.ID From ( Select top 1 * From @dtDHLDataType )a
	
	If exists (Select Top 1 * from DHLPackage where DHLShipmentID = @DHLShipmentID)
	Begin 
		Delete From DHLPackage Where DHLShipmentID = @DHLShipmentID
	End

    insert into DHLPackage (DHLShipmentID, PackageNumber, Insured, [Weight], [Length], Width, Height, CustReferences, CaseNumber, CiplNumber, IsDelete, CreateBy, CreateDate, UpdateBy, UpdateDate)
	select DHLShipmentID=ID, PackageNumber=ItemCode, Insured=dbo.FN_SplitStringDelimiter(ItemValue, '|', 0), [Weight]=dbo.FN_SplitStringDelimiter(ItemValue, '|', 1)
		 , [Length]=dbo.FN_SplitStringDelimiter(ItemValue, '|', 2), Width=dbo.FN_SplitStringDelimiter(ItemValue, '|', 3), Height=dbo.FN_SplitStringDelimiter(ItemValue, '|', 4)
		 , CustReferences=ItemDesc, CaseNumber=dbo.FN_SplitStringDelimiter(ItemValue, '|', 5), CiplNumber=dbo.FN_SplitStringDelimiter(ItemValue, '|', 6)
		 , IsDelete=0, CreateBy=UserId, CreateDate=GETDATE(), UpdateBy=NULL, UpdateDate =NULL
	from @dtDHLDataType  
End  
GO
