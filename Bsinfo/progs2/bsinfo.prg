* -----------------------------------------------------------------------------------------*
* Programa : Ingreso al sistema	
* Autor    : Jenny Anicama
* Creación : 15-12-2000
* Modificacion :  
* 
* -----------------------------------------------------------------------------------------*
_SCREEN.VISIBLE = .F.
SET DEVELOPMENT OFF 

*!*	Poner aqui el directorio en el que esta el Config.INI
IF !EMPTY(VERSION(2))
	SET DEFA TO \AplVfp\bsinfo
ENDIF
*!*	Activar los Paths para sus formularios personales.... (xUsuario)
SET PATH TO .\Forms , ; 
            .\Progs , ;
            .\Reports , ;
            .\Menus , ;
            .\vcxs , ;
            .\Data , ;
			..\classgen\vcxs , ;
			..\classgen\Forms ,;
			..\classgen\Reports ,;
			..\classgen\PROGS

SET SYSMENU TO

SET SECONDS OFF
SET HOURS TO 12
SET DECI  TO 6 
#include const.h 	


SET CLASSLIB TO ADMNOVIS , ADMTBAR , ADMVRS , ADMGRAL ,DOSVR

_SCREEN.WINDOWSTATE	= 2

CLOSE DATABASES ALL

SET PROCEDURE TO JANESOFT
*!*	SET PROCEDURE TO ALMPLIBF ADDITIVE
PUBLIC goEntorno , goConexion , GoCfgAlm , GoCfgCpi , GoSvrCbd,GoCfgVta

goConexion	= CREATEOBJECT('cnxgen_ODBC')

*!*		IF !goConexion.Conectar()
*!*			=MESSAGEBOX("¡ No se pudo establecer la conexión con el servidor!",64,"Error de conexión")
*!*			RELEASE goConexion , goEntorno
*!*			RETURN
*!*		ENDIF
 
goEntorno	= CREATEOBJECT("Entorno")
goCfgAlm	= CREATEOBJECT("DOSVR.oNegocios")
*!*	goCfgCpi	= CREATEOBJECT("DOSVR.Cpiplibf")
goSvrCbd    = CREATEOBJECT("DOSVR.Contabilidad") 	&& Servicios para contabilidad
goCfgVTa    = CREATEOBJECT("DOSVR.oNegocios")
*************************************************
** Publicas de todo el sistema y para cada modulo
*************************************************
Public GsCodCia,GsNomCia,GsSigCia,GsDirCia,GsTlfCia,GsRptCia,GsRucCia
PUBLIC GdFecha,GsFecha,GsUsuario,GsPathCia
**************************
** Publicas de almacen
**************************
Public GsCodSed,GsNomSed,GsSubAlm,GsNomSub,GaLenCod,GaClfDiv,GlCorrU_I,GlContra,GsClfDiv,GnLenDiv 
***************************
** Publicas de Contabilidad
***************************
goSvrCbd.SetVarPublic()



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

Gen4_Bienvenida.lblMsg.CAPTION	= 'Configurando el Entorno del Sistema'

*!*	Crear la barra de herramienta del m¢dulo

PUBLIC goToolBarFun , goStatusBar
*!*	goToolBarFun= NEWOBJECT('Com_ToolBar')
*!*	goToolBarFun.DOCK(2)
*!*	goToolBarFun.SHOW()
*!*	goToolBarFun.ENABLED	= .F.



Gen4_Bienvenida.lblMsg.CAPTION	= 'Configurando el menú principal'

_SCREEN.VISIBLE	= .T.
*!*	_SCREEN.ADDOBJECT('PAPEL_TAPIZ','FUN_MAINMENU')
*!*	_SCREEN.PAPEL_TAPIZ.VISIBLE	= .T.

_screen.Width  =SYSMETRIC(1)
_screen.Height =SYSMETRIC(2)

_screen.Top = 50
_screen.Left= 0
_screen.AutoCenter = .f.
_screen.Closable= .t.
_SCREEN.PICTURE='K:\APLVFP\GRAFGEN\FONDOS\O-NEG01.JPG'

*!*	Configurar la barra de estado del sistema
goStatusBar	= CREATEOBJECT("StatusBar")

goStatusBar.MOVABLE	= .F.
goStatusBar.Usuario	= goEntorno.USER.Login
goStatusBar.Fecha	= loUtil.Formato_Fecha(DATE(),.T.)
goStatusBar.Servidor= '\\'+goEntorno.Servidor+'\'+goEntorno.BaseDatos
goStatusBar.DOCK(3)
goStatusBar.SHOW()


Gen4_Bienvenida.lblMsg.CAPTION	= 'Obteniendo el perfil de usuario'



*!*	goToolBarFun.ENABLED	=	.T.

ON SHUTDOWN CLEAR EVENTS
Gen4_Bienvenida.RELEASE()
RELEASE  Gen4_Bienvenida

** goEntorno.GenerarPerfilUsuario() && Revisar cuando es con Base de Datos VFP  VETT 27-01-2001 

*!*	ON KEY LABEL F1 goToolBarCom.cmdHelp.CLICK()
DO Config_almacen
DO FORM FunGen2_Principal
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
*!*	Permite Inhabilitar una opcion del men£ segun el formulario
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
*!*	M¢dulo del Menu Principal del Sistema Comercial
*!*	-----------------------------------------------------------
PROCEDURE Exec_Option
	LPARAMETER lnOpcion
*!*		ON SHUTDOWN DO Exit_Option IN Fun
*!*		DO CASE
*!*			CASE lnOpcion == 1	&& ALMACEN
*!*				CLOSE DATABASES ALL
*!*				goEntorno.Modulo	= "ALM"
*!*				_SCREEN.PAPEL_TAPIZ.VISIBLE	= .F.
*!*				_SCREEN.CAPTION	= 'Sistema Fundo - [Módulo Almacenes]'
*!*				DO FUNALM.MPR
*!*			CASE lnOpcion == 2	&& PRODUCCION
*!*				CLOSE DATABASES ALL
*!*				goEntorno.Modulo	= "CPI"
*!*				_SCREEN.PAPEL_TAPIZ.VISIBLE	= .F.
*!*				_SCREEN.CAPTION	= 'Sistema Fundo - [Módulo Control Produccion]'
*!*				DO FUNPRO.MPR
*!*				goToolBarFun.cmdRip.VISIBLE	= .T.
*!*			CASE lnOpcion == 3	&& VENTAS 
*!*				CLOSE DATABASES ALL
*!*				goEntorno.Modulo	= "VTA"
*!*				_SCREEN.PAPEL_TAPIZ.VISIBLE	= .F.
*!*				_SCREEN.CAPTION	= 'Sistema Fundo - [Módulo de Ventas]'
*!*				DO FUNVTA.MPR
*!*		ENDCASE
ENDPROC


*!*	-----------------------------------------------------------
*!*	Salir de los M¢dulos del Sistema Comercial
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
Public GsCodCia,GsNomCia,GsSigCia,GsDirCia,GsTlfCia,GsRptCia,GsRucCia
Public GsCodSed,GsNomSed,GsSubAlm,GsNomSub,GaLenCod,GaClfDiv
Public GsAnoMes,GsPeriodo,GsNroMes,GsClfDiv,GnLenDiv,GdFecha,GsFecha
*
Public _Mes, _Ano, XsNroMes,GlCorrU_I,GlContra
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
GsFecha = DATETIME()
GsPeriodo = LEFT(GoEntorno.GsPeriodo,4)
*
_Mes = Month(Date())
_Ano = Year(Date())
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


do define_division_Familia
return 
** OJO : Este codigo debe pasar a ser un metodo para ser utilizado como los metodos de la clase
** Entorno 
*********************************
PROCEDURE Define_Division_Familia		
*********************************
*+----------------------------------------------------------------------------+
*Ý  GaLenCod :    Longitud de las divisiones del codigo del material.         Ý
*+----------------------------------------------------------------------------+
DIMENSION GaLenCod(1),GaClfDiv(1)
STORE 0 TO GaLenCod
STORE [] TO GaClfDiv

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
     ENDIF
     GaLenCod(zi) = Digitos
     GaClfDiv(zi) = LEFT(Codigo,2)
     IF Defecto
        GsClfDiv  = LEFT(Codigo,2)
        GnLenDiv  = Digitos
     ENDIF
ENDSCAN
IF zi>0
   DIMENSION GaLenCod(zi)
   DIMENSION GaClfDiv(zi)
ENDIF
*** Fin : GaLenCod

*+----------------------------------------------------------------------------+
*Ý  GnLenDiv :    Longitud de la division/Familia a utilizar por defecto.     Ý
*+----------------------------------------------------------------------------+
IF GnLenDiv <= 0
   =MESSAGEBOX([Sub - divisiones de c¢digo de material mal definidas.;]+;
             [Corregir en el men£ de tablas y maestros en la opci¢n,;]+;
             [de tablas generales del sistema.])
ENDIF
USE IN TABL
return .t.
*** Fin : GnLenDiv

