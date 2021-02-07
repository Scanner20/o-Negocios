*!*	Poner aqui el directorio en el que esta el Config.INI
SET SYSMENU TO DEFA
SET DEFA TO \AplVfp\bsinfo

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
*!*		    c:\fundo\cia001,c:\fundo\cia001\c2000  
			
SET SECONDS OFF
SET HOURS TO 12
SET DECI  TO 6
SET ASSERTS ON

** Cosntantes Globales independientes de que modulo se este ejecutando
#include const.h 	
*!*	Las 2 lineas anteriores, apuntan hacia las clases generales

*!*	Activar las Librerias de clases generales
SET CLASSLIB TO ADMNOVIS , ADMTBAR , ADMVRS , ADMGRAL ,DOSVR
CLOSE DATABASES ALL
SET PROCEDURE TO JANESOFT
*!*	SET PROCEDURE TO ALMPLIBF ADDITIVE

*!*	PUBLIC goEntorno , goConexion , goAlmplibf
PUBLIC goEntorno , goConexion , GoCfgAlm , GoCfgCpi , GoSvrCbd,GoCfgVta

*!*		goConexion	= CREATEOBJECT('cnxgen_ODBC')

*!*		IF !goConexion.Conectar()
*!*			=MESSAGEBOX("¡ No se pudo establecer la conexión con el servidor!",64,"Error de conexión")
*!*			RELEASE goConexion , goEntorno
*!*			RETURN
*!*		ENDIF

goEntorno	= CREATEOBJECT("Entorno")
goCfgAlm	= CREATEOBJECT("DOSVR.Almplibf")
goCfgCpi	= CREATEOBJECT("DOSVR.Cpiplibf")
goSvrCbd    = CREATEOBJECT("DOSVR.Contabilidad") 	&& Servicios para contabilidad
goCfgVTa    = CREATEOBJECT("DOSVR.Almplibf")
*!*	Colocar aqui el Sistema y Módulo que trabajarán
goEntorno.Sistema = "FUN"   &&& VETT  ???
goEntorno.Modulo  = "GEN"   &&& VETT  ???

goEntorno.USER.Login	= ALLTRIM( SUBSTR(SYS(0),AT('#',SYS(0))+1) )
*************************************************
** Publicas de todo el sistema y para cada modulo
*************************************************
Public GsCodCia,GsNomCia,GsSigCia,GsDirCia,GsTlfCia,GsRptCia,GsRucCia
PUBLIC GdFecha,GsFecha,GsUsuario
**************************
** Publicas de almacen
**************************
Public GsCodSed,GsNomSed,GsSubAlm,GsNomSub,GaLenCod,GaClfDiv,GlCorrU_I,GlContra,GsClfDiv,GnLenDiv 
***************************
** Publicas de Contabilidad
***************************
goSvrCbd.SetVarPublic()
DO config_almacen

&& Clasificacion auxiliar de clientes y proveedores de la tabla CBDMAUXI
*
GsDirCia= ''
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
GsCodSed	='001'
GsNomSed	= 'NO definida'
GsSubAlm	='010'
GsNomSub	='NO definida'
GlCorrU_I   = .F.
GlContra  	= .F.
**K_ESC = 27
GdFecha = DATETIME()
GsFecha = DATETIME()
GoEntorno.GsPeriodo ='2003'
GsPeriodo = LEFT(GoEntorno.GsPeriodo,4)
*
_Mes = Month(Date())
_Ano = Year(Date())
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

SELE 0
IF !FILE('ALMTGSIS.CDX')
   USE ALMTGSIS ALIAS TABL EXCLU
   IF !USED()
      =MESSAGEBOX([Error en apertura de tabla general del sistema])
      CLOSE DATA
      RETURN
   ENDIF
   SET SAFE OFF
   INDEX ON TABLA+CODIGO TAG TABL01
   INDEX ON TABLA+NOMBRE TAG TABL02
   SET ORDER TO TABL01
   SET SAFE ON
ELSE
   USE ALMTGSIS ORDER TABL01 ALIAS TABL
   IF !USED()
      =MESSAGEBOX([Error en apertura de tabla general del sistema])
      CLOSE DATA
      RETURN
   ENDIF
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
return 
*** Fin : GnLenDiv

