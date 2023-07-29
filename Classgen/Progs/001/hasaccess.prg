PARAMETERS pProcess
IF UPPER(Goentorno.user.groupname)='MASTER'
	RETURN .t.
ENDIF
SaveAlias = ALIAS()
*  Note: CURSOR "Access" MUST BE CREATED WHEN USER LOGS IN
SELECT Access
PreviousExactSetting = SET("EXACT")
SET EXACT ON
SEEK UPPER ( pProcess )
ReturnValue = IIF( FOUND(), State, .F. )
SET EXACT &PreviousExactSetting
IF NOT EMPTY ( SaveAlias )
   SELECT    ( SaveAlias )
ENDIF
RETURN ReturnValue