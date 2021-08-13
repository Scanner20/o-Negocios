*!*	_screen.icon=".\ICONS\WRENCH.ICO"
*!*	**_screen.picture= ".\BMPS\MAIN3A_V.bmp"
*!*	IF VERSION(5)>700
*!*		_SCREEN.BACKCOLOR = RGB(198,194,254)
*!*		_sCREEN.ForeColor = RGB(0,0,0)
*!*	ELSE
*!*		_SCREEN.BACKCOLOR=RGB(106,155,227)	&& Celeste de Microsoft
*!*		_SCREEN.BACKCOLOR=RGB(140,177,234)	&& Logo Uni
*!*		_SCREEN.BACKCOLOR=RGB(130,170,232)	&& Logo Uni
*!*	ENDIF

** VETT: Parche necesario, hasta ahora no descubro por que no reconoce las unidades de red previamente 
** configuradas antes de entrar a VFP 2021/05/14 07:59:01 ** 
DO CASE
	CASE INLIST(SYS(0),"SERVIDOR3-IDC-O") 
		Run /N NET USE K: "\\servidor3-idc-o-negocios\dev"
		Run /N NET USE O: "\\servidor3-idc-o-negocios\o-n"
		Run /N NET USE P: "\\servidor3-idc-o-negocios\o-n2"
ENDCASE
** VETT:Fin del parche 2021/05/14 07:59:01 ** 

DO CASE 
	CASE JUSTSTEM(SYS(2023))=='TEMP2'
		_screen.Icon= SYS(5)+'\APLVFP\GRAFGEN\ICONOS\MOTIF\ALIEN Motif.ico'
		IF VERSION(5)>700
*!*				_SCREEN.BACKCOLOR=RGB(130,170,232)	

			_SCREEN.BACKCOLOR=  RGB(0,0,0)	 && RGB(192,192,192)  &&
			_sCREEN.ForeColor = RGB(255,128,0)  && RGB(0,255,0) 
		ELSE
			_SCREEN.BACKCOLOR=RGB(106,155,227)	&& Celeste de Microsoft
			_SCREEN.BACKCOLOR=RGB(140,177,234)	&& Logo Uni
			_SCREEN.BACKCOLOR=RGB(130,170,232)	&& Logo Uni
		ENDIF
	CASE JUSTSTEM(SYS(2023))=='TEMP'
	      _screen.Icon= SYS(5)+'\APLVFP\GRAFGEN\ICONOS\MOTIF\DATA.ICO'
		IF VERSION(5)>700
			_SCREEN.BACKCOLOR = RGB(198,194,254)
			_sCREEN.ForeColor = RGB(0,0,0)
		ELSE
			_SCREEN.BACKCOLOR=RGB(106,155,227)	&& Celeste de Microsoft
			_SCREEN.BACKCOLOR=RGB(140,177,234)	&& Logo Uni
			_SCREEN.BACKCOLOR=RGB(130,170,232)	&& Logo Uni
		ENDIF
ENDCASE
*!*	_SCREEN.BACKCOLOR = 14916458		&& Idem
*!*	_SCREEN.BACKCOLOR = 15499400
*_VFP.Top = 30

*!*	_SCREEN.ADDOBJECT("MyPic", "Image")
*_SCREEN.MyPic.PICTURE ='K:\APLVFP\GRAFGEN\JPEG\DRAGONBALL\GTRARE5.JPG'
*_SCREEN.MyPic.PICTURE ='K:\APLVFP\GRAFGEN\JPEG\DRAGONBALL\cardgt1b.JPG'

*_SCREEN.MyPic.PICTURE='C:\MIS DOCUMENTOS\MIS IMÁGENES\MCP-RGB[1].JPG'
*_SCREEN.MyPic.PICTURE='C:\MIS DOCUMENTOS\MIS IMÁGENES\MCP-BW[1].JPG'
*_SCREEN.MyPic.PICTURE ='K:\APLVFP\GRAFGEN\FONDOS\DEV2.JPG'

*!*	LsGrapfile=LOCFILE('.\grafgen\jpeg\Jane\Janepiscina2005.jpg')
*!*	LsGrapfile=LOCFILE('.\grafgen\jpeg\Jane\Janeparque2005.jpg')
*!*	LsGrapfile=LOCFILE('.\grafgen\jpeg\Jane\Jane_Set2006_1_4.JPG')
LsGrapfile=LOCFILE('.\grafgen\jpeg\Jane\Jane_Joan_3.JPG')
_SCREEN.ADDOBJECT("MyPic", "Image")
_SCREEN.MyPic.PICTURE =LsGrapfile
_SCREEN.MyPic.TOP = 0
_SCREEN.MyPic.LEFT = _vfp.width - _screen.mypic.width - 100
_SCREEN.MyPIC.Stretch = 0
_SCREEN.MyPic.VISIBLE = .F.
_Vfp.Caption = _vfp.Caption + ' - '+SYS(0)
*!* Setup Advanced Object Oriented
DEFINE BAR 10 OF _MSYSTEM KEY ALT+F1 PROMPT "Advanced Object Oriented"
ON SELECTION BAR 10 OF _MSYSTEM RUN /N3 hh.EXE k:\aplvfp\ayudas\o.CHM
SET CLOCK TO 0,136
SET HOURS TO 24

DEFINE BAR 30 OF _MSM_TOOLS PROMPT "\-"
DEFINE BAR 31 OF _MSM_TOOLS PROMPT "GKK Program Editor" KEY CTRL+E, "CTRL+E"
ON SELECTION BAR 31 OF _MSM_TOOLS DO "C:\Program Files\Microsoft Visual FoxPro 9\GKKTools\GKKEditPRG.app"
DEFINE BAR 32 OF _MSM_TOOLS PROMPT "GKK Screen Editor" KEY CTRL+S, "CTRL+S"
ON SELECTION BAR 32 OF _MSM_TOOLS DO "C:\Program Files\Microsoft Visual FoxPro 9\GKKTools\GKKEditScx.app"
DEFINE BAR 33 OF _MSM_TOOLS PROMPT "GKK Compare" KEY CTRL+K, "CTRL+K"
ON SELECTION BAR 33 OF _MSM_TOOLS DO "C:\Program Files\Microsoft Visual FoxPro 9\GKKTools\GKKCompare.app"

*!*	DEFINE WINDOW desktop2 FROM 1,20 TO 25,60  TITLE 'Output' FLOAT GROW CLOSE MINIMIZE FILL FILE LOCFILE('.\grafgen\jpeg\Jane\Jane20060401005.jpg')
*!*	ACTIVATE WINDOW desktop2

*------------------------------------------------------------------------
* A CDir object remembers the current directory on creation, and restores
* to that when it goes out of scope. It also provides methods to change
* to the special folders with intellisense support.
*------------------------------------------------------------------------
PUBLIC oDir
oDir = createobject('cdir')


define class CDir as custom
   hidden sDir
   hidden oShell
   sDir= ""
   oShell= .null.
   function init
      this.sDir= sys(5)+sys(2003)
      this.oShell= createobject('WScript.Shell')
   function destroy
      cd (this.sDir)
      this.oShell= .null.
   function cd(tcDir)
      cd (tcDir)
   hidden function cdspecial()
      cd (this.oShell.SpecialFolders(getwordnum(program(program(-1)-1),2,[.])))
   function AllUsersDesktop
      this.cdspecial()
   function AllUsersPrograms
      this.cdspecial()
   function AllUsersStartMenu
      this.cdspecial()
   function AllUsersStartup
      this.cdspecial()
   function Favorites
      this.cdspecial()
   function Fonts
      this.cdspecial()
   function MyDocuments
      this.cdspecial()
   function NetHood
      this.cdspecial()
   function PrintHood
      this.cdspecial()
   function Programs
      this.cdspecial()
   function PrintHood
      this.cdspecial()
   function Recent
      this.cdspecial()
   function SendTo
      this.cdspecial()
   function StartMenu
      this.cdspecial()
   function Startup
      this.cdspecial()
   function Templates
      this.cdspecial()
enddef

