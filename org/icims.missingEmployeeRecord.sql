-- This query will return those people that should be on the company lists, etc but aren't because they are not in the WorkforceMDM.dbo.Employee table

USE Staging
GO

SELECT main.*,
       NEWID() AS GuidKey
FROM
-- ensure uniqueness
(SELECT DISTINCT
        CAST(A.PERNR AS VARCHAR(8)) AS EmployeeId,
        A.NACHN                     AS LastName,
        A.RUFNM                     AS FirstNameKnownAs,
        A.INITS                        AS MiddleInitial,
        C.VORNA                    AS FirstName,
        D.TEXT1                      AS WorkforceStatus,
        A.MULTI_TERMS         AS MultipleTerms,
        A.EMP_STATUS,
        B.PERSG,
        H.WorkforceId,
        J.WorkforceId               AS iCimsTableWorkforceId,
        H.PersonId                  AS EmployeeTablePersonId,
        J.PersonId                  AS iCimsTablePersonId,
        CASE
          WHEN ( G.EmployeeId IS NOT NULL )
            THEN 1
          ELSE 0
        END                         AS EmployeeRecordExists,
        A.ITAR_ELIGIBLE,
        ( CASE
            WHEN LTRIM(RTRIM(A.HIRE_DATE)) = ''
                  OR A.HIRE_DATE IS NULL
              THEN NULL
            ELSE CONVERT(DATETIME, A.HIRE_DATE)
          END )                     AS HIRE_DATE,
        ( CASE
            WHEN LTRIM(RTRIM(A.TERM_DATE)) = ''
                  OR A.TERM_DATE IS NULL
              THEN NULL
            ELSE CONVERT(DATETIME, A.TERM_DATE)
          END )                     AS TERM_DATE,
        A.YRS_OF_SERVICE            AS YearsOfService,
        A.MOS_OF_SERVICE            AS MonthsOfService,
        A.WORKING_TITLE             AS PositionTitle,
        ( CASE
            WHEN IsNumeric(B.KOSTL) = 1
              THEN Cast(Cast(B.KOSTL AS INTEGER) AS NVARCHAR(10))
            ELSE B.KOSTL
          END )                     AS CostCenterCodeDerived,
        F.PTEXT                     AS EmployeeGroup,
        E.PTEXT                     AS FlsaType,
        I.RECRUITER_ROLE            AS RecruiterRole,
        Case When F.PERSG = 'X'Then 2 Else 1 End  AS PersonTypeId,
		cast(Case When F.PERSG = 'X'Then 'NonEmployee' Else 'Employee' End as nvarchar(50))  AS WorkforceType,
		WT.WorkforceTypeId
 FROM   Staging.sap.Z_FAC_EXTRACT AS A
 INNER JOIN Staging.sap.Z_PA0002_MDMV AS C ON A.PERNR = C.PERNR
 INNER JOIN Staging.sap.T529U AS D ON A.STAT2 = D.STATV
 INNER JOIN Staging.sap.Z_PA0001_MDMV AS B ON A.PERNR = B.PERNR
 LEFT OUTER JOIN Staging.sap.T503T AS E ON A.EMP_STATUS = E.PERSK
 LEFT OUTER JOIN Staging.sap.T501T AS F ON B.PERSG = F.PERSG
 LEFT OUTER JOIN WorkforceMdm.dbo.Employee G --  No Match in iCims Scenario
          ON G.EmployeeId = A.PERNR
 LEFT OUTER JOIN WorkforceMdm.dbo.Workforce H --  No Match in iCims Scenario
          ON H.WorkforceId = G.WorkforceId
 LEFT OUTER JOIN Staging.sap.ZHR_ICIMS_EXTRACT I -- Needed for iCims Scenario
          ON CAST(A.PERNR AS INT) = I.PERNR
 LEFT OUTER JOIN WorkforceMdm.dbo.Workforce J -- Needed for iCims Scenario
          ON J.PersonId = cast(I.PERSON_ID AS INT)
 LEFT OUTER JOIN WorkforceMdm.dbo.WorkForceType  WT
          ON WT.EmployeeGroup =F.PERSG and WT.SubGroup = E.PERSK
 LEFT OUTER JOIN PersonMdm.dbo.PersonType K
          ON WT.PersonTypeId = K.PersonTypeId

 WHERE  ( C.ENDDA >= GETDATE() )
        AND ( C.BEGDA <= GETDATE() )
        AND ( D.STATN = 2 )
        AND D.SPRSL = N'E'
        AND ( B.ENDDA >= GETDATE() )
        AND ( B.BEGDA <= GETDATE() )
        AND ( F.SPRSL = N'E' )
        AND ( E.SPRSL = N'E' ) 
) AS main
Where main.EmployeeRecordExists = 0 and WorkforceType = 'Employee'

