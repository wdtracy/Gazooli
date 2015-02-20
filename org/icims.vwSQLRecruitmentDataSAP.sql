--[icims].[vwSQLRecruitmentDataSAP] This version does not have pay data so it is safe to run
	
SELECT ROW_NUMBER() OVER (ORDER BY wf.PersonId ASC) AS RowId 
		,wf.PersonId
		,wf.WorkforceId
		,wp.FirstName
		,ISNULL(wp.MiddleInitial, '') AS MiddleInitial
		,wp.LastName
		,ISNULL(a.[Address], '') AS [Address]
		,ISNULL(a.Address2, '') AS Address2
		,ISNULL(c.CityName, '') AS CityName
		,ISNULL(sp.StateCode, '') AS StateCode
		,ISNULL(co.CountryCode, '') AS CountryCode
		,ISNULL(LEFT(a.PostalCode, 5), '') AS PostalCode
		,ISNULL(WorkforceMDM.dbo.udfRemoveNonNumericChar(
											(
												SELECT TOP 1 T.TelecomNumber 
												FROM snTelecom T
												INNER JOIN snTelecomType TT ON TT.TelecomTypeId = T.TelecomTypeId
												INNER JOIN snWorkforce_Telecom WT ON WT.TelecomId = T.TelecomId 
												WHERE TT.TelecomTypeName = 'Hired Applicant' 
												AND WT.WorkforceId = wf.WorkforceId)), '') AS TelecomNumber
		,pos.PositionNumber
		,CONVERT(VARCHAR(10), wf.ActiveHireDate, 112) AS ActiveHireDate
FROM snPosition pos
INNER JOIN snWorkforce_Position wpos ON wpos.PositionId = pos.PositionId
INNER JOIN snWorkforce wf ON wf.WorkforceId = wpos.WorkforceId
INNER JOIN snPerson wp ON wp.PersonId = wf.PersonId
LEFT JOIN snWorkforce_Address wa ON wa.WorkforceId = wf.WorkforceId
LEFT JOIN snAddress a ON a.AddressId = wa.AddressId
LEFT JOIN snCity c ON c.CityId = a.CityId
LEFT JOIN snStateProvince sp ON sp.StateId = c.StateId
LEFT JOIN snCountry co ON co.CountryId = sp.CountryId
--where wf.PersonId IN (14847, 14848)
WHERE wpos.PositionStatus = 'Hired Applicant'
and wf.WorkforceType = 'Hired Applicant'
