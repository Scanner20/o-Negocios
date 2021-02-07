*** 
*** ReFox XI+  #IT489753  Victor  EMBRACE [VFP70]
***
**
FUNCTION RepEnhance
 LPARAMETERS tcexcelfilein, tcexcelfileout, tctypefileout, tnplatform, tlenhcolumn, tlenhheader, tlenhtitle, tlenhsummary, ar_detail, ar_header, ar_title, ar_summary, tnrecords, tnpageorient, tnpageleftmargin, tlnomessages
 EXTERNAL ARRAY ar_detail, ar_header, ar_title, ar_summary
 IF EMPTY(m.tnpageleftmargin)
    tnpageleftmargin = 0
 ENDIF
 IF  .NOT. m.tlenhcolumn .AND.  .NOT. m.tlenhheader .AND.  .NOT. m.tlenhtitle .AND.  .NOT. m.tlenhsummary
    RETURN 0
 ENDIF
 IF  .NOT. FILE(m.tcexcelfilein)
    RETURN 1
 ENDIF
 LOCAL lnoldselect
 lnoldselect = SELECT()
 LOCAL oexcel, lcoldonerror, lnenherror, lctitle
 lctitle = "Report export - Formating"
 lnenherror = 0
 lcoldonerror = onerror()
 ON ERROR lnenherror=ERROR()
 oexcel = CREATEOBJECT("Excel.Application")
 ON ERROR &lcoldonerror
 IF m.lnenherror<>0
    IF  .NOT. m.tlnomessages
       = worn_mesg("Can not open Excel, error "+as(m.lnenherror), m.lctitle)
    ENDIF
    RETURN m.lnenherror
 ENDIF
 IF  .NOT. isobject(m.oexcel)
    RETURN 2
 ENDIF
 oworkbook = oexcel.workbooks.open(m.tcexcelfilein)
 IF  .NOT. isobject(m.oworkbook)
    oexcel.quit
    RETURN 3
 ENDIF
 oworksheet1 = oworkbook.worksheets(1)
 IF  .NOT. isobject(m.oworksheet1)
    oexcel.quit
    RETURN 4
 ENDIF
 IF  .NOT. m.tlnomessages
    WAIT WINDOW NOCLEAR NOWAIT 'Excel automotion, please wait'
 ENDIF
 LOCAL i, lnlastheadrow, lnrow, lnrowto, lncolumn, lncolumns, lncharsize, lnpointsperchar, levalue
 lnlastheadrow = 1
 lncolumns = ALEN(ar_detail, 1)
 WITH oworksheet1
    IF m.tlenhcolumn .AND. m.tnrecords>0
       lnrow = 1
       lnrowto = m.lnlastheadrow+m.tnrecords
       WITH .range(.cells(m.lnrow, 1),.cells(m.lnrowto, m.lncolumns)).borders(7)
          .linestyle = 1
          .weight = 2
          .colorindex = -4105
       ENDWITH
       WITH .range(.cells(m.lnrow, 1),.cells(m.lnrowto, m.lncolumns)).borders(8)
          .linestyle = 1
          .weight = 2
          .colorindex = -4105
       ENDWITH
       WITH .range(.cells(m.lnrow, 1),.cells(m.lnrowto, m.lncolumns)).borders(9)
          .linestyle = 1
          .weight = 2
          .colorindex = -4105
       ENDWITH
       WITH .range(.cells(m.lnrow, 1),.cells(m.lnrowto, m.lncolumns)).borders(10)
          .linestyle = 1
          .weight = 2
          .colorindex = -4105
       ENDWITH
       IF m.lncolumns>1
          WITH .range(.cells(m.lnrow, 1),.cells(m.lnrowto, m.lncolumns)).borders(11)
             .linestyle = 1
             .weight = 2
             .colorindex = -4105
          ENDWITH
       ENDIF
       IF m.lnrowto>m.lnrow
          WITH .range(.cells(m.lnrow, 1),.cells(m.lnrowto, m.lncolumns)).borders(12)
             .linestyle = 1
             .weight = 2
             .colorindex = -4105
          ENDWITH
       ENDIF
       lnrow = 2
       LOCAL lnposstart, lnposend, lcpict, lcnumbformat, lndecimals
       FOR i = 1 TO m.lncolumns
          lncolumn = INT(VAL(wordnum(ar_detail(m.i, 1), 2, "_")))
          WITH .range(.cells(m.lnrow, m.lncolumn), .cells(m.lnrowto, m.lncolumn))
             IF "9"$ar_detail(m.i, 17)
                lnposstart = AT("9", ar_detail(m.i, 17))
                lnposend = RAT("9", ar_detail(m.i, 17))
                IF m.lnposstart>0 .AND. m.lnposend>=m.lnposstart
                   lcpict = SUBSTR(ar_detail(m.i, 17), lnposstart, m.lnposend-m.lnposstart+1)
                   lcnumbformat = "0"
                   IF ","$m.lcpict
                      lcnumbformat = "#,##"+m.lcnumbformat
                   ENDIF
                   lnposstart = RAT(".", m.lcpict)
                   IF m.lnposstart>0
                      lndecimals = LEN(m.lcpict)-m.lnposstart
                      IF m.lndecimals>0
                         lcnumbformat = m.lcnumbformat+"."+REPLICATE("0", m.lndecimals)
                         .numberformat = m.lcnumbformat
                      ENDIF
                   ENDIF
                ENDIF
             ENDIF
             IF  .NOT. EMPTY(ar_detail(m.i, 14))
                .font.name = ar_detail(m.i, 14)
             ENDIF
             IF  .NOT. EMPTY(ar_detail(m.i, 15))
                .font.size = ar_detail(m.i, 15)
             ENDIF
             IF INLIST(ar_detail(m.i, 16), 3, 1)
                .font.bold = .T.
             ENDIF
             IF INLIST(ar_detail(m.i, 16), 3, 2)
                .font.italic = .T.
             ENDIF
             IF m.tnplatform="WIN"
                .font.color = getobjpencolor(ar_detail(m.i, 18))
                .interior.color = getobjfillcolor(ar_detail(m.i, 18), ar_detail(m.i, 3))
             ENDIF
             DO CASE
                CASE "J"$ar_detail(m.i, 17) .OR. ar_detail(m.i, 19)=1 .OR. INLIST(ar_detail(m.i, 4), "N", "I")
                   .horizontalalignment = -4152
                CASE "I"$ar_detail(m.i, 17) .OR. ar_detail(m.i, 19)=2
                   .horizontalalignment = -4108
                OTHERWISE
                   .horizontalalignment = -4131
             ENDCASE
             .verticalalignment = -4160
          ENDWITH
          IF m.tnplatform="WIN"
             lnpointsperchar = .columns(m.lncolumn).width/.columns(m.lncolumn).columnwidth
             .columns(m.lncolumn).columnwidth = CEILING(oexcel.inchestopoints(ar_detail(m.i, 12)/10000)/m.lnpointsperchar)
          ELSE
             .columns(m.lncolumn).columnwidth = ar_detail(m.i, 12)
          ENDIF
          IF ar_detail(m.i, 13)
             .range(.cells(m.lnrow, m.lncolumn), .cells(m.lnrowto, m.lncolumn)).wraptext = .T.
          ENDIF
       ENDFOR
    ENDIF
    LOCAL lnhpoz, j
    IF m.tlenhheader .AND. ALEN(ar_header)>1
       FOR j = 1 TO m.lncolumns
          .range(.cells(1, m.j), .cells(1, m.j)).value = ""
       ENDFOR
       LOCAL lnheadobjects
       lnheadobjects = ALEN(ar_header, 1)
       FOR i = 1 TO m.lnheadobjects
          lnhpoz = ar_header(m.i, 6)+ar_header(m.i, 12)/2
          lncolumn = 0
          FOR j = 1 TO m.lncolumns
             IF BETWEEN(m.lnhpoz, ar_detail(m.j, 6), ar_detail(m.j, 6)+ar_detail(m.j, 12))
                lncolumn = INT(VAL(wordnum(ar_detail(m.j, 1), 2, "_")))
                EXIT
             ENDIF
          ENDFOR
          IF m.lncolumn=0
             FOR j = 1 TO m.lncolumns
                IF BETWEEN(m.lnhpoz, ar_detail(m.j, 6)-ar_detail(m.j, 12)/2, ar_detail(m.j, 6)+ar_detail(m.j, 12)*1.5 )
                   lncolumn = INT(VAL(wordnum(ar_detail(m.j, 1), 2, "_")))
                   EXIT
                ENDIF
             ENDFOR
          ENDIF
          IF m.lncolumn>0
             WITH .range(.cells(1, m.lncolumn), .cells(1, m.lncolumn))
                levalue = .value
                IF EMPTY(m.levalue) .OR. ISNULL(m.levalue)
                   .value = anytoc(EVALUATE(ar_header(m.i, 2)))
                ELSE
                   .value = anytoc(m.levalue)+SPACE(1)+anytoc(EVALUATE(ar_header(m.i, 2)))
                ENDIF
                IF  .NOT. EMPTY(ar_header(m.i, 14))
                   .font.name = ar_header(m.i, 14)
                ENDIF
                IF  .NOT. EMPTY(ar_header(m.i, 15))
                   .font.size = ar_header(m.i, 15)
                ENDIF
                IF INLIST(ar_header(m.i, 16), 3, 1)
                   .font.bold = .T.
                ENDIF
                IF INLIST(ar_header(m.i, 16), 3, 2)
                   .font.italic = .T.
                ENDIF
                IF m.tnplatform="WIN"
                   .font.color = getobjpencolor(ar_header(m.i, 18))
                   .interior.color = getobjfillcolor(ar_header(m.i, 18), ar_header(m.i, 3))
                ENDIF
                .horizontalalignment = -4108
                .verticalalignment = -4108
                .wraptext = .T.
                .shrinktofit = .T.
             ENDWITH
          ENDIF
       ENDFOR
    ENDIF
    IF m.tlenhtitle .AND. ALEN(ar_title)>1
       LOCAL lntitleobjects, arr_rows[1], lnvpoz, lnrows, lnrow
       lnrows = 0
       STORE 0 TO arr_rows
       lntitleobjects = ALEN(ar_title, 1)
       FOR i = 1 TO m.lntitleobjects
          lnvpoz = ROUND(ar_title(m.i, 5), -2)
          IF m.lnrows=0 .OR. ASCAN(arr_rows, m.lnvpoz)=0
             lnrows = m.lnrows+1
             DIMENSION arr_rows[m.lnrows]
             arr_rows[m.lnrows] = m.lnvpoz
             .rows(1).entirerow.insert
          ENDIF
          = ASORT(arr_rows)
       ENDFOR
       FOR i = 1 TO m.lntitleobjects
          lnvpoz = ROUND(ar_title(m.i, 5), -2)
          lnrow = ASCAN(arr_rows, m.lnvpoz)
          IF m.lnrow>0
             WITH .cells(m.lnrow, 1)
                levalue = .value
                IF EMPTY(m.levalue) .OR. ISNULL(m.levalue)
                   .value = anytoc(EVALUATE(ar_title(m.i, 2)))
                ELSE
                   .value = anytoc(m.levalue)+SPACE(1)+anytoc(EVALUATE(ar_title(m.i, 2)))
                ENDIF
                IF  .NOT. EMPTY(ar_title(m.i, 14))
                   .font.name = ar_title(m.i, 14)
                ENDIF
                IF  .NOT. EMPTY(ar_title(m.i, 15))
                   .font.size = ar_title(m.i, 15)
                ENDIF
                IF INLIST(ar_title(m.i, 16), 3, 1)
                   .font.bold = .T.
                ENDIF
                IF INLIST(ar_title(m.i, 16), 3, 2)
                   .font.italic = .T.
                ENDIF
                IF m.tnplatform="WIN"
                   .font.color = getobjpencolor(ar_title(m.i, 18))
                   .interior.color = getobjfillcolor(ar_title(m.i, 18), ar_title(m.i, 3))
                ENDIF
                .verticalalignment = -4108
                .shrinktofit = .T.
             ENDWITH
          ENDIF
       ENDFOR
       FOR i = 1 TO m.lnrows
          WITH .range(.cells(m.i, 1), .cells(m.i, m.lncolumns))
             .mergecells = .T.
          ENDWITH
       ENDFOR
    ENDIF
    WITH .pagesetup
       .leftheader = ""
       .centerheader = ""
       .rightheader = ""
       .leftfooter = ""
       .centerfooter = ""
       .rightfooter = ""
       .printheadings = .F.
       .printgridlines = .F.
       .printcomments = -4142
       .centerhorizontally = .F.
       .centervertically = .F.
       .draft = .F.
       .papersize = 9
       .firstpagenumber = -4105
       .order = 1
       .blackandwhite = .F.
       .zoom = 100
       .bottommargin = oexcel.centimeterstopoints(1.17 )
       .topmargin = oexcel.centimeterstopoints(1.17 )
       .rightmargin = oexcel.centimeterstopoints(0.8 )
       tnpageleftmargin = m.tnpageleftmargin/10000
       IF m.tnpageleftmargin<=(40/127)
          tnpageleftmargin = (40/127)
       ENDIF
       .leftmargin = oexcel.inchestopoints(m.tnpageleftmargin)
       DO CASE
          CASE m.tnpageorient=1
             .orientation = 1
          CASE m.tnpageorient=2
             .orientation = 2
       ENDCASE
    ENDWITH
 ENDWITH
 lnenherror = -1
 tctypefileout = UPPER(m.tctypefileout)
 DO CASE
    CASE INLIST(m.tctypefileout, "HTML", "DOC")
       tcexcelfileout = FORCEEXT(m.tcexcelfileout, "htm")
       = delfile(m.tcexcelfileout)
       oworkbook.saveas(m.tcexcelfileout, 44)
       oworkbook.close
       oexcel.quit
       IF FILE(m.tcexcelfileout)
          IF INLIST(m.tctypefileout, "DOC")
             LOCAL oword, odocument, lcfileout, lnworderror
             lcfileout = FORCEEXT(m.tcexcelfileout, "doc")
             lcoldonerror = onerror()
             lnworderror = 0
             ON ERROR lnworderror=ERROR()
             oword = CREATEOBJECT("Word.Application")
             ON ERROR &lcoldonerror
             IF m.lnworderror<>0
                lnenherror = m.lnworderror
                IF  .NOT. m.tlnomessages
                   = worn_mesg("Can not open Word, error "+as(m.lnworderror), m.lctitle)
                ENDIF
             ENDIF
             IF isobject(m.oword)
                IF  .NOT. m.tlnomessages
                   WAIT WINDOW NOCLEAR NOWAIT 'Word automotion, please wait'
                ENDIF
                = delfile(m.lcfileout)
                odocument = oword.documents.open(m.tcexcelfileout)
                IF isobject(odocument)
                   oword.activewindow.view.type = 3
                   WITH odocument
                      WITH .pagesetup
                         DO CASE
                            CASE m.tnpageorient=1
                               .orientation = 0
                               .pagewidth = oword.centimeterstopoints(21)
                               .pageheight = oword.centimeterstopoints(29.7 )
                            CASE m.tnpageorient=2
                               .orientation = 1
                               .pagewidth = oword.centimeterstopoints(29.7 )
                               .pageheight = oword.centimeterstopoints(21)
                         ENDCASE
                         .topmargin = oword.centimeterstopoints(1.17 )
                         .bottommargin = oword.centimeterstopoints(1.17 )
                         .rightmargin = oword.centimeterstopoints(0.8 )
                         .headerdistance = oword.centimeterstopoints(0.8 )
                         .footerdistance = oword.centimeterstopoints(0.8 )
                         .leftmargin = oword.inchestopoints(m.tnpageleftmargin)
                      ENDWITH
                      .saveas(m.lcfileout, 0)
                      .close
                   ENDWITH
                ENDIF
                oword.quit
                IF FILE(m.lcfileout)
                   lnenherror = 0
                   = delfile(m.tcexcelfileout)
                   tcexcelfileout = m.lcfileout
                ENDIF
             ENDIF
          ELSE
             lnenherror = 0
          ENDIF
       ENDIF
    OTHERWISE
       tcexcelfileout = FORCEEXT(m.tcexcelfileout, "xls")
       oworkbook.saveas(m.tcexcelfileout, -4143)
       oworkbook.close
       oexcel.quit
       IF FILE(m.tcexcelfileout)
          lnenherror = 0
       ENDIF
 ENDCASE
 IF  .NOT. m.tlnomessages
    WAIT CLEAR
 ENDIF
 SELECT (m.lnoldselect)
 RETURN m.lnenherror
ENDFUNC
**
FUNCTION GetObjPenColor
 LPARAMETERS tcarrayelement
 LOCAL lnred, lngreen, lnblue, lcsep
 lcsep = ","
 lnred = INT(VAL(wordnum(m.tcarrayelement, 1, m.lcsep)))
 lngreen = INT(VAL(wordnum(m.tcarrayelement, 2, m.lcsep)))
 lnblue = INT(VAL(wordnum(m.tcarrayelement, 3, m.lcsep)))
 RETURN rgbspec(m.lnred, m.lngreen, m.lnblue)
ENDFUNC
**
FUNCTION GetObjFillColor
 LPARAMETERS tcarrayelement, tnobjtype
 LOCAL lnred, lngreen, lnblue, lcsep
 lcsep = ","
 lnred = INT(VAL(wordnum(m.tcarrayelement, 4, m.lcsep)))
 lngreen = INT(VAL(wordnum(m.tcarrayelement, 5, m.lcsep)))
 lnblue = INT(VAL(wordnum(m.tcarrayelement, 6, m.lcsep)))
 IF (m.lnred=0 .AND. m.lngreen=0 .AND. m.lnblue=0 .AND. m.tnobjtype=5) .OR. (m.lnred=-1 .AND. m.lngreen=-1 .AND. m.lnblue=-1)
    RETURN RGB(255, 255, 255)
 ELSE
    RETURN rgbspec(m.lnred, m.lngreen, m.lnblue)
 ENDIF
ENDFUNC
**
FUNCTION RGBspec
 LPARAMETERS tnred, tngreen, tnblue
 RETURN RGB(IIF(m.tnred>=0, m.tnred, 0), IIF(m.tngreen>=0, m.tngreen, 0), IIF(m.tnblue>=0, m.tnblue, 0))
ENDFUNC
**
*** 
*** ReFox - todo no se pierde 
***
