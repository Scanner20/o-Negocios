DEFINE WINDOW MYWINDOW FROM 5,0 TO 20,80 COLOR SCHEME 5
ACTIVATE WINDOW MYWINDOW
SET SAFETY off
STORE SPACE(40) TO tFromDBC, tToDBC, tDBFname && suitably increase size to your needs

@ 2,5 SAY "Select Source DBC with full path : " Get tFromDBC
@ 4,5 SAY "Select Destination DBC with path : " Get tToDBC

READ

IF EMPTY(tFromdbc) .OR. EMPTY(tToDBC) 
    DEACTIVATE WINDOW MYWINDOW
    RETURN
ENDIF
*tfromdbc="d:\vfpalarms\dat\mydata"
*ttodbc="d:\vfpalarms\dat1\logbook"
tFromDBC = ALLT(tFromDBC)
tToDBC = ALLT(tToDBC)

CLOSE DATABASES ALL

CREATE DATABASE (ttodbc)
OPEN DATABASE  (tfromdbc)
ADBOBJECTS(atables,"TABLE")
FOR i=1 to ALEN(atables,1)
  SET DATABASE TO (tfromdbc)
  use (atables(i)) IN 0
  SELECT(atables(i))
  COPY STRUCTURE to (ADDBS(JUSTPATH(ttodbc))+atables(i)) with cdx database (ttodbc)
  USE
  SET DATABASE TO (ttodbc)
  use (atables(i)) IN 0
  SELECT(atables(i))
  APPEND FROM (ADDBS(JUSTPATH(tfromdbc))+atables(i))
  USE 
NEXT
SET DATABASE TO (tfromdbc)
ADBOBJECTS(atables,"VIEW")

CLOSE DATABASES all

LOCAL lnObjectId, lnNewId, lnParentId, lcFromDBF, lcToDBF

use (tfromdbc+".dbc") IN 0 ALIAS old
USE (tToDBC+".DBC") IN 0 ALIAS new

SELECT new
PACK
GO BOTTOM
lnNewId = RECCOUNT()+1
lnParentId = lnNewId
SELECT old
PACK

FOR i=1 to ALEN(atables,1)

  LOCATE FOR ALLTRIM(UPPER(OBJECTNAME)) == ALLTRIM(UPPER(atables(i)))
  lnObjectId = ObjectId
  SCATTER MEMVAR MEMO
  m.ObjectId = lnNewId
  nstart=1
  do while .t.
    plen=ASC(SUBSTR(m.property,nstart,1))+256*ASC(SUBSTR(m.property,nstart+1,1))
    buf=SUBSTR(m.property,nstart,plen)
    do while .t.
      ns=AT(JUSTFNAME(tfromdbc)+"!",buf,1)
      IF ns=0
        EXIT
      ENDIF
      buf=STUFF(buf,ns,LEN(JUSTFNAME(tfromdbc)),JUSTFNAME(ttodbc))
    ENDDO
    nlen=LEN(buf)
    hnlen=INT(nlen/256)
    lnlen=MOD(nlen,256)
    buf=STUFF(buf,1,2,CHR(lnlen)+CHR(hnlen))
    m.property=STUFF(m.property,nstart,plen,buf)
    nstart=nstart+nlen
    IF nstart>=LEN(m.property)
      EXit
    endif
  enddo
  SELECT new
  APPEND BLANK
  GATHER MEMVAR MEMO

  SELECT old
  SCAN FOR ParentId = lnObjectId
    SCATTER MEMVAR MEMO
    lnNewId = lnNewId+1
    m.ObjectId = lnNewId
    m.ParentId = lnParentId
    nstart=1
    do while .t.
      plen=ASC(SUBSTR(m.property,nstart,1))+256*ASC(SUBSTR(m.property,nstart+1,1))
      buf=SUBSTR(m.property,nstart,plen)
      do while .t.
        ns=AT(JUSTFNAME(tfromdbc)+"!",buf,1)
        IF ns=0
          EXIT
        ENDIF
        buf=STUFF(buf,ns,LEN(JUSTFNAME(tfromdbc)),JUSTFNAME(ttodbc))
      ENDDO
      nlen=LEN(buf)
      hnlen=INT(nlen/256)
      lnlen=MOD(nlen,256)
      buf=STUFF(buf,1,2,CHR(lnlen)+CHR(hnlen))
      m.property=STUFF(m.property,nstart,plen,buf)
      nstart=nstart+nlen
      IF nstart>=LEN(m.property)
        EXit
      endif
    enddo
    SELECT new
    APPEND BLANK
    GATHER MEMVAR MEMO
    SELECT old
  ENDSCAN
  lnnewid=lnnewid+1
  lnParentId = lnNewId
next
CLOSE DATABASES ALL

DEACTIVATE WINDOW MYWINDOW

RETURN