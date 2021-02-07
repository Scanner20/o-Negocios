*** 
*** ReFox XI+  #IT489753  Victor  EMBRACE [VFP70]
***
**
FUNCTION CreTabl1
 LPARAMETERS tcpath, astrct, tnblocksiz, tcalias, tcclause, tcotherformat
 IF EMPTY(m.tnblocksiz)
    tnblocksiz = setblock()
 ENDIF
 IF  .NOT. ischar(m.tcclause)
    tcclause = IIF(EMPTY(m.tcpath), '', 'FREE')
 ENDIF
 LOCAL lcstructinfo, lnoldblock, lnerror, lcoldonerr
 IF TYPE("aStrct[1]")="U"
    lcstructinfo = "("+m.astrct+")"
 ELSE
    lcstructinfo = "FROM ARRAY aStrct"
 ENDIF
 lnoldblock = setblock()
 lnerror = 0
 lcoldonerr = onerror()
 ON ERROR lnerror=ERROR()
 SET BLOCKSIZE TO m.tnblocksiz
 SELECT 0
 IF EMPTY(m.tcpath)
    IF EMPTY(m.tcalias)
       tcalias = SYS(2015)
    ENDIF
    CREATE CURSOR (m.tcalias) &tcclause  &lcstructinfo
 ELSE
    tcpath = force_dbf(m.tcpath, .T.)
    IF EMPTY(m.tcotherformat)
       CREATE TABLE (m.tcpath) &tcclause  &lcstructinfo
    ELSE
       LOCAL lcaliastmp
       lcaliastmp = SYS(2015)
       CREATE CURSOR (m.lcaliastmp) &lcstructinfo
       IF m.lnerror=0
          COPY TO (m.tcpath) TYPE &tcotherformat
          IF m.lnerror=0
             IF EMPTY(m.tcalias)
                USE EXCLUSIVE (m.tcpath)
             ELSE
                USE EXCLUSIVE (m.tcpath) ALIAS (m.tcalias)
             ENDIF
          ENDIF
       ENDIF
       = close1(m.lcaliastmp)
    ENDIF
    IF m.lnerror=0
       IF  .NOT. EMPTY(m.tcalias) .AND.  .NOT. curalias(m.tcalias)
          USE EXCLUSIVE (m.tcpath) ALIAS (m.tcalias)
       ENDIF
       FLUSH
    ENDIF
 ENDIF
 IF m.lnerror=0
    IF USED()
       tcalias = ALIAS()
    ELSE
       lnerror = -1
    ENDIF
 ENDIF
 SET BLOCKSIZE TO m.lnoldblock
 ON ERROR &lcoldonerr
 RETURN m.lnerror
ENDFUNC
**
FUNCTION FoxVersion
 PRIVATE lcverstr, lnversion, ln1, ln2, i
 lnversion = 0
 lcverstr = VERSION(1)
 FOR i = 1 TO 3
    ln1 = AT(SPACE(1), m.lcverstr, m.i)+1
    ln2 = AT(SPACE(1), m.lcverstr, m.i+1)
    lnversion = VAL(SUBSTR(m.lcverstr, m.ln1, m.ln2-m.ln1))
    IF m.lnversion>0
       EXIT
    ENDIF
 ENDFOR
 RETURN m.lnversion
ENDFUNC
**
FUNCTION RecNo1
 LPARAMETERS tcalias
 IF EMPTY(m.tcalias)
    tcalias = ALIAS()
 ENDIF
 IF EMPTY(m.tcalias)
    RETURN -3
 ENDIF
 IF EOF(m.tcalias)
    RETURN -2
 ENDIF
 IF BOF(m.tcalias)
    RETURN -1
 ENDIF
 RETURN RECNO(m.tcalias)
ENDFUNC
**
FUNCTION Go1
 LPARAMETERS tnrectogo, tcalias
 IF EMPTY(m.tcalias)
    tcalias = ALIAS()
 ENDIF
 DO CASE
    CASE m.tnrectogo>RECCOUNT(m.tcalias)
       GOTO BOTTOM IN (m.tcalias)
       RETURN .F.
    CASE m.tnrectogo<1
       GOTO TOP IN (m.tcalias)
       RETURN .F.
    OTHERWISE
       GOTO m.tnrectogo IN (m.tcalias)
       RETURN (RECNO(m.tcalias)=m.tnrectogo)
 ENDCASE
ENDFUNC
**
FUNCTION Close1
 LPARAMETERS tcalias, tlused
 IF VARTYPE(m.tcalias)="L"
    IF USED()
       USE
    ENDIF
    RETURN  .NOT. USED()
 ENDIF
 IF EMPTY(m.tcalias)
    RETURN .T.
 ENDIF
 IF m.tlused
    RETURN .F.
 ENDIF
 IF USED(m.tcalias)
    USE IN (m.tcalias)
 ENDIF
 RETURN  .NOT. USED(m.tcalias)
ENDFUNC
**
FUNCTION OnError
 RETURN ON('ERROR')
ENDFUNC
**
FUNCTION SetBlock
 RETURN SET('BLOCKSIZE')
ENDFUNC
**
FUNCTION NullInit
 LPARAMETERS tvalue
 LOCAL lctype
 lctype = VARTYPE(m.tvalue)
 DO CASE
    CASE INLIST(m.lctype, 'N', 'F', 'Y')
       RETURN 0
    CASE INLIST(m.lctype, 'D')
       RETURN date00()
    CASE INLIST(m.lctype, 'T')
       RETURN DTOT(date00())
    CASE m.lctype=='L'
       RETURN .F.
    CASE m.lctype=='O'
       RETURN .NULL.
 ENDCASE
 RETURN ''
ENDFUNC
**
FUNCTION Date00
 RETURN CTOD('')
ENDFUNC
**
FUNCTION AS
 LPARAMETERS tnnumber
 RETURN ALLTRIM(STR(m.tnnumber))
ENDFUNC
**
FUNCTION IsChar
 LPARAMETERS tetotest
 RETURN VARTYPE(m.tetotest)="C"
ENDFUNC
**
FUNCTION CurAlias
 LPARAMETERS tcalias
 IF USED() .AND.  .NOT. EMPTY(m.tcalias) .AND. ALLTRIM(UPPER(m.tcalias))==ALIAS()
    RETURN .T.
 ELSE
    RETURN .F.
 ENDIF
ENDFUNC
**
FUNCTION Force_DBF
 LPARAMETERS m.filname, m.olnlyifnot
 IF PCOUNT()<2
    m.olnlyifnot = .F.
 ENDIF
 RETURN force_ext(m.filname, cdbf, m.olnlyifnot)
ENDFUNC
**
FUNCTION Force_EXT
 LPARAMETERS tcfilename, tcnewext, tlonlyifnot
 PRIVATE lcdot
 lcdot = "."
 IF m.tlonlyifnot .AND. m.lcdot$JUSTFNAME(m.tcfilename)
    RETURN m.tcfilename
 ENDIF
 tcfilename = stripext(m.tcfilename)
 tcnewext = ALLTRIM(m.tcnewext)
 DO CASE
    CASE EMPTY(m.tcnewext)
       RETURN m.tcfilename
    CASE LEFT(m.tcnewext, 1)==m.lcdot
       RETURN m.tcfilename+m.tcnewext
 ENDCASE
 RETURN m.tcfilename+m.lcdot+m.tcnewext
ENDFUNC
**
FUNCTION StripExt
 LPARAMETERS tcfilename
 tcfilename = TRIM(m.tcfilename)
 PRIVATE lndotpos, lnterminator
 lndotpos = RAT(".", m.tcfilename)
 lnterminator = MAX(RAT("\", m.tcfilename), RAT(":", m.tcfilename))
 IF m.lndotpos>m.lnterminator
    tcfilename = LEFT(m.tcfilename, m.lndotpos-1)
 ENDIF
 RETURN m.tcfilename
ENDFUNC
**
FUNCTION FontStyleN
 LPARAMETERS tnfontstyle
 DO CASE
    CASE m.tnfontstyle=1
       RETURN 'B'
    OTHERWISE
       RETURN 'N'
 ENDCASE
ENDFUNC
**
FUNCTION RenFile
 PARAMETER tcfile1, tcfile2, m.usetts_n
 PRIVATE llusewinapi
 llusewinapi = .T.
 IF FILE(m.tcfile1)
    IF FILE(m.tcfile2) .AND.  .NOT. delfile(m.tcfile2, m.usetts_n)
       RETURN .F.
    ENDIF
    PRIVATE lnerror
    lnerror = 0
    IF UPPER(JUSTDRIVE(m.tcfile1))<>UPPER(JUSTDRIVE(m.tcfile2))
       IF copyfile(m.tcfile1, m.tcfile2)
          = delfile(m.tcfile1)
       ENDIF
    ELSE
       IF m.llusewinapi
          RETURN movefile(m.tcfile1, m.tcfile2)<>0
       ELSE
          PRIVATE lcoldonerror
          lcoldonerror = onerror()
          ON ERROR lnerror=ERROR()
          RENAME (m.tcfile1) TO (m.tcfile2)
          ON ERROR &lcoldonerror
          RETURN FILE(m.tcfile2) .AND.  .NOT. FILE(m.tcfile1) .AND. m.lnerror=0
       ENDIF
    ENDIF
 ENDIF
 RETURN .F.
ENDFUNC
**
FUNCTION DelFile
 PARAMETER tcfile, usettsin, tnerror, tlmesnotdeleted, tcbadmessage
 tnerror = 0
 PRIVATE llusewinapi
 llusewinapi = .T.
 IF FILE(m.tcfile)
    IF m.llusewinapi
       IF deletefile(m.tcfile)=0
          tnerror = -108
       ENDIF
    ELSE
       PRIVATE lcoldonerr
       lcoldonerr = onerror()
       ON ERROR tnerror = ERROR()
       DELETE FILE (m.tcfile)
       ON ERROR &lcoldonerr
       IF FILE(m.tcfile) .AND. m.tnerror=0
          tnerror = -108
       ENDIF
    ENDIF
    IF FILE(m.tcfile)
       PRIVATE lcmessage
       lcmessage = "Problem deleting file:"+CHR(13)+CHR(13)+LOWER(m.tcfile)
       IF EMPTY(m.tcbadmessage)
          tcbadmessage = ""
       ENDIF
       tcbadmessage = m.tcbadmessage+CHRTRAN(m.lcmessage, CHR(13), SPACE(1))+CHR(13)
       IF m.tlmesnotdeleted
          = worn_mesg(m.lcmessage)
       ENDIF
       RETURN .F.
    ENDIF
 ENDIF
 RETURN .T.
ENDFUNC
**
FUNCTION MoveFile
 PARAMETER tcexistingfilename, tcnewfilename
 DECLARE INTEGER MoveFile IN Win32api AS MoveFile0 STRING @, STRING @
 RETURN movefile0(@m.tcexistingfilename, @m.tcnewfilename)
ENDFUNC
**
FUNCTION DeleteFile
 PARAMETER tcfilename
 DECLARE INTEGER DeleteFile IN Win32api AS DeleteFile0 STRING @
 RETURN deletefile0(@m.tcfilename)
ENDFUNC
**
FUNCTION CopyFile
 PARAMETER tcfile1, tcfile2, usettsin, tlmesprogrss, tlmesnotcopied, tcbadmessage
 PRIVATE llok, llusewinapi
 llok = .F.
 llusewinapi = .T.
 IF FILE(m.tcfile1)
    IF  .NOT. delfile(m.tcfile2, m.usettsin, 0, m.tlmesnotcopied, @m.tcbadmessage)
       RETURN .F.
    ENDIF
    IF m.tlmesprogrss
       WAIT CLEAR
       WAIT WINDOW NOWAIT 'Копира файл '+LOWER(m.tcfile1)+' в '+LOWER(m.tcfile2)
    ENDIF
    IF m.llusewinapi
       llok = copyfileapi(m.tcfile1, m.tcfile2, 0)<>0
    ELSE
       PRIVATE lnerror, lcoldonerror
       lnerror = 0
       lcoldonerror = onerror()
       ON ERROR lnerror=ERROR()
       COPY FILE (m.tcfile1) TO (m.tcfile2)
       ON ERROR &lcoldonerror
       llok = FILE(m.tcfile2) .AND. m.lnerror=0
    ENDIF
    IF m.tlmesprogrss
       WAIT CLEAR
    ENDIF
 ELSE
    PRIVATE lcmessage
    lcmessage = "Can not copy file:"+CHR(13)+LOWER(m.tcfile1)+CHR(13)+CHR(13)+"in file:"+CHR(13)+LOWER(m.tcfile2)
    IF EMPTY(m.tcbadmessage)
       tcbadmessage = ""
    ENDIF
    tcbadmessage = m.tcbadmessage+CHRTRAN(m.lcmessage, CHR(13), SPACE(1))+CHR(13)
    IF m.tlmesnotcopied
       = worn_mesg(m.lcmessage)
    ENDIF
 ENDIF
 RETURN m.llok
ENDFUNC
**
FUNCTION CopyFileApi
 PARAMETER lcsource, lctarget, nflag
 DECLARE INTEGER CopyFile IN WIN32API AS CopyFile0 STRING @, STRING @, INTEGER
 RETURN copyfile0(@m.lcsource, @m.lctarget, m.nflag)
ENDFUNC
**
FUNCTION Worn_mesg
 LPARAMETERS tcmessage, tctitle, ndialogboxtype
 IF PCOUNT()<2 .OR. EMPTY(m.tctitle)
    tctitle = UPPER("Warning")
 ENDIF
 IF PCOUNT()<3
    ndialogboxtype = 048
 ENDIF
 RETURN MESSAGEBOX(m.tcmessage, m.tctitle, m.ndialogboxtype)
ENDFUNC
**
FUNCTION IsObject
 LPARAMETERS tetotest
 RETURN VARTYPE(m.tetotest)="O" .AND.  .NOT. ISNULL(m.tetotest)
ENDFUNC
**
FUNCTION AnyToC
 LPARAMETERS invar, tntyperet
 IF PCOUNT()<2
    tntyperet = 0
 ENDIF
 LOCAL lctype
 lctype = TYPE("m.inVar")
 DO CASE
    CASE INLIST(m.lctype, 'C', 'M')
       RETURN m.invar
    CASE INLIST(m.lctype, 'N', 'I', 'Y')
       RETURN asspec(m.invar)
    CASE m.lctype='D'
       RETURN DTOC(m.invar)
    CASE m.lctype='T'
       RETURN TTOC(m.invar)
    CASE m.lctype='L'
       IF m.tntyperet=1
          RETURN IIF(m.invar, cyes_loc, cno_loc)
       ELSE
          RETURN IIF(m.invar, ".t.", ".f.")
       ENDIF
    CASE m.lctype='O'
       RETURN cobject_loc
    CASE m.lctype='G'
       RETURN cgeneral_loc
    OTHERWISE
       RETURN m.invar
 ENDCASE
ENDFUNC
**
FUNCTION ASspec
 LPARAMETERS tnnumber, tnround
 IF PCOUNT()<2
    tnround = 15
 ENDIF
 IF iswhole(m.tnnumber)
    RETURN as(m.tnnumber)
 ELSE
    RETURN LTRIM(trim1(STR(m.tnnumber, 25, m.tnround), '0'))
 ENDIF
ENDFUNC
**
FUNCTION IsWhole
 PARAMETER m.tnnumber
 RETURN m.tnnumber=INT(m.tnnumber)
ENDFUNC
**
FUNCTION Trim1
 LPARAMETERS tcstr, tcsimb
 IF PCOUNT()<2
    tcsimb = ","
 ENDIF
 LOCAL lnlen
 tcsimb = m.tcsimb+SPACE(1)
 tcstr = TRIM(m.tcstr)
 lnlen = LEN(m.tcstr)
 DO WHILE .T.
    IF m.lnlen<=0
       EXIT
    ENDIF
    IF  .NOT. SUBSTR(m.tcstr, m.lnlen, 1)$m.tcsimb
       EXIT
    ENDIF
    lnlen = m.lnlen-1
 ENDDO
 IF m.lnlen>0
    RETURN PADR(m.tcstr, m.lnlen)
 ELSE
    RETURN ""
 ENDIF
ENDFUNC
**
FUNCTION Info_mesg
 LPARAMETERS tcmessage, tctitle, ndialogboxtype
 IF EMPTY(m.tcmessage)
    tcmessage = ""
 ENDIF
 IF EMPTY(m.tctitle)
    tctitle = UPPER("information")
 ENDIF
 IF PCOUNT()<3
    ndialogboxtype = 064
 ENDIF
 RETURN MESSAGEBOX(m.tcmessage, m.tctitle, m.ndialogboxtype)
ENDFUNC
**
FUNCTION ShellExe
 LPARAMETERS tcfilename, tcparameters, tcworkdir, tcoperation, tnshowwindow, tnaction, tnhandlestarted
 IF EMPTY(m.tnaction)
    tnaction = 0
 ENDIF
 IF EMPTY(m.tcparameters)
    tcparameters = ""
 ENDIF
 IF EMPTY(m.tcworkdir)
    tcworkdir = ""
 ENDIF
 IF EMPTY(m.tcoperation)
    tcoperation = "Open"
 ENDIF
 IF islog(m.tnshowwindow)
    tnshowwindow = 1
 ENDIF
 DECLARE INTEGER ShellExecute IN SHELL32.DLL INTEGER, STRING, STRING, STRING, STRING, INTEGER
 LOCAL lnreturn
 tcfilename = putquotes(ALLTRIM(m.tcfilename), .F., .T.)
 tcworkdir = putquotes(ALLTRIM(m.tcworkdir), .F., .T.)
 IF m.tnaction>0
    LOCAL awins0[1]
    = awindows(@awins0)
 ENDIF
 lnreturn = shellexecute(0, m.tcoperation, m.tcfilename, m.tcparameters, m.tcworkdir, m.tnshowwindow)
 IF m.lnreturn>=32 .AND. m.tnaction>0
    LOCAL lninitialactivewindow, tntimestart, lctitle, awinsafter[1]
    lninitialactivewindow = mainhwnd()
    tntimestart = SECONDS()
    lctitle = "Starting "+m.tcfilename
    DO WHILE .T.
       = awindows(@awinsafter)
       tnhandlestarted = getnewwindow(@awins0, @awinsafter)
       IF m.tnhandlestarted>0 .AND. m.lninitialactivewindow<>m.tnhandlestarted
          EXIT
       ENDIF
       IF escapeproc()
          EXIT
       ENDIF
       IF SECONDS()-m.tntimestart>30
          IF INLIST(yesno("After 30 s the application is not activated."+CHR(13)+"Wait more?", m.lctitle, 0), 1, 6)
             WAIT CLEAR
             WAIT WINDOW NOCLEAR NOWAIT m.lctitle
             tntimestart = SECONDS()
          ELSE
             EXIT
          ENDIF
       ENDIF
    ENDDO
    IF m.tnaction=2 .AND. m.tnhandlestarted>0 .AND. m.lninitialactivewindow<>m.tnhandlestarted
       WAIT WINDOW NOCLEAR NOWAIT 'Waiting to finish "'+ALLTRIM(getwindowtext(m.tnhandlestarted))+'"'
       DO WHILE iswindow(m.tnhandlestarted)=1
          = sleep(100)
       ENDDO
    ENDIF
    WAIT CLEAR
 ENDIF
 RETURN m.lnreturn
ENDFUNC
**
FUNCTION IsLog
 LPARAMETERS tetotest
 RETURN VARTYPE(m.tetotest)="L"
ENDFUNC
**
FUNCTION PutQuotes
 LPARAMETERS m.tcstring, tlcheck, tlonlyifspaces
 IF m.tlonlyifspaces .AND.  .NOT. SPACE(1)$m.tcstring
    RETURN m.tcstring
 ENDIF
 LOCAL lcquote
 lcquote = '"'
 IF m.tlcheck .AND. m.lcquote$m.tcstring
    lcquote = "'"
 ENDIF
 IF m.lcquote<>PADR(m.tcstring, 1)
    RETURN m.lcquote+m.tcstring+m.lcquote
 ELSE
    RETURN m.tcstring
 ENDIF
ENDFUNC
**
FUNCTION aWindows
 PARAMETER pawindows
 PRIVATE lhcurrwin, lnwincount
 lhcurrwin = getwindow(mainhwnd(), 0)
 lnwincount = 0
 DO WHILE lhcurrwin>0
    IF  .NOT. EMPTY(getwindowtext(m.lhcurrwin)) .AND. iswindowvisible(m.lhcurrwin)<>0
       lnwincount = lnwincount+1
       DIMENSION pawindows(m.lnwincount, 2)
       pawindows[m.lnwincount, 1] = getwindowtext(m.lhcurrwin)
       pawindows[m.lnwincount, 2] = m.lhcurrwin
    ENDIF
    lhcurrwin = getwindow(m.lhcurrwin, 2)
 ENDDO
 RETURN m.lnwincount
ENDFUNC
**
FUNCTION GetNewWindow
 LPARAMETERS tawins0, tawinsafter
 EXTERNAL ARRAY tawins0, tawinsafter
 LOCAL lnhandle, i, j, llfound
 lnhandle = 0
 FOR i = 1 TO ALEN(tawinsafter, 1)
    IF  .NOT. EMPTY(tawinsafter(m.i, 2))
       llfound = .F.
       FOR j = 1 TO ALEN(tawins0, 1)
          IF  .NOT. EMPTY(tawins0(m.j, 2))
             IF tawins0(m.j, 2)=tawinsafter(m.i, 2)
                llfound = .T.
                EXIT
             ENDIF
          ENDIF
       ENDFOR
       IF  .NOT. m.llfound
          lnhandle = tawinsafter(m.i, 2)
          EXIT
       ENDIF
    ENDIF
 ENDFOR
 RETURN m.lnhandle
ENDFUNC
**
FUNCTION EscapeProc
 LPARAMETERS tcmessage, tcchrlist
 IF PCOUNT()<2
    tcchrlist = CHR(27)
 ENDIF
 IF CHRSAW()
    LOCAL lnkeynumber
    lnkeynumber = INKEY()
    CLEAR TYPEAHEAD
    IF m.lnkeynumber<1 .OR. CHR(m.lnkeynumber)$m.tcchrlist
       IF INLIST(MESSAGEBOX("Procedure "+IIF(EMPTY(m.tcmessage), "та", m.tcmessage)+CHR(13)+"will be canceled"+CHR(13)+"Do you confirm?", 0292), 1, 6)
          RETURN .T.
       ENDIF
    ENDIF
 ENDIF
 RETURN .F.
ENDFUNC
**
FUNCTION YesNo
 LPARAMETERS tcmessage, tctitlebox, ndefaultbutton, ndialogboxtype, nicon
 IF EMPTY(m.tctitlebox)
    tctitlebox = _SCREEN.caption
 ENDIF
 IF PCOUNT()<3
    ndefaultbutton = 0
 ENDIF
 IF PCOUNT()<4
    ndialogboxtype = 3
 ENDIF
 IF PCOUNT()<5
    nicon = 32
 ENDIF
 IF EMPTY(m.tcmessage)
    tcmessage = 'Are you sure?'
 ENDIF
 RETURN MESSAGEBOX(m.tcmessage, m.tctitlebox, m.ndialogboxtype+m.ndefaultbutton+m.nicon)
ENDFUNC
**
FUNCTION GetWindowText
 LPARAMETERS tnhandle
 DECLARE INTEGER GetWindowText IN WIN32API AS GetWindowText0 INTEGER, STRING @, INTEGER
 LOCAL lptitle, lnresult, lnlen
 lnlen = 512
 lptitle = REPLICATE(CHR(0), m.lnlen)
 lnresult = getwindowtext0(m.tnhandle, @m.lptitle, m.lnlen-1)
 IF m.lnresult<>0
    RETURN LEFT(m.lptitle, AT(CHR(0), lptitle)-1)
 ELSE
    RETURN ""
 ENDIF
ENDFUNC
**
FUNCTION IsWindow
 LPARAMETERS tnhandle
 DECLARE INTEGER IsWindow IN user32.dll AS IsWindow0 INTEGER
 RETURN iswindow0(m.tnhandle)
ENDFUNC
**
FUNCTION IsWindowVisible
 LPARAMETERS tnhandle
 DECLARE INTEGER IsWindowVisible IN user32.dll AS IsWindowVisible0 INTEGER
 RETURN iswindowvisible0(m.tnhandle)
ENDFUNC
**
FUNCTION GetWindow
 LPARAMETERS tnhandleoriginal, tnrelationship
 DECLARE INTEGER GetWindow IN user32.dll AS GetWindow0 INTEGER, INTEGER
 RETURN getwindow0(m.tnhandleoriginal, m.tnrelationship)
ENDFUNC
**
FUNCTION Sleep
 PARAMETER tnmilliseconds
 DECLARE Sleep IN WIN32API AS Sleep0 INTEGER
 = sleep0(m.tnmilliseconds)
 RETURN .T.
ENDFUNC
**
*** 
*** ReFox - todo no se pierde 
***
