* Converted to VFP by William Steinford.
* Date: Feb 9, 2003
* This VFP Class definition is based on the C++ class definition
* found at http://www.codeguru.com/internet/pop3_protocol_class_wrapper.shtml
* written originally by Asif Rasheed (aasif@khi.compol.com)

#DEFINE CRLF CHR(13)+CHR(10)

* Test Code:
OX=CREATE("popemail")
OX.SERVERNAME=INPUTBOX("Gimme Your POP SERVER","Hi","mail.o-negocios.com")
OX.USER=INPUTBOX("Gimme Your User Name","Hi","vtorres@o-negocios.com")
OX.PASSWORD=INPUTBOX("Gimme Your Password","Hi","260474")

?"Trying to Connect..."
IF NOT OX.CONNECT()
 ? "Error Connecting:"+OX.ERRORMESSAGE
ELSE
 ?? "Connected!"
 ? "Stat Check..."
 IF OX.STATISTICS()
  STRTOFILE(OX.SERVERRESPONSE,'ServerStat.txt')
  ? "ServerResponse: "+TRAN(OX.SERVERRESPONSE)
  ? "Number of Emails: "+TRAN(OX.NUMBEROFEMAILS-3)
  ? "Size of Email: "+TRAN(OX.TOTALMAILSIZE)
  ? "Getting Email List..."
  ? OX.LIST()
  ? "Total Messages: "+TRAN(OX.NUMBEROFEMAILS)
  IF OX.NUMBEROFEMAILS>0
   ? 'First Email:'
   FOR LNI = 1 TO OX.NUMBEROFEMAILS
    ? OX.RETRIEVE(LNI)
    LCEMAIL = OX.MSGCONTENTS
    STRTOFILE('----Email#'+TRAN(LNI)+'--------'+CRLF ;
     +LCEMAIL+CRLF,'c:\data\email\Email.txt',.T.)
   ENDFOR
* ? ox.MsgContents
  ELSE
   ? "No Emails!"
  ENDIF
 ELSE
  ? "Failed STAT check!"
 ENDIF
 OX.DISCONNECT()
ENDIF

#DEFINE CONNECTION_CHECK 0
#DEFINE USER_CHECK 1
#DEFINE PASSWORD_CHECK 2
#DEFINE QUIT_CHECK 3
#DEFINE DELETE_CHECK 4
#DEFINE RSET_CHECK 5
#DEFINE STAT_CHECK 6
#DEFINE NOOP_CHECK 7
#DEFINE LIST_CHECK 8
#DEFINE RETR_CHECK 9
#DEFINE VBSTRING 8
#DEFINE TIME_OUT 30

*/////////////////////////////////////////////////////////////////////////////
DEFINE CLASS POPEMAIL AS CUSTOM
 ERRORMESSAGE = ""
 PASSWORD = ""
 USER = ""

 SERVERPORT = 110
 SERVERNAME = ""

 MSGCONTENTS = ""
 TOTALMAILSIZE = 0
 NUMBEROFEMAILS = 0
 CONNECTED = .F.

 SERVERRESPONSE = ''
 OCXSOCKET = .NULL.
 DIMENSION SIZEOFMSG[1]

*!* CString GetErrorMessage(); // If there is any error this will return it method
*!* CString GetPassword(); // Getting Password stored in class
*!* void SetPassword(CString& Password); // Setting Password in class
*!* CString GetUser(); // Getting user name stored in class
*!* void SetUser(CString& User); // Setting user name in class
*!* CString GetHost(); // Getting Host name (email server name) stored in class
*!* void SetHost(CString& Host); // Setting Host name (email server name) in class
*!* BOOL Connect(); // Connecting to email server
*!* int GetTotalMailSize(); // it returns the Total Mail Size
*!* int GetNumberOfMails(); // It return the number of mails
*!* CString GetMsgContents();
*!* BOOL Statistics(); // issue the STAT command on email server
*!* BOOL Retrieve(int MsgNumber); // Getting any particular mail message
*!* BOOL Reset(); // issue the reset command on email server
*!* int GetMessageSize(int MsgNumber); // Return a size of any particular mail
*!* BOOL Noop(); // issue the NOOP command on email server
*!* BOOL Disconnect(); // issue the QUIT command on email server
*!* BOOL Delete(int& MsgNumber); // Deleteing a particular message from email server
*!* BOOL Connect(CString& Host, CString& User, CString& Password);

 PROCEDURE INIT
 THIS.OCXSOCKET = CREATE('mswinsock.winsock')
ENDPROC

 FUNCTION CONNECT(SERVERNAME, PCUSER, PCPASSWORD) && Boolean
 LOCAL LCSERVERNAME,LCUSER,LCPASSWORD,LNTIME
 LCSERVERNAME = ALLTRIM( IIF( VARTYPE(PCSERVERNAME)='C', PCSERVERNAME, THIS.SERVERNAME ) )
 LCUSER = ALLTRIM( IIF( VARTYPE(PCUSER)='C', PCUSER, THIS.USER ) )
 LCPASSWORD = IIF( VARTYPE(PCPASSWORD)='C', PCPASSWORD, THIS.PASSWORD )

 THIS.OCXSOCKET.CONNECT(LCSERVERNAME,THIS.SERVERPORT) && 110 Pop3 Port
 LNTIME = SECONDS()
 DO WHILE THIS.OCXSOCKET.STATE <> 7
* ?"Waiting to connect..."
  INKEY(0.01)
* ?"state="+tran(THIS.ocxSocket.State)
  IF SECONDS() - LNTIME > TIME_OUT
   THIS.ERRORMESSAGE = "Server cannot be connected"
   RETURN .F.
  ENDIF
 ENDDO
 CONNECTED = .T.
* ?"State="+tran(THIS.ocxSocket.State)
 IF NOT THIS.CHECKRESPONSE(CONNECTION_CHECK)
  RETURN .F.
 ENDIF

 IF NOT THIS.SENDMESSAGEOK( "USER "+LCUSER, USER_CHECK )
  RETURN .F.
 ENDIF
 IF NOT THIS.SENDMESSAGEOK( "PASS "+LCPASSWORD, PASSWORD_CHECK )
  RETURN .F.
 ENDIF
 RETURN .T.
ENDFUNC

 FUNCTION DELETE(PNMSGNUMBER)
 IF NOT THIS.SENDMESSAGEOK( "DELE "+TRAN(PCMSGNUMBER), DELETE_CHECK )
  RETURN .F.
 ENDIF
 RETURN .T.
ENDFUNC

 FUNCTION NOOP
 IF NOT THIS.SENDMESSAGEOK( "NOOP ", NOOP_CHECK )
  RETURN .F.
 ENDIF
 RETURN .T.
ENDFUNC

*// Return the Msg Size for given msg number
 FUNCTION GETMESSAGESIZE(PNMSGNUMBER)
 IF ALEN(THIS.SIZEOFMSG) <= PNMSGNUMBER
  RETURN 0
 ENDIF
 RETURN THIS.SIZEOFMSG[MsgNumber+1]
ENDFUNC

 FUNCTION RESET()
 IF NOT THIS.SENDMESSAGEOK( "RSET ", RSET_CHECK )
  RETURN .F.
 ENDIF
 RETURN .T.
ENDFUNC

*// MsgContents will hold the msg body
 FUNCTION RETRIEVE(PNMSGNUMBER)
 IF NOT THIS.SENDMESSAGEOK( "RETR "+TRAN(PNMSGNUMBER), RETR_CHECK )
  RETURN .F.
 ENDIF
 RETURN .T.
ENDFUNC

 FUNCTION STATISTICS()
 IF NOT THIS.SENDMESSAGEOK( "STAT ", STAT_CHECK )
  RETURN .F.
 ENDIF
 RETURN .T.
ENDFUNC

 FUNCTION LIST
 IF NOT THIS.SENDMESSAGEOK( "LIST ", LIST_CHECK )
  RETURN .F.
 ENDIF
 RETURN .T.
ENDFUNC

 FUNCTION DISCONNECT()
* ?"Trying to Disconnect..."
 IF NOT THIS.SENDMESSAGEOK( "QUIT ", QUIT_CHECK )
  RETURN .F.
 ENDIF
* ??" Disconnected."
 RETURN .T.
ENDFUNC

 FUNCTION SENDMESSAGEOK( PCMSG, PNTYPE )
* wsprintf (buf, "USER %s\r\n", (LPCSTR) User)
* ?"(out) "+pcMsg
 THIS.OCXSOCKET.SENDDATA(PCMSG+CRLF)
 IF NOT THIS.CHECKRESPONSE(PNTYPE)
  RETURN .F.
 ENDIF
 RETURN .T.
ENDFUNC

 FUNCTION CHECKRESPONSE(RESPONSETYPE)
 LOCAL BUF
 BUF =THIS.READDATA()
 THIS.SERVERRESPONSE =BUF
 *?buf
 DO CASE
 CASE RESPONSETYPE=CONNECTION_CHECK
  IF BUF="-ERR"
   THIS.ERRORMESSAGE ="Bad Connection"
   RETURN .F.
  ENDIF
 CASE RESPONSETYPE=USER_CHECK
  IF BUF="-ERR"
   THIS.ERRORMESSAGE ="Bad User Name"
   RETURN .F.
  ENDIF
 CASE RESPONSETYPE=PASSWORD_CHECK
  IF BUF="-ERR"
   THIS.ERRORMESSAGE ="Bad Password"
   RETURN .F.
  ENDIF
 CASE RESPONSETYPE=QUIT_CHECK
  IF BUF="-ERR"
   THIS.ERRORMESSAGE ="Error occured during QUIT"
   RETURN .F.
  ENDIF
 CASE RESPONSETYPE=DELETE_CHECK
  IF BUF="-ERR"
   THIS.ERRORMESSAGE ="Error occured during DELE"
   RETURN .F.
  ENDIF
 CASE RESPONSETYPE=RSET_CHECK
   IF BUF="-ERR"
    THIS.ERRORMESSAGE ="Error occured during RSET"
    RETURN .F.
  ENDIF
 CASE RESPONSETYPE=STAT_CHECK
  IF BUF="-ERR"
   THIS.ERRORMESSAGE ="Error occured during STAT"
   RETURN .F.
  ELSE
   EMAILNUMBER =.T.
   LNI =1
   LCSAMP =SUBSTR(BUF,LNI,1)
   DO WHILE LCSAMP#CHR(0) AND LNI<1000 && '\0'
    IF (LCSAMP=CHR(9) OR LCSAMP=' ') && *p == '\t' || *p == ' ')
     IF (EMAILNUMBER == .T.)
      THIS.NUMBEROFEMAILS = Val(SubStr(BUF, LNI)) && New
      EMAILNUMBER = .F.
     ELSE
      THIS.TOTALMAILSIZE = Val(SubStr(BUF, LNI)) && New
      RETURN .T.
     ENDIF
    ENDIF
    LNI = LNI + 1
    LCSAMP = SUBSTR(BUF,LNI,1)
   ENDDO
  ENDIF
 CASE RESPONSETYPE=NOOP_CHECK
  IF BUF="-ERR"
   THIS.ERRORMESSAGE = "Error occured during NOOP"
   RETURN .F.
  ENDIF
 CASE RESPONSETYPE=LIST_CHECK
  IF BUF="-ERR"
   THIS.ERRORMESSAGE = "Error occured during LIST"
   RETURN .F.
  ELSE
* Buf = THIS.ReadData()
   LNI = 1
   LCSAMP = SUBSTR(BUF,LNI,1)
   LNLINE = 1
   DO WHILE LNI <= Len(BUF) &&LCSAMP#'.' AND LNI<1000 && '\0' && New: no check for . (RFC STD53)
    IF LCSAMP=CHR(13)
     LNLINE = LNLINE + 1
    ENDIF
    IF LNLINE > 1
     IF (LCSAMP=CHR(9) OR LCSAMP=' ') && *p == '\t' || *p == ' ')
      DIMENSION THIS.SIZEOFMSG[ alen(THIS.SizeOfMsg)+1 ]
      THIS.SIZEOFMSG[alen(THIS.SizeOfMsg)] = VAL(SUBSTR(BUF,LNI))
*? " Email #"+tran(alen(THIS.SizeOfMsg)-1)+" size="+tran(THIS.SizeOfMsg[alen(THIS.SizeOfMsg)])
     ENDIF
    ENDIF
    LNI = LNI + 1
    LCSAMP = SUBSTR(BUF,LNI,1)
   ENDDO
   THIS.NUMBEROFEMAILS = ALEN(THIS.SIZEOFMSG)-1
  ENDIF
 CASE RESPONSETYPE=RETR_CHECK
  IF BUF="-ERR"
   THIS.ERRORMESSAGE = "Error occured during RETR"
   RETURN .F.
  ELSE
   THIS.MSGCONTENTS = BUF+THIS.READDATA()
  ENDIF
 ENDCASE
 RETURN .T.
ENDFUNC

 FUNCTION READDATA
 LOCAL CMSGIN, LNTIME
 LNTIME = SECONDS()
 DO WHILE THIS.OCXSOCKET.BYTESRECEIVED = 0
* ?"Waiting to Receive data..."
  INKEY(0.2)
  IF SECONDS() - LNTIME > TIME_OUT
* ?"Timed Out"
   RETURN ''
  ENDIF
 ENDDO
 ***CMSGIN = REPL(CHR(0),10000) && chr(0),10000)

* ?"(in) Bytes Received: "+tran(THIS.ocxSocket.BytesReceived)
* THIS.ocxSocket.Receive(buf, len(buf))

 * Fixed a bug with messages longer than the buffer size

 ***IF THIS.OCXSOCKET.STATE=7
 *** THIS.OCXSOCKET.GETDATA(@CMSGIN,VBSTRING)
 ***ENDIF

	DOEVENTS

	lcBuffer = REPL(CHR(0),10000)
	lcMsgIn = ""
	IF THIS.OCXSOCKET.State = 7
		DO WHILE THIS.OCXSOCKET.BytesReceived > 0
			THIS.OCXSOCKET.GETDATA(@lcBuffer,vbString)
			lcMsgIn = lcMsgIn + lcBuffer
			INKEY(0.1)
		ENDDO
	ENDIF

* cMsgIn = LEFT( cMsgIn, AT(chr(0),cMsgIn) )
* ?"(in) Data Read: ("+tran(len(cMsgIn))+","+tran(THIS.ocxSocket.BytesReceived)+" bytes) "+cMsgIn
 RETURN CMSGIN
ENDFUNC

 PROCEDURE DESTROY
 DODEFAULT()
 IF THIS.CONNECTED
  THIS.DISCONNECT()
 ENDIF
ENDPROC
ENDDEFINE



