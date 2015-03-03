-- This will show the most recent errors that have occurred since 1/1/2015

SELECT [FirstName]
      ,[MiddleName]
      ,[LastName]
      ,[StartDate]
      ,[PositionNumber]
      ,[EmployeeId]
      ,[WorkforceId]
      ,[ExternalRecruitmentId]
      ,MAX([CreatedTimeStamp])
      ,[ErrorDescription]
  FROM [dbo].[ErrorPosition]
  group by [FirstName]
      ,[MiddleName]
      ,[LastName]
      ,[StartDate]
      ,[PositionNumber]
      ,[PositionTitle]
      ,[CostCenter]
      ,[EmployeeId]
      ,[WorkforceId]
      ,[ExternalRecruitmentId]
      ,[ErrorDescription]
  having max(createdtimestamp) > '1/1/2015'
  order by max(createdtimestamp) desc
