USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ShipmentDhlGetList]
(    
	@ConsigneeName NVARCHAR(200),
	@CreateBy NVARCHAR(200)
)
AS
BEGIN
	DECLARE @Sql nvarchar(max);
	DECLARE @WhereSql nvarchar(max) = '';
	DECLARE @RoleID bigint;
	DECLARE @area NVARCHAR(max);
	DECLARE @role NVARCHAR(max);
	DECLARE @usertype NVARCHAR(max);

	SELECT @area = U.Business_Area
		,@role = U.[Role],@usertype = UserType
	FROM dbo.fn_get_employee_internal_ckb() U
	WHERE U.AD_User = @CreateBy;

	
	if @role !=''
	BEGIN
	IF (@role !='EMCS IMEX' and @CreateBy !='xupj21fig' and @CreateBy !='ict.bpm' and @usertype !='ext-imex' )
	BEGIN
		SET @WhereSql = ' AND s.CreateBy='''+@CreateBy+''' ';
	END

	IF @ConsigneeName <> ''
	BEGIN
		SET @WhereSql = ' AND (s.IdentifyNumber LIKE ''%'+@ConsigneeName+'%'' ';
	END

	SET @sql = 'Select Distinct s.DhlShipmentId As Id, 
			ISNULL(s.IdentifyNumber, ''-'') AS AwbNo
			, p.CompanyName AS ConsigneeName
			, s.ShipTimestamp AS BookingDate
			, IIF(s.IdentifyNumber = '''' OR s.IdentifyNumber = null OR s.IdentifyNumber = ''-'', ''Draft'', ''On Progress'') AS StatusViewByUser 
		FROM DHLShipment s
		JOIN DHLPerson p ON p.DHLShipmentID = s.DHLShipmentID AND p.IsDelete = 0 AND p.PersonType = ''RECIPIENT''
		WHERE 1=1 '+@WhereSql+'
		AND s.IsDelete = 0	
		ORDER BY s.DhlShipmentId DESC';
		print (@WhereSql);
		print (@sql);
	exec(@sql);	
	END
END
GO
