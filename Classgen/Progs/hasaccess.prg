PARAMETERS pProcess
#DEFINE ERRLOGACCESS	"c:\temp\NoAcceso.txt"
#DEFINE CRLF 			CHR(13)+CHR(10)

 
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

IF !ReturnValue
 	 STRTOFILE(TTOC(DATETIME()) +","+PROGRAM(1)+","+PROGRAM(2)+","+PROGRAM(3)+","+PROGRAM(4)+","+"Proceso: "+pProcess+CRLF,ERRLOGACCESS,.F.)
ENDIF
RETURN ReturnValue