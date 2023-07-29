
*!*	Serializable object to XML

*!*	Author:  Martina Jindrová
*!*	E-mail:  jindra@egservis.cz
*!*	JID:     gorila@dione.zcu.cz  
*!*	Date:    21.07.2010

*!*	Version: 0.0.4
*!*	Changes: m dot fix
*!*	Date:    13.02.2011

*!*	Version: 0.0.3
*!*	Changes: Add new property lShowChangedProperties. If value is .T. then only changed properties wiil be save to XML

DEFINE CLASS _SerializableObject2XML AS CUSTOM
   Name="_SerializableObject2XML"
   PROTECTED iLevel,cBadChars,iObjectList
   PROTECTED ARRAY aObjectList(1) && list of objects

   iLevel=-1     && The object hierarchy level
   iObjectList=0 && Count of items in object list
   iFile=-1      && File handle

   lShowChangedProperties=.F. && Show Changed Properties

   cBadChars="" && list of bad XML characters
   PROCEDURE Init
      LOCAL lcBadChars
      lcBadChars=""
      FOR lii=0 TO 8
          lcBadChars=m.lcBadChars+CHR(m.lii)
      NEXT
      FOR lii=10 TO 31
          lcBadChars=m.lcBadChars+CHR(m.lii)
      NEXT
      This.cBadChars=m.lcBadChars
   ENDPROC

   PROCEDURE StrTranHTMLString(lcString)
      * lcString 
      RETURN STRTRAN(STRTRAN(STRTRAN(STRTRAN(m.lcString,"&","&amp;"),">","&gt;"),"<","&lt;"),'"',"&quot;")
   ENDPROC

   PROTECTED PROCEDURE AddObject2List(loObj)
      LOCAL llExist
      llExist=PEMSTATUS(m.loObj,"__SerializableObjectID",5)
      IF NOT m.llExist
         This.iObjectList=This.iObjectList+1
         DIME This.aObjectList(This.iObjectList)
         This.aObjectList(This.iObjectList)=m.loObj
         =ADDPROPERTY(loObj,"__SerializableObjectID",SYS(2015))
      ENDIF
      RETURN m.llExist
   ENDPROC

   PROTECTED PROCEDURE FreeObjectList()
      LOCAL lii
      FOR lii=1 TO This.iObjectList
         =REMOVEPROPERTY(This.aObjectList(m.lii),"__SerializableObjectID")
      NEXT
      STORE .NULL. TO This.aObjectList
      This.iObjectList=0
      DIME This.aObjectList(1)
   ENDPROC

   PROCEDURE Serializable(luValue,lcFile) && Convert object to XML
      * luValue - Object reference
      * lcFile  - Output file name
      IF EMPTY(m.lcFile)
         lcFile=SYS(2023)+"\"+SYS(2015)+".xml"
      ENDIF   
      This.iFile=FCREATE(m.lcFile,0)
      IF This.iFile<=0
         RETURN ""
      ENDIF

      TEXT TO lcData TEXTMERGE NOSHOW
<?xml version="1.0" encoding="windows-<<CPCURRENT()>>" standalone="yes"?>
<result>

      ENDTEXT
      =FWRITE(This.iFile,m.lcData)

      This.ToXML(m.luValue) && Convert object to XML

      TEXT TO lcData TEXTMERGE NOSHOW 
</result>

      ENDTEXT
      =FWRITE(This.iFile,m.lcData)
      =FCLOSE(This.iFile)
      This.iFile=-1
      This.FreeObjectList()
      RETURN m.lcFile
   ENDPROC


   PROTECTED PROCEDURE ToXML(luValue) && Convert object to XML
      * luValue - Object reference
      LOCAL lcType,lii,liy,liz,loObj,lcPom,liRows,liCols,lcpom2,lcName,lcTABs,;
            lcValue,lcPEM,luMember,lix,llExist,luItem,llObj
      LOCAL ARRAY laMembers(1)  

      This.iLevel=This.iLevel+1
      lcTABs=SPACE(This.iLevel)

      lcType=VARTYPE(m.luValue)  && Typ ofpassed value
      IF m.lcType#'O' OR ISNULL(m.luValue)
         TEXT TO lcData TEXTMERGE NOSHOW
<<m.lcTABs>><value type="<<m.lcType>>"><<IIF(m.lcTYPE$"CM",IIF(LEN(CHRTRAN(m.luValue,This.cBadChars,""))=LEN(m.luValue), This.StrTranHTMLString(m.luValue),STRCONV(m.luValue,13)),m.luValue)>></value>

         ENDTEXT
         =FWRITE(This.iFile,m.lcData)
         This.iLevel=This.iLevel-1
         RETURN ""
      ENDIF

      
      IF PEMSTATUS(m.luValue,"BaseClass",5) AND UPPER(m.luValue.BaseClass)=='COLLECTION'
         TEXT TO lcData TEXTMERGE NOSHOW
<<m.lcTABs>><collection>

         ENDTEXT
         =FWRITE(This.iFile,m.lcData)
         FOR liz=1 TO luValue.Count
             luItem=luValue.Item(m.liz)

             llObj=VARTYPE(m.luItem)="O"   
             llExist=IIF(m.llObj,This.AddObject2List(m.luItem),.F.)

             IF m.llObj
                IF TYPE("m.luItem.Name")="C"
                   TEXT TO lcData TEXTMERGE NOSHOW
<<m.lcTABs>><object name="<<m.luItem.Name>>">

                   ENDTEXT
                ELSE
                   TEXT TO lcData TEXTMERGE NOSHOW
<<m.lcTABs>><object name="">

                   ENDTEXT
                ENDIF   
                =FWRITE(This.iFile,m.lcData)
             ENDIF   
             IF NOT m.llExist
                This.ToXML(m.luItem)
             ELSE
                TEXT TO lcData TEXTMERGE NOSHOW 
<<m.lcTABs>><linkedobject name="<<m.luItem.__SerializableObjectID>>" />

                ENDTEXT
                =FWRITE(This.iFile,m.lcData)
             ENDIF
             IF m.llObj
                TEXT TO lcData TEXTMERGE NOSHOW
<<m.lcTABs>></object>

                ENDTEXT
                =FWRITE(This.iFile,m.lcData)
             ENDIF   
         NEXT
         TEXT TO lcData TEXTMERGE NOSHOW
<<m.lcTABs>></collection>

         ENDTEXT
         =FWRITE(This.iFile,m.lcData)
      ENDIF 

      * walk member list
      lcValue='' 
      liy=AMEMBERS(m.laMembers,m.luValue) 
      FOR lii=1 TO m.liy
          lcPEM=m.laMembers(m.lii)

          TRY
            lcType=IIF(TYPE("ALEN(m.luValue."+m.lcPEM+")")="N","A",TYPE('EVAL("m.luValue."+m.lcPEM)'))
          CATCH 
            lcType="U"
          ENDTRY  

          DO CASE
             CASE m.lcPEM=='OBJECTS'
                  TEXT TO lcData TEXTMERGE NOSHOW
<<m.lcTABs>><collection name="<<m.lcPEM>>" />

                  ENDTEXT
                  =FWRITE(This.iFile,m.lcData)

             CASE m.lcPEM=='CONTROLS'
                  TEXT TO lcData TEXTMERGE NOSHOW
<<m.lcTABs>><collection name="<<m.lcPEM>>" />

                  ENDTEXT
                  =FWRITE(This.iFile,m.lcData)
                  FOR liz=1 TO m.luValue.ControlCount
                      llExist=This.AddObject2List(m.luValue.Controls(m.liz))

                      IF TYPE("m.luValue.Controls(m.liz).Name")="C"
                         TEXT TO lcData TEXTMERGE NOSHOW
<<m.lcTABs>><object name="<<m.luValue.Controls(m.liz).Name>>">

                         ENDTEXT
                      ELSE
                         TEXT TO lcData TEXTMERGE NOSHOW
<<m.lcTABs>><object name="">

                         ENDTEXT
                      ENDIF   
                      =FWRITE(This.iFile,m.lcData)
                      IF NOT m.llExist
                         This.ToXML(m.luValue.Controls(m.liz))
                      ELSE
                         TEXT TO lcData TEXTMERGE NOSHOW 
<<m.lcTABs>><linkedobject name="<<m.luValue.Controls(m.liz).__SerializableObjectID>>" />

                         ENDTEXT
                         =FWRITE(This.iFile,m.lcData)
                      ENDIF
                      TEXT TO lcData TEXTMERGE NOSHOW
<<m.lcTABs>></object>

                      ENDTEXT
                      =FWRITE(This.iFile,m.lcData)
                  NEXT

             CASE m.lcPEM=='PAGES'
                  TEXT TO lcData TEXTMERGE NOSHOW 
<<m.lcTABs>><collection name="<<m.lcPEM>>" />

                  ENDTEXT
                  =FWRITE(This.iFile,m.lcData)
                  FOR liz=1 TO m.luValue.PageCount
                      llExist=This.AddObject2List(m.luValue.Pages(m.liz))

                      TEXT TO lcData TEXTMERGE NOSHOW 
<<m.lcTABs>><object name="<<m.luValue.Pages(m.liz).Name>>">

                      ENDTEXT
                      =FWRITE(This.iFile,m.lcData)
                      IF NOT m.llExist
                         This.ToXML(m.luValue.Pages(m.liz))
                      ELSE
                         TEXT TO lcData TEXTMERGE NOSHOW 
<<m.lcTABs>><linkedobject name="<<m.luValue.Pages(m.liz).__SerializableObjectID>>" />

                         ENDTEXT
                         =FWRITE(This.iFile,m.lcData)
                      ENDIF
                      TEXT TO lcData TEXTMERGE NOSHOW 
<<m.lcTABs>></object>

                      ENDTEXT
                      =FWRITE(This.iFile,m.lcData)
                  NEXT

             CASE m.lcPEM=='COLUMNS'
                  TEXT TO lcData TEXTMERGE NOSHOW 
<<m.lcTABs>><collection name="<<m.lcPEM>>" />
                  ENDTEXT
                  =FWRITE(This.iFile,m.lcData)
                  FOR liz=1 TO m.luValue.ColumnCount
                      llExist=This.AddObject2List(m.luValue.Columns(m.liz))

                      TEXT TO lcData TEXTMERGE NOSHOW 
<<m.lcTABs>><object name="<<m.luValue.Columns(m.liz).Name>>">
                      ENDTEXT
                      =FWRITE(This.iFile,m.lcData)
                      IF NOT m.llExist
                         This.ToXML(m.luValue.Columns(m.liz))
                      ELSE
                         TEXT TO lcData TEXTMERGE NOSHOW 
<<m.lcTABs>><linkedobject name="<<m.luValue.Columns(m.liz).__SerializableObjectID>>" />

                         ENDTEXT
                         =FWRITE(This.iFile,m.lcData)
                      ENDIF
                         
                      TEXT TO lcData TEXTMERGE NOSHOW 
<<m.lcTABs>></object>

                      ENDTEXT
                      =FWRITE(This.iFile,m.lcData)
                  NEXT


             CASE m.lcPEM=='ACTIVEFORM' OR m.lcPEM=='ACTIVECONTROL' OR m.lcPEM=='PARENT'
                  TEXT TO lcData TEXTMERGE NOSHOW 
<<m.lcTABs>><object name="<<m.lcPEM>>"><<IIF(TYPE('m.luValue.'+m.lcPEM)<>'O','',EVAL('m.luValue.'+m.lcPEM+'.Name'))>></object>

                  ENDTEXT
                  =FWRITE(This.iFile,m.lcData)

             CASE m.lcType="A"
                  lcPom='luValue.'+m.lcPEM
                  liRows=EVAL("ALEN("+m.lcPom+",1)")
                  liCols=EVAL("ALEN("+m.lcPom+",2)")
                  IF m.liCols>0
                     TEXT TO lcData TEXTMERGE NOSHOW 
<<m.lcTABs>><array name="<<m.lcPEM>>" rows="<<m.liRows>>" cols="<<m.liCols>>">

                     ENDTEXT
                  ELSE
                     TEXT TO lcData TEXTMERGE NOSHOW 
<<m.lcTABs>><array name="<<m.lcPEM>>" rows="<<m.liRows>>">

                     ENDTEXT
                  ENDIF
                  =FWRITE(This.iFile,m.lcData)

                  * walk cells
                  FOR liz=1 TO EVAL("ALEN("+m.lcPom+")")
                      IF m.liCols>0
                         liRow=INT((m.liz-1)/m.liCols)+1
                         liCol=m.liz-((m.liRow-1)*m.liCols)
                         
                         TEXT TO lcData TEXTMERGE NOSHOW 
<<m.lcTABs>><cell row="<<m.liRow>>" col="<<m.liCol>>">

                         ENDTEXT
                      ELSE
                         TEXT TO lcData TEXTMERGE NOSHOW 
<<m.lcTABs>><cell row="<<m.liz>>">

                         ENDTEXT
                      ENDIF   
                      =FWRITE(This.iFile,m.lcData)
                      This.ToXML(EVAL(m.lcPom+"(m.liz)"))
                      TEXT TO lcData TEXTMERGE NOSHOW
<<m.lcTABs>></cell>

                      ENDTEXT
                      =FWRITE(This.iFile,m.lcData)
                  NEXT
                                    
                  TEXT TO lcData TEXTMERGE NOSHOW
<<m.lcTABs>></array>

                  ENDTEXT
                  =FWRITE(This.iFile,m.lcData)

             CASE lcPEM=='LIST'
                  lcPom='m.luValue.'+m.lcPEM
                  liRows=m.luValue.ListCount
                  liCols=m.luValue.ColumnCount
                  TEXT TO lcData TEXTMERGE NOSHOW 
<<m.lcTABs>><list rows="<<m.liRows>>" cols="<<m.liCols>>">

                  ENDTEXT
                  =FWRITE(This.iFile,m.lcData)

                  FOR liRow=1 TO m.liRows
                      TEXT TO lcData TEXTMERGE NOSHOW 
<<m.lcTABs>><listrow row="<<m.liRow>>">

                      ENDTEXT
                      =FWRITE(This.iFile,m.lcData)
                      FOR liCol=1 TO m.liCols
                          TEXT TO lcData TEXTMERGE NOSHOW 
<<m.lcTABs>><listcol col="<<m.liCol>>">

                          ENDTEXT
                          =FWRITE(This.iFile,m.lcData)

                          This.ToXML(m.luValue.List(m.liRow,m.liCol))
                          TEXT TO lcData TEXTMERGE NOSHOW
<<m.lcTABs>></listcol>

                          ENDTEXT
                          =FWRITE(This.iFile,m.lcData)
                      NEXT   

                      TEXT TO lcData TEXTMERGE NOSHOW
<<m.lcTABs>></listrow>

                      ENDTEXT
                      =FWRITE(This.iFile,m.lcData)
                  NEXT
                                    
                  TEXT TO lcData TEXTMERGE NOSHOW
<<m.lcTABs>></list>

                  ENDTEXT
                  =FWRITE(This.iFile,m.lcData)
   

             CASE m.lcType='O'
                  loObj=EVAL("m.luValue."+m.lcPEM)
                  TEXT TO lcData TEXTMERGE NOSHOW 
<<m.lcTABs>><object name="<<m.lcPEM>>">

                  ENDTEXT
                  =FWRITE(This.iFile,m.lcData)

                  IF !ISNULL(m.loObj)  && pokud ona vlastnost je nenulová
                     llExist=This.AddObject2List(m.loObj)
                     IF NOT m.llExist
                        * pak pøidej názae nalinkovaného objektu
                        This.ToXML(m.loObj)
                     ELSE
                        TEXT TO lcData TEXTMERGE NOSHOW 
<<m.lcTABs>><linkedobject name="<<m.loObj.__SerializableObjectID>>" />

                        ENDTEXT
                        =FWRITE(This.iFile,m.lcData)
                     ENDIF
                  ENDIF   
                  TEXT TO lcData TEXTMERGE NOSHOW 
<<m.lcTABs>></object>

                  ENDTEXT
                  =FWRITE(This.iFile,m.lcData)

             OTHERWISE

                  DO CASE
                     CASE m.lcType==""
                          lcPom= This.StrTranHTMLString("Damaged property")
                          TEXT TO lcData TEXTMERGE NOSHOW
<<m.lcTABs>><value type="<<m.lcType>>" name="<<m.lcPEM>>"><<m.lcPom>></value>

                          ENDTEXT
                          =FWRITE(This.iFile,m.lcData)
                          
                     CASE m.lcType="U"
                          lcPom= This.StrTranHTMLString("Hidden or Protected property")
                          TEXT TO lcData TEXTMERGE NOSHOW
<<m.lcTABs>><value type="<<m.lcType>>" name="<<m.lcPEM>>"><<m.lcPom>></value>

                          ENDTEXT
                          =FWRITE(This.iFile,m.lcData)
                     
                     OTHERWISE
                          luMember=EVAL("m.luValue."+m.lcPEM)
                          IF NOT This.lShowChangedProperties OR This.lShowChangedProperties AND PEMSTATUS(m.luValue,m.lcPEM,0)
                             TEXT TO lcData TEXTMERGE NOSHOW 
<<m.lcTABs>><value type="<<m.lcType>>" name="<<m.lcPEM>>"><<IIF(m.lcType$"CMQW",IIF(m.lcType$"CM" AND LEN(CHRTRAN(m.luMember,This.cBadChars,""))=LEN(m.luMember), This.StrTranHTMLString(m.luMember),STRCONV(m.luMember,13)),m.luMember)>></value>

                             ENDTEXT
                             =FWRITE(This.iFile,m.lcData)
                          ENDIF   
                  ENDCASE
          ENDCASE

      NEXT
      This.iLevel=This.iLevel-1
      RETURN ""
   ENDPROC

ENDDEFINE
