USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[fn_get_next_approval]
(
	-- Add the parameters for the function here
	@Type nvarchar(100),
	@LastUser nvarchar(100),
	@GroupID nvarchar(100),
	@Creator nvarchar(100),
	@IdRequest nvarchar(100) = '0'
)
RETURNS nvarchar(100)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result nvarchar(100);
	DECLARE @BArea nvarchar(100);
	DECLARE @SuperiorUsername nvarchar(500);
	SELECT @BArea = Business_Area FROM employee WHERE AD_User = @LastUser;

	-- Add the T-SQL statements to compute the return value here
	IF @Type = 'Superior' 
	BEGIN
		SELECT @SuperiorUsername = SuperiorUsername FROM mastersuperior WHERE IsDeleted = 0 AND employeeUsername = @Creator;
		IF ISNULL(@SuperiorUsername, '') = ''
		BEGIN
			SELECT @Result = t1.AD_User from employee as t0
			inner join employee as t1 on t1.Employee_Id = t0.Superior_ID
			WHERE t0.AD_User = @Creator
		END
		ELSE
		BEGIN
			SET @Result = @SuperiorUsername;
		END
  
	END 
 
	IF @Type = 'Group' 
	BEGIN
		SELECT @SuperiorUsername = SuperiorUsername FROM mastersuperior WHERE IsDeleted = 0 AND employeeUsername = @Creator;
        IF ISNULL(@SuperiorUsername, '') = ''   
        BEGIN
            IF EXISTS	(SELECT	TOP	1 *
                        FROM	employee
                        WHERE	Organization_Name LIKE '%' + @GroupID +'%'
                                AND Employee_Name LIKE '%Asmat%')
            BEGIN
                SELECT	@Result = AD_User 
                FROM	employee
                WHERE	Organization_Name LIKE '%Import Export%'
                        AND Employee_Name LIKE '%Asmat%' 
            END
            ELSE
            BEGIN
				SET @Result = @GroupID 
			END
		END  
	END

	IF @Type = 'Requestor' 
	BEGIN
		SET @Result = @Creator
	END

	IF @Type IN ('Region Manager', 'Area Manager')
	BEGIN
		SET @Result = @BArea;
	END

	IF @Type = 'PPJK'
	BEGIN
		DECLARE @UserName nvarchar(100);
		SELECT TOP 1 @UserName = Username FROM dbo.MasterAreaUserCKB where BAreaCode = @BArea AND IsActive = 1;
		SELECT @Result = @UserName FROM PartsInformationSystem.dbo.UserAccess where UserID =  @UserName;
	END 

	IF @Type = 'AreaCipl'
	BEGIN
		DECLARE @RequestorName nvarchar(50);
		DECLARE @DataId bigint;
		select @DataId = IdGr from dbo.RequestGr where Id = @IdRequest
		select @Result = PickupPic FROM dbo.GoodsReceive where Id = @DataId;
	END 

	RETURN @Result;

END

GO
