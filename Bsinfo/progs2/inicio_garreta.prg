CLEAR ALL
*!*	Poner aqui el directorio en el que esta el Config.INI

SET SYSMENU TO DEFA
IF INLIST(SYS(5),'F','E','D')
	CD SYS(5)+'\dev\aplvfp\bsinfo\proys\'
	SET DEFA TO \dev\AplVfp\bsinfo
	DEFINE WINDOW desktop2 FROM 1,20 TO 20,50  TITLE 'Output' FLOAT GROW CLOSE MINIMIZE FILL FILE LOCFILE(SYS(5)+'\dev_thinkpad\APLVFP\grafgen\jpeg\Jane\Jane20060401005.jpg')
	ACTIVATE WINDOW desktop2
ELSE
	CD SYS(5)+'\aplvfp\bsinfo\proys\'
	SET DEFA TO \AplVfp\bsinfo
	DEFINE WINDOW desktop2 FROM 1,20 TO 20,50  TITLE 'Output' FLOAT GROW CLOSE MINIMIZE FILL FILE LOCFILE(SYS(5)+'\aplvfp\grafgen\jpeg\Jane\Jane20060401005.jpg')
	ACTIVATE WINDOW desktop2
ENDIF
*!*	Activar los Paths para sus formularios personales.... (xUsuario)
SET PATH TO .\Forms , ; 
            .\Progs , ;
            .\Reports , ;
            .\Menus , ;
            .\vcxs , ;
            h:\o-negocios\garreta , ;
            h:\o-negocios\garreta\Data , ;
			..\classgen\vcxs , ;
			..\classgen\Forms ,;
			..\classgen\Reports ,;
			..\classgen\PROGS ,;
			..\DLLS,;
			..\LIBV\TASK_SERVER
			
SET SECONDS OFF
SET HOURS TO 12
SET DECI  TO 6
SET ASSERTS ON
SET MULTILOCKS ON

** Cosntantes Globales independientes de que modulo se este ejecutando
#include const.h
*!*	Las 2 lineas anteriores, apuntan hacia las clases generales

*!*	Activar las Librerias de clases generales
SET CLASSLIB TO ADMNOVIS , ADMTBAR , ADMVRS , ADMGRAL ,DOSVR, o-N,registry
CLOSE DATABASES ALL
SET PROCEDURE TO JANESOFT,FXGEN_2
SET LIBRARY TO VFPEncryption71.FLL
DO def_v_publicas
DO def_color
*!*	SET PROCEDURE TO ALMPLIBF ADDITIVE
*!*	PUBLIC goEntorno , goConexion , goAlmplibf
PUBLIC goEntorno , goConexion , GoCfgAlm , GoCfgCpi , GoSvrCbd,GoCfgVta,GoEntPub
*!*	Public _Mes, _Ano
*!*	_Mes = Month(Date())
*!*	_Ano = Year(Date())

goConexion = CREATEOBJECT('cnxgen_ODBC')

*!*		IF !goConexion.Conectar()
*!*			=MESSAGEBOX("¡ No se pudo establecer la conexión con el servidor!",64,"Error de conexión")
*!*			RELEASE goConexion , goEntorno
*!*			RETURN
*!*		ENDIF

goEntorno	= CREATEOBJECT("Entorno")
goEntPub	= CREATEOBJECT("Env")

goEntPub.TsPathInicio = SET('PATH')
*!*	goCfgCpi	= CREATEOBJECT("DOSVR.Cpiplibf")
Public GsCodCia,GsNomCia,GsSigCia,GsDirCia,GsTlfCia,GsRptCia,GsRucCia,GsSistema
GsCodCia = '001'
goSvrCbd    = CREATEOBJECT("DOSVR.Contabilidad") 	&& Servicios para contabilidad
*!*	Colocar aqui el Sistema y Módulo que trabajarán
goEntorno.Sistema = "FUN"   &&& VETT  ???
goEntorno.Modulo = "GEN"   &&& VETT  ???

goEntorno.USER.Login	= ALLTRIM( SUBSTR(SYS(0),AT('#',SYS(0))+1) )

_vfp.Caption = 'o-Negocios - '+STR(YEAR(DATE()),4,0)  + ' --> '+ goentpub.tspathadm
**************************************************
* Publicas de todo el sistema y para cada modulo *
**************************************************
PUBLIC GdFecha,GsFecha,GsUsuario,GsPathCia
***********************
* Publicas de almacen *
***********************
Public GsCodSed,GsNomSed,GsSubAlm,GsNomSub,GaLenCod,GaClfDiv,GlCorrU_I,GlContra,GsClfDiv,GnLenDiv 
****************************
* Publicas de Contabilidad *
****************************
goSvrCbd.SetVarPublic()
goEntPub.SetPath()
PUBLIC xAcceso
xAcceso = .f.
goCfgAlm	= CREATEOBJECT("DOSVR.oNegocios")
goCfgVTa    = CREATEOBJECT("DOSVR.oNegocios")
DO config_almacen

*!*	Clasificacion auxiliar de clientes y proveedores de la tabla CBDMAUXI
DO FORM gen4_login.scx WITH 'ADM'
************************
PROCEDURE Config_almacen
************************
Public GsCodCia,GsNomCia,GsSigCia,GsDirCia,GsTlfCia,GsRptCia,GsRucCia,GsFaxCia
Public GsCodSed,GsNomSed,GsSubAlm,GsNomSub,GaLenCod,GaClfDiv
Public GsAnoMes,GsPeriodo,GsNroMes,GsClfDiv,GnLenDiv,GdFecha,GsFecha
Public XsNroMes,GlCorrU_I,GlContra
GsCodCia	='001'
GsNomcia	='NO definida'
GsDirCia	= 'NO Definida'
GsCodSed	='001'
GsNomSed	= 'NO definida'
GsSubAlm	='010'
GsNomSub	='NO definida'
GlCorrU_I   = .F.
GlContra  	= .F.
GdFecha = DATETIME()
GsFecha = LTRIM(STR(DAY(GdFecha)))+"-"+MES(GdFecha,3)+;
             "-"+STR(YEAR(GdFecha),4)
GsPeriodo = LEFT(GoEntorno.GsPeriodo,4)
GsAnoMes  = GoEntorno.GsPeriodo
XsNroMes = TRAN(_MES,"@L 99")
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
LsDbPeriodo= 'P'+GsCodCia+GsPeriodo
OPEN DATABASE (LsDbPeriodo)
SET DATABASE TO (LsDBCia)
GoCfgAlm.CargaSedes
GsCOdSed = GoCfgAlm.mSedes(1,1)
GsNomSed = GoCfgAlm.mSedes(1,2)
GOCFGALM.CodSed = GsCodSed
GoCfgalm.XsCodDoc='FACT'
GoCfgAlm.XsTpoDoc='CARGO'
GOCfGAlm.XsPtoVta='001'

*!* VETT 2006/04/09 *!*
GoEntpub.GsCodCia = GsCodCia
GoEntPub.TsPathCia = goentpub.Pathdatacia(GsCodCia)


DO define_division_Familia
RETURN
*!*	OJO : Este codigo debe pasar a ser un metodo para ser utilizado como los metodos de la clase
*!*	Entorno 
*********************************
PROCEDURE Define_Division_Familia		
*********************************
*********************************************************************
* GaLenCod :    Longitud de las divisiones del codigo del material. *
*********************************************************************
DIMENSION GaLenCod(1),GaClfDiv(1)
STORE 0 TO GaLenCod
STORE [] TO GaClfDiv
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
*!*	Fin : GaLenCod

*************************************************************************
* GnLenDiv :    Longitud de la division/Familia a utilizar por defecto. *
*************************************************************************
IF GnLenDiv <= 0
	=MESSAGEBOX([Sub - divisiones de c¢digo de material mal definidas.;]+;
             [Corregir en el men£ de tablas y maestros en la opci¢n,;]+;
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
	RETURN
ENDIF
GsSubAlm = GaSubALm(1,1)
GsNomSub = GaSubAlm(1,2)
DIMENSION GaSubAlm(zi,2)
IF USED('ALMA')
	USE IN ALMA
ENDIF
RETURN 
*!*	Fin : GnLenDiv

