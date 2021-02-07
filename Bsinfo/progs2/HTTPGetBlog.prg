    

CLEAR ALL

CLEAR 

#define WAIT_TIMEOUT                     258

#define ERROR_ALREADY_EXISTS             183

#define WM_USER                                                              0x400

 

SET EXCLUSIVE OFF 

SET SAFETY OFF 

SET ASSERTS ON 

PUBLIC oBlogForm as Form

oBlogForm=creat("BlogForm","blogs.msdn.com/Calvin_Hsia")

oBlogForm.Visible=1

DEFINE CLASS BlogForm AS Form

          Height=_screen.Height-80

          Width = 900

          AllowOutput=0

          left=170

          cBlogUrl=""

          oThreadMgr=null

          ADD OBJECT txtSearch as textbox WITH width=200

          ADD OBJECT cmdSearch as CommandButton WITH left=210,caption="\<Search"

          ADD OBJECT cmdCrawl as CommandButton WITH left=310,caption="\<Crawl"

          ADD OBJECT cmdQuit as CommandButton WITH left=410,caption="\<Quit"

          ADD OBJECT oGrid as Grid WITH;
          
          			width = thisform.Width,;

                   top=20,;

                   ReadOnly=1,;

                   Anchor=15

          ADD OBJECT oWeb as cWeb WITH ;

                   top=230,;

                   height=thisform.Height-250,;

                   width = thisform.Width,;

                   Anchor=15

          ADD OBJECT lblStatus as label WITH top = thisform.Height-18,width = thisform.Width,anchor=4,caption=""

          PROCEDURE Init(cUrl as String)

                   this.cBlogUrl=cUrl

                   IF !FILE("blogs.dbf")

                             CREATE table Blogs(title c(250),pubdate t,link c(100),followed i, Stored t,mht m)

                             INDEX on link TAG link

                             INDEX on pubdate TAG pubdate DESCENDING 

                             INSERT INTO Blogs (link) VALUES (cUrl)     && jump start the table with a link

                             INSERT INTO blogs (link) VALUES ('http://blogs.msdn.com/vsdata/archive/2004/03/18/92346.aspx')        && early blogs

                             INSERT INTO blogs (link) VALUES ('http://blogs.msdn.com/vsdata/archive/2004/03/31/105159.aspx')

                             INSERT INTO blogs (link) VALUES ('http://blogs.msdn.com/vsdata/archive/2004/04/05/107986.aspx')

                             INSERT INTO blogs (link) VALUES ('http://blogs.msdn.com/vsdata/archive/2004/05/12/130612.aspx')

                             INSERT INTO blogs (link) VALUES ('http://blogs.msdn.com/vsdata/archive/2004/06/16/157451.aspx')

                   ENDIF 

                   USE blogs SHARED    && reopen shared

                   this.RequeryData()

                   this.RefrGrid

          PROCEDURE RequeryData

                   LOCAL cTxt, cWhere

                   cTxt=ALLTRIM(thisform.txtSearch.value)

                   cWhere= "!EMPTY(mht)"

                   IF LEN(cTxt)>0

                             cWhere=cWhere+" and ATC(cTxt, mht)>0"

                   ENDIF 

                   SELECT * FROM blogs WHERE  &cWhere ORDER BY pubdate DESC INTO CURSOR Result

                   thisform.lblStatus.caption="# records ="+TRANSFORM(_tally)

                   WITH this.oGrid

                             .RecordSource= "Result"

                             .Column1.FontSize=14

                             .Column1.Width=this.Width-120

                             .RowHeight=25

                   ENDWITH 

                   thisform.refrGrid      

          PROCEDURE RefrGrid

                   cFilename=ADDBS(GETENV("temp"))+SYS(3)+".mht"

                   STRTOFILE(mht,cFilename)

                   thisform.oWeb.Navigate(cFilename)

          PROCEDURE oGrid.AfterRowColChange(nColIndex as Integer)

                   IF this.rowcolChange=1       && row changed

                             thisform.RefrGrid

                   ENDIF 

          PROCEDURE cmdQuit.Click

                   thisform.Release

          PROCEDURE cmdCrawl.Click

                   thisform.txtSearch.value=""

                   fBackgroundThread=.t.       && if you want to run on background thread

                   IF this.Caption = "\<Crawl"

                             thisform.lblStatus.caption= "Blog crawl start"

                             CreateCrawlProc()

                             IF fBackgroundThread

                                      this.Caption="Stop \<Crawl"

                                      *Get ThreadManager from http://blogs.msdn.com/calvin_hsia/archive/2006/05/23/605465.aspx

                                      thisform.oThreadMgr=NEWOBJECT("ThreadManager","threads.prg")

                                       thisform.oThreadMgr.CreateThread("MyThreadFunc",thisform.cBlogUrl,"oBlogForm.CrawlDone")

                                      thisform.lblStatus.caption= "Background Crawl Thread Created"

                             ELSE

                                      LOCAL oBlogCrawl

                                      oBlogCrawl=NEWOBJECT("BlogCrawl","MyThreadFunc.prg","",thisform.cBlogUrl)          && the class def resides in MyThreadFunc.prg

                                      thisform.CrawlDone

                             ENDIF 

                   ELSE

                             this.Caption="\<Crawl"

                             IF fBackgroundThread AND TYPE("thisform.oThreadMgr")="O"

                                      thisform.lblStatus.caption= "Attempting thread stop"

                                      thisform.oThreadMgr.SendMsgToStopThreads()

                             ENDIF 

                   ENDIF 

          PROCEDURE CrawlDone

                   thisform.oThreadMgr=null 

                   thisform.cmdCrawl.caption="\<Crawl"

                   thisform.lblStatus.caption= "Crawl done"

                   this.RequeryData()

          PROCEDURE cmdSearch.Click

                   thisform.RequeryData

          PROCEDURE destroy

                   IF USED("result")

                             USE IN result

                   ENDIF 

                   SELECT Blogs

                   SET MESSAGE TO 

                   SET FILTER TO 

                   SET ORDER TO LINK   && LINK

ENDDEFINE

 

DEFINE CLASS cweb as olecontrol

          oleclass="shell.explorer.2"

          PROCEDURE refreshxxx

                   NODEFAULT

          PROCEDURE TitleChange(cText as String)

                   thisform.caption=cText

          PROCEDURE Navigatecomplete2(pDisp AS VARIANT, URL AS VARIANT) AS VOID

                   IF url=GETENV("TEMP")

                             ERASE (url)

                   ENDIF 

ENDDEFINE

 

 

PROCEDURE CreateCrawlProc as String      && Create the Thread proc, which includes the crawling class

TEXT TO cstrVFPCode TEXTMERGE NOSHOW && generate the task to run: MyThreadFunc

**************************************************

**************************************************

          PROCEDURE MyThreadFunc(p2)      && p2 is the 2nd param to MyDoCmd

                   TRY

                             DECLARE integer GetCurrentThreadId in WIN32API 

                             DECLARE integer PostMessage IN WIN32API integer hWnd, integer nMsg, integer wParam, integer lParam

                             cParm=SUBSTR(p2,AT(",",p2)+1)

                             hWnd=INT(VAL(p2))

                             oBlogCrawl=CREATEOBJECT("BlogCrawl",cParm)

                   CATCH TO oEx

                             DECLARE integer MessageBoxA IN WIN32API integer,string,string,integer

                             MESSAGEBOXA(0,oEx.details+" "+oEx.message,TRANSFORM(oex.lineno),0)

                   ENDTRY

                   PostMessage(hWnd, WM_USER, 0, GetCurrentThreadId())

DEFINE CLASS BlogCrawl as session

          oWeb=0

          oWSH=0

          fStopCrawl=.f.

          hEvent=0

          cMonths="January   February  March     April     May       June      July      August    September October   November  December  "

          cCurrentLink=""

          PROCEDURE init(cBlogUrl)

                   LOCAL fDone,nRec,nStart

                   nStart=SECONDS()

                   DECLARE integer CreateEvent IN WIN32API integer lpEventAttributes, integer bManualReset, integer bInitialState, string lpName

                   DECLARE integer CloseHandle IN WIN32API integer 

                   DECLARE integer WaitForSingleObject IN WIN32API integer hHandle, integer dwMilliseconds

                   DECLARE integer GetLastError IN WIN32API 

                   this.hEvent = CreateEvent(0,0,0,"VFPAbortThreadEvent") && Get the existing event

                   IF this.hEvent = 0

                             THROW "Creating event error:"+TRANSFORM(GetLastError())

                   ENDIF 

                   ?"Start Crawl"

                   DECLARE integer GetWindowText IN WIN32API integer, string @, integer

                   DECLARE integer Sleep IN WIN32API integer

                   this.oWeb=CREATEOBJECT("InternetExplorer.Application")

                   this.oWeb.visible=1

                   this.oweb.top=0

                   this.oweb.left=0

                   this.oweb.width=500

                   this.oWSH=CREATEOBJECT("Wscript.Shell")

                   USE blogs ORDER 1

                   REPLACE link WITH cBlogUrl, followed WITH 0       && set flag to indicate this page needs to be retrieved and crawled

                   this.fStopCrawl=.f.

                   fDone = .f.

                   DO WHILE !fDone AND NOT this.fStopCrawl

                             fDone=.t.

                             GO TOP 

                             SCAN WHILE NOT this.fStopCrawl

                                      nRec=RECNO()

                                      IF followed = 0

                                                REPLACE followed WITH 1

                                                this.BlogCrawl(ALLTRIM(link))

                                                IF this.fStopCrawl

                                                          GO nRec

                                                          REPLACE followed WITH 0    && restore flag

                                                ENDIF 

                                                fDone = .f.

                                      ENDIF 

                             ENDSCAN

                   ENDDO 

                   ?"Done Crawl",SECONDS()-nStart

          PROCEDURE BlogCrawl(cUrl)

                   LOCAL fGotUrl,cTitle

                   fGotUrl = .f.

                   DO WHILE !fGotUrl    && loop until we've got the target url in IE with no Error

                             this.oweb.navigate2(cUrl)

                             DO WHILE this.oweb.ReadyState!=4

                                      ?"Loading "+cUrl

                                      Sleep(1000)   && yield processor

                                      IF this.IsThreadAborted()

                                                this.fStopCrawl=.t.

                                                ?"Aborting Crawl"

                                                RETURN 

                                      ENDIF 

                             ENDDO 

                             cTitle=SPACE(250)

                             nLen=GetWindowText(this.oWeb.HWND,@cTitle,LEN(cTitle))

                             cTitle=LEFT(cTitle,nLen)

                             IF EMPTY(cTitle) OR UPPER(ALLTRIM(cTitle))="ERROR" OR ("http"$LOWER(cTitle) AND "400"$cTitle) 

                                      ?"Error retrieving ",cUrl," Retrying"

                             ELSE

                                      fGotUrl = .t.

                             ENDIF 

                   ENDDO 

                   this.cCurrentLink=cUrl

                   IF OCCURS("/",cUrl)=8          &&http://blogs.msdn.com/calvin_hsia/archive/2005/08/09/449347.aspx

                             cMht=this.SaveAsMHT(cTitle) && save the page before we parse

                             IF this.fStopCrawl

                                      RETURN .f.

                             ENDIF 

                             REPLACE title WITH STRTRAN(STRTRAN(cTitle," - Microsoft Internet Explorer",""),"Calvin Hsia's WebLog : ",""),;

                                       mht WITH cMht,Stored WITH DATETIME()

                             IF EMPTY(title)         && for some reason, the page wasn't retrieved

                                      REPLACE followed WITH 0

                             ENDIF 

                   ENDIF 

                   ?"Parsing HTML"

                   this.ProcessNodes(this.oWeb.Document,0) && Recur through html nodes to find links

                   ?"Done Parsing HTML"

          PROCEDURE ProcessNodes(oNode,nLev)    && recursive routine to look through HTML

                   LOCAL i,j,dt,cClass,oC,cLink

                   IF this.IsThreadAborted() OR nLev > 30     && limit recursion levels

                             RETURN

                   ENDIF 

                   WITH oNode

                             DO CASE 

                             CASE LOWER(.NodeName)="div"    && look for pub date

                                      IF OCCURS("/",this.cCurrentLink)=8 && # of backslashes in blog leaf entry

                                                oC=.Attributes.GetnamedItem("class")

                                                IF !ISNULL(oC) AND !EMPTY(oC.Value)

                                                          cClass=oC.Value

                                                          IF cClass="postfoot" OR cClass = "posthead"

                                                                   cText=ALLTRIM(STRTRAN(.innerText,"Published",""))

                                                                   IF !EMPTY(cText)

                                                                             dt=this.ToDateTime(cText)

                                                                             IF SEEK(this.cCurrentLink,"blogs")

                                                                                      REPLACE pubdate WITH dt

                                                                             ELSE

                                                                                      ASSERT .f.

                                                                             ENDIF 

                                                                   ENDIF 

                                                          ENDIF 

                                                ENDIF 

                                      ENDIF 

                             CASE .nodeName="A"

                                      cLink=LOWER(STRTRAN(.Attributes("href").value,"%5f","_"))

                                      IF ATC("http://blogs.msdn.com/calvin_hsia/",cLink)>0

                                                IF ATC("#",cLink)=0 AND ATC("archive/2",cLink)>0

                                                          *http://blogs.msdn.com/calvin_hsia/archive/2004/10/11/<a%20rel=

 

                                                          IF "<"$cLink   && comment spam prevention: 

*http://blogs.msdn.com/calvin_hsia/archive/2004/10/11/240992.aspx

*<a rel="nofollow" target="_new" href="<a rel="nofollow" target="_new" href="http://www.53dy.com">http://www.53dy.com</a>                                                        

                                                          ELSE 

                                                                    *http://blogs.msdn.com/calvin_hsia/archive/2004/11/16/visual%20foxpro

                                                                   IF "%"$cLink

                                                                    *http://blogs.msdn.com/calvin_hsia/archive/2004/11/16/258422.aspx

                                                                   * broken link: host updated software for category links

                                                                   *<A title="Visual Foxpro" href="http://blogs.msdn.com/calvin_hsia/archive/2004/11/16/Visual%20Foxpro">Visual Foxpro</A>

*                                                                           SET STEP ON 

                                                                   ELSE 

                                                                             IF !SEEK(cLink,"Blogs")

                                                                                      INSERT INTO Blogs (link) VALUES (cLink)

                                                                             ENDIF 

                                                                   ENDIF 

                                                          ENDIF 

                                                ENDIF 

                                      ENDIF 

                             ENDCASE 

                             FOR i = 0 TO .childNodes.length-1

                                      this.ProcessNodes(.childNodes(i),nLev+1)

                             ENDFOR 

                   ENDWITH 

                   PROCEDURE ToDateTime(cText as String) as Datetime

                             *Friday, April 01, 2005 11:30 AM by Calvin_Hsia 

                             LOCAL dt as Datetime

                             ASSERT GETWORDNUM(cText,6)$"AM PM"

                             nHr = INT(VAL(GETWORDNUM(cText,5)))

                             IF GETWORDNUM(cText,6)="PM" AND nhr < 12

                                      nHr=nHr+12

                             ENDIF 

                             dt=CTOT(GETWORDNUM(ctext,4) + "/" +; && Year

                                      TRANSFORM(INT(1+(AT(GETWORDNUM(cText,2),this.cMonths)-1)/10)) + "/" +;          && month

                                      TRANSFORM(VAL(GETWORDNUM(cText,3)))  + "T" +;     && day of month

                                      TRANSFORM(nHr)+":"+;               && hour

                                      TRANSFORM(VAL(SUBSTR(GETWORDNUM(cText,5),4))))  && minute

                             ASSERT !EMPTY(dt)

                   RETURN dt

          PROCEDURE SaveAsMHT(cTitle as String) as String

                   fRetry = .t.

                   DO WHILE fRetry

                             fRetry = .f.

                             WITH this.oWSH

                                      .AppActivate(cTitle)   && bring IE to the foreground

                                      TEMPFILEMHT= "c:\t.mht"    && temp file can be constant

                                      ERASE (TEMPFILEMHT)

                                      .SendKeys("%fa"+TEMPFILEMHT+"{tab}w%s")    && Alt-F (File Menu) S (Save As) type Web Archive  Alt-S

                                      nTries=5

                                      DO WHILE !FILE(TEMPFILEMHT)      && wait til IE saves the file

                                                Sleep(5000)

                                                nTries=nTries-1

                                                IF nTries=0

                                                          fRetry=.t.

                                                          EXIT 

                                                ENDIF 

                                                IF this.IsThreadAborted()

                                                          this.fStopCrawl=.t.

                                                          ?"Aborting crawl"

                                                          RETURN ""

                                                ENDIF 

                                      ENDDO 

                                      sleep(100)

                             ENDWITH 

                   ENDDO 

                   RETURN FILETOSTR(TEMPFILEMHT)

          RETURN

          PROCEDURE IsThreadAborted as Boolean

                   IF WaitForSingleObject(this.hEvent,0) = WAIT_TIMEOUT

                             RETURN .f.

                   ENDIF 

                   RETURN .t.

          PROCEDURE destroy

                   this.oWeb.visible=.f.

                   this.oWeb=0

                   CloseHandle(this.hEvent)

ENDDEFINE

**************************************************

**************************************************

ENDTEXT

          STRTOFILE(cstrVFPCode,"MyThreadFunc.prg")

          COMPILE MyThreadFunc.prg

*SELECT PADR(TRANSFORM(YEAR(pubdate)),4)+"/"+PADL(MONTH(pubdate),2,"0") as mon,COUNT(*) FROM blogs WHERE !EMPTY(mht) GROUP BY mon ORDER BY mon DESC INTO CURSOR result

 

RETURN

