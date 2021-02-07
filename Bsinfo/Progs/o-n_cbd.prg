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

*!*	Activar los Paths para sus formularios personales.... (xUsuario)  && .\Data ,
*!*	         	D:\o-negocios\IDC , ;
*!*	            D:\o-negocios\IDC\Data , ;

SET PATH TO .\Forms , ; 
			.\Forms2, ;
            .\Progs , ;
            .\Reports , ;
            .\Menus , ;
            .\vcxs , ;
            .\Data , ;
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
	DO 	LsPathUPD+'UPD_SYSTEM.FXP' WITH '001'  && Compañia uno por defecto
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
		=MESSAGEBOX("¡ No se pudo establecer la conexión con el servidor!",64,"Error de conexión")
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

goEntorno.Modulo = 'CBD'
CLEAR
WITH _SCREEN
    oldcaption = .CAPTION
    .CAPTION="CONTABILIDAD"
ENDWITH
IF VARTYPE(_SCREEN.MyBG)='O'
	_SCREEN.MyBG.Visible = .T.
ENDIF

xbarra = CREATEOBJECT('Fun_Acceso')
xbarra.DOCK(2)
xbarra.VISIBLE  = (.T.)
This.Parent.EjecutaCbd=.F.
do form FunFun_Selec_Contab TO This.Parent.EjecutaCbd
IF THIS.Parent.EjecutaCbd
	DO FUNCBDM00.MPR
	READ EVENTS
ENDIF
SET SYSMENU OFF
_SCREEN.CAPTION=oldcaption
goEntorno.Modulo = 'GEN'