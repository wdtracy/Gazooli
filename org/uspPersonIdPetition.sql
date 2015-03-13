-- This is the stored procedure that returns a person ID

USE [PersonMDM]
GO
/****** Object:  StoredProcedure [dbo].[uspPersonIdPetition]    Script Date: 3/10/2015 10:38:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[uspPersonIdPetition]
       @PersonIdToCheck int = NULL
      ,@FirstName nvarchar(50)
      ,@FirstNameKnownAs nvarchar(50) = NULL
      ,@MiddleInitial nvarchar(50) = NULL
      ,@LastName nvarchar(50)
      ,@Suffix nvarchar(10) = NULL
      ,@MaidenName nvarchar(50) = NULL
      ,@PersonTypeName nvarchar(50)
      ,@NaturalKey varchar(20)
AS

/******************************************************************************************
Purpose:  Used to Petition for a PersonId

Where Used: MDM

Target Database: PersonMdm

Database Referenced: PersonMdm
                     WorkforceMdm

Return: INT --> PersonId | If err, return value will be 0

Mod By  Date      Comments
------  --------  -----------------------------------------------------
RH      03/05/12  Create date.
RH      03/30/12  Error handling refinement.
BR		12/27/12  Recode and added functionality
SR		01/08/13  Added is null check
                  
Sample Usage:
  DECLARE   
       @PersonId int = NULL
      ,@FirstName nvarchar(50) = 'George'
      ,@FirstNameKnownAs nvarchar(50) = 'G'
      ,@MiddleInitial nvarchar(50) = 'I'
      ,@LastName nvarchar(50) = 'Joe'
      ,@Suffix nvarchar(10) = 'Jr'
      ,@MaidenName nvarchar(50) = NULL
      ,@PersonTypeName varchar(20) = 'Employee'
      ,@NaturalKey nvarchar(20) = '9876'  
      
  EXEC @PersonId = WorkforceMdm.dbo.snUspPersonPetition @PersonId,@FirstName,@FirstNameKnownAs,@MiddleInitial,@LastName,@Suffix,@MaidenName,@PersonTypeName,@NaturalKey
  PRINT @PersonId
select * from vwPerson where PersonId = 9249
select * from vwPersonType
select * from PersonReference  where PersonId = 9249
******************************************************************************************/

SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON

DECLARE @PersonIdRet INT = @PersonIdToCheck
DECLARE @ErrorDescription VARCHAR(200) = NULL
DECLARE @PersonTypeId INT = 0
DECLARE @PersonTypeFound BIT = 0

------------------------------------------------------------------------
-------- VALIDATE PROVIDED PERSON ID -----------------------------------
------------------------------------------------------------------------
IF (@PersonIdToCheck IS NOT NULL)
BEGIN
	SELECT @PersonIdRet = PersonId 
	FROM vwPerson 
	WHERE PersonId = @PersonIdToCheck

	IF(@PersonIdRet IS NULL)
	BEGIN
		SET @ErrorDescription = 'uspPersonIdPetition - The Person Id supplied does not exist in the Person table'
		print @ErrorDescription
		GOTO ERROR_CONDITION
	END
	ELSE
		RETURN(@PersonIdRet)
END

------------------------------------------------------------------------
-------- VALIDATE THE PERSON TYPE --------------------------------------
------------------------------------------------------------------------
IF(@PersonTypeName IS NOT NULL)
BEGIN
	SET @PersonTypeId = (SELECT PersonTypeId FROM vwPersonType WHERE PersonTypeName = @PersonTypeName)
	
	IF(@PersonTypeId IS  NULL)
	BEGIN
		SET @ErrorDescription = 'uspPersonIdPetition - The Person Type Name could not be found.'
		print @ErrorDescription
		GOTO ERROR_CONDITION
	END	
END

------------------------------------------------------------------------
-------- VALIDATE PROVIDED NATURAL KEY ---------------------------------
------------------------------------------------------------------------
IF (@PersonIdToCheck IS NULL AND @PersonTypeName + @NaturalKey IS NOT NULL)
	BEGIN

	    -- Check With Type ID for person as employee as 1st priority
		 SELECT @PersonIdRet = P.PersonId
			FROM dbo.vwPerson P
			INNER JOIN dbo.vwPersonReference PR ON PR.PersonId = P.PersonId
			INNER JOIN dbo.PersonType PT ON PT.PersonTypeId = PR.PersonTypeId
			WHERE PR.NaturalKey = @NaturalKey
			AND PT.PersonTypeId = @PersonTypeId
			AND P.IsDuplicate = 0


		   -- Check With Type ID for Hired applicant as st priority
		   IF @PersonIdRet IS NULL
					SELECT @PersonIdRet = P.PersonId 
					FROM dbo.vwPerson P
					WHERE P.PersonId = (SELECT TOP 1 P.PersonId 
											FROM dbo.vwPerson P
											INNER JOIN dbo.vwPersonReference PR ON PR.PersonId = P.PersonId
											INNER JOIN dbo.PersonType PT ON PT.PersonTypeId = PR.PersonTypeId
											WHERE PR.NaturalKey = @NaturalKey
											Order By PT.PersonTypeId
										)


       


     -- Update Natural PersonID for all fount Natural Keys
	 IF @PersonIdRet IS NOT NULL

			BEGIN

			
				IF NOT EXISTS (SELECT 1 
									FROM dbo.vwPersonReference PR 
									WHERE PR.PersonId = @PersonIdRet
									AND PR.PersonTypeId = @PersonTypeId ) 
					 INSERT INTO PersonReference
						( 
							PersonId
						   ,PersonTypeId
						   ,NaturalKey
						 )
						VALUES
						( 
							@PersonIdRet
						   ,@PersonTypeId
						   ,@NaturalKey
						 )
			END

	END


 


------------------------------------------------------------------------
-------- RETURN PERSON ID FOR A NEW NATURAL KEY WHEN A FORMER ----------
-------- KEY EXISTS AND UPDATE INFO ACCORDINGLY ------------------------
------------------------------------------------------------------------
--IF(@NewNaturalKey + @NaturalKey IS NOT NULL)
--BEGIN
--	IF((SELECT COUNT(*) FROM vwPersonReference WHERE NaturalKey = @NewNaturalKey) > 0)
--	BEGIN
--		SET @ErrorDescription = 'uspPersonIdPetition - Natural Key Collision, the specified New Natural Key is already in use.'
--		GOTO ERROR_CONDITION
--	END

--	IF((SELECT COUNT(*) FROM vwPersonReference WHERE NaturalKey = @NaturalKey) = 0)
--	BEGIN
--		SET @ErrorDescription = 'uspPersonIdPetition - Original Natural Key could not be located.'
--		GOTO ERROR_CONDITION
--	END

--	SELECT @PersonIdRet = PersonId
--	FROM vwPersonReference
--	WHERE NaturalKey = @NaturalKey

--	UPDATE vwPersonReference
--	SET NaturalKey = @NewNaturalKey
--	   ,PersonTypeId = @PersonTypeId
--	WHERE PersonId = @PersonIdRet

--	RETURN (@PersonIdRet)
--END

------------------------------------------------------------------------
-------- NULL PERSON ID, LET'S INSERT A NEW RECORD ---------------------
------------------------------------------------------------------------
IF @PersonIdRet IS NULL 
		BEGIN
			INSERT INTO dbo.vwPerson
			( 
				FirstName
				,MiddleInitial
				,LastName
				,Suffix
				,FirstNameKnownAs
				,MaidenName
			)
			VALUES
			(
				@FirstName
				,@MiddleInitial
				,@LastName
				,@Suffix
				,@FirstNameKnownAs
				,@MaidenName
			)

			SET @PersonIdRet = SCOPE_IDENTITY()
	
			INSERT INTO PersonReference
			( 
				PersonId
			   ,PersonTypeId
			   ,NaturalKey
			 )
			VALUES
			( 
				@PersonIdRet
			   ,@PersonTypeId
			   ,@NaturalKey
			 )



		END
ELSE
		BEGIN
			UPDATE dbo.vwPerson
			SET FirstName = @FirstName
			   ,MiddleInitial = @MiddleInitial
			   ,LastName = @LastName
			   ,Suffix = @Suffix
			   ,MaidenName = @MaidenName
			   ,FirstNameKnownAs = @FirstNameKnownAs
			WHERE PersonId = @PersonIdRet


			--have a person id but check to see if there is a reference record of this type
			--this is to handle iCims created record but no employee type in PersonReference
			SELECT @PersonTypeFound = 1
			FROM   dbo.PersonReference PR  
			WHERE PR.PersonTypeId = @PersonTypeId
			AND PR.PersonId = @PersonIdRet

		END
 
------------------------------------------------------------------------
-------- PROCESS THE PERSON REFERENCE TABLE ----------------------------
------------------------------------------------------------------------
IF(@PersonTypeFound  IS NULL)
BEGIN
	INSERT INTO PersonReference
    ( 
		PersonId
	   ,PersonTypeId
	   ,NaturalKey
     )
	VALUES
    ( 
		@PersonIdRet
	   ,@PersonTypeId
	   ,@NaturalKey
     )
END

RETURN @PersonIdRet

------------------------------------------------------------------------
-------- ERROR LOGGING -------------------------------------------------
------------------------------------------------------------------------
ERROR_CONDITION:
BEGIN
	INSERT INTO dbo.snErrorPerson
		(  
			PersonId
		   ,FirstName
		   ,FirstNameKnownAs
		   ,MiddleInitial
		   ,LastName
		   ,Suffix
		   ,MaidenName
		   ,ErrorDescription
		)
	VALUES
		(  
			@PersonIdToCheck
		   ,@FirstName
		   ,@FirstNameKnownAs
		   ,@MiddleInitial
		   ,@LastName
		   ,@Suffix
		   ,@MaidenName
		   ,@ErrorDescription
		)
	RETURN (0)
END

SET QUOTED_IDENTIFIER ON
SET NOCOUNT OFF




------------------------------------------------ Create Synonyms---------------------------------------------------------------------------






