USE [EMCS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<hasni>
-- Create date: <20191007>
---- =============================================
--DROP PROCEDURE [dbo].[SP_RAchievement_Chart] 
CREATE PROCEDURE [dbo].[SP_RAchievement_Chart] 
(
	@StartDate nvarchar(10),
	@EndDate nvarchar(10),
	@Cycle nvarchar(50) 
)	
AS
BEGIN	
	DECLARE @sql nvarchar(max);  

	SET @sql = 'SELECT 
		CAST(AVG(achievement) as int) TotAchievement
	FROM
	(SELECT
			t3.Name,
			ISNULL(
				CAST(
					IIF(t1.Actual = NULL, 0, IIF(t1.Actual <= t3.TargetDays, 100, t3.TargetDays/t1.Actual*100)) as decimal(18,0))
			, 0) [Achievement]
		FROM
		(SELECT [Value], [Name], [Description] [TargetDays]
			FROM MasterParameter
			WHERE [group]=''Achievement'') t3
		LEFT JOIN 
		(
		--cipl approved
		SELECT 
			t1.[Name],
			CAST(AVG(
				CAST(
					CAST(DATEDIFF(hour,t0.CreateDate,t1.ApprovedDate) as decimal(18,3)) 
					/ CAST(''24'' as decimal(18,3)) as decimal(18,2)
				)
			) as decimal(18,1)) as [Actual]
		FROM
			Cipl t0
			JOIN (
				SELECT max(CreateDate) as [ApprovedDate], IdCipl, ''1'' as [Name]
				  FROM [EMCS].[dbo].[CiplHistory] t0
				where Status = ''Approve''
				GROUP BY IdCipl) as t1 
			on t1.IdCipl = t0.id
		GROUP BY t1.[Name]

		UNION 

		--pickup goods
		SELECT 
			t2.[Name],
			CAST(AVG(
				CAST(
					CAST(DATEDIFF(hour,t2.ApprovedDate, t0.ActualTimePickup) as decimal(18,3)) 
					/ CAST(''24'' as decimal(18,3)) as decimal(18,2)
				)
			) as decimal(18,1)) as [Actual] 
		FROM
		GoodsReceive t0
		JOIN GoodsReceiveItem t1 on t1.IdGr = t0.Id
		JOIN (
			SELECT max(t0.CreateDate) as [ApprovedDate], EdoNo, ''2'' as [Name]
			  FROM [EMCS].[dbo].CiplHistory t0
			  join Cipl t1 on t1.id = t0.IdCipl
			where Status = ''Approve''
			GROUP BY EdoNo) as t2
		on t2.EdoNo = t1.DoNo
		GROUP BY t2.Name
	
		UNION 

		--NPE PEB
		SELECT 
			t0.[Name],
			CAST(AVG(
				CAST(
					CAST(DATEDIFF(hour,t0.PebDate,t0.NpeDate) as decimal(18,3)) 
					/ CAST(''24'' as decimal(18,3)) as decimal(18,2)
				)
			) as decimal(18,1)) as [Actual]
		FROM
			(SELECT PebDate, NpeDate, ''3'' [Name] FROM Cargo) t0
		GROUP BY t0.[Name]

		UNION 

		--BL/AWB
		SELECT 
			t0.[Name],
			CAST(AVG(
				CAST(
					CAST(DATEDIFF(hour,t0.NpeDate,t0.BlDate) as decimal(18,3)) 
					/ CAST(''24'' as decimal(18,3)) as decimal(18,2)
				)
			) as decimal(18,1)) as [Actual]
		FROM
			(SELECT NPEDate, BlDate, ''4'' [Name] FROM Cargo) t0
		GROUP BY t0.[Name]

		) as t1 on t3.Value = t1.[Name]
		
	) achieved';

	IF (@Cycle <> '')
	BEGIN
		SET @sql += ' WHERE [Name] = ''' + @Cycle + '''';
	END

	--select @sql;
	EXECUTE(@sql);
END
GO
