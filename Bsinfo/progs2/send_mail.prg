** Ejemplo 1:
=SendSmtpEmail('dominio.com','userFROM@dominio.com','userTO@correo.com','SUBJECT','MENSAJE','X:\Ruta\Nombrearchivo.xxx')

** Ejemplo 2:
=SendSmtpMail2()

FUNCTION SendSmtpEmail


* strServ: The SMTP server to use.  Can be in the following formats:
*           xxx.xxx.xxx.xxx  "xxx.xxx.xxx.xxx:port"  "xxx.xxx.xxx.xxx port"
*           ServerName       "servername:port"       "servername port"
* strFrom: The email address to provide as the "FROM" address
* strTo:   The email address to send the email to.
* strSubj: Subject for the email
* strMsg:  The Message to include as the body of the email.
* oFB_Attachments: Comma separated list of files to attach (full path to each file)
*          (for backward compatibility, the Feedback object can be passed as this parameter)
*          All Attachments+message can be at most 16MB right now, because of VFP string size limit.
* oFeedBack: An object with a method "FeedBack" that expects one string property.
*            If not provided, the feedback messages will be output to the console through "?".
*            Pass .NULL. (or an object without "Feedback" method) to turn off all feedback.
*
* Updated: April 1, 2004: Fixed RCPT TO handling to properly
*                         bracket the email address.

LPARAMETERS strServ, strFrom, strTo, strSubj, strMsg, oFB_cAttachments, oFeedBack
#DEFINE crlf chr(13)+chr(10)
#DEFINE TIME_OUT 5

LOCAL Sock, llRet, lnI, laTO[1], lnCnt, lcServ, lnServPort
LOCAL lnTime, lcOutStr, Junk, lcAttachments, loFB, laAtch[1], lnAtchCnt
LOCAL laFiles[1]

lcMsg         = strMsg
lcAttachments = oFB_cAttachments
loFB          = oFeedback
if TYPE('oFB_cAttachments')='O'
  loFB = oFB_cAttachments
  lcAttachments = ''
endif

* Load Attachments
if TYPE('lcAttachments')='C' and not empty(lcAttachments)
  lnAtchCnt = ALINES( laAtch, StrTran(lcAttachments,',',chr(13)) )
  lcMsg = lcMsg + crlf + crlf
  for lnI = 1 to lnAtchCnt
    if ADIR(laFiles,laAtch[lnI])=0
      GiveFeedBack( loFB, "ERROR: Attachment Not Found:"+laAtch[lnI] )
      RETURN .F.
    endif
    lcAtch = FileToStr( laAtch[lnI] )
    if empty(lcAtch)
      GiveFeedBack( loFB, "ERROR: Attachment Empty/Could not be Read:"+laAtch[lnI] )
      RETURN .F.
    endif

    GiveFeedBack( loFB, "Encoding file: "+laAtch[lnI] )
    lcAtch = UUEncode( laAtch[lnI], lcAtch )

    lcMsg = lcMsg + lcAtch
    lcAtch = '' && free memory
  endfor
endif


GiveFeedBack( loFB, "Connecting to Server: "+strServ )

Sock=create('mswinsock.winsock')
** OR
*  Sock=create('vfpWinSock')
** to use the winsock emulator class below (wayyyy below!) to avoid
**   the licensing issues stemming from OCX's, and to avoid having to
**   register MSWINSCK.OCX on the customers' machines.

llRet = .F.



lnServPort = 25
lcServ     = strServ
do case && Find Port
  case ':' $ lcServ
    lnAt = at(':',lcServ)
    lnServPort = val( Substr(lcServ, lnAt+1) )
    lcServ = left( lcServ, lnAt-1 ) && moved below "lnServPort =...."
    if lnServPort<=0
      lnServPort = 25
    endif
  case ' ' $ lcServ
    lnAt = at(' ',lcServ)
    lnServPort = val( Substr(lcServ, lnAt+1) )
    lcServ = left( lcServ, lnAt-1 ) && moved below "lnServPort =...."
    if lnServPort<=0
      lnServPort = 25
    endif
endcase

sock.Connect(strServ,lnServPort)
lnTime = seconds()

DO WHILE .T. && Control Loop

  if sock.State <> 7 && Connected
    GiveFeedBack( loFB, "Waiting to connect..." )
    inkey(0.1)
    if seconds() - lnTime > TIME_OUT
      GiveFeedBack( loFB, "Connect Timed Out")
      EXIT && Leave Control Loop
    endif
    LOOP  && Wait to connect
  endif

  GiveFeedBack( loFB, "Connected." )

  if not ReadWrite(sock,"HELO " + alltrim(strServ), 220)
    GiveFeedBack( loFB, "Failed HELO" )
    EXIT && Leave Control Loop
  endif

  If Not ReadWrite(sock,"MAIL FROM: " + alltrim(strFrom), 250)
    GiveFeedBack( loFB, "Failed MAIL" )
    EXIT
  endif

  lnCnt = aLines(laTo, ChrTran(strTo,' ,;',chr(13)))
  * once for each email address
  for lnI = 1 to lnCnt
    if not empty(laTo[lnI])
      lcTo = iif( '<' $ laTo[lnI], laTo[lnI], '<' + alltrim(laTo[lnI]) + '>' )
      If Not ReadWrite(sock,"RCPT TO: " + lcTo, 250)
        GiveFeedBack( loFB, "RCPT Failed" )
        EXIT && Leave Control Loop
      endif
    endif
  endfor

  If Not ReadWrite(sock,"DATA", 250)
    GiveFeedBack( loFB, "Failed DATA" )
    EXIT && Leave Control Loop
  endif
  * tran(day(date()))+' '+tran(month(date()))+' '+tran(year(date()));
  *    + ' ' +tran(hour(datetime()))+':'+tran(minute(datetime()))+':'+tran(sec(datetime())) +crlf

  lcOutStr = "DATE: " + GetSMTPDateTime() +crlf;
           + "FROM: " + alltrim(strFrom) + CrLf ;
           + "TO: " + alltrim(strTo) + CrLf ;
           + "SUBJECT: " + alltrim(strSubj) ;
           + crlf ;
           + crlf ;
           + lcMsg
  * remove any inadvertant end-of-data marks:
  lcOutStr = StrTran(lcOutStr, crlf+'.'+crlf, crlf+'. '+crlf)
  * Place end of data mark on end:
  lcOutStr = lcOutStr + crlf + "."
  If Not ReadWrite(sock,lcOutStr, 354 )

    GiveFeedBack( loFB, "Failed DATA (Cont'd)" )
    EXIT && Leave Control Loop
  ENDIF

  * Simon Cropper: If using vfpWinSock and you are sending emails with large attachements you should
  * delay the following QUIT command until the email has has a chance to 'get out the building', otherwise
  * the program enters the IF...ENDIF construct and exits the DO...ENDDO without the llRet being set to TRUE.
  * Outcome: Email sent but program records an error => user keeps trying to send email = upset customer!

  If Not ReadWrite(sock,"QUIT", 250)
    GiveFeedBack( loFB, "Failed QUIT" )
    EXIT && Leave Control Loop
  endif

  GiveFeedBack( loFB, "Email Sent!" )
  llRet = .T.
  EXIT && Leave Control Loop
ENDDO

* Do cleanup code.
Junk = repl(chr(0),1000)
if sock.state = 7 && Connected
  sock.GetData(@Junk)
endif
sock.close
sock = .null.
RETURN llRet
*--------------------------------------------------
Function GiveFeedback( oFB, cMsg )
  if VarType(oFB)='O' or IsNull(oFB)
    if NOT IsNull(oFB) and PEMStatus(oFB,'Feedback',3)='Method'
      RETURN oFB.Feedback( cMsg )
    else
      RETURN .T. && Hide Feedback
    endif
  else
    ?cMsg
  endif
ENDFUNC
*--------------------------------------------------
  FUNCTION GetSMTPDateTime
  * Wed, 12 Mar 2003 07:54:56 -0500
  LOCAL lcRet, ltDT, lnBias
    ltDT = DateTime()
    if 'UTIL' $ set('PROC')
      lnBias = GetTimeZone('BIAS') && In Util.prg
    else
      lnBias = -5 && EST
    endif
    lcBias = iif( lnBias<0, '+', '-' )
    lnBias = abs(lnBias)
    lcBias = lcBias+PadL(Tran(lnBias/60),2,'0')+PadL(Tran(lnBias%60),2,'0')
    lcRet = LEFT( CDOW(ltDT), 3 )+', '+Str( Day(ltDt), 2 ) + ' ' + LEFT( CMONTH(ltDT), 3);
            +' '+TRAN( Year(ltDT) )+' '+PadL(Tran(hour(ltDT)),2,'0')+':';
            +PadL(Tran(Minute(ltDT)),2,'0')+':';
            +PadL(Tran(Sec(ltDT)),2,'0')+' ';
            +lcBias
  RETURN lcRet
  ENDFUNC
*--------------------------------------------------
Function ReadWrite( oSock, cMsgOut, iExpectedCode )
LOCAL cMsgIn, iCode, lnTime
  lnTime = seconds()

  do while oSock.BytesReceived = 0
*   ?"Waiting to Receive data..."
   inkey(0.2)
   if seconds() - lnTime > TIME_OUT
*     ?"Timed Out"
     return .F.
   endif
  enddo

  cMsgIn = repl(chr(0),1000)
  oSock.GetData(@cMsgIn)
*?"expected:",iExpectedCode
*
*?"resp:",cMsgIn
  iCode = Val(Left(cMsgIn, 3))
*?"Got:",icode
  If iCode = iExpectedCode
    oSock.SendData( cMsgOut + CrLf )
  Else
*    ?"Failed; Code="+cMsgin
*    ?"Code="+tran(iCode)
    RETURN .F.
  Endif
RETURN .T.
FUNCTION GetTimeZone( pcFunc )
* Purpose: Return the Time Zone bias or description
*   Input: pcFunc = "BIAS" or Missing... return the bias in Minutes
*                     ( GMT = LocalTime + Bias )
*          pcFunc = "NAME" ... Return the time zone name.
*  Author: William GC Steinford
***********************************************************

*!*	typedef struct _TIME_ZONE_INFORMATION {
*!*	    LONG       Bias;                    2:  1-  2
*!*	    WCHAR      StandardName[ 32 ];     64:  3- 66
*!*	    SYSTEMTIME StandardDate;           16: 67- 82
*!*	    LONG       StandardBias;            2: 83- 84
*!*	    WCHAR      DaylightName[ 32 ];     64: 85-148
*!*	    SYSTEMTIME DaylightDate;           16:149-164
*!*	    LONG       DaylightBias;            2:165-166
*!*	} TIME_ZONE_INFORMATION, *PTIME_ZONE_INFORMATION;
*!*	typedef struct _SYSTEMTIME {
*!*	    WORD wYear;
*!*	    WORD wMonth;
*!*	    WORD wDayOfWeek;
*!*	    WORD wDay;
*!*	    WORD wHour;
*!*	    WORD wMinute;
*!*	    WORD wSecond;
*!*	    WORD wMilliseconds;
*!*	} SYSTEMTIME, *PSYSTEMTIME;
LOCAL lcTZInfo, lcDesc
lcTZInfo = num2dword(0);
           +repl(chr(0),64)+repl(num2Word(0),8)+num2dword(0);
           +repl(chr(0),64)+repl(num2Word(0),8)+num2dword(0)
DECLARE INTEGER GetTimeZoneInformation IN kernel32.dll;
    STRING @ lpTimeZoneInformation
#DEFINE TIME_ZONE_ID_INVALID  0xFFFFFFFF
#DEFINE TIME_ZONE_ID_UNKNOWN  0
#DEFINE TIME_ZONE_ID_STANDARD 1
#DEFINE TIME_ZONE_ID_DAYLIGHT 2
lcRes = GetTimeZoneInformation( @lcTZInfo )
lnBias = Buf2DWord( lcTZInfo )
lcDesc = "Unknown"
do case
  case lcRes=TIME_ZONE_ID_STANDARD
    lcDesc = substr( lcTZInfo, 3, 64 )
    lcDesc = StrConv( lcDesc, 6 ) && 6=Unicode(wide)->DoubleByte
    lcDesc = strTran( lcDesc, chr(0), '' )
  case lcRes=TIME_ZONE_ID_DAYLIGHT
    lcDesc = substr( lcTZInfo, 3, 64 )
    lcDesc = StrConv( lcDesc, 6 )
    lcDesc = strTran( lcDesc, chr(0), '' )
endcase
if varType(pcFunc)='C' and pcFunc='NAME'
  RETURN lcDesc
endif

RETURN lnBias
ENDFUNC
* * *
* dword is compatible with LONG
FUNCTION num2Long( lnValue )

  RETURN num2Dword(lnValue)
ENDFUNC
FUNCTION num2dword (lnValue)
#DEFINE m0       256
#DEFINE m1     65536
#DEFINE m2  16777216
  LOCAL b0, b1, b2, b3
  b3 = Int(lnValue/m2)
  b2 = Int((lnValue - b3*m2)/m1)
  b1 = Int((lnValue - b3*m2 - b2*m1)/m0)
  b0 = Mod(lnValue, m0)
  RETURN Chr(b0)+Chr(b1)+Chr(b2)+Chr(b3)
ENDFUNC
* * *
* word is compatible with Integer
FUNCTION num2word (lnValue)
  RETURN Chr(MOD(m.lnValue,256)) + CHR(INT(m.lnValue/256))
ENDFUNC
* * *
FUNCTION buf2word (lcBuffer)
  RETURN Asc(SUBSTR(lcBuffer, 1,1)) + ;
         Asc(SUBSTR(lcBuffer, 2,1)) * 256
ENDFUNC
* * *
FUNCTION  buf2Long (lcBuffer)
  RETURN buf2Dword(lcBuffer)
ENDFUNC
FUNCTION  buf2dword(lcBuffer)
RETURN Asc(SUBSTR(lcBuffer, 1,1)) + ;
       Asc(SUBSTR(lcBuffer, 2,1)) * 256 +;
       Asc(SUBSTR(lcBuffer, 3,1)) * 65536 +;
       Asc(SUBSTR(lcBuffer, 4,1)) * 16777216
ENDFUNC
**************************************************************************************
Function UUEncode( strFilePath, pcFileData )
* Converted by wgcs From VB code at www .vbip.com/winsock/winsock_uucode_02.asp
* strFilePath: Specify the full path to the file to load and UU-encode.
* pcFileData:  an optional parameter.  Specify this, and strFilePath is not loaded,
*              but just the filename from strFilePath is used for the encoding label.
*
LOCAL strFileName, strFileData, i, j, lEncodedLines, ;
      strTempLine, lFileSize, strResult, strChunk

*Get file name
strFileName = JUSTFNAME(strFilePath)
if type('pcFileData')='C'
  strFileData = pcFileData
else
  strFileData = FILETOSTR(strFilePath)
endif

*Insert first marker: "begin 664 ..."
strResult = "begin 664 " + strFileName + chr(10)

*Get file size
lFileSize = Len(strFileData)
lEncodedLines = int(lFileSize / 45) + 1

For i = 1 To lEncodedLines
    *Process file data by 45-bytes cnunks

    *reset line buffer
    strTempLine = ""

    If i = lEncodedLines Then
        *Last line of encoded data often is not
        *equal to 45
      strChunk = strFileData
      StrFileData = ''
    else
      strChunk    = LEFT(   strFileData, 45 )
      StrFileData = SubStr( strFileData, 46 )
    endif

* Thanks to "AllTheTimeInTheWorld" on Tek-Tips.com, it was recognized that
*  the length calculation should be after the correction of the last line
*  with the blankspace symbols:
*    *Add first symbol to encoded string that informs
*    *about quantity of symbols in encoded string.
*    *More often "M" symbol is used.
*   strTempLine = Chr(Len(strChunk) + 32)

    If i = lEncodedLines And (Len(strChunk) % 3<>0) Then
      *If the last line is processed and length of
      *source data is not a number divisible by 3,
      *add one or two blankspace symbols
      strChunk = strChunk + Space( 3 -(Len(strChunk) % 3) )
    endif

    *Now that we know the final length of the last string,
    *Add first symbol to encoded string that informs
    *about quantity of symbols in encoded string.
    *More often "M" symbol is used.
    strTempLine = Chr(Len(strChunk) + 32)


*!*	    For j = 1 To Len(strChunk) Step 3
*!*	        *Break each 3 (8-bits) bytes to 4 (6-bits) bytes
*!*	        *
*!*	        *1 byte
*!*	        strTempLine = strTempLine +  ;
*!*	            Chr(Asc(SubStr(strChunk, j, 1)) / 4 + 32)
*!*	        *2 byte
*!*	        strTempLine = strTempLine +  ;
*!*	            Chr((Asc(SubStr(strChunk, j, 1)) % 4) * 16  ;
*!*	            + Asc(SubStr(strChunk, j + 1, 1)) / 16 + 32)
*!*	        *3 byte
*!*	        strTempLine = strTempLine +  ;
*!*	            Chr((Asc(SubStr(strChunk, j + 1, 1)) % 16) * 4  ;
*!*	            + Asc(SubStr(strChunk, j + 2, 1)) / 64 + 32)
*!*	        *4 byte
*!*	        strTempLine = strTempLine +  ;
*!*	            Chr(Asc(SubStr(strChunk, j + 2, 1)) % 64 + 32)

*!*	    EndFor

    * Faster method:
    For j = 1 To Len(strChunk) Step 3
        *Break each 3 (8-bits) bytes to 4 (6-bits) bytes
        ln1 = Asc(SubStr(strChunk, j, 1))
        ln2 = Asc(SubStr(strChunk, j + 1, 1))
        ln3 = Asc(SubStr(strChunk, j + 2, 1))
        *1 byte
        strTempLine = strTempLine +  Chr(ln1 / 4 + 32) ;
                                  +  Chr((ln1 % 4) * 16  + ln2 / 16 + 32) ;
                                  +  Chr((ln2 % 16) * 4  + ln3 / 64 + 32) ;
                                  +  Chr(ln3 % 64 + 32)
    EndFor


    *add encoded line to result buffer
    strResult = strResult + strTempLine + chr(10)
EndFor
*add the end marker
strResult = strResult + "*" + chr(10) + "end" + chr(10)
*asign return value
return strResult

Function UUDecode(strUUCodeData)
* Converted by wgcs From VB code at www .vbip.com/winsock/winsock_uucode_04.asp
LOCAL lnLines, laLines[1], lcOut, lnI, lnJ
LOCAL strDataLine, intSymbols, strTemp

*Remove first marker

If Left(strUUCodeData, 6) = "begin "
   strUUCodeData = SUBSTR(strUUCodeData, AT(chr(10),strUUCodeData) + 1)
EndIf

*Remove marker of the attachment's end
If Right(strUUCodeData, 5) = "end" + chr(13)+chr(10)
   * Remove last 10 characters:  CR,LF,*,CR,LF,E,N,D,CR,LF
   strUUCodeData = Left(strUUCodeData, Len(strUUCodeData) - 10)
endif
strTemp = ""

*Break decoded data to the strings

*From now each member of the array vDataLines contains
*one line of the encoded data
lnLines = alines(laLines, strUUCodeData)

For lnI = 1 to lnLines
   *Decode data line by line
   strDataLine = laLines[lnI]

   *Extract the number of characters in the string
   *We can figure it out by means of the first string character
   intSymbols = Asc(Left(strDataLine, 1))

   *which we delete because of its uselessness
   strDataLine = SubStr(strDataLine, 2, intSymbols)

   *Decode the string by 4 bytes portion.
   *From each byte remove two oldest bits.
   *From remain 24 bits make 3 bytes
   For lnJ = 1 To Len(strDataLine) Step 4
      *1 byte
      strTemp = strTemp + Chr( (Asc(SubStr(strDataLine, lnJ,   1)) - 32) * 4  ;
                              +(Asc(SubStr(strDataLine, lnJ+1, 1)) - 32) / 16   )
      *2 byte
      strTemp = strTemp + Chr( (Asc(SubStr(strDataLine, lnJ+1, 1)) % 16) * 16 ;
                              +(Asc(SubStr(strDataLine, lnJ+2, 1)) - 32) / 4    )
      *3 byte

      strTemp = strTemp + Chr( (Asc(SubStr(strDataLine, lnJ+2, 1)) % 4) * 64 ;
                              + Asc(SubStr(strDataLine, lnJ+3, 1)) - 32)
   ENDFOR
   *Write decoded string to the file
   lcOut = lcOut + strTemp

   *Clear the buffer in order to receive the next
   *line of the encoded data
   strTemp = ""
ENDFOR

RETURN lcOut
ENDFUNC

**** Segundo metodo
PROCEDURE SendSmtpMail2
#DEFINE CrLf  Chr(13)+Chr(10)
LOCAL cServer, cSender, cRecipient, obj
cServer = "dominio.com"
cSender = "userFrom@dominio.com"
cRecipient = "UserTO@correo.com"

obj = CreateObject("Tsmtp", cServer, cSender, cRecipient)
IF VARTYPE(obj) <> "O"
	= MessageB("Unable to initiaze Tsmtp object.   " + Chr(13) +;
		"Check Host, Sender, and Recipient parameters.     ", 48, " Error")
ELSE
	WITH obj
		.subject = "Testing Winsock SMTP functionality"
		.body = "Test message:" + CrLf + CrLf +;
			"Windows Sockets (Winsock) provides a general-purpose networking " +;
			"application programming interface (API) based on the socket interface " +;
			"from the University of California at Berkeley. " + CrLf + CrLf +;
			"Winsock is designed to run efficiently on Windows OSs while maintaining " +;
			"compatibility with the Berkeley Software Distribution (BSD) standard, " +;
			"known as Berkeley Sockets."
		.SendMail()
	ENDWITH
	IF USED("csLog")
		SELECT csLog
		GO TOP
		BROW NORMAL NOWAIT
	ENDIF
ENDIF
* end of main

DEFINE CLASS Tsmtp As Custom
#DEFINE SMTP_PORT     25  && default SMTP port
#DEFINE AF_INET       2
#DEFINE SOCK_STREAM   1
#DEFINE IPPROTO_TCP   6
#DEFINE SOCKET_ERROR  -1
#DEFINE FD_READ       1
	host=""
	IP=""
	sender=""
	recipient=""
	subject=""
	body=""
	hSocket=0

PROCEDURE Init(cServer, cSender, cRecipient)
	DO decl
	IF WSAStartup(0x202, Repli(Chr(0),512)) <> 0
	* unable to initialize Winsock on this computer
		RETURN .F.
	ENDIF

	THIS.host = cServer
	THIS.sender = cSender
	THIS.recipient = cRecipient

	IF Not THIS.InitCheck()
		= WSACleanup()
		RETURN .F.
	ENDIF

FUNCTION InitCheck
	IF EMPTY(THIS.host) Or EMPTY(THIS.recipient);
		Or EMPTY(THIS.sender)
	* invalid Host or sender/recipient email address
		RETURN .F.
	ENDIF
	THIS.IP = THIS.GetIP()
	IF EMPTY(THIS.IP)
	* can not resolve Host name to IP address
		RETURN .F.
	ENDIF
RETURN .T.

PROCEDURE Destroy
	= WSACleanup()

PROTECTED FUNCTION IsMailValid  && just a minimal check
RETURN Not (EMPTY(THIS.sender) Or EMPTY(THIS.recipient);
	Or EMPTY(THIS.subject+THIS.body))

PROTECTED FUNCTION GetIP
#DEFINE HOSTENT_SIZE 16
	LOCAL nStruct, nSize, cBuffer, nAddr, cIP
	nStruct = gethostbyname(THIS.host)
	IF nStruct = 0
		RETURN ""
	ENDIF
	cBuffer = Repli(Chr(0), HOSTENT_SIZE)
	cIP = Repli(Chr(0), 4)
	= CopyMemory(@cBuffer, nStruct, HOSTENT_SIZE)
	= CopyMemory(@cIP, buf2dword(SUBS(cBuffer,13,4)),4)
	= CopyMemory(@cIP, buf2dword(cIP),4)
RETURN inet_ntoa(buf2dword(cIP))

PROTECTED FUNCTION ConnectTo
	LOCAL cBuffer, cPort, cHost, lResult
	cPort = num2word(htons(SMTP_PORT))
	nHost = inet_addr(THIS.IP)
	cHost = num2dword(nHost)
	cBuffer = num2word(AF_INET) + cPort + cHost + Repli(Chr(0),8)
	lResult = (ws_connect(THIS.hSocket, @cBuffer, Len(cBuffer))=0)
RETURN lResult

FUNCTION SendMail
	IF Not THIS.IsMailValid()
		RETURN .F.
	ENDIF
	THIS.hSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)
	IF THIS.hSocket = SOCKET_ERROR
		RETURN .F.
	ENDIF

	LOCAL lResult
	IF THIS.ConnectTo()
           **   Most servers expect the server name after HELO:
	   ** THIS.snd("HELO", .T.)
		THIS.snd("HELO "+THIS.host, .T.)
		THIS.snd("MAIL FROM:<" + THIS.sender + ">", .T.)
		THIS.snd("RCPT TO:<" + THIS.recipient + ">", .T.)
		THIS.snd("DATA", .T.)
		THIS.snd("From: " + THIS.sender)
		THIS.snd("To: " + THIS.recipient)
		THIS.snd("Subject: " + THIS.subject)
		THIS.snd("")
		THIS.snd(THIS.body)
		THIS.snd(".", .T.)
		THIS.snd("QUIT", .T.)
		lResult = .T.
	ELSE
		= MessageB("Unable to connect to [" + THIS.host +;
			"] on port " + LTRIM(STR(SMTP_PORT)) + ".   ",;
			48, " Connection error")
		lResult = .F.
	ENDIF
	= closesocket(THIS.hSocket)
RETURN lResult
ENDFUNC

PROTECTED FUNCTION snd(cData, lResponse)
	THIS.writelog(1, cData)
	LOCAL cBuffer, nResult, cResponse
	cBuffer = cData + CrLf
	nResult = send(THIS.hSocket, @cBuffer, Len(cBuffer), 0)

	IF nResult = SOCKET_ERROR
		RETURN .F.
	ENDIF
	IF Not lResponse
		RETURN .T.
	ENDIF

	LOCAL hEventRead, nWait, cRead
	DO WHILE .T.
		* creating event, linking it to the socket and wait
		hEventRead = WSACreateEvent()
		= WSAEventSelect(THIS.hSocket, hEventRead, FD_READ)

		* 1000 milliseconds can be not enough
		nWait = WSAWaitForMultipleEvents(1, @hEventRead,;
			0, 1000, 0)
		= WSACloseEvent(hEventRead)

		IF nWait <> 0  && error or timeout
			EXIT
		ENDIF
		
		* reading data from connected socket


		cRead = THIS.rd()
		IF Not EMPTY(cRead)
			THIS.writelog(0, cRead)
		ENDIF
	ENDDO
RETURN .T.

PROTECTED FUNCTION rd
#DEFINE READ_SIZE 16384
	LOCAL cRecv, nRecv, nFlags
	cRecv = Repli(Chr(0), READ_SIZE)
	nFlags = 0
	nRecv = recv(THIS.hSocket, @cRecv, READ_SIZE, nFlags)
RETURN Iif(nRecv<=0, "", LEFT(cRecv, nRecv))

PROTECTED PROCEDURE writelog(nMode, cMsg)
	IF Not USED("csLog")
		CREATE CURSOR csLog(dir I, msg C(250))
	ENDIF
	? cMsg
	cMsg = CrLf + cMsg + CrLf


	LOCAL nIndex, nPos0, nPos1
	nIndex = 1
	DO WHILE .T.
		nPos0 = AT(CrLf, cMsg, nIndex)
		nPos1 = AT(CrLf, cMsg, nIndex+1)
		IF nPos1 = 0
			EXIT
		ENDIF
		cLog = SUBSTR(cMsg, nPos0, nPos1-nPos0)
		cLog = STRTRAN(STRTRAN(cLog, Chr(13),""),Chr(10),"")
		IF Not EMPTY(cLog)
			INSERT INTO csLog VALUES (m.nMode, m.cLog)
		ENDIF
		nIndex = nIndex + 1
	ENDDO
ENDDEFINE

PROCEDURE decl
	DECLARE INTEGER gethostbyname IN ws2_32 STRING host
	DECLARE STRING inet_ntoa IN ws2_32 INTEGER in_addr
	DECLARE INTEGER socket IN ws2_32 INTEGER af, INTEGER tp, INTEGER pt
	DECLARE INTEGER closesocket IN ws2_32 INTEGER s
	DECLARE INTEGER WSACreateEvent IN ws2_32
	DECLARE INTEGER WSACloseEvent IN ws2_32 INTEGER hEvent
	DECLARE GetSystemTime IN kernel32 STRING @lpSystemTime
	DECLARE INTEGER inet_addr IN ws2_32 STRING cp
	DECLARE INTEGER htons IN ws2_32 INTEGER hostshort
	DECLARE INTEGER WSAStartup IN ws2_32 INTEGER wVerRq, STRING lpWSAData
	DECLARE INTEGER WSACleanup IN ws2_32

	DECLARE INTEGER connect IN ws2_32 AS ws_connect ;
		INTEGER s, STRING @sname, INTEGER namelen

	DECLARE INTEGER send IN ws2_32;
		INTEGER s, STRING @buf, INTEGER buflen, INTEGER flags

	DECLARE INTEGER recv IN ws2_32;
		INTEGER s, STRING @buf, INTEGER buflen, INTEGER flags

	DECLARE INTEGER WSAEventSelect IN ws2_32;
		INTEGER s, INTEGER hEventObject, INTEGER lNetworkEvents

	DECLARE INTEGER WSAWaitForMultipleEvents IN ws2_32;
		INTEGER cEvents, INTEGER @lphEvents, INTEGER fWaitAll,;
		INTEGER dwTimeout, INTEGER fAlertable

	DECLARE RtlMoveMemory IN kernel32 As CopyMemory;
		STRING @Dest, INTEGER Src, INTEGER nLength

FUNCTION buf2dword(lcBuffer)
RETURN Asc(SUBSTR(lcBuffer, 1,1)) + ;
	BitLShift(Asc(SUBSTR(lcBuffer, 2,1)),  8) +;
	BitLShift(Asc(SUBSTR(lcBuffer, 3,1)), 16) +;
	BitLShift(Asc(SUBSTR(lcBuffer, 4,1)), 24)

FUNCTION num2dword(lnValue)
#DEFINE m0  256
#DEFINE m1  65536
#DEFINE m2  16777216
	IF lnValue < 0
		lnValue = 0x100000000 + lnValue
	ENDIF
	LOCAL b0, b1, b2, b3
	b3 = Int(lnValue/m2)
	b2 = Int((lnValue - b3*m2)/m1)
	b1 = Int((lnValue - b3*m2 - b2*m1)/m0)
	b0 = Mod(lnValue, m0)
RETURN Chr(b0)+Chr(b1)+Chr(b2)+Chr(b3)

FUNCTION num2word(lnValue)
RETURN Chr(MOD(m.lnValue,256)) + CHR(INT(m.lnValue/256))


