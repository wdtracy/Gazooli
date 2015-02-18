USE [WorkforceMDM]
GO

SELECT [WorkforceId]
      ,p.[PositionId]
      ,[PositionHireDate]
      ,[PositionStatus]
      ,wp.[_Created]
      ,wp.[_CreatedBy]
      ,wp.[_LastModified]
      ,wp.[_LastModifiedBy]
	  ,p.PositionNumber
	  ,p.PositionTitle
	  ,p._Created
	  ,p._LastModified
  FROM [dbo].[Workforce_Position] wp
  join Position p on wp.PositionId = p.PositionId
  where workforceid is null and PositionStatus = 'Filled'
  order by PositionNumber
GO
