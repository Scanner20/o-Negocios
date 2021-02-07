*!*	------------------------------------------------------------------------------------
*!*	Titulo			:
*!*	Prop¢sito		:	Programa Principal del Sistema de Desarrollo de Producto
*!*	PARµMETROS		:	<Ninguno>
*!*	Valor de retorno:	<Ninguno>
*!*	Comentarios 	:
*!*
*!*	CREACIàN
*!*		Fecha  		:	03 - Dic - 1999
*!*		Autor		:	Giuliano Gonzales Zeballos
*!*		Comentario	:
*!*
*!*	ULTIMA MODIFICACIàN
*!*		Fecha		:   30 - Jun - 2000  
*!*		Autor		:	Víctor Segovia Jiménez
*!*		Comentario	:
*!*	-------------------------------------------------------------------------------------

SET PATH TO .\Formularios , .\Programas , .\Reportes , .\Menus , .\Clases ,  ;
			H:\TDV\ClasesGenerales\Programacion01\Programacion\Clases , ;
			H:\TDV\ClasesGenerales\Programacion01\Programacion\Formularios , ;
			H:\TDV\ClasesGenerales\Programacion01\Programacion\Reportes, ;
			H:\TDV\Ayudas

SET CLASSLIB TO ADMNOVIS , ADMTBAR , ADMVRS , ADMGRAL

_SCREEN.VISIBLE = .F.
_SCREEN.WINDOWSTATE	= 2
CLOSE DATABASES ALL
DEACTIVATE WINDOW 'Estándar'
DEACTIVATE WINDOW 'Standard'
DEACTIVATE WINDOW 'Administrador de Proyectos'
DEACTIVATE WINDOW 'Project Manager'
SET SYSMENU OFF

*!*	Mostrar el Login de Ingreso al Sistema
DO FORM Gen4_Login WITH 'DDP','GEN'
READ EVENTS

LOCAL loUtil

IF NOT (VARTYPE(goEntorno)=="O" AND goEntorno.Conexion.Conectado) .OR. !xAcceso
	IF EMPTY(VERSION(2))	&& RunTime
		QUIT
	ELSE
		_SCREEN.VISIBLE = .T.
		RETURN
	ENDIF
ENDIF

goEntorno.Sistema	= "DDP"
goEntorno.Modulo	= "GEN"
goEntorno.GenerarLog('0001','')

loUtil	= CREATEOBJECT('Util')

_SCREEN.CAPTION	= goEntorno.DescripcionSistema
_SCREEN.ICON	= "H:\Tdv\GraficosGenerales\Iconos\Color8.ico"

Gen4_Bienvenida.lblMsg.CAPTION	= 'Configurando el Entorno del Sistema'
DOEVENTS
DOEVENTS
DOEVENTS

*!*	Crear la barra de herramienta del m¢dulo

PUBLIC goToolBar1 , goStatusBar
*!*	Configurar la barra de estado del sistema
goStatusBar	= CREATEOBJECT("StatusBar")
goStatusBar.DOCK(3)
goStatusBar.MOVABLE	= .F.
goStatusBar.Fecha	= loUtil.Formato_Fecha(DATE(),.T.)
goStatusBar.Servidor= '\\'+goEntorno.Servidor+'\'+goEntorno.BaseDatos
goStatusBar.SHOW()

Gen4_Bienvenida.lblMsg.CAPTION	= 'Configurando el menú principal'
DOEVENTS
DOEVENTS
DOEVENTS

_SCREEN.VISIBLE	= .T.
_SCREEN.PICTURE	= "h:\tdv\graficosgenerales\fondos\logo_tdv.bmp"

Gen4_Bienvenida.lblMsg.CAPTION	= 'Obteniendo el perfil de usuario'
DOEVENTS
DOEVENTS
DOEVENTS


goStatusBar.Usuario	= goEntorno.USER.Login
*!*	goToolBar1.ENABLED	=	.T.

ON SHUTDOWN CLEAR EVENTS
Gen4_Bienvenida.RELEASE()
RELEASE  Gen4_Bienvenida

goEntorno.GenerarPerfilUsuario()
*return

DO FORM DdpGen2_Principal
*READ EVENTS

ON SHUTDOWN
WAIT WINDOW 'Saliendo del Sistema...' TIMEOUT 0.5


CLOSE DATABASES ALL
goConexion.Desconectar()

=SQLDisconnect(0)

RELEASE goEntorno , goConexion , goToolBar1 , goStatusBar

SET SYSMENU TO DEFAULT
_SCREEN.PICTURE	= ''
_SCREEN.ICON	= ''
_SCREEN.CAPTION	= ALLTRIM(LEFT(VERSION(1),AT(' ',VERSION(1),2)))

IF EMPTY(VERSION(2))	&& RunTime
	QUIT
ENDIF
WAIT CLEAR
CLEAR ALL
RETURN



*!*	-----------------------------------------------------------
*!*	Procedimiento para salir del Sistema Comercial
*!*	-----------------------------------------------------------
PROCEDURE Salir_Com
	*_SCREEN.REMOVEOBJECT('PAPEL_TAPIZ')
	CLEAR EVENTS
	CLOSE DATABASES ALL
	goConexion.Desconectar()
	=SQLDisconnect(0)

	RELEASE goEntorno , goConexion , goToolBar1 , goStatusBar
	SET SYSMENU TO DEFAULT
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
	ON SHUTDOWN DO Exit_Option  && IN COM
	DO CASE
		CASE lnOpcion == 1	&& PRESUPUESTOS
			*_SCREEN.PAPEL_TAPIZ.VISIBLE	= .F.
			*_SCREEN.CAPTION	= 'Sistema Comercial - [Módulo Presupuestos]'
			*DO COMPRE.MPR
		CASE lnOpcion == 2	&& PEDIDOS REGULARES
			*_SCREEN.PAPEL_TAPIZ.VISIBLE	= .F.
			*_SCREEN.CAPTION	= 'Sistema Comercial - [Módulo Pedidos Regulares]'
			*DO COMPR1.MPR
		CASE lnOpcion == 3	&& REPOSICION DE STOCK
			*_SCREEN.PAPEL_TAPIZ.VISIBLE	= .F.
			*_SCREEN.CAPTION	= 'Sistema Comercial - [Módulo Reposici¢n de Stock]'
			*DO COMPR2.MPR
	ENDCASE
ENDPROC


*!*	-----------------------------------------------------------
*!*	Salir de los M¢dulos del Sistema Comercial
*!*	-----------------------------------------------------------
PROCEDURE Exit_Option
	ON SHUTDOWN CLEAR EVENTS
	*_SCREEN.PAPEL_TAPIZ.VISIBLE	= .T.
	*_SCREEN.CAPTION	= 'Sistema Comercial'
	*DO ADMPrincipal.MPR
ENDPROC