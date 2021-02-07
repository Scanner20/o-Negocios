*** 
*** ReFox XI+  #IT489753  Victor  EMBRACE [VFP70]
***
**
FUNCTION RepExpFl
 PARAMETER tcrepfile, tcclauses, tctofile, tctofiletype, tlsummary, tngroupsummary, tlforcedospart, tlenhcolumn, tlenhheader, tlenhtitle, tlenhsummary, tlnomessages, tcprogressfuncs, tcprogrtitle, tnprogrincrement
 IF EMPTY(m.tngroupsummary)
    tngroupsummary = 0
 ENDIF
 PRIVATE lnoldrecmain, lnmainalias, lnrepalias
 lnmainalias = SELECT()
 lnoldrecmain = recno1()
 lnrepalias = SYS(2015)
 SELECT 0
 USE NOUPDATE (m.tcrepfile) AGAIN ALIAS (m.lnrepalias)
 IF  .NOT. USED()
    SELECT (m.lnmainalias)
    RETURN 2
 ENDIF
 IF _DOS .OR. m.tlforcedospart
    SET FILTER TO platform='DOS'
 ELSE
    SET FILTER TO platform='WINDOWS'
 ENDIF
 GOTO TOP
 IF EOF()
    SET FILTER TO platform='DOS'
    GOTO TOP
 ENDIF
 PRIVATE pcplatform
 pcplatform = PADR(platform, 3)
 PRIVATE pnmaxdisplrow
 pnmaxdisplrow = 6
 PRIVATE lnpageorient, lnleftmargin
 lnpageorient = 0
 lnleftmargin = 0
 LOCATE FOR objtype=1 .AND. objcode=53
 IF FOUND() .AND. LEN(tag2)>45
    lnpageorient = ASC(SUBSTR(tag2, 45, 1))
    lnleftmargin = hpos
 ENDIF
 PRIVATE plreplacevalues
 plreplacevalues = .T.
 PRIVATE pnbandobjtype
 pnbandobjtype = 9
 PRIVATE lnvarobjtype
 lnvarobjtype = 18
 PRIVATE pndetailband, pnheaderband, pntitleband, pnfooterband
 pntitleband = 0
 pnheaderband = 1
 pngrheaderband = 3
 pndetailband = 4
 pngrfooterband = 5
 pnfooterband = 7
 pnsummaryband = 8
 PRIVATE pndettype1, pndettype2
 pndettype1 = 5
 pndettype2 = 8
 PRIVATE pnrestot1gr
 IF m.pcplatform="DOS"
    pnrestot1gr = 3
 ELSE
    pnrestot1gr = 6
 ENDIF
 PRIVATE lcvarname, lnrepvars, ar_vars
 lnrepvars = 0
 SELECT (m.lnrepalias)
 SCAN FOR objtype=m.lnvarobjtype
    lnrepvars = m.lnrepvars+1
    lcvarname = ALLTRIM(name)
    IF "m."=LOWER(PADR(m.lcvarname, 2)) .AND. LEN(m.lcvarname)>2
       lcvarname = SUBSTR(m.lcvarname, 3)
    ENDIF
    IF  .NOT. EMPTY(m.lcvarname)
       DIMENSION ar_vars[m.lnrepvars, 7]
       PRIVATE &lcvarname
       SELECT (m.lnmainalias)
       &lcvarname = EVALUATE( &lnrepalias..TAG )	
       ar_vars[m.lnrepvars, 1] = m.lcvarname
       ar_vars[m.lnrepvars,2] = ALLTRIM(&lnrepalias..EXPR)	
       ar_vars[m.lnrepvars,3] = &lnrepalias..totaltype		
       ar_vars[m.lnrepvars,4] = &lnrepalias..resettotal	
       ar_vars[m.lnrepvars, 5] = 0
       ar_vars[m.lnrepvars, 6] = 0
       ar_vars[m.lnrepvars, 7] = 0
    ENDIF
    SELECT (m.lnrepalias)
 ENDSCAN
 PRIVATE lndetobjects, ar_detail, ar_detstruct, lnvposmin, lnvposmax, i
 DIMENSION ar_detail[1], ar_detstruct[1]
 STORE 0 TO lnvposmin, lnvposmax
 = getvdiapason(m.lnrepalias, m.pndetailband, @m.lnvposmin, @m.lnvposmax, 0)
 lndetobjects = getbandobjects(m.lnrepalias, m.lnvposmin, m.lnvposmax, @ar_detail)
 = crestructarray(m.lndetobjects, @ar_detail, @ar_detstruct, 'Col_')
 FOR i = 1 TO m.lndetobjects
    PRIVATE &ar_detail[m.i,1]
    &ar_detail[m.i,1] = ""
 ENDFOR
 PRIVATE lnsummobjects, ar_summary, ar_summstruct
 DIMENSION ar_summary[1], ar_summstruct[1]
 = getvdiapason(m.lnrepalias, m.pnsummaryband, @m.lnvposmin, @m.lnvposmax, 0)
 lnsummobjects = getbandobjects(m.lnrepalias, m.lnvposmin, m.lnvposmax, @ar_summary)
 = crestructarray(m.lnsummobjects, @ar_summary, @ar_summstruct, 'Summ_')
 FOR i = 1 TO m.lnsummobjects
    PRIVATE &ar_summary[m.i,1]
    &ar_summary[m.i,1] = ""
 ENDFOR
 PRIVATE ar_header
 DIMENSION ar_header[1]
 IF m.tlenhheader
    PRIVATE lnheadobjects, ar_headstruct, lnvminheader, lnvmaxheader
    STORE 0 TO lnvminheader, lnvmaxheader
    DIMENSION ar_headstruct[1]
    = getvdiapason(m.lnrepalias, m.pnheaderband, @m.lnvminheader, @m.lnvmaxheader, 0)
    lnheadobjects = getbandobjects(m.lnrepalias, m.lnvminheader, m.lnvmaxheader, @ar_header)
    = crestructarray(m.lnheadobjects, @ar_header, @ar_headstruct, 'Head_')
    FOR i = 1 TO m.lnheadobjects
       PRIVATE &ar_header[m.i,1]
       &ar_header[m.i,1] = ""
    ENDFOR
 ENDIF
 PRIVATE ar_title
 DIMENSION ar_title[1]
 IF m.tlenhtitle
    PRIVATE lntitlobjects, ar_titlstruct, lnvmintitle, lnvmaxtitle
    STORE 0 TO lnvmintitle, lnvmaxtitle
    DIMENSION ar_titlstruct[1]
    = getvdiapason(m.lnrepalias, m.pntitleband, @m.lnvmintitle, @m.lnvmaxtitle, 0)
    lntitlobjects = getbandobjects(m.lnrepalias, m.lnvmintitle, m.lnvmaxtitle, @ar_title)
    = crestructarray(m.lntitlobjects, @ar_title, @ar_titlstruct, 'Titl_')
    FOR i = 1 TO m.lntitlobjects
       PRIVATE &ar_title[m.i,1]
       &ar_title[m.i,1] = ""
    ENDFOR
 ENDIF
 PRIVATE pngroups, ar_groups
 pngroups = 0
 SELECT (m.lnrepalias)
 SCAN FOR objtype=m.pnbandobjtype .AND. objcode=m.pngrheaderband .AND.  .NOT. EMPTY(expr)
    pngroups = m.pngroups+1
    DIMENSION ar_groups[m.pngroups, 5]
    ar_groups[m.pngroups, 1] = ALLTRIM(expr)
    SELECT (m.lnmainalias)
    ar_groups[m.pngroups, 4] = nullinit(EVALUATE(ar_groups(m.pngroups, 1)))
    SELECT (m.lnrepalias)
    ar_groups[m.pngroups, 5] = .F.
 ENDSCAN
 PRIVATE lcgrp, j, lctemp
 FOR j = 1 TO m.pngroups
    lcgrp = as(m.j)
    PRIVATE ar_grh&lcgrp, ar_grhs&lcgrp
    DIMENSION ar_grh&lcgrp[1], ar_grhs&lcgrp[1]
    = getvdiapason(m.lnrepalias, m.pngrheaderband, @m.lnvposmin, @m.lnvposmax, m.j)
    ar_groups[m.j,2] = getbandobjects( m.lnrepalias, m.lnvposmin, m.lnvposmax, @ar_grh&lcgrp )
    =crestructarray( ar_groups[m.j,2], @ar_grh&lcgrp, @ar_grhs&lcgrp, "Gh"+m.lcgrp+"_" )
    FOR i = 1 TO ar_groups(m.j, 2)
       lctemp = ar_grh&lcgrp[m.i,1]
       PRIVATE &lctemp
       &lctemp = ""
    ENDFOR
    PRIVATE ar_grf&lcgrp, ar_grfs&lcgrp
    DIMENSION ar_grf&lcgrp[1], ar_grfs&lcgrp[1]
    = getvdiapason(m.lnrepalias, m.pngrfooterband, @m.lnvposmin, @m.lnvposmax, m.j)
    ar_groups[m.j,3] = getbandobjects( m.lnrepalias, m.lnvposmin, m.lnvposmax, @ar_grf&lcgrp )
    =crestructarray( ar_groups[m.j,3], @ar_grf&lcgrp, @ar_grfs&lcgrp, "Gf"+m.lcgrp+"_" )
    FOR i = 1 TO ar_groups(m.j, 3)
       lctemp = ar_grf&lcgrp[m.i,1]
       PRIVATE &lctemp
       &lctemp = ""
    ENDFOR
 ENDFOR
 SELECT (m.lnrepalias)
 USE
 IF m.lndetobjects=0
    IF  .NOT. m.tlsummary .AND. m.tngroupsummary=0
       tngroupsummary = m.pngroups
    ENDIF
    tlsummary = .T.
 ENDIF
 PRIVATE lcgroupsummary
 IF m.tlsummary .AND. m.pngroups>0 .AND. m.tngroupsummary>0 .AND.  .NOT. BETWEEN(m.tngroupsummary, 1, m.pngroups)
    tngroupsummary = m.pngroups
 ENDIF
 IF m.tlsummary .AND. m.pngroups=0 .AND. m.tngroupsummary>0
    tngroupsummary = 0
 ENDIF
 lcgroupsummary = as(m.tngroupsummary)
 PRIVATE pccursname, lncurscreerror, pcarractstr, pcarract
 pccursname = SYS(2015)
 lncurscreerror = 1
 pcarractstr = ""
 DO CASE
    CASE m.lndetobjects>0 .AND.  .NOT. m.tlsummary
       pcarractstr = 'ar_DetStruct'
       pcarract = 'ar_Detail'
    CASE m.lnsummobjects>0 .AND. m.tngroupsummary=0 .AND. m.tlsummary
       pcarractstr = 'ar_SummStruct'
       pcarract = 'ar_Summary'
    CASE m.pngroups>0 .AND. m.tngroupsummary>0 .AND. ar_groups(m.tngroupsummary, 3)>0
       pcarractstr = 'ar_GrFs'+m.lcgroupsummary
       pcarract = 'ar_GrF'+m.lcgroupsummary
    CASE m.pngroups>0 .AND. m.tngroupsummary>0 .AND. ar_groups(m.tngroupsummary, 2)>0
       pcarractstr = 'ar_GrHs'+m.lcgroupsummary
       pcarract = 'ar_GrH'+m.lcgroupsummary
 ENDCASE
 IF  .NOT. EMPTY(m.pcarractstr)
    lncurscreerror = cretabl1( '', @&pcarractstr, 0, m.pccursname )
 ENDIF
 IF m.lncurscreerror<>0
    SELECT (m.lnmainalias)
    RETURN m.lncurscreerror
 ENDIF
 PRIVATE n1, llappend, legroupvalue, lnrecsprocessed, lnrecsadded, lnresettotal, lngroupreset, levalue, lnaverage
 STORE 0 TO lnrecsprocessed, lnrecsadded
 SELECT (m.lnmainalias)
 PRIVATE lnrecstotal, lnrecordoriginal
 lnrecordoriginal = recno1()
 COUNT &tcclauses TO lnrecstotal
 PRIVATE lluseprogress, lnerror, lcoldonerr
 lcoldonerr = onerror()
 lluseprogress = .F.
 IF  .NOT. EMPTY(m.tcprogressfuncs)
    PRIVATE lcsep, lcprogresskey
    lcsep = ","
    IF words(m.tcprogressfuncs, m.lcsep)=3
       PRIVATE lcprogrinitfunc, lcprogrupdatefunc, lcprogrreleasefunc
       lcprogrinitfunc = wordnum(m.tcprogressfuncs, 1, m.lcsep)
       lcprogrupdatefunc = wordnum(m.tcprogressfuncs, 2, m.lcsep)
       lcprogrreleasefunc = wordnum(m.tcprogressfuncs, 3, m.lcsep)
       lcprogresskey = "RepExp"
       lnerror = 0
       ON ERROR lnerror=ERROR()
       =&lcprogrinitfunc( m.lcprogresskey, m.tcprogrtitle, "Scanning", 0, m.lnrecstotal, m.tnprogrincrement, .f.)
       ON ERROR &lcoldonerr
       lluseprogress = (m.lnerror=0)
    ENDIF
 ENDIF
 = go1(m.lnrecordoriginal)
 SCAN &tcclauses
    lnrecsprocessed = m.lnrecsprocessed+1
    IF m.lluseprogress
       =&lcprogrupdatefunc( m.lcprogresskey, m.lnrecsprocessed, .t., "" )
    ENDIF
    FOR i = 1 TO m.pngroups
       legroupvalue = EVALUATE(ar_groups(m.i, 1))
       ar_groups[m.i, 5] = ar_groups(m.i, 4)<>m.legroupvalue
       ar_groups[m.i, 4] = m.legroupvalue
    ENDFOR
    IF m.lnrecsprocessed>1 .AND.  .NOT. (m.lndetobjects>0 .AND.  .NOT. m.tlsummary) .AND. (m.pngroups>0 .AND. m.tngroupsummary>0 .AND. ar_groups(m.tngroupsummary, 3)>0)
       IF ar_groups(m.tngroupsummary, 5)
          IF app_onerecord()=0
             lnrecsadded = m.lnrecsadded+1
          ENDIF
       ENDIF
    ENDIF
    FOR m.n1 = 1 TO m.lnrepvars
       lctemp = ar_vars(m.n1, 1)
       lnresettotal = ar_vars(m.n1, 4)
       IF m.lnresettotal>=m.pnrestot1gr
          lngroupreset = m.lnresettotal-m.pnrestot1gr+1
          IF ar_groups(m.lngroupreset, 5)
             ar_vars[m.n1, 5] = 0
             ar_vars[m.n1, 6] = 0
             ar_vars[m.n1, 7] = 0
             &lctemp = 0
          ENDIF
       ENDIF
       ar_vars[m.n1, 6] = ar_vars(m.n1, 6)+1
       DO CASE
          CASE ar_vars(m.n1, 3)=1
             &lctemp = m.&lctemp + 1
          CASE ar_vars(m.n1, 3)=2
             &lctemp = m.&lctemp + EVALUATE(ar_vars[m.n1,2])
          CASE ar_vars(m.n1, 3)=3
             ar_vars[m.n1, 5] = ar_vars(m.n1, 5)+EVALUATE(ar_vars(m.n1, 2))
             &lctemp = ar_vars[m.n1,5] / ar_vars[m.n1,6]
          CASE ar_vars(m.n1, 3)=4
             levalue = EVALUATE(ar_vars(m.n1, 2))
             IF ar_vars(m.n1, 6)=1
                &lctemp = m.levalue
             ELSE
                IF m.levalue < m.&lctemp
                   &lctemp = m.levalue
                ENDIF
             ENDIF
          CASE ar_vars(m.n1, 3)=5
             levalue = EVALUATE(ar_vars(m.n1, 2))
             IF ar_vars(m.n1, 6)=1
                &lctemp = m.levalue
             ELSE
                IF m.levalue > m.&lctemp
                   &lctemp = m.levalue
                ENDIF
             ENDIF
          CASE INLIST(ar_vars(m.n1, 3), 6, 7)
             levalue = EVALUATE(ar_vars(m.n1, 2))
             ar_vars[m.n1, 5] = ar_vars(m.n1, 5)+m.levalue
             ar_vars[m.n1, 7] = ar_vars(m.n1, 7)+m.levalue*m.levalue
             lnaverage = ar_vars(m.n1, 5)/ar_vars(m.n1, 6)
             &lctemp = ( ar_vars[m.n1,7] - ar_vars[m.n1,5]*m.lnaverage*2 ) / ar_vars[m.n1,6] + m.lnaverage*m.lnaverage	
             IF ar_vars(m.n1, 3)=6
                &lctemp = SQRT( m.&lctemp )	
             ENDIF
          OTHERWISE
             &lctemp = EVALUATE(ar_vars[m.n1,2])
       ENDCASE
    ENDFOR
    llappend = .F.
    DO CASE
       CASE m.lndetobjects>0 .AND.  .NOT. m.tlsummary
          llappend = rpprocessojects(m.lndetobjects, @ar_detail, 0)
       CASE m.pngroups>0 .AND. m.tngroupsummary>0 .AND. ar_groups(m.tngroupsummary, 3)>0
          =rpprocessojects( ar_groups[m.tngroupsummary,3], @ar_grf&lcgroupsummary, 0 )
       CASE m.pngroups>0 .AND. m.tngroupsummary>0 .AND. ar_groups(m.tngroupsummary, 2)>0
          llappend = rpprocessojects( ar_groups[m.tngroupsummary,2], @ar_grh&lcgroupsummary, 0 )
          IF m.llappend .AND.  .NOT. ar_groups(m.tngroupsummary, 5)
             llappend = .F.
          ENDIF
    ENDCASE
    = rpprocessojects(m.lnsummobjects, @ar_summary, 1)
    IF m.llappend
       IF app_onerecord()=0
          lnrecsadded = m.lnrecsadded+1
       ENDIF
    ENDIF
    SELECT (m.lnmainalias)
 ENDSCAN
 = rpprocessojects(m.lnsummobjects, @ar_summary, 2)
 IF  .NOT. (m.lndetobjects>0 .AND.  .NOT. m.tlsummary) .AND. ((m.pngroups>0 .AND. m.tngroupsummary>0 .AND. ar_groups(m.tngroupsummary, 3)>0) .OR. (m.tngroupsummary=0 .AND. m.tlsummary))
    IF app_onerecord()=0
       lnrecsadded = m.lnrecsadded+1
    ENDIF
 ENDIF
 IF m.lluseprogress
    =&lcprogrreleasefunc( m.lcprogresskey )
 ENDIF
 PRIVATE lctoclause
 lctoclause = wordnum(m.tctofiletype, 1, "_")
 SELECT (m.pccursname)
 lnerror = 0
 ON ERROR lnerror=ERROR()
 IF UPPER(PADR(m.tctofiletype, 2))="XL"
    tctofile = FORCEEXT(m.tctofile, "xls")
 ENDIF
 COPY TO (m.tctofile) &lctoclause
 ON ERROR &lcoldonerr
 = close1(m.pccursname)
 IF m.lnerror=0 .AND. foxversion()>3
    PRIVATE lcfunc, tctofile0, lctypefileout
    lctypefileout = wordnum(m.tctofiletype, 2, "_")
    IF  .NOT. EMPTY(m.lctypefileout)
       lcfunc = "RepEnhance"
       tctofile0 = FORCEEXT(ADDBS(JUSTPATH(m.tctofile))+JUSTSTEM(m.tctofile)+"_tmp", JUSTEXT(m.tctofile))
       IF renfile(m.tctofile, m.tctofile0)
          IF &lcfunc( m.tctofile0, @m.tctofile, m.lctypefileout, m.pcplatform, m.tlenhcolumn, m.tlenhheader, m.tlenhtitle, tlenhsummary,  @&pcarract, @ar_header, @ar_title, @ar_summary, m.lnrecsadded, m.lnpageorient, m.lnleftmargin, m.tlnomessages ) = 0
             = delfile(m.tctofile0)
          ELSE
             = renfile(m.tctofile0, m.tctofile)
          ENDIF
       ENDIF
    ENDIF
 ENDIF
 SELECT (m.lnmainalias)
 = go1(m.lnoldrecmain)
 RETURN m.lnerror
ENDFUNC
**
FUNCTION GetVdiapason
 PARAMETER tnrepalias, tnband, tnvposmin, tnvposmax, tngroup
 PRIVATE lnoldselect, llok
 llok = .T.
 lnoldselect = SELECT()
 SELECT (m.tnrepalias)
 PRIVATE lndesignheight
 IF m.pcplatform='DOS'
    lndesignheight = 0
 ELSE
    lndesignheight = 2083.333 
 ENDIF
 STORE 0 TO tnvposmin, tnvposmax
 PRIVATE lngroupcount, lnlastheightadded
 lnlastheightadded = 0
 lngroupcount = 0
 IF m.tnband=m.pngrfooterband
    lngroupcount = m.pngroups+1
 ENDIF
 SCAN FOR objtype=m.pnbandobjtype .AND. objcode<=m.tnband
    IF m.tnband=m.pngrheaderband .AND. objcode=m.pngrheaderband
       lngroupcount = m.lngroupcount+1
       IF m.lngroupcount>m.tngroup
          EXIT
       ENDIF
    ENDIF
    lnlastheightadded = height+m.lndesignheight
    tnvposmax = m.tnvposmax+m.lnlastheightadded
    IF m.tnband=m.pngrfooterband .AND. objcode=m.pngrfooterband
       lngroupcount = m.lngroupcount-1
       IF m.lngroupcount=m.tngroup
          EXIT
       ENDIF
    ENDIF
 ENDSCAN
 tnvposmin = m.tnvposmax-m.lnlastheightadded
 tnvposmax = m.tnvposmax-1
 IF m.tnvposmin>=m.lndesignheight
    tnvposmin = m.tnvposmin-m.lndesignheight
    tnvposmax = m.tnvposmax-m.lndesignheight
 ENDIF
 SELECT (m.lnoldselect)
 RETURN m.llok
ENDFUNC
**
FUNCTION GetBandObjects
 PARAMETER tnrepalias, tnvposmin, tnvposmax, ar_detail
 PRIVATE lnoldselect
 lnoldselect = SELECT()
 SELECT (m.tnrepalias)
 PRIVATE lndetobjects, levalue, lcexpr
 lndetobjects = 0
 SCAN FOR INLIST(objtype, m.pndettype1, m.pndettype2) .AND. BETWEEN(vpos, m.tnvposmin, m.tnvposmax)
    lcexpr = ALLTRIM(expr)
    IF m.pcplatform="DOS" .AND. objtype=5 .AND. LEN(m.lcexpr)=3 .AND. EVALUATE(m.lcexpr)$m.dw_dosgrph+"+-_|"
       LOOP
    ENDIF
    lndetobjects = m.lndetobjects+1
    DIMENSION ar_detail[m.lndetobjects, 19]
    ar_detail[m.lndetobjects, 1] = ""
    ar_detail[m.lndetobjects, 2] = m.lcexpr
    ar_detail[m.lndetobjects, 3] = objtype
    IF objtype=m.pndettype2
       SELECT (m.lnmainalias)
       levalue = EVALUATE(ar_detail(m.lndetobjects, 2))
       ar_detail[m.lndetobjects, 4] = VARTYPE(m.levalue)
       SELECT (m.tnrepalias)
    ELSE
       ar_detail[m.lndetobjects, 4] = 'C'
    ENDIF
    ar_detail[m.lndetobjects, 5] = vpos
    ar_detail[m.lndetobjects, 6] = hpos
    ar_detail[m.lndetobjects, 7] = totaltype
    ar_detail[m.lndetobjects, 8] = resettotal
    ar_detail[m.lndetobjects, 9] = 0
    ar_detail[m.lndetobjects, 10] = 0
    ar_detail[m.lndetobjects, 11] = 0
    ar_detail[m.lndetobjects, 12] = width
    ar_detail[m.lndetobjects, 13] = stretch
    ar_detail[m.lndetobjects, 14] = fontface
    ar_detail[m.lndetobjects, 15] = fontsize
    ar_detail[m.lndetobjects, 16] = fontstyle
    ar_detail[m.lndetobjects, 17] = picture
    ar_detail[m.lndetobjects, 18] = as(penred)+","+as(pengreen)+","+as(penblue)+","+as(fillred)+","+as(fillgreen)+","+as(fillblue)
    ar_detail[m.lndetobjects, 19] = offset
 ENDSCAN
 SELECT (m.lnoldselect)
 RETURN m.lndetobjects
ENDFUNC
**
FUNCTION RpProcessOjects
 PARAMETER tnobjects, ar_band, tntypecalc
 EXTERNAL ARRAY ar_band
 PRIVATE llok, lctemp, k1, lntotaltype, lnresettotal, lngroupreset, levalue, lnaverage
 llok = .T.
 FOR m.k1 = 1 TO m.tnobjects
    lctemp = ar_band(m.k1, 1)
    lntotaltype = ar_band(m.k1, 7)
    DO CASE
       CASE m.tntypecalc=1 .AND. m.lntotaltype=0
          LOOP
       CASE m.tntypecalc=2 .AND. m.lntotaltype>0
          LOOP
    ENDCASE
    lnresettotal = ar_band(m.k1, 8)
    IF INLIST(ar_band(m.k1, 3), m.pndettype1, m.pndettype2)
       IF m.lnresettotal>=m.pnrestot1gr
          lngroupreset = m.lnresettotal-m.pnrestot1gr+1
          IF ar_groups(m.lngroupreset, 5)
             ar_band[m.k1, 9] = 0
             ar_band[m.k1, 10] = 0
             ar_band[m.k1, 11] = 0
             &lctemp = 0
          ENDIF
       ENDIF
       ar_band[m.k1, 10] = ar_band(m.k1, 10)+1
       DO CASE
          CASE m.lntotaltype=1
             IF TYPE(m.lctemp)<>'N'
                &lctemp = 0
             ENDIF
             &lctemp = m.&lctemp + 1
          CASE m.lntotaltype=2
             IF TYPE(m.lctemp)<>'N'
                &lctemp = 0
             ENDIF
             &lctemp = m.&lctemp + EVALUATE(ar_band[m.k1,2])
          CASE m.lntotaltype=3
             ar_band[m.k1, 9] = ar_band(m.k1, 9)+EVALUATE(ar_band(m.k1, 2))
             &lctemp = ar_band[m.k1,9] / ar_band[m.k1,10]					
          CASE m.lntotaltype=4
             levalue = EVALUATE(ar_band(m.k1, 2))
             IF ar_band(m.k1, 10)=1
                &lctemp = m.levalue
             ELSE
                IF m.levalue < m.&lctemp
                   &lctemp = m.levalue
                ENDIF
             ENDIF
          CASE m.lntotaltype=5
             levalue = EVALUATE(ar_band(m.k1, 2))
             IF ar_band(m.k1, 10)=1
                &lctemp = m.levalue
             ELSE
                IF m.levalue > m.&lctemp
                   &lctemp = m.levalue
                ENDIF
             ENDIF
          CASE INLIST(m.lntotaltype, 6, 7)
             levalue = EVALUATE(ar_band(m.k1, 2))
             ar_band[m.k1, 9] = ar_band(m.k1, 9)+m.levalue
             ar_band[m.k1, 11] = ar_band(m.k1, 11)+m.levalue*m.levalue
             lnaverage = ar_band(m.k1, 9)/ar_band(m.k1, 10)
             &lctemp = ( ar_band[m.k1,11] - ar_band[m.k1,9]*m.lnaverage*2 ) / ar_band[m.k1,10] + m.lnaverage*m.lnaverage	
             IF m.lntotaltype=6
                &lctemp = SQRT( m.&lctemp )	
             ENDIF
          OTHERWISE
             &lctemp = EVALUATE(ar_band[m.k1,2])
       ENDCASE
       IF TYPE(m.lctemp)='C' .AND. m.pcplatform='DOS'
          &lctemp = dos_win( m.&lctemp )
       ENDIF
    ENDIF
 ENDFOR
 RETURN m.llok
ENDFUNC
**
FUNCTION CreStructArray
 PARAMETER tnobjects, ar_band, ar_struct, tcnameprefix
 EXTERNAL ARRAY ar_band
 IF m.tnobjects<=0
    RETURN .F.
 ENDIF
 PRIVATE lnoldselect
 lnoldselect = SELECT()
 PRIVATE lcaliascurs, a_cursstruct, i
 DIMENSION a_cursstruct[2, 4]
 a_cursstruct[1, 1] = 'Vpos'
 a_cursstruct[1, 2] = 'N'
 a_cursstruct[1, 3] = 9
 a_cursstruct[1, 4] = 3
 a_cursstruct[2, 1] = 'Hpos'
 a_cursstruct[2, 2] = 'N'
 a_cursstruct[2, 3] = 9
 a_cursstruct[2, 4] = 3
 lcaliascurs = SYS(2015)
 IF cretabl1('', @a_cursstruct, 0, m.lcaliascurs)<>0
    SELECT (m.lnoldselect)
    RETURN .F.
 ENDIF
 SELECT (m.lcaliascurs)
 INDEX ON STR(vpos, 9, 3)+STR(hpos, 9, 3) TAG curc1
 FOR m.i = 1 TO m.tnobjects
    APPEND BLANK
    REPLACE vpos WITH ar_band(m.i, 5)
    REPLACE hpos WITH ar_band(m.i, 6)
 ENDFOR
 PRIVATE k, lndecimals, lndigits, lnwidth
 DIMENSION ar_struct[m.tnobjects, 4]
 PRIVATE lnrepcharsize
 i = 0
 SCAN
    k = RECNO()
    i = m.i+1
    ar_band[m.k, 1] = m.tcnameprefix+as(m.i)
    ar_struct[m.i, 1] = ar_band(m.k, 1)
    ar_struct[m.i, 2] = ar_band(m.k, 4)
    IF m.pcplatform='WIN'
       lnrepcharsize = (FONTMETRIC(6, ar_band(m.k, 14), ar_band(m.k, 15), fontstylen(ar_band(m.k, 16)))/96)*10000
       lnwidth = CEILING(ar_band(m.k, 12)/m.lnrepcharsize)
    ELSE
       lnwidth = ar_band(m.k, 12)
    ENDIF
    ar_struct[m.i, 3] = 10
    ar_struct[m.i, 4] = 0
    lnwidth = INT(m.lnwidth)
    DO CASE
       CASE INLIST(ar_struct(m.i, 2), 'D', 'T')
          ar_struct[m.i, 3] = 8
       CASE INLIST(ar_struct(m.i, 2), 'C', 'M')
          ar_struct[m.i, 2] = 'C'
          IF  .NOT. ar_band(m.k, 13)
             ar_struct[m.i, 3] = m.lnwidth
          ELSE
             ar_struct[m.i, 3] = MIN(254, INT(m.lnwidth*m.pnmaxdisplrow))
          ENDIF
       CASE ar_struct(m.i, 2)='N'
          lndigits = 20
          lndecimals = 6
          IF m.lnwidth+m.lndecimals+IIF(m.lndecimals=0, 0, 1)<=m.lndigits
             ar_struct[m.i, 3] = m.lnwidth+m.lndecimals+IIF(m.lndecimals=0, 0, 1)
             ar_struct[m.i, 4] = m.lndecimals
          ELSE
             ar_struct[m.i, 3] = m.lndigits
             IF m.lnwidth>17
                ar_struct[m.i, 4] = 2
             ELSE
                ar_struct[m.i, 4] = m.lndigits-m.lnwidth-1
             ENDIF
          ENDIF
    ENDCASE
 ENDSCAN
 USE
 SELECT (m.lnoldselect)
 RETURN .T.
ENDFUNC
**
FUNCTION App_OneRecord
 PRIVATE lnoldselect, lnerror
 lnerror = 0
 lnoldselect = SELECT()
 SELECT (m.pccursname)
 APPEND BLANK
 IF m.plreplacevalues
    PRIVATE lncolumns, i, lccolvarname
    lncolumns = ALEN( &pcarractstr, 1 )
    FOR i = 1 TO m.lncolumns
       lccolvarname = &pcarractstr[m.i,1]
       REPLACE &lccolvarname WITH m.&lccolvarname
    ENDFOR
 ELSE
    GATHER MEMVAR
 ENDIF
 SELECT (m.lnoldselect)
 RETURN m.lnerror
ENDFUNC
**
*** 
*** ReFox - todo no se pierde 
***
