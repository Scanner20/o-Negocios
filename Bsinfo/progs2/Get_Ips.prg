#DEFINE CLS_NAME "clsIpAddr"
LOCAL loIpAddr, lbRetVal
loIpAddr = NEWOBJECT(CLS_NAME)
IF VARTYPE(loIpAddr) = 'O'
 LOCAL lcLocalHost
 lcLocalHost = loIpAddr.GetLocalHostName()
 IF !EMPTY(lcLocalHost)
  LOCAL lcIpAddr
  lcIpAddr = loIpAddr.GetHostIP(lcLocalHost)
  IF !EMPTY(lcIpAddr)
   CLEAR
   ?"Local host: "+lcLocalHost
   ?"IP address: "+lcIpAddr
   lbRetVal = .T.
  ELSE
   MESSAGEBOX("Can not define IP address for host: "+lcLocalHost, 16, _SCREEN.CAPTION)
  ENDIF
 ELSE
  MESSAGEBOX("Can not define local host.", 16, _SCREEN.CAPTION)
 ENDIF
ELSE
 MESSAGEBOX("Can not create '"+CLS_NAME+"' object", 16, _SCREEN.CAPTION)
ENDIF
RELEASE loIpAddr
CLEAR DLLS
RETURN lbRetVal

*////////////////////////////////////////////////////////////////////////////
#DEFINE WSADATA_SIZE 398
#DEFINE WS_VERSION  514  && 0x0202
#DEFINE HOSTENT_SIZE 16
#DEFINE SOCKET_ERROR -1
#DEFINE S_OK   0

DEFINE CLASS clsIpAddr AS SESSION
 PROTECTED bIsDecl
 PROTECTED bIsInitWinSock
 PROTECTED pWSADATA

 bIsDecl = .F.
 bIsInitWinSock = .F.
 pWSADATA = ""

 PROCEDURE INIT
  RETURN this.InitWinSock()
 ENDPROC

 PROCEDURE DESTROY
  this.ClearWinSock()
 ENDPROC

 FUNCTION GetLocalHostName
  * Returns the standard host name for the local machine
  LOCAL lcBuffer, lnResult
  lcBuffer = SPACE(250)
  lnResult = gethostname(@lcBuffer, LENC(lcBuffer))
  IF lnResult = S_OK
   RETURN SUBSTRC(lcBuffer, 1, ATC(CHR(0), lcBuffer)-1)
  ENDIF
  this.ShowLastWinSockErr()
  RETURN ""
 ENDFUNC

 FUNCTION GetHostIP
  LPARAMETERS tcHostname
  * Returns IP addres for the tcHostname
  LOCAL lcHOSTENTptr, lcHOSTENT, lnAddrlistPtr
  *
  * address for the HOSTENT structure
  lcHOSTENTptr = gethostbyname(tcHostname)
  IF lcHOSTENTptr <> 0
   lcHOSTENT = this.GetMemBuf(lcHOSTENTptr, HOSTENT_SIZE)
   *
   * a pointer to a null-terminated list of addresses
   lnAddrlistPtr = this.buf2dword(SUBSTRC(lcHOSTENT, 13, 4))
   RETURN this.GetIPfromHOSTENT(lnAddrlistPtr)
  ENDIF
  RETURN ""
 ENDFUNC

 PROTECTED PROCEDURE DECL
  IF !this.bIsDecl
   DECLARE INTEGER WSAStartup IN ws2_32 ;
    INTEGER wVerRq, STRING @lpWSAData
   DECLARE INTEGER WSACleanup IN ws2_32
   DECLARE INTEGER WSAGetLastError IN ws2_32
   DECLARE INTEGER gethostbyname IN ws2_32 ;
    STRING HOSTNAME
   DECLARE INTEGER gethostname IN ws2_32 ;
    STRING @NAME, INTEGER namelen
   DECLARE RtlMoveMemory IN kernel32 AS Heap2Str ;
    STRING @DEST, INTEGER Src, INTEGER nLength
   this.bIsDecl = .T.
  ENDIF
  RETURN this.bIsDecl
 ENDPROC

 PROTECTED FUNCTION InitWinSock
  LOCAL lnInitResult
  IF this.DECL() AND !this.bIsInitWinSock
   LOCAL lpWSAData
   lpWSAData = REPLICATE(CHR(0), WSADATA_SIZE)
   lnInitResult = WSAStartup(WS_VERSION, @lpWSAData)
   IF lnInitResult = S_OK
    this.pWSADATA = lpWSAData
    this.bIsInitWinSock = .T.
    RETURN .T.
   ENDIF
   this.ShowLastWinSockErr()
  ENDIF
  RETURN .F.
 ENDFUNC

 PROTECTED FUNCTION ClearWinSock
  IF this.bIsDecl AND this.bIsInitWinSock
   IF WSACleanup() = S_OK
    this.bIsInitWinSock = .F.
    RETURN .T.
   ELSE
    this.ShowLastWinSockErr()
   ENDIF
  ENDIF
  RETURN .F.
 ENDFUNC

 PROTECTED PROCEDURE ShowLastWinSockErr
  LOCAL lnWinSockErr, lcMsg
  lnWinSockErr = WSAGetLastError()
  lcMsg = "Windows Sockets Error code: "+LTRIM(STR(lnWinSockErr))
  = MESSAGEBOX(lcMsg, 16, _SCREEN.CAPTION)
 ENDPROC

 PROTECTED FUNCTION buf2dword
  LPARAMETERS lcBuffer
  RETURN ASC(SUBSTRC(lcBuffer, 1,1)) + ;
   ASC(SUBSTRC(lcBuffer, 2,1)) * 256 +;
   ASC(SUBSTRC(lcBuffer, 3,1)) * 65536 +;
   ASC(SUBSTRC(lcBuffer, 4,1)) * 16777216
 ENDFUNC

 PROTECTED FUNCTION GetIPfromHOSTENT
  LPARAMETERS tnAddrlistPtr
  * Retrieving IP address from the HOSTENT structure
  LOCAL lnDataAddress, lcResult
  lnDataAddress = this.buf2dword(this.GetMemBuf(tnAddrlistPtr, 4))
  RETURN IIF(lnDataAddress <> 0, this.GetIPAddress(this.GetMemBuf(lnDataAddress, 4)), "")
 ENDFUNC

 PROTECTED FUNCTION GetIPAddress
  LPARAMETERS tcAddrBuf
  * Converts 4-characters string buffer
  * to the IP address string representation
  LOCAL lcResult, lnCnt
  lcResult = ""
  FOR lnCnt=1 TO 4
   lcResult = lcResult;
    + LTRIM(STR(ASC(SUBSTRC(tcAddrBuf, lnCnt, 1))));
    + IIF(lnCnt=4, "", ".")
  ENDFOR
  RETURN lcResult
 ENDFUNC

 PROTECTED FUNCTION GetMemBuf
  LPARAMETERS tnAddr, tnBufsize
  LOCAL lcBuffer
  lcBuffer = REPLICATE(CHR(0), tnBufsize)
  = Heap2Str(@lcBuffer, tnAddr, tnBufsize)
  RETURN lcBuffer
 ENDFUNC

ENDDEFINE

********************
PROCEDURE Ip_Website
********************
lcHostName = "www.o-negocios.com"

  lcCommand = "%comspec% /c ping " + lcHostName + " -n 1 > ping.log"
  loWshShell = CREATEOBJECT("WScript.Shell")
  loWshShell.RUN(lcCommand, 0, .T.)

  lcPing = filetostr("ping.log")

** To view the result
  =MESSAGEBOX(m.lcPing)