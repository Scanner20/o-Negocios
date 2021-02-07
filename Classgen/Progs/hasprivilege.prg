*========================================================================================
* Returns 0 if the user doesn't have a particulare privilege. The return value is 1 if 
* the user has the privilege, but it is disabled. 2 means the user has the privilege 
* and it's enabled.
*
* Check, if the user is allowed to install a printer:
*
* ? HasPrivilege( "SeLoadDriverPrivilege" )
*
* Written by Christof Wollenhaupt
*========================================================================================
LParameter tcPrivilege

	*--------------------------------------------------------------------------------------
	* Declare API functions
	*--------------------------------------------------------------------------------------
	Declare Long OpenProcess in Win32API ;
		Long fdwAccess, ;
		Long fInherit, ;
		Long IDProcess
	Declare Long OpenProcessToken in Win32API ;
		Long ProcessHandle, ;
		Long DesiredAccess, ;
		Long @TokenHandle
	Declare CloseHandle in Win32API Long
	Declare Long LookupPrivilegeValue in Win32API ;
		String lpSystemName, ;
		String lpName, ;
		String qlpLuid
	Declare Long GetTokenInformation in Win32API ;
	  Long TokenHandle, ;
  	Long TokenInformationClass, ;
  	String @TokenInformation, ;
  	Long TokenInformationLength, ;
  	Long @ReturnLength

	*--------------------------------------------------------------------------------------
	* Get Client Token
	*--------------------------------------------------------------------------------------
	#DEFINE  PROCESS_QUERY_INFORMATION 0x400
	#DEFINE TOKEN_QUERY 8
	Local lnProcess, lnClientToken
	lnProcess = OpenProcess( PROCESS_QUERY_INFORMATION, 0, _VFP.Processid )
	lnClientToken = 0
	OpenProcessToken( m.lnProcess, TOKEN_QUERY, @lnClientToken )

	*--------------------------------------------------------------------------------------
	* Get LUID for privilege 
	*--------------------------------------------------------------------------------------
	Local lcLUID
	lcLUID = Space(8)
	LookupPrivilegeValue( NULL, m.tcPrivilege, @lcLUID )

	*--------------------------------------------------------------------------------------
	* If the token is not enabled, we need to check if the user has got the privilege
	* at all.
	*--------------------------------------------------------------------------------------
	#DEFINE ENUM_TokenPrivileges 3
	Local lcTokenPrivileges, lnSize, lnReturn
	lnSize = 0
	lcTokenPrivileges = Space(2048)
 		lnReturn = GetTokenInformation( ;
		m.lnClientToken, ;
		ENUM_TokenPrivileges, ;
		@lcTokenPrivileges, ;
		Len(m.lcTokenPrivileges), ;
		@lnSize ;
	)
	If m.lnReturn == 0
		lcTokenPrivileges = ""
	Else
  	lcTokenPrivileges = Left(m.lcTokenPrivileges,m.lnSize)
  EndIf 
	
	*--------------------------------------------------------------------------------------
	* Check if the requested privilege is among those assigned to the token.
	*--------------------------------------------------------------------------------------
	#DEFINE SE_PRIVILEGE_ENABLED 2
	Local lnToken, llFound, llEnabled, lcCurLUID, lnAttributes
	llFound = .F.
	If not Empty(m.lcTokenPrivileges)
		For lnToken = 1 to CToBin(Left(m.lcTokenPrivileges,4),"RS")
			lcCurLUID = Substr( m.lcTokenPrivileges, (m.lnToken-1)*12+1+4, 8 )
			If m.lcCurLUID == m.lcLUID
				llFound = .T.
				lnAttributes = CToBin(Substr(m.lcTokenPrivileges,(m.lnToken-1)*12+1+4+8,4),"RS")
				If Bittest(m.lnAttributes,1)
					llEnabled = .T.
				Else
					llEnabled = .F.
				EndIf 
			EndIf 
		EndFor 
	EndIf 

	*--------------------------------------------------------------------------------------
	* Close handles
	*--------------------------------------------------------------------------------------
	CloseHandle( m.lnProcess )
	CloseHandle( m.lnClientToken )
	
	*--------------------------------------------------------------------------------------
	* Determine the return value
	*--------------------------------------------------------------------------------------
	Local lnReturn
	If m.llFound
		If m.llEnabled
			lnReturn = 2
		Else
			lnReturn = 1
		EndIf
	Else 
		lnReturn = 0
	EndIf 
	
Return m.lnReturn