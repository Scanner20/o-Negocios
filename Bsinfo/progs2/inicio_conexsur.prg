CLEAR all
*!*	Poner aqui el directorio en el que esta el Config.INI
*!*	DEFINE WINDOW desktop2 FROM 1,20 TO 20,50  TITLE 'Output' FLOAT GROW CLOSE MINIMIZE FILL FILE LOCFILE('k:\aplvfp\grafgen\jpeg\Jane20060401005.jpg')
*!*	ACTIVATE WINDOW desktop2

SET SYSMENU TO DEFA
	IF INLIST(SYS(5),'F','E','D')
		CD SYS(5)+'\aplvfp\bsinfo\proys\'
		SET DEFA TO \AplVfp\bsinfo
		DEFINE WINDOW desktop2 FROM 0+5,0+60 TO 22.5+5,64.875+60  TITLE 'Las Bebitas' FLOAT GROW CLOSE MINIMIZE FILL FILE LOCFILE(SYS(5)+'\APLVFP\grafgen\jpeg\Jane\jane_joan_3.JPG') FONT 'Lucida Console',14
		ACTIVATE WINDOW desktop2
	ELSE
		CD SYS(5)+'\aplvfp\bsinfo\proys\'
		SET DEFA TO \AplVfp\bsinfo
		DEFINE WINDOW desktop2 FROM 0+5,0+60 TO 22.5+5,64.875+60 TITLE 'Las Bebitas' FLOAT GROW CLOSE MINIMIZE FILL FILE LOCFILE(SYS(5)+'\aplvfp\grafgen\jpeg\Jane\jane_joan_3.JPG') FONT 'Lucida Console',14
		ACTIVATE WINDOW desktop2
 	ENDIF
*!*	Activar los Paths para sus formularios personales.... (xUsuario)

SET PATH TO .\Forms , ; 
			.\Forms2, ;
            .\Progs , ;
			.\Progs2, ;
            .\Reports , ;
            .\Reports2, ;
            .\Menus , ;
            .\Menus2, ;
            .\vcxs ,;
			O:\o-negocios\ConexSur , ;
            O:\o-negocios\ConexSur\Data , ;
			..\classgen\vcxs , ;
			..\classgen\Forms ,;
			..\classgen\Reports ,;
			..\classgen\PROGS ,;
			..\DLLS,;
			..\LIBV\TASK_SERVER
*!*		    c:\fundo\cia001,c:\fundo\cia001\c2000  
			
SET SECONDS OFF
SET HOURS TO 12
SET DECI  TO 6
SET ASSERTS ON
SET MULTILOCKS ON
SET DELETED ON

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


		goConexion	= CREATEOBJECT('cnxgen_ODBC')

*!*		IF !goConexion.Conectar()
*!*			=MESSAGEBOX("¡ No se pudo establecer la conexión con el servidor!",64,"Error de conexión")
*!*			RELEASE goConexion , goEntorno
*!*			RETURN
*!*		ENDIF

Public GsCodCia,GsNomCia,GsSigCia,GsDirCia,GsTlfCia,GsRptCia,GsRucCia,GsSistema
GsCodCia = '001'

goEntorno	= CREATEOBJECT("Entorno")
goEntPub	= CREATEOBJECT("Env")

goEntPub.TsPathInicio = SET('PATH')


goCfgCpi	= CREATEOBJECT("DOSVR.Cpiplibf") &&AMAA 28-12-06

goSvrCbd    = CREATEOBJECT("DOSVR.Contabilidad") 	&& Servicios para contabilidad
*!*	Colocar aqui el Sistema y Módulo que trabajarán
goEntorno.Sistema = "FUN"   &&& VETT  ???
goEntorno.Modulo  = "GEN"   &&& VETT  ???

goEntorno.USER.Login	= ALLTRIM( SUBSTR(SYS(0),AT('#',SYS(0))+1) )

_vfp.Caption = 'o-Negocios - '+STR(YEAR(DATE()),4,0)  + ' --> '+ goentpub.tspathadm
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
PUBLIC xAcceso
xAcceso = .f.

goCfgAlm	= CREATEOBJECT("DOSVR.oNegocios")
goCfgVTa    = CREATEOBJECT("DOSVR.oNegocios")
DO config_almacen

&& Clasificacion auxiliar de clientes y proveedores de la tabla CBDMAUXI
DO FORM gen4_login.scx WITH 'ADM'
*!*	Goentorno.User.Login= 'Prueba'
*!*	GoEntorno.USER.GroupName		= 'Ventas'
*!*	GsUsuario = 'Prueba'
=BuildAccessCursor()
xAcceso = .T.
*
**
************************
PROCEDURE Config_almacen
************************
Public GsCodCia,GsNomCia,GsSigCia,GsDirCia,GsTlfCia,GsRptCia,GsRucCia,GsFaxCia
Public GsCodSed,GsNomSed,GsSubAlm,GsNomSub,GaLenCod,GaClfDiv,GsClfAtr,GnLenAtr
Public GsAnoMes,GsPeriodo,GsNroMes,GsClfDiv,GnLenDiv,GdFecha,GsFecha
*
Public XsNroMes,GlCorrU_I,GlContra
*
GsCodCia	='003'
GsNomcia	='NO definida'
GsDirCia	= 'NO Definida'
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
*GoEntorno.GsPeriodo ='2003'
GsPeriodo = LEFT(GoEntorno.GsPeriodo,4)
GsAnoMes  = GoEntorno.GsPeriodo
*
XsNroMes = TRAN(_MES,"@L 99")
*
GsUsuario = 'ADMIN'

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

*goEntorno.GenerarPerfilUsuario()
*goEntorno.GenerarTablasLocales()
GOCFGALM.CodSed = GsCodSed
GoCfgalm.XsCodDoc='FACT'
GoCfgAlm.XsTpoDoc='CARGO'
GOCfGAlm.XsPtoVta='001'

** VETT 2006/04/09 **
GoEntpub.GsCodCia	= GsCodCia
GoEntPub.TsPathCia = goentpub.Pathdatacia(GsCodCia)
IF VARTYPE(GdFecha)='D'
	GdFecha = DTOT(GdFecha)
ENDIF

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
DIMENSION GaLenCod(1),GaClfDiv(1),GaNomDiv(1)
STORE 0 TO GaLenCod,GnLenAtr
STORE [] TO GaClfDiv,GsClfAtr

*!*	SELE 0
*!*	IF !FILE('ALMTGSIS.CDX')
*!*	   USE ALMTGSIS ALIAS TABL EXCLU
*!*	   IF !USED()
*!*	      =MESSAGEBOX([Error en apertura de tabla general del sistema])
*!*	      CLOSE DATA
*!*	      RETURN
*!*	   ENDIF
*!*	   SET SAFE OFF
*!*	   INDEX ON TABLA+CODIGO TAG TABL01
*!*	   INDEX ON TABLA+NOMBRE TAG TABL02
*!*	   SET ORDER TO TABL01
*!*	   SET SAFE ON
*!*	ELSE
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
     IF CodIng = 'ATR'
        GsClfAtr  = LEFT(Codigo,2)
        GnLenAtr  = Digitos
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
return 
*** Fin : GnLenDiv

