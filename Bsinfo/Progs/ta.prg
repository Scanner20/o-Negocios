* -----------------------------------------------------------------------------------------*
* Programa : Ta
* Autor    : Victor E. Torres Tejada 
* Creaci�n : 15-12-2000
* Modificacion : 11-05-2017  
* 
* -----------------------------------------------------------------------------------------*
_SCREEN.VISIBLE = .F.

*!*	Poner aqui el directorio en el que esta el Config.INI
IF !EMPTY(VERSION(2))
	IF INLIST(SYS(5),'F','E','C')
		CD SYS(5)+'\aplvfp\bsinfo\proys\'
		SET DEFA TO \AplVfp\bsinfo
*!*			CD SYS(5)+'\dev\aplvfp\bsinfo\proys\'
*!*			SET DEFA TO \dev\AplVfp\bsinfo
	ELSE
		CD SYS(5)+'\aplvfp\bsinfo\proys\'
		SET DEFA TO \AplVfp\bsinfo
	ENDIF

ENDIF

*!*	Activar los Paths para sus formularios personales.... (xUsuario)  && .\Data ,;
*!*	         	D:\o-negocios\IDC , ;
*!*	            D:\o-negocios\IDC\Data , ;

SET PATH TO .\Forms , ; 
            .\Progs , ;
            .\Reports , ;
            .\Menus , ;
            .\vcxs , ;
            .\Data ,;
			..\classgen\vcxs , ;
			..\classgen\Forms ,;
			..\classgen\Reports ,;
			..\classgen\PROGS ,;
			..\GrafGen\Iconos ,;
			..\DLLS,;
			..\LIBV\TASK_SERVER
			
SET DEVELOPMENT OFF
SET SYSMENU TO

SET SECONDS OFF
SET HOURS TO 12
SET DECI  TO 6 
SET MULTILOCKS ON
SET DELETED ON 
*!*	SET UDFPARMS TO REFERENCE

#include const.h 	



**---------------------------**
** ACTUALIZACION DEL SISTEMA ** 
**---------------------------**
LsPathOrig = SYS(5)+SYS(2003)
LsPathUpd  = LsPathOrig +'\UPDATE\' 
IF FILE(LsPathUPD+'UPD_SYSTEM.FXP')
	DO 	LsPathUPD+'UPD_SYSTEM.FXP' WITH '001'  && Compa�ia uno por defecto
ENDIF





SET CLASSLIB TO ADMNOVIS , ADMTBAR , ADMVRS , ADMGRAL ,DOSVR, o-N, registry, o-NLib,GridExtras

_SCREEN.WINDOWSTATE	= 2

CLOSE DATABASES ALL

SET PROCEDURE TO JANESOFT,FXGEN_2
					
SET LIBRARY TO VFPEncryption71.FLL
DO def_v_publicas
DO def_color

*!*	SET PROCEDURE TO ALMPLIBF ADDITIVE
PUBLIC goEntorno , goConexion , GoCfgAlm , GoCfgCpi , GoSvrCbd,GoCfgVta , GoEntPub
*!*	Public _Mes, _Ano
*!*	_Mes = Month(Date())
*!*	_Ano = Year(Date())

goConexion	= CREATEOBJECT('cnxgen_ODBC')
IF  GoConexion.cBackEnd ='VFPDBC'
	** No se establece conexion mediante ODBC
ELSE
	IF !goConexion.Conectar()
		=MESSAGEBOX("� No se pudo establecer la conexi�n con el servidor!",64,"Error de conexi�n")
		RELEASE goConexion , goEntorno
		RETURN
	ENDIF
ENDIF	
Public GsCodCia,GsNomCia,GsSigCia,GsDirCia,GsTlfCia,GsRptCia,GsRucCia,GsSistema
GsCodCia = '001'
goEntorno	= CREATEOBJECT("Entorno")
goEntPub	= CREATEOBJECT("Env")
goCfgCpi	= CREATEOBJECT("DOSVR.Cpiplibf")
goSvrCbd    = CREATEOBJECT("DOSVR.Contabilidad") 	&& Servicios para contabilidad

*************************************************
** Publicas de todo el sistema y para cada modulo
*************************************************

PUBLIC GdFecha,GsFecha,GsUsuario,GsPathCia
**************************
** Publicas de almacen
**************************
Public GsCodSed,GsNomSed,GsSubAlm,GsNomSub,GaLenCod,GaClfDiv,GlCorrU_I,GlContra,GsClfDiv,GnLenDiv 
PUBLIC GaNomDiv
***************************
** Publicas de Contabilidad
***************************
goSvrCbd.SetVarPublic()
goEntPub.SetPath()

goCfgAlm	= CREATEOBJECT("DOSVR.oNegocios")
goCfgVTa    = CREATEOBJECT("DOSVR.oNegocios")

PUBLIC xAcceso
xAcceso = .f.
*!*	Mostrar el Login de Ingreso al Sistema

DO FORM Gen4_Login WITH "FUN","ALM"   &&&& VETT ???
READ EVENTS

LOCAL loUtil


IF goEntorno.SqlEntorno
	IF NOT (VARTYPE(goEntorno)=="O" AND goEntorno.Conexion.Conectado)
		IF EMPTY(VERSION(2))	&& RunTime
			QUIT
		ELSE
			SET SYSMENU TO DEFA		
			_SCREEN.VISIBLE = .T.
			RETURN
		ENDIF
	ENDIF
ELSE
	IF NOT (VARTYPE(goEntorno)=="O"  AND goEntorno.Conexion_DB_VFP )
		IF EMPTY(VERSION(2))	&& RunTime
			QUIT
		ELSE
			SET SYSMENU TO DEFA
			_SCREEN.VISIBLE = .T.
			RETURN
		ENDIF
	ENDIF
ENDIF

goEntorno.Sistema	= "FUN"   &&& VETT ???
goEntorno.Modulo	= ""      &&& VETT ???

loUtil	= CREATEOBJECT('Util')

_SCREEN.CAPTION	= goEntorno.DescripcionSistema

IF VARTYPE(Gen4_Bienvenida)='O'
Gen4_Bienvenida.lblMsg.CAPTION	= 'Configurando el Entorno del Sistema'
ENDIF
*!*	Crear la barra de herramienta del m�dulo

PUBLIC goToolBarFun , goStatusBar
*!*	goToolBarFun= NEWOBJECT('Com_ToolBar')
*!*	goToolBarFun.DOCK(2)
*!*	goToolBarFun.SHOW()
*!*	goToolBarFun.ENABLED	= .F.


IF VARTYPE(Gen4_Bienvenida)='O'
Gen4_Bienvenida.lblMsg.CAPTION	= 'Configurando el men� principal'
ENDIF

_SCREEN.VISIBLE	= .T.
*!*	_SCREEN.ADDOBJECT('PAPEL_TAPIZ','FUN_MAINMENU')
*!*	_SCREEN.PAPEL_TAPIZ.VISIBLE	= .T.

_screen.Width  =SYSMETRIC(1)
_screen.Height =SYSMETRIC(2)

_screen.Top = 50
_screen.Left= 0
_screen.AutoCenter = .f.
_screen.Closable= .t.
*!*	_SCREEN.PICTURE='K:\APLVFP\GRAFGEN\FONDOS\O-NEG01.JPG'
_SCREEN.BACKCOLOR=RGB(106,155,227)	&& Celeste de Microsoft
_SCREEN.BACKCOLOR = 14916458		&& Idem


*!*	Configurar la barra de estado del sistema
goStatusBar	= CREATEOBJECT("StatusBar")

goStatusBar.MOVABLE	= .F.
goStatusBar.Usuario	= goEntorno.USER.Login
goStatusBar.Fecha	= loUtil.Formato_Fecha(DATE(),.T.)
goStatusBar.Servidor= '\\'+goEntorno.Servidor+'\'+goEntorno.BaseDatos
goStatusBar.DOCK(3)
goStatusBar.SHOW()

IF VARTYPE(Gen4_Bienvenida)='O'
Gen4_Bienvenida.lblMsg.CAPTION	= 'Obteniendo el perfil de usuario'
ENDIF



*!*	goToolBarFun.ENABLED	=	.T.

ON SHUTDOWN CLEAR EVENTS
IF VARTYPE(Gen4_Bienvenida)='O'
Gen4_Bienvenida.RELEASE()
ENDIF 
RELEASE  Gen4_Bienvenida

** goEntorno.GenerarPerfilUsuario() && Revisar cuando es con Base de Datos VFP  VETT 27-01-2001 

*!*	ON KEY LABEL F1 goToolBarCom.cmdHelp.CLICK()
DO Config_almacen
DO FORM funfun_compa�ias
DO FORM ADM_Principal
*!*	DO FUN.MPR
*!*	READ EVENTS

ON SHUTDOWN
WAIT WINDOW 'Saliendo del Sistema...' TIMEOUT 0.5


CLOSE DATABASES ALL
IF goEntorno.SqlEntorno
	goConexion.Desconectar()

	=SQLDisconnect(0)
ELSE

ENDIF

RELEASE goEntorno , goConexion , goToolBarCom , goStatusBar, goCfgAlm, goCfgCpi

SET SYSMENU TO DEFAULT
_SCREEN.PICTURE	= ''
*!*	_SCREEN.REMOVEOBJECT('PAPEL_TAPIZ')
_SCREEN.CAPTION	= ALLTRIM(LEFT(VERSION(1),AT(' ',VERSION(1),2)))

IF EMPTY(VERSION(2))	&& RunTime
	QUIT
ELSE
	set sysmenu to defa	
ENDIF
WAIT CLEAR
CLEAR ALL
RETURN



*!*	-----------------------------------------------------------
*!*	Procedimiento para salir del Sistema Comercial
*!*	-----------------------------------------------------------
PROCEDURE Salir_Com
*!*		_SCREEN.REMOVEOBJECT('PAPEL_TAPIZ')
	CLEAR EVENTS
	CLOSE DATABASES ALL
	goConexion.Desconectar()
	=SQLDisconnect(0)

	RELEASE goEntorno , goConexion , goToolBarCom , goStatusBar
	SET SYSMENU TO DEFAULT
	_screen.AutoCenter = .F.
	_screen.Closable= .t.
	_SCREEN.PICTURE	= ''
	_SCREEN.CAPTION	= ALLTRIM(LEFT(VERSION(1),AT(' ',VERSION(1),2)))
	IF EMPTY(VERSION(2))	&& RunTime
		QUIT
	ENDIF
ENDPROC
*!*	-----------------------------------------------------------



*!*	-----------------------------------------------------------
*!*	Permite Inhabilitar una opcion del men� segun el formulario
*!*	-----------------------------------------------------------
FUNCTION SkipFrm
	LPARAMETER tcForm
	RETURN .F.
*!*		LOCAL laDerechos
*!*		tcForm	=  ALLTRIM(UPPER(tcForm))

*!*		SELECT NombreFormulario ;
*!*			FROM (goEntorno.Perfil_Local) ;
*!*			WHERE ;
*!*			ALLTRIM(UPPER(NombreFormulario)) == tcForm ;
*!*			INTO ARRAY aDerechos

*!*		RETURN EMPTY(_TALLY)
ENDFUNC
*!*	-----------------------------------------------------------


*!*	-----------------------------------------------------------
*!*	M�dulo del Menu Principal del Sistema Comercial
*!*	-----------------------------------------------------------
PROCEDURE Exec_Option
	LPARAMETER lnOpcion
*!*		ON SHUTDOWN DO Exit_Option IN Fun
*!*		DO CASE
*!*			CASE lnOpcion == 1	&& ALMACEN
*!*				CLOSE DATABASES ALL
*!*				goEntorno.Modulo	= "ALM"
*!*				_SCREEN.PAPEL_TAPIZ.VISIBLE	= .F.
*!*				_SCREEN.CAPTION	= 'Sistema Fundo - [M�dulo Almacenes]'
*!*				DO FUNALM.MPR
*!*			CASE lnOpcion == 2	&& PRODUCCION
*!*				CLOSE DATABASES ALL
*!*				goEntorno.Modulo	= "CPI"
*!*				_SCREEN.PAPEL_TAPIZ.VISIBLE	= .F.
*!*				_SCREEN.CAPTION	= 'Sistema Fundo - [M�dulo Control Produccion]'
*!*				DO FUNPRO.MPR
*!*				goToolBarFun.cmdRip.VISIBLE	= .T.
*!*			CASE lnOpcion == 3	&& VENTAS 
*!*				CLOSE DATABASES ALL
*!*				goEntorno.Modulo	= "VTA"
*!*				_SCREEN.PAPEL_TAPIZ.VISIBLE	= .F.
*!*				_SCREEN.CAPTION	= 'Sistema Fundo - [M�dulo de Ventas]'
*!*				DO FUNVTA.MPR
*!*		ENDCASE
ENDPROC


*!*	-----------------------------------------------------------
*!*	Salir de los M�dulos del Sistema Comercial
*!*	-----------------------------------------------------------
PROCEDURE Exit_Option
	CLOSE DATABASES ALL
	ON SHUTDOWN CLEAR EVENTS
*!*		_SCREEN.PAPEL_TAPIZ.VISIBLE	= .T.
*!*		_SCREEN.CAPTION	= 'Sistema Comercial'
*!*		goEntorno.Modulo	= ""
*!*		DO COM.MPR
*!*		goToolBarCom.cmdRip.VISIBLE	= .F.
ENDPROC

***  Chequear en alm_s_vb.prg 
************************
PROCEDURE Config_almacen
************************
Public GsCodCia,GsNomCia,GsSigCia,GsDirCia,GsTlfCia,GsRptCia,GsRucCia,GsFaxCia
Public GsCodSed,GsNomSed,GsSubAlm,GsNomSub,GaLenCod,GaClfDiv,GsClfAtr,GnLenAtr
Public GsAnoMes,GsPeriodo,GsNroMes,GsClfDiv,GnLenDiv,GdFecha,GsFecha
*
Public XsNroMes,GlCorrU_I,GlContra
*


GsCodCia	='001'
GsNomcia	='NO definida'
GsDirCia	='NO definida'
GsCodSed	='001'
GsNomSed	= 'NO definida'
GsSubAlm	='010'
GsNomSub	='NO definida'
GlCorrU_I   = .F.
GlContra  	= .F.
**K_ESC = 27
GdFecha = DATETIME()
GsFecha = LTRIM(STR(DAY(GdFecha)))+"-"+MES(GdFecha,3)+;
             "-"+STR(YEAR(GdFecha),4)

GsPeriodo = LEFT(GoEntorno.GsPeriodo,4)
*
XsNroMes = TRAN(_MES,"@L 99")
*
GsUsuario = GoEntorno.User.Login

OPEN DATABASE admin
SELECT 0
USE empresas
LOCATE
IF !EOF()
	GsCodCia = CodCia
	GsNomCia = NomCia
	GsDirCia = DirCia
	GsSigCia = SigCia
	GsRucCia = RucCia 
	GsTlfCia = TlfCia
	GsFaxCia = FaxCia
	GoEntorno.GsCodCia = GsCodCia
ENDIF
USE

LOCAL LsDbCia AS String

LsDBCia = 'CIA'+GSCodCia
OPEN DATABASE (LsDBCia)


GoEntorno.GsPeriodo=GOSVRCBD.CAP_aaaamm()
GsPeriodo = LEFT(GoEntorno.GsPeriodo,4)
GsAnoMes  = GoEntorno.GsPeriodo

LsDbPeriodo= 'P'+GsCodCia+GsPeriodo
OPEN DATABASE (LsDbPeriodo)
SET DATABASE TO (LsDBCia)
GoCfgAlm.CargaSedes
GsCOdSed = GoCfgAlm.mSedes(1,1)
GsNomSed = GoCfgAlm.mSedes(1,2)

*
**open database fundosc
*goEntorno.GenerarPerfilUsuario()
*goEntorno.GenerarTablasLocales()

** VETT 2006/04/09 **
GoEntpub.GsCodCia	= GsCodCia
GoEntPub.TsPathCia = goentpub.Pathdatacia(GsCodCia)

do define_division_Familia
return 
** OJO : Este codigo debe pasar a ser un metodo para ser utilizado como los metodos de la clase
** Entorno 
*********************************
PROCEDURE Define_Division_Familia		
*********************************
*+----------------------------------------------------------------------------+
*�  GaLenCod :    Longitud de las divisiones del codigo del material.         �
*+----------------------------------------------------------------------------+
DIMENSION GaLenCod(1),GaClfDiv(1),GaNomDiv(1)
STORE 0 TO GaLenCod,GnLenAtr
STORE [] TO GaClfDiv,GsClfAtr

*!*	SELE 0
*!*	*!*	IF !FILE('ALMTGSIS.CDX')
*!*	*!*	   USE ALMTGSIS ALIAS TABL EXCLU
*!*	*!*	   IF !USED()
*!*	*!*	      =MESSAGEBOX([Error en apertura de tabla general del sistema])
*!*	*!*	      CLOSE DATA
*!*	*!*	      RETURN
*!*	*!*	   ENDIF
*!*	*!*	   SET SAFE OFF
*!*	*!*	   INDEX ON TABLA+CODIGO TAG TABL01
*!*	*!*	   INDEX ON TABLA+NOMBRE TAG TABL02
*!*	*!*	   SET ORDER TO TABL01
*!*	*!*	   SET SAFE ON
*!*	*!*	ELSE
*!*		
*!*	   USE ALMTGSIS ORDER TABL01 ALIAS TABL
*!*	   IF !USED()
*!*	      =MESSAGEBOX([Error en apertura de tabla general del sistema])
*!*	      CLOSE DATA
*!*	      RETURN
*!*	   ENDIF
*!*	ENDIF
IF !goentorno.open_dbf1('ABRIR','ALMTGSIS','TABL','TABL01','')
	=MESSAGEBOX('No se tiene acceso a tabla ALMTGSIS',64,'Error de acceso a la base de datos')
	RETURN .f.
ENDIF

SELE TABL
zi = 0
SEEK [CM]
SCAN WHILE Tabla=[CM]
     zi = zi + 1
     IF ALEN(GaLenCod)< zi
        DIMENSION GaLenCod(zi+5)
        DIMENSION GaClfDiv(zi+5)
        DIMENSION GaNomDiv(zi+5)
     ENDIF
     GaLenCod(zi) = Digitos
     GaClfDiv(zi) = LEFT(Codigo,2)
     GaNomDiv(zi) = PADR(Nombre,20)
     IF Defecto
        GsClfDiv  = LEFT(Codigo,2)
        GnLenDiv  = Digitos
     ENDIF
     IF CodIng='ATR'
     	GsClfAtr = LEFT(Codigo,2)
     	GnLenAtr = Digitos
     ENDIF

ENDSCAN
IF zi>0
   DIMENSION GaLenCod(zi)
   DIMENSION GaClfDiv(zi)
ENDIF
*** Fin : GaLenCod

*+----------------------------------------------------------------------------+
*�  GnLenDiv :    Longitud de la division/Familia a utilizar por defecto.     �
*+----------------------------------------------------------------------------+
IF GnLenDiv <= 0
   =MESSAGEBOX([Sub - divisiones de c�digo de material mal definidas.;]+;
             [Corregir en el men� de tablas y maestros en la opci�n,;]+;
             [de tablas generales del sistema.])
ENDIF
USE IN TABL
DIMENSION GaSubAlm(1,2)
STORE [] TO  GaSubAlm
SELE 0
IF ! FILE(goentPub.TSpathcia+'almtalma.cdx')
   USE almtalma  ALIAS ALMA EXCLU
   IF !USED()
       DO f1MsgErr WITH [Tabla de almacenes no esta disponible]
       RETURN
   ENDIF
   INDEX ON SubAlm TAG ALMA01
ELSE
   USE almtalma  ALIAS ALMA
   IF !USED()
       DO f1MsgErr WITH [Tabla de almacenes no esta disponible]
       RETURN
   ENDIF
ENDIF
SET ORDER TO ALMA01
zi = 0
SCAN
    zi = zi + 1
    IF ALEN(GaSubAlm,1)< zi
       DIMENSION GaSubAlm(zi+5,2)
    ENDIF
    GaSubAlm(zi,1)=SubAlm
    GaSubAlm(zi,2)=DesSub
ENDSCAN
IF zi<=0
       DO f1MsgErr WITH [No estan configurados los almacenes]
       return
ENDIF
GsSubAlm = GaSubALm(1,1)
GsNomSub = GaSubAlm(1,2)
DIMENSION GaSubAlm(zi,2)
IF USED('ALMA')
	USE IN ALMA
ENDIF
return .t.
*** Fin : GnLenDiv

