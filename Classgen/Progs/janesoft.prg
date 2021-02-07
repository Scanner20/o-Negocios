*:*****************************************************************************
*:
*: Procedure file: C:\APLICA\LIB\belcsoft.PRG
*:         System: belcsoft
*:         Author: VICTOR E. TORRES TEJADA
*:      Copyright (c) 1995 - 1998, belcsoft S.A
*:  Last modified: 10/12/98 at 13:55:02
*:
*:  Procs & Fncts: COLOR     ***
*:               : MONO_VGA
*:               : MONO
*:               : DEF_COLOR
*:               : BORR_ARCTMP
*:               : DEF_TECLAS
*:               : F1_ERROR
*:               : PRESENTA
*:               : PMEYLU
*:               : _CLAVE()
*:               : F0CHKSIS()
*:               : SIS_MENU
*:               : _SIGUE()
*:               : _SALIR()
*:               : _ACTMNU()
*:               : SISTEMAS
*:               : F1_MENUV()
*:               : QUE_HAGO
*:               : ACHOICE()
*:               : QUE_HAGOW
*:               : F1_ALERT
*:               : F1_CAJA
*:               : FA_ALERT
*:               : F0EMPRES()
*:               : VCONTROL()
*:               : F()
*:               : F1_EDIT
*:               : BTN_VAL
*:               : LOC_DLOG
*:               : REFRESH
*:               : ESTADO
*:               : F1_BASE()
*:               : F1_BUSCA()
*:               : F1_ESTOY
*:               : F1QEH()
*:               : F1_INDEX()
*:               : F1_RLOCK()
*:               : F0PRINT
*:               : DIRPRINT
*:               : PSELECT()
*:               : FORMREPO
*:               : FORMLABE
*:               : F0PRFIN
*:               : F0MBPRN
*:               : XRETURN
*:               : F1MSGERR
*:               : F1BROWSE_CLON()
*:               : FSERR()
*:               : FASELEC()
*:               : F1CHRMES()
*:               : F1QH()
*:               : F0DCRIP()
*:               : F0CRIPT()
*:               : F1_APERT()
*:               : INDEX_TAG
*:               : F1USEROK()
*:               : F1CNFGSO()
*:               : F1DBFALT()
*:               : F1_ALARM
*:               : F1_SEGDS()
*:               : NUMERO()
*:               : F1_WMSG()
*:               : F1_DOW()
*:               : F1_ALEA()
*:               : ENCRIPTA
*:               : MES()
*:               : PSET()
*:               : PRNSTR()
*:               : ADMMTCMB
*:               : ABRIRDBFS
*:               : BROWS_TCMB
*:               : BDEF_TCMB()
*:               : VFCHCMB()
*:               : VOFIVTA()
*:               : VOFICMP()
*:               : VBCOCMP()
*:               : VBCOVTA()
*:               : BBORRA_REG
*:               : BAGREGA_REG
*:               : VBRW()
*:               : WBRW()
*:               : ADMMTABL
*:               : ADMCMBST
*:               : VMARCA()
*:               : ADMMSEDE
*:               : BROWS_SEDE
*:               : BDEF_SEDE()
*:               : BIGCHARS
*:               : ADMMTSIS
*:               : BROWS_TSIS
*:               : BDEF_TSIS()
*:               : DESCRIPT
*:               : PKUNPRG()
*:               : CFGUSUAR()
*:               : CFGSISTE()
*:
*:          Calls: COLOR              (procedure in belcsoft.PRG)
*:               : MONO_VGA           (procedure in belcsoft.PRG)
*:               : MONO               (procedure in belcsoft.PRG)
*:               : DEF_COLOR          (procedure in belcsoft.PRG)
*:               : BORR_ARCTMP        (procedure in belcsoft.PRG)
*:               : DEF_TECLAS         (procedure in belcsoft.PRG)
*:               : F1_ERROR           (procedure in belcsoft.PRG)
*:               : PRESENTA           (procedure in belcsoft.PRG)
*:               : PMEYLU             (procedure in belcsoft.PRG)
*:               : _CLAVE()           (function in belcsoft.PRG)
*:               : F0CHKSIS()         (function in belcsoft.PRG)
*:               : SIS_MENU           (procedure in belcsoft.PRG)
*:               : _SIGUE()           (function in belcsoft.PRG)
*:               : _SALIR()           (function in belcsoft.PRG)
*:               : _ACTMNU()          (function in belcsoft.PRG)
*:               : GER_S_VB.PRG
*:
*:           Uses: ADMPRINT.DBF
*:               : USUARIOS.DBF           Alias: USUA
*:
*:      CDX files: USUARIOS.CDX
*:
*:    Other Files: ADMCONFG.FKY
*:
*:      Documented 16:47:49                                FoxDoc version 3.00a
*:*****************************************************************************
** LIBRERIA PRINCIPAL **
**
CLEAR
CLOSE ALL
do def_v_publicas

*------------------------------------------------------------------------------*
c_dbfempty  ='La base de datos est  vac¡a. ¨Desea agregar alg£n registro?'
c_edits     ='Por favor, finalice su edici¢n.'
c_topfile   ='Principio de archivo.'
c_endfile   ='Fin de archivo.'
c_brtitle   ='Encontrar registro'
c_nolock    ='En este momento no se puede bloquear el registro, int‚ntelo m s tarde.'
c_ecancel   ='Edici¢n cancelada.'
c_delrec    ='¨Eliminar registros seleccionados?'
c_nofeat    ='Caracter¡stica no disponible ahora.'
c_nowiz     ='Asistente no disponible.'
c_makerepo  ='Crear un informe con el Asistente para informes.'
c_norepo    ='No se puede crear el informe.'
c_delnote   ='Eliminando registros...'
c_readonly  ='La tabla es de s¢lo lectura: no se permite su edici¢n.'
c_notable   ='No hay ninguna tabla seleccionada. Abra una tabla o ejecute una consulta.'
c_badexpr   ='Expresi¢n no v lida.'
c_locwiz    ='Buscar WIZARD.APP:'
c_multitable='Tiene tablas de relaci¢n multiple: no se permite agregar registros.'
c_addrec    ='Agregando nuevo registro.'
c_editrec   ='Modificando registro.'

*------------------------------------------------------------------------------*
#DEFINE c_winlib		"FOXTOOLS.FLL"
#DEFINE c_badplat    "Esta versi¢n de FoxApp s¢lo funciona en Windows, DOS o Macintosh."
DO CASE
CASE _WINDOWS
   m.app_platform = "WINDOWS"
   m.g_dfltfface = "MS Sans Serif"
   m.g_dfltfsize = 8
   m.g_dfltfstyle = "B"
   m.libfile = c_winlib
   m.libext  = "FLL"
CASE _MAC
   m.app_platform = "MAC"
   m.g_dfltfface = "Geneva"
   m.g_dfltfsize = 10
   m.g_dfltfstyle = ""
   m.libfile = ""
CASE _DOS
   m.app_platform = "DOS"
   m.g_dfltfface = "FoxFont"
   m.g_dfltfsize = 10
   m.g_dfltfstyle = ""
   m.libfile = ""
   m.libext  = "PLB"
OTHERWISE
   **	WAIT WINDOW C_BADPLAT NOWAIT
   **	RETURN
ENDCASE
m.pathlib = SYS(5)+SYS(2003)+[\LIB\]
c_localiza= " Por favor localizar "
c_no_lib  = " no esta disponible."

IF _UNIX or VERSION()=[Visual FoxPro]
ELSE

   m.fa_libavail = .T.
   m.fa_loadlib = LEN(m.libfile) > 0
   IF m.fa_loadlib
      IF ! m.libfile $ SET("LIBRARY",1)
         m.fa_libavail = .F.
         IF !FILE(m.pathlib+m.libfile)
            m.templib=LOCFILE(m.libfile,m.libext,c_localiza+m.libfile+':')
            IF EMPTY(m.templib)
               WAIT WINDOW m.libfile + c_no_lib
               RETURN
            ELSE
               m.libfile = m.templib
            ENDIF
         ELSE
            m.libfile = m.pathlib+m.libfile
         ENDIF
         SET LIBRARY TO (m.libfile) ADDITIVE
      ENDIF
   ENDIF
ENDIF
*------------------------------------------------------------------------------*
SET SYSMENU TO
SET SYSMENU ON
DEFINE PAD _px0106h0q OF _msysmenu PROMPT "\<Sistema"     COLOR SCHEME 3 KEY alt+s,""
DEFINE PAD _px0106h1x OF _msysmenu PROMPT "\<Editar"      COLOR SCHEME 3 KEY alt+E, ""
DEFINE PAD _px0106h1y OF _msysmenu PROMPT "\<Archivar"    COLOR SCHEME 3 KEY alt+A, ""
DEFINE PAD _qau0r8jpa OF _msysmenu PROMPT "\<Window"      COLOR SCHEME 3 KEY alt+W, ""
ON     PAD _px0106h0q OF _msysmenu ACTIVATE POPUP sistema
ON     PAD _px0106h1x OF _msysmenu ACTIVATE POPUP edita
ON     PAD _px0106h1y OF _msysmenu ACTIVATE POPUP archivo
ON     PAD _qau0r8jpa OF _msysmenu ACTIVATE POPUP _mwindow

DEFINE POPUP sistema MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR _mst_about OF sistema PROMPT "\<FoxPro Info."
DEFINE BAR _mst_help  OF sistema PROMPT "\<Help..."
DEFINE BAR _mst_macro OF sistema PROMPT "\<Macros"
DEFINE BAR 3          OF sistema PROMPT "\-"
DEFINE BAR _mst_calcu OF sistema PROMPT "\<Calculadora"   KEY f12, "F12"
DEFINE BAR _mst_diary OF sistema PROMPT "Calendario/\<Diario"
DEFINE BAR 4          OF sistema PROMPT "\-"
DEFINE BAR _mst_captr OF sistema PROMPT "Ca\<pturar"


DEFINE POPUP edita  MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR _med_undo  OF edita PROMPT "Undo"                   KEY ctrl+u, "^U"
DEFINE BAR _med_redo  OF edita PROMPT "Redo"                   KEY ctrl+R, "^R"
DEFINE BAR _med_sp100 OF edita PROMPT "\-"
DEFINE BAR _med_cut   OF edita PROMPT "Cut"                    KEY ctrl+x, "^X"
DEFINE BAR _med_copy  OF edita PROMPT "Copy"                   KEY ctrl+C, "^C"
DEFINE BAR _med_paste OF edita PROMPT "Paste"                  KEY ctrl+v, "^V"
DEFINE BAR _med_clear OF edita PROMPT "Clear"
DEFINE BAR _med_sp200 OF edita PROMPT "\-"
DEFINE BAR _med_slcta OF edita PROMPT "Select All"
DEFINE BAR _med_sp300 OF edita PROMPT "\-"
DEFINE BAR _med_goto  OF edita PROMPT "Goto Line..."
DEFINE BAR _med_find  OF edita PROMPT "Find..."                KEY ctrl+F, "^F"
DEFINE BAR _med_finda OF edita PROMPT "Find Again"             KEY ctrl+G, "^G"
DEFINE BAR _med_repl  OF edita PROMPT "Replace and Find Again" KEY ctrl+E, "^E"
DEFINE BAR _med_repla OF edita PROMPT "Replace All"
DEFINE BAR _med_sp400 OF edita PROMPT "\-"
DEFINE BAR _med_pref  OF edita PROMPT "Preferences..."

DEFINE POPUP archivo MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR _mfi_new   OF archivo PROMPT "\<Nuevo"
DEFINE BAR _mfi_open  OF archivo PROMPT "\<Apertura"
DEFINE BAR _mfi_close OF archivo PROMPT "\<Cerrar"
DEFINE BAR 4          OF archivo PROMPT "\-"
DEFINE BAR _mfi_savas OF archivo PROMPT "\<Grabar"



DEFINE POPUP _mwindow MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR _mwi_hide OF _mwindow PROMPT "\<Esconder"
DEFINE BAR _mwi_hidea OF _mwindow PROMPT "\<Esconder Todo"
DEFINE BAR _mwi_showa OF _mwindow PROMPT "\<Mostrar Todo"
DEFINE BAR _mwi_clear OF _mwindow PROMPT "\<Limpiar"
DEFINE BAR _mwi_sp100 OF _mwindow PROMPT "\-"
DEFINE BAR _mwi_move OF _mwindow PROMPT "\<M\<over" ;
   KEY ctrl+f7, "^F7"
DEFINE BAR _mwi_size OF _mwindow PROMPT "\<Tama¤o" ;
   KEY ctrl+f8, "^F8"
DEFINE BAR _mwi_zoom OF _mwindow PROMPT "\<Zoom " ;
   KEY ctrl+f10, "^F10"
DEFINE BAR _mwi_min OF _mwindow PROMPT "Z\<oom " ;
   KEY ctrl+f9, "^F9"
DEFINE BAR _mwi_rotat OF _mwindow PROMPT "\<Permutar" ;
   KEY ctrl+f1, "^F1"
DEFINE BAR _mwi_color OF _mwindow PROMPT "\<Color..."
DEFINE BAR _mwi_sp200 OF _mwindow PROMPT "\-"
DEFINE BAR _mwi_debug OF _mwindow PROMPT "\<Debug"
DEFINE BAR _mwi_trace OF _mwindow PROMPT "\<Trace"
DEFINE BAR _mwi_view OF _mwindow PROMPT "\<View"
*------------------------------------------------------------------------
SET RESOURCE OFF
CLEAR WINDOW
CLEAR MACROS
RESTORE MACROS FROM admconfg
SET EXACT OFF
SET TALK OFF
SET MESSAGE TO 23
monitor = UPPER(GETENV("COLOR"))
Mon_Color= (m.monitor  = "ON") OR EMPTY(m.Monitor)
IF ISCOLOR() && AND Mon_Color
   DO COLOR
ELSE
   IF SYS(2006)="VGA"
      DO mono_vga
   ELSE
      DO MONO
   ENDIF
ENDIF
DO def_color

IF INLIST(SYS(2006),"VGA")

   **SET DISP TO VGA50
ENDIF


RELEASE monitor

saltopag = .F.
gsterminal = TRIM(GETENV("TERMINAL"))
pathorg1   = SYS( 2001, "PATH" ) + ";" + SYS(5)+SYS(2003)
pathorg    = SYS( 2001, "PATH" ) + ";" + SYS(5)+SYS(2003)
pathdef    = SYS(5)+SYS(2003)
pathtras   = pathdef+[\TRASLADO\]
pathdef1   = SYS(2003)
pathuser   = LEFT(SYS(2005),LEN(SYS(2005))-11)
IF EMPTY(pathuser)
   pathuser= "\APLICA\TMP\"
ENDIF
gsmsgerr   = ""
serr       = ""
glescape   = .F.


DO borr_arctmp    && Borrando archivos temporales

DO def_teclas     && Define teclas

*-------------------- Control de errores --------------------*

ON ERROR DO f1_error WITH PROGRAM(),MESSAGE(),MESSAGE(1),LINENO(),ERROR()

arcusr = pathuser+"USR\FOXUSER"
IF ! EMPTY(gsterminal)
   arcusr = pathuser+"usr\"+RIGHT(gsterminal,8)
   IF ! FILE(arcusr+".dbf")
      arcusr1 = pathuser+"USR\FOXUSER"
      IF ! FILE(arcusr1+".dbf")
         ?CHR(7)+CHR(7)
         WAIT "Archivo : "+arcusr1+".dbf no registrado" WINDOW
         CLOSE DATA
         QUIT
         RETURN
      ENDIF
      USE (arcusr1)
      COPY STRU TO (arcusr)
      USE
   ENDIF
ENDIF
IF ! FILE(arcusr+".dbf")
   ?CHR(7)+CHR(7)
   WAIT "Archivo : "+arcusr+".dbf no registrado" WINDOW
   CLOSE DATA
   QUIT
   RETURN
ENDIF
SET RESOURCE TO (arcusr)
RELEASE cmd,arcusr,arcusr1

** Configuramos variables de impresi¢n **
_nombre    = "Impresora Local                 "
_interface = ""
_comando   = ""
_driver    = "Epson.pdt"
_archivo   = ""
_destino   = 1
_PEJECT    = "NONE"
IF FILE("ADMPRINT.DBF")
   USE admprint ORDER admprint
   SEEK gsterminal
   IF FOUND()
      _nombre    = nombre
      _interface = interface
      _comando   = comando
      _driver    = TRIM(driver)+".pdt"
   ENDIF
   USE
ENDIF
IF "" <> _comando
   ! &_comando >nul
ENDIF
IF "" <> _interface
   SET PRINT TO (_interface)
ELSE
   SET PRINT TO
ENDIF




SET PATH TO (pathorg)

nulo       = 0
simple     = 1
doble      = 2
bloque     = 3

SET REPROCESS TO 20
SET MULTILOCK OFF
SET REFRESH  TO 1
SET UDFPARMS TO REFERENCE
SET POINT TO [.]
SET SEPARATOR TO [,]
IF _WINDOWS
   SET STAT OFF
ENDIF
lPrtLogo=.f.
DO presenta
USE usuarios IN 1 ORDER usua01 ALIAS usua

IF ! USED("USUA")
   SET DEFAULT TO (pathdef)
   QUIT
ENDIF

SELECT usua
IF NOT WEXIST("USUARIO")
   DEFINE WINDOW usuario FROM 17,29 TO 20,53 FLOAT NOCLOSE SHADOW DOUBLE ;
      COLOR SCHEME 10
ENDIF
#REGION 1

ON KEY LABEL ctrl+f12 DO pmeylu

gsusuario= SPACE(LEN(login))
gsclave  = SPACE(LEN(password))
glmaster = .F.
GlDemo    =.F.
glatrib  = ""
tnveces  = 3
#REGION 1
IF WVISIBLE("USUARIO")
   ACTIVATE WINDOW usuario SAME
ELSE
   ACTIVATE WINDOW usuario NOSHOW
ENDIF
@ 0,1 SAY "Usuario :" COLOR SCHEME 10
@ 1,1 SAY "Clave   :" COLOR SCHEME 10

IF ! EMPTY(GETENV("AUTOLOGIN"))
   gsusuario = PADR(UPPER(ALLTRIM(GETENV("AUTOLOGIN"))),LEN(login))
   LOCATE FOR UPPER(usua.login)=gsusuario
   IF ! FOUND()
      gsusuario= SPACE(LEN(login))
   ENDIF
ENDIF

IF EMPTY(gsusuario)
   @ 0,11 GET gsusuario PICTURE "@!" COLOR SCHEME 10
   @ 1,11 GET gsclave   PICTURE "@!" COLOR ,x
   READ VALID _clave()
ELSE
   @ 0,11 SAY gsusuario PICTURE "@!"
ENDIF
RELEASE WINDOWS usuario
IF LASTKEY() = 27
   SET DEFAULT TO (pathdef)
   QUIT
ENDIF
IF GlDemo
    IF USUA.chk>30
       do f1msgerr with [Copia no autorizada del sistema Llamar al Tlf:9180457]       
       
	   SET DEFAULT TO (pathdef)
	   QUIT
    ENDIF
    do while !rlock()
    enddo
    replace usua.chk with usua.chk + 1
    unlock
ENDIF
m.lpravez = .T.
m.lsalir = .F.
** Vector que controla los registros borrados de un archivo **
DIMENSION aregdel(1)
STORE 0 TO aregdel,gntotdel
Gsprogram=PROGRAM()
GlNewSist =.f.
GlGerencia=[G]$UPPER(USUA.Atributos)
DO f0chksis
_MES = MONTH(DATE())
_ANO = YEAR(DATE())
STORE [] TO GsAnoMes,GsPeriodo,XsNroMes
DO CASE
	CASE _WINDOWS OR _MAC
	    IF GlNewSist
			PUSH MENU _MSYSMENU
	        SET SYSMENU TO
*!*		        DO F1ANOMES.SPR
	        =INKEY(3,[M])
*!*		        DO F1INGSIS.SPR
		ELSE
		    DO CASE 
		    	case !GlGerencia
			        PUSH MENU _msysmenu
			        DO sis_menu
			        ACTIVATE MENU _msysmenu
			        READ WHEN _sigue() VALID _salir() ACTIVATE _actmnu()
				other			        
*!*				        DO GER_S_VB
	        ENDCASE
		ENDIF
    CASE _DOS OR _UNIX
		    DO CASE 
		    	case !GlGerencia
			        PUSH MENU _msysmenu
			        IF GlDemo
			        	DO sis_mnu1
			        else
				        DO sis_menu
			        endif
			        ACTIVATE MENU _msysmenu
			        READ WHEN _sigue() VALID _salir() ACTIVATE _actmnu()
				other			        
*!*				        DO GER_S_VB
	        ENDCASE
ENDCASE
SET SYSMENU TO
CLEAR WINDOW ALL
CLOSE DATA
QUIT
RETURN
******************
PROCEDURE sis_menu
RETURN
******************
PROCEDURE sis_mnu1
return
***************
PROCEDURE def_v_publicas
*--------------------------- Variables de  Impresi¢n ---------------------------*
RELEASE ALL LIKE _prn*
PUBLIC _prn0,_prn1,_prn2,_prn3,_prn4,_prn5a,_prn5b,_prn6a,_prn6b,_prn7a,_prn7b,;
   _prn8a,_prn8b,_prn9a,_prn9b,_prn10a,_prn10b
STORE "" TO _prn0,_prn1,_prn2,_prn3,_prn4,_prn5a,_prn5b,_prn6a,_prn6b,;
   _prn7a,_prn7b,_prn8a,_prn8b,_prn9a,_prn9b,_prn10a,_prn10b
*------------------------------------------------------------------------------*

*-------------------- Variables que controlan el teclado -----------------------*
RELEASE ALL LIKE k_*
PUBLIC k_home,k_end,k_pgup,k_pgdn,k_del,k_ins,k_f_izq,k_f_arr,k_f_aba,k_f_der,;
   k_tab,k_backtab,k_backspace,k_enter,k_f1,k_f2,k_f3,k_f4,k_f5,k_f6,k_f7,;
   k_f8,k_f9,k_f10,k_sf1,k_sf2,k_sf3,k_sf4,k_sf5,k_sf6,k_sf7,k_sf8,k_sf9,;
   k_ctrlw,k_lookup,k_borrar,k_esc,m.bfiltro


STORE 0 TO k_home,k_end,k_pgup,k_pgdn,k_del,k_ins,k_f_izq,k_f_arr,k_f_aba,;
   k_f_der,k_f_der,k_tab,k_backtab,k_backspace,k_enter,k_f1,k_f2,k_f3,;
   k_f4,k_f5,k_f6,k_f7,k_f8,k_f9,k_f10,k_sf1,k_sf2,k_sf3,k_sf4,k_sf5,;
   k_sf6,k_sf7,k_sf8,k_sf9,k_ctrlw,k_lookup,k_borrar,k_esc

*-------------------- Variables que controlan el color (adicional) ------------*
PUBLIC c_fondo,c_linea,c_say,c_get,c_sayr,m.bfiltro
STORE "" TO c_fondo,c_linea,c_say,c_get,c_sayr,m.bfiltro
*-------------------- Variables Globales -----------------------*

PUBLIC gscodcia,gsnomcia,gsdircia,gssigcia,gslogcia,gsruccia,m.estoy,Gsprogram,GsCodPln

STORE [] TO gscodcia,gsnomcia,gsdircia,gssigcia,gslogcia,gsruccia,m.estoy,GsCodPln

PUBLIC c_dbfempty,c_edits,c_topfile,c_endfile,c_brtitle,c_nolock,c_ecancel,c_delrec,c_nofeat,c_nowiz 
PUBLIC c_makerepo,c_norepo,c_delnote,c_readonly,c_notable ,c_badexpr,c_locwiz,c_multitable,c_addrec,c_editrec  

c_dbfempty  ='La base de datos est  vac¡a. ¨Desea agregar alg£n registro?'
c_edits     ='Por favor, finalice su edici¢n.'
c_topfile   ='Principio de archivo.'
c_endfile   ='Fin de archivo.'
c_brtitle   ='Encontrar registro'
c_nolock    ='En este momento no se puede bloquear el registro, int‚ntelo m s tarde.'
c_ecancel   ='Edici¢n cancelada.'
c_delrec    ='¨Eliminar registros seleccionados?'
c_nofeat    ='Caracter¡stica no disponible ahora.'
c_nowiz     ='Asistente no disponible.'
c_makerepo  ='Crear un informe con el Asistente para informes.'
c_norepo    ='No se puede crear el informe.'
c_delnote   ='Eliminando registros...'
c_readonly  ='La tabla es de s¢lo lectura: no se permite su edici¢n.'
c_notable   ='No hay ninguna tabla seleccionada. Abra una tabla o ejecute una consulta.'
c_badexpr   ='Expresión no válida.'
c_locwiz    ='Buscar WIZARD.APP:'
c_multitable='Tiene tablas de relaci¢n multiple: no se permite agregar registros.'
c_addrec    ='Agregando nuevo registro.'
c_editrec   ='Modificando registro.'

PUBLIC Saltopag,GsTerminal,Pathorg1,PathOrg,Pathdef,PathDef1,PathUser,GsMsgErr,sErr,GlEscape,GlRunDos
saltopag = .F.
gsmsgerr   = ""
serr       = ""
glescape   = .F.
gsterminal = TRIM(GETENV("TERMINAL"))
pathorg1   = SYS( 2001, "PATH" ) + ";" + SYS(5)+SYS(2003)
pathorg    = SYS( 2001, "PATH" ) + ";" + SYS(5)+SYS(2003)
pathdef    = SYS(5)+SYS(2003)
pathtras   = pathdef+[\TRASLADO\]
pathdef1   = SYS(2003)
pathuser   = LEFT(SYS(2005),LEN(SYS(2005))-11)
IF EMPTY(pathuser)
   pathuser= SYS(2023)
ENDIF
GlRundos = .F.

*!*****************************************************************************
*!
*!       Function: _SIGUE
*!
*!      Called by: belcsoft.PRG
*!
*!*****************************************************************************
FUNCTION _sigue
***************
CLEAR READ

***************
*!*****************************************************************************
*!
*!       Function: _SALIR
*!
*!      Called by: belcsoft.PRG
*!
*!*****************************************************************************
FUNCTION _salir
***************
PRIVATE m.temp, m.ontop

IF m.lsalir
   RETURN .T.
ENDIF
RETURN .F.
****************
*!*****************************************************************************
*!
*!       Function: _ACTMNU
*!
*!      Called by: belcsoft.PRG
*!
*!*****************************************************************************
FUNCTION _actmnu
****************
PRIVATE m.temp, m.ontop
IF m.lpravez
   KEYBOARD "{dnarrow}"
   m.lpravez = .F.
ELSE
   KEYBOARD "{alt+dnarrow}"
ENDIF
**************
*!*****************************************************************************
*!
*!      Procedure: MONO
*!
*!      Called by: belcsoft.PRG
*!
*!*****************************************************************************
PROCEDURE MONO
**************
SET COLOR OF SCHEME  1 TO W/N,N+/W,N/W,W+/N,N/W,N+/W,u+/N,N+/N,W/N,N/W,-
SET COLOR OF SCHEME  2 TO W/N,W+/N,W+/N,W+/N,W/N,N+/W,u+/N,N+/N,W+/N,W/N,-
SET COLOR OF SCHEME  3 TO W/N,N/W,N/W,W+/N,W+/N,W+/N,N+/W,N+/N,W+/N,N+/W,-
SET COLOR OF SCHEME  4 TO W/N,W+/N,W+/N,W+/N,W/N,N+/W,u+/N,N+/N,W+/N,W/N,-
SET COLOR OF SCHEME  5 TO W/N,W+/N,W+/N,W+/N,W+/N,N+/W,u+/N,N+/N,W+/N,W/N,-
SET COLOR OF SCHEME  6 TO W/N,W+/N,W+/N,W+/N,W+/N,N+/W,u+/N,N+/N,W+/N,W/N,-
SET COLOR OF SCHEME  7 TO N+/W,N/W,N/W,N+/W,N/W,W+/N,u+/N,N+/N,N+/W,N/W,-
SET COLOR OF SCHEME  8 TO W/N,u+/N,N/W,N+/W,N/W,N/W,u+/N,N+/N,W+/N,W/N,-
SET COLOR OF SCHEME  9 TO W/N,W+/N,W+/N,N+/W,N/W,N/W,N/W,N+/N,N+/W,N/W,-
SET COLOR OF SCHEME 10 TO W/N,N+/W,N/W,N+/W,N/W,u+/N,N/W,N+/N,N+/W,N/W,-
SET COLOR OF SCHEME 11 TO W+/N,u+/N,N/W,N+/W,N/W,N/W,W/N,N+/N,N/W,W/N,-
SET COLOR OF SCHEME 12 TO W/N,N+/W,N/W,W+/N,W/N,N+/W,u+/N,N+/N,W+/N,W/N,-
IF _WINDOWS

ELSE
	SET COLOR OF SCHEME 13 TO W/N,N+/W,W+/N,W+/N,W/N,u+/N,W+/N,N+/N,W+/N,W/N,-
	SET COLOR OF SCHEME 14 TO N+/W,N/W,N/W,N+/W,N/W,W+/N,u+/N,N+/N,N+/W,N/W,-
ENDIF
SET COLOR OF SCHEME 15 TO W/N,N+/W,W+/N,W+/N,W/N,u+/N,W+/N,N+/N,W+/N,W/N,-
SET COLOR OF SCHEME 16 TO W/N,N+/W,W+/N,W+/N,W/N,u+/N,W+/N,N+/N,W+/N,W/N,-
SET COLOR OF SCHEME 17 TO W/N,N+/W,W+/N,W+/N,W/N,u+/N,W+/N,N+/N,W+/N,W/N,-
SET COLOR OF SCHEME 18 TO W/N,N+/W,W+/N,W+/N,W/N,u+/N,W+/N,N+/N,W+/N,W/N,-
SET COLOR OF SCHEME 19 TO W/N,N+/W,W+/N,W+/N,W/N,u+/N,W+/N,N+/N,W+/N,W/N,-
SET COLOR OF SCHEME 20 TO W/N,N+/W,W+/N,W+/N,W/N,u+/N,W+/N,N+/N,W+/N,W/N,-
SET COLOR OF SCHEME 21 TO W/N,N+/W,W+/N,W+/N,W/N,u+/N,W+/N,N+/N,W+/N,W/N,-
SET COLOR OF SCHEME 22 TO W/N,N+/W,W+/N,W+/N,W/N,u+/N,W+/N,N+/N,W+/N,W/N,-
SET COLOR OF SCHEME 23 TO W/N,N+/W,W+/N,W+/N,W/N,u+/N,W+/N,N+/N,W+/N,W/N,-
SET COLOR OF SCHEME 24 TO W/N,N+/W,W+/N,W+/N,W/N,u+/N,W+/N,N+/N,W+/N,W/N,-
RETURN

******************
*!*****************************************************************************
*!
*!      Procedure: MONO_VGA
*!
*!      Called by: belcsoft.PRG
*!
*!*****************************************************************************
PROCEDURE mono_vga
******************
SET COLOR OF SCHEME  1 TO W/N,N+/W,N/W,W+/N,N/W,N+/W,N/W,N+/N,W+/N,N/W,-
SET COLOR OF SCHEME  2 TO B+,W/N,W+/N,W+/N,W/N,N+/W,N/W,N+/N,W+/N,W/N,-
SET COLOR OF SCHEME  3 TO W/N,N/W,N/W,W+/N,W+/N,W+/N,N+/W,N+/N,W+/N,N+/W,-
SET COLOR OF SCHEME  4 TO W/N,W+/N,W+/N,W+/N,W/N,N+/W,B+/W,N+/N,W+/N,W/N,-
SET COLOR OF SCHEME  5 TO W/N,W+/N,W+/N,W+/N,W+/N,N+/W,B+/W,N+/N,W+/N,W/N,-
SET COLOR OF SCHEME  6 TO W/N,W+/N,W+/N,W+/N,W+/N,N+/W,B+/W,N+/N,W+/N,W/N,-
SET COLOR OF SCHEME  7 TO N+/W,N/W,N/W,N+/W,N/W,W+/N,B+/W,N+/N,N+/W,N/W,-
SET COLOR OF SCHEME  8 TO W/N,B+/W,N/W,N+/W,N/W,N/W,B+/W,N+/N,W+/N,W/N,-
SET COLOR OF SCHEME  9 TO W/N,W+/N,W+/N,N+/W,N/W,N/W,N/W,N+/N,N+/W,N/W,-
SET COLOR OF SCHEME 10 TO W/N,N+/W,N/W,N+/W,N/W,B+/W,N/W,N+/N,N+/W,N/W,-
SET COLOR OF SCHEME 11 TO W+/N,G+/W,N/W,N+/W,N/W,N/W,W/N,N+/N,N/W,W/N,-
SET COLOR OF SCHEME 16 TO W/N,N+/W,N/W,W+/N,W/N,N+/W,B+/W,N+/N,W+/N,W/N,-
IF _WINDOWS
ELSE
	SET COLOR OF SCHEME 13 TO W/N,N+/W,W+/N,W+/N,W/N,B+/W,W+/N,N+/N,W+/N,W/N,-
	SET COLOR OF SCHEME 14 TO N+/W,N/W,N/W,N+/W,N/W,W+/N,B+/W,N+/N,N+/W,N/W,-
ENDIF	
SET COLOR OF SCHEME 15 TO W/N,N+/W,W+/N,W+/N,W/N,G+,W+/N,N+/N,W+/N,W/N,-
SET COLOR OF SCHEME 16 TO W/N,N+/W,W+/N,W+/N,W/N,G+,W+/N,N+/N,W+/N,W/N,-
SET COLOR OF SCHEME 17 TO W/N,N+/W,W+/N,W+/N,W/N,G+,W+/N,N+/N,W+/N,W/N,-
SET COLOR OF SCHEME 18 TO W/N,N+/W,W+/N,W+/N,W/N,G+,W+/N,N+/N,W+/N,W/N,-
SET COLOR OF SCHEME 19 TO W/N,N+/W,W+/N,W+/N,W/N,G+,W+/N,N+/N,W+/N,W/N,-
SET COLOR OF SCHEME 20 TO W/N,N+/W,W+/N,W+/N,W/N,G+,W+/N,N+/N,W+/N,W/N,-
SET COLOR OF SCHEME 21 TO W/N,N+/W,W+/N,W+/N,W/N,G+,W+/N,N+/N,W+/N,W/N,-
SET COLOR OF SCHEME 22 TO W/N,N+/W,W+/N,W+/N,W/N,G+,W+/N,N+/N,W+/N,W/N,-
SET COLOR OF SCHEME 23 TO W/N,N+/W,W+/N,W+/N,W/N,G+,W+/N,N+/N,W+/N,W/N,-
SET COLOR OF SCHEME 24 TO W/N,N+/W,W+/N,W+/N,W/N,G+,W+/N,N+/N,W+/N,W/N,-


RETURN

***************
*!*****************************************************************************
*!
*!      Procedure: COLOR
*!
*!      Called by: belcsoft.PRG
*!
*!*****************************************************************************
PROCEDURE COLOR
***************
SET COLOR OF SCHEME  1 TO W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+
SET COLOR OF SCHEME  2 TO BG/W,N/W,N/W,B/W,W/N,N/BG,W+/W,N+/N,B/W,W/N,+
SET COLOR OF SCHEME  3 TO BG/W,N/W,BG/N,BG/N,BG/N,N/BG,W+/W,N+/N,BG/N,BG/N,+
SET COLOR OF SCHEME  4 TO BG/W,N/W,N/W,B/W,W/N,N/BG,W+/W,N+/N,B/W,W/N,+
SET COLOR OF SCHEME  5 TO W+/RB,W+/BG,W+/RB,W+/RB,W/RB,W+/B,GR+/RB,N+/N,W+/RB,W/RB,+
SET COLOR OF SCHEME  6 TO W/BG,W+/BG,W+/RB,W+/RB,W/RB,W+/B,BG+/BG,N+/N,W+/RB,W/RB,+
SET COLOR OF SCHEME  7 TO B/W,W+/W,GR+/R,W+/R,W/R,W+/N,GR+/R,N+/N,W+/R,W/R,+
SET COLOR OF SCHEME  8 TO W+/BG,W+/W,GR+/W,GR+/W,N+/W,W+/GR,BG+/BG,N+/N,B/BG,W/BG,+
SET COLOR OF SCHEME  9 TO W/BG,W+/BG,B/BG,GR+/W,N+/W,W+/GR,W+/B,N+/N,GR+/W,N+/W,+
SET COLOR OF SCHEME 10 TO RGB(0,0,0,192,192,192),RGB(0,0,0,255,255,255),RGB(192,192,192,0,0,0),RGB(255,255,255,0,0,0,),,RGB(0,0,0,255,255,255),,,RGB(0,0,0,236,233,216)
SET COLOR OF SCHEME 16 TO W+/BG,GR+/B,b/W,N+/W,N+/W,GR+/GR,W+/B,N+/N,GR+/W,N+/W,+  &&
SET COLOR OF SCHEME 11 TO W+/BG,W+/W,GR+/W,GR+/W,N+/W,W+/GR,W/B,N+/N,W+/B,W/BG,+
SET COLOR OF SCHEME 12 TO GR+/R,W+/W,GR+/R,W+/R,W/R,W+/N,GR+/R,N+/N,W+/R,W/R,+
IF _WINDOWS
ELSE
	SET COLOR OF SCHEME 13 TO W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+ &&
	SET COLOR OF SCHEME 14 TO W+/G,W+/RB,W+/RB,W+/RB,W/RB,W+/B,BG+/BG,N+/N,W+/RB,W/RB,+
ENDIF
*SET COLOR OF SCHEME 15 TO W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+
SET COLOR OF SCHEME 16 TO W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+
SET COLOR OF SCHEME 18 TO W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+
SET COLOR OF SCHEME 19 TO W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+
SET COLOR OF SCHEME 20 TO W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+
SET COLOR OF SCHEME 21 TO W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+
SET COLOR OF SCHEME 22 TO W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+
SET COLOR OF SCHEME 23 TO W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+
SET COLOR OF SCHEME 24 TO W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+
RETURN
*********************
PROCEDURE COLOR_SET_1
*********************
set color of scheme  1 to W+/BG,N/W,B+/BG,BG/B,B+/BG,GR+/B,GR+/B,N+/N,GR+/BG,N+/BG,+
set color of scheme  2 to W/BG,W+/BG,W+/B,BG/B,W/N,BG+/B,W+/W,N+/N,B/W,W/N,+
set color of scheme  3 to BG/W,N/W,BG/N,BG/N,BG/N,N/BG,W+/W,N+/N,BG/N,BG/N,-
set color of scheme  4 to BG/W,N/W,N/W,B/W,W/N,N/BG,W+/W,N+/N,B/W,W/N,+
set color of scheme  5 to W+/RB,W+/BG,W+/RB,W+/RB,W/RB,W+/B,GR+/RB,N+/N,W+/RB,W/RB,+
set color of scheme  6 to W/BG,W+/BG,W+/RB,W+/RB,W/RB,W+/B,GR+/RB,N+/N,W+/RB,W/RB,+
set color of scheme  7 to GR+/R,W+/W,GR+/R,W+/R,W/R,W+/N,GR+/R,N+/N,W+/R,W/R,+
set color of scheme  8 to W+/W,W+/BG,W+/W,B/W,N+/W,W+/GR,BG+/BG,N+/N,B/BG,W/BG,+
set color of scheme  9 to W/BG,W+/BG,B/BG,GR+/W,N+/W,W+/GR,W+/B,N+/N,GR+/W,N+/W,+
set color of scheme 10 to W+/BG,GR+/B,W/W,GR+/W,N+/W,GR+/GR,W+/B,N+/N,GR+/W,N+/W,-
set color of scheme 11 to W+/BG,W+/W,GR+/W,GR+/W,N+/W,W+/GR,W/B,N+/N,W+/B,W/BG,+
set color of scheme 12 to GR+/R,W+/W,GR+/R,W+/R,W/R,W+/N,GR+/R,N+/N,W+/R,W/R,+
set color of scheme 16 to W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+
set color of scheme 17 to B/BG,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+
set color of scheme 18 to W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+
set color of scheme 19 to W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+
set color of scheme 20 to W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+
set color of scheme 21 to W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+
set color of scheme 22 to W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+
set color of scheme 23 to W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+
set color of scheme 24 to W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+
create color set SEAGREEN
*!*****************************************************************************
*!
*!      Procedure: BORR_ARCTMP
*!
*!      Called by: belcsoft.PRG
*!
*!*****************************************************************************
PROCEDURE borr_arctmp
*********************
CLEAR
**WAIT PADC("** Borrando archivos temporales **",80) NOWAIT WINDOW
DIMENSION vtmpfile(1)
=ADIR(vtmpfile,pathuser+"*.*")
FOR i = 1 TO ALEN(vtmpfile,1)
   DO CASE
   CASE ".PRN"$vtmpfile(i,1)
   CASE "FOXUSER" $ vtmpfile(i,1)
   OTHER
      ERROR = .F.
      **WAIT PADC(vTmpFile(i,1),80) NOWAIT WINDOW
      ctmpfile = pathuser+vtmpfile(i,1)
      ON ERROR ERROR = .T.
      DELETE FILE (ctmpfile)
      IF ERROR
         * @ 15,0 SAY PADC("ARCHIVO USADO POR OTRO USARIO",80)
      ENDIF
      ON ERROR
   ENDCASE
NEXT
RELEASE ctmpfile,vtmpfile,i,ERROR
IF _DOS
   KEYBOARD CHR(ASC(" "))
   KEYBOARD CHR(k_f_arr)
ENDIF
RETURN
********************
*!*****************************************************************************
*!
*!      Procedure: DEF_TECLAS
*!
*!      Called by: belcsoft.PRG
*!
*!*****************************************************************************
PROCEDURE def_teclas
********************
*------- Definicion de Teclas -------*
k_home       = 1
k_end        = 6
k_pgup       = 18
k_pgdn       = 3
k_del        = 7
k_ins        = 22
k_f_izq      = 19
k_f_der      = 4
k_f_arr      = 5
k_f_aba      = 24
k_tab        = 9
k_backtab    = 15
k_backspace  = 127
k_enter      = 13
k_f1         = 28
k_f2         = -1
k_f3         = -2
k_f4         = -3
k_f5         = -4
k_f6         = -5
k_f7         = -6
k_f8         = -7
k_f9         = -8
k_f10        = -9
k_sf1        = 84
k_sf2        = 85
k_sf3        = 86
k_sf4        = 87
k_sf5        = 88
k_sf6        = 89
k_sf7        = 90
k_sf8        = 91
k_sf9        = 92
k_ctrlw      = 23
k_lookup     = -7
k_borrar     = -8
k_esc        = 27

home       = 1
end        = 6
pgup       = 18
pgdn       = 3
del        = 7
ins        = 22
f_izq      = 19
f_der      = 4
f_arr      = 5
f_aba      = 24
tab        = 9
backtab    = 15
backspace  = 127
enter      = 13
f1         = 28
f2         = -1
f3         = -2
f4         = -3
f5         = -4
f6         = -5
f7         = -6
f8         = -7
f9         = -8
f10        = -9
sf1        = 84
sf2        = 85
sf3        = 86
sf4        = 87
sf5        = 88
sf6        = 89
sf7        = 90
sf8        = 91
sf9        = 92
ctrlw      = 23
lookup     = -7
borrar     = -8
esc        = 27
Escape		= 27

*------------------------------------*
RETURN
******************
*!*****************************************************************************
*!
*!      Procedure: SISTEMAS
*!
*!           Uses: SISTEMAS.DBF           Alias: SIST
*!
*!      CDX files: SISTEMAS.CDX
*!
*!*****************************************************************************
PROCEDURE sistemas
******************
SELE 0
USE sistemas ORDER sist01 ALIAS sist
IF !USED("SIST")
   SET DEFA TO (pathdef)
   RETURN .F.
ENDIF
GO TOP
IF EOF()
   WAIT "NO EXISTEN SISTEMAS DEFINIDOS" NOWAIT WINDOW
   RETURN .F.
ENDIF

DIMENSION acodsis(10),anomsis(10)
nsistemas = 0

SEEK gsusuario

SCAN WHILE login = gsusuario
   nnrosis = nnrosis + 1
   IF nnrosis > ALEN(anomsis)
      DIMENSION acodsis(nnrosis + 10),anomsis(nnrosis + 10)
   ENDIF
   acodsis(nsistemas) = codigo
   anomsis(nsistemas) = nombre
ENDSCAN


nnrosis = nnrosis + 1
IF maxele > ALEN(vmodulo)
   DIMENSION vmodulo(maxele + 10),vcodmod(maxele + 10)
ENDIF
vmodulo(maxele)  = "\<SALIR DEL SISTEMA"
vcodmod(maxele)  = "SALIR"
DIMENSION vmodulo(maxele),vcodmov(maxele),opc(1,2)
opc(1,1) = PADC("MODULOS",ancho)
opc(1,2) = ""
xmodulo = 1
yo = 21 - maxele - 2
IF yo < 3
   yo = 3
ENDIF

DEFINE WINDOW usuario FROM yo,xo-3 TO 21,xo+ancho-2 FLOAT NOCLOSE SHADOW NONE ;
   COLOR SCHEME 2
ACTIVATE WINDOW usuario
DO WHILE .T.
   SET MESSAGE TO 22
   MENU BAR opc,1
   MENU  1,vmodulo,ALEN(vmodulo)
   READ MENU BAR TO row0, xmodulo
   IF LASTKEY() # ESCAPE
      EXIT
   ENDIF
ENDDO
DEACTIVATE WINDOW usuario
RELEASE WINDOWS usuario
IF vcodmod(xmodulo) = "SALIR"
   SET DEFAULT TO (pathdef)
   QUIT
ENDIF
SEEK gsusuario+vcodmod(xmodulo)
RELEASE xmodulo,opc,vmodulo,vcodmod,maxele
***************
*!*****************************************************************************
*!
*!       Function: _CLAVE
*!
*!      Called by: belcsoft.PRG
*!
*!          Calls: ENCRIPTA           (procedure in belcsoft.PRG)
*!
*!*****************************************************************************
FUNCTION _clave
***************
#REGION
PRIVATE i, x, C, A, B
IF LASTKEY() =  27
   RETURN .T.
ENDIF
LOCATE FOR UPPER(usua.login)=gsusuario
IF FOUND()
   if _Windows OR _MAC
		return INLIST(GsUSuario,[MASTER],[ADM],[])		   		
   else
	    B    = encripta(gsclave,RECNO())
	    IF B = usua.password
	    	RETURN .T.
	    ENDIF
   endif		   
ENDIF
?? CHR(7)
WAIT WINDOW "Clave incorrecta. Le quedan "+TRAN(ABS(tnveces - 1),"99")+" intentos..." NOWAIT
gsclave = SPACE(LEN(usua.password))
tnveces = tnveces - 1
IF tnveces < 1
   QUIT
ENDIF
RETURN .F.
*******************
*!*****************************************************************************
*!
*!      Procedure: DEF_COLOR
*!
*!      Called by: belcsoft.PRG
*!
*!*****************************************************************************
PROCEDURE def_color
*******************
IF ISCOLOR()
   *IF UPPER(GETENV("COLOR"))="ON"
   c_fondo = "W+/BU"
   c_linea = "N/bg"
   c_say   = "N/Bg"
   c_sayr  = "N+/Bg"
   c_get   = "W+/BU"
ELSE
   IF SYS(2006)="VGA"
      DO mono_vga
   ELSE
      DO MONO
   ENDIF
   c_fondo = "N+/N"
   c_linea = "N/W"
   c_say   = "N/W"
   c_get   = "N+/W"
   c_sayr  = "N+/W"
ENDIF

*SET COLOR OF SCHEME 2 TO RGB(0,0,0,255,0,0),RGB(0,0,0,255,255,225),RGB(0,0,0,230,255,255),RGB(0,255,0,230,255,255),RGB(0,255,0,230,255,255),RGB(0,0,255,230,255,255),RGB(0,0,0,230,255,255)
*!*	SET COLOR OF SCHEME 11 tO RGB(0,0,0,223,223,223)
*!*	SET COLOR OF SCHEME 12 TO RGB(0,0,0,230,255,255),RGB(0,0,0,192,192,225),RGB(0,0,0,230,255,255),RGB(0,255,0,106,155,227),RGB(223,255,255,0,0,255),RGB(0,0,0,230,255,255),RGB(223,255,255,0,0,255),RGB(0,0,0,106,155,227),RGB(0,0,0,106,155,227),RGB(0,0,0,255,255,255),RGB(0,155,227,0,255,0)
SET COLOR OF SCHEME 11 TO RGB(0,0,0,106,155,227),RGB(0,0,0,192,192,225),RGB(0,0,0,230,255,255),RGB(0,255,0,106,155,227),RGB(223,255,255,0,0,255),RGB(0,0,0,230,255,255),RGB(223,255,255,0,0,255),RGB(0,0,0,106,155,227),RGB(0,0,0,106,155,227),RGB(0,0,0,255,255,255),RGB(0,155,227,0,255,0)
SET COLOR OF SCHEME 12 TO RGB(0,0,0,106,155,227),RGB(0,0,0,192,192,225),RGB(0,0,0,230,255,255),RGB(0,255,0,106,155,227),RGB(223,255,255,0,0,255),RGB(0,0,0,230,255,255),RGB(223,255,255,0,0,255),RGB(0,0,0,106,155,227),RGB(0,0,0,106,155,227),RGB(0,0,0,255,255,255),RGB(0,155,227,0,255,0)
SET COLOR OF SCHEME 16 TO RGB(0,0,0,106,155,227),RGB(0,0,0,192,192,225),RGB(0,0,0,230,255,255),RGB(0,255,0,106,155,227),RGB(223,255,255,0,0,255),RGB(0,0,0,230,255,255),RGB(223,255,255,0,0,255),RGB(0,0,0,106,155,227),RGB(0,0,0,106,155,227),RGB(0,0,0,255,255,255),RGB(0,155,227,0,255,0)
SET COLOR OF SCHEME 17 TO RGB(0,0,0,106,155,227),RGB(0,0,0,192,192,225),RGB(0,0,0,230,255,255),RGB(0,255,0,106,155,227),RGB(223,255,255,0,0,255),RGB(0,0,0,230,255,255),RGB(223,255,255,0,0,255),RGB(0,0,0,106,155,227),RGB(0,0,0,106,155,227),RGB(0,0,0,255,255,255),RGB(0,155,227,0,255,0)
SET COLOR OF SCHEME 18 TO RGB(0,0,0,192,192,192),RGB(128,128,128,192,192,192),RGB(0,0,0,230,255,255),RGB(0,255,0,106,155,227),RGB(223,255,255,0,0,255),RGB(0,0,0,230,255,255),RGB(223,255,255,0,0,255),RGB(0,0,0,106,155,227),RGB(0,0,0,106,155,227),RGB(0,0,0,255,255,255),RGB(0,155,227,0,255,0)
SET COLOR OF SCHEME 19 TO RGB(255,255,255,0,0,255)
*!*	SET COLOR OF SCHEME 18 TO RGB(0,0,0,192,192,225)

*!*****************************************************************************
*!
*!      Procedure: PRESENTA
*!
*!      Called by: belcsoft.PRG
*!               : GER_S_VB.PRG
*!
*!          Calls: F1_BASE()          (function in belcsoft.PRG)
*!
*!*****************************************************************************
PROCEDURE presenta
ctsi=[SISTEMA DE INFORMACION INTEGRAL]
ctsd=[POR : JENNY ANICAMA FRITSCH    ]
ctii=[Active men£ maestro con tecla ALT o haga]
ctid=[doble CLICK con bot¢n derecho del mouse]
=f1_base(ctsi,ctsd,ctii,ctid)
RETURN
****************
*!*****************************************************************************
*!
*!      Procedure: PMEYLU
*!
*!      Called by: belcsoft.PRG
*!
*!*****************************************************************************
PROCEDURE pmeylu
****************
DO CASE
CASE UPPER(GETENV("USER"))=[MEYLU]
   swinact = WOUTPUT()
   ACTIVATE SCREEN
   @ 22,0  CLEAR
   ? "Digite Resume para retornar"
   @ ROW(),7 SAY "RESUME"
   SUSPEND
   IF !EMPTY(swinact)
      ACTIVATE WINDOW (swinact) SAME
   ENDIF
ENDCASE

*       +---------------------------------------------------------+
*       Ý                                                         Ý
*       Ý 27/10/95            SIS_MENU.MPR              23:23:25  Ý
*       Ý                                                         Ý
*       +---------------------------------------------------------Ý
*       Ý                                                         Ý
*       Ý Nombre del autor                                        Ý
*       Ý                                                         Ý
*       Ý Copyright (c) 1995 Nombre de la empresa                 Ý
*       Ý Direcci¢n                                               Ý
*       Ý Ciudad,     C.P.                                        Ý
*       Ý Pa¡s                                              Ý
*       Ý                                                         Ý
*       Ý Description:                                            Ý
*       Ý Este programa lo ha generado autom ticamente GENMENU.    Ý
*       Ý                                                         Ý
*       +---------------------------------------------------------+


*       +---------------------------------------------------------+
*       Ý                                                         Ý
*       Ý                    Definici¢n de men£                   Ý
*       Ý                                                         Ý
*       +---------------------------------------------------------+
*
*!*****************************************************************************
*!
*!      Procedure: SIS_MENU
*!
*!      Called by: belcsoft.PRG
*!
*!          Calls: ALM_S_VB.PRG
*!               : CPI_S_VB.PRG
*!               : CBD_S_VB.PRG
*!               : CMP_S_VB.PRG
*!               : TRF_S_VB.PRG
*!               : FCJ_S_VB.PRG
*!               : PLN_S_VB.PRG
*!               : CFGUSUAR()         (function in belcsoft.PRG)
*!               : ADMMTCMB           (procedure in belcsoft.PRG)
*!               : CFGSISTE()         (function in belcsoft.PRG)
*!
*!*****************************************************************************
*!*	*!*	PROCEDURE sis_menu
*!*	*!*	SET SYSMENU TO

*!*	*!*	*SET SYSMENU ON

*!*	*!*	DEFINE PAD _r4t1e4tep OF _msysmenu PROMPT "\<Aplicaciones" COLOR SCHEME 3 ;
*!*	*!*	   KEY alt+A, ""
*!*	*!*	DEFINE PAD _r4t1e4tew OF _msysmenu PROMPT "\<Configuraci¢n" COLOR SCHEME 3 ;
*!*	*!*	   KEY alt+C, ""
*!*	*!*	DEFINE PAD _qau0r8jpa OF _msysmenu PROMPT "\<Ventanas"      COLOR SCHEME 3 KEY alt+v, ""
*!*	*!*	DEFINE PAD _px0106h0q OF _msysmenu PROMPT "\<Utilitarios"     COLOR SCHEME 3 KEY alt+u,""
*!*	*!*	DEFINE PAD _r4t1e4tf3 OF _msysmenu PROMPT "\<Salir" COLOR SCHEME 3 ;
*!*	*!*	   KEY alt+s, ""
*!*	*!*	ON PAD _r4t1e4tep OF _msysmenu ACTIVATE POPUP aplicacion
*!*	*!*	ON PAD _r4t1e4tew OF _msysmenu ACTIVATE POPUP configurac
*!*	*!*	ON     PAD _qau0r8jpa OF _msysmenu ACTIVATE POPUP _mwindow
*!*	*!*	ON     PAD _px0106h0q OF _msysmenu ACTIVATE POPUP sistema
*!*	*!*	ON SELECTION PAD _r4t1e4tf3 OF _msysmenu QUIT

*!*	*!*	DEFINE POPUP aplicacion MARGIN RELATIVE SHADOW COLOR SCHEME 4
*!*	*!*	DEFINE BAR 1 OF aplicacion PROMPT "\<ALMACEN E INVENTARIOS"
*!*	*!*	DEFINE BAR 2 OF aplicacion PROMPT "CONTROL Y \<PROGRAMA DE PRODUCCION"
*!*	*!*	DEFINE BAR 3 OF aplicacion PROMPT "\<CONTABILIDAD"
*!*	*!*	DEFINE BAR 4 OF aplicacion PROMPT "C\<OMPRAS"
*!*	*!*	DEFINE BAR 5 OF aplicacion PROMPT "\<TRANSFERENCIA DE INFORMACION"
*!*	*!*	DEFINE BAR 6 OF aplicacion PROMPT "\<FLUJO DE CAJA"
*!*	*!*	DEFINE BAR 7 OF aplicacion PROMPT "\<PLANILLAS"
*!*	*!*	DEFINE BAR 8 OF aplicacion PROMPT "\<CTA.CTE. PERSONAL"

*!*	*!*	*!*	ON SELECTION BAR 1 OF aplicacion DO alm_s_vb
*!*	*!*	*!*	ON SELECTION BAR 2 OF aplicacion DO cpi_s_vb
*!*	*!*	*!*	ON SELECTION BAR 3 OF aplicacion DO cbd_s_vb
*!*	*!*	*!*	ON SELECTION BAR 4 OF aplicacion DO cmp_s_vb
*!*	*!*	*!*	ON SELECTION BAR 5 OF aplicacion DO trf_s_vb
*!*	*!*	*!*	ON SELECTION BAR 6 OF aplicacion DO fcj_s_vb
*!*	*!*	*!*	ON SELECTION BAR 7 OF aplicacion DO pln_s_vb
*!*	*!*	*!*	ON SELECTION BAR 8 OF aplicacion DO plnMCCTE


*!*	*!*	DEFINE POPUP configurac MARGIN RELATIVE SHADOW COLOR SCHEME 4
*!*	*!*	DEFINE BAR _mfi_setup OF configurac PROMPT "\<Impresoras"
*!*	*!*	DEFINE BAR 2 OF configurac PROMPT "\-"
*!*	*!*	DEFINE BAR 3 OF configurac PROMPT "\<Tipos de Cambio"
*!*	*!*	DEFINE BAR 4 OF configurac PROMPT "\<Sistemas"
*!*	*!*	*ON SELECTION BAR 1 OF configurac do cfgprint
*!*	*!*	ON SELECTION BAR 2 OF configurac DO cfgusuar
*!*	*!*	ON SELECTION BAR 3 OF configurac DO admmtcmb_x
*!*	*!*	ON SELECTION BAR 4 OF configurac DO cfgsiste



*!*	*!*	DEFINE POPUP _mwindow MARGIN RELATIVE SHADOW COLOR SCHEME 4
*!*	*!*	DEFINE BAR _mwi_hide OF _mwindow PROMPT "\<Esconder"
*!*	*!*	DEFINE BAR _mwi_hidea OF _mwindow PROMPT "\<Esconder Todo"
*!*	*!*	DEFINE BAR _mwi_showa OF _mwindow PROMPT "\<Mostrar Todo"
*!*	*!*	DEFINE BAR _mwi_clear OF _mwindow PROMPT "\<Limpiar"
*!*	*!*	DEFINE BAR _mwi_sp100 OF _mwindow PROMPT "\-"
*!*	*!*	DEFINE BAR _mwi_move OF _mwindow PROMPT "\<M\<over" ;
*!*	*!*	   KEY ctrl+f7, "^F7"
*!*	*!*	DEFINE BAR _mwi_size OF _mwindow PROMPT "\<Tama¤o" ;
*!*	*!*	   KEY ctrl+f8, "^F8"
*!*	*!*	DEFINE BAR _mwi_zoom OF _mwindow PROMPT "\<Zoom " ;
*!*	*!*	   KEY ctrl+f10, "^F10"
*!*	*!*	DEFINE BAR _mwi_min OF _mwindow PROMPT "Z\<oom " ;
*!*	*!*	   KEY ctrl+f9, "^F9"
*!*	*!*	DEFINE BAR _mwi_rotat OF _mwindow PROMPT "\<Permutar" ;
*!*	*!*	   KEY ctrl+f1, "^F1"
*!*	*!*	DEFINE BAR _mwi_color OF _mwindow PROMPT "\<Color..."
*!*	*!*	DEFINE BAR _mwi_sp200 OF _mwindow PROMPT "\-"
*!*	*!*	DEFINE BAR _mwi_debug OF _mwindow PROMPT "\<Debug"
*!*	*!*	DEFINE BAR _mwi_trace OF _mwindow PROMPT "\<Trace"
*!*	*!*	DEFINE BAR _mwi_view OF _mwindow PROMPT "\<View"


*!*	*!*	DEFINE POPUP sistema MARGIN RELATIVE SHADOW COLOR SCHEME 4
*!*	*!*	DEFINE BAR _mst_about OF sistema PROMPT "\<FoxPro Info."
*!*	*!*	DEFINE BAR _mst_help  OF sistema PROMPT "\<Help..."
*!*	*!*	DEFINE BAR _mst_macro OF sistema PROMPT "\<Macros"
*!*	*!*	DEFINE BAR 3          OF sistema PROMPT "\-"
*!*	*!*	DEFINE BAR _mst_calcu OF sistema PROMPT "\<Calculadora"   KEY f12, "F12"
*!*	*!*	DEFINE BAR _mst_diary OF sistema PROMPT "Calendario/\<Diario"
*!*	*!*	DEFINE BAR 4          OF sistema PROMPT "\-"
*!*	*!*	DEFINE BAR _mst_captr OF sistema PROMPT "Ca\<pturar"

*------------------------------------------------------------------------------*
* Programa     : F1_MenuV                                                      *
*                                                                              *
* Autor        : VETT 12/10/95                                                 *
* Actializaci¢n:                                                               *
*                                                                              *
* Nota         : Genera un menu de ventanas emergentes en base a una tabla     *
*                predefinida. Llamamos a procedimiento recursivo.              *
*                El menu es vertical con despliegue vertical.                  *
*------------------------------------------------------------------------------*
*!*****************************************************************************
*!
*!       Function: F1_MENUV
*!
*!      Called by: GER_S_VB.PRG
*!
*!          Calls: F1USEROK()         (function in belcsoft.PRG)
*!               : QUE_HAGO           (procedure in belcsoft.PRG)
*!               : QUE_HAGOW          (procedure in belcsoft.PRG)
*!
*!           Uses: &SARCHIVO              Alias: MENU
*!
*!*****************************************************************************
FUNCTION f1_menuv
PARAMETER sarchivo
IF !FILE(sarchivo)
   RETURN
ENDIF
SELE 0
USE &sarchivo. ORDER menu01 ALIAS MENU
IF !USED()
   CLOSE DATA
   RETURN
ENDIF


*
Gsprogram = []
* Averiguamos opciones principales *
SEEK "00"
nyo      = filmnu + IIF(_WINDOWS OR _MAC,+2,0)
nxo      = colmnu + IIF(_WINDOWS OR _MAC,+2,0)
npos_pan = posven  && 1 derecha ,2 centrado, 3 Izquierda
nlargo   = largo
stitsist = TRIM(detalle)

nancho  = 0
nopcmnp = 0
DIMENSION anombre(10),amenu(10),anivel(10)
* Averiguamos opciones principales *

SEEK "01"
SCAN WHILE nivel = [01] FOR f1userok()
   nopcmnp  = nopcmnp + 1
   IF ALEN(anombre) < nopcmnp
      DIMENSION anombre (nopcmnp+5),amenu(nopcmnp+5),anivel(nopcmnp+5)
   ENDIF
   anombre (nopcmnp)  = TRIM(nombre)
   amenu   (nopcmnp)  = MENU
   anivel  (nopcmnp)  = nivel
   nancho1 = LEN(TRIM(nombre))
   nancho  = MAX(nancho,nancho1)
ENDSCAN

nlargo = nopcmnp

DIMENSION anombre(nopcmnp),amenu(nopcmnp),anivel(nopcmnp)
DO CASE
CASE npos_pan = 1
   nxo = (80 - nancho) + 4
CASE npos_pan = 2
   nxo = ((80 - nancho) + 4)/2
CASE npos_pan = 3
   nxo = 0
OTHER
ENDCASE

ny1    = nyo + nopcmnp + 2
IF ny1 > 21
   ny1 = 21
ENDIF
nx1    = nxo + nancho + 1

nrow   = 1
ncol   = 1

DIMENSION aopc(1,2)
aopc(1,1) = PADC("MENU PRINCIPAL",nx1-nxo)
aopc(1,2) = ""

*
STORE 0 TO nultxi,nultyi,nultys,nultxs
*

*SAVE SCREEN TO SCRMNU
DO WHILE .T.
   DEFINE WINDOW principal FROM nyo,nxo TO ny1,nx1 FLOAT NOCLOSE NONE;
      COLOR SCHEME 2
   ACTIVATE WINDOW principal
   DO WHILE .T.
      SET MESSAGE TO 22
      MENU BAR aopc,1
      MENU  1,anombre,ALEN(anombre)
      READ MENU BAR TO nrow,ncol
      ulttecla =LASTKEY()
      IF ((LASTKEY()>=65 AND LASTKEY()<=90) OR (LASTKEY()>=97 AND LASTKEY()<=122)) AND ncol <= nopcmnp
         KEYBOARD CHR(k_enter)
      ENDIF
      IF INLIST(LASTKEY(),k_esc,k_enter)
         EXIT
      ENDIF
   ENDDO
   **
   DEACTIVATE WINDOW principal
   RELEASE WINDOWS principal
   IF LASTKEY()=k_esc
      EXIT
   ENDIF
   **
   DO CASE
   CASE _DOS or _unix
      DO que_hago WITH anivel(ncol),amenu(ncol),anombre(ncol)
   CASE _WINDOWS or _mac
      DO que_hagow WITH anivel(ncol),amenu(ncol),anombre(ncol)
   ENDCASE

   *REST SCREEN FROM SCRMNU
ENDDO

RETURN
*------------------------------------------------------------------------------*
* Rutina que determina la acci¢n a tomar al momento de escoger una opci¢n del  *
* menu.                                                                        *
*------------------------------------------------------------------------------*
*!*****************************************************************************
*!
*!      Procedure: QUE_HAGO
*!
*!      Called by: F1_MENUV()         (function in belcsoft.PRG)
*!               : QUE_HAGO           (procedure in belcsoft.PRG)
*!
*!          Calls: F1USEROK()         (function in belcsoft.PRG)
*!               : ACHOICE()          (function in belcsoft.PRG)
*!               : QUE_HAGO           (procedure in belcsoft.PRG)
*!               : &GsProgram.PRG
*!
*!           Uses: &SARCHIVO              Alias: MENU
*!
*!*****************************************************************************
PROCEDURE que_hago
*----------------*
PARAMETERS _nivel,_menu,_nombre
PRIVATE snivel,smenu,aopcmnx,nopx,anombrex,nxi,nyi,nxs,nys,aopcx
DIMENSION aopcx(1,2)
DIMENSION aopcmnx(5,2),anombrex(5)
SELE MENU
SEEK _nivel+_menu
snivel = TRAN(VAL(nivel)+1,"@L ##")
smenu  = TRIM(MENU)
nopx = 0
DO CASE
CASE UPPER(opcion) = "EXTERNO"
   curventana = WOUTPUT()
   ACTIVATE SCREEN
   SAVE SCREEN TO panmnu
   ccomando = MLINE(comando,1)
   ! &ccomando.
   IF !USED("MENU")
      SELE 0
      USE &sarchivo. ORDER menu01 ALIAS MENU
      IF !USED()
         CLOSE DATA
         RETURN
      ENDIF
   ENDIF

   RESTORE SCREEN FROM panmnu
   IF !EMPTY(curventana)
      ACTIVATE WINDOW (curventana) SAME
   ENDIF
CASE UPPER(opcion) = "COMANDO"
   curventana = WOUTPUT()
   ACTIVATE SCREEN
   SAVE SCREEN TO panmnu
   ccomando = MLINE(comando,1)
   &ccomando.
   IF !USED("MENU")
      SELE 0
      USE &sarchivo. ORDER menu01 ALIAS MENU
      IF !USED()
         CLOSE DATA
         RETURN
      ENDIF
   ENDIF

   RESTORE SCREEN FROM panmnu
   IF !EMPTY(curventana)
      ACTIVATE WINDOW (curventana) SAME
   ENDIF
CASE UPPER(opcion) = "MENU"
   nanchox = 0
   SEEK snivel+smenu
   SCAN WHILE nivel+MENU = snivel+smenu FOR f1userok()
      nopx = nopx + 1
      IF ALEN(aopcmnx,1) < nopx
         DIMENSION aopcmnx(nopx + 5,2),anombrex(nopx + 5)
      ENDIF
      aopcmnx(nopx,1) = nivel
      aopcmnx(nopx,2) = MENU
      anombrex(nopx ) = TRIM(nombre)
      nanchox1         = LEN(TRIM(nombre))
      nanchox          = MAX(nanchox,nanchox1)
   ENDSCAN
   DIMENSION aopcmnx(nopx,2),anombrex(nopx)
   IF VAL(snivel)<=2
      nxs = 80 - nanchox - 4
      nys = nyo
      nxi = nxs + nanchox + 4
      nyi = IIF(nys + nopx+2>21,21,nys+nopx+2)
   ELSE
      nxs = nultxs - 4
      nys = nultys
      nxi = nxs + nanchox + 4
      nyi = IIF(nys + nopx+2>21,21,nys+nopx+2)
   ENDIF
   aopcx(1,1) =PADC(_nombre,ABS(nxs-nxi))
   aopcx(1,2) = []
   nultxs = nxs
   nultys = nys
   nultxi = nxi
   nultyi = nyi
   nrowx  = 1
   nopcx  = 1
   sventana = "MENU"+snivel
   DO WHILE .T.
      nopcx  = achoice(nys,nxs,nyi,nxi,anombrex,sventana)
      IF nopcx=0
         EXIT
      ENDIF
      DO que_hago WITH aopcmnx(nopcx,1),aopcmnx(nopcx,2),anombrex(nopcx)
   ENDDO
CASE UPPER(opcion) = "PROGRAM"
   curventana = WOUTPUT()
   ACTIVATE SCREEN
   SAVE SCREEN TO panmnu
   Gsprogram = MLINE(comando,1)
   IF EMPTY(Gsprogram)
      WAIT WINDOW [En proceso de implementaci_n] NOWAIT
   ELSE
	   DO &Gsprogram.
	   IF !USED("MENU")
	      SELE 0
	      USE &sarchivo. ORDER menu01 ALIAS MENU
	      IF !USED()
	         CLOSE DATA
	         RETURN
	      ENDIF
	   ENDIF
   ENDIF
   RESTORE SCREEN FROM panmnu
   IF !EMPTY(curventana)
      ACTIVATE WINDOW (curventana) SAME
   ENDIF
   IF gsusuario = [MASTER]
   
   ENDIF

ENDCASE
RETURN
****************
*!*****************************************************************************
*!
*!       Function: ACHOICE
*!
*!      Called by: QUE_HAGO           (procedure in belcsoft.PRG)
*!
*!*****************************************************************************
FUNCTION achoice
****************
PARAMETERS nfilas,ncols,nfilai,ncoli,aopcion,m.ventana
DIMENSION aopcion(nopx)
DEFINE WINDOW (m.ventana) FROM  nfilas,ncols TO nfilai,ncoli FLOAT NOCLOSE NONE;
   COLOR SCHEME 2
ACTIVATE WINDOW (m.ventana)
DO WHILE .T.
   SET MESSAGE TO 22
   MENU BAR aopcx,1
   MENU  1,aopcion,ALEN(aopcion)
   READ MENU BAR TO nrowx,nopcx
   IF INLIST(LASTKEY(),k_esc,k_enter)
      EXIT
   ENDIF
ENDDO
DEACTIVATE WINDOW (m.ventana)
RELEASE WINDOW  (m.ventana)
DO CASE
CASE LASTKEY() = k_esc
   RETURN 0
CASE LASTKEY() = k_enter
   RETURN nopcx
ENDCASE
*-----------------*
*!*****************************************************************************
*!
*!      Procedure: QUE_HAGOW
*!
*!      Called by: F1_MENUV()         (function in belcsoft.PRG)
*!               : QUE_HAGOW          (procedure in belcsoft.PRG)
*!
*!          Calls: F1USEROK()         (function in belcsoft.PRG)
*!               : QUE_HAGOW          (procedure in belcsoft.PRG)
*!               : &GsProgram.PRG
*!               : F1_BASE()          (function in belcsoft.PRG)
*!
*!           Uses: &SARCHIVO              Alias: MENU
*!
*!*****************************************************************************
PROCEDURE que_hagow
*-----------------*
PARAMETERS _nivel,_menu,_nombre
PRIVATE snivel,smenu,aopcmnx,nopx,anombrex,nxi,nyi,nxs,nys,aopcx
DIMENSION aopcx(1,2)
DIMENSION aopcmnx(5,2),anombrex(5)
SELE MENU
SEEK _nivel+_menu
snivel = TRAN(VAL(nivel)+1,"@L ##")
smenu  = TRIM(MENU)
nopx = 0
DO CASE
CASE UPPER(opcion) = "EXTERNO"
   curventana = WOUTPUT()
  **ACTIVATE SCREEN
  **SAVE SCREEN TO panmnu
   ccomando = MLINE(comando,1)
   ! &ccomando.
   IF !USED("MENU")
      SELE 0
      USE &sarchivo. ORDER menu01 ALIAS MENU
      IF !USED()
         CLOSE DATA
         RETURN
      ENDIF
   ENDIF

  **RESTORE SCREEN FROM panmnu
   IF !EMPTY(curventana)
      ACTIVATE WINDOW (curventana) SAME
   ENDIF
CASE UPPER(opcion) = "COMANDO"
   curventana = WOUTPUT()
  **ACTIVATE SCREEN
  **SAVE SCREEN TO panmnu
   ccomando = MLINE(comando,1)
   &ccomando.
   IF !USED("MENU")
      SELE 0
      USE &sarchivo. ORDER menu01 ALIAS MENU
      IF !USED()
         CLOSE DATA
         RETURN
      ENDIF
   ENDIF

  **RESTORE SCREEN FROM panmnu
   IF !EMPTY(curventana)
      ACTIVATE WINDOW (curventana) SAME
   ENDIF
CASE UPPER(opcion) = "MENU"
   nanchox = 0
   SEEK snivel+smenu
   SCAN WHILE nivel+MENU = snivel+smenu FOR f1userok()
      nopx = nopx + 1
      IF ALEN(aopcmnx,1) < nopx
         DIMENSION aopcmnx(nopx + 5,2),anombrex(nopx + 5)
      ENDIF
      aopcmnx(nopx,1) = nivel
      aopcmnx(nopx,2) = MENU
      anombrex(nopx ) = TRIM(nombre)
      nanchox1         = LEN(TRIM(nombre))
      nanchox          = MAX(nanchox,nanchox1)
   ENDSCAN
   DIMENSION aopcmnx(nopx,2),anombrex(nopx)
   IF VAL(snivel)<=2
      nxs = 80 - nanchox - 4
      nys = nyo
      nxi = nxs + nanchox + 4
      nyi = IIF(nys + nopx+2>21,21,nys+nopx+2)
   ELSE
      nxs = nultxs - 4
      nys = nultys
      nxi = nxs + nanchox + 4
      nyi = IIF(nys + nopx+2>21,21,nys+nopx+2)
   ENDIF
   aopcx(1,1) =PADC(_nombre,ABS(nxs-nxi))
   aopcx(1,2) = []
   nultxs = nxs
   nultys = nys
   nultxi = nxi
   nultyi = nyi
   nrowx  = 1
   nopcx  = 1
   sventana = "MENU"+snivel
   DO WHILE .T.
      **nOpcx  = Achoice(nYS,nXS,nYI,nXI,aNomBrex,sVentana)
      **parameters nFilaS,nColS,nFilaI,nColI,aOpcion,m.ventana
      **DIMENSION aOpcion(nOpx)
      DEFINE WINDOW (sventana) FROM  nys,nxs TO nyi,nxi FLOAT NOCLOSE NONE;
         COLOR SCHEME 2
      ACTIVATE WINDOW (sventana)
      DO WHILE .T.
         SET MESSAGE TO 22
         MENU BAR aopcx,1
         MENU  1,anombrex,ALEN(anombrex)
         READ MENU BAR TO nrowx,nopcx
         IF INLIST(LASTKEY(),k_esc,k_enter)
            EXIT
         ENDIF
      ENDDO
      DEACTIVATE WINDOW (sventana)
      RELEASE WINDOW  (sventana)
      DO CASE
      CASE LASTKEY() = k_esc
         nopcx =0
      CASE LASTKEY() = k_enter
      ENDCASE
      IF nopcx=0
         EXIT
      ENDIF
      DO que_hagow WITH aopcmnx(nopcx,1),aopcmnx(nopcx,2),anombrex(nopcx)
   ENDDO
CASE UPPER(opcion) = "PROGRAM"
   curventana = WOUTPUT()
**  ACTIVATE SCREEN
**  SAVE SCREEN TO panmnu
   Gsprogram = MLINE(comando,1)
   IF EMPTY(Gsprogram)
      WAIT WINDOW [En proceso de implementaci_n] NOWAIT
   ELSE
	   DO &Gsprogram.
	   IF !USED("MENU")
	      SELE 0
	      USE &sarchivo. ORDER menu01 ALIAS MENU
	      IF !USED()
	         CLOSE DATA
	         RETURN
	      ENDIF
	   ENDIF
	endif		
   DO f1_base WITH stitsist,[],[],[]
 ** RESTORE SCREEN FROM panmnu
   IF !EMPTY(curventana)
      ACTIVATE WINDOW (curventana) SAME
   ENDIF

   IF gsusuario = [MASTER]

   ENDIF

ENDCASE
RETURN

*!*****************************************************************************
*!
*!      Procedure: F1_ALERT
*!
*!      Called by: F1_ERROR           (procedure in belcsoft.PRG)
*!               : BTN_VAL            (procedure in belcsoft.PRG)
*!               : F1_RLOCK()         (function in belcsoft.PRG)
*!
*!*****************************************************************************
PROCEDURE f1_alert
* muestra un mensaje de error, en una ventana con el ancho
* necesario.  Cada ";" en la cadena de mensaje representa una nueva linea.
PARAMETERS strg,m.tipo_alr
PRIVATE m.in_talk, m.numlines, m.i, m.remain, m.in_cons, m.entonces

IF TYPE("Tipo_ALR")=[C]
   DO CASE
   CASE m.tipo_alr = [ERROR]
      m.tipo_alr = 1
   CASE m.tipo_alr = [SI_O_NO]
      m.tipo_alr = 2
   CASE m.tipo_alr = [MENSAJE]
      m.tipo_alr = 3
   CASE m.tipo_alr = [PROCESO]
      m.tipo_alr = 4
   CASE m.tipo_alr = [REINTENTAR]
      m.tipo_alr = 5
   OTHER
      m.tipo_alr = 6
   ENDCASE
ELSE


ENDIF

m.in_talk = SET('TALK')
SET TALK OFF
m.in_cons = SET('CONSOLE')

m.numlines = OCCURS(';',m.strg) + 1

DIMENSION alert_arry[m.numlines]
m.remain = m.strg
m.maxlen = 0
FOR i = 1 TO m.numlines
   IF AT(';',m.remain) > 0
      alert_arry[i] = SUBSTR(m.remain,1,AT(';',m.remain)-1)
      alert_arry[i] = CHRTRAN(alert_arry[i],';','')
      m.remain = SUBSTR(m.remain,AT(';',m.remain)+1)
   ELSE
      alert_arry[i] = m.remain
      m.remain = ''
   ENDIF
   IF LEN(alert_arry[i]) > SCOLS() - 6
      alert_arry[i] = SUBSTR(alert_arry[i],1,SCOLS()-6)
   ENDIF
   IF LEN(alert_arry[i]) > m.maxlen
      m.maxlen = LEN(alert_arry[i])
   ENDIF
ENDFOR

m.maxlen  = MAX(54,m.maxlen)

m.top_row = INT( (SROWS() - 4 - m.numlines) / 2)
m.bot_row = m.top_row + 3 + m.numlines

m.top_col = INT((SCOLS() - m.maxlen - 6) / 2)
m.bot_col = m.top_col + m.maxlen + 6


vent_act = WOUTPUT()
IF !EMPTY(vent_act)
**   DEACTIVATE WINDOW (vent_act)
ENDIF
private m.que_color,m.rgb_color
do case
   case m.tipo_alr = 1
      m.que_color= 12
      m.rgb_color= [rgb(255,255,0,255,0,0)]
   case m.tipo_alr = 2
      m.que_color= 1
      m.rgb_color= [rgb(255,0,0,0,223,223)]
   case m.tipo_alr = 3
      m.que_color= 5
      m.rgb_color= [rgb(0,0,0,192,192,192)]
   case m.tipo_alr = 4
      m.que_color= 13
      m.rgb_color= [rgb(255,255,255,0,0,128)]
   case m.tipo_alr = 5
      m.que_color= 2
      m.rgb_color= [rgb(255,255,255,255,0,255)]
   case m.tipo_alr = 6
      m.que_color= 11
      m.rgb_color= [rgb(,,,0,255,0)]
endcase
DO CASE 
	case _Unix or _dos
		DEFINE WINDOW alert FROM m.top_row,m.top_col TO m.bot_row+1,m.bot_col;
		   DOUBLE COLOR SCHEME (M.QUE_COLOR)
		ACTIVATE WINDOW alert
	CASE _WINDOWS OR _MAC
		DEFINE WINDOW alert FROM m.top_row,m.top_col TO m.bot_row+1,m.bot_col;
		   DOUBLE COLOR (M.rgb_COLOR)
		ACTIVATE WINDOW alert
		
ENDCASE
FOR m.i = 1 TO m.numlines
   @ m.i,3 SAY PADC(alert_arry[m.i],m.maxlen)
ENDFOR

CLEAR TYPEAHEAD
SET CONSOLE OFF
*m.keycode = 0
*DO WHILE m.keycode = 0
*   m.keycode = INKEY(0,'HM')
*ENDDO
SET CONSOLE ON
m.entonces = 1
m.cancelar = 1
??CHR(7)+CHR(7)
DO CASE
CASE m.tipo_alr = 1
   @ m.i+1,03 GET m.entonces ;
      PICTURE "@*HT \!\<Cancelar;\<Suspender;\<Ignorar;\<Reintentar" ;
      DEFAULT 1
   m.cancelar = 1
CASE m.tipo_alr = 2
   @ m.i+1,(m.maxlen-10)/2 GET m.entonces ;
      PICTURE "@*HT \!\<Si;\<No";
      DEFAULT 1
   m.cancelar = 2
CASE m.tipo_alr = 3
   @ m.i+1,(m.maxlen-11)/2 GET m.entonces ;
      PICTURE "@*HT \!\<Continuar";
      DEFAULT 1
   m.cancelar = 1
CASE m.tipo_alr = 4
   @ m.i+1,(m.maxlen-21)/2 GET m.entonces ;
      PICTURE "@*HT \!\<Aceptar;\<Cancelar";
      DEFAULT 1
   m.cancelar = 2
CASE m.tipo_alr = 5
   @ m.i+1,(m.maxlen-24)/2 GET m.entonces ;
      PICTURE "@*HT \!\<Cancelar;\<Reintentar";
      DEFAULT 1
   m.cancelar = 1
CASE m.tipo_alr = 6
   @ m.i+1,(m.maxlen-12)/2 GET m.entonces ;
      PICTURE "@*HT \!\<Cancelar";
      DEFAULT 1
   m.cancelar = 1
ENDCASE
READ CYCLE MODAL

UltTecla = LASTKEY()

IF LASTKEY()=27
   m.entonces = m.cancelar
ENDIF
RELEASE WINDOW alert
IF m.in_talk = "ON"
   SET TALK ON
ENDIF
IF m.in_cons = "OFF"
   SET CONSOLE OFF
ENDIF
IF !EMPTY(vent_act)
   ACTIVATE WINDOW (vent_act) SAME
   SHOW WINDOW (Vent_act) TOP
ENDIF
RETURN m.entonces
*-----------------------------------------------------------------*
*                                                                 *
*       Procedure: F1_CAJA                                        *
*                                                                 *
*-----------------------------------------------------------------*
*!*****************************************************************************
*!
*!      Procedure: F1_CAJA
*!
*!      Called by: GER_S_VB.PRG
*!               : F0EMPRES()         (function in belcsoft.PRG)
*!               : F1_INDEX()         (function in belcsoft.PRG)
*!               : F1_RLOCK()         (function in belcsoft.PRG)
*!               : F1MSGERR           (procedure in belcsoft.PRG)
*!               : F1QH()             (function in belcsoft.PRG)
*!               : TPOCMB             (procedure in GER_S_VB.PRG)
*!
*!*****************************************************************************
PROCEDURE f1_caja
* Define una ventana de usuario

PARAMETER m.largo, m.ancho, m.nombre, m.color,m.tit,m.dverti,m.dhoriz
PRIVATE m.desdfil, m.desdcol, m.hastfil, m.hastcol

m.desdfil = INT((SROW()-m.largo)/2)
m.desdcol = INT((SCOL()-m.ancho)/2)
m.hastfil = m.desdfil + m.largo
m.hastcol = m.desdcol + m.ancho

IF PARAMETERS() > 5
   IF (m.desdfil + m.dverti)>=0  AND (m.desdfil + m.dverti)<=24
      m.desdfil = m.desdfil + m.dverti
      m.hastfil = m.hastfil + m.dverti
   ENDIF
ENDIF

IF PARAMETERS() > 6
   IF (m.desdcol + m.dhoriz)>=0  AND (m.desdcol + m.dhoriz)<=24
      m.desdcol = m.desdcol + m.dhoriz
      m.hastcol = m.hastcol + m.dhoriz
   ENDIF
ENDIF

DEFINE WINDOW (m.nombre);
   FROM m.desdfil, m.desdcol TO m.hastfil, m.hastcol;
   FLOAT NOGROW NOCLOSE NOZOOM SHADOW DOUBLE;
   COLOR SCHEME (m.color);
   TITLE (m.tit)
RETURN



*!*****************************************************************************
*!
*!      Procedure: F1_ERROR
*!
*!      Called by: belcsoft.PRG
*!
*!          Calls: F1_ALERT           (procedure in belcsoft.PRG)
*!
*!*****************************************************************************
PROCEDURE f1_error
PARAMETERS e_program,e_message,e_source,e_lineno,e_error
m.e_source = ALLTRIM(m.e_source)
x_errline  = "No. Linea: "
x_errprg   = "Programa: "
x_errerr   = "  Error: "
x_errsrc   = " Origen: "
x_dbf      = "Archivo: "
m.que_hago = 1
DO CASE
CASE m.e_error = 1707     && CDX not found.  Ignore it.
   RETURN
OTHERWISE
   m.que_hago = f1_alert(x_errline + ALLTRIM(STR(m.e_lineno,5))+';' ;
      +x_errprg + m.e_program +';' ;
      +x_errerr + m.e_message +';' ;
      +x_errsrc + IIF(LEN(m.e_source)<50,;
      m.e_source,SUBSTR(m.e_source,1,50)+'...')+';';
      +x_dbf    + SUBSTR(DBF()+[ ]+ALIAS(),1,50),1)

ENDCASE
DO CASE
CASE m.que_hago = 1
   swinact = WOUTPUT()
   IF !EMPTY(swinact)
      DEACTIVATE WINDOW (swinact)
   ENDIF
   IF FILE(PATHDEF+[\VETT.BS])
*!*			DO F1CANCEL   		
   ELSE
		CLOSE DATA
		CLEAR GETS
		CLEAR PROMPT
		CLEAR WINDOWS
		SET PRINT OFF
		RETURN TO MASTER
   ENDIF
CASE m.que_hago = 2
   swinact = WOUTPUT()
   ACTIVATE SCREEN
   @ 22,0  CLEAR
   WAIT WINDOW "Digite RESUME para retornar" NOWAIT
   *SUSPEND
*!*	   DO F1SUSPEN
   IF !EMPTY(swinact)
      ACTIVATE WINDOW (swinact) SAME
   ENDIF
CASE m.que_hago = 3
   RETURN
CASE m.que_hago = 4
   RETRY
ENDCASE
RETURN
******************************
*                            *
*                            *
*   FUNCTION F0EMPRES        *
*                            *
******************************
*!*****************************************************************************
*!
*!       Function: F0EMPRES
*!
*!      Called by: GER_S_VB.PRG
*!
*!          Calls: F1_CAJA            (procedure in belcsoft.PRG)
*!               : VCONTROL()         (function in belcsoft.PRG)
*!
*!           Uses: EMPRESAS.DBF           Alias: EMPR
*!
*!      CDX files: EMPRESAS.CDX
*!
*!*****************************************************************************
FUNCTION f0empres

SELE 0
USE empresas ORDER empr01 ALIAS empr
IF !USED()
   CLOSE DATA
   RETURN .F.
ENDIF

xwhile= [.T.]
xfor   = [.T.]

PRIVATE nancho,nancho1

scadena ='[ ]+CodCia+[ ]+NomCia'
DIMENSION alindat(2),arecno(2)
STORE [] TO alindat
nit     = 0
nancho = 0

GO TOP
SCAN WHILE EVAL(xwhile) FOR EVAL(xfor)
   nit = nit + 1
   IF ALEN(alindat)<nit
      DIMENSION alindat(nit + 5),arecno(nit + 5)
   ENDIF
   alindat(nit) = &scadena
   arecno (nit) = RECNO()
   nancho1         = LEN(RTRIM(alindat(nit)))
   nancho          = MAX(nancho,nancho1)
ENDSCAN

snombre= [CONSULTA]
nlargo = nit    + 5
nancho = nancho + 6
IF nancho<30
   nancho = 30
ENDIF
stit   = [ COMPA¥IAS ]
ccolor = 2


DO f1_caja WITH nlargo,nancho,snombre,ccolor,stit

ACTIVATE WINDOW (snombre) NOSHOW
m.control = 1
DIMENSION alindat(nit),arecno(nit)
@ 00,00 SAY PADC(stit,nancho-1) COLOR SCHEME 5
@ 00,00 GET nopc FROM alindat SIZE nlargo-1 ,nancho-1 PICT "@^" DEFAULT 1 COLOR SCHEME 2
@ 04,(nancho - 20)/2 GET m.control PICTURE "@*HT \!\<Aceptar;\<Cancelar" ;
   DEFAULT 1 VALID vcontrol(m.control)

READ CYCLE WHEN F()

DEACTIVATE WINDOW (snombre)
RELEASE WINDOW (snombre)

IF m.control = 1
   ulttecla = LASTKEY()
ENDIF
IF m.control = 2
   ulttecla = k_esc
ENDIF
IF ulttecla = k_esc
   nopc = 0
ENDIF
IF ulttecla#k_esc
   GO arecno(nopc)
ENDIF
IF nopc > 0
   gscodcia  = codcia
   gsruccia  = ruccia
   gssigcia  = sigcia
   gsnomcia  = nomcia
   gsdircia  = dircia
   IF _UNIX OR _DOS
      gslogcia  = LOGO
   ELSE
      **GsLogCia  = Logow
   ENDIF
   tspathcia = "cia"+gscodcia
   DO CASE
   CASE _UNIX OR _DOS
      @ 19,16 SAY " Compa¤ia : " COLOR SCHEME 15
      @ 19,29 SAY gscodcia+" " + gsnomcia COLOR SCHEME 15
   CASE _WINDOWS OR _MAC
      PRIVATE m.titulo
      m.titulo = [BS-INFO - (c) BELCSOFT - VETT 1995-1998]
      m.arcbmp=m.pathlib+[bmps\]+[BS-INFO2.bmp]
      MODIFY WINDOW SCREEN TITLE m.titulo FILL FILE (m.arcbmp)
      lscadcia=TRIM("Compañia : "+gscodcia+" "+gsnomcia)
      @29,(WCOL()-LEN(lscadcia))/2 SAY lscadcia FONT [ARIAL],8 STYLE [BN]  COLOR SCHEME 15

   ENDCASE
   tspathdbf  = pathdef+"\"+tspathcia
   SET DEFAULT TO (tspathdbf)
   RELEASE ALL LIKE t*
ENDIF
IF USED("EMPR")
   SELE empr
   USE
ENDIF
RETURN (nopc>0)
*****************
*!*****************************************************************************
*!
*!       Function: VCONTROL
*!
*!      Called by: GER_S_VB.PRG
*!               : F0EMPRES()         (function in belcsoft.PRG)
*!
*!          Calls: MES()              (function in belcsoft.PRG)
*!
*!*****************************************************************************
FUNCTION vcontrol
*****************
PARAMETER opc
SHOW GETS
ulttecla = IIF(opc=1,LASTKEY(),k_esc)
RETURN .T.
**********
*!*****************************************************************************
*!
*!       Function: F
*!
*!*****************************************************************************
FUNCTION F
**********
_CUROBJ = 2
RETURN .T.
******************************************
*                                        *
*        FUNCTION F1_EDIT                *
*                                        *
*  EDICION DE UNA BASE DE DATOS          *
*                                        *
******************************************
*!*****************************************************************************
*!
*!      Procedure: F1_EDIT
*!
*!      Called by: ADMMTABL           (procedure in belcsoft.PRG)
*!
*!          Calls: &PMOSTRAR.PRG
*!               : BTN_VAL            (procedure in belcsoft.PRG)
*!
*!*****************************************************************************
PROCEDURE f1_edit
PARAMETERS ppidllave,pmostrar,pmodificar,peliminar,pimprimir,svllave,scllave,controles,plocalizar,picclave,piccmpad1,msgcmpad1,nomcmpad1
IF !EMPTY(picclave) AND PARAMETERS()>=10
   spic_clave = "@*CN "+LEFT(picclave,10)
ELSE
   spic_clave = "@*CN Cla\<ve"
ENDIF

IF PARAMETERS() >= 11  AND !EMPTY(piccmpad1)
   spic_cmpad1 = "@*HN "+LEFT(piccmpad1,09)
   haycmpad1 = .T.
ELSE
   spic_cmpad1 = "@*HN "+PADC("",10)
   haycmpad1 = .F.
ENDIF





IF PARAMETERS() >= 12 AND !EMPTY(msgcmpad1)
ELSE
   msgcmpad1 = "Boton de control disponible para activar clave alternativa."
ENDIF

IF PARAMETERS() >= 13 AND !EMPTY(nomcmpad1)
   haycmpad1 = (haycmpad1 AND .T.)
ELSE
   haycmpad1 = .F.
ENDIF




PRIVATE    opc,sesrgv,seleccion
PRIVATE    lver,ledita,lchequea,cvctrl


IF _DOS OR _UNIX
	ACTIVATE SCREEN
ELSE
ENDIF
*SET MESSAGE TO 23

m.estoy  = []
*
**************************************************************************

IF EMPTY(controles)
   RETURN 0
ENDIF


opc       = 1
seleccion = .T.
scllave    = TRIM(scllave)
IF svllave==[]
   sesrgv    = " .NOT. EOF()"
   IF ! EOF()
      GOTO TOP
   ENDIF
   haycmpad1 = .F.
ELSE
   sesrgv    = "&sVLlave = sCLlave"
   IF ! &svllave = scllave
      SEEK scllave
   ENDIF
ENDIF

*
**************************************************************************
* Rutina Principal
*

crear  = .F.
lver = .T.
m.pll_btn = .F.
cvctrl    = []


IF lver
   m.estoy = [MOSTRANDO]
   IF &sesrgv
      DO &pmostrar
   ELSE
   ENDIF
   lver = .F.
ENDIF
DO CASE
CASE _WINDOWS OR _MAC

CASE _DOS OR _UNIX

ENDCASE
IF EMPTY(WONTOP())
   nfedit=SROW()-2
ELSE
   nfedit=WROW()-2
ENDIF
@ nfedit,1 GET m.top_btn ;
   PICTURE "@*HN \<1" ;
   SIZE 1,3,0 ;
   DEFAULT 1 ;
   VALID btn_val([TOP]) ;
   FONT 'Lucida Console',10;
   MESSAGE 'Cambia al primer registro.' 

@ nfedit,4 GET m.prev_btn ;
   PICTURE "@*HN \<-1" ;
   SIZE 1,4,0 ;
   DEFAULT 1 ;
   VALID btn_val('PREV') ;
   FONT 'Lucida Console',10;
   MESSAGE 'Cambia al registro anterior.'

@ nfedit,8 GET m.next_btn ;
   PICTURE "@*HN \<+1" ;
   SIZE 1,4,0 ;
   DEFAULT 1 ;
   VALID btn_val('NEXT') ;
   FONT 'Lucida Console',10;
   MESSAGE 'Cambia al siguiente registro.'

@ nfedit,12 GET m.end_btn ;
   PICTURE "@*HN \<0" ;
   SIZE 1,3,0 ;
   DEFAULT 1 ;
   VALID btn_val('END') ;
   FONT 'Lucida Console',10;
   MESSAGE 'Cambia al £ltimo registro.'

@ nfedit,16 GET m.pll_btn ;
   PICTURE spic_clave ;
   SIZE 1,9 ;
   DEFAULT 0 ;
   VALID btn_val('READKEY');
   FONT 'Lucida Console',10;
   MESSAGE 'Clave de la tabla.'

@ nfedit,29 GET m.ca1_btn ;
   PICTURE spic_cmpad1 ;
   SIZE 1,08 ;
   DEFAULT 1 ;
   WHEN haycmpad1 VALID btn_val('CMPAD1') ;
   FONT 'Lucida Console',10;
   MESSAGE msgcmpad1

@ nfedit,39 GET add_btn ;
   PICTURE "@*HN \<Crea" ;
   SIZE 1,6,0 ;
   DEFAULT 1 ;
   WHEN [C]$controles VALID btn_val('ADD') ;
   FONT 'Lucida Console',10;
   MESSAGE 'Agrega un nuevo registro.' &&;   COLOR SCHEME 1

@ nfedit,46 GET m.edi_btn ;
   PICTURE "@*HN \<Edita" ;
   SIZE 1,7,0 ;
   DEFAULT 1 ;
   WHEN [M]$controles VALID btn_val('EDIT') ;
   MESSAGE 'Edita el registro actual.' ;
   FONT 'Lucida Console',10 && ;   COLOR SCHEME 1

@ nfedit,54 GET m.del_btn ;
   PICTURE "@*HN \<Borra" ;
   SIZE 1,7,0 ;
   DEFAULT 1 ;
   WHEN [A]$controles VALID btn_val('DELETE') ;
   MESSAGE 'Elimina el registro actual.' ;
   FONT 'Lucida Console',10  &&;   COLOR SCHEME 1

@ nfedit,62 GET m.prnt_btn ;
   PICTURE "@*HN \<Infor." ;
   SIZE 1,8,0 ;
   DEFAULT 1 ;
   WHEN [R]$controles VALID btn_val('PRINT') ;
   MESSAGE 'Emitir documento o listado.' ;
   FONT 'Lucida Console',10  && ;   COLOR SCHEME 1

@ nfedit,71 GET m.exit_btn ;
   PICTURE "@*HN \<Cerrar" ;
   SIZE 1,8,0 ;
   DEFAULT 1 ;
   VALID btn_val('EXIT') ;
   MESSAGE 'Cierra la pantalla.' ;
   FONT 'Lucida Console',10  && ;  COLOR SCHEME 1
   
READ CYCLE NOLOCK 
IF _unix OR _dos
	CLOSE DATA
ENDIF

RETURN
*****************
*!*****************************************************************************
*!
*!      Procedure: BTN_VAL
*!
*!      Called by: F1_EDIT            (procedure in belcsoft.PRG)
*!               : REFRESH            (procedure in belcsoft.PRG)
*!
*!          Calls: LOC_DLOG           (procedure in belcsoft.PRG)
*!               : &PIMPRIMIR.PRG
*!               : &PMOSTRAR.PRG
*!               : &PPIDLLAVE.PRG
*!               : ESTADO             (procedure in belcsoft.PRG)
*!               : F1_ALERT           (procedure in belcsoft.PRG)
*!               : &PELIMINAR.PRG
*!               : F1MSGERR           (procedure in belcsoft.PRG)
*!               : &PMODIFICAR.PRG
*!
*!*****************************************************************************
PROCEDURE btn_val
*****************
PARAMETER m.btnname
m.pll_btna = m.pll_btn
DO CASE
CASE m.btnname='EXIT'
   CLEAR READ
   IF _UNIX OR _DOS
	   CLOSE DATA
   ENDIF
   CLEAR
   RETURN
CASE m.btnname='PREV'
   IF &sesrgv .AND. ! BOF()
      SKIP -1
      IF .NOT. &sesrgv
         SKIP
      ENDIF
   ELSE
      SEEK scllave
   ENDIF
   IF BOF()
      WAIT WINDOW c_topfile NOWAIT
      GO TOP
   ENDIF
   lver = .T.
CASE m.btnname='NEXT'
   IF &sesrgv
      SKIP
      IF .NOT. &sesrgv .OR. EOF()
         SKIP -1
      ENDIF
   ELSE
      SEEK scllave
   ENDIF
   IF EOF()
      WAIT WINDOW c_endfile NOWAIT
      GO BOTTOM
   ENDIF
   lver = .T.
CASE  m.btnname='TOP'
   IF scllave== ""
      GOTO TOP
   ELSE
      SEEK scllave
   ENDIF
   WAIT WINDOW c_topfile NOWAIT
   lver = .T.
CASE  m.btnname='END'
	
   IF scllave==""
      GOTO BOTTOM
   ELSE
      SEEK scllave + CHR(255)
      IF !FOUND() AND RECNO(0)>0
         GO RECNO(0)
         IF .NOT. &sesrgv .OR. EOF()
            SKIP -1
         ENDIF
      ENDIF
   ENDIF
   WAIT WINDOW c_endfile NOWAIT
   lver = .T.
CASE m.btnname='LOCATE'
   cvctrl = [L]
   DO loc_dlog

CASE m.btnname='ADD'
   cvctrl = [C]
   GOTO BOTTOM
   IF .NOT. EOF()
      SKIP
   ENDIF
   lchequea    = .T.
   m.pll_btn = .T.
   seleccion = .T.
   ledita    = .T.
   crear     = .T.
   *DO REFRESH
   SHOW GETS
CASE m.btnname='EDIT'
   cvctrl = [M]
   IF &sesrgv .AND. !m.pll_btn
      seleccion = .T.
      ledita    = .T.
      m.pll_btn = .F.
   ELSE
      ledita    = .T.
      seleccion = .F.
      lchequea    = .T.
   ENDIF
   *DO REFRESH
CASE m.btnname='DELETE'
   cvctrl='A'
   IF &sesrgv .AND. !m.pll_btn
      seleccion = .T.
      ledita    = .F.
      lchequea    = .T.
      m.pll_btn = .F.
   ELSE
      seleccion = .F.
      ledita    = .F.
      lchequea    = .T.
      m.pll_btn = .T.
   ENDIF
   *DO REFRESH
CASE m.btnname='PRINT'
   cvctrl='R'
   DO &pimprimir
   DO &pmostrar
   ledita    = .F.
   seleccion = .T.
CASE m.btnname='READKEY'
   SHOW OBJECT _CUROBJ
   RETURN .F.
CASE m.btnname='CMPAD1'
   SHOW OBJECT _CUROBJ
   m.estoy = [EDITCLAVE]
   DO &pmostrar
   ulttecla    = LASTKEY()
   IF ulttecla = 27
      RETURN
   ENDIF
   m.pll_btn   = .T.
   ledita      = .T.
   lchequea      = .T.
   scllave    = TRIM(scllave)
   sesrgv    = "&sVLlave = sCLlave"
   IF ! &svllave = scllave
      SEEK scllave
   ENDIF
ENDCASE

IF lver
   IF &sesrgv
      m.estoy = "MOSTRANDO"      
      DO &pmostrar      && Pinta la pantalla con el registro actual
   ELSE
   ENDIF
   lver = .F.
   RETURN
ENDIF



IF m.pll_btn
   lseguir = .T.
   DO WHILE lseguir
	  ulttecla = 0
	  m.estoy  = [PIDLLAVE]
      DO &ppidllave
      ulttecla = IIF(ulttecla#0,ulttecla,LASTKEY())
      IF ulttecla = 27
         ledita    = .F.
         seleccion = .T.
         EXIT
      ENDIF
      IF EMPTY(cvctrl)
         IF EOF()
            cvctrl = [C]
         ELSE
            cvctrl = [M]
         ENDIF
      ENDIF

      DO estado WITH cvctrl
      lseguir = .F.
      IF lchequea
         IF cvctrl='C'
            ok = .NOT. &sesrgv
         ELSE
            ok = &sesrgv
         ENDIF
         IF ok
            IF FOUND()
               m.estoy = [MOSTRANDO]
               DO &pmostrar
               IF cvctrl='A'
*                  IF f1_alert("Desea anular el registro ?",2)=1
				  IF MESSAGEBOX('Desea anular el registro ?',32+4,'ANULACION DE REGISTRO')=6
                     DO &peliminar
                     DO &pmostrar
                  ENDIF
               ENDIF
            ENDIF
            EXIT
         ENDIF
         IF &sesrgv
            DO f1msgerr WITH "Registro existente"

         ELSE
            DO f1msgerr WITH "Registro no existente"
         ENDIF
         lseguir = .T.
      ENDIF
   ENDDO

ENDIF

IF cvctrl='A' .AND. .NOT. m.pll_btn
*   IF f1_alert("Desea anular el registro ?",2)=1
	IF MESSAGEBOX('Desea anular el registro ?',32+4,'ANULACION DE REGISTRO')=6
	    DO &peliminar
	    m.estoy = [MOSTRANDO]
	    DO &pmostrar
	ENDIF
   seleccion  = .T.
ENDIF

IF ledita
   DO WHILE .T.
      ulttecla = 0
      m.estoy  = [EDITANDO]
      DO &pmodificar
      ulttecla = LASTKEY()
      DO CASE
      CASE ulttecla = k_pgup
         SKIP -1
         IF .NOT. &sesrgv .OR. BOF()
            SKIP
         ENDIF
         IF &sesrgv
            m.estoy = [MOSTRANDO]
            DO &pmostrar       && Pinta la pantalla con el registro actual
         ENDIF
         LOOP
      CASE ulttecla = k_pgdn
         SKIP
         IF .NOT. &sesrgv .OR. EOF()
            SKIP -1
         ENDIF
         IF &sesrgv
            m.estoy = [MOSTRANDO]
            DO &pmostrar       && Pinta la pantalla con el registro actual
         ENDIF
         LOOP
      CASE ulttecla = k_esc
         IF &sesrgv
            m.estoy = [MOSTRANDO]
            DO &pmostrar       && Pinta la pantalla con el registro actual
         ENDIF
         EXIT
      OTHERWISE
         IF &sesrgv
            m.estoy = [MOSTRANDO]
            DO &pmostrar       && Pinta la pantalla con el registro actual
         ENDIF
         EXIT
      ENDCASE
   ENDDO
ENDIF
m.pll_btn = m.pll_btna
*IF m.Ca1_Btn
*   m.Pll_Btn = .F.
*   m.Ca1_Btn = .F.
*ENDIF
SHOW GETS
RETURN
******************
*!*****************************************************************************
*!
*!      Procedure: LOC_DLOG
*!
*!      Called by: BTN_VAL            (procedure in belcsoft.PRG)
*!
*!          Calls: FLDLIST()          (function in ?)
*!               : OBJVAR()           (function in ?)
*!
*!*****************************************************************************
PROCEDURE loc_dlog
******************
PRIVATE gfields,i
DEFINE WINDOW wzlocate FROM 1,1 TO 15,40;
   SYSTEM GROW CLOSE ZOOM FLOAT;
   SHADOW COLOR SCHEME 10
MOVE WINDOW wzlocate CENTER
m.gfields=SET('FIELDS',2)
IF !EMPTY(RELATION(1))
   SET FIELDS ON
   IF m.gfields # 'GLOBAL'
      SET FIELDS global
   ENDIF
   IF EMPTY(fldlist())
      m.i=1
      DO WHILE !EMPTY(objvar(m.i))
         IF ATC('M.',objvar(m.i))=0
            SET FIELDS TO (objvar(m.i))
         ENDIF
         m.i = m.i + 1
      ENDDO
   ENDIF
ENDIF
BROWSE WINDOW wzlocate NOEDIT NODELETE ;
   NOMENU TITLE c_brtitle
SET FIELDS &gfields
SET FIELDS OFF
RELEASE WINDOW wzlocate
RETURN
*****************
*!*****************************************************************************
*!
*!      Procedure: REFRESH
*!
*!          Calls: BTN_VAL            (procedure in belcsoft.PRG)
*!
*!*****************************************************************************
PROCEDURE REFRESH
*****************
DO CASE
CASE !crear  AND RECCOUNT()=0
   SHOW GETS DISABLE
   SHOW GET exit_btn ENABLE
CASE !crear
   SHOW GET add_btn DISABLE
   SHOW GET del_btn DISABLE
   SHOW GET edit_btn DISABLE
CASE (RECCOUNT()=0 OR EOF()) AND crear
   SHOW GETS DISABLE
   SHOW GET add_btn ENABLE
   SHOW GET exit_btn ENABLE
CASE ledita
   *SHOW GET find_drop DISABLE
   SHOW GET top_btn DISABLE
   SHOW GET prev_btn DISABLE
   SHOW GET loc_btn DISABLE
   SHOW GET next_btn DISABLE
   SHOW GET end_btn DISABLE
   SHOW GET add_btn DISABLE
   SHOW GET prnt_btn DISABLE
   SHOW GET exit_btn DISABLE
   SHOW GET edit_btn,1 PROMPT "\<Guardar"
   SHOW GET del_btn,1 PROMPT "\<Cancelar"
   ON KEY LABEL ESCAPE DO btn_val WITH 'DELETE'
   RETURN
OTHERWISE
   SHOW GET edit_btn,1 PROMPT "E\<ditar"
   SHOW GET del_btn,1 PROMPT "\<Eliminar"
   SHOW GETS ENABLE
ENDCASE
ON KEY LABEL ESCAPE
****************
*!*****************************************************************************
*!
*!      Procedure: ESTADO
*!
*!      Called by: BTN_VAL            (procedure in belcsoft.PRG)
*!
*!*****************************************************************************
PROCEDURE estado
****************
PARAMETER x
PRIVATE s
DO CASE
CASE x=[C]
   s = [Crear]
CASE x=[M]
   s = [Modificar]
CASE x=[R]
   s = [Informe]
CASE x=[A]
   s = [Eliminar]
OTHER s= []
ENDCASE

WAIT WINDOW s NOWAIT TIMEOUT 1
RETURN
****************************
*
* PROCEDURE F1_BASE
*
****************************
*!*****************************************************************************
*!
*!       Function: F1_BASE
*!
*!      Called by: PRESENTA           (procedure in belcsoft.PRG)
*!               : GER_S_VB.PRG
*!               : QUE_HAGOW          (procedure in belcsoft.PRG)
*!               : F1_INDEX()         (function in belcsoft.PRG)
*!               : ADMMTCMB           (procedure in belcsoft.PRG)
*!               : ADMMTABL           (procedure in belcsoft.PRG)
*!               : ADMCMBST           (procedure in belcsoft.PRG)
*!               : ADMMSEDE           (procedure in belcsoft.PRG)
*!               : ADMMTSIS           (procedure in belcsoft.PRG)
*!
*!*****************************************************************************
FUNCTION f1_base
PARAMETERS ctopi,ctopd,cfooti,cfootd,NLOCTIT

DO CASE
CASE _DOS OR _UNIX
   FOR i = 0 TO SROW()-1
      @ i,0 SAY REPLICATE(CHR(219),SCOL()) COLOR (c_fondo)
   ENDFOR
   @0,0 SAY REPLI(" ",SCOL()) COLOR (c_linea)

   @0,0 SAY PADR(ctopi,SCOL()/2) COLOR (c_linea)
   @0,SCOL()/2 SAY PADL(ctopd,SCOL()/2) COLOR (c_linea)

   @SROW()-1,0 SAY REPLI(" ",SCOL()) COLOR (c_linea)

   @SROW()-1,0        SAY PADR(cfooti,SCOL()/2) COLOR (c_linea)
   @SROW()-1,SCOL()/2 SAY PADL(cfootd,SCOL()/2) COLOR (c_linea)
CASE _WINDOWS OR _MAC
	   PRIVATE m.titulo
*!*	   m.titulo = PADR(ctopi,SCOL()/2)+[ ]+PADR(ctopd,SCOL()/2)
		m.titulo = PADR(ctopi,40)+[ ]+PADR(ctopd,40)
*!*	   m.arcbmp=m.pathlib+[bmps\]+[bs-info2.bmp]
*!*	   MODIFY WINDOW SCREEN TITLE m.titulo FILL FILE (m.arcbmp)
*!*	   IF !lPrtLogo
*!*	      =INKEY(3,[M])
*!*	      lPrtLogo = .t.
*!*	   ENDIF
		DEFINE WINDOW __WFondo AT 05,10 SIZE 40,115 NOCLOSE FLOAT GROW ;
		 TITLE (m.titulo) COLOR SCHEME 8
		ACTIVATE WINDOW __WFondo



ENDCASE
RETURN
****************************
*
* PROCEDURE F1_BUSCA
*
****************************
*!*****************************************************************************
*!
*!       Function: F1_BUSCA
*!
*!*****************************************************************************
FUNCTION f1_busca
PARAMETERS var1,campo1,modulo,p_area,xtabla,lvacio,m.prgmst

IF _WIndows OR _MAC
	#include const.h 	
ENDIF

m.curarea = ALIAS()
IF EMPTY(m.curarea)
   m.curarea = p_area
ENDIF
SELECT (p_area)
IF EMPTY(xtabla)
   m.llave = TRIM(var1)
ELSE
   m.llave = xtabla+TRIM(var1)
ENDIF
glescape = .F.
ulttecla = LASTKEY()
IF ulttecla = k_f8
   m.modselec=gsbusca
   IF !&modselec.(modulo)
      RETURN .F.
   ENDIF
   IF ulttecla = k_esc
      SELE (m.curarea)
      glescape = .T.
      RETURN .F.
   ENDIF
   SELE (P_area)
   var1    = &campo1
   IF EMPTY(xtabla)
      m.llave = TRIM(var1)
   ELSE
      m.llave = xtabla+TRIM(var1)
   ENDIF
   ulttecla = k_enter
   SELECT (m.curarea)
ENDIF
*
IF EMPTY(var1) AND lvacio
   SELECT (m.curarea)
   RETURN .T.
ENDIF
*
IF EMPTY(var1) AND !lvacio
   SELECT (m.curarea)
   RETURN .F.
ENDIF
*
m.creando = .F.
IF TYPE("CREAR")="L"
   m.creando = crear
ENDIF

m.lfound = SEEK(m.llave,p_area)

IF TYPE("CVCTRL")="C" AND m.estoy = [PIDLLAVE]
ELSE
   IF !m.lfound
      SELECT (m.curarea)
      RETURN .F.
   ENDIF
ENDIF
IF !EMPTY(m.prgmst)
   DO (m.prgmst) IN (Gsprogram)
ENDIF
IF ulttecla = k_esc OR ulttecla = k_enter
   SELECT (m.curarea)
   RETURN .T.
ENDIF
SELECT (m.curarea)
RETURN .T.
********************************
*                              *
*     PROCEDURE F1_ESTOY       *
*                              *
********************************
*!*****************************************************************************
*!
*!      Procedure: F1_ESTOY
*!
*!*****************************************************************************
PROCEDURE f1_estoy
PARAMETER smensaje
PRIVATE m.mensaje
DO CASE
CASE smensaje="BORR_REG"
   m.mensaje = "Borrando registro..."
CASE smensaje="ABRE_DBF"
   m.mensaje = "Abriendo archivos..."
CASE smensaje="ESPERAR"
   m.mensaje = "Espere por favor..."
CASE smensaje="GRAB_REG"
   m.mensaje = "Grabando registro..."
CASE smensaje="GRAB_DBFS"
   m.mensaje = "Grabando en archivos..."
CASE smensaje="OK"
   m.mensaje = "OK"
CASE smensaje="PROC_REG"
   m.mensaje = "Procesando registro..."
CASE smensaje="PROC_DBF"
   m.mensaje = "Procesando archivo..."
CASE smensaje="PROC_DBFS"
   m.mensaje = "Procesando en archivos..."
CASE smensaje="INIC_SIS"
   m.mensaje = "Inicializando sistema..."
CASE smensaje="INIC_INF"
   m.mensaje = "Inicializando informaci¢n..."
CASE smensaje="CARG_SIS"
   m.mensaje = "Cargando sistema..."
CASE smensaje="CARG_INF"
   m.mensaje = "Cargando informaci¢n..."
CASE smensaje="IMPRIMIR"
   m.mensaje = "Imprimiendo..."
OTHER
   m.mensaje = ""
ENDCASE
WAIT WINDOW m.mensaje NOWAIT
********************************************************************************
*                                                                              *
* FUNCION   : f1qeh.prg => que estoy haciendo                                  *
*                                                                              *
* PROPOSITO : Indica al usuario la acci¢n que se esta tomando en tiempo de     *
*                                                                              *
*             ejecuci¢n de un proceso ,rutina , o funci¢n.                     *
*                                                                              *
* AUTOR     : VETT                                                             *
*                                                                              *
* FECHA     : 15/11/95                                                         *
*                                                                              *
********************************************************************************
*!*****************************************************************************
*!
*!       Function: F1QEH
*!
*!      Called by: ABRIRDBFS          (procedure in belcsoft.PRG)
*!               : BBORRA_REG         (procedure in belcsoft.PRG)
*!               : BAGREGA_REG        (procedure in belcsoft.PRG)
*!               : PABREDBFS          (procedure in belcsoft.PRG)
*!
*!*****************************************************************************
FUNCTION f1qeh
PARAMETER smensaje,m.segundos
PRIVATE m.mensaje
DO CASE
CASE smensaje="BORR_REG"
   m.mensaje = "Borrando registro..."
CASE smensaje="ABRE_DBF"
   m.mensaje = "Abriendo archivos..."
CASE smensaje="ESPERAR"
   m.mensaje = "Espere por favor..."
CASE smensaje="GRAB_REG"
   m.mensaje = "Grabando registro..."
CASE smensaje="GRAB_DBFS"
   m.mensaje = "Grabando en archivos..."
CASE smensaje="GRAB_CABE"
   m.mensaje = "Grabando cabezera del documento..."
CASE smensaje="GRAB_DETA"
   m.mensaje = "Grabando detalle del documento..."
CASE smensaje="OK"
   m.mensaje = "OK"
CASE smensaje="PROC_REG"
   m.mensaje = "Procesando registro..."
CASE smensaje="PROC_DBFS"
   m.mensaje = "Procesando en archivos..."
CASE smensaje="PROC_DBF"
   m.mensaje = "Procesando archivo..."
CASE smensaje="PROC_INFO"
   m.mensaje = "Procesando informaci¢n..."
CASE smensaje="INIC_SIS"
   m.mensaje = "Inicializando sistema..."
CASE smensaje="INIC_INF"
   m.mensaje = "Inicializando informaci¢n..."
CASE smensaje="CARG_SIS"
   m.mensaje = "Cargando sistema..."
CASE smensaje="CARG_INF"
   m.mensaje = "Cargando informaci¢n..."
CASE smensaje="IMPRIMIR"
   m.mensaje = "Imprimiendo..."
CASE smensaje="EOF"
   m.mensaje = "Fin de archivo"
CASE smensaje="BOF"
   m.mensaje = "Principio de archivo"
OTHER
   m.mensaje = smensaje
ENDCASE
??CHR(7)
IF PARAMETERS()=1
   WAIT WINDOW m.mensaje NOWAIT
ELSE
   WAIT WINDOW m.mensaje NOWAIT TIMEOUT m.segundos
ENDIF
**************************************************
*                                                *
*   FUNCTION F1_INDEX : INDEXACION DE ARCHIVOS   *
*                                                *
**************************************************
*!*****************************************************************************
*!
*!       Function: F1_INDEX
*!
*!          Calls: F1_BASE()          (function in belcsoft.PRG)
*!               : F1_CAJA            (procedure in belcsoft.PRG)
*!
*!           Uses: SISTDBFS.DBF           Alias: DBFS
*!               : SISTCDXS.DBF           Alias: TAGS
*!
*!        Indexes: &TAGIDX                (tag in SISTCDXS.CDX)
*!
*!      CDX files: SISTDBFS.CDX
*!               : SISTCDXS.CDX
*!
*!*****************************************************************************
FUNCTION F1_INDEX
PARAMETERS m.NomSis
SYS(2700,0)
PRIVATE NumOpc
IF ! (FILE("SISTDBFS.dbf") AND FILE("SISTCDXS.dbf") )
   WAIT "No Existe Formatos de Indexaci¢n" WINDOW NOWAIT
   RETURN
ENDIF
IF !USED('DBFS')
	USE admin!SISTDBFS IN 0 ORDER SISTEMA ALIAS DBFS &&EXCLUSIVE
ENDIF
IF !USED('TAGS')
	USE admin!SISTCDXS IN 0 ORDER SISTEMA ALIAS TAGS &&EXCLUSIVE
ENDIF

IF ! (USED("DBFS") .AND. USED("TAGS"))
   WAIT "Error en Apertura de Archivos" WINDOW NOWAIT
   RETURN
ENDIF

SELECT dbfs 
SET ORDER TO SISTEMA   && SISTEMA+ARCHIVO 
IF !SEEK(m.NomSis,"DBFS")
   WAIT "No existen formatos de indexaci¢n para archivos de "+m.NomSis WINDOW NOWAIT
   RETURN
ENDIF

SELECT TAGS
SET ORDER TO SISTEMA   && SISTEMA+ARCHIVO
REPLACE ALL TAGS.MARCA WITH "X" FOR TAGS.SISTEMA=m.NomSis
SELECT DBFS
SET RELATION TO SISTEMA+ARCHIVO INTO TAGS
REPLACE ALL DBFS.MARCA WITH " " FOR TAGS.SISTEMA=m.NomSis
*REPLACE ALL DBFS.EMPAQUETA WITH IIF(DBFS.PacArchivo,"X"," ") FOR TAGS.SISTEMA=m.NomSis

=F1_BASE("MANTENIMIENTO","SISTEMA : "+m.NomSis,"USUARIO:"+GsUsuario,GsFecha)
wPrincipal=WONTOP()


IF _DOS OR _UNIX
	DO F1_CAJA WITH 20,70,"MANTENIMIENTO",2,"INDEXACION DE ARCHIVOS"

	ACTIVATE WINDOW MANTENIMIENTO
ENDIF

DEFINE WINDOW PREGUNTA FROM 18,23 TO 20,61 FLOAT NOZOOM NOGROW SHADOW ;
              TITLE "Eliga su Opci¢n para Continuar" 
IF !EMPTY(wPrincipal)
	ACTIVATE WINDOW PREGUNTA IN (wPrincipal)
ELSE
	ACTIVATE WINDOW PREGUNTA
ENDIF


@ 00,02 GET NumOpc DEFAULT 1 PICT "@*HT \<Total;\<Parcial;\<Cancelar"
READ CYCLE
IF LASTKEY()=27 .OR. NumOpc = 3
	RELEASE WINDOW PREGUNTA,MANTENIMIENTO
	IF USED('DBFS')
		SET ORDER TO ARCHIVO
	ENDIF
	IF USED('TAGS')
		USE IN TAGS
	ENDIF
	SYS(2700,1)
	RETURN
ENDIF
SELECT DBFS
SET RELATION TO
IF NumOpc = 2
   STORE WOUTPUT() TO currwind
   IF _DOS OR _UNIX
	   ACTIVATE SCREEN
	ELSE	   
   ENDIF
   IF NOT EMPTY(currwind)
    ACTIVATE WINDOW (currwind) SAME
   ENDIF
   RELEASE WINDOWS PREGUNTA
   ACTIVATE WINDOW (wPrincipal)
   IF !EMPTY(wPrincipal)
	   DEFINE WINDOWS Win2 FLOAT FROM 4,10 TO 15,70 SHADOW IN WINDOW (wPrincipal)
	ELSE
	   DEFINE WINDOWS Win2 FLOAT FROM 4,10 TO 15,70 SHADOW 
	ENDIF
	   
   SELECT DBFS
   SEEK m.NomSis
   BROWSE TITLE "BASE DE DATOS" KEY m.NomSis FIELD ;
    DBFS.MARCA:6:P="!",;
    DBFS.EMPAQUETA:10,DBFS.PACARCHIVO:H="RECONSTRUYE",;
    DBFS.ARCHIVO:R:W=.F.,;
    DBFS.CONCEPTO:R:W=.F. WINDOW Win2
   IF LASTKEY()=27
      RELEASE WINDOWS Win2,pregunta,Mantenimiento
      IF _DOS OR _UNIX
      		CLOSE DATA
      ELSE
      		IF USED('DBFS')
      			SET ORDER TO ARCHIVO
      		ENDIF
      		IF USED('TAGS')
      			USE IN TAGS
      		ENDIF
      ENDIF
      RETURN
   ENDIF
ELSE
	SELECT DBFS
	REPLACE ALL DBFS.MARCA WITH "X" FOR DBFS.SISTEMA=m.NomSis   
ENDIF

**
SELECT DBFS
SET FILTER TO DBFS.MARCA = "X"
SELECT TAGS
SET FILTER TO TAGS.MARCA = "X"
SELECT DBFS


define window win2 from 11,10 to 14,70 shadow
IF !EMPTY(wPrincipal)
	activate window win2 IN WINDOW (wPrincipal)
ELSE
	activate window win2
ENDIF
LOCAL NomArc as String 
SELECT DBFS
SEEK m.NomSis
SCAN REST WHILE SISTEMA=m.NomSis
   NomArc = TRIM(DBFS.Archivo)
	IF _DOS OR _UNIX
		IF !USED([DAT])
      		USE (NomArc) IN 3 ALIAS DAT EXCLUSIVE
		ENDIF
	ELSE
		goentorno.open_dbf1('ABRIR',NomArc,'DAT','','EXCLU')
	ENDIF	   
	 
   m.Empaqueta = .F.
   IF USED("DAT")
      SELECT DAT
      CLEAR
      @ 0,2 SAY "Base de Datos : "+DBF()
      NumReg = RECCOUNT()
      IF DBFS.Empaqueta = "X"
         @ 1,0 SAY PADC("*** E M P A Q U E T A N D O ***",78)
         SET TALK ON
         SET TALK WINDOW
         PACK
         m.Empaqueta = .T.
         SET TALK OFF
      ENDIF
      IF DBFS.pacarchivo 
      	 SELECT DAT
      	 DELETE TAG ALL 
         CLEAR
         @ 0,2 SAY "Tabla de Datos : " + DBF()
         SELECT TAGS
         SEEK DBFS.Sistema+DBFS.Archivo
         SCAN REST WHILE DBFS.Sistema+DBFS.Archivo = TAGS.Sistema+TAGS.Archivo
            @ 1,04 SAY "Reconstruyendo: " + TAGS.Indice
            Campos = TAGS.Llave
            TagIdx = TAGS.Indice
			m.Desc = IIF(TAGS.Descend,[DESCENDING],[])
            SELECT DAT
            SET TALK ON
            SET TALK WINDOW
            INDEX ON &Campos  TAG  &TagIdx  COMPACT &Desc.
            NomCdx=ADDBS(JUSTPATH(DBF()))+JUSTSTEM(DBF())
            SET INDEX TO (NomCdx+".CDX")
            SET TALK OFF
            SELECT TAGS
         ENDSCAN
      ENDIF
      USE IN DAT
   ENDIF
   SELECT DBFS
ENDSCAN
CLEAR 
@ 1,04 SAY "Mantenimiento Completado" 
RELEASE WINDOWS Win3,Win2,Pregunta,Mantenimiento
IF _DOS OR _UNIX
	CLOSE DATA
ELSE
	USE IN dbfs
	USE IN tags
ENDIF
*CLEAR MACROS
CLEAR 
IF WEXIST('__WFondo')
	RELEASE WINDOW __WFondo
ENDIF
SYS(2700,1)
RETURN
*************************************************************
*                                                           *
*          FUNCTION F1_RLOCK : BLOQUEO DE REGISTRO          *
*                                                           *
*************************************************************
*!*****************************************************************************
*!
*!       Function: F1_RLOCK
*!
*!      Called by: TPOCMB             (procedure in GER_S_VB.PRG)
*!
*!          Calls: F1_CAJA            (procedure in belcsoft.PRG)
*!               : F1_ALERT           (procedure in belcsoft.PRG)
*!
*!*****************************************************************************
FUNCTION f1_rlock
PARAMETERS lapso
PRIVATE siempre,inic,temp
inic    = Lapso
siempre = (inic = 0)
ok      = .t.


snombre= [ESTADO]
nlargo = 2
nancho = 25
stit   = []
ncolor = 2

DO f1_caja WITH nlargo,nancho,snombre,ncolor,stit

ACTIVATE WINDOW (snombre) NOSHOW


IF siempre
   ACTIVATE WINDOW (snombre)
   @0,0 SAY "Un momento por favor..."
ENDIF
DO WHILE .T.
   IF .NOT. RLOCK()
      retardo=100
      DO WHILE retardo > 0
         retardo = retardo-1
      ENDDO
      lapso = lapso - 1
      IF .NOT. (siempre .OR. lapso > 0)
         IF f1_alert([Registro bloqueado por otro usuario],5)=1
            ok     = .f.
            EXIT
         ELSE
            ACTIVATE WINDOW (snombre)
            @0,0 SAY "Un momento por favor..."
         ENDIF
         lapso    =  inic
      ENDIF
   ELSE
      ok     = .t.
      EXIT
   ENDIF
ENDDO
* ------------------------------------------------------------------------
RELEASE WINDOW (snombre)
RETURN ok
*************************************************
*                                               *
*                                               *
*      F0PRINT CONFIGURACION DE IMPRESION       *
*                                               *
*************************************************
*****************
*!*****************************************************************************
*!
*!      Procedure: F0PRINT
*!
*!      Called by: PLISTA             (procedure in belcsoft.PRG)
*!
*!          Calls: F0PRINT.SPR
*!               : XRETURN            (procedure in belcsoft.PRG)
*!               : FORMREPO           (procedure in belcsoft.PRG)
*!               : FORMLABE           (procedure in belcsoft.PRG)
*!               : F0PRFIN            (procedure in belcsoft.PRG)
*!
*!*****************************************************************************
PROCEDURE f0print
*****************
PARAMETERS xtiprep
*#include const.h
PRIVATE opc,DBF,SELECT,regact
m.curwin=WOUTPUT()
IF _Dos OR _Unix
	IF !EMPTY(m.curwin)
	   SHOW WINDOW (m.curwin) BOTTOM REFRESH
	ENDIF
ENDIF
SET TALK OFF
IF TYPE("XWHILE") <> "C"
   xwhile   = ""
ENDIF
IF TYPE("XFOR") <> "C"
   xfor     = ""
ENDIF
IF TYPE("INIPRN") <> "C"
   iniprn   = ""
ENDIF
IF TYPE("INIPRNW") <> "C"
   iniprnw   = ""
ENDIF

IF TYPE("XTipRep") = "C"
   IF  xtiprep = "REPORTS" .OR. xtiprep = "QUERY" .OR. xtiprep = "LABEL"
      IF  xtiprep = "LABEL"
         ON KEY LABEL ctrl+R MODIFY LABEL   (snomrep) NOENVIRONMENT
      ELSE
         ON KEY LABEL ctrl+R MODIFY REPORT  (snomrep) NOENVIRONMENT
      ENDIF
      IF  xtiprep = "QUERY"
         ON KEY LABEL ctrl+q MODIFY QUERY   (snomqry)
      ENDIF
   ENDIF
ENDIF

_PCOPIES = 1
_PBPAGE  = 1
_PEPAGE  = 32767
_PAGENO  = 1
_PWAIT   = .F.
_pselect = .F.
_destino = 1
_PEJECT  = "NONE"
m.opc    = 0
m.control = 1
IF ! FILE("admprint.dbf")
   _comando   = ""
   _interface = ""
   _driver    = "Epson.pdt"
   _nombre    = SET('PRINTER',3)
ENDIF
_archivo = SPACE(30)
m.dbf    = DBF()
m.select = SELECT()
m.regact = RECNO()

IF VARTYPE(_FontName)<>'C'
	_FontName	= 'Courier New'
ENDIF
IF VARTYPE(_FontSize)<>'N'
	_FontSize	= 9
ENDIF
IF VARTYPE(_FontStyle)<>'C'
	_FontStyle	= 'N' 
ENDIF	

IF VERSION()=[Visual FoxPro]
	do form f0print_ to m.Control
ELSE
*!*		DO f0print.spr
ENDIF
IF _DOs OR _UNIX
	IF (LASTKEY()=27) OR (m.control=2)
		IF PROGRAM(2)='F1_EDIT' OR PROGRAM(1)='F1_EDIT'
			ulttecla = 0
		ELSE
		    ulttecla = 27
			KEYBOARD '{ESC}'    
		ENDIF
	   DEACTIVATE WINDOW impresion
	   RELEASE WINDOW impresion
	   RETURN
	ENDIF
ELSE
	IF m.Control = 2
		IF PROGRAM(2)='F1_EDIT' OR PROGRAM(1)='F1_EDIT'
			ulttecla = 0
		ELSE
		    ulttecla = 27
			KEYBOARD '{ESC}'    
		ENDIF
	   DEACTIVATE WINDOW impresion
	   RELEASE WINDOW impresion
       RETURN
	ENDIF	
ENDIF
SELECT (m.select)
IF RECNO() <> m.regact .AND. ! EMPTY(m.dbf)
   GOTO m.regact
ENDIF

ON KEY LABEL ctrl+R
ON KEY LABEL ctrl+q
*** Por Pantalla solo funciona intermitentemente en VFP
*** Asi que procedemos al parche correspondiente ****  VETT 2007-25-2007 2:23am  	
IF _DOS OR _UNIX
	
ELSE
		
**	_Destino = IIF(_Destino=2,3,_Destino)
ENDIF

*** 

DO CASE
CASE _destino = 1
   IF EMPTY(_interface )
      SET PRINTER TO lpt1
   ELSE
      SET PRINTER TO (_interface)
   ENDIF
   IF VERSION()='Visual FoxPro'
   	
   ELSE
   		RESTORE FROM (_driver) ADDITIVE
   ENDIF
   
CASE _destino = 2 && Pantalla ya no sirve

*!*		IF VERSION()='Visual FoxPro'
*!*			_archivo = goentorno.tmppath+SYS(3)+".pat"
*!*		ELSE
*!*		   _archivo = pathuser+SYS(3)+".pat"
*!*		ENDIF   
*!*	   DELETE FILE (_archivo)
*!*	   SET PRINTER TO (_archivo)
		_Archivo=''
	   IF "" = TRIM(_archivo)
			IF VERSION()='Visual FoxPro'
				_archivo = goentorno.tmppath+SYS(3)+".pat"
			ELSE
			   _archivo = pathuser+SYS(3)+".pat"
			ENDIF   
	   ENDIF
	   IF ! "."$_archivo
	      _archivo = _archivo+".prn"
	   ENDIF
	   IF ! ( ":"$_archivo OR  "\"$_archivo OR  "/"$_archivo)
			IF VERSION()='Visual FoxPro'
				_archivo = goentorno.tmppath+_archivo
			ELSE
			   _archivo = pathuser+_archivo
			ENDIF   
	   ENDIF
	   DELETE FILE (_archivo)
	   SET PRINTER TO (_archivo)
	   IF VERSION()='Visual FoxPro'
	   	
	   ELSE
			RESTORE FROM (_driver) ADDITIVE
	   ENDIF



   STORE "" TO _prn0,_prn1,_prn2,_prn3,_prn4,_prn5a,_prn5b,_prn6a,_prn6b,;
      _prn7a,_prn7b,_prn8a,_prn8b,_prn9a,_prn9b
CASE _destino = 3 
*!*		_Archivo = ''
   IF "" = TRIM(_archivo)
		IF VERSION()='Visual FoxPro'
			_archivo = goentorno.tmppath+SYS(3)+".pat"
		ELSE
		   _archivo = pathuser+SYS(3)+".pat"
		ENDIF   
   ENDIF
   IF ! "."$_archivo
      _archivo = _archivo+".prn"
   ENDIF
   IF ! ( ":"$_archivo OR  "\"$_archivo OR  "/"$_archivo)
		IF VERSION()='Visual FoxPro'
			_archivo = goentorno.tmppath+_archivo
		ELSE
		   _archivo = pathuser+_archivo
		ENDIF   
   ENDIF
   DELETE FILE (_archivo)
   SET PRINTER TO (_archivo)
   IF VERSION()='Visual FoxPro'
   	
   ELSE
		RESTORE FROM (_driver) ADDITIVE
   ENDIF
   
ENDCASE



*@ 02,17 FILL TO 05,43 COLOR SCHEME 11
*@ 02,17 TO 05,43      COLOR SCHEME 11
*@ 03,18 SAY "       Imprimiendo       " COLOR -
*@ 04,18 SAY " [ESC] cancela Impresi¢n " COLOR SCHEME 11
IF NOT WEXIST("Aviso_Prt")
   DEFINE WINDOW aviso_prt ;
      FROM 10, 23 ;
      TO 13,55 ;
      NOFLOAT ;
      NOCLOSE ;
      SHADOW ;
      NOMINIMIZE ;
      COLOR SCHEME 10
ENDIF
ACTIVATE WINDOW aviso_prt
DO CASE
CASE _WINDOWS
   MOVE WINDOW aviso_prt BY 5,0
CASE _MAC
   MOVE WINDOW aviso_prt BY 5,0
ENDCASE
@ 0,0 SAY "          Imprimiendo" ;
   SIZE 1,21, 0
@ 1,4 SAY " ESC  cancela impresi¢n" ;
   SIZE 1,23, 0
@1,5 SAY [ESC] COLOR SCHEME 7
SET CONSOLE OFF
IF TYPE("XTipRep") = "C" AND LASTKEY() # 27
   IF _destino = 1
      IF EMPTY(_interface)
         SET PRINTER TO lpt1
      ELSE
         SET PRINTER TO (_interface)
      ENDIF
      IF _DOS OR _UNIX
         ??? &iniprn
      ELSE
		**         ??? (iniprnw)
      ENDIF
   ENDIF
   SET ESCAPE ON
   ON  ESCAPE DO xreturn
   IF xtiprep = "REPORTS"
      DO formrepo    && IN F0PRINT
   ENDIF
   IF xtiprep = "QUERY"
      SET TALK ON
      SET TALK WINDOW
      IF ! ".QPR"$snomqry
         snomqry = snomqry+".QPR"
      ENDIF
      DO  (snomqry)
      SET TALK OFF
      DO formrepo   && IN F0PRINT
   ENDIF
   IF xtiprep = "LABEL"
      DO formlabe   && IN F0PRINT
   ENDIF
   DO f0prfin       && IN F0PRINT
ENDIF
RETURN


*       +---------------------------------------------------------+
*       Ý                                                         Ý
*       Ý                  F0PRFIN Fin de Impresi¢n               Ý
*       Ý                                                         Ý
*       +---------------------------------------------------------+
*
*!*****************************************************************************
*!
*!      Procedure: F0PRFIN
*!
*!      Called by: F0PRINT            (procedure in belcsoft.PRG)
*!               : DIRPRINT           (procedure in belcsoft.PRG)
*!
*!*****************************************************************************
PROC f0prfin
PRIVATE respuesta
ON  ESCAPE
SET PRINTER TO
SET ESCAPE OFF
SET CONSOLE ON
SET DEVICE TO SCREEN
DO CASE
SET STEP ON 
CASE _destino = 2  
   *RUN README &_Archivo
	IF (_WINDOWS OR _DOS OR _UNIX ) AND ( TYPE("XTipRep") != "C" OR (TYPE("XTipRep")="C" AND XTIPREP='XLS'))
		MODI COMM &_archivo NOEDIT
    ENDIF
    DELETE FILE (_archivo)
CASE _destino = 3  AND TYPE("XTipRep") = "C"   AND XTipRep = 'XLS'
	LOCAL cArchivo
	LcCursorAct	= ALIAS()
	IF NOT EMPTY(LcCursorAct)
		DO FORM clagen_exportar WITH 'Reporte',LcCursorAct,_archivo,'00006'
	ENDIF
	IF !EMPTY(LcCursorAct)
		SELECT(LcCursorAct)
	ENDIF
CASE _destino = 3	AND TYPE("XTipRep") != "C"
   *RUN README &_Archivo
   =SYS(2700,0) 
 
   MODI COMM &_archivo NOEDIT
   @ 00,00 CLEAR TO 02,31 COLOR SCHEME 15
   respuesta = 1
   @ 01,02 GET respuesta PICTURE "@*HT \<Salir;\<Borrar;\<Imprimir" COLOR SCHEME 15
   READ CYCLE
   =SYS(2700,1) 
   DO CASE
   CASE respuesta = 2
      DELETE FILE (_archivo)
   CASE respuesta = 3
      SET HEADING OFF
      SET CONSOLE OFF
      SET PDSETUP TO
      _PEJECT = "NONE"
      TYPE (_archivo) TO PRINT
      SET CONSOLE ON
      SET HEADING ON
      *DELETE FILE (_Archivo)
   ENDCASE
ENDCASE
set printer to
IF WVISIBLE('IMPRESION')
   DEACTIVATE WINDOW impresion
   RELEASE WINDOW impresion
ENDIF
RELEASE WINDOW aviso_prt
RETURN

*       +---------------------------------------------------------+
*       Ý                                                         Ý
*       Ý                  F0MBPRN Membrete de Impresi¢n          Ý
*       Ý                                                         Ý
*       +---------------------------------------------------------+
*
**************************************************************************
* Definir las siguientes variables antes de correr esta opci¢n :         *
* Titulo    -->  Titulo                                                  *
* SubTitulo -->  Sub Titulo                                              *
* NumPag    -->  contador de p ginas                                     *
* NumLin    -->  contador de l¡neas de impresi¢n                         *
* E1..E9    -->  Encabezados de impresi¢n                                *
* Ancho     -->  Ancho de la Impresi¢n                                   *
* IniImp    -->  Setup de Impresi¢n                                      *
**************************************************************************
*!*****************************************************************************
*!
*!      Procedure: F0MBPRN
*!
*!      Called by: RESETPAG           (procedure in belcsoft.PRG)
*!
*!*****************************************************************************
PROCEDURE f0mbprn
*****************
IF numpag > 0
   EJECT PAGE
ENDIF
numpag    = _PAGENO
IF numpag = 1 .OR. numpag = _PEPAGE
   IF _UNIX
      SET PRINTER TO "cat >/dev/null"
   ELSE
      SET PRINTER TO nul
   ENDIF
ENDIF

IF numpag = _PBPAGE   && Reset Printer
   DO CASE
   CASE _destino = 1
      IF EMPTY(_interface)
         SET PRINTER TO lpt1
      ELSE
         SET PRINTER TO (_interface)
      ENDIF
   CASE _destino = 2
      SET PRINTER TO (_archivo)
   CASE _destino = 3
      SET PRINTER TO (_archivo)
   ENDCASE
   DO CASE
   CASE _DOS OR _UNIX
      @ 0,0 SAY _prn0+IIF(_prn5a==[],[],_prn5a+CHR(largo)+_prn5b)
   ENDCASE
ENDIF

ulttecla = 0
IF numpag >= _PBPAGE
   IF  _PWAIT
      SET DEVICE TO SCREEN
      @ 00,00 SAY PADC("Pausa entre p ginas",32) COLOR SCHEME 7
      @ 01,00 SAY PADC("Enter para continuar",32) COLOR SCHEME 7
      ?? CHR(7)
      @ 01,06 SAY "Enter" COLOR W*/N
      ulttecla = 0
      DO WHILE ! (ulttecla = k_enter .OR. ulttecla = k_esc)
         ulttecla = INKEY(0)
      ENDDO
      IF ulttecla = k_esc
         SET DEVICE TO PRINTER
         RETURN
      ENDIF
      @ 00,00 SAY PADC("                         ",32)      COLOR SCHEME 11
      @ 01,00 SAY PADC("P gina No. "+STR(numpag,3,0),32)    COLOR SCHEME 11
      @ 02,00 SAY PADC(" ESC cancela Impresi¢n",32)          COLOR SCHEME 11
      @ 02,05 SAY "ESC" COLOR SCHEME 7
      SET DEVICE TO PRINTER
   ENDIF
ENDIF
IF _DOS
   SET DEVICE TO SCREEN
   @ 00,00 SAY PADC("                         ",32)      COLOR SCHEME 11
   @ 01,00 SAY PADC("P gina No. "+STR(numpag,3,0),32)    COLOR SCHEME 11
   SET DEVICE TO PRINTER
ENDIF

coltit = (ancho - LEN(titulo) - 1)/2
colstt = (ancho - LEN(subtitulo) - 1)/2
mrgizq = (ancho - LEN(en9) - 1)/2
colder =  ancho - LEN(tit_sder) - 1

* - Imprimir el encabezado de la p gina.
numlin = 0
IF _windows OR _Mac
	
ELSE
	@ numlin, 0 + _PLOFFSET      SAY iniimp
ENDIF


@ numlin, 0 + _PLOFFSET      SAY tit_sizq
DO CASE
CASE titulo="@"
   IF _destino <> 3
      coltit = (ancho - 2*(LEN(titulo)-1) - 1)/2
   ENDIF
	DO CASE
		CASE _DOS OR _UNIX
			@ numlin,coltit + _PLOFFSET SAY _prn7b+SUBSTR(titulo,2)+_prn7b
	   CASE _WINDOWS
   			@ numlin,coltit + _PLOFFSET SAY SUBSTR(titulo,2)  &&FONT "Courier New",12
	ENDCASE
	   
   IF _destino <> 3
      @ numlin,0 + _PLOFFSET SAY ""
   ENDIF
OTHER
   @ numlin,coltit + _PLOFFSET SAY titulo &&FONT "Courier New",10
ENDCASE
@ numlin,colder + _PLOFFSET SAY tit_sder

numlin = numlin + 1
@ numlin,0  + _PLOFFSET      SAY tit_iizq
IF VARTYPE(tit_iizq2)='C'
	numlin = numlin + 1
	@ numlin,0 + _PLOFFSET        SAY tit_iizq2
ENDIF
DO CASE
CASE titulo="@"
   IF _destino <> 2
      colstt = (ancho - 2*(LEN(subtitulo)-1) - 1)/2
   ENDIF
   DO CASE 
	CASE _DOS OR _UNIX
   		@ numlin,colstt + _PLOFFSET SAY _prn7b+SUBSTR(subtitulo,2)+_prn7b
   CASE _WINDOWS
   		@ numlin,colstt + _PLOFFSET SAY SUBSTR(subtitulo,2) &&FONT "Courier New",12
   ENDCASE		
   IF _destino <> 2
      @ numlin,0 + _PLOFFSET SAY ""
   ENDIF
OTHER
   @ numlin,colstt + _PLOFFSET  SAY subtitulo &&FONT "Courier New",10
ENDCASE
IF VARTYPE(SinNumPag)='L' AND  SinNumPag = .T.
ELSE
	@ numlin,ancho-14 + _PLOFFSET SAY "PAGINA: "+STR(numpag,5) &&FONT "Courier New",10
ENDIF
lin      = 1
LOCAL i AS Character  
DO WHILE lin <= 9
   i          = STR(lin,1,0)
   leyenda    = en&i
   IF LEN(leyenda) > 0
      numlin = numlin + 1
      DO CASE
      CASE leyenda = "<"
         leyenda    = RIGHT( leyenda, LEN(leyenda)-1)
         COL = 0
      CASE leyenda = "@"
         COL    = (ancho - LEN(leyenda) - 1)/2
         IF _destino <> 2
            COL    = (ancho - 2*(LEN(leyenda)-1) - 1)/2
         ENDIF
         IF _UNIX OR _DOS
         	leyenda    = _prn7a+SUBST( leyenda, 2)+_prn7b
         ELSE
         	leyenda    = SUBST( leyenda, 2)
         ENDIF
      OTHER
         COL    = (ancho - LEN(leyenda) - 1)/2
      ENDCASE
      IF COL < 0
         COL  = 0 
      ENDIF
      xxlen = LEN(leyenda)
      IF xxlen <= 254
         @ numlin,COL + _PLOFFSET SAY leyenda &&FONT "Courier New",10
      ELSE
         xx = LEFT(leyenda,254)
         xy = SUBS(leyenda,255)
         @ numlin,COL + _PLOFFSET    SAY xx &&FONT "Courier New",10
         @ numlin,COL+254 SAY xy &&FONT "Courier New",10
      ENDIF
   ENDIF
   lin        = lin + 1
ENDDO
RETURN
******************
*!*****************************************************************************
*!
*!      Procedure: DIRPRINT
*!
*!          Calls: PSELECT()          (function in belcsoft.PRG)
*!               : XRETURN            (procedure in belcsoft.PRG)
*!               : FORMREPO           (procedure in belcsoft.PRG)
*!               : FORMLABE           (procedure in belcsoft.PRG)
*!               : F0PRFIN            (procedure in belcsoft.PRG)
*!
*!*****************************************************************************
PROCEDURE dirprint
******************
PARAMETERS xtiprep
PRIVATE opc,DBF,SELECT,regact
ACTIVATE SCREEN
SET TALK OFF
IF TYPE("XWHILE") <> "C"
   xwhile   = ""
ENDIF
IF TYPE("XFOR") <> "C"
   xfor     = ""
ENDIF
IF TYPE("INIPRN") <> "C"
   iniprn   = "CHR(0)"
ENDIF

IF TYPE("XTipRep") = "C"
   IF  xtiprep = "REPORTS" .OR. xtiprep = "QUERY" .OR. xtiprep = "LABEL"
      IF  xtiprep = "LABEL"
         ON KEY LABEL ctrl+R MODIFY LABEL   (snomrep) NOENVIRONMENT
      ELSE
         ON KEY LABEL ctrl+R MODIFY REPORT  (snomrep) NOENVIRONMENT
      ENDIF
      IF  xtiprep = "QUERY"
         ON KEY LABEL ctrl+q MODIFY QUERY   (snomqry)
      ENDIF
   ENDIF
ENDIF
_PCOPIES = 1
_PBPAGE  = 1
_PEPAGE  = 32767
_PAGENO  = 1
_PWAIT   = .F.
_pselect = .F.
_destino = 1
_PEJECT  = "NONE"

IF ! FILE("admprint.dbf")
   _comando   = ""
   _interface = ""
   _driver    = "Epson.pdt"
   _nombre    = "Impresora Local                 "
ENDIF
_archivo = SPACE(30)
m.dbf    = DBF()
m.select = SELECT()
m.regact = RECNO()
m.opc    = 1
SAVE SCREEN
@ 20,19 FILL TO 23,59 COLOR W+/N
@ 19,20 CLEAR TO 22,60
@ 19,20 FILL TO 22,60 COLOR SCHEME 5
@ 19,20 TO 22,60 COLOR SCHEME 5
@ 20,22 SAY "Presione       para iniciar impresi¢n" COLOR SCHEME 5
@ 20,31 GET opc PICT "@*HT F10" COLOR SCHEME 5
@ 21,26 SAY "[                              ]" COLOR SCHEME 5
@ 21,27 SAY _nombre PICTURE "@S30" COLOR SCHEME 5
@ 21,22 GET _pselect PICTURE "@*C" VALID pselect() COLOR SCHEME 5
READ CYCLE
RESTORE SCREEN
SELECT (m.select)
IF RECNO() <> m.regact .AND. ! EMPTY(m.dbf)
   GOTO m.regact
ENDIF

ON KEY LABEL ctrl+R
ON KEY LABEL ctrl+q
DO CASE
CASE _destino = 1
   IF EMPTY(_interface)
      SET PRINTER TO lpt1
   ELSE
      SET PRINTER TO (_interface)
   ENDIF
   RESTORE FROM (_driver) ADDITIVE
ENDCASE
IF LASTKEY() = 27
   RETURN
ENDIF
@ 19,19 FILL TO 22,60 COLOR SCHEME 11
@ 19,19 TO 22,60      COLOR SCHEME 11
@ 20,20 SAY " *****   En proceso de Impresi¢n  ***** " COLOR SCHEME 11
@ 21,20 SAY " Presione [ESC] para cancelar Impresi¢n " COLOR SCHEME 11
@ 21,31 SAY "ESC" COLOR SCHEME 7
SET CONSOLE OFF
IF TYPE("XTipRep") = "C" AND LASTKEY() # 27
   IF _destino <> 2
      SET PRINTER TO (_interface)
      ??? &iniprn
   ENDIF
   SET ESCAPE ON
   ON  ESCAPE DO xreturn
   IF xtiprep = "REPORTS"
      DO formrepo    && IN F0PRINT
   ENDIF
   IF xtiprep = "QUERY"
      SET TALK ON
      SET TALK WINDOW
      DO  (snomqry)
      SET TALK OFF
      DO formrepo   &&  IN F0PRINT
   ENDIF
   IF xtiprep = "LABEL"
      DO formlabe   &&  IN F0PRINT
   ENDIF
   DO f0prfin     &&  IN F0PRINT
ENDIF
RETURN


*       +---------------------------------------------------------+
*       Ý                                                         Ý
*       Ý                 PSELECT  SELCCION DE IMPRESORA          Ý
*       Ý                                                         Ý
*       +---------------------------------------------------------+
*
*!*****************************************************************************
*!
*!       Function: PSELECT
*!
*!      Called by: DIRPRINT           (procedure in belcsoft.PRG)
*!               : _RQ20KWV30()       (function in F0PRINT.SPR)
*!
*!           Uses: ADMPRINT.DBF
*!
*!*****************************************************************************
FUNC pselect
PRIVATE lsnulo,m.currsel,linreg,ancho,xo
m.currsel = SELECT()
_pselect   = .F.
IF ! USED("admprint")
   SELECT 0
   USE admprint ORDER admprint
ELSE
   SELECT admprint
ENDIF
SEEK gsterminal
IF ! FOUND()
   SELECT (m.currsel)
   RETURN .T.
ENDIF
DEFINE WINDOWS modulos FROM 9,74-(LEN(admprint.nombre));
   TO 24,77 NONE   COLOR SCHEME 10
BROWSE FIELD admprint.nombre KEY gsterminal NODELETE NOAPPEND NOMODIFY NOMENU;
   TITLE "IMPRESORAS" WINDOWS modulos
RELEASE WINDOWS modulos
IF LASTKEY() # 27
   _nombre    = nombre
   _comando   = comando
   _interface = interface
   _driver    = TRIM(driver)+".pdt"
   IF ! EMPTY(comando)
      ! &_comando >nul
   ENDIF
   IF m.opc = 0
      @ 02,19 SAY _nombre PICTURE "@S30" COLOR SCHEME 5
   ELSE
      @ 02,19 SAY _nombre PICTURE "@S30" COLOR SCHEME 5
   ENDIF
ENDIF
RETURN .T.
*       +---------------------------------------------------------+
*       +---------------------------------------------------------+
*!*****************************************************************************
*!
*!      Procedure: FORMREPO
*!
*!      Called by: F0PRINT            (procedure in belcsoft.PRG)
*!               : DIRPRINT           (procedure in belcsoft.PRG)
*!
*!*****************************************************************************
PROC formrepo
IF EOF()
   RETURN
ENDIF
m.regact = RECNO()
PRINTJOB
GOTO m.regact
DO CASE
CASE xwhile == "" AND xfor == ""
   IF _WINDOWS OR _MAC
   		DO CASE 
      		CASE _destino=1
		         REPORT REST FORM (snomrep) NOEJECT TO PRINT PROMPT
      		CASE _destino=2
   		         REPORT REST FORM (snomrep) NOEJECT PREVIEW 
		    CASE _destino=3     
		         REPORT REST FORM (snomrep) NOEJECT TO PRINTER 
      ENDCASE 
   ELSE
      REPORT REST FORM (snomrep) NOEJECT PDSETUP TO PRINT
   ENDIF
CASE xwhile == ""
   IF _WINDOWS OR _MAC
      IF _destino=1
         REPORT REST FORM (snomrep) NOEJECT TO PRINT PROMPT ;
            FOR EVALUATE(xfor)
      ELSE
         REPORT REST FORM (snomrep) NOEJECT ;
            FOR EVALUATE(xfor) PREVIEW
      ENDIF
   ELSE
      REPORT REST FORM (snomrep) NOEJECT PDSETUP TO PRINT ;
         FOR EVALUATE(xfor)
   ENDIF
CASE xfor == ""
   IF _WINDOWS OR _MAC
      IF _destino=1
         REPORT REST FORM (snomrep) NOEJECT TO PRINT PROMPT ;
            WHILE EVALUATE(xwhile)
      ELSE
         REPORT REST FORM (snomrep) NOEJECT ;
            WHILE EVALUATE(xwhile) PREVIEW
      ENDIF
   ELSE
      REPORT REST FORM (snomrep) NOEJECT PDSETUP TO PRINT ;
         WHILE EVALUATE(xwhile)
   ENDIF
OTHER
   IF _WINDOWS OR _MAC
      IF _destino=1
         REPORT REST FORM (snomrep) NOEJECT TO PRINT PROMPT ;
            WHILE EVALUATE(xwhile) FOR EVALUATE(xfor)
      ELSE
         REPORT REST FORM (snomrep) NOEJECT;
            WHILE EVALUATE(xwhile) FOR EVALUATE(xfor) PREVIEW
      ENDIF
   ELSE
      REPORT REST FORM (snomrep) NOEJECT PDSETUP TO PRINT ;
         WHILE EVALUATE(xwhile) FOR EVALUATE(xfor)
   ENDIF
ENDCASE
ENDPRINTJOB
RETURN

*       +---------------------------------------------------------+
*       +---------------------------------------------------------+
*!*****************************************************************************
*!
*!      Procedure: FORMLABE
*!
*!      Called by: F0PRINT            (procedure in belcsoft.PRG)
*!               : DIRPRINT           (procedure in belcsoft.PRG)
*!
*!*****************************************************************************
PROC formlabe
IF EOF()
   RETURN
ENDIF
m.regact = RECNO()
PRINTJOB
GOTO m.regact
DO CASE
CASE xwhile == "" AND xfor == ""
   LABEL  REST FORM (snomrep) PDSETUP TO PRINT
CASE xwhile == ""
   LABEL  REST FORM (snomrep) PDSETUP TO PRINT ;
      FOR EVALUATE(xfor)
CASE xfor == ""
   LABEL  REST FORM (snomrep) PDSETUP TO PRINT ;
      WHILE EVALUATE(xwhile)
OTHER
   LABEL  REST FORM (snomrep) PDSETUP TO PRINT ;
      WHILE EVALUATE(xwhile) FOR EVALUATE(xfor)
ENDCASE
ENDPRINTJOB
RETURN

*!*****************************************************************************
*!
*!      Procedure: XRETURN
*!
*!      Called by: F0PRINT            (procedure in belcsoft.PRG)
*!               : DIRPRINT           (procedure in belcsoft.PRG)
*!
*!*****************************************************************************
PROCEDURE xreturn
DEACTIVATE WINDOW impresion
RELEASE WINDOW impresion
RELEASE WINDOW aviso_prt
RETURN
*!*****************************************************************************
*!
*!      Procedure: F1MSGERR
*!
*!      Called by: BTN_VAL            (procedure in belcsoft.PRG)
*!               : F1_APERT()         (function in belcsoft.PRG)
*!               : PGRABAR            (procedure in belcsoft.PRG)
*!               : _MES()             (function in GER_S_VB.PRG)
*!
*!          Calls: F1_CAJA            (procedure in belcsoft.PRG)
*!
*!*****************************************************************************
PROCEDURE f1msgerr
* Procedimiento para mostrar un mensaje de error

PARAMETER m.mensaje
PRIVATE ALL
nlen   = LEN(m.mensaje)+10
IF nlen>78
   nlen = 78
ENDIF

nancho = LEN(PADC(ALLTRIM(m.mensaje),nlen))

DO f1_caja WITH 4, nancho, "ALERT", 7,"",9
ACTIVATE WINDOW alert
??CHR(7)+CHR(7)
SET CURSOR OFF
@ 0,0 CLEAR
@ 1,0 SAY PADC(ALLTRIM(m.mensaje), WCOLS())
WAIT ""
SET CURSOR ON

RELEASE WINDOW alert
RETURN

***************************************
*                                     *
*  FUNCION FSERR : MENSAJE DE ERROR   *
*                                     *
***************************************
*!*****************************************************************************
*!
*!       Function: FSERR
*!
*!*****************************************************************************
FUNCTION fserr
PRIVATE smsgerr
IF glescape
   serr = []
   gsmsgerr = []
   smsgerr = []
ELSE
   IF EMPTY(serr)
      smsgerr = gsmsgerr
   ELSE
      smsgerr = serr
   ENDIF
ENDIF
RETURN smsgerr

*******************************************
*                                         *
*       FUNCTION F1CHRMES                 *
*                                         *
*******************************************
*!*****************************************************************************
*!
*!       Function: F1CHRMES
*!
*!*****************************************************************************
FUNCTION f1chrmes
PARAMETER nmes
DO CASE
CASE nmes = 1
   cmes = [E]   && Enero

CASE nmes = 2
   cmes = [F]   && Febrero

CASE nmes = 3
   cmes = [M]   && Marzo

CASE nmes = 4
   cmes = [A]   && Abril

CASE nmes = 5
   cmes = [Y]   && mayo

CASE nmes = 6
   cmes = [J]   && Junio

CASE nmes = 7
   cmes = [U]   && julio

CASE nmes = 8
   cmes = [G]   && agosto

CASE nmes = 9
   cmes = [S]   && Septiembre

CASE nmes = 10
   cmes = [O]   && Octubre

CASE nmes = 11
   cmes = [N]   && Noviembre

CASE nmes = 12
   cmes = [D]   && Diciembre

OTHER
   cmes = [X]   && ??
ENDCASE
RETURN cmes
********************************************************************************
*                                                                              *
* FUNCION   : f1qh.prg => que estoy haciendo                                   *
*                                                                              *
* PROPOSITO : Indica al usuario la acci¢n que se esta tomando en tiempo de     *
*                                                                              *
*             ejecuci¢n de un proceso ,rutina , o funci¢n.                     *
*                                                                              *
* AUTOR     : VETT                                                             *
*                                                                              *
* FECHA     : 15/11/95                                                         *
*                                                                              *
********************************************************************************
*!*****************************************************************************
*!
*!       Function: F1QH
*!
*!          Calls: F1_CAJA            (procedure in belcsoft.PRG)
*!
*!*****************************************************************************
FUNCTION f1qh
PARAMETER smensaje,m.sengundos
PRIVATE m.mensaje
m.currwin = WOUTPUT()
IF !EMPTY(m.currwin) AND m.currwin#[QUESTOY]
   *DEACTIVATE WINDOW (m.CurrWin)
   SHOW WINDOW (m.currwin) BOTT
ENDIF
IF WEXIST("QUESTOY")
   RELEASE WINDOW questoy
ENDIF
DO CASE
CASE smensaje="BORR_REG"
   m.mensaje = "Borrando registro..."
CASE smensaje="ABRE_DBF"
   m.mensaje = "Abriendo archivos..."
CASE smensaje="ESPERAR"
   m.mensaje = "Espere por favor..."
CASE smensaje="GRAB_REG"
   m.mensaje = "Grabando registro..."
CASE smensaje="GRAB_DBFS"
   m.mensaje = "Grabando en archivos..."
CASE smensaje="GRAB_CABE"
   m.mensaje = "Grabando cabezera del documento..."
CASE smensaje="GRAB_DETA"
   m.mensaje = "Grabando detalle del documento..."
CASE smensaje="OK"
   m.mensaje = "OK"
CASE smensaje="PROC_REG"
   m.mensaje = "Procesando registro..."
CASE smensaje="PROC_DBF"
   m.mensaje = "Procesando archivo..."
CASE smensaje="PROC_DBFS"
   m.mensaje = "Procesando en archivos..."
CASE smensaje="PROC_INFO"
   m.mensaje = "Procesando informaci¢n..."
CASE smensaje="INIC_SIS"
   m.mensaje = "Inicializando sistema..."
CASE smensaje="INIC_INF"
   m.mensaje = "Inicializando informaci¢n..."
CASE smensaje="CARG_SIS"
   m.mensaje = "Cargando sistema..."
CASE smensaje="CARG_INF"
   m.mensaje = "Cargando informaci¢n..."
CASE smensaje="IMPRIMIR"
   m.mensaje = "Imprimiendo..."
CASE smensaje="EOF"
   m.mensaje = "Fin de archivo"
CASE smensaje="BOF"
   m.mensaje = "Principio de archivo"
OTHER
   m.mensaje = smensaje
ENDCASE
IF EMPTY(m.mensaje)
   IF NOT EMPTY(m.currwin) AND m.currwin#[QUESTOY]
      SHOW WINDOW (m.currwin) TOP
   ENDIF
   RETURN
ENDIF
PRIVATE nlen,nancho,snombre
nlen   = LEN(m.mensaje)+2
IF nlen>78
   nlen = 78
ENDIF

nancho = LEN(PADC(ALLTRIM(m.mensaje),nlen))
snombre = [QUESTOY]

DO f1_caja WITH 2, nancho, snombre, 2,""
ACTIVATE WINDOW (snombre)
??CHR(7)
*IF SYS(2016) = "" OR SYS(2016) = "*"
*   ACTIVATE SCREEN
@ 0,0 SAY PADC(ALLTRIM(m.mensaje), WCOLS()) COLOR (c_linea)
*ENDIF

IF NOT EMPTY(m.currwin)
   SHOW WINDOW (snombre)   BOTT
   SHOW WINDOW (m.currwin) TOP
ENDIF

*******************************************
*                                         *
*            FUNCTION f0DCrip             *
*                                         *
*******************************************
*!*****************************************************************************
*!
*!       Function: F0DCRIP
*!
*!*****************************************************************************
FUNCTION f0dcrip
PARAMETER  ccad1 ,nsem1
PRIVATE ccar, npos, nlong,K,j
** Control de errores en los par metros
IF TYPE("cCad1") != "C"
   RETURN ""
ENDIF
** Proceso
nlong = LEN( ccad1 )

rotado =[]
v=MOD(nsem1,nlong)+1
DO WHILE LEN(rotado)<nlong
   IF v>nlong
      v=1
   ENDIF
   xchar=SUBSTR(ccad1,v,1)
   rotado=rotado+xchar
   v=v+1
ENDDO
ccad1 = rotado
semilla1=0
semilla2=0
j = nlong
FOR K= 1 TO LEN(ccad1)
   semilla1 = semilla1 + K+1
   semilla2 = semilla2 + K+j
   j= j - 1
NEXT
i1 = semilla1
i2 = semilla2
FOR npos = 1 TO nlong
   ** C¢digo ASCII de cada elemento m s la
   ** longitud de la cadena
   i1 = i1 - 1
   i2 = i2 + 1
   ccar  = CHR( ASC( SUBSTR( ccad1, npos, 1 ) ) + nlong )
   nval  = ASC( SUBSTR(ccad1,npos,1) )
   IF MOD(npos,2)=0
      IF i1-nval+nlong<i1
         nval =  i1 - nval + nlong
      ELSE
         nval =  nval + i1 - nlong
      ENDIF
   ELSE
      IF nval + i2 > 255
         IF i2>nval
            nval = i2 - nval + nlong
         ELSE
            nval = nval - i2 + nlong
         ENDIF
      ELSE
         nval = nval + i2
      ENDIF
   ENDIF
   ccar = CHR(nval)
   ** Reemplazamos el elemento de la cadena
   ** por el nuevo valor
   ccad1 = STUFF( ccad1, npos, 1, ccar )
NEXT

RETURN ccad1
*******************************
*                             *
*     FUNCTION f0Cript        *
*                             *
*******************************
*!*****************************************************************************
*!
*!       Function: F0CRIPT
*!
*!*****************************************************************************
FUNCTION f0cript
PARAMETER  ccad1 ,nsem1
PRIVATE ccar, npos, nlong,K,j,x
SET TALK OFF
SET ECHO OFF
** Control de errores en los par metros
IF TYPE("cCad1") != "C"
   RETURN ""
ENDIF
** Proceso
nlong = LEN( ccad1 )

rotado =[]
v=MOD(nsem1,nlong)+1
DO WHILE LEN(rotado)<nlong
   IF v>nlong
      v=1
   ENDIF
   xchar=SUBSTR(ccad1,v,1)
   rotado=rotado+xchar
   v=v+1
ENDDO
ccad1 = rotado
semilla1=64
semilla2=0
j = nlong
FOR K= 1 TO LEN(ccad1)
   semilla1 = semilla1 + K+1
   semilla2 = semilla2 + K+j
   j= j - 1
NEXT
i1 = IIF(semilla1+nsem1-32>256,127,semilla1)
i2 = IIF(semilla2+nsem1-32>256,127,semilla2)

FOR npos = 1 TO nlong
   ** C¢digo ASCII de cada elemento m s la
   ** longitud de la cadena
   i1 = i1 - 1
   i2 = i2 + 1


   nval  = ASC( SUBSTR(ccad1,npos,1) )
   IF MOD(npos,2)=0
      IF i1>nval
         x = i1 - nval + nsem1
      ELSE
         x = nval - i1 + nsem1
      ENDIF
   ELSE
      IF i2>nval
         x = i2 - nval + nsem1
      ELSE
         x = nval - i2  + nsem1
      ENDIF
   ENDIF
   ccar = CHR(x)
   ** Reemplazamos el elemento de la cadena
   ** por el nuevo valor
   ccad1 = STUFF( ccad1, npos, 1, ccar )
NEXT

RETURN ccad1
*************************
*                       *
* FUNCTION F0CHKSIS     *
*                       *
*************************
*!*****************************************************************************
*!
*!       Function: F0CHKSIS
*!
*!      Called by: belcsoft.PRG
*!
*!*****************************************************************************
FUNCTION f0chksis
*IF gsusuario#[GERENCIA]
*   GsUsuario=[GERENCIA]
*ENDIF
RETURN
*********************************
*
*     FUNCTION F1_APERT
*
*********************************
*!*****************************************************************************
*!
*!       Function: F1_APERT
*!
*!          Calls: MKDIR()            (function in ?)
*!               : F1MSGERR           (procedure in belcsoft.PRG)
*!               : INDEX_TAG          (procedure in belcsoft.PRG)
*!
*!           Uses: SISTEMAS.DBF           Alias: SIST
*!               : SISTDBFS.DBF           Alias: DBFS
*!               : SISTCDXS.DBF           Alias: TAGS
*!               : &CARCACT
*!               : &CARCNEW               Alias: DAT
*!
*!      CDX files: SISTEMAS.CDX
*!               : SISTDBFS.CDX
*!               : SISTCDXS.CDX
*!
*!    Other Files: DBF
*!
*!*****************************************************************************
FUNCTION f1_apert
PARAMETER __sistema,filmsg1,colmsg1,filmsg2,colmsg2
IF VARTYPE(__sistema)<>'C'
	__sistema = 'ALL'
ENDIF

LsPathIni =	SET("PATH")
lescmsg1 = .F.
lescmsg2 = .F.
IF PARAMETERS() >1
   lescmsg1 = .T.
ENDIF
IF PARAMETERS() >3
   lescmsg2 = .T.
ENDIF

m.currwind = WOUTPUT()
xancho = SCOL()
xlargo = SROW()
IF !EMPTY(m.currwind)
   xancho = WCOL()
   xlargo = WROW()
ENDIF


DO CASE
CASE _UNIX
   lcslash = [/]
CASE _DOS

   lcslash = [\]
ENDCASE

GsSistema=__Sistema
dirnew = ADDBS(goentpub.Tspathadm)+"CIA"+gscodcia+"\C"+STR(_ano+1,4,0)
diract = ADDBS(goentpub.Tspathadm)+"CIA"+gscodcia+"\C"+STR(_ano,4,0)
IF !DIRECTORY(DirNew)
	DO CASE
	CASE _DOS OR _UNIX
	   !mkdir &dirnew > null
	CASE _WINDOWS OR _MAC
	   MKDIR (dirnew)
	ENDCASE
ENDIF
Dirnew = ADDBS(Dirnew)
Diract = ADDBS(Diract)

********* ATENCION : LAS 11 LINEAS SIGUIENTES ES CODIGO TEMPORAL. VETT 12-02-2006
DO CASE 
	CASE GsSistema='ALMACEN'
		IF FILE(Dirnew+'ALMCATGE.DBF') AND FILE(Dirnew+'ALMCATAL.DBF') AND ;
			FILE(Dirnew+'ALMCTRAN.DBF') AND FILE(Dirnew+'ALMDTRAN.DBF') AND ;		
			FILE(Dirnew+'ALMCFTRA.DBF') AND FILE(Dirnew+'ALMCDOCM.DBF') AND ;
			FILE(Dirnew+'ALMDLOTE.DBF') 
			
			RETURN .T.
		ENDIF
	CASE GsSistema='CONTABILIDAD'
ENDCASE 
********* ATENCION : LAS 11 LINEAS ANTERIORES ES CODIGO TEMPORAL. VETT 12-02-2006
***** Copiando los archivos que no existan en este nuevo directorio ****
IF !USED([SIST])
   SELE 0
   USE sistemas ORDER sist01 ALIAS sist
   IF !USED()
      DO f1msgerr WITH [Error : Tabla de sistemas]
      RETURN .F.
   ENDIF
ENDIF
IF !USED([DBFS])
   SELE 0
   USE sistdbfs ORDER sistema ALIAS dbfs
   IF !USED()
      DO f1msgerr WITH [Error : Tabla de archivos del sistema]
      RETURN .F.
   ENDIF
ENDIF
IF !USED([TAGS])
   SELE 0
   USE sistcdxs ORDER sistema ALIAS tags
   IF !USED()
      DO f1msgerr WITH [Error : Tabla de archivos del sistema]
      RETURN .F.
   ENDIF
ENDIF

SELE sist
SEEK gssistema
IF !FOUND()
   DO f1msgerr WITH [Error : Sistema mal configurado]
   RETURN .F.
ENDIF

IF lescmsg1
   @ filmsg1,colmsg1 SAY [TRANSFIRIENDO ARCHIVOS...] SIZE 1,xancho - colmsg1 - 2
ENDIF
*** Bases de datos con las que trabajeremos ***
cPathDatos  =  GoEntPub.Tspathadm
cPathDb_CIA = ADDBS(cPathDatos)+"CIA"+cCodCia
cPathDb_ANO = ADDBS(cPathDatos)+"CIA"+cCodCia+"\C"+cAno
cPathDb_ANO_ACT = ADDBS(cPathDatos)+"CIA"+cCodCia+"\C"+STR(_ano,4,0)
LsNomBdAno = 'P'+cCodCia+cAno
LsNomBdCia = 'CIA'+cCodcia

IF !DIRECTORY(cPathDatos)
	MKDIR (cPathDatos)
ENDIF	
IF !DIRECTORY(cPathDB_ANO)
	MKDIR (cPathDB_ANO)
ENDIF	
IF !DIRECTORY(cPathDb_CIA)
	MKDIR (cPathDb_CIA)
ENDIF	
SET DEFAULT TO (cPathDb_ANO_ACT)

SELE 0
carchivo= LEFT(sist.codigo,3)+[*.dbf]
carcact = SYS(2000,diract+carchivo)
DO WHILE ! EMPTY(carcact)
   carcnew = dirnew+carcact
   =SEEK(PADR(gssistema,LEN(dbfs.sistema))+LEFT(carcact,8),[DBFS])
   IF ! FILE(carcnew)
*!*	   	  **********************
*!*	   	  FUNCTION CheckDataBase
*!*	   	  **********************
   	  DO CASE 
   	  	CASE DBFS.Ubicacion='PER'
   	  		LsNomBd = LsNomBdAno
   	  	CASE DBFS.Ubicacion='CIA'	
   	  		LsNomBd = LsNomBdCia
   	  	
   	  ENDCASE
		IF !FILE(LsNomBd+'.DBC')
			SET defa to (cPathDatos)
			CREATE DATABASE (LsNomBd)  && La Base de datos nueva o _ANO+1
			SET DEFAULT TO (cPathDb_ANO)
		ENDIF
	  			   	  
      USE &carcact
      DO CASE
      CASE !dbfs.trans_str
         IF lescmsg2
            @ filmsg2,colmsg2 SAY [TRANSFIRIENDO EN:]+carcnew SIZE 1,xancho - colmsg2 - 2
         ENDIF
         COPY TO (carcnew)   && WITH CDX
         USE &carcnew ALIAS dat EXCLU
         IF INLIST(carcact ,"CBDTOPER.DBF","ALMCDOCM.DBF","CMPCDOCM.DBF")
            FOR K = 0 TO 13
               campo = [NDOC]+TRAN(K,"@L ##")
               IF TYPE(campo)=[N]
                  REPLACE ALL &campo. WITH 1
               ENDIF
               IF carcact=[CMPCDOCM.DBF]
                  campob = [IDOC]+TRAN(K,"@L ##")
                  IF TYPE(campob)=[N]
                     REPLACE ALL &campob. WITH 1
                  ENDIF
               ENDIF
            ENDFOR
         ENDIF
         DO index_tag
         USE
         LsDB_ACT=SET("Database") 
         SET DATABASE TO (LsNomDB)
         ADD TABLE (cArcNew) 
		 SET DATABASE TO (LsDB_ACT)
      CASE dbfs.trans_str
         IF lescmsg2
            @ filmsg2,colmsg2 SAY [CREANDO :]+carcnew SIZE 1,xancho - colmsg2 - 2
         ENDIF
         COPY STRUCTU TO (carcnew)   && WITH CDX
         USE &carcnew ALIAS dat EXCLU
         IF INLIST(carcact,[CBDTCIER.DBF])
            DO WHILE RECCOUNT() < 14
               APPEND BLANK
               IF RECNO()<=2
                  REPLACE cierre WITH .F.
               ENDIF
            ENDDO
         ENDIF
         DO index_tag
         USE

         **OTHER
         **   COPY STRUCTU TO (cArcNEW) WITH CDX
      ENDCASE
      USE
   ENDIF
   carcact = SYS(2000,diract+carchivo,1)
ENDDO
**** ARCHIVOS DE MEMORIA *****************************
carchivo= lcslash+LEFT(sist.codigo,3)+[*.MEM]
carcact = SYS(2000,diract+carchivo)
DO WHILE ! EMPTY(carcact)
   carcnew = dirnew+carcact
   IF ! FILE(carcnew)
      COPY FILE &carcact TO &carcnew
   ENDIF
   carcact = SYS(2000,diract+carchivo,1)
ENDDO
*** Otros Archivos ***
*!*	*!*	carchivo= lcslash+[CBDTCIER]+[.DBF]
*!*	*!*	carcact = SYS(2000,diract+carchivo)
*!*	*!*	DO WHILE ! EMPTY(carcact)
*!*	*!*	   carcnew = dirnew+carcact
*!*	*!*	   IF lescmsg2
*!*	*!*	      @ filmsg2,colmsg2 SAY [CREANDO :]+carcnew SIZE 1,xancho - colmsg2 - 2
*!*	*!*	   ENDIF
*!*	*!*	   USE (carcact)
*!*	*!*	   COPY STRUCTU TO (carcnew)   && WITH CDX
*!*	*!*	   USE &carcnew ALIAS dat EXCLU
*!*	*!*	   IF INLIST(carcact,[CBDTCIER.DBF])
*!*	*!*	      DO WHILE RECCOUNT() < 14
*!*	*!*	         APPEND BLANK
*!*	*!*	         IF RECNO()<=2
*!*	*!*	            REPLACE cierre WITH .F.
*!*	*!*	         ENDIF
*!*	*!*	      ENDDO
*!*	*!*	   ENDIF
*!*	*!*	   **DO INDEX_TAG
*!*	*!*	   USE
*!*	*!*	   carcact = SYS(2000,diract+carchivo,1)
*!*	*!*	ENDDO

IF lescmsg1
   @ filmsg1,colmsg1 SAY REPLI(" ",xancho - colmsg1 - 2)
ENDIF
IF lescmsg2
   @ filmsg2,colmsg2 SAY REPLI(" ",xancho - colmsg2 - 2)
ENDIF
RETURN .T.
*******************
*!*****************************************************************************
*!
*!      Procedure: INDEX_TAG
*!
*!      Called by: F1_APERT()         (function in belcsoft.PRG)
*!
*!          Calls: F1_WMSG()          (function in belcsoft.PRG)
*!
*!        Indexes: &TAGIDX                (tag in SISTCDXS.CDX)
*!
*!*****************************************************************************
PROCEDURE index_tag
*******************
SELECT tags
SEEK dbfs.sistema+dbfs.archivo
SCAN REST WHILE dbfs.sistema+dbfs.archivo = tags.sistema+tags.archivo
   mensaje="Reconstruyendo: " + tags.indice
   DO f1_wmsg WITH mensaje, WCOLS(), WROWS() - 1
   campos = tags.llave
   tagidx = tags.indice
   m.Desc = IIF(TAGS.Descend,[DESCENDING],[])
   SELECT dat
   SET TALK ON
   SET TALK WINDOW
   INDEX ON &campos.  TAG  &tagidx.  COMPACT &DESC
   lsarccdx=dirnew+dbfs.archivo+".CDX"
   SET INDEX TO (lsarccdx)
   SET TALK OFF
   SELECT tags
ENDSCAN
SELE dat
RETURN

*********************************************************
*                                                       *
*    FUNCION F1USEROK : CHEQUEA USUARIO AUTORIZADO      *
*                                                       *
*********************************************************
*!*****************************************************************************
*!
*!       Function: F1USEROK
*!
*!      Called by: F1_MENUV()         (function in belcsoft.PRG)
*!               : QUE_HAGO           (procedure in belcsoft.PRG)
*!               : QUE_HAGOW          (procedure in belcsoft.PRG)
*!
*!*****************************************************************************
FUNCTION f1userok
PARAMETER _cmpMemo,_Variable
IF PARAMETER()=2
	IF EMPTY(_Variable) OR Empty(_CmpMemo)
		RETURN .T.
	ENDIF	
ELSE
	_CmpMemo =Usuarios
	_Variable=GsUsuario
ENDIF
m.numlin = MEMLINES(_CmpMemo)
_MLINE=0
lstotuser=[]
IF m.numlin<>0
   FOR K = 1 TO m.numlin
      lstotuser=lstotuser + MLINE(usuarios,1,_MLINE)
   ENDFOR
ENDIF
IF EMPTY(lstotuser)
   RETURN .T.
ELSE
   RETURN TRIM(_Variable)$lstotuser
ENDIF
****************************************************************************
** Pretendo generalizar ciertas variables que dependen del sistema operativo
****************************************************************************
*!*****************************************************************************
*!
*!       Function: F1CNFGSO
*!
*!*****************************************************************************
FUNCTION f1cnfgso
PUBLIC gsslash
gsslash = [\]
DO CASE
CASE _UNIX
   gsslash = [/]
CASE _MAC
   gsslash = [\]
CASE _DOS
   gsslash = [\]
CASE _WINDOWS
   gsslash = [\]
ENDCASE
RETURN

****************************
*
* PROCEDURE F1_ALARM
*
****************************
*!*****************************************************************************
*!
*!      Procedure: F1_ALARM
*!
*!          Calls: SEGUNDOS()         (function in ?)
*!
*!*****************************************************************************
PROCEDURE f1_alarm
PARAMETER N
if pARAMETERS()<1
	N=1
endif
do case 
	CASE N=1
		SET BELL TO 550,8
		??CHR(7)
		=INKEY(0.1)
		SET BELL TO 800,9
		??CHR(7)
		=INKEY(0.1)
		SET BELL TO 400,11
		??CHR(7)
		=INKEY(0.1)
		SET BELL TO 240,11
		??CHR(7)
		=INKEY(0.1)
		SET BELL TO 500,10
		??CHR(7)
	CASE N=2
		SET BELL TO 500,10
		??CHR(7)
		=INKEY(0.1)
		SET BELL TO 240,11
		??CHR(7)
		=INKEY(0.1)
		SET BELL TO 400,11
		??CHR(7)
		=INKEY(0.1)
		SET BELL TO 800,9
		??CHR(7)
		=INKEY(0.1)
		SET BELL TO 550,8
		??CHR(7)
	OTHER
endcase 

**!*****************************************************************************
*!
*!       Function: NUMERO
*!
*!*****************************************************************************
FUNC numero
PARAMETERS num , dec , strtipo

PRIVATE numtexto,cientexto,ciento,miles,largo,entero,DECIMAL

numtexto = []
cientexto= []
entero   = LTRIM(STR(INT(num),15,0))
DECIMAL  = RIGHT(STR(num,15,dec),dec)
largo    = LEN(entero)
ciento   = []
miles    = 0

DO WHILE largo > 0

   ciento    = RIGHT('   '+entero,3)     && Toma los Tres £ltimos digitos
   digito1   = SUBSTR(ciento,3,1)        && El Ultimo D¡gito
   digito2   = SUBSTR(ciento,2,1)        && Pen£ltimo D¡gito
   digito3   = SUBSTR(ciento,1,1)        && Antepen£ltimo D¡gito
   cientexto = []
   * Texto del £ltimo d¡gito *(UNIDADES)**********************************
   DO CASE
   CASE digito1='1'
      cientexto='uno'
   CASE digito1='2'
      cientexto='dos'
   CASE digito1='3'
      cientexto='tres'
   CASE digito1='4'
      cientexto='cuatro'
   CASE digito1='5'
      cientexto='cinco'
   CASE digito1='6'
      cientexto='seis'
   CASE digito1='7'
      cientexto='siete'
   CASE digito1='8'
      cientexto='ocho'
   CASE digito1='9'
      cientexto='nueve'
   ENDCASE
   * Texto de los dos £ltimos d¡gitos **(DECENAS)*************************
   DO CASE
   CASE digito2='1'
      DO CASE
      CASE digito1='0'
         cientexto='diez'
      CASE digito1='1'
         cientexto='once'
      CASE digito1='2'
         cientexto='doce'
      CASE digito1='3'
         cientexto='trece'
      CASE digito1='4'
         cientexto='catorce'
      CASE digito1='5'
         cientexto='quince'
      OTHERWISE
         cientexto='dieci'+cientexto
      ENDCASE
   CASE digito2='2'
      cientexto= IIF(digito1#'0','veinti'   +cientexto,'veinte')
   CASE digito2='3'
      cientexto= IIF(digito1#'0','treinti'  +cientexto,'treinta')
   CASE digito2='4'
      cientexto= IIF(digito1#'0','cuarenti' +cientexto,'cuarenta')
   CASE digito2='5'
      cientexto= IIF(digito1#'0','cincuenti'+cientexto,'cincuenta')
   CASE digito2='6'
      cientexto= IIF(digito1#'0','sesenti'  +cientexto,'sesenta')
   CASE digito2='7'
      cientexto= IIF(digito1#'0','setenti'  +cientexto,'setenta')
   CASE digito2='8'
      cientexto= IIF(digito1#'0','ochenti'  +cientexto,'ochenta')
   CASE digito2='9'
      cientexto= IIF(digito1#'0','noventi'  +cientexto,'noventa')
   ENDCASE
   * Texto de los tres £ltimos d¡gitos *(CENTENAS)************************
   DO CASE
   CASE digito3='1'
      cientexto= IIF(cientexto==[],'cien','ciento '+cientexto)
   CASE digito3='2'
      cientexto='doscientos '   +cientexto
   CASE digito3='3'
      cientexto='trescientos '  +cientexto
   CASE digito3='4'
      cientexto='cuatrocientos '+cientexto
   CASE digito3='5'
      cientexto='quinientos '   +cientexto
   CASE digito3='6'
      cientexto='seiscientos '  +cientexto
   CASE digito3='7'
      cientexto='setecientos '  +cientexto
   CASE digito3='8'
      cientexto='ochocientos '  +cientexto
   CASE digito3='9'
      cientexto='novecientos '  +cientexto
   ENDCASE
   ***********************************************************************

   IF miles > 0 .AND. RIGHT(cientexto,3)='uno'
      cientexto = SUBSTR(cientexto,1,LEN(cientexto)-1)
   ENDIF

   DO CASE
   CASE miles = 0
      numtexto= cientexto
   CASE (miles= 1 .OR. miles=3 .OR. miles=5) .AND. VAL(ciento)>0
      numtexto= cientexto + ' mil ' + LTRIM(numtexto)
   CASE miles = 2
      IF cientexto = 'un'
         numtexto  = 'un millon '+LTRIM(numtexto)
      ELSE
         numtexto  = cientexto+' millones '+LTRIM(numtexto)
      ENDIF
   CASE miles =4
      IF numtexto = 'millones'
         numtexto = []
      ENDIF
      IF cientexto= 'un'
         numtexto = 'un billon '+LTRIM(numtexto)
      ELSE
         numtexto = cientexto + ' billones '+LTRIM(numtexto)
      ENDIF
   ENDCASE
   miles   = miles +1
   entero  = SUBSTR(entero , 1 ,IIF(largo>3 ,largo-3,0) )
   largo   = LEN(entero)
ENDDO

numtexto = LTRIM(TRIM(numtexto))
IF numtexto == []
   numtexto = 'cero'
ENDIF

IF dec > 0
   numtexto = numtexto + ' con '+DECIMAL+'/100'
ENDIF
DO CASE
CASE  TYPE("StrTipo") <> "N"
CASE  strtipo = 1
   numtexto = UPPER(numtexto)
CASE  strtipo = 3
   numtexto = UPPER(SUBSTR(numtexto,1,1))+SUBSTR(numtexto,2,LEN(numtexto)-1)
CASE  strtipo = 4
   numtexto = PROPER(numtexto)
ENDCASE

RETURN numtexto
****************************************************
*                                                  *
*  FUNCTION F1_WMSG : MENSAJE EN VENTANA ACTIVA    *
*                                                  *
****************************************************
*!*****************************************************************************
*!
*!       Function: F1_WMSG
*!
*!      Called by: INDEX_TAG          (procedure in belcsoft.PRG)
*!
*!*****************************************************************************
FUNCTION f1_wmsg
PARAMETERS cadena_msj, anch_col, fila,COLU,Cod_col
cadena_msj = TRIM(cadena_msj)
IF PARAMETERS()<4
   STORE (anch_col - LEN(cadena_msj))/2 TO COLU
ENDIF
IF PARAMETERS()<5
   Cod_col = []  	
ELSE
   Cod_Col = COD_COL
ENDIF
IF COLU<0
   COLU = 0
   cadena_msj=LEFT(cadena_msj,WCOLS())
   anch_col = WCOLS()
ENDIF
IF LEN(cadena_msj)>anch_col
**   anch_col =len(cadena_msj)
ENDIF
if _dos or _unix
	@ fila, COLU SAY SPACE(anch_col) FONT 'SMALL FONTS',7
else
**	@ fila, COLU SAY REPLI([_],anch_col) FONT 'SMALL FONTS',7 &&COD_COL
	@ fila,colu clear to fila,colu+Anch_Col  
endif
IF !EMPTY(COD_COL)
	@ fila, COLU SAY LEFT(cadena_msj,anch_col) FONT 'SMALL FONTS',7 COLOR (COD_COL)
ELSE
	@ fila, COLU SAY LEFT(cadena_msj,anch_col) FONT 'SMALL FONTS',7 
ENDIF	
RETURN
******************************
*                            *
*  FUNCTION F1_DOW           *
*                            *
******************************
*!*****************************************************************************
*!
*!       Function: F1_DOW
*!
*!*****************************************************************************
FUNCTION f1_dow
PARAMETER _fecha,_forma
quedia=DOW(_fecha)
DO CASE
CASE quedia=1
   lscad=[domingo]
CASE quedia=2
   lscad=[lunes]
CASE quedia=3
   lscad=[martes]
CASE quedia=4
   lscad=[miercoles]
CASE quedia=5
   lscad=[jueves]
CASE quedia=6
   lscad=[viernes]
CASE quedia=7
   lscad=[sabado]
ENDCASE
DO CASE
CASE _forma=1
   RETURN lscad
CASE _forma=2
   RETURN UPPER(lscad)
CASE _forma=3
   RETURN LEFT(UPPER(lscad),1)+SUBSTR(lscad,2)
ENDCASE
RETURN

***********************************
*                                 *
*        FUNCTION F1_ALEA         *
*                                 *
***********************************
*!*****************************************************************************
*!
*!       Function: F1_ALEA
*!
*!*****************************************************************************
FUNCTION f1_alea
PARAMETER desde, hasta
RETURN INT((hasta-desde+1)*RAND()+desde)
*
*!*****************************************************************************
*!
*!      Procedure: ENCRIPTA
*!
*!      Called by: _CLAVE()           (function in belcsoft.PRG)
*!
*!*****************************************************************************
PROCEDURE encripta
PARAMETER parametro1, parametro2
PRIVATE LEN,retorno,xchar,x,rotado,dato,enc1
SET TALK OFF
SET ECHO OFF
dato = parametro1
enc1 = parametro2
LEN=LEN(dato)
retorno=[]
rotado =[]
x=MOD(enc1,LEN)+1
DO WHILE LEN(rotado)<LEN
   IF x>LEN
      x=1
   ENDIF
   xchar=SUBSTR(dato,x,1)
   rotado=rotado+xchar
   x=x+1
ENDDO
DO WHILE LEN>0
   xchar=ASC(SUBSTR(rotado,LEN,1))
   xchar=xchar-32+LEN
   IF xchar<0
      xchar=0
   ENDIF
   IF xchar>127
      xchar=xchar-127
   ELSE
      xchar=xchar+127
   ENDIF
   retorno=retorno+CHR(xchar)
   LEN=LEN-1
ENDDO
RETURN retorno

*!*****************************************************************************
*!
*!       Function: MES
*!
*!      Called by: GER_S_VB.PRG
*!               : VCONTROL()         (function in belcsoft.PRG)
*!               : _MES()             (function in GER_S_VB.PRG)
*!
*!*****************************************************************************
FUNC mes
PARAMETER parametro1, parametro2
PRIVATE nummes , mestexto , strtipo

IF varTYPE(Parametro1)='D' OR varTYPE(Parametro1)='T'
   nummes = MONTH(parametro1)
ELSE
   nummes = parametro1
ENDIF

DO CASE
CASE nummes = 0
   mestexto = ("apertura")
CASE nummes = 1
   mestexto = ("enero")
CASE nummes = 2
   mestexto = ("febrero")
CASE nummes = 3
   mestexto = ("marzo")
CASE nummes = 4
   mestexto = ("abril")
CASE nummes = 5
   mestexto = ("mayo")
CASE nummes = 6
   mestexto = ("junio")
CASE nummes = 7
   mestexto = ("julio")
CASE nummes = 8
   mestexto = ("agosto")
CASE nummes = 9
   mestexto = ("setiembre")
CASE nummes = 10
   mestexto = ("octubre")
CASE nummes = 11
   mestexto = ("noviembre")
CASE nummes = 12
   mestexto = ("diciembre")
CASE nummes = 13
   mestexto = ("cierre")
OTHER
   RETURN(" ")
ENDCASE
DO CASE
CASE  TYPE("Parametro2") <> "N"
CASE  parametro2= 1
   mestexto = UPPER(mestexto)
CASE  parametro2= 3
   mestexto = PROPER(mestexto)
ENDCASE
RETURN mestexto
**** ENVIA CODIGOS DE CONTROL A LA IMPRESORA ****
*!*****************************************************************************
*!
*!       Function: PSET
*!
*!*****************************************************************************
FUNCTION pset
*************
PARAMETER num1,num2
IF PARAMETER() < 1
   RETURN ""
ENDIF
DO CASE
CASE num1 = 0
   ??? _prn0
CASE num1 = 1
   ??? _prn1
CASE num1 = 2
   ??? _prn2
CASE num1 = 3
   ??? _prn3
CASE num1 = 4
   ??? _prn4
CASE num1 = 5
   ??? _prn5a+CHR(largo)+_prn5b
CASE num1 = 6
   IF PARAMETER() = 1 .OR. num2 = 0
      ??? _prn6a
   ELSE
      ??? _prn6b
   ENDIF
CASE num1 = 7
   IF PARAMETER() = 1 .OR. num2 = 0
      ??? _prn7a
   ELSE
      ??? _prn7b
   ENDIF
CASE num1 = 8
   IF PARAMETER() = 1 .OR. num2 = 0
      ??? _prn8a
   ELSE
      ??? _prn8b
   ENDIF
CASE num1 = 9
   IF PARAMETER() = 1 .OR. num2 = 0
      ??? _prn9a
   ELSE
      ??? _prn9b
   ENDIF
ENDCASE
RETURN ""
******************
*!*****************************************************************************
*!
*!       Function: PRNSTR
*!
*!*****************************************************************************
FUNCTION prnstr
******************
SET MARGIN TO 10
LIST STRU TO PRINT
N = 1
DO WHILE ! SYS(14,N)==""
   SET ORDER TO N
   ??? SPACE(10)+ORDER()+" "+SYS(14,N)+CHR(13)+CHR(10)
   N = N + 1
ENDDO
EJECT PAGE
RETURN
*+-----------------------------------------------------------------------------+
*Ý Nombre        Ý ADDMTCMB.prg                                                Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Sistema       Ý SISTEMA DE INFORMACION INTEGRAL                             Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Autor         Ý VETT                   Telf: 4841538                        Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Ciudad        Ý LIMA , PERU                                                 Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Direcci¢n     Ý Av. Bertello 170 - 401 Ciudad Satelite Sta. Rosa. - Callao  Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Prop¢sito     Ý Formulaci¢n de productos terminados o intermedios           Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Creaci¢n      Ý 18/12/95                                                    Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Actualizaci¢n Ý                                                             Ý
*Ý               Ý                                                             Ý
*+-----------------------------------------------------------------------------+


*+-----------------------------------------------------------------------------+
*Ý Nombre        Ý admmtabl.prg                                                Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Sistema       Ý APLICA                                                      Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Autor         Ý VETT                   Telf: 4841538                        Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Ciudad        Ý LIMA , PERU                                                 Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Direcci¢n     Ý Av. Bertello 170 - 401 Ciudad Satelite Sta. Rosa. - Callao  Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Prop¢sito     Ý Tablas auxiliares para los sistemas                         Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Creaci¢n      Ý 25/01/96                                                    Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Actualizaci¢n Ý                                                             Ý
*+-----------------------------------------------------------------------------+
*!*****************************************************************************
*!
*!      Procedure: ADMMTABL
*!
*!          Calls: F1_BASE()          (function in belcsoft.PRG)
*!               : PMOSTRAR.PRG
*!               : F1_EDIT            (procedure in belcsoft.PRG)
*!
*!           Uses: CBDMAUXI.DBF           Alias: AUXI
*!
*!*****************************************************************************

******************
procedure ResetPag
******************
IF LinFin <= PROW() .OR. NumPag = 0 ;
   .OR. SaltoPag
   SaltoPag = .F.
   IF NumPag > 0
      NumLin = LINFIN + 1
      IF NumLin < (PROW() + 1)
         NumLin = (PROW() + 1)
      ENDIF
      @ NumLin,Ancho -12  SAY "Continua.."
   ENDIF
   DO F0MBPRN
   IF InKey() = K_ESC
      Cancelar = .T.
   ENDIF
ENDIF
RETURN

***********************************FIN
*******************
*!*****************************************************************************
*!
*!      Procedure: ADMCMBST
*!
*!          Calls: F1_BASE()          (function in belcsoft.PRG)
*!               : PABREDBFS          (procedure in belcsoft.PRG)
*!               : PINIVAR            (procedure in belcsoft.PRG)
*!               : PBROWSE            (procedure in belcsoft.PRG)
*!

************************************************************************* FIN
* Procedimiento Pide el codigo de movimiento
******************************************************************************
*!*****************************************************************************
*!
*!      Procedure: PABREDBFS
*!
*!      Called by: ADMCMBST           (procedure in belcsoft.PRG)
*!
*!          Calls: F1QEH()            (function in belcsoft.PRG)
*!
*!           Uses: SISTDBFS.DBF           Alias: DBFS
*!
*!      CDX files: SISTDBFS.CDX
*!
*!*****************************************************************************
PROCEDURE pabredbfs_x

=f1qeh("ABRE_DBF")
** Abrimos areas a usar **
CLOSE DATA
SELE 0
USE sistdbfs ORDER sistema           ALIAS dbfs
IF !USED()
   CLOSE DATA
   RETURN
ENDIF

=f1qeh("OK")
RETURN
*****************
*!*****************************************************************************
*!
*!      Procedure: PINIVAR
*!
*!      Called by: ADMCMBST           (procedure in belcsoft.PRG)
*!

**********************************************
*                                            *
*  PROCEDURE BIGCHARS : LETRAS GRANDES       *
*                                            *
**********************************************
*!*****************************************************************************
*!
*!      Procedure: BIGCHARS
*!
*!*****************************************************************************
PROCEDURE bigchars
PARAMETER startx,starty,instring

SET BLINK OFF

IF startx > 20
   RETURN
ENDIF

curenty = starty
curlet = 1

IF "MONO" $ UPPER(SYS(2006))
   colorvar = "n/n"
ELSE
   colorvar = "n/b"
ENDIF

DO WHILE curlet <= LEN(instring) AND curenty < 89
   DO CASE
   CASE SUBSTR(instring,curlet,1) = " "
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 3,curenty + 5 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 6
   CASE SUBSTR(instring,curlet,1) = "t"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 5 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 6
      @ 0,0 SAY " __"
      @ 0,3 SAY "_" COLOR (colorvar)

      @ 1,0 SAY "___"
      @ 1,3 SAY "_" COLOR W+/N
      @ 1,4 SAY "_" COLOR (colorvar)

      @ 2,1 SAY "__ " COLOR W+/N

      @ 3,0 SAY " __"
      @ 3,3 SAY "_" COLOR W+/N

      @ 4,0 SAY "   __" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "."
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 5 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 6
      @ 3,0 SAY "__"
      *			@ 3,3 say "_" color w+/n

   CASE SUBSTR(instring,curlet,1) = "s"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 5 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 7
      @ 1,0 SAY "__"
      @ 1,2 SAY "_" COLOR W+/N
      @ 1,3 SAY "__"

      @ 2,0 SAY " _"
      @ 2,2 SAY "___" COLOR W+/N
      @ 2,5 SAY "_" COLOR (colorvar)

      @ 3,0 SAY "____"
      @ 3,4 SAY "_ " COLOR W+/N

      @ 4,0 SAY "  ___" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "e"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 5 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 7
      @ 1,0 SAY "__"
      @ 1,2 SAY "__" COLOR W+/N
      @ 1,4 SAY "_"

      @ 2,0 SAY "_____ " COLOR W+/N

      @ 3,0 SAY "__"
      @ 3,2 SAY "___" COLOR W+/N
      @ 3,5 SAY "_" COLOR (colorvar)

      @ 4,0 SAY "  ___" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "r"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 5 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 6
      @ 1,0 SAY "___"
      @ 1,3 SAY "_" COLOR W+/N
      @ 1,4 SAY "_" COLOR (colorvar)

      @ 2,0 SAY "__ " COLOR W+/N
      @ 2,3 SAY "_" COLOR (colorvar)

      @ 3,0 SAY "__ " COLOR W+/N

      @ 4,0 SAY " __" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "o"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 5 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 7
      *		@ 0,2 say "_"
      *		@ 0,3 say "__"
      @ 1,0 SAY "__"
      @ 1,2 SAY "__" COLOR W+/N
      @ 1,4 SAY "_"

      @ 2,0 SAY "__ __ " COLOR W+/N

      @ 3,0 SAY "__"
      @ 3,2 SAY "___ " COLOR W+/N

      @ 4,0 SAY "  ___" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "¢"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 5 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 7
      @ 0,2 SAY "_"
      @ 0,3 SAY "__"
      @ 1,0 SAY "__"
      @ 1,2 SAY "__" COLOR W+/N
      @ 1,4 SAY "_"

      @ 2,0 SAY "__ __ " COLOR W+/N

      @ 3,0 SAY "__"
      @ 3,2 SAY "___ " COLOR W+/N

      @ 4,0 SAY "  ___" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "a"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 6 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 8
      @ 1,0 SAY "__"
      @ 1,2 SAY "__" COLOR W+/N
      @ 1,4 SAY "_"

      @ 2,0 SAY "__"
      @ 2,2 SAY "___ " COLOR W+/N

      @ 3,0 SAY "__"
      @ 3,2 SAY "____" COLOR W+/N

      @ 4,0 SAY "  __ __" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "i"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 3 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 4
      @ 0,0 SAY "_"
      @ 0,1 SAY "_" COLOR W+/N
      @ 0,2 SAY "_" COLOR (colorvar)

      @ 1,0 SAY "__"
      @ 1,2 SAY "_" COLOR (colorvar)

      @ 2,0 SAY "__ " COLOR W+/N

      @ 3,0 SAY "__ " COLOR W+/N

      @ 4,0 SAY " __" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "n"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 5 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 7
      @ 1,0 SAY "__"
      @ 1,2 SAY "__" COLOR W+/N
      @ 1,4 SAY "_"

      @ 2,0 SAY "__ __ " COLOR W+/N

      @ 3,0 SAY "__ __ " COLOR W+/N

      @ 4,0 SAY " __ __" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "m"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 8 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 10
      @ 1,0 SAY "__"
      @ 1,2 SAY "__" COLOR W+/N
      @ 1,4 SAY "_"
      @ 1,5 SAY "__" COLOR W+/N
      @ 1,7 SAY "_"

      @ 2,0 SAY "__ __ __ " COLOR W+/N

      @ 3,0 SAY "__ __ __ " COLOR W+/N

      @ 4,0 SAY " __ __ __" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "f"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 6 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 7
      @ 0,0 SAY " __"
      @ 0,3 SAY "__" COLOR W+/N
      @ 0,5 SAY "_" COLOR (colorvar)

      @ 1,0 SAY "___"
      @ 1,3 SAY "_" COLOR W+/N
      @ 1,4 SAY "_" COLOR (colorvar)

      @ 2,1 SAY "__ " COLOR W+/N

      @ 3,1 SAY "__ " COLOR W+/N

      @ 4,0 SAY "  __" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "l"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 3 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 4
      @ 0,0 SAY "__"
      @ 0,2 SAY "_" COLOR (colorvar)

      @ 1,0 SAY "__ " COLOR W+/N

      @ 2,0 SAY "__ " COLOR W+/N

      @ 3,0 SAY "__ " COLOR W+/N

      @ 4,0 SAY " __" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "k"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 7 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 8
      @ 0,0 SAY "__"
      @ 0,2 SAY "_" COLOR (colorvar)

      @ 1,0 SAY "_____" COLOR W+/N
      @ 1,5 SAY "_" COLOR (colorvar)

      @ 2,0 SAY "____" COLOR W+/N
      @ 2,4 SAY "_" COLOR (colorvar)

      @ 3,0 SAY "__ " COLOR W+/N
      @ 3,3 SAY "___"

      @ 4,0 SAY " __  __" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "u"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 6 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 7
      @ 1,0 SAY "__"
      @ 1,2 SAY "_" COLOR (colorvar)
      @ 1,3 SAY "__"
      @ 1,5 SAY "_" COLOR (colorvar)

      @ 2,0 SAY "__ __ " COLOR W+/N

      @ 3,0 SAY "__"
      @ 3,2 SAY "_" COLOR W+/N
      @ 3,3 SAY "_"
      @ 3,4 SAY "_ " COLOR W+/N

      @ 4,0 SAY "  __ _" COLOR (colorvar)
      *
      * Code added by Lexitrans to generate the accented "u"
      *
   CASE SUBSTR(instring,curlet,1) = "£"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 6 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 7
      @ 0,2 SAY "_"
      @ 0,3 SAY "__"
      @ 1,0 SAY "__"
      @ 1,2 SAY "_" COLOR (colorvar)
      @ 1,3 SAY "__"
      @ 1,5 SAY "_" COLOR (colorvar)

      @ 2,0 SAY "__ __ " COLOR W+/N

      @ 3,0 SAY "__"
      @ 3,2 SAY "_" COLOR W+/N
      @ 3,3 SAY "_"
      @ 3,4 SAY "_ " COLOR W+/N

      @ 4,0 SAY "  __ _" COLOR (colorvar)
      *
      * End of code added by Lexitrans to generate the accented "u"
      *
      *
   CASE SUBSTR(instring,curlet,1) = "b"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 6 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 7
      @ 0,0 SAY "__"
      @ 0,2 SAY "_" COLOR (colorvar)

      @ 1,0 SAY "____" COLOR W+/N
      @ 1,4 SAY "_"

      @ 2,0 SAY "__ " COLOR W+/N
      @ 2,3 SAY " _"
      @ 2,5 SAY "_" COLOR (colorvar)

      @ 3,0 SAY "_____ " COLOR W+/N

      @ 4,0 SAY " ____" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "c"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 5 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 6
      @ 1,0 SAY "__"
      @ 1,2 SAY "__" COLOR W+/N
      @ 1,4 SAY "_" COLOR (colorvar)

      @ 2,0 SAY "__ " COLOR W+/N
      @ 2,3 SAY " _" COLOR (colorvar)

      @ 3,0 SAY "__"
      @ 3,2 SAY "__" COLOR W+/N
      @ 3,4 SAY "_" COLOR (colorvar)

      @ 4,0 SAY "  ___" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "d"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 5 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 7
      @ 0,0 SAY "   __"
      @ 0,5 SAY "_" COLOR (colorvar)

      @ 1,0 SAY "__"
      @ 1,2 SAY "___ " COLOR W+/N

      @ 2,0 SAY "_ " COLOR W+/N
      @ 2,2 SAY "_" COLOR (colorvar)
      @ 2,3 SAY "__ " COLOR W+/N

      @ 3,0 SAY "_____"
      @ 3,5 SAY "_" COLOR (colorvar)

      @ 4,0 SAY "  ____" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "q"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 5 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 7
      @ 1,0 SAY "__"
      @ 1,2 SAY "_" COLOR W+/N
      @ 1,3 SAY "__"
      @ 1,5 SAY "_" COLOR (colorvar)

      @ 2,0 SAY "_ " COLOR W+/N
      @ 2,2 SAY "_" COLOR (colorvar)
      @ 2,3 SAY "__ " COLOR W+/N

      @ 3,0 SAY "_____"
      @ 3,5 SAY "_" COLOR (colorvar)

      @ 4,0 SAY "  _" COLOR (colorvar)
      @ 4,3 SAY "__ " COLOR W+/N

      @ 5,0 SAY "    __" COLOR (colorvar)

   CASE SUBSTR(instring,curlet,1) = "g"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 6 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 7
      @ 1,0 SAY "__"
      @ 1,2 SAY "_" COLOR W+/N
      @ 1,3 SAY "__"
      @ 1,5 SAY "_" COLOR (colorvar)

      @ 2,0 SAY "_ " COLOR W+/N
      @ 2,2 SAY "_" COLOR (colorvar)
      @ 2,3 SAY "__ " COLOR W+/N

      @ 3,0 SAY "_____"
      @ 3,5 SAY "_" COLOR (colorvar)

      @ 4,0 SAY " _"
      @ 4,2 SAY "_" COLOR W+/N
      @ 4,3 SAY "_"
      @ 4,4 SAY "_ " COLOR W+/N

      @ 5,0 SAY "  ___" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "h"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 5 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 7
      @ 0,0 SAY "__" COLOR W+/N
      @ 0,2 SAY "_" COLOR (colorvar)

      @ 1,0 SAY "____" COLOR W+/N
      @ 1,4 SAY "_"

      @ 2,0 SAY "__ __ " COLOR W+/N

      @ 3,0 SAY "__ __ " COLOR W+/N

      @ 4,0 SAY " __ __" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "j"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 3 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 5
      @ 0,0 SAY " _"
      @ 0,2 SAY "_" COLOR W+/N
      @ 0,3 SAY "_" COLOR (colorvar)

      @ 1,0 SAY " __"
      @ 1,3 SAY "_" COLOR (colorvar)

      @ 2,1 SAY "__ " COLOR W+/N

      @ 3,1 SAY "__ " COLOR W+/N

      @ 4,0 SAY "_"
      @ 4,1 SAY "_ " COLOR W+/N
      @ 4,3 SAY "_" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "p"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 6 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 7
      @ 1,0 SAY "_____"

      @ 2,0 SAY "__ " COLOR W+/N
      @ 2,3 SAY " _"
      @ 2,5 SAY "_" COLOR (colorvar)

      @ 3,0 SAY "_____ " COLOR W+/N

      @ 4,0 SAY "__ " COLOR W+/N
      @ 4,3 SAY "__" COLOR (colorvar)

      @ 5,0 SAY " __" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "w"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 8 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 9
      @ 1,0 SAY "__"
      @ 1,2 SAY "_" COLOR (colorvar)
      @ 1,3 SAY "_"
      @ 1,4 SAY "_" COLOR (colorvar)
      @ 1,5 SAY "__"
      @ 1,7 SAY "_" COLOR (colorvar)

      @ 2,0 SAY "__"
      @ 2,2 SAY "_____ " COLOR W+/N

      @ 3,1 SAY "__ __ " COLOR W+/N

      @ 4,0 SAY "  __ __" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "x"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 7 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 8
      @ 1,0 SAY "_____"
      @ 1,5 SAY "_" COLOR W+/N
      @ 1,6 SAY "_" COLOR (colorvar)

      @ 2,0 SAY " ___"
      @ 2,4 SAY "_" COLOR W+/N
      @ 2,5 SAY "_" COLOR (colorvar)

      @ 3,0 SAY "__ " COLOR W+/N
      @ 3,3 SAY "_" COLOR (colorvar)
      @ 3,4 SAY "__" COLOR W+/N
      @ 3,6 SAY "_" COLOR (colorvar)

      @ 4,0 SAY " __  __" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "y"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 6 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 7
      @ 1,0 SAY "__"
      @ 1,2 SAY "_" COLOR (colorvar)
      @ 1,3 SAY "__"
      @ 1,5 SAY "_" COLOR (colorvar)

      @ 2,0 SAY "__ __ " COLOR W+/N

      @ 3,0 SAY " ___"
      @ 3,4 SAY "_ " COLOR W+/N

      @ 4,0 SAY " __"
      @ 4,3 SAY "_ " COLOR W+/N

      @ 5,0 SAY "  __" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "v"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 6 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 7
      @ 1,0 SAY "__"
      @ 1,2 SAY "_" COLOR (colorvar)
      @ 1,3 SAY "__"
      @ 1,5 SAY "_" COLOR (colorvar)

      @ 2,0 SAY "_"
      @ 2,1 SAY "_ __ " COLOR W+/N

      @ 3,0 SAY " __"
      @ 3,3 SAY "_ " COLOR W+/N

      @ 4,0 SAY "   _" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "/"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 4 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 6
      @ 0,0 SAY "   _"
      @ 0,4 SAY "_" COLOR (colorvar)

      @ 1,0 SAY "  _"
      @ 1,3 SAY "__" COLOR (colorvar)

      @ 2,0 SAY " _"
      @ 2,2 SAY "__" COLOR (colorvar)

      @ 3,0 SAY "_"
      @ 3,1 SAY "__" COLOR (colorvar)

      @ 4,0 SAY " _" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "z"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 6 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 7
      @ 1,0 SAY "_"
      @ 1,1 SAY "____" COLOR W+/N
      @ 1,5 SAY "_" COLOR (colorvar)

      @ 2,0 SAY " __"
      @ 2,3 SAY "_ " COLOR W+/N
      @ 2,5 SAY "_" COLOR (colorvar)

      @ 3,0 SAY "____" COLOR W+/N
      @ 3,4 SAY "_"

      @ 4,0 SAY " _____" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "|"
      startx = startx + 6
      curenty = starty
   CASE SUBSTR(instring,curlet,1) = "A"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 7 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 9
      @ 0,2 SAY "___" COLOR W+/N
      @ 0,5 SAY "_" COLOR (colorvar)

      @ 1,1 SAY "__ __" COLOR W+/N
      @ 1,6 SAY "_" COLOR (colorvar)

      @ 2,0 SAY "_"
      @ 2,1 SAY "______" COLOR W+/N

      @ 3,0 SAY "__ " COLOR W+/N
      @ 3,3 SAY "__" COLOR (colorvar)
      @ 3,5 SAY "__ " COLOR W+/N

      @ 4,0 SAY " __   __" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "B"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 6 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 8
      @ 0,0 SAY "____" COLOR W+/N
      @ 0,4 SAY "__"

      @ 1,0 SAY "___" COLOR W+/N
      @ 1,3 SAY "__"
      @ 1,5 SAY "_ " COLOR W+/N

      @ 2,0 SAY "__ " COLOR W+/N
      @ 2,3 SAY "_"  COLOR (colorvar)
      @ 2,4 SAY "__" COLOR W+/N
      @ 2,6 SAY "_"  COLOR (colorvar)

      @ 3,0 SAY "___" COLOR W+/N
      @ 3,3 SAY "__"
      @ 3,5 SAY "_ " COLOR W+/N

      @ 4,0 SAY " _____" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "C"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 8 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 9
      @ 0,0 SAY " __"
      @ 0,3 SAY "___" COLOR W+/N
      @ 0,6 SAY "_"

      @ 1,0 SAY "__ " COLOR W+/N
      @ 1,3 SAY "_" COLOR (colorvar)
      @ 1,4 SAY "  _"
      @ 1,7 SAY "_" COLOR (colorvar)

      @ 2,0 SAY "__ " COLOR W+/N
      @ 2,3 SAY "   _ "

      @ 3,0 SAY " _____"
      @ 3,6 SAY "_ " COLOR W+/N

      @ 4,0 SAY "   ____" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "D"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 6 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 8
      @ 0,0 SAY "____" COLOR W+/N
      @ 0,4 SAY "_"

      @ 1,0 SAY "__ " COLOR W+/N
      @ 1,3 SAY " __"
      @ 1,6 SAY "_" COLOR (colorvar)

      @ 2,0 SAY "__ " COLOR W+/N
      @ 2,3 SAY " __"
      @ 2,6 SAY "_" COLOR (colorvar)

      @ 3,0 SAY "_____ " COLOR W+/N
      @ 3,6 SAY "_" COLOR (colorvar)

      @ 4,0 SAY " ____" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "E"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 6 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 7
      @ 0,0 SAY "_____" COLOR W+/N
      @ 0,5 SAY "_" COLOR (colorvar)

      @ 1,0 SAY "___" COLOR W+/N
      @ 1,3 SAY "__"

      @ 2,0 SAY "__ " COLOR W+/N
      @ 2,3 SAY "___" COLOR (colorvar)

      @ 3,0 SAY "___" COLOR W+/N
      @ 3,3 SAY "__"

      @ 4,0 SAY " _____" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "F"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 6 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 7
      @ 0,0 SAY "_____" COLOR W+/N
      @ 0,5 SAY "_" COLOR (colorvar)

      @ 1,0 SAY "___" COLOR W+/N
      @ 1,3 SAY "_"

      @ 2,0 SAY "__ " COLOR W+/N
      @ 2,3 SAY "__" COLOR (colorvar)

      @ 3,0 SAY "__ " COLOR W+/N

      @ 4,0 SAY " __" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "G"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 8 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 9
      @ 0,0 SAY " __"
      @ 0,3 SAY "___" COLOR W+/N
      @ 0,6 SAY "_"

      @ 1,0 SAY "__ " COLOR W+/N
      @ 1,3 SAY "_" COLOR (colorvar)
      @ 1,4 SAY "  _"
      @ 1,7 SAY "_" COLOR (colorvar)

      @ 2,0 SAY "__ " COLOR W+/N
      @ 2,3 SAY " ___"
      @ 2,7 SAY "_" COLOR (colorvar)

      @ 3,0 SAY " _____"
      @ 3,6 SAY "_ " COLOR W+/N

      @ 4,0 SAY "   ____" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "H"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 7 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 8
      @ 0,0 SAY "__"
      @ 0,2 SAY "_ " COLOR (colorvar)
      @ 0,4 SAY "__"
      @ 0,6 SAY "_ " COLOR (colorvar)

      @ 1,0 SAY "___" COLOR W+/N
      @ 1,3 SAY "___"
      @ 1,6 SAY "_" COLOR (colorvar)

      @ 2,0 SAY "__ " COLOR W+/N
      @ 2,3 SAY "_" COLOR (colorvar)
      @ 2,4 SAY "__ " COLOR W+/N

      @ 3,0 SAY "__ " COLOR W+/N
      @ 3,3 SAY " "
      @ 3,4 SAY "__ " COLOR W+/N

      @ 4,0 SAY " __  __" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "I"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 3 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 4
      @ 0,0 SAY "__"
      @ 0,2 SAY "_" COLOR (colorvar)

      @ 1,0 SAY "__ " COLOR W+/N

      @ 2,0 SAY "__ " COLOR W+/N

      @ 3,0 SAY "__ " COLOR W+/N

      @ 4,0 SAY " __" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "J"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 6 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 7
      @ 0,0 SAY "   __"
      @ 0,5 SAY "_" COLOR (colorvar)

      @ 1,3 SAY "__ " COLOR W+/N

      @ 2,3 SAY "__ " COLOR W+/N

      @ 3,0 SAY "____"
      @ 3,4 SAY "_ " COLOR W+/N

      @ 4,0 SAY "  ___" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "K"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 7 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 9
      @ 0,0 SAY "__"
      @ 0,2 SAY "_" COLOR (colorvar)
      @ 0,3 SAY "__"
      @ 0,5 SAY "_" COLOR W+/N
      @ 0,6 SAY "_" COLOR (colorvar)

      @ 1,0 SAY "____ " COLOR W+/N
      @ 1,5 SAY "_" COLOR (colorvar)

      @ 2,0 SAY "____" COLOR W+/N
      @ 2,4 SAY "_"

      @ 3,0 SAY "__ " COLOR W+/N
      @ 3,3 SAY " ___"

      @ 4,0 SAY " __   __" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "L"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 6 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 7
      @ 0,0 SAY "__"
      @ 0,2 SAY "_" COLOR (colorvar)

      @ 1,0 SAY "__ " COLOR W+/N

      @ 2,0 SAY "__ " COLOR W+/N

      @ 3,0 SAY "___" COLOR W+/N
      @ 3,3 SAY "__"

      @ 4,0 SAY " _____" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "M"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 10 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 11
      @ 0,0 SAY "___   ___"
      @ 0,9 SAY "_" COLOR (colorvar)

      @ 1,0 SAY "____" COLOR W+/N
      @ 1,4 SAY " ____"
      @ 1,9 SAY "_" COLOR (colorvar)


      @ 2,0 SAY "__ ___ __ " COLOR W+/N

      @ 3,0 SAY "__ " COLOR W+/N
      @ 3,3 SAY " _"
      @ 3,5 SAY "__" COLOR (colorvar)
      @ 3,7 SAY "__ " COLOR W+/N

      @ 4,0 SAY " __  _  __" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "N"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 8 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 9
      @ 0,0 SAY "___  __"
      @ 0,7  SAY "_" COLOR (colorvar)

      @ 1,0 SAY "____" COLOR W+/N
      @ 1,4 SAY " __"
      @ 1,7 SAY "_" COLOR (colorvar)

      @ 2,0 SAY "__ " COLOR W+/N
      @ 2,3 SAY "_"
      @ 2,4 SAY "___ " COLOR W+/N

      @ 3,0 SAY "__ " COLOR W+/N
      @ 3,3 SAY " ___"
      @ 3,7 SAY " " COLOR W+/N

      @ 4,0 SAY " __   __" COLOR (colorvar)

   CASE SUBSTR(instring,curlet,1) = "O"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 7,curenty + 7 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 9
      @ 0,0 SAY " __"
      @ 0,3 SAY "_" COLOR W+/N
      @ 0,4 SAY "__"

      @ 1,0 SAY "__ " COLOR W+/N
      @ 1,3 SAY "_ " COLOR (colorvar)
      @ 1,5 SAY "__"
      @ 1,7 SAY "_" COLOR (colorvar)

      @ 2,0 SAY "__ " COLOR W+/N
      @ 2,3 SAY "  __"
      @ 2,7 SAY "_" COLOR (colorvar)

      @ 3,0 SAY " ____"
      @ 3,5 SAY "_ " COLOR W+/N
      @ 3,7 SAY "_" COLOR (colorvar)

      @ 4,0 SAY "   ___" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "P"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 6 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 8
      @ 0,0 SAY "___" COLOR W+/N
      @ 0,3 SAY "___"

      @ 1,0 SAY "__ " COLOR W+/N
      @ 1,3 SAY " __"
      @ 1,6 SAY "_" COLOR (colorvar)

      @ 2,0 SAY "_____ " COLOR W+/N
      @ 2,6 SAY "_" COLOR (colorvar)

      @ 3,0 SAY "__ " COLOR W+/N

      @ 4,0 SAY " __" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "Q"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 8 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 9
      @ 0,0 SAY " __"
      @ 0,3 SAY "_" COLOR W+/N
      @ 0,4 SAY "__"

      @ 1,0 SAY "__ " COLOR W+/N
      @ 1,3 SAY "_ " COLOR (colorvar)
      @ 1,5 SAY "__"
      @ 1,7 SAY "_" COLOR (colorvar)

      @ 2,0 SAY "__ " COLOR W+/N
      @ 2,3 SAY "_ __"
      @ 2,7 SAY "_" COLOR (colorvar)

      @ 3,0 SAY " _____"
      @ 3,6 SAY "__" COLOR (colorvar)

      @ 4,0 SAY "   ___" COLOR (colorvar)
      @ 4,6 SAY "_"
      @ 4,7 SAY "_" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "R"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 7 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 8
      @ 0,0 SAY "___" COLOR W+/N
      @ 0,3 SAY "___"

      @ 1,0 SAY "__ " COLOR W+/N
      @ 1,3 SAY " __"
      @ 1,6 SAY "_" COLOR (colorvar)

      @ 2,0 SAY "______" COLOR W+/N
      @ 2,6 SAY "_" COLOR (colorvar)

      @ 3,0 SAY "__ " COLOR W+/N
      @ 3,3 SAY " __"
      @ 3,6 SAY "_" COLOR (colorvar)

      @ 4,0 SAY " __  __" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "S"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 7 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 8
      @ 0,0 SAY "__"
      @ 0,2 SAY "___" COLOR W+/N
      @ 0,5 SAY "_"

      @ 1,0 SAY "_____"
      @ 1,5 SAY "__" COLOR (colorvar)

      @ 2,0 SAY "_  ___"
      @ 2,6 SAY "_" COLOR (colorvar)

      @ 3,0 SAY "_____"
      @ 3,5 SAY "_ " COLOR W+/N

      @ 4,0 SAY "  ____" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "T"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 7 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 8
      @ 0,0 SAY "_"
      @ 0,1 SAY "_____" COLOR W+/N
      @ 0,6 SAY "_" COLOR (colorvar)

      @ 1,2 SAY "__ " COLOR W+/N

      @ 2,2 SAY "__ " COLOR W+/N

      @ 3,2 SAY "__ " COLOR W+/N

      @ 4,0 SAY "   __" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "U"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 6 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 8
      @ 0,0 SAY "__"
      @ 0,2 SAY "_ " COLOR (colorvar)
      @ 0,4 SAY "__"
      @ 0,6 SAY "_ " COLOR (colorvar)

      @ 1,0 SAY "__ " COLOR W+/N
      @ 1,3 SAY " __"
      @ 1,6 SAY "_" COLOR (colorvar)

      @ 2,0 SAY "__ " COLOR W+/N
      @ 2,3 SAY " "
      @ 2,4 SAY "__ " COLOR W+/N

      @ 3,0 SAY "__"
      @ 3,2 SAY "_" COLOR W+/N
      @ 3,3 SAY "_"
      @ 3,4 SAY "__ " COLOR W+/N

      @ 4,0 SAY "  ____" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "V"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 7 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 9
      @ 0,0 SAY "__"
      @ 0,2 SAY "_" COLOR (colorvar)
      @ 0,3 SAY "  __"
      @ 0,7 SAY "_" COLOR (colorvar)

      @ 1,0 SAY " __"
      @ 1,3 SAY "_" COLOR (colorvar)
      @ 1,4 SAY "__ " COLOR W+/N
      @ 1,7 SAY "_" COLOR (colorvar)

      @ 2,0 SAY " __"
      @ 2,3 SAY "___ " COLOR W+/N

      @ 3,0 SAY "  __"
      @ 3,4 SAY "_ " COLOR W+/N

      @ 4,0 SAY "    _" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "W"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 10 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 12
      @ 0,0 SAY "__"
      @ 0,2 SAY "_ " COLOR (colorvar)
      @ 0,4 SAY "__"
      @ 0,6 SAY "_ " COLOR (colorvar)
      @ 0,8 SAY "__"
      @ 0,10 SAY "_" COLOR (colorvar)

      @ 1,0 SAY "__"
      @ 1,2 SAY "_" COLOR W+/N
      @ 1,3 SAY " __"
      @ 1,6 SAY "_" COLOR (colorvar)
      @ 1,7 SAY "__"
      @ 1,9 SAY "_ " COLOR W+/N

      @ 2,1 SAY "________ " COLOR W+/N

      @ 3,2 SAY "__ " COLOR W+/N
      @ 3,6 SAY "__ " COLOR W+/N
      @ 3,9 SAY "_" COLOR (colorvar)

      @ 4,0 SAY "   __  __" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "X"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 8 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 9
      @ 0,0 SAY "__"
      @ 0,2 SAY "_" COLOR (colorvar)
      @ 0,3 SAY "  __"
      @ 0,7 SAY "_" COLOR (colorvar)

      @ 1,0 SAY " ____"
      @ 1,5 SAY "_" COLOR W+/N
      @ 1,6 SAY "__" COLOR (colorvar)

      @ 2,0 SAY " __"
      @ 2,3 SAY "___" COLOR W+/N

      @ 3,0 SAY "__ " COLOR W+/N
      @ 3,3 SAY "_" COLOR (colorvar)
      @ 3,4 SAY " __"
      @ 3,7 SAY "_" COLOR (colorvar)

      @ 4,0 SAY " __   __" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "Y"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 9 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 10
      @ 0,0 SAY "__"
      @ 0,2 SAY "_" COLOR (colorvar)
      @ 0,3 SAY "   __"
      @ 0,8 SAY "_" COLOR (colorvar)

      @ 1,0 SAY " __"
      @ 1,3 SAY "_" COLOR (colorvar)
      @ 1,4 SAY " __"
      @ 1,7 SAY "__" COLOR (colorvar)

      @ 2,0 SAY "  ___"
      @ 2,5 SAY "_ " COLOR W+/N
      @ 2,7 SAY "_" COLOR (colorvar)

      @ 3,3 SAY "__ " COLOR W+/N

      @ 4,0 SAY "    __" COLOR (colorvar)
   CASE SUBSTR(instring,curlet,1) = "Z"
      DEFINE WINDOW ("letter" + ALLTRIM(STR(curlet))) ;
         FROM startx,curenty TO startx + 5,curenty + 6 ;
         NONE NOSHADOW
      ACTIVATE WINDOW ("letter" + ALLTRIM(STR(curlet)))
      curenty = curenty + 8
      @ 0,0 SAY "_"
      @ 0,1 SAY "_____" COLOR W+/N
      @ 0,6 SAY "_" COLOR (colorvar)

      @ 1,0 SAY "  __"
      @ 1,4 SAY "_ " COLOR W+/N
      @ 1,6 SAY "_" COLOR (colorvar)

      @ 2,0 SAY " __"
      @ 2,3 SAY "_ " COLOR W+/N

      @ 3,0 SAY "____" COLOR W+/N
      @ 3,4 SAY "__"

      @ 4,0 SAY " ______ " COLOR (colorvar)
   ENDCASE
   curlet = curlet + 1
ENDDO
*+-----------------------------------------------------------------------------+
*Ý Nombre        Ý ADMMTSIS.prg                                                Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Sistema       Ý APLICA                                                      Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Autor         Ý VETT                   Telf: 4841538 - 9411837              Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Ciudad        Ý LIMA , PERU                                                 Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Direcci¢n     Ý Av. Bertello 170 - 401 Ciudad Satelite Sta. Rosa. - Callao  Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Prop¢sito     Ý TABLAS DEL SISTEMA                                          Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Creaci¢n      Ý 18/12/96                                                    Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Actualizaci¢n Ý                                                             Ý
*Ý               Ý                                                             Ý
*+-----------------------------------------------------------------------------+

*!*****************************************************************************
*!
*!      Procedure: ABRIRDBFS
*!
*!      Called by: ADMMTCMB           (procedure in belcsoft.PRG)
*!               : ADMMSEDE           (procedure in belcsoft.PRG)
*!               : ADMMTSIS           (procedure in belcsoft.PRG)
*!
*!          Calls: F1QEH()            (function in belcsoft.PRG)
*!
*!           Uses: ADMMTCMB.DBF           Alias: TCMB
*!               : SEDES.DBF              Alias: SEDE
*!
*!      CDX files: ADMMTCMB.CDX
*!
*!*****************************************************************************
PROCEDURE abrirdbfs
*******************
=f1qeh([ABRE_DBF])

IF !USED([TSIS])
   USE (arc_tabl) IN 0 ORDER tabl01 ALIAS TABL
   IF !USED()
      **CLOSE DATA
      RETURN .F.
   ENDIF
ENDIF
=f1qeh([OK])
RETURN
********************

FUNCTION F1ABREDBF
******************
PARAMETER _ARC_DBF,_VER_RUTA,_EXCLU,_ALIAS,_TAG 
IF !_VER_RUTA
	IF !USED(_ALIAS)
		SELE 0
		IF _EXCLU
			USE (_ARC_DBF) ORDER (_TAG) ALIAS (_ALIAS) EXCLUSIVE
		ELSE
			USE (_ARC_DBF) ORDER (_TAG) ALIAS (_ALIAS) SHARED
		ENDIF			
		IF !USED()
			DO F1MSGERR WITH [ERROR AL ABRIR ]+_ARC_DBF
			RETURN .F.	
		ENDIF
	ENDIF	
ELSE
	IF !USED([DBFS])
		SELE 0
		USE SISTDBFS ORDER SISTEMA ALIAS DBFS
		IF !USED()
			RETURN .F.
		ENDIF
	ENDIF
	IF SEEK(PADR(GsSistema,LEN(Sistema))+_ARC_DBF,[DBFS])
		IF AT([?],PATH_001)					
			m.Ruta_Dbf=JUSTPATH(PATH_001)
			m.Ruta_Dbf=ADDBS(m.Ruta_Dbf)+IIF
		ELSE
		
		ENDIF		
	ELSE
		do f1msgerr with [TABLA ]+_ARC_DBF+[ NO ESTA CONFIGURADA]
		RETURN .F.
	ENDIF
ENDIF
RETURN .T.

*!*****************************************************************
*!
*!      Procedure: FORCEEXT
*!
*!*****************************************************************
FUNCTION forceext
* Force the extension of "filname" to be whatever ext is.
PARAMETERS filname,ext
PRIVATE ALL
IF SUBSTR(m.ext,1,1) = "."
   m.ext = SUBSTR(m.ext,2,3)
ENDIF

m.pname = justpath(m.filname)
m.filname = justfname(UPPER(ALLTRIM(m.filname)))
IF AT('.',m.filname) > 0
   m.filname = SUBSTR(m.filname,1,AT('.',m.filname)-1) + '.' + m.ext
ELSE
   m.filname = m.filname + '.' + m.ext
ENDIF
RETURN addbs(m.pname) + m.filname
*!*****************************************************************
*!
*!      Procedure: DEFAULTEXT
*!
*!*****************************************************************
FUNCTION defaultext
* Force the extension of "filname" to be whatever ext is, but only
* if filname doesn't already have an extension.
PARAMETERS filname,ext
PRIVATE ALL
IF EMPTY(justext(m.filname))
   IF SUBSTR(m.ext,1,1) = "."
      m.ext = SUBSTR(m.ext,2,3)
   ENDIF

   RETURN m.filname + '.' + m.ext
ELSE 
   RETURN filname
ENDIF      

*!*****************************************************************
*!
*!      Procedure: JUSTFNAME
*!
*!*****************************************************************
FUNCTION justfname
* Return just the filename (i.e., no path) from "filname"
PARAMETERS filname
PRIVATE ALL
IF RAT('\',m.filname) > 0
   m.filname = SUBSTR(m.filname,RAT('\',m.filname)+1,255)
ENDIF
IF RAT(':',m.filname) > 0
   m.filname = SUBSTR(m.filname,RAT(':',m.filname)+1,255)
ENDIF
RETURN ALLTRIM(UPPER(m.filname))

*!*****************************************************************
*!
*!      Procedure: JUSTSTEM
*!
*!*****************************************************************
FUNCTION juststem
* Return just the stem name from "filname"
PARAMETERS filname
PRIVATE ALL
IF RAT('\',m.filname) > 0
   m.filname = SUBSTR(m.filname,RAT('\',m.filname)+1,255)
ENDIF
IF RAT(':',m.filname) > 0
   m.filname = SUBSTR(m.filname,RAT(':',m.filname)+1,255)
ENDIF
IF AT('.',m.filname) > 0
   m.filname = SUBSTR(m.filname,1,AT('.',m.filname)-1)
ENDIF
RETURN ALLTRIM(UPPER(m.filname))

*!*****************************************************************
*!
*!      Procedure: JUSTEXT
*!
*!*****************************************************************
FUNCTION justext
* Return just the extension from "filname"
PARAMETERS filname
PRIVATE ALL
filname = JustFname(m.filname)   && prevents problems with ..\ paths
m.ext = ""
IF AT('.',m.filname) > 0
   m.ext = SUBSTR(m.filname,AT('.',m.filname)+1,3)
ENDIF
RETURN UPPER(m.ext)


*!*****************************************************************
*!
*!      Procedure: JUSTPATH
*!
*!*****************************************************************
FUNCTION justpath
* Return just the path name from "filname"
PARAMETERS m.filname
PRIVATE ALL
m.filname = ALLTRIM(UPPER(m.filname))
m.pathsep = IIF(_MAC,":", "\")
IF _MAC
   m.found_it = .F.
   m.maxchar = max(RAT("\", m.filname), RAT(":", m.filname))
   IF m.maxchar > 0
      m.filname = SUBSTR(m.filname,1,m.maxchar)
      IF RIGHT(m.filname,1) $ ":\" AND LEN(m.filname) > 1 ;
            AND !(SUBSTR(m.filname,LEN(m.filname)-1,1)  $ ":\")
         m.filname = SUBSTR(m.filname,1,LEN(m.filname)-1)
      ENDIF
      RETURN m.filname
   ENDIF
ELSE
   IF m.pathsep $ filname
      m.filname = SUBSTR(m.filname,1,RAT(m.pathsep,m.filname))
      IF RIGHT(m.filname,1) = m.pathsep AND LEN(m.filname) > 1 ;
            AND SUBSTR(m.filname,LEN(m.filname)-1,1) <> m.pathsep
         m.filname = SUBSTR(m.filname,1,LEN(m.filname)-1)
      ENDIF
      RETURN m.filname
   ENDIF      
ENDIF
RETURN ''

*!*****************************************************************
*!
*!      Procedure: ADDBS
*!
*!*****************************************************************
FUNCTION addbs
* Add a backslash to a path name if there isn't already one there
PARAMETER m.pathname
PRIVATE ALL
m.pathname = ALLTRIM(UPPER(m.pathname))
IF !(RIGHT(m.pathname,1) $ '\:') AND !EMPTY(m.pathname)
   m.pathname = m.pathname + IIF(_MAC,':','\')
ENDIF
RETURN m.pathname




*!*****************************************************************
*!
*!      Procedure: INVERT
*!
*!*****************************************************************
PROCEDURE invert
* Invert (i.e., index on all fields) the "filname" database

PARAMETERS filname
PRIVATE comp_stat, safe_stat, in_area, fstem, i

comp_stat = SET("COMPATIBLE")
safe_stat = SET("SAFETY")
SET COMPATIBLE TO FOXPLUS
SET SAFETY OFF

m.in_area = SELECT()          && currently selected area

m.fstem = makealias(juststem(m.filname))
IF USED(m.fstem)
   SELECT (m.fstem)
ELSE
   SELECT 0
   USE (m.filname)
ENDIF


FOR i = 1 TO FCOUNT()
   fldname = FIELD(i)
   IF !INLIST(TYPE(m.fldname),"M","G","P")
      WAIT WINDOW "Creando ¡ndice en "+m.fldname NOWAIT
      INDEX ON &fldname TAG (m.fldname)
   ENDIF
ENDFOR

IF m.in_area <> SELECT()
   USE
ENDIF
SELECT (m.in_area)
IF m.comp_stat = "ON" OR m.comp_stat = "DB4"
   SET COMPATIBLE TO DB4
ENDIF
IF m.safe_stat = "ON"
   SET SAFETY ON
ENDIF
RETURN


*!*****************************************************************
*!
*!      Procedure: OPENDBF
*!
*!*****************************************************************
FUNCTION opendbf
* Open a database and return the alias name, or an empty string
*   if the database could not be opened.  Prompt user to find 
*   database if necessary
PARAMETERS fname
PRIVATE stem
IF FILE(m.fname)
   m.stem = makealias(LEFT(juststem(m.fname),10))
   IF USED(m.stem)
      SELECT (m.stem)
   ELSE
      SELECT 0
      m.fname = LOCFILE(m.fname,'DBF',;
         'Buscar '+juststem(m.fname)+', ')
      IF EMPTY(m.fname)
         RETURN ''
      ELSE
         USE (m.fname)
      ENDIF
   ENDIF
   RETURN ALIAS()
ELSE
   RETURN ''
ENDIF

*!*****************************************************************
*!
*!      Procedure: ACTWIN
*!
*!*****************************************************************
FUNCTION actwin
* Activate window wind_name

parameter wind_name
PRIVATE ALL
wind_name = UPPER(ALLTRIM(m.wind_name))
IF !EMPTY(m.wind_name) AND WEXIST(m.wind_name)
   ACTIVATE WINDOW (m.wind_name)
ENDIF
RETURN ''


*!*****************************************************************
*!
*!      Procedure: ALERT
*!
*!*****************************************************************
PROCEDURE alert
* Display an error message, automatically sizing the message window
*    as necessary.  Semicolons in "strg" mean "new line".
PARAMETERS strg
PRIVATE in_talk, in_cons, numlines, i, remain, maxlen, keycode

in_talk = SET('TALK')
SET TALK OFF
in_cons = SET('CONSOLE')

m.numlines = OCCURS(';',m.strg) + 1

DIMENSION alert_arry[m.numlines]
m.remain = m.strg
m.maxlen = 0
FOR i = 1 TO m.numlines
   IF AT(';',m.remain) > 0
      alert_arry[i] = SUBSTR(m.remain,1,AT(';',m.remain)-1)
      alert_arry[i] = CHRTRAN(alert_arry[i],';','')
      m.remain = SUBSTR(m.remain,AT(';',m.remain)+1)
   ELSE
      alert_arry[i] = m.remain
      m.remain = ''
   ENDIF
   IF LEN(alert_arry[i]) > SCOLS() - 6
      alert_arry[i] = SUBSTR(alert_arry[i],1,SCOLS()-6)
   ENDIF
   IF LEN(alert_arry[i]) > m.maxlen
      m.maxlen = LEN(alert_arry[i])
   ENDIF
ENDFOR

m.top_row = INT( (SROWS() - 4 - m.numlines) / 2)
m.bot_row = m.top_row + 3 + m.numlines

m.top_col = INT((SCOLS() - m.maxlen - 6) / 2)
m.bot_col = m.top_col + m.maxlen + 6

DEFINE WINDOW alert FROM m.top_row,m.top_col TO m.bot_row,m.bot_col;
   DOUBLE COLOR SCHEME 7
ACTIVATE WINDOW alert

FOR i = 1 TO m.numlines
   @ i,3 SAY PADC(alert_arry[i],m.maxlen)
ENDFOR

SET CONSOLE OFF
keycode = 0
DO WHILE m.keycode = 0
   keycode = INKEY(0,'HM')
ENDDO
SET CONSOLE ON

RELEASE WINDOW alert

IF m.in_talk = "ON"
   SET TALK ON
ENDIF
IF m.in_cons = "OFF"
   SET CONSOLE OFF
ENDIF


*!*****************************************************************
*!
*!      Procedure: APPERROR
*!
*!*****************************************************************
PROCEDURE apperror
* Simple ON ERROR routine for FoxApp application

PARAMETERS e_program,e_message,e_source,e_lineno,e_error
CLEAR TYPEAHEAD

DO CASE
CASE e_error = 217     && invalid display mode
   SET CURSOR OFF
   WAIT WINDOW "Ese modo de presentaci¢n no est  disponible en su computadora."
   SET CURSOR ON
   RETURN
CASE e_error = 1707    && CDX not found.  Ignore it.
   RETURN
OTHERWISE

   ON ERROR
   m.e_source = ALLTRIM(m.e_source)
   DO alert WITH 'L¡nea n§: '+ALLTRIM(STR(m.e_lineno,5))+';' ;
      +'Programa: '+m.e_program +';' ;
      +'   Error: '+m.e_message +';' ;
      +'  Origen: '+IIF(LEN(m.e_source)<50,;
      m.e_source,SUBSTR(m.e_source,1,50)+'...')
   ON KEY
   CLOSE ALL
   CLEAR PROGRAM
   CLEAR WINDOW
   SET SYSMENU TO DEFAULT
   IF FILE("foxapp.fky")
      RESTORE MACROS FROM foxapp.fky
      DELETE FILE foxapp.fky
   ENDIF
   * Restore original error routine if possible
   IF TYPE('fxapp_error') = 'C'
      ON ERROR &fxapp_error
   ENDIF

   CANCEL
ENDCASE
RETURN

*!*****************************************************************
*!
*!      Procedure: SHOWPOP
*!
*!*****************************************************************
PROCEDURE showpop
* Determine if a popup can be displayed for this field
PARAMETERS sourcedbf, varname

PRIVATE sourcedbf, targetdbf, varname, i, retval

* varname is in Proper case coming from BROWSE
varname = UPPER(ALLTRIM(m.varname))

* See if any databases are keyed on varname
m.targetdbf = 0
FOR i = 1 TO m.numareas
   IF SUBSTR(dbflist[i,m.cfldnum],AT('.',dbflist[i,m.cfldnum])+1);
         == m.varname
      m.targetdbf = i
   ENDIF
ENDFOR

* Make sure we can display list
DO CASE
CASE m.targetdbf = 0
   WAIT WINDOW "No hay lista de selecci¢n disponible para ";
      +PROPER(m.varname)+'.' NOWAIT
   retval = "NULL"
CASE dbflist[m.targetdbf,m.cstemnum] = m.sourcedbf
   * The target database is the one we are in!

   * Show the popup, but don't allow any replacements.
   =disppop(dbflist[m.targetdbf,m.cdbfnum], m.varname)
   retval = "NULL"
OTHERWISE
   retval = disppop(dbflist[m.targetdbf,m.cdbfnum], m.varname)
ENDCASE

* Replace the selected value into the current field
IF TYPE("retval") = "C"
   IF retval <> "NULL"
      REPLACE &varname WITH retval
   ENDIF
ELSE
   REPLACE &varname WITH retval
ENDIF

RETURN
****************
FUNCTION DBFLIST
RETURN 
*!*****************************************************************
*!
*!      Procedure: DISPPOP
*!
*!*****************************************************************
FUNCTION disppop
* Display a scrollable list of items in the popdbf database
PARAMETERS popdbf, varname
PRIVATE ALL

* Store the value that varname has in the current database
varnameval = &varname

in_area = SELECT()
SELECT 0
USE (popdbf) AGAIN

* Make sure it has a TAG of varname
i = 1
tag_found = .F.
DO WHILE !EMPTY(TAG(i)) AND !tag_found
   tag_found = (TAG(i) == varname)
   IF !tag_found
      i = i + 1
   ENDIF
ENDDO
IF !tag_found
   INDEX ON (varname) TAG (varname)
ENDIF
SET ORDER TO TAG (varname)

* Position picklist at the default value 
SEEK varnameval
IF !FOUND()
   GOTO TOP
ENDIF

* Figure out where the pick list should go
DO CASE
CASE COL() < scol()/2
   s_col = scol()/2 + 1
   e_col = scol() - 1
   s_row = 5
   e_row = SROWS() - 3
CASE COL() >= scol()/2
   s_col = 2
   e_col = scol()/2 - 1
   s_row = 5
   e_row = SROWS() - 3
ENDCASE

* Display pick list
DEFINE WINDOW dbfwin FROM s_row, s_col TO e_row, e_col ;
   TITLE PROPER(varname)+" lista de selecci¢n" ;
   CLOSE GROW ZOOM FLOAT MINIMIZE ;
   COLOR SCHEME 11
*   COLOR W+/W,N/W,BG/N,BG/N,BG/N,N/BG,N/W,N+/N,BG/N,BG/N,+

ON KEY LABEL enter KEYBOARD CHR(23)
SET SYSMENU OFF
BROWSE WINDOW dbfwin NOEDIT NOAPPEND NODELETE
SET SYSMENU AUTOMATIC
ON KEY LABEL enter

* If user selected an item, return its value
IF LASTKEY() <> 27
   retval = &varname
ELSE
   retval = "NULL"
ENDIF

* Do housekeeping and return
RELEASE WINDOW dbfwin
USE
SELECT (in_area)

RETURN retval
*!*****************************************************************************
*!
*!    Procedure: FNADDQUOTES
*!
*!*****************************************************************************
FUNCTION fnaddquotes
PARAMETER m.fname

DO CASE
CASE INLIST(LEFT(m.fname,1), "'", '"', '[')
   RETURN m.fname
CASE AT('"', m.fname) = 0
   RETURN '"' + m.fname + '"'
CASE AT("'", m.fname) = 0
   RETURN "'" + m.fname + "'"
CASE AT("[", m.fname) = 0 AND AT("]", m.fname) = 0
   RETURN "[" + m.fname + "]"
OTHERWISE
   RETURN m.fname      
ENDCASE

*!*****************************************************************************
*!
*!    Procedure: MAKEALIAS
*!
*!*****************************************************************************
FUNCTION makealias
PARAMETER filname
m.filname = UPPER(ALLTRIM(m.filname))
m.filname = CHRTRAN(m.filname, ' ', '_')
m.filname = LEFT(m.filname, 10)
RETURN m.filname



*!*****************************************************************
*!
*!      Procedure: PUTOUT
*!
*!*****************************************************************
FUNCTION putout
* Copies a file with name "Pathname" from the path specified in "source"
* the the "target" path.

PARAMETERS pathname, source, target
PRIVATE pathname, source, target, filname, file1, file2

m.filname = justfname(m.pathname)
m.target = addbs(m.target)
m.source = addbs(m.source)
m.file1 = m.source + m.pathname
m.file2 = m.target + m.filname
IF FILE(m.file1)
    xxx=FOPEN(File1)
	IF xxx>0  
	    =FCLOSE(xxx) 
		WAIT WINDOW [Copiando ]+File1 +[ -> ]+ File2 nowait
		COPY FILE (file1) TO (file2)
	ENDIF
ENDIF

**********************
function cap_almctran  && Capturamos registros de la cabecera de almacen
*********************
parameter pcAlias,PcSubAlm,PcTipMov,PcCodMov,PcNroDoc
if PARAMETERS()=0
	LsWhere = []
	PcAlias = GoEntorno.TmpPath+SYS(3)
else
	do case
		case PARAMETERS()=1
			LsWhere = []
		case PARAMETERS()=2
			LsWhere = [almctran.Subalm=PcSubAlm]
		case PARAMETERS()=3
			LsWhere = [almctran.Subalm=PcSubAlm and almctran.TipMov=PcTipMov]
		case PARAMETERS()=4
			LsWhere = [almctran.Subalm=PcSubAlm and almctran.TipMov=PcTipMov and almctran.CodMov=PcCodmov]
		case PARAMETERS()=5
			LsWhere = [almctran.Subalm=PcSubAlm and almctran.TipMov=PcTipMov and almctran.CodMov=PcCodmov and almctran.NroDoc==PcNrodoc]
	endcase
ENDIF
LOCAL lsRutaTabla
lsRutaTabla=goentorno.remotepathentidad('almctran')
DO CASE
	CASE .T.
		IF USED(PcAlias)
		     USE IN (PcAlias)
		ENDIF
		lCreaTmp=goentorno.open_dbf1('TEMP_STR','CTRA',PcAlias,'','')
		SELECT CTRA
		SEEK  PcSubAlm+PcTipMov+PcCodMov+PcNroDoc
		IF FOUND()
			SCATTER MEMVAR memo
		ELSE
			SCATTER MEMVAR memo BLANK 
		ENDIF
		SELECT  (PcAlias)
		APPEND BLANK 
		GATHER MEMVAR MEMO 
		
	OTHERWISE 
		IF USED(PcAlias)
			USE IN (PcAlias)
		ENDIF

		if empty(lsWhere)
			SELECT 0
			select * from (lsRutaTabla) into table (PcAlias)
		ELSE
			IF VERSION(5) < 700    
				select * from (lsRutaTabla) where &LsWhere.	into Cursor temporal
				SELE Temporal
				LcArcTmp = GoEntorno.TmpPath+SYS(3)
				COPY TO (LcArcTmp)
				USE IN TEMPORAL
				SELE 0
				USE (LcArcTmp) ALIAS (PcAlias) exclusive
				
			ELSE
				SELECT 0
				select * from (lsRutaTabla) where &LsWhere.	into Cursor (PcAlias) readwrite
			ENDIF	
			

		ENDIF
ENDCASE 		
*********************
function cap_almdtran  && Capturamos registros de la cabecera de almacen
*********************
parameter pcAlias,PcSubAlm,PcTipMov,PcCodMov,PcNroDoc,PcWhere,PcFor

if PARAMETERS()=0
	LsWhere = []
	PcAlias = GoEntorno.TmpPath+SYS(3)
else
		IF PARAMETERS()=6
			PcFor = '.T.'
			IF VARTYPE(PcWhere)<>'C'
				PcWhere = '.T.'
			ENDIF
		ENDIF	
		IF PARAMETERS()=7
			IF VARTYPE(PcFor)<>'C'
				PcFor = '.T.'
			ENDIF
			IF VARTYPE(PcWhere)<>'C'
				PcWhere = '.T.'
			ENDIF
		ENDIF

		IF PARAMETERS()=1
			LsWhere = []
		ENDIF	
		IF PARAMETERS()=2
			PcTipMov=''
			PcCodMov=''
			PcNroDoc=''			
		ENDIF	
		IF PARAMETERS()=3
			PcCodMov=''
			PcNroDoc=''			
		ENDIF	
		IF PARAMETERS()=4
			PcNroDoc=''			
		ENDIF	
		IF PARAMETERS()=5
			PcNroDoc=TRIM(PcNroDoc)
		ENDIF	

	LsWhere = [almdtran.Subalm+almdtran.TipMov+almDtran.CodMov+almDtran.NroDoc+STR(almdtran.nroitm,3,0)=PcSubAlm+PcTipMov+PcCodMov+PcNroDoc]
ENDIF

IF VARTYPE(PcFor)<>'C'
	PcFor = '.T.'
ENDIF
IF VARTYPE(PcWhere)<>'C'
	PcWhere = '.T.'
ENDIF


LOCAL lsRutaDtra,LsRutaCatg
lsRutaDtra=goentorno.remotepathentidad('almdtran')
lsRutaCatg=goentorno.remotepathentidad('almcatge')
DO CASE 
	CASE PcSubAlm='G/R'
		IF USED(PcAlias)
			USE IN (PcAlias)
		ENDIF
		LOCAL LoDatAdm AS DataAdmin OF k:\aplvfp\classgen\vcxs\DOSVR.vcx
		LoDatAdm=CREATEOBJECT('DOSVR.DataAdmin')
		LoDatAdm.abrirtabla('TEMP_STR','DTRA',PcAlias,'','')
		LoDatAdm.Mod_str_tabla(PcAlias,'Agregar','CodMat2','C',LEN(CATG.CodMat),0)
		LoDatAdm.Mod_str_tabla(PcAlias,'Agregar','DesMat2','C',LEN(CATG.DesMat),0)
		LoDatAdm.Mod_str_tabla(PcAlias,'Agregar','UndStk','C',LEN(CATG.UndStk),0)
		LoDatAdm.Mod_str_tabla(PcAlias,'Agregar','NroReg','N',6,0)
		LoDatAdm.Mod_str_tabla(PcAlias,'Agregar','ChkSerie','L',1,0)
		LoDatAdm.Mod_str_tabla(PcAlias,'Agregar','T_Tramo','N',10,2)
		SELECT (PcAlias)
		INDEX on Nro_itm TAG OrdItems
		LOCAL LsLLaveGuia
		SELECT DTRA
		SET ORDER TO DTRA04 
		LsLlaveGuia=PADR(PcSubAlm,LEN(TpoRef))+PADR(PcTipMov,LEN(NroRef))
		SEEK LsLlaveGuia
		SCAN WHILE TpoRef+NroRef=LsLlaveGuia
		
			SCATTER MEMVAR 
			=SEEK(m.CodMat,'CATG')
			**m.DesMat = CATG.DesMat 
			m.UndStk = CATG.UndStk
			m.NroReg=RECNO()
			INSERT into (PcAlias) from memvar			
			SELECT DTRA
		ENDSCAN
	OTHERWISE
		DO CASE 
			CASE .t.	
				IF USED(PcAlias)
					USE IN (PcAlias)
				ENDIF
				LOCAL LoDatAdm AS DataAdmin OF k:\aplvfp\classgen\vcxs\DOSVR.vcx
				LoDatAdm=CREATEOBJECT('DOSVR.DataAdmin')
				LoDatAdm.abrirtabla('TEMP_STR','DTRA',PcAlias,'','')
				LoDatAdm.Mod_str_tabla(PcAlias,'Agregar','CodMat2','C',LEN(CATG.CodMat),0)
				LoDatAdm.Mod_str_tabla(PcAlias,'Agregar','DesMat2','C',LEN(CATG.DesMat),0)
				LoDatAdm.Mod_str_tabla(PcAlias,'Agregar','UndStk','C',LEN(CATG.UndStk),0)
				LoDatAdm.Mod_str_tabla(PcAlias,'Agregar','NroReg','N',6,0)
				LoDatAdm.Mod_str_tabla(PcAlias,'Agregar','ChkSerie','L',1,0)
				LoDatAdm.Mod_str_tabla(PcAlias,'Agregar','T_Tramo','N',10,2)
				LOCAL LsLLaveGuia
				SELECT DTRA
				SET ORDER TO DTRA01 
				LsLlaveGuia=PcSubAlm+PcTipMov+PcCodMov+PcNroDoc
				SEEK LsLlaveGuia
				SCAN WHILE SubAlm+TipMov+CodMov+NroDoc=LsLlaveGuia AND &PcWhere. FOR &PcFor.
				
					SCATTER MEMVAR 
					=SEEK(m.CodMat,'CATG')
					m.DesMat = CATG.DesMat 
					m.UndStk = CATG.UndStk
					m.NroReg=RECNO()
					INSERT into (PcAlias) from memvar			
					SELECT DTRA
				ENDSCAN

			OTHERWISE 
				if empty(lsWhere)
					select * from lsRutaDtra into table (PcAlias)
				ELSE
					IF VERSION(5)<700
						select almdtran.*,almcatge.desmat,almcatge.undstk,RECNO('almdtran') AS NROREG,SPACE(2) aS TipPre from &LsRutaDtra inner join &LsRutaCatg on ;
						 almdtran.codmat=almcatge.codmat where &LsWhere. ;
						 into Cursor temporal
				 		SELE Temporal
						LcArcTmp = GoEntorno.TmpPath+SYS(3)
						COPY TO (LcArcTmp)
						USE IN TEMPORAL
						SELE 0
						USE (LcArcTmp) ALIAS (PcAlias) exclusive
						
					ELSE
						select almdtran.*,almcatge.desmat,almcatge.undstk,RECNO('almdtran') AS NROREG, SPACE(2) aS TipPre from &LsRutaDtra inner join &LsRutaCatg on ;
						 almdtran.codmat=almcatge.codmat where &LsWhere. ;
						 into Cursor (PcAlias) readwrite

					ENDIF
				endif	
		
		ENDCASE	
ENDCASE
IF USED(PcAlias) 
	GO TOP IN (PcAlias)
ENDIF
************************
FUNCTION CORRELATIVO_ALM
************************
Lparameters _tabla,_tipMov,_CodMov,_Almacen,_Valor

_Tabla=goentorno.remotepathentidad(_Tabla)

LsTipTran=IIF(_TipMov='S','SALI','INGR')

Local LsCampo,LnNroDoc,LsPicture,LnLenSufijo,LnLenNDoc,LsCampo2
IF GlCorrU_I
**	m.sNroDoc = RIGHT(REPLI("0",LEN(m.sNroDoc)) + LTRIM(STR(cDOC->NroDoc)),LEN(m.sNroDoc))
	SELECT * from (_tabla) where Siglas='UNIQ' AND CodDoc=LsTipTran INTO CURSOR C_CDOC
	LsCampo = 'C_CDOC.NroDoc'
	LsCampo2 = 'NroDoc'
ELSE
	SELECT * from (_tabla) where TipMov=_Tipmov and Codmov=_Codmov and SubAlm=_Almacen INTO CURSOR C_CDOC
	LsCampo = 'C_CDOC.NDOC'+XsNroMes
	LsCampo2 = 'NDOC'+XsNroMes
ENDIF	
LnNroDoc= EVAL(LsCampo)
IF EMPTY(LnNroDoc) OR ISNULL(LnNroDoc)
	WAIT WINDOW NOWAIT "Falta definir en maestro de correlativos por almacen"
ENDIF
*INICIO AMAA 03-1-07 c_dtra -> dtra
LsPicture = "@L "+REPLI('#',LEN(dtra.NroDoc))
LnLenNDoc = LEN(dtra.NroDoc) - LEN(XsNroMes)

*IF CDOC->ORIGEN
	LnNroDoc = VAL(XsNroMes+RIGHT(TRANSF(LnNroDoc,LsPicture),LnLenNDoc))
*ENDIF
IF !_valor == '0'
	IF VAL(_Valor) > LnNroDoc
    	LnNroDoc = VAL(_Valor) + 1
	ELSE
    	LnNroDoc = LnNroDoc + 1
	ENDIF     
*!*	    DO CASE 
*!*	    	CASE XsNroMES <= "13"
*!*	        	LsCampo='NDOC'+XsNroMes
*!*	        OTHER
*!*	        	LsCampo='NRODOC'
*!*	   ENDCASE
   UPDATE (_Tabla) SET &LsCampo2. = LnNroDoc ;
   WHERE TipMov=_Tipmov and Codmov=_Codmov and SubAlm=_Almacen
ENDIF
RETURN  RIGHT(REPLI('0',LEN(dtra.NroDoc)) + LTRIM(STR(LnNroDoc)), 10)
**FIN
*******************
PROCEDURE ITEM2DTRA
*******************
PARAMETERS PsCursor,PcTpoRef,PcAnular 
IF PARAMETERS()<3 OR VARTYPE(PcAnular)<>'C'
	PcAnular=''
ENDIF
LsTpoRf1Ant=GoCfgAlm.TpoRf1

DO CASE 
	CASE PcTpoRef='FREE'
		IF USED('C_CTRA')
			USE IN C_CTRA
		ENDIF
		IF USED('C_DTRA')
			USE IN C_DTRA
		ENDIF
		LOCAL LoDatAdm AS DataAdmin OF k:\aplvfp\classgen\vcxs\DOSVR.vcx
		LoDatAdm=CREATEOBJECT('DOSVR.DataAdmin')
		IF !USED('DTRA')
			LoDatAdm.abrirtabla('ABRIR','ALMDTRAN',"DTRA",'DTRA01','')
		ENDIF
		IF !USED('CTRA')
			LoDatAdm.abrirtabla('ABRIR','ALMCTRAN',"CTRA",'CTRA01','')
		ENDIF

		LoDatAdm.abrirtabla('TEMP_STR','DTRA',"C_DTRA",'','')
		LoDatAdm.Mod_str_tabla("C_DTRA",'Agregar','CodMat2','C',LEN(CATG.CodMat),0)
		LoDatAdm.Mod_str_tabla("C_DTRA",'Agregar','DesMat2','C',LEN(CATG.DesMat),0)
		LoDatAdm.Mod_str_tabla("C_DTRA",'Agregar','UndStk','C',LEN(CATG.UndStk),0)
		LoDatAdm.Mod_str_tabla("C_DTRA",'Agregar','NroReg','N',6,0)
		lCreaTmp=LoDatAdm.abrirtabla('TEMP_STR','CTRA','C_CTRA','','')
	
		LsTabla=RUTATABLA('RUTA','ALMCDOCM','','','')

		SELECT (PsCurSor)
		SCAN
			SCATTER memvar	field EXCEPT nrorf1,NroRef,NroItm 
			SELECT CodMov,TipMov FROM (LsTabla ) WHERE SubAlm+CodDoc=m.SubAlm+m.CodDoc INTO CURSOR C_CodMov
			m.CodMov=c_CodMov.CodMov
			m.TipMov=c_CodMov.TipMov
			m.Factor = 1
			m.ImpCto = m.ImpLin
			m.CanDes = m.CanFac
			m.Tporef = m.CodDoc
			m.NroRef = m.NroDoc
			m.NroDoc = LEFT(CodDoc,1)+SUBSTR(m.nrodoc,2)
			m.NroReg = 0  && Siempre es nuevo registro
			INSERT INTO c_DTRA FROM MEMVAR  	
			m.Tporf1 = m.CodDoc
			m.NroRf1 = m.NroDoc
			GoCfGAlm.TpoRf1 = m.Tporf1
			IF !SEEK(m.SubAlm+m.TipMov+m.CodMov+m.NroDoc,'c_CTRA','CTRA01')
				INSERT INTO C_Ctra FROM memvar 
			ENDIF
		ENDSCAN
		SELECT C_CTRA
		LOCATE
		=gocfgalm.cap_cfg_transacciones(c_CTRA.TipMov,c_CTRA.CodMov) 
		SELECT C_CTRA
		GoCfGAlm.TpoRf1 = C_CTRA.Tporf1 && Conservamor el Tipo de documento segun facturación
		GoCfgAlm.XsTpoRef = C_CTRA.Tporf1
		** Ahora Borramos movimientos anteriores ** 
		=Borrar_Transaccion_Alm_X_ALM(PcAnular)
		** Grabamos
		IF PcAnular<>'E'  && Si es diferente de anular 
			LnTrnCtrl=Grabar_Transaccion_Alm_X_ALM('C_DTRA',PcTpoRef)
		ENDIF
		IF USED('C_CodMov')
			USE IN C_CodMov
		ENDIF
		IF USED('ALMCDOCM')
			USE IN ALMCDOCM
		ENDIF
		GoCfgAlm.TpoRf1 = LsTpoRf1Ant

		**>>  Vo.Bo. VETT  2008/12/09 15:09:01 
	CASE INLIST(PcTpoRef,'PROF','FACT','BOLE' )
		IF USED('C_CTRA')
			USE IN C_CTRA
		ENDIF
		IF USED('C_DTRA')
			USE IN C_DTRA
		ENDIF
		LOCAL LoDatAdm AS DataAdmin OF k:\aplvfp\classgen\vcxs\DOSVR.vcx
		LoDatAdm=CREATEOBJECT('DOSVR.DataAdmin')
		IF !USED('DTRA')
			LoDatAdm.abrirtabla('ABRIR','ALMDTRAN',"DTRA",'DTRA01','')
		ENDIF
		IF !USED('CTRA')
			LoDatAdm.abrirtabla('ABRIR','ALMCTRAN',"CTRA",'CTRA01','')
		ENDIF

		LoDatAdm.abrirtabla('TEMP_STR','DTRA',"C_DTRA",'','')
		LoDatAdm.Mod_str_tabla("C_DTRA",'Agregar','CodMat2','C',LEN(CATG.CodMat),0)
		LoDatAdm.Mod_str_tabla("C_DTRA",'Agregar','DesMat2','C',LEN(CATG.DesMat),0)
		LoDatAdm.Mod_str_tabla("C_DTRA",'Agregar','UndStk','C',LEN(CATG.UndStk),0)
		LoDatAdm.Mod_str_tabla("C_DTRA",'Agregar','NroReg','N',6,0)
		lCreaTmp=LoDatAdm.abrirtabla('TEMP_STR','CTRA','C_CTRA','','')
	
		LsTabla=RUTATABLA('RUTA','ALMCDOCM','','','')
		SELECT (PsCurSor)
		SCAN
			SCATTER memvar	field EXCEPT nrorf1,NroRef,NroItm 
			**>>  Vo.Bo. VETT  2008/12/10 13:38:04 
*!*				SELECT CodMov,TipMov FROM (LsTabla ) WHERE SubAlm+CodDoc=m.SubAlm+m.CodDoc INTO CURSOR C_CodMov
*!*				
*!*				m.CodMov=c_CodMov.CodMov
*!*				m.TipMov=c_CodMov.TipMov
			m.CodMov=GoCfgVta.sCodMov		&& Las proformas son manejadas por el objeto de transacciones de ventas
			m.TipMov=GoCfgVta.cTipMov		&& GoCfgVta
			**>>  Vo.Bo. VETT  2008/12/10 13:43:57 : FIN
			
			** VETT  13/05/2015 05:49 PM : Campo fecha no esta cuando es en base a un pedido 
			IF VARTYPE(FCHDOC)='U'
				m.FchDoc = GoCfgVta.XdFchDoc
			ENDIF
			
			
			m.Factor = m.FacEqu && OJO 
			m.ImpCto = m.ImpLin
			m.CanDes = IIF(PcTpoRef='PROF',m.CanPed,m.CanFac)
			m.TpoRef = IIF(EMPTY(m.CodDoc),PcTpoRef,m.CodDoc)
			m.NroRef = m.NroDoc
			m.NroDoc = IIF(m.TpoRef='PROF',LEFT(m.TpoRef,2)+SUBSTR(m.NroDoc,1),LEFT(m.TpoRef,1)+SUBSTR(m.nrodoc,2) )
			m.NroReg = 0  && Siempre es nuevo registro
			INSERT INTO c_DTRA FROM MEMVAR  	
			m.Tporf1 = m.TpoRef
			m.NroRf1 = m.NroDoc
			GoCfGAlm.TpoRf1 = m.Tporf1
			IF !SEEK(m.SubAlm+m.TipMov+m.CodMov+m.NroDoc,'c_CTRA','CTRA01')
				INSERT INTO C_Ctra FROM memvar 
			ENDIF
		ENDSCAN
		SELECT C_CTRA
		LOCATE
		=gocfgalm.cap_cfg_transacciones(c_CTRA.TipMov,c_CTRA.CodMov) 
		SELECT C_CTRA
		GoCfGAlm.TpoRf1 = C_CTRA.Tporf1 && Conservamor el Tipo de documento segun facturación
		GoCfgAlm.XsTpoRef = C_CTRA.Tporf1
		** Ahora Borramos movimientos anteriores ** 
		=Borrar_Transaccion_Alm_X_ALM(PcAnular)
		** Grabamos
		IF PcAnular<>'E'  && Si es diferente de anular 
			LnTrnCtrl=Grabar_Transaccion_Alm_X_ALM('C_DTRA',PcTpoRef)
		ENDIF
		IF USED('C_CodMov')
			USE IN C_CodMov
		ENDIF
		IF USED('ALMCDOCM')
			USE IN ALMCDOCM
		ENDIF
		GoCfgAlm.TpoRf1 = LsTpoRf1Ant

ENDCASE
**************************************
PROCEDURE Grabar_Transaccion_Alm_X_ALM
**************************************
PARAMETERS PcCursor , PcTpoRef
#include const.h

DO CASE 
	CASE INLIST(PcTpoRef,'G/R','FREE','PROF','FACT','BOLE')  && >>  Vo.Bo. VETT  2008/12/10 13:56:39 
		DO CASE
			CASE INLIST(PcTpoRef,'G/R')		
			    IF GoCfgVta.Crear = .T.
					GoCfgVta.CodSed		= GoCfgAlm.CodSed
					GoCfgVta.XsCodDoc	= PcTpoRef
					GoCfgVta.XsPtoVta   = GoCfgAlm.XsPtoVta
					GoCfgVta.CfgVar_ID('VTATDOCM')
					LsNroDoc = GoCfgVta.Gen_Id('0','VTATDOCM')
					**	Proximamente pondremos el siguiente codigo en la clase -> o-Negocios.Gen_Id , VETT 2009-04-14

					IF SEEK(PcTpoRef + LsNroDoc ,'GUIA','VGUI01')
						LlEncontreCorrelativo=.F.
						FOR K = 1 TO 10000
							GoCfgVta.Gen_Id(LsNroDoc,'VTATDOCM')
							LsNroDoc=GoCfgVta.Gen_Id('0','VTATDOCM')
							IF SEEK(PcTpoRef + LsNroDoc ,'GUIA','VGUI01')
					           LOOP
							ELSE
								LlEncontreCorrelativo=.T.
							   EXIT	    
							ENDIF
						ENDFOR
						IF !LlEncontreCorrelativo
							RETURN -1		
						ELSE
							SELECT C_CTRA
							replace NroRf1 WITH LsNroDoc
							GoCfgVta.Gen_Id(LsNroDoc,'VTATDOCM')
							RELEASE LsNroDoc
						ENDIF
					ELSE
						GoCfgVta.Gen_Id(LsNroDoc,'VTATDOCM')
						RELEASE LsNroDoc
					ENDIF
					** Fin:Proximamente pondremos el codigo anterior en la clase -> o-Negocios.Gen_Id
				 ELSE
				 	
				 ENDIF	
			OTHERWISE 	
		ENDCASE
		LnNumRegAct = 0	&& Contador de registros actualizados
		SELECT C_DTRA 
		INDEX on subalm+Tipmov+CodMov TAG MatxAlm  FOR !EMPTY(SubAlm) AND !EMPTY(CodMAt)
		SET ORDER TO MatxAlm
		LOCATE
		DO WHILE !EOF()  && OJO A ESTE PUNTO YA DEBE ESTAR GRABADO SUBALM,TIPMOV,CODMOV,CODMAT
			REPLACE CodSed WITH GsCodSed && GoCfgAlm.CodSed
			*** Verificamos que exista *** 
			IF SEEK(C_CTRA.TpoRf1+C_CTRA.NroRf1+C_DTRA.SubAlm+C_DTRA.TipMov+C_DTRA.CodMov,'CTRA','CTRA03')
				LsNroDoc = CTRA.NroDoc
				goCfgAlm.Crear = .F.
			ELSE
				DO CASE
					CASE	PcTpoRef='G/R' 
				    	LsNroDoc = correlativo_alm(GoCfgAlm.EntidadCorrelativo,TipMov,CodMov,SubAlm,'0')
					CASE	INLIST(PcTpoRef,'FREE','PROF','FACT','BOLE')
						LsNroDoc = C_CTRA.NroDoc
						
				ENDCASE    
			    goCfgAlm.Crear = .T.
			ENDIF    
			LlSoloCabecera = .T.
			SELECT C_DTRA
			*** Aqui guardamos la posicion del puntero para evitar desgracias
			PRIVATE LnRegActual
			LnRegActual = RECNO()
		    IF Grabar_transaccion_Alm(CodSed,SubAlm,TipMov,CodMov,@LsNroDoc,LlSoloCabecera) < 0 && Grabamos solo la cabecera del movimiento
		         *DO F1MsgErr WITH [IMPOSIBLE GENERAR ] &&+aDesMov(m.NumEle)+[ EN ]+ALMNOMBR(LsSubALm)
		         IF VERSION(2)=2
		             WAIT WINDOW [IMPOSIBLE GENERAR ]+TipMov+[ ]+ CodMov+ [ ]+ NroDoc 
			         SUSPEND 
			     ELSE
		             WAIT WINDOW [IMPOSIBLE GENERAR ]+TipMov+[ ]+ CodMov+ [ ]+ NroDoc NOWAIT 
		         ENDIF
		         SELE C_DTRA
		   	 	 STRTOFILE(PROGRAM()+" "+TTOC(DATETIME())+CRLF,ERRLOGFILE,.T.)
				 STRTOFILE("ALMACEN :"+Tporef+' '+Nroref+CRLF,ERRLOGFILE,.T.)
				 STRTOFILE("Nrodoc:"+subalm+'-'+tipmov+'-'+codmov+'-'+nrodoc+'-'+DTOC(fchdoc)+CRLF,ERRLOGFILE,.T.)
		    ENDIF
		    DIMENSION aRefPedidos[1,2] 
		    STORE '' TO aRefPedidos[1,2] 
		    LnNumRegAct = 0	&& Cantidad de registros actualizados
		    =Actualiza_item_almacen_borrados()  && Si han modificado y borrado items previamente grabados
			SELECT C_DTRA
			GO LnRegActual
			LsLlave=subalm+Tipmov+CodMov
			SCAN WHILE subalm+Tipmov+CodMov=LsLLave
				** Capturamos los pedidos de los registros procesados VETT 2015/03/12
				LnNumRegAct	=	LnNumRegAct + 1
				IF ALEN(aRefPedidos,1)<LnNumRegAct
					DIMENSION aRefPedidos[LnNumRegAct+5,2] 	
				ENDIF
				aRefPedidos[LnNumRegAct,1] = TpoRfb
				aRefPedidos[LnNumRegAct,2] = NroRfb
				**FIN VETT 2015/03/12
				replace NroDoc WITH LsNroDoc && Grabamos el NroDoc final grabado en la cabecera de la transaccion
				=GrbDetAlm_ITEM()
				SELECT C_DTRA
			ENDSCAN
			SELECT C_DTRA
		ENDDO
		
		IF LnNumRegAct > 0
			DIMENSION aRefPedidos[LnNumRegAct,2]
			** Actualizamos Cabecera de Pedidos	- VETT 2015/03/12
			FOR K = 1 TO LnNumRegAct
				GoCfgAlm.xAct_Ped_GR_CAB(aRefPedidos[K,1],aRefPedidos[K,2])
			ENDFOR
		ENDIF
	
ENDCASE		
RETURN 1
* Procedimiento de Grabaci¢n de informaci¢n
********************************
FUNCTION Grabar_transaccion_Alm
********************************
PARAMETERS  m.cCodSed, m.cSubAlm, m.cTipMov , m.sCodMov , m.sNroDoc,m.lSinDetalle
IF PARAMETERS()<6
	m.lSinDetalle = .F.
ENDIF
=F1QEH("GRAB_DBFS")

IF GoCfgAlm.lPidCli
   GoCfgAlm.sCodCli = GoCfgAlm.sCodAux
ENDIF
IF GoCfgAlm.lPidPro
   GoCfgAlm.sCodPro = GoCfgAlm.sCodAux
ENDIF
IF GoCfgAlm.lPidActFijo
   GoCfgAlm.sCodPar = GoCfgAlm.sCodAux
ENDIF
*
IF GoCfgAlm.Crear                  && Creando
   =F1QEH("GRAB_CABE")
*!*	   SELE CDOC
*!*	   IF .NOT. F1_RLock(5)
*!*			UltTecla = K_ESC
*!*	    	RETURN .F.             && No pudo bloquear registro
*!*	   ENDIF

	IF goentorno.sqlentorno
		&& Hacer Sentencia SQL
		&& Evaluar si existe registro
		&& asignar a lEncontro
	ELSE
		SELECT CTRA
		lEncontro = SEEK(m.cSubAlm + m.cTipMov + m.sCodMov + m.sNroDoc ,'CTRA','CTRA01') 
	ENDIF
	IF SEEK(m.cSubAlm + m.cTipMov + m.sCodMov + m.sNroDoc ,'CTRA','CTRA01') 
		*** Rutina para asegurarnos que siempre grabe con un nuevo correlativo intentamos 10000 veces 
		*** CHOLO TERCO !!!
		LlEncontreCorrelativo=.F.
		FOR K = 1 TO 10000
			=correlativo_alm(GoCfgAlm.EntidadCorrelativo,m.cTipMov,m.sCodMov,m.cSubAlm,m.sNroDoc)		
			m.sNroDoc=correlativo_alm(GoCfgAlm.EntidadCorrelativo,m.cTipMov,m.sCodMov,m.cSubAlm,'0')
			IF SEEK(m.cSubAlm + m.cTipMov + m.sCodMov + m.sNroDoc ,'CTRA','CTRA01')
	           LOOP
			ELSE
				LlEncontreCorrelativo=.T.
			   EXIT	    
			ENDIF
		ENDFOR
		IF !LlEncontreCorrelativo
			RETURN -1		
		ENDIF
	ENDIF
	INSERT INTO CTRA (CodSed,SubAlm,TipMov,CodMov,NroDoc) VALUES (m.cCodSed,m.cSubAlm,m.cTipMov,m.sCodMov,m.sNroDoc)
*!*	   REPLACE CTRA->CodAlm WITH GsCodAlm
*!*	   REPLACE CTRA->SubAlm WITH GsSubAlm
*!*	   REPLACE CTRA->TipMov WITH m.cTipMov
*!*	   REPLACE CTRA->CodMov WITH m.sCodMov
*!*	   REPLACE CTRA->NroDoc WITH m.sNroDoc
*!*	   SELECT CDOC
*!*	   IF GlCorrU_I
*!*		   IF m.sNroDoc >= RIGHT(REPLI("0",LEN(m.sNroDoc)) + LTRIM(STR(CDOC->NroDoc)),LEN(m.sNroDoc))
*!*		      REPLACE CDOC->NroDoc WITH CDOC->NroDoc + 1
*!*		   ENDIF
*!*		   UNLOCK
*!*	   ELSE 
*!*		   =NROAST(m.sNroDoc)
*!*	   ENDIF                
*!*	  SELECT CTRA
   =correlativo_alm(GoCfgAlm.EntidadCorrelativo,m.cTipMov,m.sCodMov,m.cSubAlm,m.sNroDoc)  
ELSE
   =F1QEH("GRAB_CABE")
  *** Rectifica cambios hechos en la cabezera, cambien en el cuerpo del **
  *** documento.                                                        ***
  =SEEK(m.cSubAlm+m.cTipMov+m.sCodMov+m.sNroDoc	,'CTRA','CTRA01')
   IF CTRA.FchDoc != C_CTRA.FchDoc .OR. ;
      CTRA.CodPro != C_CTRA.CodPro .OR. ;
      CTRA.CodVen != C_CTRA.CodVen .OR. ;
      CTRA.CodCli != C_CTRA.CodCli .OR. ;
      CTRA.NroOdt != C_CTRA.NroOdt .OR. ;
      CTRA.CodMon != C_CTRA.CodMon .OR. ;
      CTRA.TpoCmb != C_CTRA.TpoCmb .OR. ;
      CTRA.CodPrd != C_CTRA.CodPrd .OR. ;
      CTRA.FBatch != C_CTRA.fBatch  .OR. ;
      _ChkRef()

	Local  LsLLave_reg
	SELE C_DTRA
*!*	      LsLLave  = GsSubAlm+m.cTipMov+m.sCodMov+m.sNroDoc
*!*	      SEEK LsLLave
*!*	      DO WHILE LsLLave = (SubAlm+TipMov+CodMov+NroDoc) .AND. ! EOF()

	* @_@ Solo cheuqeamos los registros que ya existen. NO los nuevos
	SCAN FOR !EMPTY(NROREG) 
**	 IF F1_RLOCK(5)
		LsLlave_reg = C_DTRA.SubAlm+C_DTRA.TipMov+C_DTRA.CodMov+C_DTRA.NroDoc  + STR(C_DTRA.NroItm,3,0)
		 IF  !SEEK(LsLLave_Reg,'DTRA','DTRA01')
		 	WAIT WINDOW 'Que raro se supone que ya esta grabado y no lo encuentro, estara mal la llave?' 
		 	LOOP
		 ENDIF
	    RegAct = NROREG   && @_@ Numero de registro en la tabla real
	    lAcPre = ( DTRA.FchDoc != C_CTRA.FchDoc ) .OR. ( DTRA.CodMon != C_CTRA.CodMon ) ;
	     .OR. ( DTRA.TpoCmb != C_CTRA.TpoCmb )
	    lCmFch = DTRA.FchDoc  > FchDoc  && Barrer desde el principio
		 
	    IF !EMPTY(GoCfgAlm.XsTpoRef)	&& Si hay documento de referencia
	       LsTpoRef = GoCfgAlm.XsTpoRef
	   		LsCadenaEval2 = GoCfgAlm.VarRef
	**       IF EMPTY(NroRef)				&& Asignamos segun referencia que tenga
		  		LsNroRef = IIF(!EMPTY(GoCfgAlm.VarRef),&LsCadenaEval2.,[])
	**       ENDIF
		ELSE 	&& Lo dejamos como estaba
			LsTpoRef = TpoRef
			LsNroRef = NroRef	       
	    ENDIF
	    
	    UPDATE DTRA SET ;	    
		     FchDoc = C_CTRA.FchDoc, ;   && OJO ALTERA EL PROMEDIO
		     CodPro = C_CTRA.CodPro, ;
		     CodMon = C_CTRA.CodMon, ;    && OJO ALTERA EL PROMEDIO
		     TpoCmb = C_CTRA.TpoCmb, ;    && OJO ALTERA EL PROMEDIO
			 CodCli = C_CTRA.CodCli, ;
		     TpoRef = LsTpoRef, ;
		     NroRef = LsNroRef, ;
		     FBatch = C_CTRA.FBatch ;
		WHERE    Subalm = m.cSubAlm AND ;
			TipMov = m.cTipMov AND ; 			  	     	
			CodMov = m.sCodMov AND  ;
       		NroDoc = m.sNroDoc AND ;
			NroItm = C_DTRA.NroItm
		     
	    *** AQUI
*!*		    IF !EMPTY(GoCfgAlm.XsTpoRef)
*!*		       REPLACE TpoRef WITH GoCfgAlm.XsTpoRef
*!*		       IF EMPTY(NroRef)
*!*			  REPLACE NroRef WITH IIF(!EMPTY(GoCfgAlm.VarRef),m.GoCfgAlm.&VarRef.,[])
*!*		       ENDIF
*!*		    ENDIF
	    lAcCsmo=GoCfgAlm.lModCsm AND (C_CTRA.FBatch<>CTRA.FBatch OR CodPrd<>CTRA.CodPrd ;
		    OR lAcPre)
	    IF lAcCsmo					
		    UPDATE DTRA SET ;	    
				TpoRef = GoCfgAlm.XsTpoRef , ;
				CodPrd = C_DTRA.CodPrd, ;
				NroRef = C_CTRA.NroOdt, ;
				FBatch = C_CTRA.FBatch ;
			WHERE    Subalm = m.cSubAlm AND ;
				TipMov = m.cTipMov AND ; 			  	     	
				CodMov = m.sCodMov AND  ;
	       		NroDoc = m.sNroDoc AND ;
				NroItm = C_DTRA.NroItm
				=GRABA_CONSUMOS_PRODUCCION(DTRA.CodMat,DTRA.CodPrd,DTRA.FchDoc,DTRA.TipMov,-DTRA.Candes,NroReg,'ESTA',CTRA.CodLote)
	    ENDIF
	    *
	    lActTra=GoCfgAlm.lAfeTra AND (C_CTRA.FBatch<>CTRA.FBatch OR CodPrd<>CTRA.CodPrd ;
		    OR lAcPre)
		*   
	    IF lActTra
		    UPDATE DTRA SET ;	    
				NroRef = C_CTRA.NroOdt, ;
				FBatch = C_CTRA.FBatch ;
			WHERE    Subalm = m.cSubAlm AND ;
				TipMov = m.cTipMov AND ; 			  	     	
				CodMov = m.sCodMov AND  ;
	       		NroDoc = m.sNroDoc AND ;
				NroItm = C_DTRA.NroItm
	       		=GRABA_CONSUMOS_PRODUCCION(DTRA.CodMat,DTRA.CodPrd,DTRA.FchDoc,DTRA.TipMov,-DTRA.Candes,NroReg,'ESTR',CTRA.CodLote)
	    ENDIF
        *
        =CALC_ACT_COSTOPROMEDIOUNIT(NroReg,lCmFch)
        *
	    SELE C_DTRA
	    IF lAcCsmo
	    	=GRABA_CONSUMOS_PRODUCCION(CodMat,CodPrd,FchDoc,TipMov,Candes,nroreg,'ESTA',C_CTRA.CodLote)
	    ENDIF
	    *
	    IF lActTra
			=GRABA_CONSUMOS_PRODUCCION(CodMat,CodPrd,FchDoc,TipMov,Candes,nroreg,'ESTR',C_CTRA.CodLote)
	    ENDIF
		SELE C_dtra	
	ENDSCAN
   ENDIF
   SELECT CTRA
ENDIF
UPDATE CTRA SET  ;
		FchDoc   = C_CTRA.FchDoc ,;				
       	NroRf2   = C_CTRA.NroRf2 ,;
       	NroRf3   = C_CTRA.NroRf3 ,;
       	NroOdt   = C_CTRA.NroOdt ,;
       	CodVen   = C_CTRA.CodVen ,;
       	CodPro   = C_CTRA.CodPro ,;
       	CodCli   = C_CTRA.CodCli ,;
       	CodDire   = C_CTRA.CodDire ,;
       	CodMon   = C_CTRA.CodMon ,;
       	TpoCmb   = C_CTRA.TpoCmb ,;
       	Observ   = C_CTRA.Observ ,;
       	FBatch   = C_CTRA.fBatch ,;
       	User     = GoCfgAlm.Usuario ,;
       	CodTra	 = C_CTRA.CodTra , ;
    	NomTra   = C_CTRA.NomTra ,;
    	DirTra   = C_CTRA.DirTra ,;
    	RucTra   = C_CTRA.RucTra ,;
    	PlaTra   = C_CTRA.PlaTra ,;
    	Brevet   = C_CTRA.Brevet ,;
    	Motivo   = C_CTRA.Motivo ,;
    	ImpBrt   = C_CTRA.ImpBrt ,;
    	PorIgv   = C_CTRA.PorIgv ,;
    	ImpIgv   = C_CTRA.ImpIgv ,;
    	ImpTot   = C_CTRA.ImpTot ,;
    	CodUser  = GoCfgAlm.Usuario ,;
    	CodActiv = C_CTRA.CodActiv,;
    	CodProcs = C_CTRA.CodProcs,;
    	CodFase  = C_CTRA.CodFase,;
		CodCult  = C_CTRA.CodCult,;
		CodPar   = C_CTRA.CodPar,;
		AlmOri   = IIF(C_CTRA.TipMov='I' AND GoCfgAlm.Transf,GoCfgAlm.AlmOri ,''),;
		AlmTrf   = IIF(C_CTRA.TipMov='S' AND GoCfgAlm.Transf,GoCfgAlm.AlmTrf,''),;
		NroRf1   = C_CTRA.NroRf1,; 
		TpoRf1	 = GoCfgAlm.TpoRf1,;		
		TpoRf2	 = GoCfgAlm.TpoRf2,;
		TpoRf3	 = GoCfgAlm.TpoRf3,;
    	FchHora  = DATETIME() ,	;
    	FmaPgo   = C_CTRA.FmaPgo,;
    	CndPgo   = C_CTRA.CndPgo,;
    	CodLote  = C_CTRA.CodLote,;
     	CodPrd   = C_CTRA.CodPrd, ;
     	Flgest   = C_CTRA.FlgEst, ;
     	FchFin	 = C_CTRA.FchFin ;
WHERE    Subalm = m.cSubAlm AND ;
	TipMov = m.cTipMov AND ; 			  	     	
   	CodMov = m.sCodMov AND  ;
   	NroDoc = m.sNroDoc

*** Campos para construccion **** VETT 2007-03-13
SELECT CTRA
=SEEK(goCfgAlm.SubAlm + gocfgalm.cTipMov + goCfgAlm.sCodMov + goCfgAlm.sNroDoc ,'CTRA','CTRA01')  
IF VARTYPE(CodFre)='C'
	UPDATE CTRA SET  ;
	       	CodFre   = C_CTRA.CodFre ;
	WHERE    Subalm = m.cSubAlm AND ;
		TipMov = m.cTipMov AND ; 			  	     	
	   	CodMov = m.sCodMov AND  ;
	   	NroDoc = m.sNroDoc
ENDIF         	
IF VARTYPE(CodRes)='C'
	UPDATE CTRA SET  ;
       	CodRes   = C_CTRA.CodRes ;        	
	WHERE    Subalm = m.cSubAlm AND ;
		TipMov = m.cTipMov AND ; 			  	     	
	   	CodMov = m.sCodMov AND  ;
	   	NroDoc = m.sNroDoc
ENDIF
**>>  Vo.Bo. VETT  2008/12/29 15:42:29 
IF VerifyVar('TpoRfb','','CAMPO','CTRA') && VARTYPE(TpoRfb)='C'
	UPDATE CTRA SET  ;
	       	TpoRfb   = C_CTRA.TpoRfb ;
	WHERE    Subalm = m.cSubAlm AND ;
		TipMov = m.cTipMov AND ; 			  	     	
	   	CodMov = m.sCodMov AND  ;
	   	NroDoc = m.sNroDoc
ENDIF         	
**>>  Vo.Bo. VETT  2008/12/29 15:42:18 
IF VerifyVar('NroRfb','','CAMPO','CTRA') && VARTYPE(NroRfb)='C'
	UPDATE CTRA SET  ;
       	NroRfb   = C_CTRA.NroRfb ;        	
	WHERE    Subalm = m.cSubAlm AND ;
		TipMov = m.cTipMov AND ; 			  	     	
	   	CodMov = m.sCodMov AND  ;
	   	NroDoc = m.sNroDoc
ENDIF

=F1QEH("GRAB_DETA")
IF m.lSinDetalle
	LnControl=1 
ELSE
	UPDATE c_dtra SET Nrodoc = m.sNroDoc WHERE !EMPTY(SubAlm) AND !EMPTY(CodMat) && 
	LnControl=Grabar_transaccion_Alm_Detalle()         && Grabamos detalle
ENDIF
** Grabamos al Final los campos que modifican el consumo en la cabecera **
*!*	UPDATE CTRA SET  ;
*!*	    	CodLote  = C_CTRA.CodLote,;
*!*	     	CodPrd   = C_CTRA.CodPrd ;
*!*	WHERE    Subalm = m.cSubAlm AND ;
*!*		TipMov = m.cTipMov AND ; 			  	     	
*!*	   	CodMov = m.sCodMov AND  ;
*!*	   	NroDoc = m.sNroDoc


=F1QEH("OK")
SELE CTRA
*!*	=F1QEH("IMPRIMIR")
*!*	**DO pEmision
RETURN LnControl
**************************************
FUNCTION Grabar_transaccion_Alm_Detalle   && Graba todos los items de una transaccion al final
**************************************
*
PRIVATE OK
*
=Actualiza_item_almacen_borrados() && Si han modificado y borrado items previamente grabados
OK     = .T.

IF OK
   SELE C_DTRA
   ** PACK --- >> No funciona con cursor solo tabla hue**/*3*535*
   LOCATE
   SCAN FOR !EMPTY(CodMat) AND !EMPTY(SubAlm)
		=GrbDetAlm_ITEM()
	
		SELE C_DTRA
   ENDSCAN
ENDIF
*
*AMAA 06-12-06	
** Chequeamos estado de orden de compra **
IF GoCfgAlm.xsTpoRef="O_CM"

	=ChkEstO_C(EVALUATE("ctra."+gocfgalm.cmpref))
ENDIF 
**
RETURN 1


***********************
FUNCTION GrbDetAlm_ITEM
***********************
	m.Nro_Itm = RECNO()
	SCATTER MEMVAR
	*AMAA 06-12-06
	IF GoCfgAlm.XsTpoRef="O_CM"
           lRequi = .F.
           lItems = .F.
           DO ACTO_C WITH m.NroRef,m.CodMat,-m.CanDes,m.NroRef2,[L]
    ENDIF
    **    
	IF NroReg>0
	   ** Desactualizar **
		 m.Nro_Reg = NroReg
		SELE DTRA
		GO m.Nro_Reg
		DO WHILE !RLOCK()
		ENDDO
		DO CASE 
			CASE GoCfgAlm.cTipMov='I'
				=Alm_Descarga_stock_ALMpdsm2(.T.)
				**AMAA 06-12-06
				IF GoCfgAlm.XsTpoRef="O_CM"
		           		DO ACTO_C WITH DTRA.NroRef,DTRA.CodMat,-DTRA.CanDes,DTRA.NroRef2,[G]
			   	ENDIF
			    **
			CASE GoCfgAlm.cTipMov='S'
				=Alm_Carga_Stock_Almpcsm2(.T.)	
				** VETT  29/01/2015 11:41 AM : ACT:PEDIDOS 
				DO CASE
					CASE GoCfgAlm.XsTpoRef="G/R"
						IF TpoRfb='PEDI' AND !EMPTY(NroRfb)  && Nro Pedido
							GoCfgAlm.xDes_Ped_GR(DTRA.NroRfb,DTRA.CodMat,DTRA.CanDes, DTRA.UndVta,DTRA.Factor)
						ENDIF
					OTHER
				ENDCASE

		ENDCASE					
		UNLOCK
	ELSE
		SELE DTRA
		APPEND BLANK
		m.Nro_Reg = RECNO()
		*** Determinamos el NroItm ***
		Local LsLLave_Reg
		LsLlave_Reg=C_DTRA.SubAlm+C_DTRA.TipMov+C_DTRA.CodMov+C_DTRA.NroDoc 
		m.NroItm=goSvrCbd.Cap_NroItm(LsLlave_Reg,'DTRA','SubAlm+TipMov+CodMov+NroDoc')
		*** -------------- ***
		*!*			
		*!*	select max(nroitm)+1 as nroitm from dtra where subalm+tipmov+codmov+nrodoc=LsLlave_Reg into cursor cur_temp
		*!*	IF _TALLY  = 0		&& Creando registro por primera vez
		*!*		m.NroItm = 1
		*!*	ELSE
		*!*		m.NroItm = cur_temp.nroitm
		*!*	ENDIF
		*!*	use in cur_temp
		*!*	SELE DTRA
		*** ------------- ***
		replace NroItm WITH m.NroItm IN C_DTRA
	ENDIF
	IF m.Nro_Reg<>RECNO() AND m.Nro_Reg>0
	   GO m.Nro_Reg       && Ser  posible  ??  SI, si es que no se tiene ningun area seleccionada
	ENDIF
	GATHER MEMVAR
	REPLACE CodSed WITH GsCodSed  &&GoCfgAlm.CodSed
	REPLACE FchDoc WITH C_CTRA.FchDoc	
	
	IF GoCfgAlm.lModCsm OR GoCfgAlm.lAfeTra
	   IF USED([DFPRO])
	      =SEEK(CodPrd+SubAlm+CodMat,[DFPRO])
	      REPLACE CnFmla WITH DFPRO.CanReq*C_DTRA.Fbatch
	   ENDIF
	   REPLACE CodPrd WITH C_DTRA.CodPrd
	   REPLACE TpoRef WITH GoCfgAlm.XsTpoRef
	   REPLACE NroRef WITH C_CTRA.NroOdt				&& Revisar todavia no obedece a una
	   REPLACE FBATCH WITH C_CTRA.FBatch			    && configuracion total 01/09/2001
	ENDIF
	*
	*** AQUI
	IF !EMPTY(GoCfgAlm.XsTpoRef)
		LsCadenaEval2 = GoCfgAlm.VarRef
	   REPLACE TpoRef WITH GoCfgAlm.XsTpoRef
	   REPLACE NroRef WITH IIF(!EMPTY(GoCfgAlm.VarRef),C_CTRA.&LsCadenaEval2,[])
*!*		   IF !EMPTY(C_DTRA.NroRef)
*!*		       REPLACE NroRef WITH C_DTRA.NroRef
*!*		   ENDIF
	ENDIF
	*
	REPLACE CTRA.NroItm WITH CTRA.NroItm + 1
	*
	IF GoCfgAlm.lPidPco
	   REPLACE DTRA.CodAjt WITH "A"
	ELSE
	   REPLACE DTRA.CodAjt WITH " "
	ENDIF
	*
	* * * * * * * * * * * * * *
	DO CASE 
		CASE GoCfgAlm.cTipMov = [I]
			 =Alm_Carga_Stock_Almpcsm1()
			 **AMAA 06-12-06
			 IF GoCfgAlm.XsTpoRef="O_CM"
			 	DO ActO_C WITH DTRA.NroRef,DTRA.CodMat,DTRA.CanDes,DTRA.NroRef2,[G]
	            UNLOCK IN [DO_C]
	            UNLOCK IN [CREQ]
    		 ENDIF
   		     **
		CASE GoCfgAlm.cTipMov = [S]
	 	    =Alm_Descarga_stock_Almpdsm1()
			** VETT  29/01/2015 11:42 AM : ACT:PEDIDOS 
			DO CASE
				CASE GoCfgAlm.XsTpoRef="G/R"
					IF TpoRfb='PEDI' AND !EMPTY(NroRfb)  && Nro Pedido
						GoCfgAlm.xAct_Ped_GR(DTRA.NroRfb,DTRA.CodMat,DTRA.CanDes, DTRA.UndVta,DTRA.Factor)
					ENDIF
				OTHER
			ENDCASE

	ENDCASE	 	
	UNLOCK
	* Actualizamos saldos por lotes y fecha de vencimiento   VETT 30-01-2003
*!*		=item_almacen_lote(GoCfgAlm.CodSed,gocfgalm.SubAlm,C_DTRA.CodMat,C_DTRA.Lote,C_DTRA.FchVto,C_DTRA.TipMov,C_DTRA.CanDes,C_DTRA.FchDoc,C_DTRA.SITU)
	=item_almacen_lote(GsCodSed,gocfgalm.SubAlm,C_DTRA.CodMat,C_DTRA.Lote,C_DTRA.FchVto,C_DTRA.TipMov,C_DTRA.CanDes,C_DTRA.FchDoc,C_DTRA.SITU)
	IF C_DTRA.NroReg=0 AND !EMPTY(C_DTRA.Serie)
		=ActualizaStockSeries(C_DTRA.CodMat,C_DTRA.Serie,C_DTRA.TipMov,C_DTRA.NroReg)
	ENDIF
	* 
return
****************************************
FUNCTION Actualiza_item_almacen_borrados
****************************************
IF GoCfgAlm.GnTotDel >0
	FOR k = 1 TO GoCfgAlm.GnTotDel
       ** Borramos en el almacen emisor **
		IF GoCfgAlm.aRegDel(k)>0	
			SELE DTRA			
			GO GoCfgAlm.aRegDel(k)						
			DO WHILE !RLOCK()
			ENDDO
			DELETE
			DO CASE 
				CASE GoCfgAlm.cTipMov='I'
					=Alm_Descarga_stock_ALMpdsm2(.T.)
					**AMAA 06-12-06
					IF GoCfgAlm.XsTpoRef="O_CM"
						lRequi = .F.
						lItems = .F.
						DO ActO_C WITH DTRA.NroRef,DTRA.CodMat,-DTRA.Candes,DTRA.NroRef2,[LG]
						UNLOCK IN "DO_C"
						UNLOCK IN "CREQ"
					ENDIF
    			    **
				CASE GoCfgAlm.cTipMov='S'
					=Alm_Carga_Stock_Almpcsm2(.T.)	
					** VETT  20/01/2015 10:09 AM : ACT:PEDIDOS 
					DO CASE
					
						CASE GoCfgAlm.XsTpoRef="G/R"
							IF TpoRfb='PEDI' AND !EMPTY(NroRfb)  && Nro Pedido
								GoCfgAlm.xDes_Ped_GR(DTRA.NroRfb,DTRA.CodMat,DTRA.CanDes, DTRA.UndVta,DTRA.Factor)
							ENDIF
						OTHER
					ENDCASE
			ENDCASE					
*!*				=item_almacen_lote(GoCfgAlm.CodSed,DTRA.SubAlm,DTRA.CodMat,DTRA.Lote,DTRA.FchVto,DTRA.TipMov,-DTRA.CanDes,DTRA.FchDoc,DTRA.SITU)
			=item_almacen_lote(GsCodSed,DTRA.SubAlm,DTRA.CodMat,DTRA.Lote,DTRA.FchVto,DTRA.TipMov,-DTRA.CanDes,DTRA.FchDoc,DTRA.SITU)
			UNLOCK
		ENDIF
   ENDFOR
ENDIF

****************
FUNCTION _ChkRef
****************
IF EMPTY(GoCfgAlm.XsTpoRef) OR  EMPTY(GoCfgAlm.CmpRef) OR EMPTY(GoCfgAlm.VarRef)
   RETURN .F.
ENDIF
LsCadenaEval="C_CTRA."+GoCfgAlm.CmpRef
LsCadenaEval2 = GoCfgAlm.VarRef
RETURN &LsCadenaEval. != &LsCadenaEval2.
******************AMAA 06-12-06
FUNCTION ChkEstO_C
******************
PARAMETER LsNroO_C
PRIVATE lCerrar,sArea
sArea   = ALIAS()
lCerrar = .T.
LsNroO_C=PADR(LsNroO_C,LEN(DO_C.NroOrd))
SELE CO_C
SET ORDER TO CO_C01
SEEK LsNroO_C
IF !FOUND()
   DO F1MsgErr WITH [Orden de compra no localizada...pendiente de actualizaci¢n]
   SELE (sArea)
   RETURN .F.
ENDIF
DO WHILE !RLOCK()
ENDDO
**
SELE DO_C
orden = ORDER()
SEEK PADR(LsNroO_C,LEN(DO_C.NroOrd))
SCAN WHILE NroOrd=LsNroO_C
     IF CanPed > CanDes
        lCerrar = .F.
        EXIT
     ENDIF
ENDSCAN
SELECT DO_C
SET ORDER TO &orden.

SELE CO_C
REPLACE FlgEst WITH IIF(lCerrar,[C],[E])
REPLACE TpoCmb WITH gocfgalm.fTpoCmb
UNLOCK IN [CO_C]
SELE (sArea)
RETURN .T.
****************AMAA 06-12-06
PROCEDURE ActO_C
****************
PARAMETER LsNroO_C,LsCodMat,LfCandes,LsNroReq,QUEHAGO

LsNroO_C= PADR(LsNroO_C,LEN(DO_C.NroOrd))
LsNroReq= PADR(LsNroReq,LEN(DO_C.NroReq))
LsCodMat= PADR(LsCodMat,LEN(DO_C.CodMat))
private sArea
sArea = ALIAS()
SELE DO_C
orden = ORDER()
IF [L]$QUEHAGO   
   SEEK LsNroO_C+LsCodMat+LsNroReq
   *seek( lsnroO_c+IIF(LEN(do_c.codmat)>LEN(lscodmat),lscodmat+SPACE(LEN(do_c.codmat)-LEN(lscodmat)),LEFT(LsCodMat,LEN(do_c.codmat)))+lsnroreq)
   SET ORDER TO do_C03
   IF FOUND()
      DO WHILE !RLOCK()
      ENDDO
      LItems = .T.
      SELE CREQ
      SEEK DO_C.Usuario+DO_C.NroReq
      IF FOUND()
         DO WHILE !RLOCK()
         ENDDO
         lRequi = .T.
      ENDIF
   ENDIF 
ENDIF
IF [G]$QUEHAGO
   IF LItems
      SELE DO_C
      DO WHILE !RLOCK()
      ENDDO
      REPLACE DO_C.Candes WITH DO_C.CanDes + LfCanDes
   ENDIF
   IF lRequi
      SELE CREQ
      DO WHILE !RLOCK()
      ENDDO
      IF LfCandes<0
         REPLACE CREQ.FlgHis WITH [R]
      ELSE
         IF CREQ.TpoReq$[ASN]
            REPLACE CREQ.CodMat WITH LsCodMat
         ENDIF
         IF DO_C.CanDes>=DO_C.CanPed
            REPLACE CREQ.FlgHis WITH [H]
         ENDIF
      ENDIF
   ENDIF
ENDIF
SELECT do_c   
SET ORDER to &orden.
SELE (sArea)
RETURN

***********************************
FUNCTION GRABA_CONSUMOS_PRODUCCION
***********************************
*** Actualiza el consumo de materiales ***
PARAMETERS cCodMat , cCodPro , dFecha  , cTipMov , nCanDes, nNroReg,cTablaDBF,cCodlote
PRIVATE TnLen1 , TnLen2 , TnCont , TsCodMat , TnCanDes , xSelect,TsSubAlm
EXTERNAL ARRAY GACLFDIV,GALENCOD
private m.Reg_New
IF Type([m.RecMex])#[L]
	m.RecMex = .f.
ENDIF
xSelect = SELECT()
** Nos Posicionamos en registro 
SELECT DTRA
GO nNroReg
IF EOF()
	RETURN
ENDIF
** 
IF EMPTY(cCodPro)
   cCodPro = REPLI("9",LEN(cCodMat))
ENDIF
TsCodMat = cCodMat
TsCodLote= cCodLote
TnCanDes = nCanDes
IF ABS(nCanDes)>0
   nSigno   = ABS(nCanDes)/nCandes
ELSE
   nSigno   = 0
ENDIF
IF DTRA.Factor>0
   TnCandes = DTRA.Candes*DTRA.Factor*nSigno
ENDIF
TnLen1   = LEN(cCodPro)
TnLen2   = LEN(TRIM(cCodPro))
TnCont   = TnLen2
fValMn   = DTRA.VcToMn
fValUs   = DTRA.VcToUs
fImpNac  = DTRA.ImpNac
fImpUsa  = DTRA.ImpUsa
nStkAct  = DTRA.StkAct
TsSubAlm = DTRA.SubAlm
TsClfDiv = GaClfDiv(3)
IF nStkAct<=0
   TfVCtoMn = 0
   TfVCtoUs = 0
ELSE
   TfVCtoMn = ROUND(TnCandes*fValMn/nStkAct,4)
   TfVCtoUs = ROUND(TnCandes*fValUs/nStkAct,4)
ENDIF
*IF !USED([DFPRO])
*   USE CPIDFPRO ORDER DFPR01 ALIAS DFPRO IN 0
*   IF !USED([DFPRO])
*      DO F1msgerr WITH [Actualizaci¢n de consumos queda pendiente]
*   ENDIF
*ENDIF

LOCAL LoDatAdm AS DataAdmin OF k:\aplvfp\classgen\vcxs\DOSVR.vcx
LoDatAdm=CREATEOBJECT('DOSVR.DataAdmin')
IF !USED([DFPRO])
   LoDatAdm.abrirtabla([ABRIR],[CPIDFPRO] ,[DFPRO],[DFPR01])
   IF !USED()
       =messagebox([Actualizaci¢n de consumos queda pendiente],'Fallo acceso a tabla')
       RETURN
   ENDIF
ENDIF
RELEASE loDatAdm 

LfCanFor = 0
LfFBatch = 1.00
lFormula=SEEK(cCodPro+TsSubAlm+cCodMat,[DFPRO])
LfFBatch = DTRA.FBatch
LfCanFor = DTRA.CnFmla
IF lFormula AND LfCanFor<=0
   LfCanFor=DFPRO.CanReq*LfFbatch
ENDIF

LfCanFor = ROUND(LfCanFor*IIF(DTRA.Factor>0,DTRA.Factor,1),4)*nSigno

IF ABS(TnCanDes)>0
   fPUniMn = ROUND(fImpNac/ABS(TnCanDes),4)
   fPUniUs = ROUND(fImpUsa/ABS(TnCanDes),4)
ELSE
   fPUniMn = 0
   fPUniUs = 0
ENDIF

fValForMn  = ROUND(fPUniMn*LfCanFor,2)
fValForUs  = ROUND(fPUniUs*LfCanFor,2)

DO WHILE TnCont > 0
   okey = .F.
   FOR zi = 1 to ALEN(GaLenCod)
       IF GaLenCod(zi)=TnCont
          TsClfDiv = GaClfDiv(zi)
          Okey = .T.
          EXIT
       ENDIF
   ENDFOR
   IF okey OR TnCont = TnLen2&& AMAA 17-01-07 cambio TnLen2 x TnLen1
      TsCodPro = LEFT(cCodPro,TnCont)+SPACE(TnLen1-TnCont)
      LsFecha = PADR(LEFT(DTOS(dFecha),6),LEN(ESTA.PERIODO))
      m.Reg_new = .f.
      SELECT (cTablaDBF)
      SEEK LsFecha + TsCodPro + TsCodMat + TsCodLote
      IF ! FOUND()
         APPEND BLANK
         m.Reg_New = .t.
      ENDIF
      DO WHILE !RLOCK()
      ENDDO
      REPLACE CodPro  WITH TsCodPro
      REPLACE CodMat  WITH TsCodMat
      REPLACE SubAlm  WITH TsSubAlm
      REPLACE Periodo WITH LEFT(DTOS(dFecha),6)
      REPLACE ClfDiv  WITH TsClfDiv
      REPLACE CodLote WITH TsCodLote
      IF cTipMov $ 'S'
		IF m.RecMex and !m.Reg_New     	
			REPLACE VSalUs WITH VSalUs+fImpUsa
		else
			REPLACE CanSal WITH CanSal+TnCanDes
	        REPLACE VSalMn WITH VSalMn+fImpNac
			REPLACE VSalUs WITH VSalUs+fImpUsa
		endif	
      ELSE
		if m.RecMex and !m.Reg_New     	
			REPLACE VIngUs WITH VIngUs+fImpUsa
		else
      		REPLACE CanIng WITH CanIng+TnCanDes
		    REPLACE VIngMn WITH VIngMn+fImpNac
			REPLACE VIngUs WITH VIngUs+fImpUsa
		endif	
         **
      ENDIF
      UNLOCK
   ENDIF
   TnCont = TnCont - 1
ENDDO
SELECT (xSelect)
RETURN

***********************************
FUNCTION CALC_ACT_COSTOPROMEDIOUNIT   && Falta optimizar 
***********************************
parameters nNroReg,lCmbFecha 

** Actualizamos Precios Promedio ****
private LfCanDes,LfPreUni,LfImpCto,LsCodMat,LsSubAlm,LiRegAct,LsCodAlm
private LfStkSub,LsOrder,m.Ingresos,LfTctoMn,LfTCtoUs,LfVCtoMn,LfVCtoUs
private LfPctoMn,LfPctoUs,LfPcPrm1,LfPcPrm2
SELE DTRA
** Guardamos datos del registro **
LsOrder  = ORDER()
GOTO nNroReg
IF EOF()
	RETURN
ENDIF
* @_@ Actualizamos todos los registros del material
IF lCmbFecha 
  * Para Regenerar el precio promedio desde el principio *
	SET ORDER TO DTRA09
	xCodmm = CodSed+CodMat
	=SEEK(xCodmm,'DTRA','DTRA09')
ENDIF

LiRegAct = Recno()
LsCodSed = CodSed
LsSubAlm = SubAlm
LfCanDes = DTRA.CanDes
LfPreUni = DTRA.PreUni
LfImpCto = DTRA.ImpCto
IF DTRA.Factor > 0
   LfCanDes = DTRA.CanDes * DTRA.Factor
   LfPreUni = DTRA.PreUni/DTRA.Factor
ENDIF
LsCodMat = DTRA.CodMat
** Posicionamos Punteros **
SELE CATG
SET ORDER TO CATG01
SEEK LsCodMat
DO WHILE !RLOCK()
ENDDO
*
SELE CALM
SET ORDER TO CATA01
SEEK LsSubAlm+LsCodMat
DO WHILE !RLOCK()
ENDDO
*******************************************************************************
** PRIMERO : ACTUALIZAMOS STOCK POR SUBALMACEN (SIN VALORIZAR) ****************
*******************************************************************************
SELE DTRA
* Stock Anterior de almacen
SET ORDER TO DTRA02
GO LiRegAct
SKIP -1
IF BOF() .OR. ! (LsCodMat+LsSubAlm = CodMat+SubAlm)
   LfStkSub = CALM.StkIni
ELSE
   LfStkSub = DTRA.StkSub
ENDIF
GOTO LiRegAct
IF DELETE()
   SKIP
ENDIF
SCAN WHILE (LsCodMat+LsSubAlm = CodMat+SubAlm) 
   IF !RLOCK()
      LOOP
   ENDIF
   m.Ingresos = DTRA.TipMov $ "RID"
   LfCanDes = DTRA.CanDes
   IF DTRA.Factor > 0
      LfCanDes = DTRA.CanDes * DTRA.Factor
   ENDIF
   IF m.Ingresos
      LfStkSub = LfStkSub + LfCanDes
   ELSE
      LfStkSub = LfStkSub - LfCanDes
   ENDIF
   REPLA DTRA.StkSub WITH LfStkSub
   UNLOCK
ENDSCAN
*******************************************************************************
** SEGUNDO : ACTUALIZAMOS STOCK GENERAL (VALORIZADO) **************************
*******************************************************************************
SELE DTRA
* Stock Anterior de almacen
SET ORDER TO DTRA09
GO LiRegAct
SKIP -1
IF BOF() .OR. ! (LsCodSed+LsCodMat = CodSed+CodMat)
   LfStkAct = CATG.StkIni
   LfVCtoMn = CATG.VIniMn
   LfVCtoUs = CATG.VIniUs
ELSE
   LfStkAct = DTRA.StkAct
   LfVCtoMn = DTRA.VCtoMn
   LfVCtoUs = DTRA.VCtoUs
ENDIF
GOTO LiRegAct
IF DELETE()
   SKIP
ENDIF
SCAN WHILE (LsCodSed+LsCodMat = CodSed+CodMat)
   IF !RLOCK()
      LOOP
   ENDIF
   m.Ingresos = DTRA.TipMov $ "RID"
   LfCanDes = DTRA.CanDes
   ** Cantidad despachada en unidad de Stock **
   IF DTRA.Factor > 0
      LfCanDes = DTRA.CanDes * DTRA.Factor
   ENDIF
   IF DTRA.CodMon = 1
      LfTCtoMn = ImpCto
      IF DTRA.TpoCmb > 0
         LfTCtoUS = ROUND(DTRA.ImpCto/DTRA.TpoCmb,2)
      ELSE
         LfTCtoUS = 0
      ENDIF
      REPLACE ImpNac WITH ImpCto
      REPLACE ImpUsa WITH LfTCtoUs
   ELSE
      LfTCtoMn = ROUND(DTRA.ImpCto*DTRA.TpoCmb,2)
      LfTCtoUS = DTRA.ImpCto
      REPLACE ImpUsa WITH ImpCto
      REPLACE ImpNac WITH LfTCtoMn
   ENDIF
   ** Precio de Costo **
   IF LfStkAct  > 0
      LfPctoMn = ROUND(LfVCtoMn / LfStkAct,4)
      LfPctoUS = ROUND(LfVCtoUS / LfStkAct,4)
   ELSE
      LfPctoMn = 0
      LfPctoUS = 0
   ENDIF
   IF LfPctoMn < 0
      LfPctoMn = 0
   ENDIF
   IF LfPctoUs < 0
      LfPctoUs = 0
   ENDIF
   IF ! (DTRA.CodAjt = "A" ) &&.AND. LfStkAct >= 0 )
      LfTctoMn = ROUND(LfPctoMn*LfCanDes,2)
      LfTctoUS = ROUND(LfPctoUS*LfCanDes,2)
      REPLACE ImpUsa WITH LfTCtoUs
      REPLACE ImpNac WITH LfTCtoMn
   ENDIF
   IF m.Ingresos
   **>IF DTRA.TipMov # 'R'
         LfVctoMn = LfVctoMn + ImpNac
         LfVctoUS = LfVctoUS + ImpUsa
         LfStkAct = LfStkAct + LfCanDes
   **>ENDIF
   ELSE
   **>IF DTRA.TipMov # 'T'
         LfVctoMn = LfVctoMn - ImpNac
         LfVctoUS = LfVctoUS - ImpUsa
         LfStkAct = LfStkAct - LfCanDes
   **>ENDIF
   ENDIF
   IF LfVctoMn < 0
      LfVctoMn = 0
   ENDIF
   IF LfVctoUs < 0
      LfVctoUS = 0
   ENDIF
   SELE DTRA
   REPLACE DTRA.VCtoMn WITH LfVCtoMn
   REPLACE DTRA.VCtoUS WITH LfVCtoUS
   REPLACE DTRA.StkAct WITH LfStkAct

ENDSCAN
** Regresa a la Posicion Original
SELECT CATG
REPLACE CATG.VCtoMn WITH LfVCtoMn
REPLACE CATG.VCtoUS WITH LfVCtoUS
REPLACE CATG.StkAct WITH LFStkAct

LfPcPrm1 = 0
LfPcPrm2 = 0
IF LfStkAct>0
   LfPcPrm1 = ROUND(LfVCtoMn / LfStkAct,4)
   LfPcPrm2 = ROUND(LfVCtoUS / LfStkAct,4)
ENDIF
IF LfPcPrm1<>0
   REPLACE CATG.PctoMn WITH LfPcPrm1
ENDIF
IF LfPcPrm2<>0
   REPLACE CATG.PctoUs WITH LfPcPrm2
ENDIF
UNLOCK
SELE CALM
UNLOCK
SELE DTRA
SET ORDER TO (LsOrder)
GOTO LiRegAct
IF ! f1_RLOCK(5)
   RETURN
ENDIF
RETURN
*
*****************************************
FUNCTION CALC_ACT_COSTOPROMEDIOUNIT_ANTES   && Falta optimizar 
*****************************************
parameters nNroReg,lCmbFecha 
** Actualizamos Precios Promedio ****
private LfCanDes,LfPreUni,LfImpCto,LsCodMat,LsSubAlm,LiRegAct,LsCodAlm
private LfStkSub,LsOrder,m.Ingresos,LfTctoMn,LfTCtoUs,LfVCtoMn,LfVCtoUs
private LfPctoMn,LfPctoUs,LfPcPrm1,LfPcPrm2
SELE DTRA
** Guardamos datos del registro **
LsOrder  = ORDER()
GOTO nNroReg
IF EOF()
	RETURN
ENDIF
* @_@ Actualizamos todos los registros del material
IF lCmbFecha 
  * Para Regenerar el precio promedio desde el principio *
	SET ORDER TO DTRA03
	xCodmm = CodMat
	=SEEK(xCodmm,'DTRA','DTRA03')
ENDIF

LiRegAct = Recno()
LsCodAlm = CodSed
LsSubAlm = SubAlm
LfCanDes = DTRA.CanDes
LfPreUni = DTRA.PreUni
LfImpCto = DTRA.ImpCto
IF DTRA.Factor > 0
   LfCanDes = DTRA.CanDes * DTRA.Factor
   LfPreUni = DTRA.PreUni/DTRA.Factor
ENDIF
LsCodMat = DTRA.CodMat
** Posicionamos Punteros **
SELE CATG
SET ORDER TO CATG01
SEEK LsCodMat
DO WHILE !RLOCK()
ENDDO
*
SELE CALM
SET ORDER TO CATA01
SEEK LsSubAlm+LsCodMat
DO WHILE !RLOCK()
ENDDO
*******************************************************************************
** PRIMERO : ACTUALIZAMOS STOCK POR SUBALMACEN (SIN VALORIZAR) ****************
*******************************************************************************
SELE DTRA
* Stock Anterior de almacen
SET ORDER TO DTRA02
GO LiRegAct
SKIP -1
IF BOF() .OR. ! (LsCodMat+LsSubAlm = CodMat+SubAlm)
   LfStkSub = CALM.StkIni
ELSE
   LfStkSub = DTRA.StkSub
ENDIF
GOTO LiRegAct
IF DELETE()
   SKIP
ENDIF
SCAN WHILE (LsCodMat+LsSubAlm = CodMat+SubAlm) 
   IF !RLOCK()
      LOOP
   ENDIF
   m.Ingresos = DTRA.TipMov $ "RID"
   LfCanDes = DTRA.CanDes
   IF DTRA.Factor > 0
      LfCanDes = DTRA.CanDes * DTRA.Factor
   ENDIF
   IF m.Ingresos
      LfStkSub = LfStkSub + LfCanDes
   ELSE
      LfStkSub = LfStkSub - LfCanDes
   ENDIF
   REPLA DTRA.StkSub WITH LfStkSub
   UNLOCK
ENDSCAN
*******************************************************************************
** SEGUNDO : ACTUALIZAMOS STOCK GENERAL (VALORIZADO) **************************
*******************************************************************************
SELE DTRA
* Stock Anterior de almacen
SET ORDER TO DTRA03
GO LiRegAct
SKIP -1
IF BOF() .OR. ! (LsCodMat = CodMat)
   LfStkAct = CATG.StkIni
   LfVCtoMn = CATG.VIniMn
   LfVCtoUs = CATG.VIniUs
ELSE
   LfStkAct = DTRA.StkAct
   LfVCtoMn = DTRA.VCtoMn
   LfVCtoUs = DTRA.VCtoUs
ENDIF
GOTO LiRegAct
IF DELETE()
   SKIP
ENDIF
SCAN WHILE (LsCodMat = CodMat)
   IF !RLOCK()
      LOOP
   ENDIF
   m.Ingresos = DTRA.TipMov $ "RID"
   LfCanDes = DTRA.CanDes
   ** Cantidad despachada en unidad de Stock **
   IF DTRA.Factor > 0
      LfCanDes = DTRA.CanDes * DTRA.Factor
   ENDIF
   IF DTRA.CodMon = 1
      LfTCtoMn = ImpCto
      IF DTRA.TpoCmb > 0
         LfTCtoUS = ROUND(DTRA.ImpCto/DTRA.TpoCmb,2)
      ELSE
         LfTCtoUS = 0
      ENDIF
      REPLACE ImpNac WITH ImpCto
      REPLACE ImpUsa WITH LfTCtoUs
   ELSE
      LfTCtoMn = ROUND(DTRA.ImpCto*DTRA.TpoCmb,2)
      LfTCtoUS = DTRA.ImpCto
      REPLACE ImpUsa WITH ImpCto
      REPLACE ImpNac WITH LfTCtoMn
   ENDIF
   ** Precio de Costo **
   IF LfStkAct  > 0
      LfPctoMn = ROUND(LfVCtoMn / LfStkAct,4)
      LfPctoUS = ROUND(LfVCtoUS / LfStkAct,4)
   ELSE
      LfPctoMn = 0
      LfPctoUS = 0
   ENDIF
   IF LfPctoMn < 0
      LfPctoMn = 0
   ENDIF
   IF LfPctoUs < 0
      LfPctoUs = 0
   ENDIF
   IF ! (DTRA.CodAjt = "A" ) &&.AND. LfStkAct >= 0 )
      LfTctoMn = ROUND(LfPctoMn*LfCanDes,2)
      LfTctoUS = ROUND(LfPctoUS*LfCanDes,2)
      REPLACE ImpUsa WITH LfTCtoUs
      REPLACE ImpNac WITH LfTCtoMn
   ENDIF
   IF m.Ingresos
   **>IF DTRA.TipMov # 'R'
         LfVctoMn = LfVctoMn + ImpNac
         LfVctoUS = LfVctoUS + ImpUsa
         LfStkAct = LfStkAct + LfCanDes
   **>ENDIF
   ELSE
   **>IF DTRA.TipMov # 'T'
         LfVctoMn = LfVctoMn - ImpNac
         LfVctoUS = LfVctoUS - ImpUsa
         LfStkAct = LfStkAct - LfCanDes
   **>ENDIF
   ENDIF
   IF LfVctoMn < 0
      LfVctoMn = 0
   ENDIF
   IF LfVctoUs < 0
      LfVctoUS = 0
   ENDIF
   SELE DTRA
   REPLACE DTRA.VCtoMn WITH LfVCtoMn
   REPLACE DTRA.VCtoUS WITH LfVCtoUS
   REPLACE DTRA.StkAct WITH LfStkAct

ENDSCAN
** Regresa a la Posicion Original
SELECT CATG
REPLACE CATG.VCtoMn WITH LfVCtoMn
REPLACE CATG.VCtoUS WITH LfVCtoUS
REPLACE CATG.StkAct WITH LFStkAct

LfPcPrm1 = 0
LfPcPrm2 = 0
IF LfStkAct>0
   LfPcPrm1 = ROUND(LfVCtoMn / LfStkAct,4)
   LfPcPrm2 = ROUND(LfVCtoUS / LfStkAct,4)
ENDIF
IF LfPcPrm1<>0
   REPLACE CATG.PctoMn WITH LfPcPrm1
ENDIF
IF LfPcPrm2<>0
   REPLACE CATG.PctoUs WITH LfPcPrm2
ENDIF
UNLOCK
SELE CALM
UNLOCK
SELE DTRA
SET ORDER TO (LsOrder)
GOTO LiRegAct
IF ! f1_RLOCK(5)
   RETURN
ENDIF
RETURN

************************************
FUNCTION Alm_Descarga_stock_ALMpdsm1
************************************

   	*** AROMAS : GRABA Segun LA situacion del 
   	IF INLIST(GsSigCia,'AROMAS','PREZCOM') 
   		IF VARTYPE(SITU)='C'
   			IF !(INLIST(SITU,'01','03') OR EMPTY(SITU))
				RETURN
   			ENDIF
   		ENDIF
   	ENDIF

** Variables de C lculo **
PRIVATE LfCanDes,LfPreUni,LsSubAlm,LsCodMat
SELECT DTRA
LfCanDes = DTRA.CanDes
LfPreUni = DTRA.PreUni
IF DTRA.Factor > 0
	LfCanDes = DTRA.CanDes * DTRA.Factor
	LfPreUni = DTRA.PreUni/DTRA.Factor
ENDIF
LsSubAlm = DTRA.SubAlm
LsCodMat = DTRA.CodMat
LsAAAAMM = LEFT(DTOS(DTRA.FchDoc),6)
*** Bloqueamos los archivos a trabajar ***
SELECT CALM
SEEK LsSubAlm+LsCodMat
DO WHILE !RLOCK()
ENDDO

SELECT CATG
SEEK LsCodMat
DO WHILE !RLOCK()
ENDDO

**** Des-Actualizamos a los materiales por almacen ****
SELECT CALM
REPLACE CALM.StkAct WITH CALM.StkAct - LfCanDes
IF CALM.FCHSAL < DTRA.FchDoc
	REPLACE CALM.FCHSAL WITH DTRA.FCHDOC
ENDIF
**** Des-Actualizamos a los materiales generales ****
SELECT CATG
IF CATG.ULTSAL < DTRA.FchDoc
	REPLACE CATG.ULTSAL WITH DTRA.FCHDOC
ENDIF
**** Actualizamos Precios Promedio ****
IF DTRA.TipMov+DTRA.CodMov#[I000]  && Ingreso por apertura de Inventario
	=CALC_ACT_COSTOPROMEDIOUNIT(RECNO('DTRA'),.f.)
ENDIF
**** Actualizamos a los acumulados mensuales ****
IF GoCfgAlm.lModCsm
	=GRABA_CONSUMOS_PRODUCCION(LsCodMat, DTRA.CodPrd, DTRA.FchDoc, DTRA.TipMov, LfCandes,RECNO('DTRA'),'ESTA',C_CTRA.CodLote)
ENDIF
**** Actualizamos a los Acumulados Mensuales Transformaciones ****
If VARType(goCfgalm.lAfeTra) = [L]
	IF GoCfgAlm.lAfeTra
		=GRABA_CONSUMOS_PRODUCCION(LsCodMat, DTRA.CodPrd, DTRA.FchDoc, DTRA.TipMov, LfCandes,RECNO('DTRA'),'ESTR',C_CTRA.CodLote)
	ENDIF
ENDIF

SELECT CALM
UNLOCK
SELECT DTRA
RETURN

************************************
FUNCTION Alm_Descarga_stock_ALMpdsm2
************************************
Parameter LlActPCto
   	*** AROMAS : GRABA Segun LA situacion del 
   	IF INLIST(GsSigCia,'AROMAS','PREZCOM') 
   		IF VARTYPE(SITU)='C'
   			IF !(INLIST(SITU,'01','03') OR EMPTY(SITU))
				RETURN
   			ENDIF
   		ENDIF
   	ENDIF

PRIVATE LfCanDes,LfPreUni,LsSubAlm,LsCodMat
*!*	UltTecla = K_ESC
** Variables de C lculo **
SELECT DTRA
LiRegAct = RECNO()
LsSubAlm = DTRA.SubAlm
LsCodMat = DTRA.CodMat
*LsAAAAMM = LEFT(DTOC(CTRA.FchDoc,1),6)
*LsFecha  = DTOC(CTRA.FchDoc,1)
LfCanDes = DTRA.CanDes
LfPreUni = DTRA.PreUni
IF DTRA.Factor > 0
	LfCanDes = DTRA.CanDes * DTRA.Factor
	LfPreUni = DTRA.PreUni/DTRA.Factor
ENDIF
*** Bloqueamos los archivos a trabajar ***
SELECT CALM
SEEK LsSubALm+LsCodMat
DO WHILE !RLOCK()
ENDDO

SELECT CATG
SEEK LsCodMat
DO WHILE !RLOCK()
ENDDO

**** Des-Actualizamos a los materiales por almacen ****
SELECT CALM
REPLACE CALM.StkAct WITH CALM.StkAct - LfCanDes
UNLOCK
**** Des-Actualizamos a los materiales generales ****
SELECT CATG
*REPLACE CATG.StkAct WITH CATG.StkAct - LfCanDes
IF LlActPCto
   **** Actualizamos Precios Promedio ****
	=CALC_ACT_COSTOPROMEDIOUNIT(RECNO('DTRA'),.f.)
ENDIF

**** Actualizamos a los acumulados mensuales ****
IF GoCfgAlm.lModCsm
	=GRABA_CONSUMOS_PRODUCCION(LsCodMat, DTRA.CodPrd, DTRA.FchDoc, DTRA.TipMov, -LfCandes,RECNO('DTRA'),'ESTA',CTRA.CodLote)
ENDIF
**** Actualizamos a los Acumulados Mensuales Transformaciones ****
If VARType(goCfgalm.lAfeTra) = [L]
	IF GoCfgAlm.lAfeTra
		=GRABA_CONSUMOS_PRODUCCION(LsCodMat, DTRA.CodPrd, DTRA.FchDoc, DTRA.TipMov, -LfCandes,RECNO('DTRA'),'ESTR',CTRA.CodLote)
	ENDIF
ENDIF

SELECT CATG
UNLOCK
SELECT DTRA
RETURN

*********************************
FUNCTION alm_Carga_Stock_Almpcsm1
*********************************
   	*** AROMAS : GRABA Segun LA situacion del 
   	IF INLIST(GsSigCia,'AROMAS','PREZCOM') 
   		IF VARTYPE(SITU)='C'
   			IF !(INLIST(SITU,'01','03') OR EMPTY(SITU))
				RETURN
   			ENDIF
   		ENDIF
   	ENDIF

** Variables de C lculo **
PRIVATE LfCanDes,LfPreUni,LsSubAlm,LsCodMat
SELECT DTRA
LsSubAlm = DTRA.SubAlm
LsCodMat = DTRA.CodMat
LsAAAAMM = LEFT(DTOS(CTRA.FchDoc),6)
LfCanDes = DTRA.CanDes
LfPreUni = DTRA.PreUni
IF DTRA.CodMon = 1
	LfPreUMn = DTRA.PreUni
	IF DTRA.TpoCmb > 0
		LfPreUUS = ROUND(DTRA.PreUni/DTRA.TpoCmb,4)
	ELSE
		LfPreUUS = 0
	ENDIF
ELSE
	LfPreUMn = ROUND(DTRA.PreUni*DTRA.TpoCmb,4)
	LfPreUUS = DTRA.PreUni
ENDIF
IF DTRA.Factor > 0
	LfCanDes = DTRA.CanDes * DTRA.Factor
	LfPreUni = DTRA.PreUni/DTRA.Factor
	LfPreUMn = LfPreUMn/DTRA.Factor
	LfPreUUS = LfPreUUS/DTRA.Factor
ENDIF
*** Bloqueamos los archivos a trabajar ***
SELECT CALM
SEEK LsSubAlm+LsCodMat
DO WHILE !RLOCK()
ENDDO
SELECT CATG
SEEK LsCodmat
DO WHILE !RLOCK()
ENDDO

**** Actualizamos a los materiales por almacen ****
SELECT CALM
REPLACE CALM.StkAct WITH CALM.StkAct + LfCanDes
IF CALM.FCHING < DTRA.FchDoc
	REPLACE CALM.FCHING WITH DTRA.FCHDOC
ENDIF
UNLOCK
**** Actualizamos a los materiales generales ****
SELECT CATG
IF GoCfgAlm.lModPre .AND. LfCanDes > 0   && OJO: caso de revalorizaci¢n
	REPLACE CATG.UltCmp WITH MAX(CATG.UltCmp,CTRA.FchDoc)
	REPLACE CATG.PMAXMN WITH MAX(CATG.PMAXMN,LfPreUMn)
	REPLACE CATG.PMAXUS WITH MAX(CATG.PMAXUS,LfPreUUS)
   ** Verificamos si es el ultimo registro grabado
   ** para grabar el precio de ultima compra
	SELECT DTRA
	IF CATG.UltCmp <=CTRA.FchDoc
	      SELECT CATG
		REPLACE CATG.PULTMN WITH LfPreUMn
	      REPLACE CATG.PULTUS WITH LfPreUUS
	ENDIF
ENDIF
SELECT DTRA
**** Actualizamos Precios Promedio ****
=CALC_ACT_COSTOPROMEDIOUNIT(RECNO('DTRA'),.f.)
**** Actualizamos a los acumulados mensuales ****
IF GoCfgAlm.lModCsm
	=GRABA_CONSUMOS_PRODUCCION(LsCodMat, DTRA.CodPrd, DTRA.FchDoc, DTRA.TipMov, LfCandes,RECNO('DTRA'),'ESTA',C_CTRA.CodLote)
ENDIF
**** Actualizamos a los Acumulados Mensuales Transformaciones ****
If VARType(goCfgalm.lAfeTra) = [L]
	IF GoCfgAlm.lAfeTra
		=GRABA_CONSUMOS_PRODUCCION(LsCodMat, DTRA.CodPrd, DTRA.FchDoc, DTRA.TipMov, LfCandes,RECNO('DTRA'),'ESTR',C_CTRA.CodLote)
	ENDIF
ENDIF





SELECT CATG
UNLOCK
SELECT CALM
UNLOCK
SELECT DTRA
RETURN
*********************************************************************** EOP() *
** Actualizamos lotes
***************************
FUNCTION ITEM_ALMACEN_LOTE
****************************
PARAMETERS _Sede,_SubAlm,_Item,_Lote,_FchVto,_TipMov,_CanDes,_FchDoc,_SITU,_Recalculo		
   	*** AROMAS : GRABA Segun LA situacion del 
   	IF INLIST(GsSigCia,'AROMAS','PREZCOM') 
   		IF VARTYPE(_SITU)='C'
   			IF !(INLIST(_SITU,'01','03') OR EMPTY(_SITU))
				RETURN
   			ENDIF
   		ENDIF
   	ENDIF

IF PARAMETERS() < 4
		RETURN -1
	_FchVto = DATE()
ENDIF
IF VARTYPE(_LOTE)#'C'
	RETURN -1
ENDIF

IF EMPTY(_LOTE)
	RETURN -1
ENDIF

LsAreaActual = ALIAS()
IF !USED('DLOTE')
	RETURN -1
ENDIF
_ITEM=PADR(_item,LEN(dlote.codmat))
_Lote=PADR(_Lote,LEN(dlote.Lote))
_SubAlm=PADR(_SubAlm,LEN(dlote.SubAlm))

LlHayLotePERANT=.f.
IF _Recalculo 
	*** Buscamos maestro de lotes año anterior ***
	LsVD=SYS(5)
	LsRutaTabl=ADDBS(IIF(":"$GoEntorno.tspathadm,goentorno.tspathadm,LsVD+goentorno.tspathadm))
	LsPerAnt = STR(_ANO-1,4,0)
	LsRutaTablAno=LsRutaTabl+'CIA'+GsCodCia+'\C'+LsPerAnt+'\'
    
	IF !USED('DLOTA') 
		IF FILE(LsRutaTablAno+'ALMDLOTE.DBF')
			LlNoHayLotePERANT=goSvrCbd.odatadm.Abrirtabla('ABRIR','ALMDLOTE','DLOTA','DLOTE01','','',GsCodCia,LsPerAnt)
			IF !USED('DLOTA')
				LlHayLotePERANT=.f.
			ENDIF
		ELSE
			LlHayLotePERANT=.f.
		ENDIF
	ELSE
		
		LlHayLotePERANT=.T.
	ENDIF
ENDIF

SELECT DLOTE
LlFOUND=SEEK( _Sede+_SubAlm+_Item+_Lote,'DLOTE','DLOTE01')
IF !LlFOUND
	APPEND BLANK
	replace CodSed WITH _Sede
	REPLACE CodMat WITH _Item
	replace SubAlm WITH _SubAlm
	replace Lote   WITH _Lote
	replace FchVto WITH _FchVto	
	*** Verificamos si tiene stock inicial por lote ***
	IF 	LlHayLotePERANT AND USED('DLOTA')
		IF SEEK( _Sede+_SubAlm+_Item+_Lote,'DLOTA','DLOTE01')
			REPLACE StkIni WITH DLOTA.StkAct
		ENDIF
	ENDIF
	REPLACE StkAct WITH STKINI
ENDIF

** Stock del Momento
DO CASE
	CASE _TipMov = 'I'
		replace StkAct WITH StkAct + _Candes
	CASE _TipMov = 'S'
		replace StkAct WITH StkAct - _Candes

ENDCASE
** Stock Por mes 
LOCAL LsMes ,K,LfStkAnt
LsMes = TRANSFORM(MONTH(_FchDoc),'@L 99')
LsCmpStk = 'STK'+LsMes


*!*	LfStkAnt = StkIni
*!*	FOR  K = 1 TO VAL(LsMes)-1
*!*		LsStkAnt = 'STK'+TRANSFORM(k,'@L 99')
*!*		LfStkAnt = LfStkAnt + &LsStkAnt.
*!*	ENDFOR

DO CASE
	CASE _TipMov = 'I'
		replace (LsCmpStk) WITH &LsCmpStk. + _Candes
	CASE _TipMov = 'S'
		replace (LsCmpStk) WITH &LsCmpStk. - _Candes

ENDCASE



IF !EMPTY(LsAreaActual) 
	SELECT (LsAreaActual)
	
ENDIF
RETURN ROUND(dlote.StkAct,2)

***************************
FUNCTION ITEM_ALMACEN_SERIE
****************************
PARAMETERS _Sede,_SubAlm,_Item,_Serie,_FchVto,_TipMov,_CanDes,_FchDoc,_SITU		
   	*** AROMAS : GRABA Segun LA situacion del 
   	IF INLIST(GsSigCia,'AROMAS','PREZCOM') 
   		IF VARTYPE(_SITU)='C'
   			IF !(INLIST(_SITU,'01','03') OR EMPTY(_SITU))
				RETURN
   			ENDIF
   		ENDIF
   	ENDIF

IF PARAMETERS() < 4
		RETURN -1
	_FchVto = DATE()
ENDIF
IF VARTYPE(_Serie)#'C'
	RETURN -1
ENDIF

IF EMPTY(_Serie)
	RETURN -1
ENDIF

LsAreaActual = ALIAS()
IF !USED('DSER')
	RETURN -1
ENDIF
_ITEM	=PADR(_item,	LEN(DSER.codmat	))
_SERIE	=PADR(_Lote,	LEN(DSER.Serie	))
_SubAlm	=PADR(_SubAlm,	LEN(DSER.SubAlm	))


SELECT DSER
LlFOUND=SEEK(_Sede+_SubAlm+_Item+_Serie,'SERI','DSERI04')
IF !LlFOUND
	APPEND BLANK
	replace CodSed WITH _Sede
	REPLACE CodMat WITH _Item
	replace SubAlm WITH _SubAlm
	replace Serie  WITH _Serie
	replace FchVto WITH _FchVto	
ENDIF

** Stock del Momento
DO CASE
	CASE _TipMov = 'I'
		replace StkAct WITH StkAct + _Candes
	CASE _TipMov = 'S'
		replace StkAct WITH StkAct - _Candes

ENDCASE
** Stock Por mes 
LOCAL LsMes ,K,LfStkAnt
LsMes = TRANSFORM(MONTH(_FchDoc),'@L 99')
LsCmpStk = 'STK'+LsMes


*!*	LfStkAnt = StkIni
*!*	FOR  K = 1 TO VAL(LsMes)-1
*!*		LsStkAnt = 'STK'+TRANSFORM(k,'@L 99')
*!*		LfStkAnt = LfStkAnt + &LsStkAnt.
*!*	ENDFOR

DO CASE
	CASE _TipMov = 'I'
		replace (LsCmpStk) WITH &LsCmpStk. + _Candes
	CASE _TipMov = 'S'
		replace (LsCmpStk) WITH &LsCmpStk. - _Candes

ENDCASE



IF !EMPTY(LsAreaActual) 
	SELECT (LsAreaActual)
	
ENDIF
RETURN ROUND(SERI.StkAct,2)

*********************************
FUNCTION alm_Carga_Stock_Almpcsm2
*********************************
PARAMETER LlActPCto
   	*** AROMAS : GRABA Segun LA situacion del 
   	IF INLIST(GsSigCia,'AROMAS','PREZCOM') 
   		IF VARTYPE(SITU)='C'
   			IF !(INLIST(SITU,'01','03') OR EMPTY(SITU))
				RETURN
   			ENDIF
   		ENDIF
   	ENDIF

PRIVATE LfCanDes,LfPreUni,LsSubAlm,LsCodMat
SELECT DTRA
LsSubAlm = DTRA.SubAlm
LfCanDes = DTRA.CanDes
LfPreUni = DTRA.PreUni
IF DTRA.Factor > 0
   LfCanDes = DTRA.CanDes * DTRA.Factor
   LfPreUni = DTRA.PreUni/DTRA.Factor
ENDIF
LsCodMat = DTRA.CodMat
*** Bloqueamos los archivos a trabajar ***
SELECT CALM
SEEK LsSubAlm+LsCodMat
DO WHILE !RLOCK()
ENDDO
SELECT CATG
SEEK LsCodMat
DO WHILE !RLOCK()
ENDDO
**** Actualizamos a los materiales por almacen ****
SELECT CALM
REPLACE CALM.StkAct WITH CALM.StkAct + LfCanDes
IF LlActPCto
   **** Actulizamos Precios Promedio ****
	IF DTRA.TipMov+DTRA.CodMov#'I000'  && Ingreso por Apertura de Inventario
		=CALC_ACT_COSTOPROMEDIOUNIT(RECNO('DTRA'),.f.)
	ENDIF
ENDIF

**** Actualizamos a los acumulados mensuales ****
IF GoCfgAlm.lModCsm
	=GRABA_CONSUMOS_PRODUCCION(LsCodMat, DTRA.CodPrd, DTRA.FchDoc, DTRA.TipMov, -LfCandes,RECNO('DTRA'),'ESTA',CTRA.CodLote)
ENDIF
**** Actualizamos a los Acumulados Mensuales Transformaciones ****
IF VARType(goCfgalm.lAfeTra) = [L]
	IF GoCfgAlm.lAfeTra
		=GRABA_CONSUMOS_PRODUCCION(LsCodMat, DTRA.CodPrd, DTRA.FchDoc, DTRA.TipMov, -LfCandes,RECNO('DTRA'),'ESTR',CTRA.CodLote)
	ENDIF
ENDIF

SELECT CATG
UNLOCK
SELECT CALM
UNLOCK
SELECT DTRA
RETURN
******************
FUNCTION HayStkAlm
******************
PARAMETERS sSubAlm,sCodMat,dFecha,cTipmov,sCodMov,sNroDoc,fCandes,lNuevo
PRIVATE m.CurrArea
m.CurrArea = ALIAS()
DO CASE
   CASE lNuevo
        =SEEK(sSubAlm+sCodmat,[CALM])
        LfStkSub=CALM.StkIni
        SELE DTRA
        SET ORDER TO DTRA02
        SEEK sSubAlm+sCodMat+DTOS(dFecha+1)
        IF !FOUND()
           IF RECNO(0)>0
              GO RECNO(0)
              IF DELETED()
                 SKIP
              ENDIF
           ENDIF
        ENDIF
        SKIP -1
        IF sSubAlm+sCodMat=SubAlm+CodMat  AND FchDoc<=dFecha
           LfStkSub = StkSub
        ENDIF
        SELE (m.CurrArea)
        RETURN LfStkSub>=fCandes
   CASE .NOT. lNuevo
        =SEEK(sSubAlm+sCodmat,[CALM])
        LfStkSub=CALM.StkIni
        SELE DTRA
        SET ORDER TO DTRA02
        SEEK sSubAlm+sCodMat+DTOS(dFecha)+cTipMov+sCodMov+sNroDoc
        IF FOUND()
           SKIP -1
           IF sSubAlm+sCodMat=SubAlm+CodMat  AND FchDoc<=dFecha
              LfStkSub = StkSub
           ENDIF
        ENDIF
        SELE (m.CurrArea)
        RETURN LfStkSub>=fCandes
ENDCASE
********************
FUNCTION Cap_Dbfs_OT
********************
parameter PcEntidad,pcAlias,PcNroDoc
if PARAMETERS()=0
	=messagebox('Debe definir Entidad','Error de acceso a tabla')
	return
else
	do case
		case PARAMETERS()=1
			LsWhere = []
			PcAlias = GoEntorno.TmpPath+SYS(3)
		case PARAMETERS()=2
			LsWhere = []
		case PARAMETERS()=3
			LsWhere = PcEntidad+[.Nrodoc==PcNrodoc]
	endcase
endif
IF USED(PcAlias)
	USE IN (PcAlias)
ENDIF
if empty(lsWhere)
	select * from (PcEntidad) into table (PcAlias)
else
	*
	DO CASE
	
	   CASE UPPER(PcEntidad) = [DO_T]  &&& Detalle
        	SELECT do_t.*,catg.DesMat,catg.UndStk,alma.DesSub,RECNO('do_t') AS NroReg, 0 AS RegGrb  ;
        	FROM   do_t INNER JOIN alma ON ;
        	       do_t.SubAlm = alma.SubAlm ;
        	       INNER JOIN catg ON ;
		           do_t.CodMat = catg.CodMat ;
		    WHERE  &LsWhere. ;
		    INTO CURSOR Temporal READWRITE 	
		*
		GO TOP 	
		SCAN  	    
	  	    
			REPLACE CanForA WITH CanFor
	        REPLACE CanDevA WITH CanDev
	        REPLACE CanSalA WITH CanSal
	        REPLACE CanAdiA WITH CanAdi		    
		    =SEEK(nrodoc+tippro+subalm+codmat,[DO_T],[DO_T01])
		    REPLACE NroReg WITH RECNO([DO_T])
	        DO CASE
	           CASE !FlgFor AND EMPTY(CodFor)
	                LfCanDes = CanFor
	                IF FacEqu>0
	                   LfCanDes = CanFor*FacEqu
	                ENDIF
	                =SEEK(SubAlm+CodMat,[CALM])
	                **** Verificamos si existe stock ****
	                IF !goCfgCpi.lStkNeg .AND. !HayStkAlm(SubAlm,CodMat,goCfgCpi.dFchDoc,[],[],[],LfCanDes,.T.)
	                   lHayStock = .F.
	                   REPLACE StkFor WITH .F.
	                ELSE
	                   REPLACE StkFor WITH .T.
	                ENDIF
	           CASE !FlgAdi AND EMPTY(CodAdi) AND CANADI#0 AND FlgFor
	                LfCanDes = CanAdi
	                IF FacEqu>0
	                   LfCanDes = CanAdi*FacEqu
	                ENDIF
	                =SEEK(SubAlm+CodMat,[CALM])
	                **** Verificamos si existe stock ****
	                IF !goCfgCpi.lStkNeg .AND. !HayStkAlm(SubAlm,CodMat,goCfgCpi.dFchDoc,[],[],[],LfCanDes,.T.)
	                   lHayStock = .F.
	                   REPLACE StkAdi WITH .F.
	                ELSE
	                   REPLACE StkAdi WITH .T.
	                ENDIF
	           CASE !FlgAdi AND EMPTY(CodAdi) AND CANADI#0 AND !FlgFor AND EMPTY(CODFOR)
	                LfCanDes = CanAdi + CanFor
	                IF FacEqu>0
	                   LfCanDes = (CanFor+CanAdi)*FacEqu
	                ENDIF
	                =SEEK(SubAlm+CodMat,[CALM])
	                **** Verificamos si existe stock ****
	                IF !m.lStkNeg .AND. !HayStkAlm(SubAlm,CodMat,goCfgCpi.dFchDoc,[],[],[],LfCanDes,.T.)
	                   lHayStock = .F.
	                   REPLACE StkAdi WITH .F.
	                ELSE
	                   REPLACE StkAdi WITH .T.
	                ENDIF
	        ENDCASE
	   ENDSCAN 
	   *
	   CASE UPPER(PcEntidad) = [MO_T]  &&& Mano de Obra
        	SELECT mo_t.*, TRIM(pers.ApePat)+[ ]+TRIM(pers.ApeMat)+[, ]+TRIM(pers.Nombre) AS NomPers, RECNO('mo_t') AS NROREG, 0.00 as ctot_he, 0.00 as ctot_hn ;
        	FROM   mo_t INNER JOIN pers ON ;
        	       mo_t.CodPers = pers.CodPer ;
		    WHERE  &LsWhere. ;
		    INTO CURSOR Temporal READWRITE 		    
	   		
	   CASE UPPER(PcEntidad) = [QO_T]  &&& Maquinaria y Equipo	 
	   		SELECT qo_t.*, part.Nompar, RECNO('qo_t') AS NROREG ;
        	FROM   qo_t INNER JOIN part ON ;
        	       qo_t.CodPar = part.CodPar ;
		    WHERE  &LsWhere. ;
		    INTO CURSOR Temporal READWRITE 
		    
	   CASE UPPER(PcEntidad) = [PO_T]  &&& Produccion
        	SELECT po_t.*,catg.DesMat,alma.DesSub,RECNO('po_t') AS NroReg, 0 AS RegGrb ;
        	FROM   po_t INNER JOIN alma ON ;
        	       po_t.SubAlm = alma.SubAlm ;
        	       INNER JOIN catg ON ;
		           po_t.CodPrd = catg.CodMat ;
		    WHERE  &LsWhere. ;
		    INTO CURSOR Temporal READWRITE 
		    GO TOP 		    
		    SCAN  
				REPLACE CanFinA WITH CanFin
		        REPLACE SubAlmA WITH SubAlm		        
   		    	=SEEK(nrodoc+subalm+codprd,[po_t],[PO_T01]) 		  	    
   		    	replace nroreg WITH RECNO([po_t])
		    ENDSCAN
		    		    
	   OTHERWISE
  	        SELECT *,0 AS NROITM FROM (PcEntidad) WHERE &LsWhere. INTO CURSOR Temporal  	        
	ENDCASE
	*
	SELE Temporal
	LcArcTmp = GoEntorno.TmpPath+STR((RAND()*100000),6)&&SYS(3)
	COPY TO (LcArcTmp)
	USE IN TEMPORAL
	SELE 0
	USE (LcArcTmp) ALIAS (PcAlias) Exclu
	DO CASE
	   CASE UPPER(PcEntidad) = [DO_T]  &&& Detalle
		   	ALTER TABLE (LcArcTmp) ALTER COLUMN REGGRB INTEGER(2) 
	        INDEX ON NroDoc+TipPro+SubAlm+CodMat TAG DO_T01
	        goCfgCpi.ArcExt = LcArcTmp
	   CASE UPPER(PcEntidad) = [PO_T]  &&& Produccion
		    ALTER TABLE (LcArcTmp) ALTER COLUMN REGGRB INTEGER(2) 
		   	INDEX on nrodoc+subalm+codprd+DTOS(fchfin) tag po_t01
			SET ORDER TO po_t01
	ENDCASE
endif		

************************
FUNCTION correlativo_cpi
************************
Lparameters _tabla,_CodSed,_Tpo_Pro,_Valor
SELECT * from (_tabla) where CodSed=_CodSed  and CodDoc=_Tpo_Pro INTO CURSOR C_NRO_T
Local LsCampo,LnNroDoc,LsPicture,LnLenSufijo,LnLenNDoc,LsCampo2
LsCampo = 'C_NRO_T.NDOC'+XsNroMes
LsCampo2 = 'NDOC'+XsNroMes
LnNroDoc= EVAL(LsCampo)
IF EMPTY(LnNroDoc) OR ISNULL(LnNroDoc)
	WAIT WINDOW NOWAIT "Falta definir en maestro de correlativos por almacen"
ENDIF
LsPicture = "@L "+REPLI('#',LEN(c_do_t.NroDoc))
LnLenNDoc = LEN(c_do_t.NroDoc) - LEN(XsNroMes) - LEN(_CodSed)
*IF CDOC->ORIGEN
	LnNroDoc = VAL(_CodSed+XsNroMes+RIGHT(TRANSF(LnNroDoc,LsPicture),LnLenNDoc))
*ENDIF
IF !_valor == '0'
	IF VAL(_Valor) > LnNroDoc
    	LnNroDoc = VAL(_Valor) + 1
	ELSE
    	LnNroDoc = LnNroDoc + 1
	ENDIF     
*!*	    DO CASE 
*!*	    	CASE XsNroMES <= "13"
*!*	        	LsCampo='NDOC'+XsNroMes
*!*	        OTHER
*!*	        	LsCampo='NRODOC'
*!*	   ENDCASE
   UPDATE (_Tabla) SET &LsCampo2. = LnNroDoc ;
   where CodSed=_CodSed  and CodDoc=_Tpo_Pro
ENDIF
RETURN  RIGHT(REPLI('0',LEN(c_do_t.NroDoc)) + LTRIM(STR(LnNroDoc)), LEN(c_do_t.NroDoc))
*
*
***************************************************************************************
* VETT ??? Procedimientos para Borrar Orden de Trabajo - CpipgO_T
***************************************************************************************
* El Procedimiento Grabar_O_T llama a :
* - DO ExtAlmCen
*******************
FUNCTION Borrar_O_T
*******************
=F1QEH("BORR_REG")
LnControl = 1
IF CieDelMes(_MES)
   LnControl = 0
   RETURN LnControl   
ENDIF
goCfgCpi.CierDbfPro()
IF !goCfgCpi.AbreDbfAlm()
   MESSAGEBOX([Error en apertura de archivos de almacen])
   DO goCfgCpi.CierDbfAlm()
   =goCfgCpi.AbreDbfPro()
   SELE C_CO_T
   LnControl = 0
   RETURN LnControl    
ENDIF

SELE C_CO_T
DO WHILE !RLOCK()
ENDDO
goCfgCpi.sNroO_T= NroDoc
SELE DO_T
SEEK C_CO_T.NroDoc

DO WHILE !EOF() .AND. NroDoc = C_CO_T.NroDoc
   DO WHILE !RLOCK()
   ENDDO
   DO ExtAlmCen WITH .T.,NroDoc,SubAlm,CodMat
   SELECT do_t 
   DELETE
   UNLOCK
   IF !EOF()
   	SKIP
   ENDIF 
ENDDO

SELE PO_T
SEEK C_CO_T.NroDoc
SCAN WHILE NroDoc = C_CO_T.NroDoc
     DO WHILE !RLOCK()
     ENDDO
     DO ExtAlmCen WITH .T.,NroDoc,SubAlm,CodPrd
     SELECT po_t 
     DELETE
     UNLOCK
ENDSCAN
SELE C_CO_T
REPLACE FlgEst WITH [A]
UNLOCK

UPDATE co_t SET flgEst = [A] WHERE NroDoc=C_CO_T.NroDoc

GoCfgCpi.CierDbfAlm()
=goCfgCpi.AbreDbfPro()

*m.Estoy = [MOSTRANDO]
*DO BROWS_OT with .T.,[DO_T]
*DEACTIVATE WINDOW (m.bTitulo)
*SHOW WINDOW (m.bTitulo) REFRESH TOP
=F1QEH("OK")

RETURN LnControl 

** FIN : REMPLAZO DE DATOS DE LA CABECERA
*
***************************************************************************************
* VETT ??? Procedimientos para Grabar Parte Diario - CpipgO_T
***************************************************************************************
* El Procedimiento Grabar_O_T llama a :
* - DO GrbdO_T
*******************
FUNCTION Grabar_O_T
*******************
*PARAMETERS m.sNroO_T 

SELECT CO_T
PRIVATE iRecno
=F1QEH("GRAB_DBFS")
*jj* PRIVATE iRecno

IF GoCfgCpi.Crear
   =F1QEH("GRAB_CABE")
   APPEND BLANK
   IF !F1_RLOCK(5)
     RETURN
   ENDIF
   STORE RECNO() TO iRECNO
   *Control multiuser *
   SELE CDOC
   IF !F1_RLOCK(5)
        SELE CO_T
        DELETE
        RETURN
   ENDIF
   IF GoCfgCpi.sNroO_T = GoCfgCpi.NroO_T
         * correlativo automatico
       XsNroMes=TRAN(_MES,"@L ##")
       Campo1   = [NDOC]+XsNroMes
       LnNroO_T = CDOC.&Campo1.
       LnNroO_T = VAL(XsNroMes+RIGHT(TRANSF(LnNroO_T,"@L ###"),3))
       LsNroO_T = ALLTRIM(STR(LnNroO_T))
       gocfgCpi.sNroO_T  = LEFT(CDOC.Siglas,3)+PADL(LsNroO_T,LEN(CO_T.NroDoc)-3,'0')
       REPLACE &Campo1. WITH &Campo1. + 1
   ELSE
      SELE CO_T
      SEEK goCfgCpi.sNroO_T
      IF FOUND()
    	  GO iRECNO
      	  DELETE
	      sErr = [Registro Creado por Otro Usuario]
          DO F1MSGERR WITH sERR
          RETURN
   	  ELSE
         SELE CDOC
         sNroCorr = SUBSTR(goCfgCpi.sNroO_T,4)
         IF VAL(sNroCorr)>=NroDoc
             REPLACE NroDoc WITH VAL(sNroCorr)+1
         ENDIF
      ENDIF
   ENDIF
   UNLOCK IN "CDOC"
   SELE CO_T
   GO iRECNO
   REPLACE NroDoc WITH goCfgCpi.sNroO_T
   *
   *SELECT CO_T
   *IF SEEK(m.sNroO_T ,'CO_T','CO_T01')
   *      m.sNroO_T=correlativo_Cpi(goCfgCpi.EntidadCorrelativo,goCfgCpi.CodSed,goCfgCpi.Tpo_Pro,'0')
   *		IF SEEK( m.sNroO_T ,'CO_T','CO_T01')
   *		   =MESSAGEBOX("Registro creado por otro usuario.")
   *		   RETURN -1   
   *		ENDIF
   * ENDIF
   * INSERT INTO CO_T ( NroDoc) VALUES (m.sNroO_T)
   * =correlativo_Cpi(goCfgCpi.EntidadCorrelativo,goCfgCpi.CodSed,goCfgCpi.Tpo_Pro,m.sNroO_T)
ELSE   
   =F1QEH("GRAB_CABE")
   =SEEK(goCfgCpi.sNroO_T,'CO_T','CO_T01')
ENDIF
*GoCfgCpi.sNroO_T = m.sNroO_T
*!*	** REMPLAZAMOS DATOS DE LA CABECERA **
*!*	REPLACE FchDoc WITH dFchDoc
*!*	REPLACE Respon WITH sRespon
*!*	REPLACE CanObj WITH fCanObj
*!*	REPLACE CodPro WITH sCodPrd
*!*	REPLACE CdArea WITH sCdArea
*!*	** Guardamos datos anteriores **
*!*	REPLACE FchFinA WITH FchFin
*!*	REPLACE CanFinA WITH CanFin
*!*	*--------------X---------------*
*!*	REPLACE FchFin WITH dFchFin
*!*	REPLACE CanFin WITH fCanFin

*!*	REPLACE FlgEst WITH IIF(!EMPTY(FchFin),[T],cFlgEst)
*!*	REPLACE TipBat WITH m.tipbat
*!*	** Factor de producci¢n
*!*	REPLACE Factor WITH fFactor

UPDATE Co_t SET ;
		FchDoc   = C_CO_T.FchDoc,;
		Respon   = C_CO_T.Respon,;
		CanObj   = C_CO_T.CanObj,;
		CodFase  = C_CO_T.CodFase,;
		CodProcs = C_CO_T.CodProcs,;
		CodActiv = C_CO_T.CodActiv,;
		CodLote  = C_CO_T.CodLote,;
		CodCult  = C_CO_T.CodCult,;
		CodPro   = C_CO_T.CodPrO,;
		CdArea   = C_CO_T.CdArea,;
		FchFinA  = C_CO_T.FchFin,;
		CanFinA  = C_CO_T.CanFin,;
		FchFin   = C_CO_T.FchFin,;
		CanFin   = C_CO_T.CanFin,;
		FlgEst   = IIF(C_CO_T.FlgEst=[P] AND !gocfgcpi.chkstk(),C_CO_T.FlgEst,IIF(C_CO_T.FlgEst=[P] AND gocfgcpi.chkstk(),[E],IIF(C_CO_T.FlgEst=[L] AND !EMPTY(C_CO_T.FchFin),[T],C_CO_T.FlgEst))), ;
		TipBat   = C_CO_T.tipbat,;
		Factor   = C_CO_T.Factor ;	
	WHERE NroDoc = goCfgCpi.sNroO_T
	
GoCfgCpi.cFlgEst = CO_T.FlgEst	&& Retomamos el valor del FlgEst
*
LnControl = GrbdO_T()
SELE C_CO_T
UNLOCK ALL
RETURN LnControl

** FIN : REMPLAZO DE DATOS DE LA CABECERA
***************************************************************************************
*+-----------------------------------------------------------------------------+
*Ý GRBdO_T   Prototipo de grabaci¢n  de O_T y Actualizaci¢n a almacen          Ý
*Ý                                                                             Ý
*Ý                                                                             Ý
*+-----------------------------------------------------------------------------+
***************** VETT ?????
* El Procedimiento GrbdO_T llama a :
* - DO CierDbfPro    M
* - !AbreDbfAlm()    M
* - DO CierDbfAlm   M
* - =AbreDbfPro()
* - DO ExtAlmCen WITH .F.,NroDoc,SubAlm,CodMat
* - !ArrConfig()
* - =ChkMovAct([CanFor])
* - =ActAlmCen(K)
*****************
PROCEDURE GrbdO_T  && Comienza la chanfainita
*****************
** Cerramos archivos innecesarios  **

lActalm = .T.
STORE .F. TO GoCfgCpi.aHayMov
GoCfgCpi.CierDbfPro()
IF !GoCfgCpi.AbreDbfAlm()
   MESSAGEBOX([Error en apertura de archivos de almacen],[Alerta])
   GoCfgCpi.CierDbfAlm()
   =GoCfgCpi.AbreDbfPro()
   lActalm = .F.
ENDIF
** Extornamos datos anteriores de almacen con otro factor **
SELE EXTORNO
SCAN
	IF !EMPTY(CodFor+CodAdi+CodDev)
		DO ExtAlmCen WITH .F.,NroDoc,SubAlm,CodMat
    ENDIF
ENDSCAN

** Borramos informacion anterior **
IF GoCfgCpi.GnTotDel >0
   FOR k = 1 TO GoCfgCpi.GnTotDel   	    
       IF GoCfgCpi.aRegDel(k)>0

          SELE DO_T
          GO GoCfgCpi.aRegDel(k)
          DO WHILE !RLOCK()
          ENDDO
          DO ExtAlmCen WITH .F.,DO_T.NroDoc,DO_T.SubAlm,DO_T.CodMat,.T.
          SELE DO_T
          DELETE
          UNLOCK
       ENDIF
   ENDFOR
ENDIF
IF GoCfgCpi.GnTotDelpo_t >0
   FOR k = 1 TO GoCfgCpi.GnTotDelpo_t
       IF GoCfgCpi.aRegDelpo_t(k)>0

          SELE PO_T
          GO GoCfgCpi.aRegDelPo_t(k)
          DO WHILE !RLOCK()
          ENDDO
          DO ExtAlmCen WITH .T.,PO_T.NroDoc,PO_T.SubAlm,PO_T.CodPrd,.T.          
          SELE PO_T
          DELETE
          UNLOCK
       ENDIF
   ENDFOR
ENDIF
IF GoCfgCpi.GnTotDelmo_t >0
   FOR k = 1 TO GoCfgCpi.GnTotDelmo_t
       IF GoCfgCpi.aRegDelmo_t(k)>0

          SELE MO_T
          GO GoCfgCpi.aRegDelMo_t(k)
          DO WHILE !RLOCK()
          ENDDO              
          SELE MO_T
          DELETE
          UNLOCK
       ENDIF
   ENDFOR
ENDIF
IF GoCfgCpi.GnTotDelQo_t >0
   FOR k = 1 TO GoCfgCpi.GnTotDelQo_t
       IF GoCfgCpi.aRegDelQo_t(k)>0

          SELE QO_T
          GO GoCfgCpi.aRegDelQo_t(k)
          DO WHILE !RLOCK()
          ENDDO
          SELE QO_T
          DELETE
          UNLOCK
       ENDIF
   ENDFOR
ENDIF
** Cargamos configuraci¢n de Producci¢n **
IF GoCfgCpi.nTotMov <=0
   IF !GoCfgCpi.ArrConfig()
      messagebox([No existe configuración para actualizar almacen],0+48+0,'Atencion !!')
      =GoCfgCpi.AbreDbfPro()
      lActAlm = .F.
   ENDIF
ENDIF

** Grabaci¢n de detalle de O_T   **

SELE C_DO_T
PACK
GO TOP
SCAN
 **IF EMPTY(NroDoc)
 **   REPLACE NroDoc WITH sNroO_t
 **ENDIF
 **IF EMPTY(CodPro)
 **   REPLACE CodPRo WITH sCodPrd
 **ENDIF
 **IF EMPTY(TipPro)
 **   =SEEK(CODMAT,[CATG])
 **   IF !CATG.NoProm
 **      m.TipPro = [PTA] && Insumos que no son envases
 **   ELSE
 **      m.TipPro = [PTB] && Insumos que si son envases
 **   ENDIF
 **   REPLACE TipPro  WITH m.TipPro
 **ENDIF
 **IF CnFmla=0
 **   REPLACE CnFmla WITH CanFor
 **ENDIF
 **IF FacEqu=0
 **   REPLACE FacEqu WITH 1
 **ENDIF
   IF C_CO_T.TipBat=2
		REPLACE CnFmla WITH CanFor + CanAdi
   ENDIF
   =GoCfgCpi.ChkMovAct([CanFor])
   =GoCfgCpi.ChkMovAct([CanAdi])
  *=GoCfgCpi.ChkMovAct([CanSal])
   =GoCfgCpi.ChkMovAct([CanDev])

   SCATTER MEMVAR
   IF NroReg>0
      m.Nro_Reg = NroReg
      SELE DO_T
      GO m.Nro_Reg
   ELSE
      SELE DO_T

      APPEND BLANK
      m.Nro_Reg = RECNO()
   ENDIF
   IF RECNO()<>m.Nro_Reg AND m.Nro_Reg>0   && Ser¡a el colmo !!
      GO m.Nro_Reg
   ENDIF
   GATHER MEMVAR
   REPLACE FCHDOC WITH CO_T.fCHdOC
   UNLOCK
   SELE C_DO_T
   REPLACE RegGrb WITH m.Nro_Reg
ENDSCAN
*

SELE CO_T
goCfgCpi.HayIngP_T = !EMPTY(CO_T.FchFin) AND (CO_T.CanFin#CO_T.CanFinA OR CO_T.FchFin#CO_T.FchFinA)
** Chequeamos si hay que valorizar Productos terminados **
**se valoriza cuando hay algun movimiento en la formulacion de la produccion
lValProTer = .f.
PRIVATE YY
FOR YY = 1 to GoCfgCpi.nTotMov
	if GoCfgCpi.aPorP_T(yy)
	else
	   IF GoCfgCpi.aHayMov(yy)		
	   	  lValProTer =.t.	
	   endif
	endif
ENDFOR
** Fin De Chequeo **
SELE DTRA
SET ORDER TO DTRA04
SELE C_PO_T
SEEK GoCfgCpi.sNroO_T 
SCAN WHILE NroDoc=GoCfgCpi.sNroO_T 
     lGrbValAlm=SEEK(GoCfgCpi.ZsTpoRef+NroDoc+CodPrd+SubAlm+CodP_T,[DTRA])
     lGrbCtoUni=lGrbValAlm AND (DTRA.Preuni#0 AND DTRA.ImpCto#0)
     IF lValProTer or CostMn<=0 or !lGrbCtoUni OR  canfin<>canfina
        DO WHILE !RLOCK()
        ENDDO
        REPLACE FlgAlm WITH .F.&&Almacen no esta actualizado con salida por produccion, hay q actualizar!!
        UNLOCK
     ENDIF
     =GoCfgCpi.ChkMovAct([CanFin])&&checkea si finalmente actualizamos el almacen por salida a produccion
	   
	   SCATTER MEMVAR
	   IF NroReg>0
	      m.Nro_Reg = NroReg
	      SELE PO_T
	      GO m.Nro_Reg
	   ELSE
	      SELE PO_T
	      APPEND BLANK
	      m.Nro_Reg = RECNO()
	   ENDIF
	   IF RECNO()<>m.Nro_Reg AND m.Nro_Reg>0   && Ser¡a el colmo !!
	      GO m.Nro_Reg
	   ENDIF
	   GATHER MEMVAR
	   UNLOCK
	   SELE C_PO_T
	   REPLACE RegGrb WITH m.Nro_Reg
ENDSCAN
** Graba Mano de Obra **
SELECT C_MO_T
GO top
SCAN
	   SCATTER MEMVAR
	   IF NroReg>0
	      m.Nro_Reg = NroReg
	      SELE MO_T
	      GO m.Nro_Reg
	   ELSE
	      SELE MO_T
	      APPEND BLANK
	      m.Nro_Reg = RECNO()
	   ENDIF
	   IF RECNO()<>m.Nro_Reg AND m.Nro_Reg>0   && Ser¡a el colmo !!
	      GO m.Nro_Reg
	   ENDIF
	   GATHER MEMVAR
	   REPLACE FCHDOC WITH CO_T.fCHdOC
	   UNLOCK
	   SELE C_MO_T	   
ENDSCAN

** Graba Maquinaria y equipo **
SELECT C_QO_T
GO top
SCAN
	   SCATTER MEMVAR
	   IF NroReg>0
	      m.Nro_Reg = NroReg
	      SELE QO_T
	      GO m.Nro_Reg
	   ELSE
	      SELE QO_T
	      APPEND BLANK
	      m.Nro_Reg = RECNO()
	   ENDIF
	   IF RECNO()<>m.Nro_Reg AND m.Nro_Reg>0   && Ser¡a el colmo !!
	      GO m.Nro_Reg
	   ENDIF
	   GATHER MEMVAR
       REPLACE FCHDOC WITH CO_T.fCHdOC
	   UNLOCK
	   SELE C_QO_T	   
ENDSCAN
**
SELE CO_T

IF !lActAlm
   RETURN
ENDIF

IF CieDelMes(_MES)
   RETURN
ENDIF

** Y abrimos archivos de almacen   **
IF !GocfgCpi.AbreDbfAlm()
   =messagebox([Error en apertura de archivos de almacen],'Atención')
   GoCfgCpi.CierDbfAlm()
   =GoCfgCpi.AbreDbfPro()
   RETURN
ENDIF

STORE .F. TO GoCfgCpi.aConFig
*DO CPIsgo_t.spr
PRIVATE K
nNumItmI = 0
FOR K = 1 TO GoCfgCpi.nTotMov
    IF GoCfgCpi.aHayMov(K) &&&AND aConFig(K,1)
       IF CO_T.flgest<>[P] 
       		LnOk = MESSAGEBOX('Existen componentes y/o insumos que no cuentan con stock en este momento, Desea generar las ;
 salidas de los que si tienen stock y dejar pendientes los que no tienen stock ?',32+4,'Atencion!! / Warning!!')   				 
 			IF LnOk<>6
		   		=ActAlmCen(K)		        			
 			ENDIF	
	   ELSE 
	   		=ActAlmCen(K)		       
	   ENDIF 
	   
    ENDIF
ENDFOR
** Imprimir guias de almacen **
lCapConfig =.T.
*DO Impr_Guias &POR REVISAR
**
RELEASE K
** Cerramos archivos de Almacen **
=GoCfgCpi.CierDbfAlm()
** Y abrimos archivos de Producci¢n **
IF !GoCfgCpi.AbreDbfPro()
   MESSAGEBOX([Error en apertura de archivos de Producci¢n])
ENDIF
RETURN

****************** ????? VETT ?????
* El Procedimiento ExtAlmCen llama a : 
* - DO ALMpdsm2 WITH .T.
* - DO ALMpcsm2 WITH .T.
*******************
PROCEDURE ExtAlmCen && Extornamos ingresos y/o salidas de almacen
*******************
PARAMETER ANULAR,LsNroDoc,LsSubAlm,LsCodMat,BorraItem
**
m.CurrArea = ALIAS()
LOCAL LoDatAdm AS DataAdmin OF k:\aplvfp\classgen\vcxs\DOSVR.vcx
LoDatAdm=CREATEOBJECT('DOSVR.DataAdmin')

IF !USED([ESTA])
   *USE ALMESTCM ORDER ESTA01 ALIAS ESTA IN 0
   LoDatAdm.abrirtabla([ABRIR],[ALMESTCM] ,[ESTA],[ESTA01])
   IF !USED()
       =messagebox([No se puede actualizar archivo almestcm.dbf],'Fallo acceso a tabla')
       RETURN
   ENDIF
ENDIF
*
IF !USED([ESTR])
   *USE ALMESTTR ORDER ESTR01 ALIAS ESTR IN 0
   LoDatAdm.abrirtabla([ABRIR],[ALMESTTRM] ,[ESTR],[ESTR01])
   IF !USED()
       =messagebox([No se puede actualizar archivo almesttr.dbf],'Fallo acceso a tabla')
       RETURN
   ENDIF
ENDIF
*
RELEASE LoDatAdm
**
m.CurrArea = ALIAS()
LsNroDoc  = PADR(LsNroDoc,LEN(DTRA.NroRef))
LsLLave   = GoCfgCpi.ZsTpoRef+LsNroDoc+LsCodMat+LsSubAlm
SELE DTRA
SET ORDER TO DTRA04
SEEK LsLlave
SCAN WHILE TpoRef+NroRef+CodMat+SubAlm=LsLlave
	 m.CurReg = RECNO()
     IF ANULAR AND USED([CTRA])
        IF SEEK(SubAlm+TipMov+CodMov+NroDoc,[CTRA]) AND CTRA.FLGEST#[A]
           SELE CTRA
           =F1_RLOCK(0)
           REPLACE FlgEst WITH [A]
           REPLACE Observ WITH [*** A N U L A D O ***]
           UNLOCK
           SELE DTRA
        ENDIF
     ENDIF
     =F1_RLOCK(0)
     IF TipMov = [I]
        =Alm_Descarga_stock_Almpdsm2(.T.)     
     ELSE
        =Alm_Carga_Stock_Almpcsm2(.T.)     
     ENDIF
	 =item_almacen_lote(GsCodSed,DTRA.SubAlm,DTRA.CodMat,DTRA.Lote,DTRA.FchVto,DTRA.TipMov,-DTRA.CanDes,DTRA.FchDoc,DTRA.SITU)
	 
     IF ANULAR OR BorraItem
        DELETE
     ENDIF
     
     IF ANULAR OR BorraItem
     ELSE
        REPLACE CanDes WITH 0
     ENDIF
     UNLOCK
     IF m.CurReg<>RECNO()
        GO m.CurReg
     ENDIF
ENDSCAN
SET ORDER TO DTRA01
IF USED([ESTA])
   SELE ESTA
   USE
ENDIF
*
IF USED([ESTR])
   SELE ESTR
   USE
ENDIF
*
IF !EMPTY(m.CurrArea)
	SELE (m.CurrArea)
ENDIF
RETURN


****************** ????? VETT ?????   VERIFICAR CUANDO ES EN EL CURSOR
* El Procedimiento ActAlmCen llama a :
* - ChkNroDoc(sNroO_T+LsSubAlm+LcTipMov+LsCodMov)
* - !GrbCabAlm(LsSubAlm,LcTipMov,LsCodMov,LsNroDoc,LdFchDoc)
* - DO GrbDetAlm
* - DO FinGrbAlm
* - DO VALORIZA
* - =chqmovalm_Pt()
******************
FUNCTION ActAlmCen
******************
PARAMETER m.NumEle
GoCfgAlm.cTipMov = GoCfgCpi.aTipMov(m.NumEle)
GoCfgAlm.sCodMov = GoCfgCpi.aCodMov(m.NumEle)
GoCfgAlm.sDesMov = GoCfgCpi.aDesMov(m.NumEle)
GoCfgAlm.sNroDoc = []
GoCfgAlm.dFchDoc = C_CO_T.FchDoc
LsValor  = GoCfgCpi.aCmpEva(m.NumEle)
LsEvalua = GoCfgCpi.aEvalua(m.NumEle)
m.Insumos= !GoCfgCpi.aPorP_T(m.NumEle)
LsCmpAct1= GoCfgCpi.aCmpAct1(m.NumEle)
LsCmpAct2= GoCfgCpi.aCmpAct2(m.NumEle)
LcLote   = [lote]+RIGHT(TRIM(LsValor),3)
gocfgalm.sNroOdT  = PADR(GoCfgCpi.sNroO_T,LEN(DTRA.NroRef))&&AMAA 17-01-07 para que CTRA guarde sus referencias
GoCfgAlm.sCodPrd  = goCfgCpi.scodprd && AMAA 17-01-07
IF MESSAGEBOX("GENERAR "+GoCfgCpi.aDesMov(m.NumEle),4+32+0,"Actualizar Almacen")=7  &&& No
   RETURN
ENDIF

IF !goCfgAlm.Cap_Cfg_Transacciones(GoCfgAlm.cTipMov,GoCfgAlm.sCodMov)
   =MESSAGEBOX([No se puede actualizar almacen , Error en configuración])
   RETURN .F.
ENDIF

goCfgAlm.nCodMon = 1
IF GoCfgCpi.lMonUsa
   goCfgAlm.nCodMon = 2
ENDIF
goCfgAlm.fTpoCmb = 1.00

LsDesCrip  = TRIM(LEFT(GoCfgCpi.aDesMov(m.NumEle),30))
WAIT WINDOW [ACTUALIZANDO ]+LsDescrip NOWAIT
IF m.Insumos
   SELE C_DO_T
   GO TOP
   DO WHILE !EOF()
      IF !EVAL(LsEvalua)
         SKIP
         LOOP
      ENDIF
      GoCfgAlm.SubAlm  = SubAlm
      LsSubAlm		   = SubAlm
      LsDesCrip = LsDesCrip +[ EN:]+LEFT(AlmNombr(LsSubAlm),13)  
      WAIT WINDOW [ACTUALIZANDO ]+LsDescrip NOWAIT
      
      GoCfgAlm.sNroDoc=ChkNroDoc(GoCfgCpi.sNroO_T+GoCfgAlm.SubAlm+GoCfgAlm.cTipMov+GoCfgAlm.sCodMov)
      **AMAA 03-01-07 Generar los Cursores C_CTRA y C_DTRA porque son usados por Grabar_transaccion_alm y  Grabar_transaccion_alm_detalle
    	LOCAL LoDatAdm AS DataAdmin OF k:\aplvfp\classgen\vcxs\DOSVR.vcx
		LoDatAdm=CREATEOBJECT('DOSVR.DataAdmin')
		
		LoDatAdm.closetable('C_CTRA')	&&deberia siempre retornarme vacío si es creacion o lleno si no es creacion
		=cap_almctran( [C_CTRA] ,GoCfgAlm.SubAlm,GoCfgAlm.cTipMov,GoCfgAlm.sCodMov,GoCfgAlm.sNroDoc)

			*ahora lo lleno con DATOS ACTUALIZADOS DEL GoCfgAlm
			SELECT C_ctra 		
			replace codsed WITH gscodsed
			replace SubAlm WITH GoCfgAlm.SubAlm
			replace TipMov WITH GoCfgAlm.cTipMov
			replace CodMov WITH GoCfgAlm.sCodMov
			replace NroDoc WITH GoCfgAlm.sNroDoc
			
			UPDATE C_CTRA SET ;
			FchDoc = GoCfgAlm.dFchDoc,;
			NroRf1 = GoCfgAlm.sNroRf1,;
			NroRf2 = GoCfgAlm.sNroRf2,;
			NroRf3 = GoCfgAlm.sNroRf3,;
			NroOdt = GoCfgAlm.sNroOdt,; 	 		
			CodVen = GoCfgAlm.sCodVen,;
			CodPro = GoCfgAlm.sCodPro,;
			CodCli = GoCfgAlm.sCodCli,;
			CodMon = GoCfgAlm.xnCodMon,;
			TpoCmb = GoCfgAlm.fTpoCmb,;
			Observ = GoCfgAlm.sObserv,;
			FBatch = GoCfgAlm.fBatch,;
			User =GoCfgAlm.Usuario,;
			NomTra = GoCfgAlm.NomTra,;
			DirTra = GoCfgAlm.DirTra,;
			RucTra = GoCfgAlm.RucTra,;
			PlaTra = GoCfgAlm.PlaTra,;
			Brevet = GoCfgAlm.Brevet,;    	
	    	Motivo = GoCfgAlm.Motivo,;
	    	ImpBrt = GoCfgAlm.fImpBrt,;
	    	PorIgv = GoCfgAlm.fPorIgv,;    	
	    	ImpIgv = GoCfgAlm.fImpIgv,;
	    	ImpTot = GoCfgAlm.fImpTot,;
	    	CodUser=GoCfgAlm.Usuario,;
	    	CodActiv=GoCfgAlm.cCodActiv,;
	    	CodProcs=GoCfgAlm.cCodProcs,;
	    	CodFase =GoCfgAlm.cCodFase,;
	    	CodCult =GoCfgAlm.cCodCult,;
	    	CodPar = GoCfgAlm.sCodPar,;
	    	AlmOri = GoCfgAlm.AlmOri,;
	    	AlmTrf = GoCfgAlm.AlmTrf,;
	    	TpoRf1 = GoCfgAlm.TpoRf1,;
	    	TpoRf2 = GoCfgAlm.TpoRf2,;
	    	TpoRf3 = GoCfgAlm.TpoRf3,;
	    	FchHora = DATETIME(),;
	    	FmaPgo = GoCfgAlm.xiFmaPgo,;
	    	CndPgo = GoCfgAlm.xsCndPgo,;	    	
	    	CodPrd = GoCfgAlm.sCodPrd,;
	    	Flgest = 'E' ;       
			where  Subalm = goCfgAlm.SubAlm AND ;
			TipMov = goCfgAlm.cTipMov AND ; 			  	     	
		   	CodMov = goCfgAlm.sCodMov AND  ;
		   	NroDoc = goCfgAlm.sNroDoc    	
		   		    	
    	LoDatAdm.closetable('C_DTRA')	&&debería siempre retornarme vacío
		=cap_almdtran( [C_DTRA] ,GoCfgAlm.SubAlm,GoCfgAlm.cTipMov,GoCfgAlm.sCodMov,GoCfgAlm.sNroDoc)
		
		RELEASE LoDatAdm
	  **
      IF Grabar_transaccion_Alm(GsCodSed,GoCfgAlm.SubAlm,GoCfgAlm.cTipMov,GoCfgAlm.sCodMov,GoCfgAlm.sNroDoc,.t.)<>1
         =MESSAGEBOX([IMPOSIBLE GENERAR ]+GoCfgCpi.aDesMov(m.NumEle)+[ EN ]+ALMNOMBR(LsSubALm))
         SELE C_DO_T
         SKIP
         LOOP
      ENDIF
      
      LsDescrip = LsDescrip + [Guía:]+gocfgalm.sNroDoc
      WAIT WINDOW [ACTUALIZANDO ]+LsDescrip NOWAIT
      LnNroItm = 0
      SELECT C_DO_T
      zllave = NroDoc+SubAlm
      SCAN WHILE NroDoc+SubAlm=zLlave    && Esta por verificarse este orden
           GoCfgAlm.fCandes = &LsValor.
           GoCfgAlm.sCodPrd = CodPro
           GoCfgAlm.sCodMat = CodMat
           GoCfgAlm.sUndVta = UndPro
           GoCfgAlm.fFactor = FacEqu
           GoCfgAlm.fPreUni = 0
           GoCfgAlm.fCnFmla = CnFmla
           GoCfgAlm.nRegGrb = RegGrb
           GoCfgAlm.cCodLote= &LcLote.
           IF GoCfgAlm.fCanDes>=0 AND EVAL(LsEvalua)
              m.Rec_Alm=0
              DO GrbDetAlm
              SELE DO_T
              GO GoCfgAlm.nRegGrb
              =F1_RLOCK(0)
              REPLACE &LsCmpAct1. WITH .T.
              REPLACE &LsCmpAct2. WITH GoCfgAlm.cTipMov+GoCfgAlm.sCodMov+GoCfgAlm.sNroDoc
              UNLOCK
           ENDIF
           SELE C_DO_T
      ENDSCAN
      IF LnNroItm >0
         SELE CTRA
         DO FinGrbAlm
      ENDIF
      SELE C_DO_T
   ENDDO
ELSE
   DO VALORIZA   && VALORIZA PRODUCCION DE LA O_T
   LnNroItm = 0
   SELE PO_T
   SEEK GoCfgCpi.sNroO_T
   SCAN WHILE NroDoc = GoCfgCpi.sNroO_T FOR EVAL(LsEvalua)
        LsSubAlm = SubAlm
        GoCfgAlm.SubAlm = SubAlm
        GoCfgAlm.dFchDoc = FchFin &&AMAA 18-01-07 para que ctra graba su fecha con la fecha de cierre
        GoCfgAlm.sCodPrd  = goCfgCpi.scodprd && AMAA 01-03-07
        LsDesCrip = LsDesCrip +[ EN:]+LEFT(AlmNombr(LsSubAlm),13)
        WAIT WINDOW [ACTUALIZANDO ]+LsDescrip NOWAIT
        =chqmovalm_Pt()&&verifica si se ha modificado un registro de la salida a produccion grabados anteriormente(el almacen de salida de pt)
        
        GoCfgAlm.sNroDoc=ChkNroDoc(GoCfgCpi.sNroO_T+GoCfgAlm.SubAlm+GoCfgAlm.cTipMov+GoCfgAlm.sCodMov)
        **AMAA 03-01-07 Generar los Cursores C_CTRA y C_DTRA porque son usados por Grabar_transaccion_alm y  Grabar_transaccion_alm_detalle
    	LOCAL LoDatAdm AS DataAdmin OF k:\aplvfp\classgen\vcxs\DOSVR.vcx
		LoDatAdm=CREATEOBJECT('DOSVR.DataAdmin')
		
		LoDatAdm.closetable('C_CTRA')	&&deberia siempre retornarme vacío si es creacion o lleno si no es creacion
		=cap_almctran( [C_CTRA] ,GoCfgAlm.SubAlm,GoCfgAlm.cTipMov,GoCfgAlm.sCodMov,GoCfgAlm.sNroDoc)

			*ahora lo lleno con DATOS ACTUALIZADOS DEL GoCfgAlm
			SELECT C_ctra 		
			replace codsed WITH gscodsed
			replace SubAlm WITH GoCfgAlm.SubAlm
			replace TipMov WITH GoCfgAlm.cTipMov
			replace CodMov WITH GoCfgAlm.sCodMov
			replace NroDoc WITH GoCfgAlm.sNroDoc
			
			UPDATE C_CTRA SET ;
			FchDoc = GoCfgAlm.dFchDoc,;
			NroRf1 = GoCfgAlm.sNroRf1,;
			NroRf2 = GoCfgAlm.sNroRf2,;
			NroRf3 = GoCfgAlm.sNroRf3,;
			NroOdt = GoCfgAlm.sNroOdt,;
			CodVen = GoCfgAlm.sCodVen,;
			CodPro = GoCfgAlm.sCodPro,;
			CodCli = GoCfgAlm.sCodCli,;
			CodMon = GoCfgAlm.xnCodMon,;
			TpoCmb = GoCfgAlm.fTpoCmb,;
			Observ = GoCfgAlm.sObserv,;
			FBatch = GoCfgAlm.fBatch,;
			User =GoCfgAlm.Usuario,;
			NomTra = GoCfgAlm.NomTra,;
			DirTra = GoCfgAlm.DirTra,;
			RucTra = GoCfgAlm.RucTra,;
			PlaTra = GoCfgAlm.PlaTra,;
			Brevet = GoCfgAlm.Brevet,;    	
	    	Motivo = GoCfgAlm.Motivo,;
	    	ImpBrt = GoCfgAlm.fImpBrt,;
	    	PorIgv = GoCfgAlm.fPorIgv,;    	
	    	ImpIgv = GoCfgAlm.fImpIgv,;
	    	ImpTot = GoCfgAlm.fImpTot,;
	    	CodUser=GoCfgAlm.Usuario,;
	    	CodActiv=GoCfgAlm.cCodActiv,;
	    	CodProcs=GoCfgAlm.cCodProcs,;
	    	CodFase =GoCfgAlm.cCodFase,;
	    	CodCult =GoCfgAlm.cCodCult,;
	    	CodPar = GoCfgAlm.sCodPar,;
	    	AlmOri = GoCfgAlm.AlmOri,;
	    	AlmTrf = GoCfgAlm.AlmTrf,;
	    	TpoRf1 = GoCfgAlm.TpoRf1,;
	    	TpoRf2 = GoCfgAlm.TpoRf2,;
	    	TpoRf3 = GoCfgAlm.TpoRf3,;
	    	FchHora = DATETIME(),;
	    	FmaPgo = GoCfgAlm.xiFmaPgo,;
	    	CndPgo = GoCfgAlm.xsCndPgo,;
	    	CodLote = GoCfgAlm.cCodLote,;
	    	CodPrd = GoCfgAlm.sCodPrd,;
	    	Flgest = 'E' ;       
			where  Subalm = goCfgAlm.SubAlm AND ;
			TipMov = goCfgAlm.cTipMov AND ; 			  	     	
		   	CodMov = goCfgAlm.sCodMov AND  ;
		   	NroDoc = goCfgAlm.sNroDoc    	
		   		    	
    	LoDatAdm.closetable('C_DTRA')	&&debería siempre retornarme vacío si no es creacion
		=cap_almdtran( [C_DTRA] ,GoCfgAlm.SubAlm,GoCfgAlm.cTipMov,GoCfgAlm.sCodMov,GoCfgAlm.sNroDoc)
		
		RELEASE LoDatAdm
	  **	
        IF Grabar_transaccion_Alm(GsCodSed,GoCfgAlm.SubAlm,GoCfgAlm.cTipMov,GoCfgAlm.sCodMov,GoCfgAlm.sNroDoc,.t.)<>1  
        	MESSAGEBOX("Imposible actualizar almacen "+AlmNombr(LsSubAlm))
            SELE PO_T
        ELSE
           LsDescrip = LsDescrip + [Guía:]+GoCfgAlm.sNroDoc
           WAIT WINDOW [ACTUALIZANDO ]+LsDescrip NOWAIT
           SELECT PO_T
           =SEEK(CodPrd,[CATG])
           GoCfgAlm.sCodPrd = []
           GoCfgAlm.sCodMat = CodPrd
           GoCfgAlm.fCanDes = CanFin
           GoCfgAlm.sUndVta = CATG.UndStk
           GoCfgAlm.fFactor = 1
           GoCfgAlm.dFchDoc = FchFin
           GoCfgAlm.FCnFmla = 0
           GoCfgAlm.fPreUni = ROUND(CostMn/CanFin,4)
           GoCfgAlm.cCodLote= &LcLote.
           *Gocfgalm.fimpcto = ROUND(GoCfgAlm.fPreUni*GoCfgAlm.fCanDes,2)

           IF GoCfgAlm.fCanDes>=0
              DO GrbDetAlm
              SELE PO_T
              =F1_RLOCK(0)
              REPLACE &LsCmpAct1. WITH .T.
              REPLACE &LsCmpAct2. WITH GoCfgAlm.cTipMov+GoCfgAlm.sCodMov+GoCfgAlm.sNroDoc
              UNLOCK
              SELE CTRA
              DO FinGrbAlm
           ENDIF
           SELE PO_T
        ENDIF
   ENDSCAN
ENDIF
RETURN

******************
FUNCTION ChkNroDoc
******************
PARAMETER m.Llave

PRIVATE m.OrDer,m.CurrArea
m.CurrArea=ALIAS()
SELE CTRA
m.Order = ORDER()
m.NroDocAlm = SPACE(LEN(CTRA.NRODOC))
SET ORDER TO CTRA02
SEEK m.Llave
IF FOUND()
	m.NroDocAlm = CTRA.NroDoc
	GoCfgAlm.Crear  = .f.
ELSE 
	GoCfgAlm.Crear  = .t.   
	m.NroDocAlm=correlativo_alm(gocfgalm.entidadcorrelativo,goCfgAlm.cTipMov,goCfgAlm.sCodMov,goCfgAlm.SubAlm,'0')
ENDIF
SELECT CTRA 
SET ORDER TO (m.Order)
SELE (m.CurrArea)
RETURN m.NroDocAlm

* El Procedimiento GrbCabAlm llama a :
* - NROAST()
* - !CAPVARCFG()                                           &&& goCfgAlm.Cap_Cfg_Transacciones1
* - DO ALMPACOM WITH CodMat,CodPrd,FchDoc,TipMov,-Candes   =GRABA_CONSUMOS_PRODUCCION(CodMat,CodPrd,FchDoc,TipMov,-Candes,nroreg,'ESTR')
* - DO ALMPATRA WITH CodMat,CodPrd,FchDoc,TipMov,-Candes
* - DO ALMPCPP1           &&& Calculamos precio promedio
*******************
PROCEDURE GrbCabAlm
*******************
PARAMETERS m.SubAlm,m.TipMov,m.CodMov,m.NroDoc,m.FchDoc
PRIVATE GsSubAlm,GsCodSed,lCrear,GsNomSub,m.CurrArea
m.CurrArea = ALIAS()
IF TYPE("GsCodSed")#[C]   &&&& VETT ????
   GsCodSed = [001]
ENDIF
* buscamos control de correlativos *
SELE CDOC
SET ORDER TO CDOC01
SEEK (m.SubAlm+m.TipMov+m.CodMov)
IF !FOUND()
    MESSAGEBOX([Correlativo no existe....])
*   UltTecla = K_ESC
    SELE (m.CurrArea)
    RETURN .F.
ENDIF
**m.NroCor = RIGHT(REPLI("0",LEN(m.NroDoc)) + LTRIM(STR(CDOC->NroDoc)),LEN(m.NroDoc))
m.NroCor=NROAST()    &&&& VETT
*
m.sDesMov = []

** VETT ??? El procedimiento CAPVARCFG() es parecido a =gocfgalm.Cap_Cfg_Transacciones
** Capturamos la configuracion de transacciones para el tipo y codigo de la configuración en ALMCFTRA
** =gocfgalm.Cap_Cfg_Transacciones(GoCfgAlm.cTipMov,GoCfgAlm.sCodMov)

** IF !CAPVARCFG()

IF !goCfgAlm.Cap_Cfg_Transacciones1(m.TipMov,m.CodMov)
   MESSAGEBOX([No se puede actualizar almacen , Error en configuración])
   SELE (m.CurrArea)
   RETURN .F.
ENDIF

m.nCodMon = 1
IF GoCfgCpi.lMonUsa
   m.nCodMon = 2
ENDIF
m.fTpoCmb = 1.00
m.sObserv = SPACE(LEN(CTRA.Observ))
m.sNroRf1 = SPACE(LEN(CTRA.NroRf1))
m.sNroRf2 = SPACE(LEN(CTRA.NroRf2))
m.sNroOdt = GoCfgCpi.sNroO_T
m.sCodCli = []
m.sCodPro = []
m.sCodVen = []
m.sCodAux = []
m.sCodPar = []
*
IF m.lPidCli
   m.sCodAux = SPACE(LEN(m.sCodCli))
ENDIF

IF m.lPidPro
   m.sCodAux = SPACE(LEn(m.sCodPro))
ENDIF

IF m.lPidActFijo
   m.sCodAux = SPACE(LEn(m.sCodPar))
ENDIF


m.fImpBrt = 0.00
m.fImpTot = 0.00
m.fImpIgv = 0.00
m.fPorIgv = 0.00

lCrear = EMPTY(m.NroDoc)

IF lCrear
   m.NroDoc = m.NroCor     && Correlativo
ENDIF

** Parte del Procedimiento GrbCabAlm es igual a Grabar_transaccion_Alm
** por eso llame a esa funcion pero hay unas cosas que no entiendo
** ???? VETT

=Grabar_transaccion_Alm(GsCodSed,m.SubAlm,m.TipMov,m.CodMov,m.NroDoc)



****************** ????? VETT ?????
* El Procedimiento GrbDetAlm llama a :
* DO ALMpdsm2 WITH .T.
* DO ALMpcsm2 WITH .T.
* DO ALMpcsm1
* DO ALMpdsm1
*******************
PROCEDURE GrbDetAlm
*******************

PRIVATE LsNroO_T
m.Reg_Act = 0
m.Ingreso = INLIST(goCfgAlm.cTipMov,[I],[R])
gocfgalm.sNroOdT  = PADR(GoCfgCpi.sNroO_T,LEN(DTRA.NroRef))
SELE DTRA
SET ORDER TO DTRA04
SEEK goCfgCpi.ZsTpoRef+gocfgalm.sNroOdT+goCfgalm.sCodMat+goCfgalm.SubAlm+goCfgalm.cTipMov+goCfgalm.sCodMov+goCfgalm.sNroDoc
IF FOUND() 		
	DO WHILE !RLOCK()
	ENDDO	   
	m.Reg_Act = RECNO()
	LnNroItm = NroItm
	IF m.Ingreso
		=Alm_Descarga_stock_Almpdsm2(.T.)   
	ELSE
	    =Alm_Carga_Stock_Almpcsm2(.T.)   
	ENDIF
	=item_almacen_lote(gsCodSed,gocfgalm.SubAlm,DTRA.CodMat,DTRA.Lote,DTRA.FchVto,DTRA.TipMov,-DTRA.CanDes,DTRA.FchDoc,DTRA.SITU)
	SELECT DTRA 
	REPLACE CanDes WITH 0
	UNLOCK
	IF GoCfgAlm.fCandes<=0
		RETURN
	ENDIF	
ELSE
   IF GoCfgAlm.fCandes<=0
      RETURN
   ENDIF
   APPEND BLANK
   m.Reg_Act = RECNO()
   LnNroItm = LnNroItm + 1
ENDIF
IF RECNO()<>m.Reg_Act AND m.Reg_Act>0
   GO m.Reg_Act
ENDIF

** Afectar o no el stock
m.situ = '06'&& Por inspeccionar 
IF !EMPTY(goCfgAlm.cCodLote)	
	cPregunta = "Almacen-"+gocfgalm.SubAlm+[ ]++": Desea aprobar el movimiento del material "+gocfgalm.sCodMat+", en el Lote:"+goCfgAlm.cCodLote
	IF MESSAGEBOX(cPregunta,4+32+0,"Actualizar Almacen")=7  &&& No
	ELSE 	
		m.situ = '01'
	ENDIF
ENDIF 
**

DO WHILE !RLOCK()
ENDDO
*REPLACE CodAlm WITH GsCodAlm
REPLACE SubAlm WITH gocfgalm.SubAlm
REPLACE TipMov WITH gocfgalm.cTipMov
REPLACE CodMov WITH gocfgalm.sCodMov
REPLACE NroDoc WITH gocfgalm.sNroDoc
REPLACE FchDoc WITH gocfgalm.dFchDoc
REPLACE CodMat WITH gocfgalm.sCodMat
REPLACE CanDes WITH gocfgalm.fCanDes
REPLACE UndVta WITH gocfgalm.sUndVta
REPLACE Factor WITH gocfgalm.fFactor
REPLACE CodPrd WITH gocfgalm.sCodPrd
REPLACE FBatch WITH gocfgalm.fFactor
REPLACE CnFmla WITH gocfgalm.fCnFmla
REPLACE CodSed WITH gsCodSed
replace lote   WITH GoCfgAlm.cCodLote
*
REPLACE TpoRef WITH gocfgcpi.zstporef     && Generado autom ticamente por producci¢n.
*
REPLACE NroItm WITH LnNroItm
*
REPLACE CodMon WITH gocfgalm.nCodMon
REPLACE TpoCmb WITH gocfgalm.fTpoCmb
REPLACE CodPro WITH gocfgalm.sCodPro
**REPLACE CodVen WITH m.sCodVen
REPLACE CodCli WITH gocfgalm.sCodCli
REPLACE User   WITH GsUsuario
REPLACE NroRef WITH gocfgalm.sNroOdt
*
REPLACE CTRA.NroItm WITH CTRA.NroItm + 1
*
IF gocfgalm.lPidPco
   replace preuni with gocfgalm.fPreUni
   replace ImpCto WITH ROUND(GoCfgAlm.fPreUni*GoCfgAlm.fCanDes,2)
   REPLACE DTRA->CodAjt WITH "A"
ELSE
   REPLACE DTRA->CodAjt WITH " "
ENDIF
REPLACE SITU WITH m.situ 
*
*jj*IF m.Ingreso
*jj*   DO ALMpcsm1
*jj*ELSE
*jj*   DO ALMpdsm1
*jj*ENDIF
*
IF m.Ingreso

   =Alm_Carga_Stock_Almpcsm1()
ELSE   
   =Alm_Descarga_Stock_ALmpdsm1()
ENDIF
=item_almacen_lote(gsCodSed,gocfgalm.SubAlm,DTRA.CodMat,DTRA.Lote,DTRA.FchVto,DTRA.TipMov,DTRA.CanDes,DTRA.FchDoc,DTRA.SITU)
*
UNLOCK
*IF ALEN(aImprimir)<nNumItmI+1
*   DIMENSION aImprimir(nNumItmI + 5)
*ENDIF
*nNumItmI = nNumItmI + 1
*aImprimir(nNumItmI)=SubAlm+TipMov+CodMov+NroDoc+CodMat
RETURN

****************** ????? VETT ?????
* El Procedimiento FinGrbAlm no llama a otro
*******************
PROCEDURE FinGrbAlm
*******************
=F1QEH("OK")
SELE CTRA
UNLOCK
*IF LcTipMov=[I]
*   DO pEmision IN AlmpMI1a
*ELSE
*   DO pEmision IN AlmpMS1a
*ENDIF
RETURN

****************** ????? VETT ?????
* El Procedimiento VALORIZA no llama a otro
******************
PROCEDURE VALORIZA
******************
priva xnvalmn, xnvalus, xncanfin,ii
store 0 to xnvalmn, xnvalus, xncanfin
xncanfin = co_t.canfin
sele dtra
set order to dtra04
seek GoCfgCpi.ZsTpoRef + GoCfgCpi.snroO_t
*AMAA12-01-07\Valoriza de acuerdo a todos los tipos de movimientos hechos en almacen, menos para el movimiento por producto terminado o salida a produccion
if found()
   scan while tporef=GoCfgCpi.ZsTpoRef and nroref=GoCfgCpi.snroo_t and !eof()
        lpro_term=.f.
        for ii=1 to GoCfgCpi.ntotmov
            if GoCfgCpi.atipmov(ii)+GoCfgCpi.acodmov(ii)=tipmov+codmov
               if GoCfgCpi.aporp_t(ii)
                  lpro_term=.t.
               endif
               exit
            endif
        endfor
        if lpro_term
           loop
        endif
        if tipmov = [S]
           xnvalmn = xnvalmn + impnac
           xnvalus = xnvalus + impusa
        else
           xnvalmn = xnvalmn - impnac
           xnvalus = xnvalus - impusa
        endif
   endscan
endif
*Coloca los costos por produccion en cada registro de los productos producidos.
sele po_t
xnreg_act = recno()
seek GoCfgCpi.snroo_t
if found()
   scan while nrodoc = GoCfgCpi.snroo_t and !eof()
        do while !rlock()
        enddo
        repla costmn with iif(xncanfin<>0,round(xnvalmn*canfin/xncanfin,2),0)
        repla costus with iif(xncanfin<>0,round(xnvalus*canfin/xncanfin,2),0)
        unlock
   endscan
endif
return

****************** ????? VETT ?????
* El Procedimiento ChqMovalm_Pt llama a :
* DO ExtAlmCen WITH .T.,NroDoc,SubAlmA,CodPrd
*********************
Function ChqMovalm_Pt
*********************
PRIVATE AREA_ACT
AREA_ACT=alias()
IF EMPTY(CodP_t)
	return .f.
ENDIF
*
IF 	SubAlm#SubAlmA AND !EMPTY(SubAlmA)
	DO ExtAlmCen WITH .T.,NroDoc,SubAlmA,CodPrd
ENDIF
*
IF CodPrd#CodPrdA AND !EMPTY(CodPrdA)
    DO ExtAlmCen WITH .T.,NroDoc,SubAlm,CodPrdA
endif
*
SELE (Area_Act)
return .t.


*************************************************************
*                                                           *
*          FUNCTION F1_RLOCK : BLOQUEO DE REGISTRO          *
*                                                           *
*************************************************************
*!*****************************************************************************
*!
*!       Function: F1_RLOCK
*!
*!      Called by: TPOCMB             (procedure in GER_S_VB.PRG)
*!
*!          Calls: F1_CAJA            (procedure in belcsoft.PRG)
*!               : F1_ALERT           (procedure in belcsoft.PRG)
*!
*!*****************************************************************************
FUNCTION f1_rlock
PARAMETERS lapso
PRIVATE siempre,inic,temp,ok
inic    = Lapso
siempre = (inic = 0)
ok      = .t.

IF siempre
   WAIT WINDOW "Un momento por favor..." NOWAIT
ENDIF
DO WHILE .T.
   IF .NOT. RLOCK()
      retardo=100
      DO WHILE retardo > 0
         retardo = retardo-1
      ENDDO
      lapso = lapso - 1
      IF .NOT. (siempre .OR. lapso > 0)
         IF MESSAGEBOX([Registro bloqueado por otro usuario],5+32+0,'Atención !!!')=2
            ok     = .f.
            EXIT
         ELSE
			WAIT WINDOW "Un momento por favor..." NOWAIT
         ENDIF
         lapso    =  inic
      ENDIF
   ELSE
      ok     = .t.
      EXIT
   ENDIF
ENDDO
* ------------------------------------------------------------------------
RETURN ok

****************************
FUNCTION Verifica_Cierre_CTB
****************************
SELECT 0
USE CBDTCIER
IF !used()
	=MESSAGEBOX([No hay acceso a tabla de cierres memsuales],'Error ')
	return
ENDIF
RegAct = _Mes + 1
GoCfgAlm.GlModMes = ! Cierre
IF RegAct <= RECCOUNT()
	GOTO RegAct
	GoCfgAlm.GlModMes = ! Cierre
ENDIF
USE
******************
FUNCTION CieDelMes
******************
PARAMETER m.Mes
PRIVATE LsFecha
LsMes=MES(m.Mes,2)
IF !GoCfgAlm.GlModMes
   =messagebox([Existe cierre contable del mes de ]+LsMes     ,[Atención])
   RELEASE LsMes
   RETURN .T.
ELSE
   RELEASE LsMes
   RETURN .F.
ENDIF
*******************
PROCEDURE CapVarCfg
*******************
** Definiendo Variables a necesitar **
IF !USED([CFTR])
   USE ALMCFTRA ORDER CFTR01 ALIAS CFTR IN 0
   IF !USED([CFTR])
      RETURN .F.
   ENDIF
ENDIF

SELE CFTR
SEEK m.TipMov+m.CodMov
m.sDesMov = LEFT(DESMOV,30)
m.lPidRf1 = CFTR->PidRf1
m.lPidRf2 = CFTR->PidRf2
m.lPidRf3 = CFTR->PidRf3
m.GloRf1  = CFTR->GloRf1
m.GloRf2  = CFTR->GloRf2
m.GloRf3  = CFTR->GloRf3
m.lPidVen = CFTR->PidVen
m.lPidCli = CFTR->PidCli
m.lPidPro = CFTR->PidPro
m.lPidOdT = CFTR->PidOdT
m.lModPre = CFTR->ModPre
m.lUndStk = CFTR->UndStk .OR. EOF()
m.lUndVta = CFTR->UndVta
m.lUndCmp = CFTR->UndCmp
IF ! m.lUndVta .and. ! m.lUndCmp
   m.lUndStk = .t.
ENDIF
m.lModCsm = CFTR->ModCsm
*
m.lAfeTra = CFTR->AfeTra
*
m.lExtPco = CFTR->ExtPco
m.lPidPco = CFTR->PidPco
m.lMonNac = CFTR->MonNac
m.lMonUsa = CFTR->MonUsa
m.lMonElg = CFTR->MonElg
m.lStkNeg = CFTR->StkNeg
if ! m.lMonElg .and. ! m.lMonUsa
   m.lMonNac = .t.
   m.lMonElg = .f.
   m.lMonUsa = .f.
ENDIF
USE
RETURN .T.
********************
PROCEDURE Impr_Guias
********************
PRIVATE J,LsLLave,G
=goCfgcpi.Cierdbfpro()
IF !GoCfgCpi.AbreDbfAlm()
   =messagebox([Error en apertura de archivos de almacen],[Atención])
   =GoCfgCpi.CierDbfAlm()
ENDIF

SELE CTRA
m.Tag = ORDER()
SET ORDER TO CTRA02
SEEK CO_T.NroDoc
SCAN WHILE NroOdt=CO_T.NroDoc
     IF lCapConfig
        m.TipMov = TipMov
        m.CodMov = CodMov
        IF GoCfgAlm.cap_cfg_transacciones(m.TipMov,m.CodMov)&&!CAPVARCFG()
           DO F1MSGERR WITH [No se pudo capturar configuraci¢n]
        ENDIF
        SELE CTRA
     ENDIF
     WAIT WINDOW [Imprimiendo Guia:]+NroDoc+[ ALM:]+LEFT(ALMNOMBR(SubAlm),25)+[ ]+m.sDesmov NOWAIT
     IF TipMov=[I]
        *DO pEmision IN AlmpMI1a
     ELSE
        *DO pEmision IN AlmpMS1a
     ENDIF
     SELE CTRA
ENDSCAN
SELE CTRA
SET ORDER TO (m.Tag)
=GoCfgCpi.CierDbfAlm()
=GoCfgCpi.AbreDbfPro()
RETURN
**************************************
PROCEDURE Borrar_Transaccion_Alm_X_ALM
*************************************
PARAMETERS PcAnular
IF PARAMETERS()<1 OR VARTYPE(PcAnular)<>'C'
	PcAnular = ''
ENDIF
#include CONST.H

LnNumRegAct = 0	&& Cantidad de registros actualizados  

LOCAL ___TpoRef as String ,___NroRef as String 
STORE '' TO ___TpoRef ,___NroRef
SELECT c_Dtra 
LOCATE 
IF EOF('C_DTRA')
	&& No se que poner aqui
	SELECT C_CTRA
	___TpoRef = C_CTRA.TpoRf1
	___NroRef = C_CTRA.NroRf1
	LnOkTra=Borrar_transaccion_Alm(C_CTRA.CodSed, C_CTRA.SubAlm, C_CTRA.TipMov , C_CTRA.CodMov , C_CTRA.NroDoc,PcAnular)
	IF LnOkTra<0
		SELECT C_CTRA
   	 	 STRTOFILE(PROGRAM()+" "+TTOC(DATETIME())+CRLF,ERRLOGFILE,.T.)
   	 	 STRTOFILE("*-- NO SE PUEDE BORRAR ITEM --*"+CRLF,ERRLOGFILE,.T.)
		 STRTOFILE("ALMACEN :"+Tporf1+' '+Nrorf1+CRLF,ERRLOGFILE,.T.)
		 STRTOFILE("Nrodoc:"+subalm+'-'+tipmov+'-'+codmov+'-'+nrodoc+'-'+DTOC(fchdoc)+CRLF,ERRLOGFILE,.T.)
	ENDIF
ELSE
	___TpoRef = TpoRef
	___NroRef = NroRef
    DIMENSION aRefPedidos[1,2] 
    STORE '' TO aRefPedidos[1,2] 
    LnNumRegAct = 0	&& Cantidad de registros actualizados


	SELECT c_Dtra 
	INDEX on subalm+Tipmov+CodMov+NroDoc TAG MatxAlm2  FOR !EMPTY(SubAlm) AND !EMPTY(CodMAt) AND !EMPTY(NroDoc) UNIQUE
	SET ORDER TO MatxAlm2
	LOCATE
	SCAN
		** Capturamos los pedidos de los registros procesados VETT 2015/03/12
		LnNumRegAct	=	LnNumRegAct + 1
		IF ALEN(aRefPedidos,1)<LnNumRegAct
			DIMENSION aRefPedidos[LnNumRegAct+5,2] 	
		ENDIF
		aRefPedidos[LnNumRegAct,1] = TpoRfb
		aRefPedidos[LnNumRegAct,2] = NroRfb
		LnOkTra=Borrar_transaccion_Alm(CodSed, SubAlm, TipMov , CodMov , NroDoc,PcAnular)
		IF LnOkTra<0
			 SELECT c_Dtra 
	   	 	 STRTOFILE(PROGRAM()+" "+TTOC(DATETIME())+CRLF,ERRLOGFILE,.T.)
 	   	 	 STRTOFILE("*-- NO SE PUEDE BORRAR ITEM --*"+CRLF,ERRLOGFILE,.T.)
			 STRTOFILE("ALMACEN :"+Tporef+' '+Nroref+CRLF,ERRLOGFILE,.T.)
			 STRTOFILE("Nrodoc:"+subalm+'-'+tipmov+'-'+codmov+'-'+nrodoc+'-'+DTOC(fchdoc)+CRLF,ERRLOGFILE,.T.)
		ENDIF
		SELECT C_DTRA
	ENDSCAN
	SET ORDER TO 
ENDIF
DO CASE
	CASE  ___TpoRef='G/R'
		IF SEEK(___TpoRef+___NroRef,'GUIA','VGUI01')
			=RLOCK('GUIA')
			replace FlgEst WITH 'A' IN GUIA
			UNLOCK IN guia
			** Actualizamos Cabecera de Pedidos		VETT 2015/03/12
			IF LnNumRegAct > 0
				DIMENSION aRefPedidos[LnNumRegAct,2]
				FOR K = 1 TO LnNumRegAct
					GoCfgAlm.xAct_Ped_GR_CAB(aRefPedidos[K,1],aRefPedidos[K,2])
				ENDFOR
			ENDIF			
		ENDIF
	CASE  INLIST(___TpoRef,'PROF','BOLE','FACT')
			** Actualizamos Cabecera de Pedidos		VETT 2015/03/12
			IF LnNumRegAct > 0
				DIMENSION aRefPedidos[LnNumRegAct,2]
				FOR K = 1 TO LnNumRegAct
					GoCfgAlm.xAct_Ped_GR_CAB(aRefPedidos[K,1],aRefPedidos[K,2])
				ENDFOR
			ENDIF			
	CASE ___TpoRef='O_T'
	CASE ___TpoRef='O_CM'
	CASE ___TpoRef='O/CN'
	CASE ___TpoRef='O/CI'
ENDCASE 
RETURN 1
** Procedimientos agregados el 23-05-2002 1:30 pm VETT
************************************************************************** FIN
* Procedimiento de Borrado ( Auditado ) de un documento
******************************************************************************
PROCEDURE Borrar_transaccion_Alm
********************************
PARAMETERS  m.cCodSed, m.cSubAlm, m.cTipMov , m.sCodMov , m.sNroDoc,m.cAnular
IF PARAMETERS() <6 OR VARTYPE(m.cAnular)<>'C'
	m.cAnular = ''
ENDIF
LOCAL LlTieneDetalleSinCabecera AS Boolean 
LlTieneDetalleSinCabecera = .F.
SELE CTRA		&& CTRA01
SEEK m.cSubAlm + m.cTipMov + m.sCodMov + m.sNroDoc
IF !FOUND()
	*=messagebox('Número de documento no existe') 
	**>>  Vo.Bo. VETT  2008/12/12 15:48:47 		
	IF SEEK(m.cSubAlm + m.cTipMov + m.sCodMov + m.sNroDoc,'DTRA','DTRA01')
		** No podemos regresar si existe detalle sin cabecera, hay que borrarlo.
		LlTieneDetalleSinCabecera = .T.		
	ELSE
		IF m.cAnular='I' && Estamos creando un registro nuevo en la BD 
			RETURN 1		
		ENDIF
		return -1
	ENDIF
	**>>  Vo.Bo. VETT  2008/12/12 15:49:06 
ENDIF
IF CieDelMes(_MES)
   RETURN -1
ENDIF
IF CieAHoyDia(CTRA.FchDoc)
   RETURN -1
ENDIF
SELECT CTRA
IF .NOT. F1_RLock(5) AND LlTieneDetalleSinCabecera = .F.
	RETURN -1             && No pudo bloquear registro
ENDIF

=F1QEH("BORR_REG")

IF FlgEst = [A] AND m.cAnular = 'E'
	IF MESSAGEBOX('Esta transacción sera borrado permanentemente de la base de datos esta seguro de continuar?',4+32+256,'Atención:') = 7
		unlock all
		IF !LlTieneDetalleSinCabecera 
			return -1
		ENDIF
	ENDIF
	DELETE
	UNLOCK
	IF !LlTieneDetalleSinCabecera 
		RETURN 1
	ENDIF
ENDIF

*!*	m.sNroDoc = CTRA->NroDoc  && No entiento por que hacia esto antes **>>  Vo.Bo. VETT  2008/12/12 16:15:00 
**
SELECT DTRA
LsOrderAct_DTRA=ORDER()
SET ORDER TO DTRA01
SEEK (m.cSubAlm + m.cTipMov + m.sCodMov + m.sNroDoc )
OK     = .T.
DO WHILE ! EOF() .AND.  OK .AND. ;
   (m.cSubAlm+m.cTipMov+m.sCodMov+m.sNroDoc) = (SubALm+TipMov+CodMov+NroDoc)
	IF F1_Rlock(5)
			**AMAA 06-12-06
		IF GoCfgAlm.cTipMov='I'
			IF GoCfgAlm.XsTpoRef="O_CM"
				lRequi = .F.
				lItems = .F.
				DO ActO_C WITH DTRA.NroRef,DTRA.CodMat,-DTRA.Candes,DTRA.NroRef2,[LG]
				UNLOCK IN "DO_C"
				UNLOCK IN "CREQ"
			ENDIF
		ENDIF 
		    **
		SELE CATG
		SEEK DTRA->CodMat
		SELE CALM
		SEEK m.cSubAlm + DTRA->CodMat
		SELECT DTRA
		DELETE
		DO CASE 
			CASE GoCfgAlm.cTipMov='I'
				=Alm_Descarga_stock_ALMpdsm2(.T.)
			CASE GoCfgAlm.cTipMov='S'
				=Alm_Carga_Stock_Almpcsm2(.T.)
				** VETT  29/01/2015 11:39 AM : ACT:PEDIDOS 
				DO CASE
					CASE GoCfgAlm.XsTpoRef="G/R"
						IF TpoRfb='PEDI' AND !EMPTY(NroRfb)  && Nro Pedido
							GoCfgAlm.xDes_Ped_GR(DTRA.NroRfb,DTRA.CodMat,DTRA.CanDes, DTRA.UndVta,DTRA.Factor)
						ENDIF
					OTHER
				ENDCASE
	
		ENDCASE					
		=item_almacen_lote(GoCfgAlm.CodSed,DTRA.SubAlm,DTRA.CodMat,DTRA.Lote,DTRA.FchVto,DTRA.TipMov,-DTRA.CanDes,DTRA.FchDoc,DTRA.SITU)
			*** SERIES 
	*!*			IF DTRA.NroReg>0 && Solo si ya existe , se supone no?
		IF !EMPTY(DTRA.Serie)
			=ActualizaStockSeries(DTRA.CodMat,DTRA.Serie,DTRA.TipMov,1)
		ENDIF
	*!*			ENDIF
		UNLOCK
	ELSE
		OK = .F.
	ENDIF
	SKIP
ENDDO
SELECT dtra
SET ORDER TO (LsOrderAct_DTRA)
** Actualizamos Cabecera de la ordenes **
SELECT CTRA
IF Ok AND m.cAnular = 'E'
	REPLACE CODCLI WITH ""
	REPLACE CODPRO WITH ""
	REPLACE OBSERV WITH ""
	REPLACE FlgEst WITH "A"    && Marca de anulado
   *AMAA 06-12-06	
   ** Chequeamos estado de orden de compra **
	IF GoCfgAlm.xsTpoRef="O_CM"
		=ChkEstO_C(EVALUATE("ctra."+gocfgalm.cmpref))
	ENDIF 
  **
ENDIF
=F1QEH("OK")
SELE CTRA
SEEK (m.cSubAlm + m.cTipMov + m.sCodMov + m.sNroDoc )
** DO pEmision
*=messagebox('Falta definir formato de impresión, consultar con sistemas')
SELE CTRA
UNLOCK ALL
RETURN 1

*******************
FUNCTION CieAHoyDia
*******************
PARAMETER m.Fecha
PRIVATE LsFecha
IF empty(GoCfgAlm.GdFchCie) OR ISNULL(GoCfgAlm.GdFchCie)
	RETURN .F.
ENDIF
LsFecha=DTOC(GoCfgAlm.GdFchCie)
IF m.Fecha<=GoCfgAlm.GdFchCie
   =F1_ALERT([Existe cierre de transacciones al ]+LsFecha ,[MENSAJE])
   RELEASE LsFecha
   RETURN .T.
ELSE
   RELEASE LsFecha
   RETURN .F.
ENDIF
*****************
FUNCTION almnombr
*****************
PARAMETER sSubAlm
sDesAlm = []
*EXTERNAL ARRAY GaSubAlm
*IF ALEN(GaSubAlm,1)>0
*   FOR k = 1 TO ALEN(GaSubAlm,1)
*       IF GaSubAlm(K,1)=sSubAlm
*          sDesAlm = GaSubAlm(K,1)+[ ]+GaSubAlm(K,2)
*          EXIT
*       ENDIF
*   ENDFOR
*ENDIF
***AMAA 28-12-06
PCALIAS = ALIAS()
IF !USED('ALMA')
	LOCAL LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
	LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
	LoDatAdm.abrirtabla('ABRIR','almtalma','alma','alma01','')
	RELEASE LoDatAdm
ENDIF
=SEEK(sSubAlm,"ALMA")
sDesAlm=ALMA.DesSub
SELECT (PCALIAS) 
**
RETURN sDesAlm
function hola
wait window 'Hola chocherita' nowait


FUNCTION ChrToArray
*!*	Convertir una cadena en una matriz según sus separadores.
LPARAMETERS  cCadena , cDelimitador , aMatrizSalida
LOCAL N , aArray
DIMENSION aArray[1]
STORE SPACE(0) TO aArray
EXTERNAL ARRAY aMatrizSalida

cDelimitador  	= IIF( TYPE("cDelimitador")=="L" , "," , cDelimitador )
cCadena 		= IIF( TYPE("cCadena")=="L", "", cCadena )
cCadena 		= cCadena + cDelimitador

DO WHILE .T.
	IF EMPTY( cCadena )
		EXIT
	ENDIF
	N = AT( cDelimitador, cCadena )
	IF N=1
		nLen = ALEN( aArray )
		DIMENSION aArray[nLen+1]
		aArray[nLen+1] = ""
	ELSE
		nLen = ALEN( aArray )
		DIMENSION aArray[nLen+1]
		aArray[nLen+1] = ALLTRIM(UPPER(LEFT( cCadena, N - 1 )))
	ENDIF
	cCadena = ALLTRIM(RIGHT( cCadena, LEN(cCadena) - N ))
ENDDO
IF ALEN(aArray)>1
	=ADEL(aArray,1)
	DIMENSION aArray( ALEN(aArray)-1 )
	DIMENSION aMatrizSalida( ALEN(aArray) )
	=ACOPY( aArray, aMatrizSalida )
ENDIF
RETURN

****************
PROCEDURE valruc
****************
Parameters lcNroRuc
  *
  IF LEN(ALLTRIM(lcNroRuc)) <> 11 THEN
    RETURN .F.
  ENDIF
  *
  LOCAL aArrayRuc
  DIMENSION aArrayRuc(3,11)
  *
  FOR i = 1 TO 11
    aArrayRuc(1,i)=VAL(SUBS(lcNroRuc,i,1))
  ENDFOR
  *
  aArrayRuc(2,1)=5
  aArrayRuc(2,2)=4
  aArrayRuc(2,3)=3
  aArrayRuc(2,4)=2
  aArrayRuc(2,5)=7
  aArrayRuc(2,6)=6
  aArrayRuc(2,7)=5
  aArrayRuc(2,8)=4
  aArrayRuc(2,9)=3
  aArrayRuc(2,10)=2
  aArrayRuc(3,11)=0
  *
  FOR i=1 TO 10
    aArrayRuc(3,i)  = aArrayRuc(1,i)  * aArrayRuc(2,i)
    aArrayRuc(3,11) = aArrayRuc(3,11) + aArrayRuc(3,i)
  ENDFOR
  *
  lnResiduo   = MOD(aArrayRuc(3,11),11)
  lnUltDigito = 11 - lnResiduo
  *
  DO CASE
    CASE lnUltDigito = 11 OR lnUltDigito=1
      lnUltDigito = 1
    CASE lnUltDigito = 10 OR lnUltDigito=0
      lnUltDigito = 0
  ENDCASE
  *
  IF lnUltDigito = aArrayRuc(1,11) THEN
    RETURN .T.
  ELSE
    RETURN .F.
  ENDIF
ENDPROC   

************************************************************************
*  Store Cursor to object.
*  In fact, Creates Parser object and tells him to
*  suck in cursor and then returns it all back to caller.
*  Accepts 3 parameters for source alias , 'for' and 'while' conditions
************************************************************************
function cur2obj
    lparameters cAlias,cForCondition,cWhileCondition
    local oTable,sv_alias

    sv_alias=alias()
    select (cAlias)

    oTable=createobject('table_parser')
    oTable.cur2obj(cAlias,cForCondition,cWhileCondition)

    select (sv_alias)
    return oTable



******************************
*  Restore Cursor from object
******************************
function obj2cur
    lparameters oTable,cAlias

    create cursor &cAlias from array oTable.arrstru

    if oTable.NumberOfRecords = 0
        return
    endif

    append from array oTable.arrdata

    if oTable.MemoCount=0
        go top
        return
    endif

    local nMemoRec, cMemoName, cMemoContent , i , j
    j=0
    for i=1 to oTable.FieldsCount
        if oTable.arrstru(i,2) = 'M'
            j = j + 1
            cMemoName = cAlias+'.' + oTable.arrstru(i,1)
            replace &cMemoName with oTable.arrmemo(recno(),j) all
        endif
    next

    go top
    return

***********************************
* Custom Object used as
* cursor carrier
***********************************
define class table_parser as custom
    OriginalAlias=''
    NumberOfRecords=0
    MemoCount=0
    FieldsCount=0

    declare arrstru(1)
    declare arrdata(1)
    declare arrmemo(1)


    procedure cur2obj
        lparameters cAlias,cForCondition,cWhileCondition,cIndice,cLlave
        local lcArrStru,sv_rec

        select (cAlias)
        go top

        this.OriginalAlias = cAlias
        declare lcArrStru(1)

        =afields(lcArrStru)
        acopy(lcArrStru,this.arrstru)

        this.MemoCount = this.count_memo_fields()

        if eof()
            this.NumberOfRecords=0
            return
        endif

        if type('cForCondition') <> 'C'
            cForCondition = ' .t. '
        endif

        if type('cWhileCondition') <> 'C'
            cWhileCondition = ' .t. '
        ENDIF
        
        if vartype(cOrder) <> 'C'
            cIndice = ''
        endif

        if vartype(cLlave) <> 'C'
            cLlave = ''
        endif

        create cursor tmpCursor  from array this.arrstru
        select (cAlias)
        IF !EMPTY(cIndice)
        	SET ORDER TO (cIndice)
        ENDIF
        IF !EMPTY(cllave) AND VARTYPE(cLlave)='C'
        	SEEK cLlave
        ENDIF
        scan  for &cForCondition while &cWhileCondition
            scatter memvar memo
            insert into tmpCursor from memvar
        endscan

        select tmpCursor
        go top

        if eof()
            use
            return
        endif
        this.NumberOfRecords=reccount()

        if this.MemoCount > 0

            local i,j,cMemoName,nMemoRec
            declare this.arrmemo( this.NumberOfRecords , this.MemoCount )

            scan
                nMemoRec=recno()
                j=0
                for i=1 to alen(lcArrStru,1)
                    if lcArrStru(i,2) = 'M'
                        cMemoName = 'tmpCursor.' + lcArrStru(i,1)
                        j = j + 1
                        this.arrmemo(nMemoRec,j)= &cMemoName
                    endif
                next
            endscan

        endif

        declare this.arrdata(this.NumberOfRecords, this.FieldsCount )
        copy to array this.arrdata
        use



    procedure count_memo_fields
        this.FieldsCount=alen(this.arrstru,1)

        local i,j
        j=0
        for i=1 to alen(this.arrstru,1)
            if this.arrstru(i,2) = 'M'
                j=j+1
            endif
        next
        return j




enddefine
********************************
******************
FUNCTION VerifyTAG
******************
PARAMETERS _PcTabla,_PcTag
LnAreaAct=SELECT()
SELECT (_PcTabla)
FOR nCount = 1 TO TAGCOUNT()
   IF !EMPTY(TAG(nCount))  && Checks for tags in the index
   	 IF TAG(nCount)==UPPER(_PcTag)
   	 	SELECT (LnAreaAct)
   	 	RETURN .T.
   	 ENDIF  
     *KEY(nCount)  && Display index expression
   ELSE
      EXIT  && Exit the loop when no more tags are found
   ENDIF
ENDFOR
SELECT (LnAreaAct)
RETURN .f.
******************
FUNCTION verifyVar
******************
PARAMETERS _cVar,_cType,cTipVar,_cAliasTabla,_cRutaDBC
IF VARTYPE(cTipVar)<>'C'
	cTipVar=''
ENDIF
IF VARTYPE(_cAliasTabla)<>'C'
	_cAliasTabla =  ''
ENDIF
 IF VARTYPE(_cRutaDBC)<>'C'
	_cRutaDBC =  ''
ENDIF
PRIVATE LsCurDbc AS Character 
#include CONST.H
DO CASE 
	CASE EMPTY(cTipVar)
		IF VARTYPE(&_cVar)<>UPPER(_cType)
			=MESSAGEBOX('Debe definir la operación contable que afectaran las transacciones a realizar.'+CRLF + ;
			'Crear la variable '+UPPER(_cVar)+' y asociarla a la operación contable respectiva.'+CRLF + ;
			'Ir a la opcion de -Configuraciones Generales- en el menu de configuración del modulo contable.' ,0+64,'Aviso importante !!!')
			
			RETURN .F.
		ELSE
			RETURN .T.	
		ENDIF
	CASE cTipVar='TABLA'
		IF VARTYPE(&_cVar)<>UPPER(_cType)
			=MESSAGEBOX('Crear la variable '+UPPER(_cVar)+' y asociarla a un valor que se utilizara en [Detalle de tablas del Sistema], segun los siguientes pasos:'+CRLF + ;
			'1. Buscar en el menu de [CONFIGURACION] la opción [Configuración de Variables Generales] y crear la variable '+ UPPER(_cVar) + ' y asignarle un valor.'+CRLF + ;
			'2. Buscar en el menu [Tablas Generales] la opción [Tablas del sistema] y crear un registro con el valor asignado a la variable '+UPPER(_cVar)+ '.' +CRLF + ;
			'3. Ir a la opción [Detalle de tablas del sistema] y crear los registros que le corresponden como detalle al codigo  creado en el paso anterior.' +CRLF + ;
			'4. Regresar nuevamente a esta opción del sistema para que el formulario y/o programa hagan uso de la configuracion que acabamos de hacer.' ;
			  ,0+64,'Aviso importante !!!')
			RETURN .F.
		ELSE
			RETURN .T.	
		ENDIF
	CASE cTipVar='CAMPO'
		IF EMPTY(_cAliasTabla)
			RETURN .F.
		ELSE
			AFIELDS(aTblCampos,_cAliasTabla)
			RETURN IIF(ASCAN(aTblCampos,UPPER(ALLTRIM( _cVar)))>0,.T.,.F.)
		ENDIF
	CASE cTipVar='INDBC'	 AND _cType='TABLE'
		Private xLlReturn AS Boolean
		LsCurDBC = SET("Database") 
	    _cRutaDBC = IIF(EMPTY(_cRutaDBC),ADDBS(GoEntorno.tsPathadm),ADDBS(_cRutaDBC))
		IF !FILE(_cRutaDBC+_cAliasTabla+'.dbc')
			RETURN .F.
		ENDIF
		IF !DBUSED(_cRutaDBC+_cAliasTabla)
			OPEN DATABASE (_cRutaDBC+_cAliasTabla)
		ENDIF
		SET DATABASE TO (_cRutaDBC+_cAliasTabla)
		IF INDBC(_cVar,_cType)
			xLlReturn = .T.
		ELSE
			xLlReturn = .F.	
		ENDIF
		IF !EMPTY(LsCurDBC)
			SET DATABASE TO (LsCurDbc)
		ENDIF
		RETURN xLlReturn
	CASE cTipVar='INDBC'	AND _cType='VIEW'
		Private xLlReturn AS Boolean
		LsCurDBC = SET("Database") 
		_cRutaDBC = IIF(EMPTY(_cRutaDBC),ADDBS(GoEntorno.tsPathadm),ADDBS(_cRutaDBC))
		IF !FILE(_cRutaDBC+_cAliasTabla+'.dbc')
			RETURN .F.
		ENDIF
		IF !DBUSED(_cRutaDBC+_cAliasTabla)
			OPEN DATABASE (_cRutaDBC+_cAliasTabla)
		ENDIF
		SET DATABASE TO (_cRutaDBC+_cAliasTabla)
		IF INDBC(_cVar,_cType)
			xLlReturn = .T.
		ELSE
			xLlReturn = .F.	
		ENDIF
		IF !EMPTY(LsCurDBC)
			SET DATABASE TO (LsCurDbc)
		ENDIF
		RETURN xLlReturn
	
ENDCASE 

******************
PROCEDURE TotHoras
******************
PARAMETER _HoraIni,_HoraFin
DO CASE
   CASE (_HoraFin - _HoraIni)/(60*60)>1
        LfHora    = INT((_HoraFin - _HoraIni)/(60*60))
        LfMinutos = ROUND((_HoraFin - _HoraIni)/(60*60) - INT((_HoraFin - _HoraIni)/(60*60)),0)*60
        _Hora=TRAN(LfHora,'@L ##')+[Hrs ]+TRAN(LfMinutos,'99')+[Min]
        
   CASE (_HoraFin - _HoraIni)/(60*60)<=1
        IF (_HoraFin - _HoraIni)/60>1
           LfMinutos = INT((_HoraFin - _HoraIni)/60)
           LfSegundos= ROUND((_HoraFin - _HoraIni)/60 - INT((_HoraFin - _HoraIni)/60),2)*60
           IF LfSegundos>=60
              LfMinutos = LfMinutos + INT(LfSegundos/60)
              LfSegundos= (LfSegundos - INT(LfSegundos))*60
           ENDIF
           _Hora=TRAN(Lfminutos,'@L ##')+[Min ]+TRAN(Lfsegundos,'99')+[ Seg]
        ELSE
           LfSegundos= ROUND(_HoraFin - _HoraIni,2)
           _Hora=TRAN(Lfsegundos,'99.99')+[ Seg]
        ENDIF
ENDCASE
RETURN _Hora
**************************
FUNCTION Valida_Agente_ret
**************************
PARAMETERS LscodCli,LfImpTot,LnCodMon,LfTpoCmb
IF !USED('CLIE')
	LOCAL LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
	LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
	LoDatAdm.abrirtabla('ABRIR','CCTCLIEN','CLIE','CLIEN04','')
ENDIF
DO CASE 
	CASE CLIE.CodAux==PADR(LsCodCli,LEN(CLIE.CodAux))
		IF  !CLIE.Rete
			LfImpRet = 0
			RETURN .f.
		ENDIF
	OTHER
		IF SEEK(GsclfCli+LsCodCli,'CLIE','CLIEN04') AND CLIE.Rete

		ELSE
			LfImpRet = 0
			RETURN .f.
		ENDIF
ENDCASE
LfMontoMin=ROUND(LfImptot*IIF(LnCodmon=1,1,LfTpoCmb),2)
IF LfMontoMin<m.MinRet
	RETURN .f.
ENDIF
RETURN .T.

**************************
FUNCTION Calcula_Monto_ret
**************************
PARAMETERS LscodCli,LfImpTot,LnCodMon,LfTpoCmb
LfImpRet = 0	
IF !USED('CLIE')
	LOCAL LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
	LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
	LoDatAdm.abrirtabla('ABRIR','CCTCLIEN','CLIE','CLIEN04','')
ENDIF
DO CASE 
	CASE CLIE.CodAux==PADR(LsCodCli,LEN(CLIE.CodAux))
		IF  !CLIE.Rete
			LfImpRet = 0
			RETURN LfImpRet
		ENDIF
	OTHER
		IF SEEK(GsclfCli+LsCodCli,'CLIE','CLIEN04') AND CLIE.Rete

		ELSE
			LfImpRet = 0
			RETURN LfImpRet
		ENDIF
ENDCASE
LfImpRet = ROUND(LfImptot*m.PorRet/100,2)
RETURN LfImpRet

*******************************************
DEFINE CLASS MD5 AS Custom OLEPUBLIC
**********************************************************************************************************************
* Written in VFP by GILLES Patrick (C) IKOONET SARL www.ikoonet.com
* Une implémention en Visual Foxpro de l'algorithme MD5 message digest tel que definis dans le RFC 1321 par R. RIVEST
* de la sociét?RSA DATA SECURTY & MIT Laboratory for Computer Science
* A VFP implementation of the RSA Data Security, Inc. MD5 Message Digest Algorithm, as defined in RFC 1321.
**********************************************************************************************************************
* Usage (sample)
* SET PROCEDURE TO mdigest5
* MD5=CREATEOBJECT("MD5")
* MD5.tohash="abc"
* ? MD5.compute()
*******************************
tohash=""
DIMENSION SinusArray(64)
#DEFINE MAX_UINT 4294967296
#DEFINE NUMBEROFBIT 8 && UNICODE 16 (unicode not tested)


PROCEDURE init
  LOCAL I
  FOR I = 1 TO 64
    this.SinusArray(I)=TRANSFORM(MAX_UINT*ABS(SIN(I)),"@0")
    this.SinusArray(I)=BITAND(EVALUATE(this.SinusArray(I)),0xFFFFFFFF) &&CAST
  ENDFOR
RETURN .T.

PROCEDURE bourre
  LOCAL NBR_BIT_BOURRE, BOURRAGE
  Bourrage = CHR(128)+REPLICATE(CHR(0),63)
  NBR_BIT_BOURRE=(448-(LEN(THIS.TOHASH)*NUMBEROFBIT)%512)/NUMBEROFBIT
  IF (LEN(THIS.TOHASH)*NUMBEROFBIT)%512>=448
    NBR_BIT_BOURRE=(448+((512-LEN(THIS.TOHASH)*NUMBEROFBIT)%512))/NUMBEROFBIT
  ENDIF

RETURN LEFT(bourrage,NBR_BIT_BOURRE)


PROCEDURE acompleter
  LOCAL retour,decalage
  decalage=TRANSFORM(LEN(this.tohash)* NUMBEROFBIT,"@0")
  retour=""
  retour=retour+CHR(EVALUATE("0x"+SUBSTR(decalage,9,2)))
  retour=retour+CHR(EVALUATE("0x"+SUBSTR(decalage,7,2)))
  retour=retour+CHR(EVALUATE("0x"+SUBSTR(decalage,5,2)))
  retour=retour+CHR(EVALUATE("0x"+SUBSTR(decalage,3,2)))
  retour=retour+REPLICATE(CHR(0),4)
RETURN RETOUR


PROCEDURE MD5_F
LPARAMETERS x,y,z
RETURN BITOR(BITAND(X,Y),BITAND(BITNOT(X),Z))

PROCEDURE MD5_G
LPARAMETERS x,y,z
RETURN BITOR(BITAND(X,Z),BITAND(Y,BITNOT(Z)))

PROCEDURE MD5_H
LPARAMETERS x,y,z
RETURN BITXOR(X,Y,Z)

PROCEDURE MD5_I
LPARAMETERS x,y,z
RETURN BITXOR(Y,BITOR(X,BITNOT(Z)))

PROCEDURE ROTATE_LEFT
LPARAMETERS pivot, npivot
RETURN BITOR(BITLSHIFT(pivot,npivot),BITRSHIFT(pivot,32-Npivot))

procedure ronde1
LPARAMETERS PA,PB,PC,PD,PE,PF,PG
RETURN PB+this.ROTATE_LEFT(PA+this.MD5_F(PB,PC,PD)+PE+PG,PF)

procedure ronde2
LPARAMETERS PA,PB,PC,PD,PE,PF,PG
RETURN PB+this.ROTATE_LEFT(PA+this.MD5_G(PB,PC,PD)+PE+PG,PF)

PROCEDURE ronde3
LPARAMETERS PA,PB,PC,PD,PE,PF,PG
RETURN PB+this.ROTATE_LEFT(PA+this.MD5_H(PB,PC,PD)+PE+PG,PF)

PROCEDURE ronde4
LPARAMETERS PA,PB,PC,PD,PE,PF,PG
RETURN PB+this.ROTATE_LEFT(PA+this.MD5_I(PB,PC,PD)+PE+PG,PF)

PROCEDURE compute
  LOCAL tocompute,CPT_I,CPT_J,CPT_L,TMP_STRING,AA,BB,CC,DD,a,b,c,d,aa,bb,cc,dd
  A=BITAND(0x67452301,0xFFFFFFFF)
  B=BITAND(0xEFCDAB89,0xFFFFFFFF)
  C=BITAND(0x98BADCFE,0xFFFFFFFF)
  D=BITAND(0x10325476,0xFFFFFFFF)

  DIMENSION T_X(16)
  tocompute=this.tohash+this.bourre()+this.acompleter()
  lentocompute=LEN(tocompute)/64
  OldA=A
  OldB=B
  OldC=C
  OldD=D
  FOR CPT_I=0 TO lentocompute-1
    FOR CPT_J=0 TO 15
      T_X(CPT_J+1)=""
      T_X(CPT_J+1)=T_X(CPT_J+1)+RIGHT(TRANSFORM(ASC(SUBSTR(tocompute,(CPT_I*64)+(CPT_J*4)+4,1)),"@0"),2)
      T_X(CPT_J+1)=T_X(CPT_J+1)+RIGHT(TRANSFORM(ASC(SUBSTR(tocompute,(CPT_I*64)+(CPT_J*4)+3,1)),"@0"),2)
      T_X(CPT_J+1)=T_X(CPT_J+1)+RIGHT(TRANSFORM(ASC(SUBSTR(tocompute,(CPT_I*64)+(CPT_J*4)+2,1)),"@0"),2)
      T_X(CPT_J+1)=T_X(CPT_J+1)+RIGHT(TRANSFORM(ASC(SUBSTR(tocompute,(CPT_I*64)+(CPT_J*4)+1,1)),"@0"),2)

      T_X(CPT_J+1)=BITAND(EVALUATE("0x"+T_X(CPT_J+1)),0xFFFFFFFF) && CAST
      *? TRANSFORM(T_X(CPT_J+1),"@0")
      *?
    ENDFOR

    OldA=A
    OldB=B
    OldC=C
    OldD=D

    && Ronde1
    a=this.ronde1(a,b,c,d,T_X( 1), 7,this.sinusarray( 1))
    d=this.ronde1(d,a,b,c,T_X( 2),12,this.sinusarray( 2))
    c=this.ronde1(c,d,a,b,T_X( 3),17,this.sinusarray( 3))
    b=this.ronde1(b,c,d,a,T_X( 4),22,this.sinusarray( 4))

    a=this.ronde1(a,b,c,d,T_X( 5), 7,this.sinusarray( 5))
    d=this.ronde1(d,a,b,c,T_X( 6),12,this.sinusarray( 6))
    c=this.ronde1(c,d,a,b,T_X( 7),17,this.sinusarray( 7))
    b=this.ronde1(b,c,d,a,T_X( 8),22,this.sinusarray( 8))

    a=this.ronde1(a,b,c,d,T_X( 9), 7,this.sinusarray( 9))
    d=this.ronde1(d,a,b,c,T_X(10),12,this.sinusarray(10))
    c=this.ronde1(c,d,a,b,T_X(11),17,this.sinusarray(11))
    b=this.ronde1(b,c,d,a,T_X(12),22,this.sinusarray(12))

    a=this.ronde1(a,b,c,d,T_X(13), 7,this.sinusarray(13))
    d=this.ronde1(d,a,b,c,T_X(14),12,this.sinusarray(14))
    c=this.ronde1(c,d,a,b,T_X(15),17,this.sinusarray(15))
    b=this.ronde1(b,c,d,a,T_X(16),22,this.sinusarray(16))
    && ronde 2
    a=this.ronde2(a,b,c,d,T_X( 2), 5,this.sinusarray(17))
    d=this.ronde2(d,a,b,c,T_X( 7), 9,this.sinusarray(18))
    c=this.ronde2(c,d,a,b,T_X(12),14,this.sinusarray(19))
    b=this.ronde2(b,c,d,a,T_X( 1),20,this.sinusarray(20))

    a=this.ronde2(a,b,c,d,T_X( 6), 5,this.sinusarray(21))
    d=this.ronde2(d,a,b,c,T_X(11), 9,this.sinusarray(22))
    c=this.ronde2(c,d,a,b,T_X(16),14,this.sinusarray(23))
    b=this.ronde2(b,c,d,a,T_X( 5),20,this.sinusarray(24))

    a=this.ronde2(a,b,c,d,T_X(10), 5,this.sinusarray(25))
    d=this.ronde2(d,a,b,c,T_X(15), 9,this.sinusarray(26))
    c=this.ronde2(c,d,a,b,T_X( 4),14,this.sinusarray(27))
    b=this.ronde2(b,c,d,a,T_X( 9),20,this.sinusarray(28))

    a=this.ronde2(a,b,c,d,T_X(14), 5,this.sinusarray(29))
    d=this.ronde2(d,a,b,c,T_X( 3), 9,this.sinusarray(30))
    c=this.ronde2(c,d,a,b,T_X( 8),14,this.sinusarray(31))
    b=this.ronde2(b,c,d,a,T_X(13),20,this.sinusarray(32))

    && ronde 3
    a=this.ronde3(a,b,c,d,T_X( 6), 4,this.sinusarray(33))
    d=this.ronde3(d,a,b,c,T_X( 9),11,this.sinusarray(34))
    c=this.ronde3(c,d,a,b,T_X(12),16,this.sinusarray(35))
    b=this.ronde3(b,c,d,a,T_X(15),23,this.sinusarray(36))

    a=this.ronde3(a,b,c,d,T_X( 2), 4,this.sinusarray(37))
    d=this.ronde3(d,a,b,c,T_X( 5),11,this.sinusarray(38))
    c=this.ronde3(c,d,a,b,T_X( 8),16,this.sinusarray(39))
    b=this.ronde3(b,c,d,a,T_X(11),23,this.sinusarray(40))

    a=this.ronde3(a,b,c,d,T_X(14), 4,this.sinusarray(41))
    d=this.ronde3(d,a,b,c,T_X( 1),11,this.sinusarray(42))
    c=this.ronde3(c,d,a,b,T_X( 4),16,this.sinusarray(43))
    b=this.ronde3(b,c,d,a,T_X( 7),23,this.sinusarray(44))

    a=this.ronde3(a,b,c,d,T_X(10), 4,this.sinusarray(45))
    d=this.ronde3(d,a,b,c,T_X(13),11,this.sinusarray(46))
    c=this.ronde3(c,d,a,b,T_X(16),16,this.sinusarray(47))
    b=this.ronde3(b,c,d,a,T_X( 3),23,this.sinusarray(48))

    && ronde 4
    a=this.ronde4(a,b,c,d,T_X( 1), 6,this.sinusarray(49))
    d=this.ronde4(d,a,b,c,T_X( 8),10,this.sinusarray(50))
    c=this.ronde4(c,d,a,b,T_X(15),15,this.sinusarray(51))
    b=this.ronde4(b,c,d,a,T_X( 6),21,this.sinusarray(52))

    a=this.ronde4(a,b,c,d,T_X(13), 6,this.sinusarray(53))
    d=this.ronde4(d,a,b,c,T_X( 4),10,this.sinusarray(54))
    c=this.ronde4(c,d,a,b,T_X(11),15,this.sinusarray(55))
    b=this.ronde4(b,c,d,a,T_X( 2),21,this.sinusarray(56))

    a=this.ronde4(a,b,c,d,T_X( 9), 6,this.sinusarray(57))
    d=this.ronde4(d,a,b,c,T_X(16),10,this.sinusarray(58))
    c=this.ronde4(c,d,a,b,T_X( 7),15,this.sinusarray(59))
    b=this.ronde4(b,c,d,a,T_X(14),21,this.sinusarray(60))

    a=this.ronde4(a,b,c,d,T_X( 5), 6,this.sinusarray(61))
    d=this.ronde4(d,a,b,c,T_X(12),10,this.sinusarray(62))
    c=this.ronde4(c,d,a,b,T_X( 3),15,this.sinusarray(63))
    b=this.ronde4(b,c,d,a,T_X(10),21,this.sinusarray(64))

    a=a+olda
    b=b+oldb
    c=c+oldC
    d=d+oldd
  ENDFOR
  a=TRANSFORM(BITAND(a,0xFFFFFFFF),"@0") && cast
  b=TRANSFORM(BITAND(b,0xFFFFFFFF),"@0") && cast
  c=TRANSFORM(BITAND(c,0xFFFFFFFF),"@0") && cast
  d=TRANSFORM(BITAND(d,0xFFFFFFFF),"@0") && cast
  a=SUBSTR(a,9,2)+SUBSTR(a,7,2)+SUBSTR(a,5,2)+SUBSTR(a,3,2)
  b=SUBSTR(b,9,2)+SUBSTR(b,7,2)+SUBSTR(b,5,2)+SUBSTR(b,3,2)
  c=SUBSTR(c,9,2)+SUBSTR(c,7,2)+SUBSTR(c,5,2)+SUBSTR(c,3,2)
  d=SUBSTR(d,9,2)+SUBSTR(d,7,2)+SUBSTR(d,5,2)+SUBSTR(d,3,2)

RETURN a+b+c+d

PROCEDURE testsuite
&& return true if all the reference value are true
  LOCAL test
  test=.T.
  this.tohash=""
  IF LOWER(this.compute())#"d41d8cd98f00b204e9800998ecf8427e"
    RETURN this.tohash
  ENDIF
  this.tohash="a"
  IF LOWER(this.compute())#"0cc175b9c0f1b6a831c399e269772661"
    RETURN this.tohash
  ENDIF
  this.tohash="abc"
  IF LOWER(this.compute())#"900150983cd24fb0d6963f7d28e17f72"
    RETURN this.tohash
  ENDIF
  this.tohash="message digest"
  IF LOWER(this.compute())#"f96b697d7cb7938d525a2f31aaf161d0"
    RETURN this.tohash
  ENDIF
  this.tohash="abcdefghijklmnopqrstuvwxyz"
  IF LOWER(this.compute())#"c3fcd3d76192e4007dfb496cca67e13b"
    RETURN this.tohash
  ENDIF
  this.tohash="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
  IF LOWER(this.compute())#"d174ab98d277d9f5a5611c2c9f419d9f"
    RETURN this.tohash
  ENDIF
  this.tohash="12345678901234567890123456789012345678901234567890123456789012345678901234567890"
  IF LOWER(this.compute())#"57edf4a22be3c955ac49da2e2107b67a"
    RETURN this.tohash
  ENDIF
  RETURN test

ENDDEFINE
*****************************AMAA07-12-06 
PROCEDURE ActualizaStockSeries
*****************************
*Debe estar aboerta la tabla AlmdSeri con alias dser
PARAMETERS cCodMat, cSeries,cTipMov,nNroReg

IF VARTYPE(cSeries)<>'C'
	cSeries = ''
ENDIF
IF EMPTY(cSeries)
	return
ENDIF


LOCAL LnSelectAct,LsOrderSeri,LsCierraSeri
STORE '' TO LnSelectAct,LsOrderSeri
LlCierraSeri = .F.
LnSelectAct=SELECT()
*** Comprobamos que esten abiertas los alias / tablas que vamos a actualizar
IF !USED('DSER')
	IF !VARTYPE(Lodatadm)=='O'
		LOCAL LoDatAdm AS DataAdmin OF k:\aplvfp\classgen\vcxs\DOSVR.vcx
		LoDatAdm=CREATEOBJECT('DOSVR.DataAdmin')
	ENDIF
	LsCierraSeri=LoDatAdm.abrirtabla('ABRIR','ALMDSERI',"DSER",'DSER05','')
	RELEASE LoDatAdm
ELSE
	LsOrderSeri=ORDER('DSER')
ENDIF

DIMENSION aSeries[1]
LcDelimitador=''
LnDelimitador=AT(',',cSeries)
IF LnDelimitador>0
	LcDelimitador=','
ELSE	
	IF AT(';',cSeries)>0
		LcDelimitador = ';'
	ENDIF
ENDIF
IF !EMPTY(LcDelimitador) 
	
	IF !EMPTY( cSeries )
		ChrToArray( cSeries, LcDelimitador , @aSeries )
	ENDIF
ELSE && es solo una sola serie
	aSeries[1] = PADR(cseries,LEN(DSER.Serie))
ENDIF

SELECT dser
SET ORDER TO DSERI05   && CODMAT+SERIE 
SEEK cCodMat+aSeries(1)
i=1
FOR i=1 TO ALEN(aseries)
	IF nNroReg<=0
		IF cTipmov='I' 
			UPDATE dser SET STKACT = 1 WHERE CODMAT=cCodMat AND SERIE=aSeries(i)	
		ELSE
			UPDATE dser SET STKACT = 0 WHERE CODMAT=cCodMat AND SERIE=aSeries(i)	
		ENDIF
	ELSE	&& Extornamos cuando es anular
		IF cTipmov='I' 
			UPDATE dser SET STKACT = 0 WHERE CODMAT=cCodMat AND SERIE=aSeries(i)	
		ELSE
			UPDATE dser SET STKACT = 1 WHERE CODMAT=cCodMat AND SERIE=aSeries(i)	
		ENDIF
	ENDIF
ENDFOR 

SELECT 	(LnSelectAct)
IF LlCierraSeri
	lodatadm.closetable('DSER')
ENDIF
RELEASE LoDatAdm
RETURN
*******************************AMAA07-12-06 
FUNCTION cValoresFiltro_assign
*******************************
LPARAMETERS tcValoresFiltro,aCampos

tcValoresFiltro		= IIF( VARTYPE(tcValoresFiltro)<>"C" , "" , ALLTRIM(tcValoresFiltro) )

*DIMENSION aCampos[1]
IF !EMPTY( tcValoresFiltro )
	ChrToArray( tcValoresFiltro, ";" , @aCampos )
ENDIF
RETURN &&aCampos
******************************AMAA07-12-06 
FUNCTION CHRTOARRAY
******************************
*!*	Convertir una cadena en una matriz según sus separadores.
LPARAMETERS  cCadena , cDelimitador , aMatrizSalida
LOCAL N , aArray
DIMENSION aArray[1]
STORE SPACE(0) TO aArray
EXTERNAL ARRAY aMatrizSalida

cDelimitador  	= IIF( TYPE("cDelimitador")=="L" , "," , cDelimitador )
cCadena 		= IIF( TYPE("cCadena")=="L", "", cCadena )
cCadena 		= cCadena + cDelimitador

DO WHILE .T.
	IF EMPTY( cCadena )
		EXIT
	ENDIF
	N = AT( cDelimitador, cCadena )
	IF N=1
		nLen = ALEN( aArray )
		DIMENSION aArray[nLen+1]
		aArray[nLen+1] = ""
	ELSE
		nLen = ALEN( aArray )
		DIMENSION aArray[nLen+1]
		aArray[nLen+1] = ALLTRIM(UPPER(LEFT( cCadena, N - 1 )))
	ENDIF
	cCadena = ALLTRIM(RIGHT( cCadena, LEN(cCadena) - N ))
ENDDO
IF ALEN(aArray)>1
	=ADEL(aArray,1)
	DIMENSION aArray( ALEN(aArray)-1 )
	DIMENSION aMatrizSalida( ALEN(aArray) )
	=ACOPY( aArray, aMatrizSalida )
ENDIF
RETURN

********************************************************
** FUNCIONES PARA EL MANEJO DE CODIGO DE BARRAS
********************************************************
*------------------------------------------------------
* PROG. : CodBar.prg
* FECHA : 2000/04/25
* U.ACT : 2004/09/15
* AUTOR : Luis María Guayán
* EMAIL : luismaria@portalfox.com
*------------------------------------------------------
* Estas funciones convierten una cadena de caracteres
* a los siguientes formatos de Códigos de Barras:
*   Codigo 39..........: _StrTo39()
*   Codigo 128-A.......: _StrTo128A()
*   Codigo 128-B.......: _StrTo128B()
*   Codigo 128-C.......: _StrTo128C()
*   Codigo EAN-13......: _StrToEan13()
*   Codigo EAN-8.......: _StrToEan8()
*   Interleaved 2 of 5.: _StrToI2of5()
*
* Las fuentes True Type utilizadas son:
*   Codigo 39..........: "PF Barcode 39"
*   Codigo 128-A.......: "PF Barcode 128"
*   Codigo 128-B.......: "PF Barcode 128"
*   Codigo 128-C.......: "PF Barcode 128"
*   Codigo EAN-13......: "PF EAN P36" ó "PF EAN P72"
*   Codigo EAN-8.......: "PF EAN P36" ó "PF EAN P72"
*   Interleaved 2 of 5.: "PF Interleaved 2 of 5", 
*                        "PF Interleaved 2 of 5 Wide", 
*                        "PF Interleavev 2 of 5 Text" 
*
*------------------------------------------------------
* FUNCTION _StrTo39(tcString) * CODIGO 39
*------------------------------------------------------
* Convierte un string para ser impreso con
* fuente True Type "PF Barcode 39"
* USO: _StrTo39('Codigo 39')
* RETORNA: Caracter
*------------------------------------------------------
FUNCTION _StrTo39(tcString)
  LOCAL lcRet
  lcRet = '*' + tcString + '*'
  RETURN lcRet
ENDFUNC

*------------------------------------------------------
* FUNCTION _StrTo128A(tcString) * CODIGO 128A
*------------------------------------------------------
* Convierte un string para ser impreso con
* fuente True Type "PF Barcode 128"
* Caracteres numéricos y alfabeticos (solo mayúsculas)
* Si un caracter es no válido lo remplaza por espacio
* USO: _StrTo128A('CODIGO 128 A')
* RETORNA: Caracter
*------------------------------------------------------
FUNCTION _StrTo128A(tcString)
  LOCAL lcStart, lcStop, lcRet, lcCheck, ;
    lnLong, lnI, lnCheckSum, lnAsc
  lcStart = CHR(103 + 32)
  lcStop = CHR(106 + 32)
  lnCheckSum = ASC(lcStart) - 32
  lcRet = tcString
  lnLong = LEN(lcRet)
  FOR lnI = 1 TO lnLong
    lnAsc = ASC(SUBS(lcRet,lnI,1)) - 32
    IF NOT BETWEEN(lnAsc,0,64)
      lcRet = STUFF(lcRet,lnI,1,CHR(32))
      lnAsc = ASC(SUBS(lcRet,lnI,1)) - 32
    ENDIF
    lnCheckSum = lnCheckSum + (lnAsc * lnI)
  ENDFOR
  lcCheck = CHR(MOD(lnCheckSum,103) + 32)
  lcRet = lcStart + lcRet + lcCheck + lcStop
  *--- Esto es para cambiar los espacios y caracteres invalidos
  lcRet = STRTRAN(lcRet,CHR(32),CHR(232))
  lcRet = STRTRAN(lcRet,CHR(127),CHR(192))
  lcRet = STRTRAN(lcRet,CHR(128),CHR(193))
  RETURN lcRet
ENDFUNC

*------------------------------------------------------
* FUNCTION _StrTo128B(tcString) * CODIGO 128B
*------------------------------------------------------
* Convierte un string para ser impreso con
* fuente True Type "PF Barcode 128"
* Caracteres numéricos y alfabeticos (mayúsculas y minúsculas)
* Si un caracter es no válido lo remplaza por espacio
* USO: _StrTo128B('Codigo 128 B')
* RETORNA: Caracter
*------------------------------------------------------
FUNCTION _StrTo128B(tcString)
  LOCAL lcStart, lcStop, lcRet, lcCheck, ;
    lnLong, lnI, lnCheckSum, lnAsc
  lcStart = CHR(104 + 32)
  lcStop = CHR(106 + 32)
  lnCheckSum = ASC(lcStart) - 32
  lcRet = tcString
  lnLong = LEN(lcRet)
  FOR lnI = 1 TO lnLong
    lnAsc = ASC(SUBS(lcRet,lnI,1)) - 32
    IF NOT BETWEEN(lnAsc,0,99)
      lcRet = STUFF(lcRet,lnI,1,CHR(32))
      lnAsc = ASC(SUBS(lcRet,lnI,1)) - 32
    ENDIF
    lnCheckSum = lnCheckSum + (lnAsc * lnI)
  ENDFOR
  lcCheck = CHR(MOD(lnCheckSum,103) + 32)
  lcRet = lcStart + lcRet + lcCheck + lcStop
  *--- Esto es para cambiar los espacios y caracteres invalidos
  lcRet = STRTRAN(lcRet,CHR(32),CHR(232))
  lcRet = STRTRAN(lcRet,CHR(127),CHR(192))
  lcRet = STRTRAN(lcRet,CHR(128),CHR(193))
  RETURN lcRet
ENDFUNC

*------------------------------------------------------
* FUNCTION _StrTo128C(tcString) * CODIGO 128C
*------------------------------------------------------
* Convierte un string para ser impreso con
* fuente True Type "PF Barcode 128"
* Solo caracteres numéricos
* USO: _StrTo128C('1234567890')
* RETORNA: Caracter
*------------------------------------------------------
FUNCTION _StrTo128C(tcString)
  LOCAL lcStart, lcStop, lcRet, lcCheck, lcCar, ;
    lnLong, lnI, lnCheckSum, lnAsc
  lcStart = CHR(105 + 32)
  lcStop = CHR(106 + 32)
  lnCheckSum = ASC(lcStart) - 32
  lcRet = ALLTRIM(tcString)
  lnLong = LEN(lcRet)
  *--- La longitud debe ser par
  IF MOD(lnLong,2) # 0
    lcRet = '0' + lcRet
    lnLong = LEN(lcRet)
  ENDIF
  *--- Convierto los pares a caracteres
  lcCar = ''
  FOR lnI = 1 TO lnLong STEP 2
    lcCar = lcCar + CHR(VAL(SUBS(lcRet,lnI,2)) + 32)
  ENDFOR
  lcRet = lcCar
  lnLong = LEN(lcRet)
  FOR lnI = 1 TO lnLong
    lnAsc = ASC(SUBS(lcRet,lnI,1)) - 32
    lnCheckSum = lnCheckSum + (lnAsc * lnI)
  ENDFOR
  lcCheck = CHR(MOD(lnCheckSum,103) + 32)
  lcRet = lcStart + lcRet + lcCheck + lcStop
  *--- Esto es para cambiar los espacios y caracteres invalidos
  lcRet = STRTRAN(lcRet,CHR(32),CHR(232))
  lcRet = STRTRAN(lcRet,CHR(127),CHR(192))
  lcRet = STRTRAN(lcRet,CHR(128),CHR(193))
  RETURN lcRet
ENDFUNC

*------------------------------------------------------
* FUNCTION _StrToEan13(tcString,.T.) * CODIGO EAN-13
*------------------------------------------------------
* Convierte un string para ser impreso con
* fuente True Type "PF EAN P36" ó "PF EAN P72"
* PARAMETROS:
*   tcString: Caracter de 12 dígitos (0..9)
*   tlCheckD: .T. Solo genera el dígito de control
*             .F. Genera dígito y caracteres a imprimir
* USO: _StrToEan13('123456789012')
* RETORNA: Caracter
*------------------------------------------------------
FUNCTION _StrToEan13(tcString,tlCheckD)
  LOCAL lcLat, lcMed, lcRet, lcJuego, ;
    lcIni, lcResto, lcCod, lnI, ;
    lnCheckSum, lnAux, laJuego(10), lnPri
  lcRet = ALLTRIM(tcString)
  IF LEN(lcRet) # 12
    *--- Error en parámetro
    *--- debe tener un largo = 12
    RETURN ''
  ENDIF
  *--- Genero dígito de control
  lnCheckSum = 0
  FOR lnI = 1 TO 12
    IF MOD(lnI,2) = 0
      lnCheckSum = lnCheckSum + VAL(SUBS(lcRet,lnI,1)) * 3
    ELSE
      lnCheckSum = lnCheckSum + VAL(SUBS(lcRet,lnI,1)) * 1
    ENDIF
  ENDFOR
  lnAux = MOD(lnCheckSum,10)
  lcRet = lcRet + ALLTRIM(STR(IIF(lnAux = 0,0,10-lnAux)))
  IF tlCheckD
    *--- Si solo genero dígito de control
    RETURN lcRet
  ENDIF
  *--- Para imprimir con fuente True Type PF_EAN_PXX
  *--- 1er. dígito (lnPri)
  lnPri = VAL(LEFT(lcRet,1))
  *--- Tabla de Juegos de Caracteres
  *--- según 'lnPri' (¡NO CAMBIAR!)
  laJuego(1) = 'AAAAAACCCCCC'   && 0
  laJuego(2) = 'AABABBCCCCCC'   && 1
  laJuego(3) = 'AABBABCCCCCC'   && 2
  laJuego(4) = 'AABBBACCCCCC'   && 3
  laJuego(5) = 'ABAABBCCCCCC'   && 4
  laJuego(6) = 'ABBAABCCCCCC'   && 5
  laJuego(7) = 'ABBBAACCCCCC'   && 6
  laJuego(8) = 'ABABABCCCCCC'   && 7
  laJuego(9) = 'ABABBACCCCCC'   && 8
  laJuego(10) = 'ABBABACCCCCC'   && 9
  *--- Caracter inicial (fuera del código)
  lcIni = CHR(lnPri + 35)
  *--- Caracteres lateral y central
  lcLat = CHR(33)
  lcMed = CHR(45)
  *--- Resto de los caracteres
  lcResto = SUBS(lcRet,2,12)
  FOR lnI = 1 TO 12
    lcJuego = SUBS(laJuego(lnPri + 1),lnI,1)
    DO CASE
      CASE lcJuego = 'A'
        lcResto = STUFF(lcResto,lnI,1,CHR(VAL(SUBS(lcResto,lnI,1)) + 48))
      CASE lcJuego = 'B'
        lcResto = STUFF(lcResto,lnI,1,CHR(VAL(SUBS(lcResto,lnI,1)) + 65))
      CASE lcJuego = 'C'
        lcResto = STUFF(lcResto,lnI,1,CHR(VAL(SUBS(lcResto,lnI,1)) + 97))
    ENDCASE
  ENDFOR
  *--- Armo código
  lcCod = lcIni + lcLat + SUBS(lcResto,1,6) + lcMed + ;
  	SUBS(lcResto,7,6) + lcLat
  RETURN lcCod
ENDFUNC

*------------------------------------------------------
* FUNCTION _StrToEan8(tcString,.T.) * CODIGO EAN-8
*------------------------------------------------------
* Convierte un string para ser impreso con
* fuente True Type "PF EAN P36" ó "PF EAN P72"
* PARAMETROS:
*   tcString: Caracter de 7 dígitos (0..9)
*   tlCheckD: .T. Solo genera el dígito de control
*             .F. Genera dígito y caracteres a imprimir
* USO: _StrToEan8('1234567')
* RETORNA: Caracter
*------------------------------------------------------
FUNCTION _StrToEan8(tcString,tlCheckD)
  LOCAL lcLat, lcMed, lcRet, ;
    lcIni, lcCod, lnI, ;
    lnCheckSum, lnAux
  lcRet = ALLTRIM(tcString)
  IF LEN(lcRet) # 7
    *--- Error en parámetro
    *--- debe tener un largo = 7
    RETURN ''
  ENDIF
  *--- Genero dígito de control
  lnCheckSum = 0
  FOR lnI = 1 TO 7
    IF MOD(lnI,2) = 0
      lnCheckSum = lnCheckSum + VAL(SUBS(lcRet,lnI,1)) * 3
    ELSE
      lnCheckSum = lnCheckSum + VAL(SUBS(lcRet,lnI,1)) * 1
    ENDIF
  ENDFOR
  lnAux = MOD(lnCheckSum,10)
  lcRet = lcRet + ALLTRIM(STR(IIF(lnAux = 0,0,10-lnAux)))
  IF tlCheckD
    *--- Si solo genero dígito de control
    RETURN lcRet
  ENDIF
  *--- Para imprimir con fuente True Type PF_EAN_PXX
  *--- Caracteres lateral y central
  lcLat = CHR(33)
  lcMed = CHR(45)
  *--- Caracteres
  FOR lnI = 1 TO 8
    IF lnI <= 4
      lcRet = STUFF(lcRet,lnI,1,CHR(VAL(SUBS(lcRet,lnI,1)) + 48))
    ELSE
      lcRet = STUFF(lcRet,lnI,1,CHR(VAL(SUBS(lcRet,lnI,1)) + 97))
    ENDIF
  ENDFOR
  *--- Armo código
  lcCod = lcLat + SUBS(lcRet,1,4) + lcMed + SUBS(lcRet,5,4) + lcLat
  RETURN lcCod
ENDFUNC

*------------------------------------------------------
* FUNCTION _StrToI2of5(tcString) * INTERLEAVED 2 OF 5
*------------------------------------------------------
* Convierte un string para ser impreso con
* fuente True Type "PF Interleaved 2 of 5" 
* ó "PF Interleaved 2 of 5 Wide" 
* ó "PF Interleavev 2 of 5 Text"   
* Solo caracteres numéricos
* USO: _StrToI2of5('1234567890')
* RETORNA: Caracter
*------------------------------------------------------
FUNCTION _StrToI2of5(tcString)
  LOCAL lcStart, lcStop, lcRet, lcCheck, ;
    lcCar, lnLong, lnI, lnSum, lnAux
  lcStart = CHR(40)
  lcStop = CHR(41)
  lcRet = ALLTRIM(tcString)
  *--- Genero dígito de control
  lnLong = LEN(lcRet)
  lnSum = 0
  lnCount = 1
  FOR lnI = lnLong TO 1 STEP -1
    lnSum = lnSum + VAL(SUBSTR(lcRet,lnI,1)) * ;
      IIF(MOD(lnCount,2) = 0,1,3)
    lnCount = lnCount + 1
  ENDFOR
  lnAux = MOD(lnSum,10)
  lcRet = lcRet + ALLTRIM(STR(IIF(lnAux = 0,0,10 - lnAux)))
  lnLong = LEN(lcRet)
  *--- La longitud debe ser par
  IF MOD(lnLong,2) # 0
    lcRet = '0' + lcRet
    lnLong = LEN(lcRet)
  ENDIF
  *--- Convierto los pares a caracteres
  lcCar = ''
  FOR lnI = 1 TO lnLong STEP 2
    IF VAL(SUBS(lcRet,lnI,2)) < 50
      lcCar = lcCar + CHR(VAL(SUBS(lcRet,lnI,2)) + 48)
    ELSE
      lcCar = lcCar + CHR(VAL(SUBS(lcRet,lnI,2)) + 142)
    ENDIF
  ENDFOR
  *--- Armo código
  lcRet = lcStart + lcCar + lcStop
  RETURN lcRet
ENDFUNC

*------------------------------------------------------
* FIN CodBar.prg
*------------------------------------------------------
**********************
FUNCTION Grabar_O_T_PD  && VETT 2007-03-10
**********************
*PARAMETERS m.sNroO_T 
SELECT CO_T
PRIVATE iRecno
=F1QEH("GRAB_DBFS")
*jj* PRIVATE iRecno

IF GoCfgCpi.Crear
   =F1QEH("GRAB_CABE")
   APPEND BLANK
   IF !F1_RLOCK(5)
     RETURN
   ENDIF
   STORE RECNO() TO iRECNO
   *Control multiuser *
   SELE CDOC
   IF !F1_RLOCK(5)
        SELE CO_T
        DELETE
        RETURN
   ENDIF
   IF GoCfgCpi.sNroO_T = GoCfgCpi.NroO_T
         * correlativo automatico
       XsNroMes=TRAN(_MES,"@L ##")
       Campo1   = [NDOC]+XsNroMes
       LnNroO_T = CDOC.&Campo1.
       LnNroO_T = VAL(XsNroMes+RIGHT(TRANSF(LnNroO_T,"@L ###"),3))
       LsNroO_T = ALLTRIM(STR(LnNroO_T))
       gocfgCpi.sNroO_T  = LEFT(CDOC.Siglas,3)+PADL(LsNroO_T,LEN(CO_T.NroDoc)-3,'0')
       REPLACE &Campo1. WITH &Campo1. + 1
   ELSE
      SELE CO_T
      SEEK goCfgCpi.sNroO_T
      IF FOUND()
    	  GO iRECNO
      	  DELETE
	      sErr = [Registro Creado por Otro Usuario]
          DO F1MSGERR WITH sERR
          RETURN
   	  ELSE
         SELE CDOC
         sNroCorr = SUBSTR(goCfgCpi.sNroO_T,4)
         IF VAL(sNroCorr)>=NroDoc
             REPLACE NroDoc WITH VAL(sNroCorr)+1
         ENDIF
      ENDIF
   ENDIF
   UNLOCK IN "CDOC"
   SELE CO_T
   GO iRECNO
   REPLACE NroDoc WITH goCfgCpi.sNroO_T
   *
   *SELECT CO_T
   *IF SEEK(m.sNroO_T ,'CO_T','CO_T01')
   *      m.sNroO_T=correlativo_Cpi(goCfgCpi.EntidadCorrelativo,goCfgCpi.CodSed,goCfgCpi.Tpo_Pro,'0')
   *		IF SEEK( m.sNroO_T ,'CO_T','CO_T01')
   *		   =MESSAGEBOX("Registro creado por otro usuario.")
   *		   RETURN -1   
   *		ENDIF
   * ENDIF
   * INSERT INTO CO_T ( NroDoc) VALUES (m.sNroO_T)
   * =correlativo_Cpi(goCfgCpi.EntidadCorrelativo,goCfgCpi.CodSed,goCfgCpi.Tpo_Pro,m.sNroO_T)
ELSE   
   =F1QEH("GRAB_CABE")
   =SEEK(goCfgCpi.sNroO_T,'CO_T','CO_T01')
ENDIF
*GoCfgCpi.sNroO_T = m.sNroO_T
*!*	** REMPLAZAMOS DATOS DE LA CABECERA **
*!*	REPLACE FchDoc WITH dFchDoc
*!*	REPLACE Respon WITH sRespon
*!*	REPLACE CanObj WITH fCanObj
*!*	REPLACE CodPro WITH sCodPrd
*!*	REPLACE CdArea WITH sCdArea
*!*	** Guardamos datos anteriores **
*!*	REPLACE FchFinA WITH FchFin
*!*	REPLACE CanFinA WITH CanFin
*!*	*--------------X---------------*
*!*	REPLACE FchFin WITH dFchFin
*!*	REPLACE CanFin WITH fCanFin

*!*	REPLACE FlgEst WITH IIF(!EMPTY(FchFin),[T],cFlgEst)
*!*	REPLACE TipBat WITH m.tipbat
*!*	** Factor de producci¢n
*!*	REPLACE Factor WITH fFactor

UPDATE Co_t SET ;
		FchDoc   = C_CO_T.FchDoc,;
		Respon   = C_CO_T.Respon,;
		CanObj   = C_CO_T.CanObj,;
		CodFase  = C_CO_T.CodFase,;
		CodProcs = C_CO_T.CodProcs,;
		CodActiv = C_CO_T.CodActiv,;
		CodLote  = C_CO_T.CodLote,;
		CodCult  = C_CO_T.CodCult,;
		CodPro   = C_CO_T.CodPrO,;
		CdArea   = C_CO_T.CdArea,;
		FchFinA  = C_CO_T.FchFin,;
		CanFinA  = C_CO_T.CanFin,;
		FchFin   = C_CO_T.FchFin,;
		CanFin   = C_CO_T.CanFin,;
		FlgEst   = IIF(C_CO_T.FlgEst=[P] AND !gocfgcpi.chkstk(),C_CO_T.FlgEst,IIF(C_CO_T.FlgEst=[P] AND gocfgcpi.chkstk(),[E],IIF(C_CO_T.FlgEst=[L] AND !EMPTY(C_CO_T.FchFin),[T],C_CO_T.FlgEst))), ;
		TipBat   = C_CO_T.tipbat,;
		Factor   = C_CO_T.Factor, ;	
		TpoRef	 = 'PECO' ,;
		NroRef	 = C_O_T.NroRef	;
	WHERE NroDoc = goCfgCpi.sNroO_T
*
LnControl = GrbdO_T_PD()	&& Graba Detalle Parte diario VETT 2007-03-10
SELE C_CO_T
UNLOCK ALL
RETURN LnControl

*****************
PROCEDURE GrbdO_T_PD  && Graba Detalle Parte diario VETT 2007-03-10
*****************
** Cerramos archivos innecesarios  **

lActalm = .T.
STORE .F. TO GoCfgCpi.aHayMov
GoCfgCpi.CierDbfPro()
IF !GoCfgCpi.AbreDbfAlm()
   MESSAGEBOX([Error en apertura de archivos de almacen],[Alerta])
   GoCfgCpi.CierDbfAlm()
   =GoCfgCpi.AbreDbfPro()
   lActalm = .F.
ENDIF
** Extornamos datos anteriores de almacen con otro factor **
SELE EXTORNO
SCAN
	IF !EMPTY(CodFor+CodAdi+CodDev)
		DO ExtAlmCen WITH .F.,NroDoc,SubAlm,CodMat
    ENDIF
ENDSCAN

** Borramos informacion anterior **
IF GoCfgCpi.GnTotDel >0
   FOR k = 1 TO GoCfgCpi.GnTotDel   	    
       IF GoCfgCpi.aRegDel(k)>0

          SELE DO_T
          GO GoCfgCpi.aRegDel(k)
          DO WHILE !RLOCK()
          ENDDO
          DO ExtAlmCen WITH .F.,DO_T.NroDoc,DO_T.SubAlm,DO_T.CodMat,.T.
          SELE DO_T
          DELETE
          UNLOCK
       ENDIF
   ENDFOR
ENDIF
IF GoCfgCpi.GnTotDelpo_t >0
   FOR k = 1 TO GoCfgCpi.GnTotDelpo_t
       IF GoCfgCpi.aRegDelpo_t(k)>0

          SELE PO_T
          GO GoCfgCpi.aRegDelPo_t(k)
          DO WHILE !RLOCK()
          ENDDO
          DO ExtAlmCen WITH .T.,PO_T.NroDoc,PO_T.SubAlm,PO_T.CodPrd,.T.          
          SELE PO_T
          DELETE
          UNLOCK
       ENDIF
   ENDFOR
ENDIF
IF GoCfgCpi.GnTotDelmo_t >0
   FOR k = 1 TO GoCfgCpi.GnTotDelmo_t
       IF GoCfgCpi.aRegDelmo_t(k)>0

          SELE MO_T
          GO GoCfgCpi.aRegDelMo_t(k)
          DO WHILE !RLOCK()
          ENDDO              
          SELE MO_T
          DELETE
          UNLOCK
       ENDIF
   ENDFOR
ENDIF
IF GoCfgCpi.GnTotDelQo_t >0
   FOR k = 1 TO GoCfgCpi.GnTotDelQo_t
       IF GoCfgCpi.aRegDelQo_t(k)>0

          SELE QO_T
          GO GoCfgCpi.aRegDelQo_t(k)
          DO WHILE !RLOCK()
          ENDDO
          SELE QO_T
          DELETE
          UNLOCK
       ENDIF
   ENDFOR
ENDIF
** Cargamos configuraci¢n de Producci¢n **
IF GoCfgCpi.nTotMov <=0
   IF !GoCfgCpi.ArrConfig()
      messagebox([No existe configuración para actualizar almacen],0+48+0,'Atencion !!')
      =GoCfgCpi.AbreDbfPro()
      lActAlm = .F.
   ENDIF
ENDIF

** Grabaci¢n de detalle de O_T   **

SELE C_DO_T
PACK
GO TOP
SCAN
 **IF EMPTY(NroDoc)
 **   REPLACE NroDoc WITH sNroO_t
 **ENDIF
 **IF EMPTY(CodPro)
 **   REPLACE CodPRo WITH sCodPrd
 **ENDIF
 **IF EMPTY(TipPro)
 **   =SEEK(CODMAT,[CATG])
 **   IF !CATG.NoProm
 **      m.TipPro = [PTA] && Insumos que no son envases
 **   ELSE
 **      m.TipPro = [PTB] && Insumos que si son envases
 **   ENDIF
 **   REPLACE TipPro  WITH m.TipPro
 **ENDIF
 **IF CnFmla=0
 **   REPLACE CnFmla WITH CanFor
 **ENDIF
 **IF FacEqu=0
 **   REPLACE FacEqu WITH 1
 **ENDIF
   IF C_CO_T.TipBat=2
		REPLACE CnFmla WITH CanFor + CanAdi
   ENDIF
   =GoCfgCpi.ChkMovAct([CanFor])
   =GoCfgCpi.ChkMovAct([CanAdi])
  *=GoCfgCpi.ChkMovAct([CanSal])
   =GoCfgCpi.ChkMovAct([CanDev])

   SCATTER MEMVAR
   IF NroReg>0
      m.Nro_Reg = NroReg
      SELE DO_T
      GO m.Nro_Reg
   ELSE
      SELE DO_T

      APPEND BLANK
      m.Nro_Reg = RECNO()
   ENDIF
   IF RECNO()<>m.Nro_Reg AND m.Nro_Reg>0   && Ser¡a el colmo !!
      GO m.Nro_Reg
   ENDIF
   GATHER MEMVAR
   REPLACE FCHDOC WITH CO_T.fCHdOC
   UNLOCK
   SELE C_DO_T
   REPLACE RegGrb WITH m.Nro_Reg
ENDSCAN
*

SELE CO_T
goCfgCpi.HayIngP_T = !EMPTY(CO_T.FchFin) AND (CO_T.CanFin#CO_T.CanFinA OR CO_T.FchFin#CO_T.FchFinA)
** Chequeamos si hay que valorizar Productos terminados **
**se valoriza cuando hay algun movimiento en la formulacion de la produccion
lValProTer = .f.
PRIVATE YY
FOR YY = 1 to GoCfgCpi.nTotMov
	if GoCfgCpi.aPorP_T(yy)
	else
	   IF GoCfgCpi.aHayMov(yy)		
	   	  lValProTer =.t.	
	   endif
	endif
ENDFOR
** Fin De Chequeo **
SELE DTRA
SET ORDER TO DTRA04
SELE C_PO_T
SEEK GoCfgCpi.sNroO_T 
SCAN WHILE NroDoc=GoCfgCpi.sNroO_T 
     lGrbValAlm=SEEK(GoCfgCpi.ZsTpoRef+NroDoc+CodPrd+SubAlm+CodP_T,[DTRA])
     lGrbCtoUni=lGrbValAlm AND (DTRA.Preuni#0 AND DTRA.ImpCto#0)
     IF lValProTer or CostMn<=0 or !lGrbCtoUni OR  canfin<>canfina
        DO WHILE !RLOCK()
        ENDDO
        REPLACE FlgAlm WITH .F.&&Almacen no esta actualizado con salida por produccion, hay q actualizar!!
        UNLOCK
     ENDIF
     =GoCfgCpi.ChkMovAct([CanFin])&&checkea si finalmente actualizamos el almacen por salida a produccion
	   
	   SCATTER MEMVAR
	   IF NroReg>0
	      m.Nro_Reg = NroReg
	      SELE PO_T
	      GO m.Nro_Reg
	   ELSE
	      SELE PO_T
	      APPEND BLANK
	      m.Nro_Reg = RECNO()
	   ENDIF
	   IF RECNO()<>m.Nro_Reg AND m.Nro_Reg>0   && Ser¡a el colmo !!
	      GO m.Nro_Reg
	   ENDIF
	   GATHER MEMVAR
	   UNLOCK
	   SELE C_PO_T
	   REPLACE RegGrb WITH m.Nro_Reg
ENDSCAN
** Graba Mano de Obra **
SELECT C_MO_T
GO top
SCAN
	   SCATTER MEMVAR
	   IF NroReg>0
	      m.Nro_Reg = NroReg
	      SELE MO_T
	      GO m.Nro_Reg
	   ELSE
	      SELE MO_T
	      APPEND BLANK
	      m.Nro_Reg = RECNO()
	   ENDIF
	   IF RECNO()<>m.Nro_Reg AND m.Nro_Reg>0   && Ser¡a el colmo !!
	      GO m.Nro_Reg
	   ENDIF
	   GATHER MEMVAR
	   REPLACE FCHDOC WITH CO_T.fCHdOC
	   UNLOCK
	   SELE C_MO_T	   
ENDSCAN

** Graba Maquinaria y equipo **
SELECT C_QO_T
GO top
SCAN
	   SCATTER MEMVAR
	   IF NroReg>0
	      m.Nro_Reg = NroReg
	      SELE QO_T
	      GO m.Nro_Reg
	   ELSE
	      SELE QO_T
	      APPEND BLANK
	      m.Nro_Reg = RECNO()
	   ENDIF
	   IF RECNO()<>m.Nro_Reg AND m.Nro_Reg>0   && Ser¡a el colmo !!
	      GO m.Nro_Reg
	   ENDIF
	   GATHER MEMVAR
       REPLACE FCHDOC WITH CO_T.fCHdOC
	   UNLOCK
	   SELE C_QO_T	   
ENDSCAN
**
SELE CO_T

IF !lActAlm
   RETURN
ENDIF

IF CieDelMes(_MES)
   RETURN
ENDIF

** Y abrimos archivos de almacen   **
IF !GocfgCpi.AbreDbfAlm()
   =messagebox([Error en apertura de archivos de almacen],'Atención')
   GoCfgCpi.CierDbfAlm()
   =GoCfgCpi.AbreDbfPro()
   RETURN
ENDIF

STORE .F. TO GoCfgCpi.aConFig
*DO CPIsgo_t.spr
PRIVATE K
nNumItmI = 0
FOR K = 1 TO GoCfgCpi.nTotMov
    IF GoCfgCpi.aHayMov(K) &&&AND aConFig(K,1)

       IF CO_T.flgest<>[P]
	       =ActAlmCen(K)
	   ENDIF 
    ENDIF
ENDFOR
** Imprimir guias de almacen **
lCapConfig =.T.
*DO Impr_Guias &POR REVISAR
**
RELEASE K
** Cerramos archivos de Almacen **
=GoCfgCpi.CierDbfAlm()
** Y abrimos archivos de Producci¢n **
IF !GoCfgCpi.AbreDbfPro()
   MESSAGEBOX([Error en apertura de archivos de Producci¢n])
ENDIF
RETURN


*---------------------------------------------------------------------------*
* NAME: GETCPUID                                                            *
*---------------------------------------------------------------------------*
*                                                                           *
* Let's get the CPU ID.                                                     *
*                                                                           *
*---------------------------------------------------------------------------*
* PARAMETERS:                                                               *
* ===========                                                               *
*        NONE                                                               *
*---------------------------------------------------------------------------*
*   Created: 20/06/2006                                                     *
* Last.Mod.:                                                                *
*---------------------------------------------------------------------------*

function GetCPUID() as integer
		local lnCPUID as integer
		lnCPUID = 0
		try
			local lcComputerName, loWMI, loItems, loItem
			lcComputerName = getwordnum( sys( 0 ), 1 )
			loWMI = getobject( "WinMgmts://" + lcComputerName )
			loItems = loWMI.InstancesOf( "Win32_Processor" )
			for each loItem in loItems
				lnCPUID = loItem.ProcessorId
				if not this.IsEmpty( lnCPUID )
					exit
				endif
			next
		catch
*!*			Do Nothing
		endtry

		return ( lnCPUID )
	ENDFUNC
	
*---------------------------------------------------------------------------*
* NAME: GETVOLUMESERIAL                                                     *
*---------------------------------------------------------------------------*
*                                                                           *
* Let's get the Volume Serial Number(s).                                    *
*                                                                           *
*---------------------------------------------------------------------------*
* PARAMETERS:                                                               *
* ===========                                                               *
*        NONE                                                               *
*---------------------------------------------------------------------------*
*   Created: 20/06/2006                                                     *
* Last.Mod.:                                                                *
*---------------------------------------------------------------------------*
	function GetVolumeSerial() as string
		local lcVolumeSerial as string
		try
			local lcComputerName, loWMIService, loItems, loItem
			lcComputerName = "."
			loWMIService = getobject( "winmgmts:\\" + lcComputerName + "\root\cimv2" )
			loItems = loWMIService.ExecQuery( "Select * from Win32_LogicalDisk" )
			for each loItem in loItems
				lcVolumeSerial = loItem.VolumeSerialNumber
				if not this.IsEmpty( lcVolumeSerial )
					exit
				endif
			next
		catch
*!*			Do Nothing
		endtry
		return ( lcVolumeSerial )
	endfunc	
*************************	
FUNCTION  GetVolumeNumber
************************* 
PARAMETERS  lcVolume 

	*------------------------------------------------------------
	* Description: GetVolumeNumber - Get the unique number associated with the boot hard drive.
	* Parameters:  lcVolume, The hard drive drive letter.
	* Return:      HDD Identifier.
	* Use:
	*------------------------------------------------------------
	* Id Date        By         Description
	*  1 02/10/2005  gregory.re Initial Creation
	*
	*------------------------------------------------------------
	LOCAL lcVolume1, ;
		lcVolumeName, ;
		lnVolumeNameLen, ;
		lnVolumeSerialNumber, ;
		lnMaxFileNameLen, ;
		lnFileSystemFlags, ;
		lcFileSystemName, ;
		lnFileSystemNameLen, ;
		lcFileInfo, ;
		lcFileName, ;
		laFiles[1], ;
		lnFiles, ;
		lnI, ;
		lcFile, ;
		lnHandle

	#DEFINE ccNULL                       CHR(0)
	#DEFINE cnFS_CASE_SENSITIVE           0
	#DEFINE cnFS_CASE_IS_PRESERVED        1
	#DEFINE cnFS_UNICODE_STORED_ON_DISK   2
	#DEFINE cnFS_PERSISTENT_ACLS          3
	#DEFINE cnFS_FILE_COMPRESSION         4
	#DEFINE cnFS_VOL_IS_COMPRESSED       15

	* Declare the API function and constants.

	DECLARE GetVolumeInformation IN Win32API ;
		STRING lpRootPathName, STRING @lpVolumeNameBuffer, ;
		INTEGER nVolumeNameSize, INTEGER @lpVolumeSerialNumber, ;
		INTEGER @lpMaximumComponentLength, INTEGER @lpFileSystemFlags, ;
		STRING @lpFileSystemNameBuffer, INTEGER nFileSystemNameSize

	lcVolumeName         = SPACE(255)
	lnVolumeNameLen      = LEN(lcVolumeName)
	lnVolumeSerialNumber = 0
	lnMaxFileNameLen     = 0
	lnFileSystemFlags    = 0
	lcFileSystemName     = SPACE(255)
	lnFileSystemNameLen  = LEN(lcFileSystemName)

	GetVolumeInformation(lcVolume, @lcVolumeName, lnVolumeNameLen, ;
		@lnVolumeSerialNumber, @lnMaxFileNameLen, @lnFileSystemFlags, ;
		@lcFileSystemName, lnFileSystemNameLen)

	RETURN lnVolumeSerialNumber
		
***--------------------- v1.0 ------------------------***
* Amaro, Aromas del Peru 
* Fecha : 07/05/2008
* Procedimiento para borrar solo el Detalle de las Transaciones
PROCEDURE Borrar_transaccion_Alm_arv
********************************
PARAMETERS  m.cCodSed, m.cSubAlm, m.cTipMov , m.sCodMov , m.sNroDoc
SELECT DTRA
LsOrderAct_DTRA=ORDER()
SET ORDER TO DTRA01
SEEK (m.cSubAlm + m.cTipMov + m.sCodMov + m.sNroDoc )
OK     = .T.
DO WHILE ! EOF() .AND.  OK .AND. ;
   (m.cSubAlm+m.cTipMov+m.sCodMov+m.sNroDoc) = (SubALm+TipMov+CodMov+NroDoc)
	IF F1_Rlock(5)
		**AMAA 06-12-06
		IF GoCfgAlm.cTipMov='I'
			IF GoCfgAlm.XsTpoRef="O_CM"
	        	 lRequi = .F.
		         lItems = .F.
	    	     DO ActO_C WITH DTRA.NroRef,DTRA.CodMat,-DTRA.Candes,DTRA.NroRef2,[LG]
	        	 UNLOCK IN "DO_C"
		         UNLOCK IN "CREQ"
	      	ENDIF
	    ENDIF 
	    **
		SELE CATG
		SEEK DTRA->CodMat
		SELE CALM
	    SEEK m.cSubAlm + DTRA->CodMat
	    SELECT DTRA
	    DELETE
		DO CASE 
			CASE GoCfgAlm.cTipMov='I'
				=Alm_Descarga_stock_ALMpdsm2(.T.)
			CASE GoCfgAlm.cTipMov='S'
				=Alm_Carga_Stock_Almpcsm2(.T.)	
		ENDCASE					
		=item_almacen_lote(GoCfgAlm.CodSed,DTRA.SubAlm,DTRA.CodMat,DTRA.Lote,DTRA.FchVto,DTRA.TipMov,-DTRA.CanDes,DTRA.FchDoc,DTRA.SITU)
		*** SERIES 
*!*			IF DTRA.NroReg>0 && Solo si ya existe , se supone no?
			IF !EMPTY(DTRA.Serie)
				=ActualizaStockSeries(DTRA.CodMat,DTRA.Serie,DTRA.TipMov,1)
			ENDIF
*!*			ENDIF

	    UNLOCK
	ELSE
	      OK = .F.
	ENDIF
	SKIP
ENDDO
SELECT dtra
SET ORDER TO (LsOrderAct_DTRA)
RETURN 1
	
	
***********************************************************************
* Program....: JANESOFT.PRG
* Author.....: Victor E. Torres Tejada
* Date.......: 16 August 2010
* Notice.....: Copyright (c) 2010 o-Negocios SAC
* Compiler...: Visual FoxPro09.00.0000.5721
* Purpose....: Clase para obtener las ultima(s) compra(s) de un material
***********************************************************************
	
**********************************
DEFINE CLASS Calc_UltCmp AS Custom 
**********************************
DIMENSION aUltCmp[6] 

	FUNCTION Cap_UltCmp(m.CodMatD,m.CodMatH,m.cuales1,m.Cuales3,m.UltCom,lReproceso,LcTipCtoUni,m.dFch1,m.dFch2) as Array
	IF PARAMETERS()<9
		m.dFch2 = GdFecha
	ENDIF

	IF PARAMETERS()<8
		m.dFch1 = CTOD('01/01/'+STR(_ANO,4,0))
	ENDIF

	IF PARAMETERS()<7
		LcTipCtoUni = 'UEPS'
	ENDIF
	IF VARTYPE(LcTipCtoUni)<>'C' OR  EMPTY(LcTipCtoUni)
		LcTipCtoUni = 'UEPS'
	ENDIF
	m.CodMatD = TRIM(m.CodMatD)
	m.CodMatH = TRIM(m.CodMatH)+CHR(255)
	***
	DO CASE
		CASE m.Cuales1=1
			Xfor1=[!CATG.Inactivo]	
		CASE m.Cuales1=2
			Xfor1=[CATG.Inactivo]	
		CASE m.Cuales1=3
			Xfor1=[.T.]	
	ENDCASE
	***
	DO CASE
		CASE m.Cuales3=1
			Xfor2=[CATG.StkAct>0]	
		CASE m.Cuales3=2
			Xfor2=[CATG.StkAct<=0]	
		CASE m.Cuales3=3
			Xfor2=[.T.]	
	ENDCASE
	***
	xFiltro=Xfor1+[ AND ]+Xfor2
	***

	SELE DO_C
	IF LcTipCtoUni = 'PEPS'
		SET ORDER TO DO_C06 
		** VETT  16/08/2010 07:06 PM : Primera  en Entrar Primera en Salir 
	ELSE && UEPS
		SET ORDER TO DO_C06 DESCENDING  && La ultima compra primero VETT 2010/02/21 UEPS
	ENDIF
	SET RELA TO NROORD INTO CO_C
	SELE CATG
	SEEK m.CodMatD
	IF !FOUND() AND RECNO(0)>0
		GO RECNO(0)
	ENDIF
	SCAN WHILE CodMat<=m.CodMatH FOR EVAL(XFiltro)
	 IF PROGRAM(1)='CPI_CPIPFORM'

	 ELSE
		WAIT WINDOW CodMat +[ ]+DesMat+[ ]+UndStk NOWAIT
	 ENDIF
		LsCodMat = CATG.CodMat	
		LfStkMin = 0
		*
		* VERIFICA STOCK MINIMO SI ES ULTIMA COMPRA
		*
		if m.ultcom and !lReproceso
			sele calm
			seek LsCodMat
		      SCAN WHILE CodMat = LsCodMat
		             m.CodCmp = [STKM]+TRAN(_MES,"@L ##")
		             LfStkMin = LfStkMin + &CodCmp.       
		       ENDSCAN
		       sele catg
		endif
		* 
		IF !INLIST(VARTYPE(m.dFch1),'D','T') 
			m.dFch1 = CTOD('01/01/'+STR(_ANO,4,0))
		ENDIF
		IF !INLIST(VARTYPE(m.dFch2),'D','T') 
			m.dFch2 = GdFecha
		ENDIF
		LdFecha=IIF(VARTYPE(m.dFch2)='T',TTOD(m.dFch2),m.dFch2)
		IF lReproceso 
			NumCmp = 1
		ELSE
			NumCmp = 5
		ENDIF	
		*
		SELE DO_C	    
		SEEK LsCodMat+DTOS(m.dFch2)
		IF !FOUND()
			IF RECNO(0)>0
		   		GO RECNO(0)
		       	IF DELETED()
			    	SKIP
			   	ENDIF
			ENDIF
		ENDIF
		SCAN WHILE CodMat=PADR(LsCodMat,LEN(DO_C.CodMat)) AND NumCmp>0
			IF CO_C.FlgEst#[A] AND tpoO_C=[C] AND DO_C.FchOrd >= m.dFch1 AND  DO_C.FchOrd <= m.dFch2 
		 	***-----------------***
			  LfFacEqu=FacEqu
		      IF UndCmp#CATG.UndStk AND (!EMPTY(UndCmp) AND !EMPTY(CATG.UndStk))
		          IF UndCmp==CATG.UndCmp AND !INLIST(CATG.FacEqu,0,1) 
		        	  LfFacEqu=CATG.FacEqu
		          ELSE
		       		  =seek(CATG.UndStk+UndCmp,[EQUN])	
		       	 	  LfFacEqu=EQUN.FacEqu
		          ENDIF
		      ENDIF
		 	  IF LfFacEqu=0
				  LfFacEqu = 1
		      ENDIF 
		  		****--------------------***********
		  		** VETT  25/08/2010 10:11 PM : Si no es para generar reporte no necesita usar tabla temporal 
		  	  IF PROGRAM(1)='CPI_CPIPFORM' 
		  	  ELSE	
			      SELE TMP
			      SEEK LsCodMat
			      IF !FOUND()
					append blank
			      ENDIF
			      do while !rlock()
			      enddo
			      REPLACE CodMat WITH LsCodMat
			      REPLACE UndStk WITH CATG.UndStk
			      *
			      if m.ultcom
			         REPLACE StkMin WITH LfStkMin
			      endif
			      *
			      Cmp1=[CodAux]+STR(NumCmp,1,0)
			      Cmp2=[NroO_C]+STR(NumCmp,1,0)
			      Cmp3=[Precio]+STR(NumCmp,1,0)
				  Cmp4=[FchCmp]+STR(NumCmp,1,0)
				  Cmp5=[CodMon]+STR(NumCmp,1,0)
				  ***--------------------------------***
				  ***--------------------------------***	        
			      REPLACE (Cmp1)  WITH CO_C.CodAux
			      REPLACE (Cmp2)  WITH DO_C.NroOrd
			      REPLACE (Cmp3)  WITH DO_C.PreUni &&IIF(DO_C.NroOrd=[N],DO_C.PreUni,DO_C.PreFob) - AMAA 20-03-07
			      REPLACE (Cmp4)  WITH DO_C.FchOrd
			      REPLACE (Cmp5)  WITH CO_C.CodMon
		      ENDIF
		      NumCmp = NumCmp - 1
					      
	  			XfPre	=	ROUND(DO_C.PreUni/LfFacEqu,2)
	  			XnMon	=	CO_C.CodMon
	  			XdFch	=	DO_C.FchOrd
	  			XfTcm	=	CO_C.TpoCmb
	  			IF XfTcm<=0
	  				IF PROGRAM(1)='CPI_CPIPFORM'
	  				ELSE
		  				DO F1msgerr WITH [Verifique tipo cambio al ]+DTOC(XdFch)+[ O/C:]+CO_C.NroOrd
	  				ENDIF
	  				XfTcm=GoCfgAlm.oentorno._tipocambio(XdFch)
		  			IF XfTcm<=0
		  				IF PROGRAM(1)='CPI_CPIPFORM'
		  				ELSE
			  				DO F1msgerr WITH [Verifique tipo cambio al ]+DTOC(XdFch)
						ENDIF
		  				XfTcm=1
		  			ENDIF
				ENDIF
	  			XfPs=IIF(XnMon=1,XfPre,ROUND(XfPre*XfTcm,2))
	  			XfPd=IIF(XnMon=2,XfPre,ROUND(XfPre/XfTcm,2))
	  	      	IF lReproceso 
		  			SELE CATG
		  			Precio_S=[PS]+TRAN(_MES,[@L ##])	      		
		  			Precio_D=[PD]+TRAN(_MES,[@L ##])	      		
		  			=f1_rlock(0)
		  			REPLACE (Precio_S) WITH XfPs
		  			REPLACE (Precio_D) WITH XfPd
		  			UNLOCK
				ENDIF
	  			
	  			*** Valores a retornar en el arreglo *** VETT 2010-02-23
	  			IF m.UltCom
		  			THIS.aUltCmp[1] = CO_C.CodAux
		  			THIS.aUltCmp[2] = CO_C.NroOrd
		  			THIS.aUltCmp[3] = CO_C.FchOrd
		  			THIS.aUltCmp[4] = CO_C.CodMon
		  			THIS.aUltCmp[5] = XfPs
		  			THIS.aUltCmp[6] = XfPd
		  			EXIT
	  			ENDIF
			ENDIF		   
		ENDSCAN  
		SELE CATG
	ENDSCAN
*!*		WAIT WINDOW [OK] NOWAIT
	IF VARTYPE(this.aUltCmp(5))<>'N'
		this.aUltCmp(5) = 0
	ENDIF
	IF VARTYPE(this.aUltCmp(6))<>'N'
		this.aUltCmp(6) = 0
	ENDIF
	
	RETURN @This.aUltCmp

ENDDEFINE	
********************************
*!* Simple Sample Usage
********************************
*!*	DIMENSION aWrkSht(1), aCols(1)
*!*	m.lcXlsFile = GETFILE("Excel:XLS,XLSX,XLSB,XLSM")
*!*	IF FILE(m.lcXlsFile)
*!*		CLEAR
*!*		?AWorkSheets(@aWrkSht,m.lcXlsFile,.T.)
*!*		?AWorkSheetColumns(@aCols,m.lcXlsFile,"Sheet1")
*!*		AppendFromExcel(m.lcXlsFile, "Sheet1", "MyTable", "column1,column2,column3", "Recnum Is Not Null", "field1,field2,field3", "field1 > 14000")
*!*		SELECT MyTable
*!*		GO TOP IN "MyTable"
*!*		BROWSE LAST NOWAIT
*!*	ENDIF
*!*	CopyToExcel("C:\Test.xlsx", "Sheet1", "MyTable") && try xls, xlsb, and xlsm as well

**********************************
FUNCTION AppendFromExcel(tcXLSFile, tcSheet, tvWorkarea, tcExcelFieldList, tcExcelWhereExpr, tcTableFieldList, tcTableForExpr, tlNoHeaderRow)
	**********************************
	* PARAMETER Information
	* tcXLSFile := a string specifying an excel file (*.xls, *.xlsx, *.xlsm, *.xlsb) on disk
	* tcSheet := a string specifying the name of a worksheet within the excel workbook (can also be a range Sheet1$A1:C20 for instance)
	* tvWorkarea [optional] := the Alias, Work Area, or File Name of the table you want the worksheet result set appended to (default is currently selected Alias)
	* tcExcelFieldList [optional] := a comma delimited list of columns you want from the worksheet (default is '*' - all columns)
	* tcExcelWhereExpr [optional] := a valid SQL Where clause to be used when querying the worksheet (default is '1=1')
	* tcTableFieldList [optional] :=  a comma delimited list of fields you want the worksheet result set inserted into (default is '*' - all fields)
	* tcTableForExpr [optional] := a valid VFP Where clause to be used when querying the worksheet result set (cursor) (default is '.T.')
	* tlNoHeaderRow [optional] := pass .T. if the worksheet does not contain a header row, .F. is the default which specifies that a header row does exist
	*
	* RETURN Information
	* returns numeric, the number of records inserted into tvWorkArea
	*
	* Provider Information
	* the default provider being used in the SQLStringConnect function can be downloaded and installed from:
	* http://www.microsoft.com/downloads/details.aspx?FamilyID=7554F536-8C28-4598-9B72-EF94E038C891&displaylang=en
	**********************************
	LOCAL lnSelect, laErr[1], laTableFields[1], laExcelFields[1], lnFieldCounter
	Local lcSQLAlias, lnResult, lcInsertValues, lcFieldList, lcNvlFieldList
	Local lcFieldType, lcExcelFieldType, lcNvlFieldName, lcTempAlias, loExc, lnReturn
	Local lcHeaderRow, llOpenedtvWorkArea
	
	m.lnSelect = SELECT(0)
	m.lnReturn = 0
	IF NOT FILE(m.tcXLSFile)
		ERROR 1, m.tcXLSFile
	ENDIF

	IF !USED(m.tvWorkarea) AND TYPE("m.tvWorkArea") = "C" AND FILE(DEFAULTEXT(m.tvWorkarea,"DBF"))
		SELECT 0
		USE (DEFAULTEXT(m.tvWorkarea,"DBF")) SHARED AGAIN
		m.tvWorkarea = ALIAS()
		m.llOpenedtvWorkArea = .T.
	ELSE
		IF !USED(m.tvWorkarea)
			m.tvWorkarea = ALIAS()
		ENDIF
	ENDIF
	IF TYPE("m.tvWorkArea") = "N"
		m.tvWorkArea = ALIAS(m.tvWorkArea)
	ENDIF
	
	m.tcSheet = ALLTRIM(EVL(m.tcSheet,"Sheet1$"))
	IF AT("$",m.tcSheet) = 0
		m.tcSheet = m.tcSheet + "$"
	ENDIF
	m.tcExcelFieldList = EVL(m.tcExcelFieldList,"*")
	m.tcExcelWhereExpr = EVL(m.tcExcelWhereExpr,"1=1")
	m.tcTableFieldList = EVL(m.tcTableFieldList,"*")
	m.tcTableForExpr = EVL(m.tcTableForExpr,".T.")
	m.lcSQLAlias = SYS(2015)
	m.lcTempAlias = SYS(2015)
	m.lnSQL = 0
	m.lcHeaderRow = IIF(EMPTY(m.tlNoHeaderRow), "Yes", "No")
	TRY
		SELECT (m.tvWorkarea)
		
*!*			m.lnSQL = SQLSTRINGCONNECT([Provider=Microsoft.ACE.OLEDB.12.0;Data Source="] + m.tcXLSFile + [";Extended Properties="Excel 12.0 Xml;HDR=] + m.lcHeaderRow + [;";])

		*!* Alternate using DSN that comes with Office install (MSDASQL = OLEDB wrapper for ODBC)
		*!*			m.lnSQL = SQLSTRINGCONNECT("Provider=MSDASQL.1;" ;
		*!*				+"Persist Security Info=False;" ;
		*!*				+"DSN=Excel Files;" ;
		*!*				+"DBQ="+FULLPATH(m.tcXLSFile)+";" ;
		*!*				+"DriverId=790;" ;
		*!*				+"MaxBufferSize=2048;" ;
		*!*				+"PageTimeout=5;")
		
		*!* Try a few other drivers that may be on the user's machine
*!*			IF m.lnSQL < 0
			m.lnSQL = SQLSTRINGCONNECT("Driver={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};" ;
				+ "DBQ="+FULLPATH(m.tcXLSFile)+";")
			IF m.lnSQL < 0 AND UPPER(ALLTRIM(JUSTEXT(m.tcXLSFile))) == "XLS" && can we try using the older driver?
				IF m.lnSQL < 0
					m.lnSQL = SQLSTRINGCONNECT("Driver={Microsoft Excel Driver (*.xls)};" ;
						+ "DBQ="+FULLPATH(m.tcXLSFile)+";")
				ENDIF
			ENDIF
			IF m.lnSQL < 0
				AERROR(m.laErr)
				ERROR m.laErr[2]
			ENDIF
*!*			ENDIF

		m.lnResult = SQLEXEC(m.lnSQL,[SELECT ] + m.tcExcelFieldList + [ FROM "] + m.tcSheet + [" Where ] + m.tcExcelWhereExpr, m.lcSQLAlias)
		IF m.lnResult < 0
			AERROR(m.laErr)
			ERROR m.laErr[2]
		ENDIF

		IF USED(m.lcSQLAlias)
			m.lcFieldList = ""
			m.lcNvlFieldList = ""
			m.lnTotalExcelFields = AFIELDS(m.laExcelFields, m.lcSQLAlias)
			SELECT &tcTableFieldList FROM (m.tvWorkarea) WHERE .F. INTO CURSOR (m.lcTempAlias)
			FOR m.lnFieldCounter = 1 TO MIN(AFIELDS(m.laTableFields, m.lcTempAlias), m.lnTotalExcelFields)
				m.lcFieldList = m.lcFieldList + IIF(!EMPTY(m.lcFieldList),",","")+m.laTableFields[m.lnFieldCounter,1]
				m.lcFieldType =  CHRTRAN(m.laTableFields[m.lnFieldCounter,2],"NIFYD","BBBBT")
				m.lcExcelFieldType = CHRTRAN(m.laExcelFields[m.lnFieldCounter,2],"CVNIFYD","MMBBBBT")
				m.lcNvlFieldName = m.laExcelFields[m.lnFieldCounter,1]
				IF !m.laTableFields[m.lnFieldCounter,5]
					m.lcNvlFieldName = [NVL(]+m.lcNvlFieldName+[,]+;
						ICASE(m.lcExcelFieldType="B", "0", ;
						m.lcExcelFieldType="M", "''", ;
						m.lcExcelFieldType="T", "{//}", ;
						m.lcExcelFieldType="L", ".F.", ;
						"''")+[)]
				ENDIF
				IF INLIST(m.lcFieldType, "C", "V")
					m.lcNvlFieldName = [CAST(]+m.lcNvlFieldName+[ AS ]+m.lcFieldType+[(] + TRANSFORM(m.laTableFields[m.lnFieldCounter,3]) + [))]
				ELSE
					m.lcNvlFieldName = [CAST(]+m.lcNvlFieldName+[ AS ]+m.lcFieldType+[)]
				ENDIF
				m.lcNvlFieldList = m.lcNvlFieldList + IIF(!EMPTY(m.lcNvlFieldList),",","") + m.lcNvlFieldName
			ENDFOR
			INSERT INTO (m.tvWorkarea) (&lcFieldList) SELECT &lcNvlFieldList FROM (m.lcSQLAlias) WHERE &tcTableForExpr
			m.lnReturn = _TALLY
		ENDIF

	CATCH TO m.loExc
		*!*			MESSAGEBOX(m.loExc.MESSAGE + " : " + TRANSFORM(m.loExc.LINENO))
	FINALLY
		IF m.llOpenedtvWorkArea
			USE IN SELECT(m.tvWorkArea)
		ENDIF
		IF m.lnSQL > 0
			SQLDISCONNECT(m.lnSQL)
		ENDIF
		USE IN SELECT(m.lcTempAlias)
		USE IN SELECT(m.lcSQLAlias)
		SELECT (m.lnSelect)
	ENDTRY
	RETURN m.lnReturn
ENDFUNC

**********************************
FUNCTION AWorkSheets(taArray, tcXLSFile, tlAllTables)
	**********************************
	* PARAMETER Information
	* taArray := an array sent in by reference to fill with Worksheet/Table information
	* tcXLSFile := a string specifying an excel file (*.xls, *.xlsx, *.xlsm, *.xlsb) on disk
	* tlAllTables := if .T., array will contain information regarding all tables in workbook; .F. returns only worksheets
	*
	* RETURN Information
	* returns numeric, the number of tables found in the workbook
	**********************************

	LOCAL lnSQL, laErr[1], lcSQLAlias, lnResult, lnReturn, loExc
	m.lnReturn = 0
	m.lnSQL = SQLSTRINGCONNECT("Driver={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};" ;
		+"DBQ="+FULLPATH(m.tcXLSFile)+";")
		
	*!* Alternate using DSN that comes with Office install (MSDASQL = OLEDB wrapper for ODBC)
	*!*		m.lnSQL = SQLSTRINGCONNECT("Provider=MSDASQL.1;" ;
	*!*			+"Persist Security Info=False;" ;
	*!*			+"DSN=Excel Files;" ;
	*!*			+"DBQ="+FULLPATH(m.tcXLSFile)+";" ;
	*!*			+"DriverId=790;" ;
	*!*			+"MaxBufferSize=2048;" ;
	*!*			+"PageTimeout=5;")

		*!* Try a few other drivers that may be on the user's machine
	IF m.lnSQL < 0
		IF UPPER(ALLTRIM(JUSTEXT(m.tcXLSFile))) == "XLS" && can we try using the older driver?
			m.lnSQL = SQLSTRINGCONNECT("Driver={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};" ;
				+ "DBQ="+FULLPATH(m.tcXLSFile)+";")
			IF m.lnSQL < 0
				m.lnSQL = SQLSTRINGCONNECT("Driver={Microsoft Excel Driver (*.xls)};" ;
					+ "DBQ="+FULLPATH(m.tcXLSFile)+";")
			ENDIF
		ELSE
			m.lnSQL = SQLSTRINGCONNECT("Driver={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};" ;
				+ "DBQ="+FULLPATH(m.tcXLSFile)+";")
		ENDIF
		IF m.lnSQL < 0
			AERROR(m.laErr)
			ERROR m.laErr[2]
		ENDIF
	ENDIF

	m.lcSQLAlias = SYS(2015)
	m.lnResult = SQLTABLES(m.lnSQL,"VIEW,TABLE,SYSTEM TABLE",m.lcSQLAlias)

	IF m.lnSQL > 0
		SQLDISCONNECT(m.lnSQL)
	ENDIF

	IF m.lnResult < 0
		AERROR(m.laErr)
		ERROR m.laErr[2]
	ENDIF

	IF USED(m.lcSQLAlias)
		TRY
			IF tlAllTables
				SELECT CAST(ALLTRIM(table_name) AS V(100)), ;
					CAST(ALLTRIM(table_type) AS V(12)) ;
					FROM (m.lcSQLAlias) ;
					INTO ARRAY taArray
			ELSE
				SELECT CAST(ALLTRIM(table_name) AS V(100)), ;
					CAST(ALLTRIM(table_type) AS V(12)) ;
					FROM (m.lcSQLAlias) ;
					WHERE table_type = "SYSTEM TABLE" ;
					INTO ARRAY taArray
			ENDIF
			m.lnReturn = _TALLY
		CATCH TO m.loExc
			THROW
		FINALLY
			*!*				USE IN SELECT(m.lcSQLAlias)
		ENDTRY
	ENDIF

	RETURN m.lnReturn
ENDFUNC

**********************************
FUNCTION AWorkSheetColumns(taArray, tcXLSFile, tcSheet)
	**********************************
	* PARAMETER Information
	* taArray := an array sent in by reference to fill with the specified worksheet's column information
	* tcXLSFile := a string specifying an excel file (*.xls, *.xlsx, *.xlsm, *.xlsb) on disk
	* tcSheet := a string specifying the worksheet or table to use when retrieving column information
	*
	* RETURN Information
	* returns numeric, the number of columns found in the worksheet/table
	**********************************
	LOCAL lnSQL, laErr[1], lnResult, lnReturn, lcSQLAlias, loExc
	m.lnReturn = 0
	m.lnSQL = SQLSTRINGCONNECT("Driver={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};" ;
		+"DBQ="+FULLPATH(m.tcXLSFile)+";")
	*!* Alternate using DSN that comes with Office install (MSDASQL = OLEDB wrapper for ODBC)
	*!*		m.lnSQL = SQLSTRINGCONNECT("Provider=MSDASQL.1;" ;
	*!*			+"Persist Security Info=False;" ;
	*!*			+"DSN=Excel Files;" ;
	*!*			+"DBQ="+FULLPATH(m.tcXLSFile)+";" ;
	*!*			+"DriverId=790;" ;
	*!*			+"MaxBufferSize=2048;" ;
	*!*			+"PageTimeout=5;")

	*!* Try a few other drivers that may be on the user's machine
	IF m.lnSQL < 0
		IF UPPER(ALLTRIM(JUSTEXT(m.tcXLSFile))) == "XLS" && can we try using the older driver?
			m.lnSQL = SQLSTRINGCONNECT("Driver={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};" ;
				+ "DBQ="+FULLPATH(m.tcXLSFile)+";")
			IF m.lnSQL < 0
				m.lnSQL = SQLSTRINGCONNECT("Driver={Microsoft Excel Driver (*.xls)};" ;
					+ "DBQ="+FULLPATH(m.tcXLSFile)+";")
			ENDIF
		ELSE
			m.lnSQL = SQLSTRINGCONNECT("Driver={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};" ;
				+ "DBQ="+FULLPATH(m.tcXLSFile)+";")
		ENDIF
		IF m.lnSQL < 0
			AERROR(m.laErr)
			ERROR m.laErr[2]
		ENDIF
	ENDIF

	m.lcSQLAlias = SYS(2015)
	m.lnResult = SQLEXEC(m.lnSQL,[SELECT * FROM "] + m.tcSheet + [$" Where 1=0], m.lcSQLAlias)

	IF m.lnSQL > 0
		SQLDISCONNECT(m.lnSQL)
	ENDIF

	IF m.lnResult < 0
		AERROR(m.laErr)
		ERROR m.laErr[2]
	ENDIF

	IF USED(m.lcSQLAlias)
		TRY
			m.lnReturn = AFIELDS(m.taArray, m.lcSQLAlias)
		CATCH TO m.loExc
			THROW
		FINALLY
			USE IN SELECT(m.lcSQLAlias)
		ENDTRY
	ENDIF

	RETURN m.lnReturn
ENDFUNC

***********************************
FUNCTION CopyToExcel(tcXLSFile, tcSheet, tvWorkArea, tcExcelFieldList, tcTableFieldList, tcTableForExpr)
	***********************************
	* PARAMETER Information
	* tcXLSFile := a string specifying an excel file (*.xls, *.xlsx, *.xlsm, *.xlsb) on disk
	* tcSheet := a string specifying the name of the worksheet to create within the excel workbook
	* tvWorkarea [optional] := the Alias, Work Area, or File Name of the table you want to be copied to the worksheet (default is currently selected Alias)
	* tcExcelFieldList [optional] := a comma delimited list of columns you want to create in the worksheet (default is '*' - columns will match table field list)
	* tcTableFieldList [optional] :=  a comma delimited list of fields you want this function to copy from tvWorkArea
	* tcTableForExpr [optional] := a valid VFP Where/For clause to be used when querying tvWorkArea for data to be copied to the worksheet
	*
	* RETURN Information
	* returns numeric, the number of records inserted into the worksheet
	*
	* Provider Information
	* the default provider being used in the SQLStringConnect function can be downloaded and installed from:
	* http://www.microsoft.com/downloads/details.aspx?FamilyID=7554F536-8C28-4598-9B72-EF94E038C891&displaylang=en
	**********************************
	#DEFINE adOpenStatic 3
	#DEFINE adOpenKeyset 1
	#DEFINE adLockOptimistic 3
	#DEFINE adUseClient 3
	#DEFINE adUseServer 2
	#DEFINE adCmdText 0x0001
	LOCAL loConnection as ADODB.Connection, lcCreateTableCommand, llOpenedtvWorkArea, loExc as Exception, ;
		lnReturn, lnResult, lnFieldCounter, lnSQL, loCursorAdapter as CursorAdapter, ;
		lcFieldName, lcFieldType, lcSelectFields, lcUpdateNameListFields, lcUpdatableFieldList, ;
		loRecordSet as ADODB.Recordset, lcConversionFunc, lcVFPFieldName, laTableFields[1], laErr[1]
	
	m.lnSelect = SELECT(0)
	m.lnReturn = 0
	
	m.llOpenedtvWorkArea = .F.
	IF !USED(m.tvWorkarea) AND TYPE("m.tvWorkArea") = "C" AND FILE(DEFAULTEXT(m.tvWorkarea,"DBF"))
		SELECT 0
		USE (DEFAULTEXT(m.tvWorkarea,"DBF")) SHARED AGAIN
		m.tvWorkarea = ALIAS()
		m.llOpenedtvWorkArea = .T.
	ELSE
		IF !USED(m.tvWorkarea)
			m.tvWorkarea = ALIAS()
		ENDIF
	ENDIF
	IF TYPE("m.tvWorkArea") = "N"
		m.tvWorkArea = ALIAS(m.tvWorkArea)
	ENDIF

	m.tcSheet = ALLTRIM(EVL(m.tcSheet,"Sheet1$"))
	IF AT("$",m.tcSheet) = 0
		m.tcSheet = m.tcSheet + "$"
	ENDIF
	m.tcExcelFieldList = EVL(m.tcExcelFieldList,"")
	m.tcTableFieldList = EVL(m.tcTableFieldList,"*")
	m.tcTableForExpr = EVL(m.tcTableForExpr,".T.")
	m.lnSQL = 0
	m.lcTempAlias = SYS(2015)
	
	TRY
		CreateExcelTemplate(m.tcXLSFile)
		IF !FILE(m.tcXLSFile)
			m.lnReturn
		ENDIF
		m.loConnection = CreateObject ( "ADODB.Connection")
		*!* This is the only provider/driver that appears to work without showing Select Data Source dialog
		*!* or throwing a weird error about the excel Database being readonly.
		m.loConnection.ConnectionString = [Provider=Microsoft.ACE.OLEDB.12.0;Data Source="] + m.tcXLSFile + [";Extended Properties="Excel 12.0 Xml;HDR=Yes;";]
		m.loConnection.Open()
		m.loConnection.Execute("DROP TABLE [Sheet1$]")
		SELECT &tcTableFieldList FROM (m.tvWorkarea) WHERE &tcTableForExpr INTO CURSOR (m.lcTempAlias) NOFILTER
		GO TOP IN (m.lcTempAlias)
		m.lnReturn = RECCOUNT(m.lcTempAlias)
		m.lcCreateTableCommand = ""
		m.lcSelectFields = ""
		m.lcUpdateNameListFields = ""
		m.lcUpdatableFieldList = ""
		m.lcConversionFunc = ""
		FOR m.lnFieldCounter = 1 TO AFIELDS(m.laTableFields, m.lcTempAlias)
			m.lcVFPFieldName = m.laTableFields(m.lnFieldCounter, 1)
			m.lcFieldName = ALLTRIM(GETWORDNUM(m.tcExcelFieldList, m.lnFieldCounter, ","))
			IF EMPTY(m.lcFieldName)
				m.lcFieldName = m.laTableFields(m.lnFieldCounter, 1)
			ENDIF
			m.lcSelectFields = m.lcSelectFields + "[" + m.lcFieldName + "] " + " AS " + m.lcVFPFieldName
			m.lcUpdateNameListFields = m.lcUpdateNameListFields + m.lcVFPFieldName + " [" + m.tcSheet + "].[" + m.lcFieldName + "]"
			m.lcUpdatableFieldList = m.lcUpdatableFieldList + m.lcVFPFieldName
			m.lcCreateTableCommand = m.lcCreateTableCommand + "[" + m.lcFieldName + "] "
			m.lcFieldType = m.laTableFields(m.lnFieldCounter, 2)
			m.lcCreateTableCommand = m.lcCreateTableCommand + ;
				ICASE(m.lcFieldType = 'C', 'Char(' + TRANSFORM(m.laTableFields(m.lnFieldCounter, 3)) + ')', ;
				 m.lcFieldType = 'Y', 'Currency', ;
				 m.lcFieldType = 'D', 'Date', ;
				 m.lcFieldType = 'T', 'DateTime', ;
				 m.lcFieldType = 'B', 'Double', ;
				 m.lcFieldType = 'F', 'Double', ;
				 m.lcFieldType = 'G', 'Binary', ;
				 m.lcFieldType = 'I', 'Integer', ;
				 m.lcFieldType = 'L', 'Logical', ;
				 m.lcFieldType = 'M', 'Text', ;
				 m.lcFieldType = 'N', 'Numeric(' + TRANSFORM(m.laTableFields(m.lnFieldCounter, 3)) + ',' + TRANSFORM(m.laTableFields(m.lnFieldCounter, 4)) + ')', ;
				 m.lcFieldType = 'Q', 'Binary', ;
				 m.lcFieldType = 'V', 'VarChar(' + TRANSFORM(m.laTableFields(m.lnFieldCounter, 3)) + ')', ;
				 m.lcFieldType = 'W', 'Blob', ;
				 'Char(' + TRANSFORM(m.laTableFields(m.lnFieldCounter, 3)) + ')')
			IF INLIST(m.lcFieldType,"T","D")
				m.lcConversionFunc = m.lcConversionFunc +IIF(!EMPTY(m.lcConversionFunc), ", ", "") +  m.lcVFPFieldName + " EmptyFieldToNull"
			ENDIF
			IF m.lnFieldCounter != ALEN(m.laTableFields,1)
				m.lcCreateTableCommand = m.lcCreateTableCommand + ','
				m.lcSelectFields = m.lcSelectFields + ','
				m.lcUpdateNameListFields = m.lcUpdateNameListFields + ','
				m.lcUpdatableFieldList = m.lcUpdatableFieldList + ','
			ENDIF
		ENDFOR
		IF !EMPTY(m.lcCreateTableCommand)
			IF m.tcSheet != [Sheet1$]
				m.tcSheet = STRTRAN(m.tcSheet,"$","")
			ENDIF
			m.lcCreateTableCommand = "CREATE TABLE [" + m.tcSheet + "](" + m.lcCreateTableCommand + ")"
			m.loConnection.Errors.Clear()
			m.loConnection.Execute(m.lcCreateTableCommand)
			IF m.loConnection.Errors.Count>0
				ERROR m.loConnection.Errors(0).Description
			ENDIF
			m.loRecordSet = CreateObject("ADODB.Recordset")
			With m.loRecordSet
			    .ActiveConnection = m.loConnection
			    .CursorLocation = adUseClient
			    .CursorType = adOpenStatic
			    .LockType = adLockOptimistic
			ENDWITH
			m.loCursorAdapter = CREATEOBJECT("CursorAdapter")
			m.loCursorAdapter.Alias = SYS(2015)
			m.loCursorAdapter.DataSourceType = "ADO"
			m.loCursorAdapter.DataSource = m.loRecordSet
			m.loCursorAdapter.SelectCmd = "Select " + m.lcSelectFields + " From [" + m.tcSheet + "]"
			IF m.loCursorAdapter.CursorFill(.F.,.T.)
				m.loCursorAdapter.Tables = "[" + m.tcSheet + "]"
				m.loCursorAdapter.BufferModeOverride = 3 && faster than 5 when dealing with larger record sets
				m.loCursorAdapter.UpdateNameList = m.lcUpdateNameListFields
				m.loCursorAdapter.UpdatableFieldList = m.lcUpdatableFieldList
				IF !EMPTY(m.lcConversionFunc)
					m.loCursorAdapter.ConversionFunc = m.lcConversionFunc
				ENDIF
				INSERT INTO (m.loCursorAdapter.Alias) SELECT * FROM (m.lcTempAlias)
				m.lnReturn = TABLEUPDATE(.T.,.T.,m.loCursorAdapter.Alias)
				IF m.lnReturn
					m.lnReturn =  RECCOUNT(m.loCursorAdapter.Alias)
				ELSE
					m.lnReturn = -1
				ENDIF
			ELSE
				AERROR(m.laErr)
				ERROR m.laErr(2)
			ENDIF
		ENDIF
		m.loConnection.Close()
	CATCH TO oErr && m.loExc
		
		oErr.UserValue = "Nested CATCH message: Unable to handle"

*!*	      ?[: Nested Catch! (Unhandled: Throw oErr Object Up) ]  

*!*	      ?[  Inner Exception Object: ]

      =MESSAGEBOX([  Error: ] + STR(oErr.ErrorNo)+; 
      [  LineNo: ] + STR(oErr.LineNo) + ;
      [  Mensaje: ] + oErr.Message + ;
      [  Procedimiento: ] + oErr.Procedure +;
      [  Nivel: ] + STR(oErr.StackLevel) +; 
      [  Contenido: ] + oErr.LineContents +;
      [  Sugerencia : Revisar datos tipo fecha,numérico inválidos o fuera de rango ], 16,'¡ Error / Warning !' )

*!*		[  Detalle: ] + oErr.Details + ;
*!*	      ?[  UserValue: ] + oErr.UserValue 
      
		m.lnReturn = -2 
*!*	      THROW oErr 

	FINALLY
		m.loCursorAdapter = Null
		m.loConnection = Null
		RELEASE loCursorAdapter, loConnection
		IF m.llOpenedtvWorkArea
			USE IN SELECT(m.tvWorkarea)
		ENDIF
		USE IN SELECT(m.lcTempAlias)
		SELECT (m.lnSelect)
	ENDTRY
	RETURN m.lnReturn
ENDFUNC


*******************
FUNCTION EmptyFieldToNull(tdFieldValue)
*******************
	RETURN EVL(m.tdFieldValue,NULL)
ENDFUNC

*******************
FUNCTION CreateExcelTemplate(tcExcelFile)
*******************
	LOCAL lcExcelFileExtension, lcFileBinary
	m.llReturn = .F.
	IF FILE(m.tcExcelFile)
		m.llReturn = .T.
	ELSE
		m.lcExcelFileExtension = UPPER(JUSTEXT(m.tcExcelFile))
		DO case
		CASE m.lcExcelFileExtension = "XLSX"
			m.lcFileBinary = 0h504B030414000600080000002100CC7EE6A14E010000080400001300DF015B436F6E74656E745F54797065735D2E786D6C20A2DB0128A00002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
			m.lcFileBinary = m.lcFileBinary + 0h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
			m.lcFileBinary = m.lcFileBinary + 0h000000000000000000000000000000000000AC93CB4EC3301045F748FC83E52D8ADDB2400835ED82C712BA281F60EC4963D52F79DCD2FE3D938422814A455536B1226BEE9D39733D996DBD631BC86863A8F9588C3883A0A3B16159F3D7C55375CB1916158C723140CD77807C36BDBC982C7609905175C09AB7A5A43B2951B7E0158A9820D04D13B357857EF35226A5576A09F27A34BA913A8602A154A5D3E0D3C90B3590AD013657B93C2B4F3E72EB64213518BE63417A9CDD0F859D77CD554ACE6A55A873B909E6876B159BC66A3051AF3D79895EECAA5391BF1A62D939C0B3AD306550065B80E29D1844F7CE0FD0A8B52BEC714B0406E8191C9E36DA274C
			m.lcFileBinary = m.lcFileBinary + 0h4195FDF8D8DA84471C8EB33BCEE43DE6D55B8CABFFA6D2D1115ED9B0EFFB5008687BF31C134ADAF5D90D4087DC80A91249422E16BE981DF2A60076B3F76B44D91FE7A7F07B34BEF4FFC440C70CA743D867A5AB3E30B9ECDFF1F4030000FFFF0300504B030414000600080000002100B5553023F50000004C0200000B00CE015F72656C732F2E72656C7320A2CA0128A0000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
			m.lcFileBinary = m.lcFileBinary + 0h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
			m.lcFileBinary = m.lcFileBinary + 0h0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008C92CF4EC3300CC6EF48BC43E4FBEA6E4808A1A5BB4C48BB21541EC024EE1FB58DA32440F7F68403824A63DBD1F6E7CF3F5BDEEEE669541F1C622F4EC3BA2841B133627BD76A78AD9F560FA06222676914C71A8E1C6157DDDE6C5F78A4949B62D7FBA8B28B8B1ABA94FC2362341D4F140BF1EC72A5913051CA6168D19319A865DC94E53D86BF1E502D3CD5C16A08077B07AA3EFA3CF9B2B7344D6F782FE67D62974E8C409E
			m.lcFileBinary = m.lcFileBinary + 0h133BCB76E543660BA9CFDBA89A42CB498315F39CD311C9FB2263039E26DA5C4FF4FFB63871224B89D048E0F33CDF8A7340EBEB812E9F68A9F8BDCE3CE2A784E14D64F861C1C50F545F000000FFFF0300504B0304140006000800000021008D87DA70E00000002D0200001A000801786C2F5F72656C732F776F726B626F6F6B2E786D6C2E72656C7320A2040128A00001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
			m.lcFileBinary = m.lcFileBinary + 0h00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000AC91CB6AC3301045F785FE83987D3D760AA594C8D99442B6C5FD00218F1FC496846692D67F5FE182DD404836D908AE06DD73246D773FE3A04E14B9F74E4391E5A0C8595FF7AED5F0557D3CBD826231AE368377A46122865DF9F8B0FDA4C1483AC45D1F58A516C71A3A91F086C8B6
			m.lcFileBinary = m.lcFileBinary + 0hA3D170E603B934697C1C8DA4185B0CC61E4C4BB8C9F3178CFF3BA03CEB54FB5A43DCD7CFA0AA2924F2ED6EDF34BDA5776F8F2339B98040966948175095892D8986BF9C2547C0CBF8CD3DF1929E8556FA1C715E8B6B0EC53D1DBE7D3C704724ABC7B2C5384F16193CFBE4F2170000FFFF0300504B030414000600080000002100A460FAFF52010000270200000F000000786C2F776F726B626F6F6B2E786D6C8C915D6FC2201486EF97EC3F10EE272DA9CE185B93655BE6CD6232A7D7AC9C5A228506A8D57FBF534CE776B72BCE073CE7BC2FCBD5B9D1E404CE2B6B729A4E124AC094562A73C8E9E7F6F5614E890FC248A1AD819C5EC0D355717FB7ECAD3B7E
			m.lcFileBinary = m.lcFileBinary + 0h597B2408303EA77508ED82315FD6D0083FB12D18EC54D6352260EA0ECCB70E84F435406834E34932638D50865E090BF71F86AD2A55C2B32DBB064CB8421C6811707D5FABD6D36259290DBBAB2222DAF65D34B8F75953A2850F2F52059039CD30B53DFC29B8AE7DEA941EBAD3644A59F12372E3085203B88D5327515ED0294A2454A2D3618B82C77958E719E7B3E1ED60CE4E41EF6F982125E7BD32D2F639E5199A7D19B31427923EB6F64A861A51D9FC567B0375A8434EE7499A0C74F60B1F2DC531F12426EAFD186CC625636D8D9230760B85815BCB3412C667A5D0250A1C8E78914F1F7954CFC63F2EBE010000FFFF0300504B0304140006000800000021
			m.lcFileBinary = m.lcFileBinary + 0h00A083C4AEA3010000640300000D000000786C2F7374796C65732E786D6CA453C16ADC3010BD17F20F42F746BB0B0D6DB19D436121909440B6D0AB6CC95EC16864A4F1B2EED767643BDEDD530EBD584F4F336F9E66E4E2F1EC419C6C4C2E6029B7F71B292C36C138EC4AF9E7B0FFFA5D8A441A8D8680B694A34DF2B1BAFB52241AC1BE1DAD25C112984A7924EA7F2A959AA3F53ADD87DE229FB4217A4DBC8D9D4A7DB4DAA49CE441ED369B07E5B54359156D404AA2090312BB5888AA48FFC44903335BA9AAA20910A2209667231383DADB39E29706574797C35AED1D8C33BDCBC4E46889F30E43CCA4CA259725719203580DECB20126AAA2D74436E29E3762
			m.lcFileBinary = m.lcFileBinary + 0hC187B1E7F2C8DD9865A6B84FA2BBA8C7EDEEDB55829A0A56451DA2E1EE5F5F7DA6AA026C4B6C34BAEE98570A3D7FEB40143C03E37417500343F591B100BE4E6301DEF284FEB637DAE756E0E0F79E9E4C2979D6B9091F902FB2C0596FDE64FD6BB559FBBF65C5B9BDD567C52BDB37A6D7F222CFBB94BFF39302B94A887A70400E6F05A7EBB3A6395F5AB0C913205DF3CBCDCD59AB70278C6DF50074580F4B79C12FD6B8C1FF58A35EDD29D02451CA0B7ECE93DA3E4C534EEBEF51BD030000FFFF0300504B030414000600080000002100E9A625B882060000531B000013000000786C2F7468656D652F7468656D65312E786D6CEC594F6FDB3614BF0FD87720
			m.lcFileBinary = m.lcFileBinary + 0h746F6D27B61B07758AD8B19BAD4D1BC46E871E6999965853A240D2497D1BDAE38001C3BA619701BBED306C2BD002BB749F265B87AD03FA15F6484AB218CB4BD2061BD6D58744227F7CFFDFE32375F5DA8388A1432224E571DBAB5DAE7A88C43E1FD338687B7786FD4B1B1E920AC763CC784CDADE9C48EFDAD6FBEF5DC59B2A241141B03E969BB8ED854A259B958AF46118CBCB3C2131CC4DB888B082571154C6021F01DD8855D6AAD56625C234F6508C23207B7B32A13E41434DD2DBCA88F718BCC64AEA019F8981264D9C15063B9ED63442CE659709748859DB033E637E34240F948718960A26DA5ED5FCBCCAD6D50ADE4C1731B5626D615DDFFCD275E982
			m.lcFileBinary = m.lcFileBinary + 0hF174CDF014C128675AEBD75B577672FA06C0D432AED7EB757BB59C9E0160DF074DAD2C459AF5FE46AD93D12C80ECE332ED6EB551ADBBF802FDF525995B9D4EA7D14A65B1440DC83ED697F01BD5667D7BCDC11B90C53796F0F5CE76B7DB74F00664F1CD257CFF4AAB5977F10614321A4F97D0DAA1FD7E4A3D874C38DB2D856F007CA39AC2172888863CBA348B098FD5AA588BF07D2EFA00D04086158D919A2764827D88E22E8E468262CD006F125C98B143BE5C1AD2BC90F4054D54DBFB30C190110B7AAF9E7FFFEAF953F4EAF993E387CF8E1FFE74FCE8D1F1C31F2D2D67E12E8E83E2C297DF7EF6E7D71FA33F9E7EF3F2F117E57859C4FFFAC327BFFCFC79
			m.lcFileBinary = m.lcFileBinary + 0h3910326821D18B2F9FFCF6ECC98BAF3EFDFDBBC725F06D814745F8904644A25BE4081DF0087433867125272371BE15C3105367050E817609E99E0A1DE0AD396665B80E718D775740F128035E9FDD77641D8462A66809E71B61E400F738671D2E4A0D7043F32A5878388B8372E66256C41D607C58C6BB8B63C7B5BD590255330B4AC7F6DD903862EE331C2B1C909828A4E7F8949012EDEE51EAD8758FFA824B3E51E81E451D4C4B4D32A4232790168B7669047E9997E90CAE766CB3771775382BD37A871CBA484808CC4A841F12E698F13A9E291C95911CE288150D7E13ABB04CC8C15CF8455C4F2AF074401847BD3191B26CCD6D01FA169C7E0343BD2A75FB
			m.lcFileBinary = m.lcFileBinary + 0h1E9B472E52283A2DA37913735E44EEF06937C45152861DD0382C623F905308518CF6B92A83EF713743F43BF801C72BDD7D9712C7DDA717823B3470445A04889E9909ED4B28D44EFD8D68FC77C59851A8C63606DE15E3B6B70D5B53594AEC9E28C1AB70FFC1C2BB8367F13E81585FDE78DED5DD7775D77BEBEBEEAA5C3E6BB55D1458A8BDBA79B07DB1E992A3954DF28432365073466E4AD3274BD82CC67D18D4EBCC0191E487A62484C7B4B83BB84060B30609AE3EA22A1C8438811EBBE66922814C490712255CC2D9CE0C97D2D678E8D3953D1936F499C1D60389D51E1FDBE1753D9C1D0D723266CB09CCF93363B4AE099C95D9FA959428A8FD3ACC6A5AA8
			m.lcFileBinary = m.lcFileBinary + 0h3373AB19D14CA973B8E52A830F975583C1DC9AD08520E85DC0CA4D38A26BD67036C18C8CB5DDED069CB9C578E1225D24433C26A98FB4DECB3EAA192765B1622E0320764A7CA4CF79A758ADC0ADA5C9BE01B7B338A9C8AEBE825DE6BD37F15216C10B2FE9BC3D918E2C2E26278BD151DB6B35D61A1EF271D2F62670AC85C72801AF4BDDF86116C0DD90AF840DFB5393D964F9C29BAD4C3137096A705361EDBEA4B053071221D50E96A10D0D339586008B35272BFF5A03CC7A510AD8487F0D29D6372018FE3529C08EAE6BC964427C5574766144DBCEBEA6A594CF141183707C84466C260E30B85F872AE833A6126E274C45D02F7095A6AD6DA6DCE29C265DF1
			m.lcFileBinary = m.lcFileBinary + 0h02CBE0EC38664988D372AB5334CB640B37799CCB60DE0AE2816EA5B21BE5CEAF8A49F90B52A518C6FF3355F47E02D705EB63ED011F6E7205463A5FDB1E172AE450859290FA7D018D83A91D102D701D0BD31054709F6CFE0B72A8FFDB9CB3344C5AC3A94F1DD000090AFB910A0521FB50964CF49D42AC96EE5D96244B0999882A882B132BF6881C1236D435B0A9F7760F8510EAA69AA465C0E04EC69FFB9E66D028D04D4E31DF9C1A92EFBD3607FEE9CEC7263328E5D661D3D064F6CF452CD955ED7AB33CDB7B8B8AE889459B55CFB2029815B682569AF6AF29C239B75A5BB196345E6B64C28117973586C1BC214AE0D207E93FB0FF51E133FB71426FA8437E
			m.lcFileBinary = m.lcFileBinary + 0h00B515C1B7064D0CC206A2FA926D3C902E907670048D931DB4C1A44959D3A6AD93B65AB6595F70A79BF33D616C2DD959FC7D4E63E7CD99CBCEC9C58B34766A61C7D6766CA5A9C1B32753148626D941C638C67CD52A7E78E2A3FBE0E81DB8E29F31254D30C1672581A1F51C983C80E4B71CCDD2ADBF000000FFFF0300504B030414000600080000002100075F38D31E010000C701000018000000786C2F776F726B7368656574732F7368656574312E786D6C8C514D6BC3300CBD0FF61F8CEE8BD38D6EA324298352B6C360ECEBEE2472626A5BC156D7EDDFCF496819F4B29B3EDE7BD2938AF5B7B3E20B4334E44B58643908F40DB5C677257CBC6FAFEE4144
			m.lcFileBinary = m.lcFileBinary + 0h56BE55963C96F08311D6D5E54571A0B08B3D228BA4E063093DF3B09232363D3A15331AD0A78EA6E014A73474320E01553B919C95D7797E2B9D321E668555F88F06696D1ADC50B377E87916096815A7FD636F860855D19AD41B0D8980BA848705C8AA98C67E1A3CC43FB16055BFA1C586B14DEE418CAE6AA2DD087C4AA57CA4CA33EE7672F512448B5AED2DBFD2E1114DD77312599EA66D14AB441F5487CF2A74C6476151274C9EDD8108337E8A9986A9BA04511333B963D6A783613A4C9EDD80D0447C4CC6B54E2FA87E010000FFFF0300504B030414000600080000002100A6A453EB3E0100005102000011000801646F6350726F70732F636F72652E786D
			m.lcFileBinary = m.lcFileBinary + 0h6C20A2040128A00001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
			m.lcFileBinary = m.lcFileBinary + 0h000000000000000000007C92516BC3201485DF07FB0FC1F7449342DB4992C236FAB4C260191B7B13BD6D65D188BAA5FDF733499BA65006BE78CFB9DF3D5ECC57075547BF609D6C7481D284A008346F84D4BB02BD57EB788922E79916AC6E3414E8080EADCAFBBB9C1BCA1B0BAFB63160BD0417059276949B02EDBD371463C7F7A0984B82430771DB58C57CB8DA1D368C7FB31DE08C903956E099609EE10E189B91884E48C147A4F9B1750F101C430D0AB477384D527CF17AB0CADD6CE8958953497F34E14DA7B853B6E08338BA0F4E8EC6B66D9376D6C708F953FCB97979EB9F1A4BDDED8A032A73C129B7C07C63CB1C4F2F617135737E1376BC95201E8F41
			m.lcFileBinary = m.lcFileBinary + 0hBF5113BC8F3B40404421001DE29E958FD9D373B54665B7C3983CC4E9BC2284F6E7AB1B79D5DF051A0AEA34F87FE2B223924595113A5BD02C9B10CF8021F7F52728FF000000FFFF0300504B03041400060008000000210027388BC4880100001103000010000801646F6350726F70732F6170702E786D6C20A2040128A000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
			m.lcFileBinary = m.lcFileBinary + 0h00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009C92C16EDB300C86EF03F60E86EE8D9C601886405651A41D7AD8B00049BBB326D3B150591244D648F6F4A36DA471BA9DA613C99FF8F58994BA3D76BEE821A38BA112CB45290A0836D62E1C2AF1B4FF7AF345144826D4C6C7009538018A5BFDF183DAE6982093032CD82260255AA2B496126D0B9DC105CB819526E6CE10A7F9
			m.lcFileBinary = m.lcFileBinary + 0h2063D3380BF7D1BE761048AECAF2B3842341A8A1BE496F8662725CF7F4BFA675B4031F3EEF4F8981B5BA4BC93B6B885FA9BF3B9B23C6868A87A305AFE45C544CB703FB9A1D9D74A9E43C553B6B3C6CD85837C623287929A84730C3D0B6C665D4AAA7750F96622ED0FDE6B1AD44F1CB200C3895E84D762610630D6D5332C63E2165FD33E6176C010895E486A93886F3DE79EC3EE9E5D8C0C175E3603081B0708DB877E4017F345B93E91FC4CB39F1C830F14E38BB816FBA73CE373E996F7AE7BD895D32E1C4C25BF4CD85177C4AFB786F08CEE3BC2EAA5D6B32D4BC81B37E29A8479E64F683C9A635E100F5B9E76F6158FEF3F4C3F572B528F98C3B3FD794BC
			m.lcFileBinary = m.lcFileBinary + 0hFC65FD070000FFFF0300504B01022D0014000600080000002100CC7EE6A14E010000080400001300000000000000000000000000000000005B436F6E74656E745F54797065735D2E786D6C504B01022D0014000600080000002100B5553023F50000004C0200000B000000000000000000000000005E0300005F72656C732F2E72656C73504B01022D00140006000800000021008D87DA70E00000002D0200001A000000000000000000000000004A060000786C2F5F72656C732F776F726B626F6F6B2E786D6C2E72656C73504B01022D0014000600080000002100A460FAFF52010000270200000F000000000000000000000000006A080000786C2F776F
			m.lcFileBinary = m.lcFileBinary + 0h726B626F6F6B2E786D6C504B01022D0014000600080000002100A083C4AEA3010000640300000D00000000000000000000000000E9090000786C2F7374796C65732E786D6C504B01022D0014000600080000002100E9A625B882060000531B00001300000000000000000000000000B70B0000786C2F7468656D652F7468656D65312E786D6C504B01022D0014000600080000002100075F38D31E010000C701000018000000000000000000000000006A120000786C2F776F726B7368656574732F7368656574312E786D6C504B01022D0014000600080000002100A6A453EB3E010000510200001100000000000000000000000000BE130000646F635072
			m.lcFileBinary = m.lcFileBinary + 0h6F70732F636F72652E786D6C504B01022D001400060008000000210027388BC48801000011030000100000000000000000000000000033160000646F6350726F70732F6170702E786D6C504B050600000000090009003E020000F11800000000
		CASE m.lcExcelFileExtension = "XLSB"
			m.lcFileBinary = 0h504B030414000600080000002100558086C16D010000020400001300DD015B436F6E74656E745F54797065735D2E786D6C20A2D90128A00002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
			m.lcFileBinary = m.lcFileBinary + 0h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
			m.lcFileBinary = m.lcFileBinary + 0h00000000000000000000000000000000A453CD4BC33014BF0BFE0F255769B2791091B53BE8042FBAC3C47396BEAE616912F2B2D9FEF7BEB6ACA0EC83E1A5A16D7E9F2F99CD9BDA247B08A89DCDD8944F580256B942DB4DC63E57AFE9234B304A5B48E32C64AC0564F3FCF666B66A3D6042688B19AB62F44F42A0AAA096C89D074B7F4A176A19E9356C84976A2B3720EE279307A19C8D60631A3B0E96CF5EA0943B139345439F07276B6D59F23CECEBA43226BD375AC94846C5DE16BCC6141A058663051039016468792D55700B2BD706688B241691CF3E2860D005244B19E2BBAC894D344644720BC373CAC9EF05C1DFA95257965A41E1D4AEA62CBC27BBEB
			m.lcFileBinary = m.lcFileBinary + 0h584E0B7EBBB0EDDDA2E89769E7FA82EA1873047702471A0B60F002D79F047E980927645F2B56DAE321C21185F3159D894E252D83F3286886FF2E1ABA435240917AA28410358C9E4FCC796C0EC5704ADE08DF5C553EE17AD0179E192FC6D6005E33D301718A72AC4DB900D7F776186F873E5296E86F70FE030000FFFF0300504B0304140006000800000021004382E3C5F70000004C0200000B00CE015F72656C732F2E72656C7320A2CA0128A000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
			m.lcFileBinary = m.lcFileBinary + 0h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
			m.lcFileBinary = m.lcFileBinary + 0h00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008C92CF4EC3300CC6EF48BC43E4FBEA6E4808A1B5BB20A4DD102A0FE0256E1BB58DA32440F7F66427A834B61DFDEFF3CF9FBCDDCDD3A8BE38442BAE8275518262A7C558D755F0D1BCAE9E40C544CED0288E2B3872845D7D7FB77DE791521E8ABDF5516515172BE853F2CF8851F73C512CC4B3CB9556C2442987A1434F7AA08E7153968F18FE6A40BD
			m.lcFileBinary = m.lcFileBinary + 0hD0547B5341D89B0750CDD1E7CDD7B5A56DADE617D19F13BB746605F29CD819362B1F325B48365FA31A0A1DA70A8CE8B79C8E48DE17191BF03CD1E676A2FFAFC58913194A845A025FE639755C025ADF0E74DDA265C7AF3BF388DF128683C8501CAC3B99838B1FA87F000000FFFF0300504B03041400060008000000210006332055E50000002D0200001A000801786C2F5F72656C732F776F726B626F6F6B2E62696E2E72656C7320A2040128A000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
			m.lcFileBinary = m.lcFileBinary + 0h0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000AC91C16AC3301044EF85FE83D87BBD760AA594C8B98442AEC1FD00555EDB22B624B4DB36FEFB0A97360DA4F4928B60B468DEEC68BD394EA37AA7C42E780D555182226F43EB7CAFE1A579BE7B04C562
			m.lcFileBinary = m.lcFileBinary + 0h7C6BC6E049C34C0C9BFAF666BDA7D1487EC4838BACB28B670D83487C42643BD064B808917C9E74214D46B24C3D46630FA6275C95E503A6DF1E509F79AA5DAB21EDDA7B50CD1C33F97FEFD075CED236D8B789BC5C4020CB3CE6055463524FA2E14B17AFCE035EC6AFAE89975C0B9DE88BC4E5AC8ADCD35F19AA6B66F808E9C003919C72FC5C312E93EABB103CFBE4FA130000FFFF0300504B030414000600080000002100A76734B792000000C00000000F000000786C2F776F726B626F6F6B2E62696E6A66646860346040034C407E05430E0323903681922C60B62983018329C34C461E0DA0B0D35390020686764686798CB21F80AC4C20BE6AC9C0E025CF
			m.lcFileBinary = m.lcFileBinary + 0hC0100132050A2A3A1819FA1919E630AA800440BA40C615317832A4301832B001D9C10C190CA9405802E44F606498CB2825FB9A11AC320528FB67E5C74BBE4901F6209D590CB31819196603710B2303000000FFFF0300504B030414000600080000002100F98F44D4E0000000CA0100000D000000786C2F7374796C65732E62696EA4904F4B424114C57FBEB9E8F6B9EB1BB410FF1104EE8C5CA608F60514438522100DFA16ADEAC3E52E15FCB3D255923CCFBC47E2D26860CE9C7BCF993B73EF7BC097590AC85D4E846F9E0690F127444146784B9B470674180AA7C6A7993CE46BDEE3AA1E89DC8D402B8EFE00F95A56EEFF569918B3A491C295CAA58E1F38
			m.lcFileBinary = m.lcFileBinary + 0h8FCD8D4D72BD189EB61086B03516BFDAB1AC88D796C62AD14A175ED36B515A6783670DEB291EDCDAF876E6D59DE3C7353DCB6ADF4BED68B00FB418F11AB3BAA2AE863CD6DD4AEC6A2A7A51B5D189EB4EB91E7DE5CA5CB3777C041C000000FFFF0300504B030414000600080000002100E9A625B882060000531B000013000000786C2F7468656D652F7468656D65312E786D6CEC594F6FDB3614BF0FD87720746F6D27B61B07758AD8B19BAD4D1BC46E871E6999965853A240D2497D1BDAE38001C3BA619701BBED306C2BD002BB749F265B87AD03FA15F6484AB218CB4BD2061BD6D58744227F7CFFDFE32375F5DA8388A1432224E571DBAB5DAE7A88C43E
			m.lcFileBinary = m.lcFileBinary + 0h1FD338687B7786FD4B1B1E920AC763CC784CDADE9C48EFDAD6FBEF5DC59B2A241141B03E969BB8ED854A259B958AF46118CBCB3C2131CC4DB888B082571154C6021F01DD8855D6AAD56625C234F6508C23207B7B32A13E41434DD2DBCA88F718BCC64AEA019F8981264D9C15063B9ED63442CE659709748859DB033E637E34240F948718960A26DA5ED5FCBCCAD6D50ADE4C1731B5626D615DDFFCD275E982F174CDF014C128675AEBD75B577672FA06C0D432AED7EB757BB59C9E0160DF074DAD2C459AF5FE46AD93D12C80ECE332ED6EB551ADBBF802FDF525995B9D4EA7D14A65B1440DC83ED697F01BD5667D7BCDC11B90C53796F0F5CE76B7DB74F006
			m.lcFileBinary = m.lcFileBinary + 0h64F1CD257CFF4AAB5977F10614321A4F97D0DAA1FD7E4A3D874C38DB2D856F007CA39AC2172888863CBA348B098FD5AA588BF07D2EFA00D04086158D919A2764827D88E22E8E468262CD006F125C98B143BE5C1AD2BC90F4054D54DBFB30C190110B7AAF9E7FFFEAF953F4EAF993E387CF8E1FFE74FCE8D1F1C31F2D2D67E12E8E83E2C297DF7EF6E7D71FA33F9E7EF3F2F117E57859C4FFFAC327BFFCFC793910326821D18B2F9FFCF6ECC98BAF3EFDFDBBC725F06D814745F8904644A25BE4081DF0087433867125272371BE15C3105367050E817609E99E0A1DE0AD396665B80E718D775740F128035E9FDD77641D8462A66809E71B61E400F738671D2E
			m.lcFileBinary = m.lcFileBinary + 0h4A0D7043F32A5878388B8372E66256C41D607C58C6BB8B63C7B5BD590255330B4AC7F6DD903862EE331C2B1C909828A4E7F8949012EDEE51EAD8758FFA824B3E51E81E451D4C4B4D32A4232790168B7669047E9997E90CAE766CB3771775382BD37A871CBA484808CC4A841F12E698F13A9E291C95911CE288150D7E13ABB04CC8C15CF8455C4F2AF074401847BD3191B26CCD6D01FA169C7E0343BD2A75FB1E9B472E52283A2DA37913735E44EEF06937C45152861DD0382C623F905308518CF6B92A83EF713743F43BF801C72BDD7D9712C7DDA717823B3470445A04889E9909ED4B28D44EFD8D68FC77C59851A8C63606DE15E3B6B70D5B53594AEC9E28
			m.lcFileBinary = m.lcFileBinary + 0hC1AB70FFC1C2BB8367F13E81585FDE78DED5DD7775D77BEBEBEEAA5C3E6BB55D1458A8BDBA79B07DB1E992A3954DF28432365073466E4AD3274BD82CC67D18D4EBCC0191E487A62484C7B4B83BB84060B30609AE3EA22A1C8438811EBBE66922814C490712255CC2D9CE0C97D2D678E8D3953D1936F499C1D60389D51E1FDBE1753D9C1D0D723266CB09CCF93363B4AE099C95D9FA959428A8FD3ACC6A5AA83373AB19D14CA973B8E52A830F975583C1DC9AD08520E85DC0CA4D38A26BD67036C18C8CB5DDED069CB9C578E1225D24433C26A98FB4DECB3EAA192765B1622E0320764A7CA4CF79A758ADC0ADA5C9BE01B7B338A9C8AEBE825DE6BD37F15216
			m.lcFileBinary = m.lcFileBinary + 0hC10B2FE9BC3D918E2C2E26278BD151DB6B35D61A1EF271D2F62670AC85C72801AF4BDDF86116C0DD90AF840DFB5393D964F9C29BAD4C3137096A705361EDBEA4B053071221D50E96A10D0D339586008B35272BFF5A03CC7A510AD8487F0D29D6372018FE3529C08EAE6BC964427C5574766144DBCEBEA6A594CF141183707C84466C260E30B85F872AE833A6126E274C45D02F7095A6AD6DA6DCE29C265DF102CBE0EC38664988D372AB5334CB640B37799CCB60DE0AE2816EA5B21BE5CEAF8A49F90B52A518C6FF3355F47E02D705EB63ED011F6E7205463A5FDB1E172AE450859290FA7D018D83A91D102D701D0BD31054709F6CFE0B72A8FFDB9CB3344C
			m.lcFileBinary = m.lcFileBinary + 0h5AC3A94F1DD000090AFB910A0521FB50964CF49D42AC96EE5D96244B0999882A882B132BF6881C1236D435B0A9F7760F8510EAA69AA465C0E04EC69FFB9E66D028D04D4E31DF9C1A92EFBD3607FEE9CEC7263328E5D661D3D064F6CF452CD955ED7AB33CDB7B8B8AE889459B55CFB2029815B682569AF6AF29C239B75A5BB196345E6B64C28117973586C1BC214AE0D207E93FB0FF51E133FB71426FA8437E00B515C1B7064D0CC206A2FA926D3C902E907670048D931DB4C1A44959D3A6AD93B65AB6595F70A79BF33D616C2DD959FC7D4E63E7CD99CBCEC9C58B34766A61C7D6766CA5A9C1B32753148626D941C638C67CD52A7E78E2A3FBE0E81DB8E29F
			m.lcFileBinary = m.lcFileBinary + 0h31254D30C1672581A1F51C983C80E4B71CCDD2ADBF000000FFFF0300504B030414000600080000002100A1512698C10000001C01000023000000786C2F776F726B7368656574732F5F72656C732F7368656574312E62696E2E72656C736CCFC16AC3300C06E0FBA0EF60745F9CF430C68853D861906BE91E40B395C434968D654AF2F6F56DEDD8F197F83FA1FEB48555DD288B8F6CA06B5A50C4363ACFB381EFCBD7EB3B2829C80ED7C864602781D37078E9CFB462A925597C12551516034B29E9436BB10B05942626E2BA99620E586ACCB34E68AF38933EB6ED9BCE8F060C4FA61A9D813CBA0ED4654FF5F21F3B789BA3C4A93436061DA7C9DBFF54BDAD9F
			m.lcFileBinary = m.lcFileBinary + 0h9E31EF233BDAAA8579A662E0E777D83535801E7AFDF4D370070000FFFF0300504B030414000600080000002100A273D38D810000001601000018000000786C2F776F726B7368656574732F7368656574312E62696E6A646498CC287E928589C181010CFE430188338551002C8644B432327432CADD61461202EB4C411298C1A882220F946244928631BB1819DA18199E32F3806CE460D001AB99C8C8308991613A8B134415480C9B5E9819301A5D0D887F97994980E10EB3411A183CB387D1103D2FEC61B431185CB687D14D8C0C00000000FFFF0300504B0304140006000800000021001E06781015000000200000001E000000786C2F776F726B73686565
			m.lcFileBinary = m.lcFileBinary + 0h74732F62696E617279496E646578312E62696ED29260000205108106A632310011000000FFFF0300504B0304140006000800000021004B7C9F083E0100005102000011000801646F6350726F70732F636F72652E786D6C20A2040128A0000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
			m.lcFileBinary = m.lcFileBinary + 0h0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007C925F4BC33014C5DF05BF43C97B9B74835943DB81CA9E1C085614DF4272D7159B3F24D16EDFDEB4DD6A0743C84BEE39F7774F2EC9D707D9463F605DA35581D284A00814D7A2517581DEAA4D9CA1C879A6046BB582021DC1A175797B937343B9B6F062B501EB1B7051202947B929D0DE7B4331767C0F92B92438541077DA4AE6C3D5D6D830FEC56AC00B42565882678279867B606C26223A21059F90E6DBB6
			m.lcFileBinary = m.lcFileBinary + 0h0340700C2D4850DEE13449F19FD78395EE6AC3A0CC9CB2F14713DE748A3B670B3E8A93FBE09AC9D8755DD22D8718217F8A3FB6CFAFC353E346F5BBE280CA5C70CA2D30AF6D99E3F9252CAE65CE6FC38E770D888763D0AFD4041FE28E1010510840C7B867E57DF9F8546D50D9EF3026F771BAAA08A1C3F9EC475EF4F781C6823C0DFE9F98F54472572D085D66946433E21930E6BEFC04E52F000000FFFF0300504B0304140006000800000021006F7E771280010000FE02000010000801646F6350726F70732F6170702E786D6C20A2040128A00001000000000000000000000000000000000000000000000000000000000000000000000000000000000000
			m.lcFileBinary = m.lcFileBinary + 0h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009C92416BE3301085EF85FD0F46F7464E589625C82AA569E9614B0349B367551EC7228A64345393F4D7
			m.lcFileBinary = m.lcFileBinary + 0h776C93C6D9EDA93A8DE63D9E3E8DA46E0E7B9FB590D0C55088E9241719041B4B17B68578593F5CFF16199209A5F13140218E80E246FFB852CB141B48E400338E0858889AA8994B89B686BDC109CB81952AA6BD21DEA6AD8C55E52C2CA27DDB432039CBF35F120E04A184F2BAF90C1443E2BCA5EF8696D1767CB8591F1B06D6EAB669BCB386F896FAC9D914315694DD1F2C7825C7A262BA15D8B7E4E8A87325C75BB5B2C6C31D07EBCA780425CF0DF508A61BDAD2B8845AB5346FC1524C19BA771EDB4C64AF06A1C329446B92338118ABB30D9BBEF60D52D27F63DA610D40A8241B86665F8EBDE3DAFDD4D3DEC0C5A5B10B184058B8445C3BF280CFD5D224FA
			m.lcFileBinary = m.lcFileBinary + 0h82783A26EE1906DE0167D5F10D678EF9FA2BF349FF64FF7161872FCD3A2E0CC16976974DB5AA4D8292C77DD2CF0DF5C8634BBE0BB9AB4DD84279F2FC2F742FBD19BEB39ECE2639AFFE814F3D25CF1F577F000000FFFF0300504B01022D0014000600080000002100558086C16D010000020400001300000000000000000000000000000000005B436F6E74656E745F54797065735D2E786D6C504B01022D00140006000800000021004382E3C5F70000004C0200000B000000000000000000000000007B0300005F72656C732F2E72656C73504B01022D001400060008000000210006332055E50000002D0200001A00000000000000000000000000690600
			m.lcFileBinary = m.lcFileBinary + 0h00786C2F5F72656C732F776F726B626F6F6B2E62696E2E72656C73504B01022D0014000600080000002100A76734B792000000C00000000F000000000000000000000000008E080000786C2F776F726B626F6F6B2E62696E504B01022D0014000600080000002100F98F44D4E0000000CA0100000D000000000000000000000000004D090000786C2F7374796C65732E62696E504B01022D0014000600080000002100E9A625B882060000531B00001300000000000000000000000000580A0000786C2F7468656D652F7468656D65312E786D6C504B01022D0014000600080000002100A1512698C10000001C01000023000000000000000000000000000B
			m.lcFileBinary = m.lcFileBinary + 0h110000786C2F776F726B7368656574732F5F72656C732F7368656574312E62696E2E72656C73504B01022D0014000600080000002100A273D38D810000001601000018000000000000000000000000000D120000786C2F776F726B7368656574732F7368656574312E62696E504B01022D00140006000800000021001E06781015000000200000001E00000000000000000000000000C4120000786C2F776F726B7368656574732F62696E617279496E646578312E62696E504B01022D00140006000800000021004B7C9F083E01000051020000110000000000000000000000000015130000646F6350726F70732F636F72652E786D6C504B01022D001400
			m.lcFileBinary = m.lcFileBinary + 0h06000800000021006F7E771280010000FE02000010000000000000000000000000008A150000646F6350726F70732F6170702E786D6C504B0506000000000B000B00DB020000401800000000
		CASE m.lcExcelFileExtension = "XLSM"
			m.lcFileBinary = 0h504B03041400060008000000210038088E4F60010000F20300001300DB015B436F6E74656E745F54797065735D2E786D6C20A2D70128A00002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
			m.lcFileBinary = m.lcFileBinary + 0h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
			m.lcFileBinary = m.lcFileBinary + 0h0000000000000000000000000000A4934D6EC2301085F7957A87C8DB2A31745155158105A5CB96053D80B127C4C27FF2181A6EDF495290401481D838B2A279DFBC37E3D1A4B126DB4244ED5DC986C58065E0A457DAAD4AF6BDF8C85F59864938258C7750B21D209B8C1F1F468B5D00CCA8DA61C9EA94C21BE7286BB0020B1FC0D19FCA472B125DE38A0721D76205FC793078E1D2BB042EE5A9D560E3D1173510B5826C2E62FA149638BC313C911AF4E7B0203D964DFBC2965D321182D15224EA9C6F9D3AA1E6BEAAB404E5E5C612ABE8C49E5A15FE2F10D3CE00DE8DC2104128AC019235452FBA27BF4325362665B38612E8438F60F0366B7F611654D9D9C7
			m.lcFileBinary = m.lcFileBinary + 0h5A07BC40B89CDDE54C7E7C5C2FBD5F5F918AC51C1A0964B9B55E5821A39F39B134A0E8A2DDBEC373E3A639CDA30FC869AA57A08E37EC74D6D086AB40E5812421260D8774CEB169D55A975DD7C8BBCFFDFB76BC0407FDAB32903EC2ED21ECB7A2AD3EE39C772F76FC0B0000FFFF0300504B030414000600080000002100B5553023F50000004C0200000B00CE015F72656C732F2E72656C7320A2CA0128A000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
			m.lcFileBinary = m.lcFileBinary + 0h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
			m.lcFileBinary = m.lcFileBinary + 0h00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008C92CF4EC3300CC6EF48BC43E4FBEA6E4808A1A5BB4C48BB21541EC024EE1FB58DA32440F7F68403824A63DBD1F6E7CF3F5BDEEEE669541F1C622F4EC3BA2841B133627BD76A78AD9F560FA06222676914C71A8E1C6157DDDE6C5F78A4949B62D7FBA8B28B8B1ABA94FC2362341D4F140BF1EC72A5913051CA6168D19319A865DC94E53D86BF1E502D3CD5C16A08077B07AA3EFA3CF9B2
			m.lcFileBinary = m.lcFileBinary + 0hB7344D6F782FE67D62974E8C409E133BCB76E543660BA9CFDBA89A42CB498315F39CD311C9FB2263039E26DA5C4FF4FFB63871224B89D048E0F33CDF8A7340EBEB812E9F68A9F8BDCE3CE2A784E14D64F861C1C50F545F000000FFFF0300504B0304140006000800000021008D87DA70E00000002D0200001A000801786C2F5F72656C732F776F726B626F6F6B2E786D6C2E72656C7320A2040128A0000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
			m.lcFileBinary = m.lcFileBinary + 0h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000AC91CB6AC3301045F785FE83987D3D760AA594C8D99442B6C5FD00218F1FC496846692D67F5FE182DD404836D908AE06DD73246D773FE3A04E14B9F74E4391E5A0C8595FF7AED5F0557D3CBD826231AE368377A46122865DF9F8B0FDA4C1483A
			m.lcFileBinary = m.lcFileBinary + 0hC45D1F58A516C71A3A91F086C8B6A3D170E603B934697C1C8DA4185B0CC61E4C4BB8C9F3178CFF3BA03CEB54FB5A43DCD7CFA0AA2924F2ED6EDF34BDA5776F8F2339B98040966948175095892D8986BF9C2547C0CBF8CD3DF1929E8556FA1C715E8B6B0EC53D1DBE7D3C704724ABC7B2C5384F16193CFBE4F2170000FFFF0300504B030414000600080000002100A460FAFF52010000270200000F000000786C2F776F726B626F6F6B2E786D6C8C915D6FC2201486EF97EC3F10EE272DA9CE185B93655BE6CD6232A7D7AC9C5A228506A8D57FBF534CE776B72BCE073CE7BC2FCBD5B9D1E404CE2B6B729A4E124AC094562A73C8E9E7F6F5614E890FC248A1
			m.lcFileBinary = m.lcFileBinary + 0hAD819C5EC0D355717FB7ECAD3B7E597B2408303EA77508ED82315FD6D0083FB12D18EC54D6352260EA0ECCB70E84F435406834E34932638D50865E090BF71F86AD2A55C2B32DBB064CB8421C6811707D5FABD6D36259290DBBAB2222DAF65D34B8F75953A2850F2F52059039CD30B53DFC29B8AE7DEA941EBAD3644A59F12372E3085203B88D5327515ED0294A2454A2D3618B82C77958E719E7B3E1ED60CE4E41EF6F982125E7BD32D2F639E5199A7D19B31427923EB6F64A861A51D9FC567B0375A8434EE7499A0C74F60B1F2DC531F12426EAFD186CC625636D8D9230760B85815BCB3412C667A5D0250A1C8E78914F1F7954CFC63F2EBE010000FFFF03
			m.lcFileBinary = m.lcFileBinary + 0h00504B030414000600080000002100A083C4AEA3010000640300000D000000786C2F7374796C65732E786D6CA453C16ADC3010BD17F20F42F746BB0B0D6DB19D436121909440B6D0AB6CC95EC16864A4F1B2EED767643BDEDD530EBD584F4F336F9E66E4E2F1EC419C6C4C2E6029B7F71B292C36C138EC4AF9E7B0FFFA5D8A441A8D8680B694A34DF2B1BAFB52241AC1BE1DAD25C112984A7924EA7F2A959AA3F53ADD87DE229FB4217A4DBC8D9D4A7DB4DAA49CE441ED369B07E5B54359156D404AA2090312BB5888AA48FFC44903335BA9AAA20910A2209667231383DADB39E29706574797C35AED1D8C33BDCBC4E46889F30E43CCA4CA25972571920358
			m.lcFileBinary = m.lcFileBinary + 0h0DECB20126AAA2D74436E29E3762C187B1E7F2C8DD9865A6B84FA2BBA8C7EDEEDB55829A0A56451DA2E1EE5F5F7DA6AA026C4B6C34BAEE98570A3D7FEB40143C03E37417500343F591B100BE4E6301DEF284FEB637DAE756E0E0F79E9E4C2979D6B9091F902FB2C0596FDE64FD6BB559FBBF65C5B9BDD567C52BDB37A6D7F222CFBB94BFF39302B94A887A70400E6F05A7EBB3A6395F5AB0C913205DF3CBCDCD59AB70278C6DF50074580F4B79C12FD6B8C1FF58A35EDD29D02451CA0B7ECE93DA3E4C534EEBEF51BD030000FFFF0300504B030414000600080000002100E9A625B882060000531B000013000000786C2F7468656D652F7468656D65312E78
			m.lcFileBinary = m.lcFileBinary + 0h6D6CEC594F6FDB3614BF0FD87720746F6D27B61B07758AD8B19BAD4D1BC46E871E6999965853A240D2497D1BDAE38001C3BA619701BBED306C2BD002BB749F265B87AD03FA15F6484AB218CB4BD2061BD6D58744227F7CFFDFE32375F5DA8388A1432224E571DBAB5DAE7A88C43E1FD338687B7786FD4B1B1E920AC763CC784CDADE9C48EFDAD6FBEF5DC59B2A241141B03E969BB8ED854A259B958AF46118CBCB3C2131CC4DB888B082571154C6021F01DD8855D6AAD56625C234F6508C23207B7B32A13E41434DD2DBCA88F718BCC64AEA019F8981264D9C15063B9ED63442CE659709748859DB033E637E34240F948718960A26DA5ED5FCBCCAD6D50ADE
			m.lcFileBinary = m.lcFileBinary + 0h4C1731B5626D615DDFFCD275E982F174CDF014C128675AEBD75B577672FA06C0D432AED7EB757BB59C9E0160DF074DAD2C459AF5FE46AD93D12C80ECE332ED6EB551ADBBF802FDF525995B9D4EA7D14A65B1440DC83ED697F01BD5667D7BCDC11B90C53796F0F5CE76B7DB74F00664F1CD257CFF4AAB5977F10614321A4F97D0DAA1FD7E4A3D874C38DB2D856F007CA39AC2172888863CBA348B098FD5AA588BF07D2EFA00D04086158D919A2764827D88E22E8E468262CD006F125C98B143BE5C1AD2BC90F4054D54DBFB30C190110B7AAF9E7FFFEAF953F4EAF993E387CF8E1FFE74FCE8D1F1C31F2D2D67E12E8E83E2C297DF7EF6E7D71FA33F9E7EF3F2
			m.lcFileBinary = m.lcFileBinary + 0hF117E57859C4FFFAC327BFFCFC793910326821D18B2F9FFCF6ECC98BAF3EFDFDBBC725F06D814745F8904644A25BE4081DF0087433867125272371BE15C3105367050E817609E99E0A1DE0AD396665B80E718D775740F128035E9FDD77641D8462A66809E71B61E400F738671D2E4A0D7043F32A5878388B8372E66256C41D607C58C6BB8B63C7B5BD590255330B4AC7F6DD903862EE331C2B1C909828A4E7F8949012EDEE51EAD8758FFA824B3E51E81E451D4C4B4D32A4232790168B7669047E9997E90CAE766CB3771775382BD37A871CBA484808CC4A841F12E698F13A9E291C95911CE288150D7E13ABB04CC8C15CF8455C4F2AF074401847BD3191B2
			m.lcFileBinary = m.lcFileBinary + 0h6CCD6D01FA169C7E0343BD2A75FB1E9B472E52283A2DA37913735E44EEF06937C45152861DD0382C623F905308518CF6B92A83EF713743F43BF801C72BDD7D9712C7DDA717823B3470445A04889E9909ED4B28D44EFD8D68FC77C59851A8C63606DE15E3B6B70D5B53594AEC9E28C1AB70FFC1C2BB8367F13E81585FDE78DED5DD7775D77BEBEBEEAA5C3E6BB55D1458A8BDBA79B07DB1E992A3954DF28432365073466E4AD3274BD82CC67D18D4EBCC0191E487A62484C7B4B83BB84060B30609AE3EA22A1C8438811EBBE66922814C490712255CC2D9CE0C97D2D678E8D3953D1936F499C1D60389D51E1FDBE1753D9C1D0D723266CB09CCF93363B4AE09
			m.lcFileBinary = m.lcFileBinary + 0h9C95D9FA959428A8FD3ACC6A5AA83373AB19D14CA973B8E52A830F975583C1DC9AD08520E85DC0CA4D38A26BD67036C18C8CB5DDED069CB9C578E1225D24433C26A98FB4DECB3EAA192765B1622E0320764A7CA4CF79A758ADC0ADA5C9BE01B7B338A9C8AEBE825DE6BD37F15216C10B2FE9BC3D918E2C2E26278BD151DB6B35D61A1EF271D2F62670AC85C72801AF4BDDF86116C0DD90AF840DFB5393D964F9C29BAD4C3137096A705361EDBEA4B053071221D50E96A10D0D339586008B35272BFF5A03CC7A510AD8487F0D29D6372018FE3529C08EAE6BC964427C5574766144DBCEBEA6A594CF141183707C84466C260E30B85F872AE833A6126E274C45
			m.lcFileBinary = m.lcFileBinary + 0hD02F7095A6AD6DA6DCE29C265DF102CBE0EC38664988D372AB5334CB640B37799CCB60DE0AE2816EA5B21BE5CEAF8A49F90B52A518C6FF3355F47E02D705EB63ED011F6E7205463A5FDB1E172AE450859290FA7D018D83A91D102D701D0BD31054709F6CFE0B72A8FFDB9CB3344C5AC3A94F1DD000090AFB910A0521FB50964CF49D42AC96EE5D96244B0999882A882B132BF6881C1236D435B0A9F7760F8510EAA69AA465C0E04EC69FFB9E66D028D04D4E31DF9C1A92EFBD3607FEE9CEC7263328E5D661D3D064F6CF452CD955ED7AB33CDB7B8B8AE889459B55CFB2029815B682569AF6AF29C239B75A5BB196345E6B64C28117973586C1BC214AE0D207
			m.lcFileBinary = m.lcFileBinary + 0hE93FB0FF51E133FB71426FA8437E00B515C1B7064D0CC206A2FA926D3C902E907670048D931DB4C1A44959D3A6AD93B65AB6595F70A79BF33D616C2DD959FC7D4E63E7CD99CBCEC9C58B34766A61C7D6766CA5A9C1B32753148626D941C638C67CD52A7E78E2A3FBE0E81DB8E29F31254D30C1672581A1F51C983C80E4B71CCDD2ADBF000000FFFF0300504B030414000600080000002100075F38D31E010000C701000018000000786C2F776F726B7368656574732F7368656574312E786D6C8C514D6BC3300CBD0FF61F8CEE8BD38D6EA324298352B6C360ECEBEE2472626A5BC156D7EDDFCF496819F4B29B3EDE7BD2938AF5B7B3E20B4334E44B586439
			m.lcFileBinary = m.lcFileBinary + 0h08F40DB5C677257CBC6FAFEE414456BE55963C96F08311D6D5E54571A0B08B3D228BA4E063093DF3B09232363D3A15331AD0A78EA6E014A73474320E01553B919C95D7797E2B9D321E668555F88F06696D1ADC50B377E87916096815A7FD636F860855D19AD41B0D8980BA848705C8AA98C67E1A3CC43FB16055BFA1C586B14DEE418CAE6AA2DD087C4AA57CA4CA33EE7672F512448B5AED2DBFD2E1114DD77312599EA66D14AB441F5487CF2A74C6476151274C9EDD8108337E8A9986A9BA04511333B963D6A783613A4C9EDD80D0447C4CC6B54E2FA87E010000FFFF0300504B0304140006000800000021000ACFE8CF3F0100005102000011000801646F
			m.lcFileBinary = m.lcFileBinary + 0h6350726F70732F636F72652E786D6C20A2040128A0000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
			m.lcFileBinary = m.lcFileBinary + 0h0000000000000000000000000000000000000000000000007C92CB6AC3301045F785FE83D1DE969C904785ED405BB26AA0509794EE8434494CAD07925A277F5FD94E5C0742411BCDBD73E66A50B63ACA3AFA01EB2AAD7294260445A0B81695DAE7E8BD5CC74B1439CF9460B55690A31338B42AEEEF326E28D7165EAD36607D052E0A24E52837393A786F28C68E1F40329704870AE24E5BC97CB8DA3D368C7FB13DE00921732CC133C13CC32D303603119D91820F48F36DEB0E2038861A2428EF709AA4F8CFEBC14A77B3A153464E59F993096F3AC71DB305EFC5C17D74D5606C9A2669A65D8C903FC51F9B97B7EEA971A5DA5D7140452638E51698D7B6C8F0
			m.lcFileBinary = m.lcFileBinary + 0hF812165733E73761C7BB0AC4E329E8376A8277717B08882804A07DDC8BB29D3E3D976B54B43B8CC9439CCE4B4268773EDB9157FD6DA0BE20CF83FF272E5B2259941342A70B3A9B8D8817409FFBFA1314BF000000FFFF0300504B0304140006000800000021006F7E771280010000FE02000010000801646F6350726F70732F6170702E786D6C20A2040128A000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
			m.lcFileBinary = m.lcFileBinary + 0h00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009C92416BE3301085EF85FD0F46F7464E589625C82AA569E9614B0349B367551EC7228A64345393F4D7776C93C6D9EDA93A8DE63D9E3E8DA46E0E7B9FB590D0C55088E9241719041B4B17B68578593F5CFF16199209A5F13140218E80E246FFB852CB141B48E400338E0858889AA8994B
			m.lcFileBinary = m.lcFileBinary + 0h89B686BDC109CB81952AA6BD21DEA6AD8C55E52C2CA27DDB432039CBF35F120E04A184F2BAF90C1443E2BCA5EF8696D1767CB8591F1B06D6EAB669BCB386F896FAC9D914315694DD1F2C7825C7A262BA15D8B7E4E8A87325C75BB5B2C6C31D07EBCA780425CF0DF508A61BDAD2B8845AB5346FC1524C19BA771EDB4C64AF06A1C329446B92338118ABB30D9BBEF60D52D27F63DA610D40A8241B86665F8EBDE3DAFDD4D3DEC0C5A5B10B184058B8445C3BF280CFD5D224FA82783A26EE1906DE0167D5F10D678EF9FA2BF349FF64FF7161872FCD3A2E0CC16976974DB5AA4D8292C77DD2CF0DF5C8634BBE0BB9AB4DD84279F2FC2F742FBD19BEB39ECE2639
			m.lcFileBinary = m.lcFileBinary + 0hAFFE814F3D25CF1F577F000000FFFF0300504B01022D001400060008000000210038088E4F60010000F20300001300000000000000000000000000000000005B436F6E74656E745F54797065735D2E786D6C504B01022D0014000600080000002100B5553023F50000004C0200000B000000000000000000000000006C0300005F72656C732F2E72656C73504B01022D00140006000800000021008D87DA70E00000002D0200001A0000000000000000000000000058060000786C2F5F72656C732F776F726B626F6F6B2E786D6C2E72656C73504B01022D0014000600080000002100A460FAFF52010000270200000F000000000000000000000000007808
			m.lcFileBinary = m.lcFileBinary + 0h0000786C2F776F726B626F6F6B2E786D6C504B01022D0014000600080000002100A083C4AEA3010000640300000D00000000000000000000000000F7090000786C2F7374796C65732E786D6C504B01022D0014000600080000002100E9A625B882060000531B00001300000000000000000000000000C50B0000786C2F7468656D652F7468656D65312E786D6C504B01022D0014000600080000002100075F38D31E010000C7010000180000000000000000000000000078120000786C2F776F726B7368656574732F7368656574312E786D6C504B01022D00140006000800000021000ACFE8CF3F010000510200001100000000000000000000000000CC13
			m.lcFileBinary = m.lcFileBinary + 0h0000646F6350726F70732F636F72652E786D6C504B01022D00140006000800000021006F7E771280010000FE020000100000000000000000000000000042160000646F6350726F70732F6170702E786D6C504B050600000000090009003E020000F81800000000
		OTHERWISE && XLS
			m.lcFileBinary = 0hD0CF11E0A1B11AE1000000000000000000000000000000003E000300FEFF0900060000000000000000000000010000000100000000000000001000001A00000001000000FEFFFFFF0000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
			m.lcFileBinary = m.lcFileBinary + 0hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
			m.lcFileBinary = m.lcFileBinary + 0hFFFFFDFFFFFF1C000000030000000400000005000000060000000700000008000000090000000A0000000B0000000C0000000D0000000E0000000F00000010000000110000001200000013000000140000001500000016000000170000001800000019000000FEFFFFFFFEFFFFFF1D000000FEFFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
			m.lcFileBinary = m.lcFileBinary + 0hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
			m.lcFileBinary = m.lcFileBinary + 0hFFFFFFFF52006F006F007400200045006E00740072007900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000016000500FFFFFFFFFFFFFFFF020000002008020000000000C00000000000004600000000000000000000000030C843AA2911C9011B000000800200000000000057006F0072006B0062006F006F006B000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001200020104000000FFFFFFFFFFFFFFFF00000000000000000000000000000000000000000000000000000000000000000000000002000000892F00
			m.lcFileBinary = m.lcFileBinary + 0h00000000000500530075006D006D0061007200790049006E0066006F0072006D006100740069006F006E000000000000000000000000000000000000000000000000000000280002010100000003000000FFFFFFFF00000000000000000000000000000000000000000000000000000000000000000000000000000000C800000000000000050044006F00630075006D0065006E007400530075006D006D0061007200790049006E0066006F0072006D006100740069006F006E000000000000000000000038000201FFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000000000000000000000000000000000000000000004000000E000
			m.lcFileBinary = m.lcFileBinary + 0h0000000000000908100000060500A91FCD07C100010006040000E1000200B004C10002000000E20000005C0070000200002020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202042000200B004610102000000C00100003D01020001009C0002001000190002000000120002000000130002000000AF0102000000BC01020000003D001200F0006900D5394A1F380000000000010058024000020000008D00020000002200020000
			m.lcFileBinary = m.lcFileBinary + 0h000E0002000100B70102000000DA000200000031001E00DC000000080090010000000200AA0701430061006C00690062007200690031001E00DC000000080090010000000200AA0701430061006C00690062007200690031001E00DC000000080090010000000200AA0701430061006C00690062007200690031001E00DC000000080090010000000200AA0701430061006C00690062007200690031001E00DC000000080090010000000200AA0701430061006C00690062007200690031001E00680101003800BC020000000200AA0701430061006D00620072006900610031001E002C0101003800BC020000000200AA0701430061006C00690062007200
			m.lcFileBinary = m.lcFileBinary + 0h690031001E00040101003800BC020000000200AA0701430061006C00690062007200690031001E00DC0001003800BC020000000200AA0701430061006C00690062007200690031001E00DC000000110090010000000200AA0701430061006C00690062007200690031001E00DC000000140090010000000200AA0701430061006C00690062007200690031001E00DC0000003C0090010000000200AA0701430061006C00690062007200690031001E00DC0000003E0090010000000200AA0701430061006C00690062007200690031001E00DC0001003F00BC020000000200AA0701430061006C00690062007200690031001E00DC0001003400BC02000000
			m.lcFileBinary = m.lcFileBinary + 0h0200AA0701430061006C00690062007200690031001E00DC000000340090010000000200AA0701430061006C00690062007200690031001E00DC0001000900BC020000000200AA0701430061006C00690062007200690031001E00DC0000000A0090010000000200AA0701430061006C00690062007200690031001E00DC000200170090010000000200AA0701430061006C00690062007200690031001E00DC0001000800BC020000000200AA0701430061006C00690062007200690031001E00DC000000090090010000000200AA0701430061006C0069006200720069001E041C000500170000222422232C2323305F293B5C28222422232C2323305C29
			m.lcFileBinary = m.lcFileBinary + 0h1E04210006001C0000222422232C2323305F293B5B5265645D5C28222422232C2323305C291E04220007001D0000222422232C2323302E30305F293B5C28222422232C2323302E30305C291E0427000800220000222422232C2323302E30305F293B5B5265645D5C28222422232C2323302E30305C291E0437002A003200005F282224222A20232C2323305F293B5F282224222A205C28232C2323305C293B5F282224222A20222D225F293B5F28405F291E042E0029002900005F282A20232C2323305F293B5F282A205C28232C2323305C293B5F282A20222D225F293B5F28405F291E043F002C003A00005F282224222A20232C2323302E30305F293B5F
			m.lcFileBinary = m.lcFileBinary + 0h282224222A205C28232C2323302E30305C293B5F282224222A20222D223F3F5F293B5F28405F291E0436002B003100005F282A20232C2323302E30305F293B5F282A205C28232C2323302E30305C293B5F282A20222D223F3F5F293B5F28405F29E000140000000000F5FF200000000000000000000000C020E000140000000000F5FF200000000000000000000000C020E000140000000000F5FF200000000000000000000000C020E000140000000000F5FF200000000000000000000000C020E000140000000000F5FF200000000000000000000000C020E000140000000000F5FF200000000000000000000000C020E000140000000000F5FF20000000
			m.lcFileBinary = m.lcFileBinary + 0h0000000000000000C020E000140000000000F5FF200000000000000000000000C020E000140000000000F5FF200000000000000000000000C020E000140000000000F5FF200000000000000000000000C020E000140000000000F5FF200000000000000000000000C020E000140000000000F5FF200000000000000000000000C020E000140000000000F5FF200000000000000000000000C020E000140000000000F5FF200000000000000000000000C020E000140000000000F5FF200000000000000000000000C020E0001400000000000100200000000000000000000002C020E000140005000000F5FF200000B400000000000000049F20E000140005
			m.lcFileBinary = m.lcFileBinary + 0h000000F5FF200000B40000000000000004AD20E000140005000000F5FF200000B40000000000000004AA20E000140005000000F5FF200000B40000000000000004AE20E000140005000000F5FF200000B400000000000000049B20E000140005000000F5FF200000B40000000000000004AF20E000140005000000F5FF200000B40000000000000004AC20E000140005000000F5FF200000B400000000000000049D20E000140005000000F5FF200000B400000000000000048B20E000140005000000F5FF200000B40000000000000004AE20E000140005000000F5FF200000B40000000000000004AC20E000140005000000F5FF200000B4000000000000
			m.lcFileBinary = m.lcFileBinary + 0h0004B320E000140015000000F5FF200000B400000000000000049E20E000140015000000F5FF200000B400000000000000049D20E000140015000000F5FF200000B400000000000000048B20E000140015000000F5FF200000B40000000000000004A420E000140015000000F5FF200000B40000000000000004B120E000140015000000F5FF200000B40000000000000004B420E000140015000000F5FF200000B40000000000000004BE20E000140015000000F5FF200000B400000000000000048A20E000140015000000F5FF200000B40000000000000004B920E000140015000000F5FF200000B40000000000000004A420E000140015000000F5FF20
			m.lcFileBinary = m.lcFileBinary + 0h0000B40000000000000004B120E000140015000000F5FF200000B40000000000000004B520E00014000B000000F5FF200000B40000000000000004AD20E00014000F000000F5FF200000941111970B970B00049620E000140011000000F5FF200000946666BF1FBF1F0004B720E000140005002B00F5FF200000F80000000000000000C020E000140005002900F5FF200000F80000000000000000C020E000140005002C00F5FF200000F80000000000000000C020E000140005002A00F5FF200000F80000000000000000C020E000140013000000F5FF200000F40000000000000000C020E00014000A000000F5FF200000B40000000000000004AA20E000
			m.lcFileBinary = m.lcFileBinary + 0h140007000000F5FF200000D400500000001F0000C020E000140008000000F5FF200000D400500000000B0000C020E000140009000000F5FF200000D400200000000F0000C020E000140009000000F5FF200000F40000000000000000C020E00014000D000000F5FF200000941111970B970B0004AF20E000140010000000F5FF200000D400600000001A0000C020E00014000C000000F5FF200000B40000000000000004AB20E000140005000000F5FF2000009C1111160B160B00049A20E00014000E000000F5FF200000941111BF1FBF1F00049620E000140005000900F5FF200000F80000000000000000C020E000140006000000F5FF200000F4000000
			m.lcFileBinary = m.lcFileBinary + 0h0000000000C020E000140014000000F5FF200000D4006100003E1F0000C020E000140012000000F5FF200000F40000000000000000C0207C0814007C080000000000000000000000003E00DED9EE787D082D007D080000000000000000000000000000000002000D001400030000000100000030305C293B5F282A0E000500027D082D007D080000000000000000000000000100000002000D001400030000000100000030305C293B5F282A0E000500027D082D007D080000000000000000000000000200000002000D001400030000000100000030305C293B5F282A0E000500027D082D007D080000000000000000000000000300000002000D00140003
			m.lcFileBinary = m.lcFileBinary + 0h0000000100000030305C293B5F282A0E000500027D082D007D080000000000000000000000000400000002000D001400030000000100000030305C293B5F282A0E000500027D082D007D080000000000000000000000000500000002000D001400030000000100000030305C293B5F282A0E000500027D082D007D080000000000000000000000000600000002000D001400030000000100000030305C293B5F282A0E000500027D082D007D080000000000000000000000000700000002000D001400030000000100000030305C293B5F282A0E000500027D082D007D080000000000000000000000000800000002000D001400030000000100000030305C
			m.lcFileBinary = m.lcFileBinary + 0h293B5F282A0E000500027D082D007D080000000000000000000000000900000002000D001400030000000100000030305C293B5F282A0E000500027D082D007D080000000000000000000000000A00000002000D001400030000000100000030305C293B5F282A0E000500027D082D007D080000000000000000000000000B00000002000D001400030000000100000030305C293B5F282A0E000500027D082D007D080000000000000000000000000C00000002000D001400030000000100000030305C293B5F282A0E000500027D082D007D080000000000000000000000000D00000002000D001400030000000100000030305C293B5F282A0E00050002
			m.lcFileBinary = m.lcFileBinary + 0h7D082D007D080000000000000000000000000E00000002000D001400030000000100000030305C293B5F282A0E000500027D082D007D080000000000000000000000000F00000002000D001400030000000100000030305C293B5F282A0E000500027D082D007D080000000000000000000000002B00000002000D001400030000000100000030305C293B5F282A0E000500027D082D007D080000000000000000000000002C00000002000D001400030000000100000030305C293B5F282A0E000500027D082D007D080000000000000000000000002D00000002000D001400030000000100000030305C293B5F282A0E000500027D082D007D0800000000
			m.lcFileBinary = m.lcFileBinary + 0h00000000000000002E00000002000D001400030000000100000030305C293B5F282A0E000500027D082D007D080000000000000000000000003A00000002000D001400030000000100000030305C293B5F282A0E000500027D082D007D080000000000000000000000003B00000002000D001400030000000300000030305C293B5F282A0E000500017D0841007D080000000000000000000000003100000003000D001400030000000300000030305C293B5F282A0E000500020800140003000000040000003B5F28405F2920207D0841007D080000000000000000000000003200000003000D001400030000000300000030305C293B5F282A0E00050002
			m.lcFileBinary = m.lcFileBinary + 0h080014000300FF3F040000003B5F28405F2920207D0841007D080000000000000000000000003300000003000D001400030000000300000030305C293B5F282A0E000500020800140003003233040000003B5F28405F2920207D082D007D080000000000000000000000003400000002000D001400030000000300000030305C293B5F282A0E000500027D0841007D080000000000000000000000003000000003000D00140002000000006100FF30305C293B5F282A0E000500020400140002000000C6EFCEFF3B5F28405F2920207D0841007D080000000000000000000000002800000003000D001400020000009C0006FF30305C293B5F282A0E000500
			m.lcFileBinary = m.lcFileBinary + 0h020400140002000000FFC7CEFF3B5F28405F2920207D0841007D080000000000000000000000003700000003000D001400020000009C6500FF30305C293B5F282A0E000500020400140002000000FFEB9CFF3B5F28405F2920207D0891007D080000000000000000000000003500000007000D001400020000003F3F76FF30305C293B5F282A0E000500020400140002000000FFCC99FF3B5F28405F29202007001400020000007F7F7FFF202020202020202008001400020000007F7F7FFF202020202020202009001400020000007F7F7FFF00000000000000000A001400020000007F7F7FFF00000000000000007D0891007D0800000000000000000000
			m.lcFileBinary = m.lcFileBinary + 0h00003900000007000D001400020000003F3F3FFF30305C293B5F282A0E000500020400140002000000F2F2F2FF3B5F28405F29202007001400020000003F3F3FFF202020202020202008001400020000003F3F3FFF202020202020202009001400020000003F3F3FFF00000000000000000A001400020000003F3F3FFF00000000000000007D0891007D080000000000000000000000002900000007000D00140002000000FA7D00FF30305C293B5F282A0E000500020400140002000000F2F2F2FF3B5F28405F29202007001400020000007F7F7FFF202020202020202008001400020000007F7F7FFF202020202020202009001400020000007F7F7FFF00
			m.lcFileBinary = m.lcFileBinary + 0h000000000000000A001400020000007F7F7FFF00000000000000007D0841007D080000000000000000000000003600000003000D00140002000000FA7D00FF30305C293B5F282A0E000500020800140002000000FF8001FF3B5F28405F2920207D0891007D080000000000000000000000002A00000007000D001400030000000000000030305C293B5F282A0E000500020400140002000000A5A5A5FF3B5F28405F29202007001400020000003F3F3FFF202020202020202008001400020000003F3F3FFF202020202020202009001400020000003F3F3FFF00000000000000000A001400020000003F3F3FFF00000000000000007D082D007D0800000000
			m.lcFileBinary = m.lcFileBinary + 0h00000000000000003D00000002000D00140002000000FF0000FF30305C293B5F282A0E000500027D0891007D080000000000000000000000003800000007000D001400030000000100000030305C293B5F282A0E000500020400140002000000FFFFCCFF3B5F28405F2920200700140002000000B2B2B2FF20202020202020200800140002000000B2B2B2FF20202020202020200900140002000000B2B2B2FF00000000000000000A00140002000000B2B2B2FF00000000000000007D082D007D080000000000000000000000002F00000002000D001400020000007F7F7FFF30305C293B5F282A0E000500027D0855007D08000000000000000000000000
			m.lcFileBinary = m.lcFileBinary + 0h3C00000004000D001400030000000100000030305C293B5F282A0E000500020700140003000000040000003B5F28405F29202008001400030000000400000020202020202020207D0841007D080000000000000000000000002200000003000D001400030000000000000030305C293B5F282A0E000500020400140003000000040000003B5F28405F2920207D0841007D080000000000000000000000001000000003000D001400030000000100000030305C293B5F282A0E000500020400140003006566040000003B5F28405F2920207D0841007D080000000000000000000000001600000003000D001400030000000100000030305C293B5F282A0E00
			m.lcFileBinary = m.lcFileBinary + 0h050002040014000300CC4C040000003B5F28405F2920207D0841007D080000000000000000000000001C00000003000D001400030000000000000030305C293B5F282A0E000500020400140003003233040000003B5F28405F2920207D0841007D080000000000000000000000002300000003000D001400030000000000000030305C293B5F282A0E000500020400140003000000050000003B5F28405F2920207D0841007D080000000000000000000000001100000003000D001400030000000100000030305C293B5F282A0E000500020400140003006566050000003B5F28405F2920207D0841007D080000000000000000000000001700000003000D
			m.lcFileBinary = m.lcFileBinary + 0h001400030000000100000030305C293B5F282A0E00050002040014000300CC4C050000003B5F28405F2920207D0841007D080000000000000000000000001D00000003000D001400030000000000000030305C293B5F282A0E000500020400140003003233050000003B5F28405F2920207D0841007D080000000000000000000000002400000003000D001400030000000000000030305C293B5F282A0E000500020400140003000000060000003B5F28405F2920207D0841007D080000000000000000000000001200000003000D001400030000000100000030305C293B5F282A0E000500020400140003006566060000003B5F28405F2920207D084100
			m.lcFileBinary = m.lcFileBinary + 0h7D080000000000000000000000001800000003000D001400030000000100000030305C293B5F282A0E00050002040014000300CC4C060000003B5F28405F2920207D0841007D080000000000000000000000001E00000003000D001400030000000000000030305C293B5F282A0E000500020400140003003233060000003B5F28405F2920207D0841007D080000000000000000000000002500000003000D001400030000000000000030305C293B5F282A0E000500020400140003000000070000003B5F28405F2920207D0841007D080000000000000000000000001300000003000D001400030000000100000030305C293B5F282A0E00050002040014
			m.lcFileBinary = m.lcFileBinary + 0h0003006566070000003B5F28405F2920207D0841007D080000000000000000000000001900000003000D001400030000000100000030305C293B5F282A0E00050002040014000300CC4C070000003B5F28405F2920207D0841007D080000000000000000000000001F00000003000D001400030000000000000030305C293B5F282A0E000500020400140003003233070000003B5F28405F2920207D0841007D080000000000000000000000002600000003000D001400030000000000000030305C293B5F282A0E000500020400140003000000080000003B5F28405F2920207D0841007D080000000000000000000000001400000003000D001400030000
			m.lcFileBinary = m.lcFileBinary + 0h000100000030305C293B5F282A0E000500020400140003006566080000003B5F28405F2920207D0841007D080000000000000000000000001A00000003000D001400030000000100000030305C293B5F282A0E00050002040014000300CC4C080000003B5F28405F2920207D0841007D080000000000000000000000002000000003000D001400030000000000000030305C293B5F282A0E000500020400140003003233080000003B5F28405F2920207D0841007D080000000000000000000000002700000003000D001400030000000000000030305C293B5F282A0E000500020400140003000000090000003B5F28405F2920207D0841007D0800000000
			m.lcFileBinary = m.lcFileBinary + 0h00000000000000001500000003000D001400030000000100000030305C293B5F282A0E000500020400140003006566090000003B5F28405F2920207D0841007D080000000000000000000000001B00000003000D001400030000000100000030305C293B5F282A0E00050002040014000300CC4C090000003B5F28405F2920207D0841007D080000000000000000000000002100000003000D001400030000000000000030305C293B5F282A0E000500020400140003003233090000003B5F28405F2920209302120010000D0000323025202D20416363656E743192084D0092080000000000000000000001041EFF0D0032003000250020002D0020004100
			m.lcFileBinary = m.lcFileBinary + 0h6300630065006E00740031000000030001000C0007046566DBE5F1FF05000C0007010000000000FF25000500029302120011000D0000323025202D20416363656E743292084D00920800000000000000000000010422FF0D0032003000250020002D00200041006300630065006E00740032000000030001000C0007056566F2DDDCFF05000C0007010000000000FF25000500029302120012000D0000323025202D20416363656E743392084D00920800000000000000000000010426FF0D0032003000250020002D00200041006300630065006E00740033000000030001000C0007066566EAF1DDFF05000C0007010000000000FF250005000293021200
			m.lcFileBinary = m.lcFileBinary + 0h13000D0000323025202D20416363656E743492084D0092080000000000000000000001042AFF0D0032003000250020002D00200041006300630065006E00740034000000030001000C0007076566E5E0ECFF05000C0007010000000000FF25000500029302120014000D0000323025202D20416363656E743592084D0092080000000000000000000001042EFF0D0032003000250020002D00200041006300630065006E00740035000000030001000C0007086566DBEEF3FF05000C0007010000000000FF25000500029302120015000D0000323025202D20416363656E743692084D00920800000000000000000000010432FF0D0032003000250020002D
			m.lcFileBinary = m.lcFileBinary + 0h00200041006300630065006E00740036000000030001000C0007096566FDE9D9FF05000C0007010000000000FF25000500029302120016000D0000343025202D20416363656E743192084D0092080000000000000000000001041FFF0D0034003000250020002D00200041006300630065006E00740031000000030001000C000704CC4CB8CCE4FF05000C0007010000000000FF25000500029302120017000D0000343025202D20416363656E743292084D00920800000000000000000000010423FF0D0034003000250020002D00200041006300630065006E00740032000000030001000C000705CC4CE6B9B8FF05000C0007010000000000FF25000500
			m.lcFileBinary = m.lcFileBinary + 0h029302120018000D0000343025202D20416363656E743392084D00920800000000000000000000010427FF0D0034003000250020002D00200041006300630065006E00740033000000030001000C000706CC4CD7E4BCFF05000C0007010000000000FF25000500029302120019000D0000343025202D20416363656E743492084D0092080000000000000000000001042BFF0D0034003000250020002D00200041006300630065006E00740034000000030001000C000707CC4CCCC0DAFF05000C0007010000000000FF2500050002930212001A000D0000343025202D20416363656E743592084D0092080000000000000000000001042FFF0D0034003000
			m.lcFileBinary = m.lcFileBinary + 0h250020002D00200041006300630065006E00740035000000030001000C000708CC4CB6DDE8FF05000C0007010000000000FF2500050002930212001B000D0000343025202D20416363656E743692084D00920800000000000000000000010433FF0D0034003000250020002D00200041006300630065006E00740036000000030001000C000709CC4CFCD5B4FF05000C0007010000000000FF2500050002930212001C000D0000363025202D20416363656E743192084D00920800000000000000000000010420FF0D0036003000250020002D00200041006300630065006E00740031000000030001000C000704323395B3D7FF05000C0007000000FFFFFF
			m.lcFileBinary = m.lcFileBinary + 0hFF2500050002930212001D000D0000363025202D20416363656E743292084D00920800000000000000000000010424FF0D0036003000250020002D00200041006300630065006E00740032000000030001000C0007053233D99795FF05000C0007000000FFFFFFFF2500050002930212001E000D0000363025202D20416363656E743392084D00920800000000000000000000010428FF0D0036003000250020002D00200041006300630065006E00740033000000030001000C0007063233C2D69AFF05000C0007000000FFFFFFFF2500050002930212001F000D0000363025202D20416363656E743492084D0092080000000000000000000001042CFF0D
			m.lcFileBinary = m.lcFileBinary + 0h0036003000250020002D00200041006300630065006E00740034000000030001000C0007073233B2A1C7FF05000C0007000000FFFFFFFF25000500029302120020000D0000363025202D20416363656E743592084D00920800000000000000000000010430FF0D0036003000250020002D00200041006300630065006E00740035000000030001000C000708323393CDDDFF05000C0007000000FFFFFFFF25000500029302120021000D0000363025202D20416363656E743692084D00920800000000000000000000010434FF0D0036003000250020002D00200041006300630065006E00740036000000030001000C0007093233FAC090FF05000C000700
			m.lcFileBinary = m.lcFileBinary + 0h0000FFFFFFFF250005000293020C002200070000416363656E74319208410092080000000000000000000001041DFF070041006300630065006E00740031000000030001000C00070400004F81BDFF05000C0007000000FFFFFFFF250005000293020C002300070000416363656E743292084100920800000000000000000000010421FF070041006300630065006E00740032000000030001000C0007050000C0504DFF05000C0007000000FFFFFFFF250005000293020C002400070000416363656E743392084100920800000000000000000000010425FF070041006300630065006E00740033000000030001000C00070600009BBB59FF05000C000700
			m.lcFileBinary = m.lcFileBinary + 0h0000FFFFFFFF250005000293020C002500070000416363656E743492084100920800000000000000000000010429FF070041006300630065006E00740034000000030001000C00070700008064A2FF05000C0007000000FFFFFFFF250005000293020C002600070000416363656E74359208410092080000000000000000000001042DFF070041006300630065006E00740035000000030001000C00070800004BACC6FF05000C0007000000FFFFFFFF250005000293020C002700070000416363656E743692084100920800000000000000000000010431FF070041006300630065006E00740036000000030001000C0007090000F79646FF05000C000700
			m.lcFileBinary = m.lcFileBinary + 0h0000FFFFFFFF25000500029302080028000300004261649208390092080000000000000000000001011BFF03004200610064000000030001000C0005FF0000FFC7CEFF05000C0005FF00009C0006FF25000500029302100029000B000043616C63756C6174696F6E92088100920800000000000000000000010216FF0B00430061006C00630075006C006100740069006F006E000000070001000C0005FF0000F2F2F2FF05000C0005FF0000FA7D00FF250005000206000E0005FF00007F7F7FFF010007000E0005FF00007F7F7FFF010008000E0005FF00007F7F7FFF010009000E0005FF00007F7F7FFF010093020F002A000A0000436865636B2043656C
			m.lcFileBinary = m.lcFileBinary + 0h6C92087F00920800000000000000000000010217FF0A0043006800650063006B002000430065006C006C000000070001000C0005FF0000A5A5A5FF05000C0007000000FFFFFFFF250005000206000E0005FF00003F3F3FFF060007000E0005FF00003F3F3FFF060008000E0005FF00003F3F3FFF060009000E0005FF00003F3F3FFF0600930204002B8003FF92082000920800000000000000000000010503FF050043006F006D006D00610000000000930204002C8006FF92082800920800000000000000000000010506FF090043006F006D006D00610020005B0030005D0000000000930204002D8004FF92082600920800000000000000000000010504
			m.lcFileBinary = m.lcFileBinary + 0hFF0800430075007200720065006E006300790000000000930204002E8007FF92082E00920800000000000000000000010507FF0C00430075007200720065006E006300790020005B0030005D0000000000930215002F001000004578706C616E61746F7279205465787492084700920800000000000000000000010235FF10004500780070006C0061006E00610074006F0072007900200054006500780074000000020005000C0005FF00007F7F7FFF2500050002930209003000040000476F6F6492083B0092080000000000000000000001011AFF040047006F006F0064000000030001000C0005FF0000C6EFCEFF05000C0005FF0000006100FF250005
			m.lcFileBinary = m.lcFileBinary + 0h000293020E00310009000048656164696E67203192084700920800000000000000000000010310FF0900480065006100640069006E006700200031000000030005000C00070300001F497DFF250005000207000E00070400004F81BDFF050093020E00320009000048656164696E67203292084700920800000000000000000000010311FF0900480065006100640069006E006700200032000000030005000C00070300001F497DFF250005000207000E000704FF3FA8C0DEFF050093020E00330009000048656164696E67203392084700920800000000000000000000010312FF0900480065006100640069006E006700200033000000030005000C0007
			m.lcFileBinary = m.lcFileBinary + 0h0300001F497DFF250005000207000E000704323395B3D7FF020093020E00340009000048656164696E67203492083900920800000000000000000000010313FF0900480065006100640069006E006700200034000000020005000C00070300001F497DFF250005000293020A003500050000496E70757492087500920800000000000000000000010214FF050049006E007000750074000000070001000C0005FF0000FFCC99FF05000C0005FF00003F3F76FF250005000206000E0005FF00007F7F7FFF010007000E0005FF00007F7F7FFF010008000E0005FF00007F7F7FFF010009000E0005FF00007F7F7FFF01009302100036000B00004C696E6B6564
			m.lcFileBinary = m.lcFileBinary + 0h2043656C6C92084B00920800000000000000000000010218FF0B004C0069006E006B00650064002000430065006C006C000000030005000C0005FF0000FA7D00FF250005000207000E0005FF0000FF8001FF060093020C0037000700004E65757472616C9208410092080000000000000000000001011CFF07004E00650075007400720061006C000000030001000C0005FF0000FFEB9CFF05000C0005FF00009C6500FF250005000293020400008000FF92083300920800000000000000000000010100FF06004E006F0072006D0061006C000000020005000C0007010000000000FF25000500029302090038000400004E6F746592086200920800000000
			m.lcFileBinary = m.lcFileBinary + 0h00000000000001020AFF04004E006F00740065000000050001000C0005FF0000FFFFCCFF06000E0005FF0000B2B2B2FF010007000E0005FF0000B2B2B2FF010008000E0005FF0000B2B2B2FF010009000E0005FF0000B2B2B2FF010093020B0039000600004F757470757492087700920800000000000000000000010215FF06004F00750074007000750074000000070001000C0005FF0000F2F2F2FF05000C0005FF00003F3F3FFF250005000206000E0005FF00003F3F3FFF010007000E0005FF00003F3F3FFF010008000E0005FF00003F3F3FFF010009000E0005FF00003F3F3FFF0100930204003A8005FF9208240092080000000000000000000001
			m.lcFileBinary = m.lcFileBinary + 0h0505FF0700500065007200630065006E0074000000000093020A003B000500005469746C659208310092080000000000000000000001030FFF05005400690074006C0065000000020005000C00070300001F497DFF250005000193020A003C00050000546F74616C92084D00920800000000000000000000010319FF050054006F00740061006C000000040005000C0007010000000000FF250005000206000E00070400004F81BDFF010007000E00070400004F81BDFF0600930211003D000C00005761726E696E67205465787492083F0092080000000000000000000001020BFF0C005700610072006E0069006E00670020005400650078007400000002
			m.lcFileBinary = m.lcFileBinary + 0h0005000C0005FF0000FF0000FF25000500028E0858008E080000000000000000000090000000110011005400610062006C0065005300740079006C0065004D0065006400690075006D0039005000690076006F0074005300740079006C0065004C0069006700680074003100360060010200000085000E00032E0000000006005368656574319A0818009A0800000000000000000000010000000000000001000000A3081000A30800000000000000000000000000008C00040001000100C1010800C10100001DEB0100FC0008000000000000000000FF00020008006308160063080000000000000000000016000000040000000200960810009608000000
			m.lcFileBinary = m.lcFileBinary + 0h0000000000000042E501009B0810009B0800000000000000000000010000008C0810008C0800000000000000000000000000000A0000000908100000061000A91FCD07C1000100060400000B021000000000000000000000000000152F00000D00020001000C00020064000F000200010011000200000010000800FCA9F1D24D62503F5F00020001002A00020000002B00020000008200020001008000080000000000000000002502040000002C0181000200C104140000001500000083000200000084000200000026000800666666666666E63F27000800666666666666E63F28000800000000000000E83F29000800000000000000E83FA10022000000
			m.lcFileBinary = m.lcFileBinary + 0h2C01010001000100040042E50100333333333333D33F333333333333D33F74009C0826009C0800000000000000000000000000000000000000000000000000003C33000000000000000055000200080000020E0000000000000000000000000000003E021200B606000000004000000000000000000000008B0810008B0800000000000000000000000002001D000F0003000000000000010000000000000067081700670800000000000000000000020001FFFFFFFF034400000A0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
			m.lcFileBinary = m.lcFileBinary + 0h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000200000003000000FEFFFFFF050000000600000007000000FEFFFFFF09000000FEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
			m.lcFileBinary = m.lcFileBinary + 0hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
			m.lcFileBinary = m.lcFileBinary + 0hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFF0000060002000000000000000000000000000000000001000000E0859FF2F94F6810AB9108002B27B3D930000000980000000700000001000000400000000400000048000000080000005400000012000000600000000C000000780000000D00000084000000130000009000000002000000E40400001E00000004000000000000001E00000004000000000000001E000000100000004D6963726F736F667420457863656C004000000000C07C0D23D9C601400000000086FCA92911C90103000000000000
			m.lcFileBinary = m.lcFileBinary + 0h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000FEFF000006000200000000000000000000000000000000000100000002D5CDD59C2E1B10939708002B2CF9AE30000000B000000008000000010000004800000017000000500000000B000000580000001000000060000000130000006800000016000000700000000D000000780000000C0000008B00000002000000E40400000300000000000C000B000000000000000B000000000000000B000000000000000B000000000000001E1000000100000007000000536865657431000C100000020000001E0000
			m.lcFileBinary = m.lcFileBinary + 0h000B000000576F726B73686565747300030000000100000000000000000000000000000000000000000000000000000000000000000000000000010043006F006D0070004F0062006A0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012000200FFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000000000000000000000000000000000000000000000000800000072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000FF
			m.lcFileBinary = m.lcFileBinary + 0hFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
			m.lcFileBinary = m.lcFileBinary + 0hFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100FEFF030A0000FFFFFFFF2008020000000000C000000000000046260000004D6963726F736F6674204F666669636520457863656C203230303320576F726B736865657400060000004269666638000E000000457863656C2E53686565742E3800F439B271000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
			m.lcFileBinary = m.lcFileBinary + 0h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
			m.lcFileBinary = m.lcFileBinary + 0h0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
		ENDCASE
		IF !EMPTY(m.lcFileBinary)
			IF STRTOFILE(m.lcFileBinary, m.tcExcelFile, 0) > 0
				m.llReturn = .T.
			ENDIF
		ENDIF
	ENDIF
	RETURN m.llReturn
ENDFUNC
*******************
PROCEDURE SetMemory
*******************
LOCAL lnAvailableMem, lpMemoryStatus, lnPct

* Running on the desktop
DECLARE GlobalMemoryStatus IN Win32API STRING @lpMemoryStatus
lpMemoryStatus = REPLICATE(CHR(0), 32)
GlobalMemoryStatus(@lpMemoryStatus)

lnAvailableMem = CharToBin(SUBSTR(lpMemoryStatus, 13, 4))

*** EGL: 11/30/98 - Added the fine tuning option
lnPct = 1
IF TYPE("goApp.nSetMemoryPct") == "N"
	lnPct = goApp.nSetMemoryPct
ENDIF
lnAvailableMem = (lnAvailableMem * lnPct)

SYS(3050, 1, lnAvailableMem)
SYS(3050, 2, (lnAvailableMem/2) )

RETURN lnAvailableMem

********************************
PROCEDURE Calc_TotRows_Excel
*********************************
PARAMETERS PsExcelFile,PsSheet
*-----------------------------------
* AUTHOR: Trevor Hancock
* CREATED: 02/15/08 04:55:31 PM
* ABSTRACT: Code demonstrates how to connect to
* and extract data from an Excel 2007 Workbook
* using the "Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)"
* from the 2007 Office System Driver: Data Connectivity Components
*-----------------------------------
IF VARTYPE(PsExcelFile)<>'C'
	RETURN -1
ENDIF
IF PARAMETERS()=2
	IF VARTYPE(PsSheet)<>'C'
		RETURN -2
	ENDIF
ENDIF
IF PARAMETERS()<2
	PsSheet ='Hoja1'
ENDIF
IF EMPTY(PsSheet)
	PsSheet ='Hoja1'
ENDIF
LOCAL lcXLBook AS STRING, lnSQLHand AS INTEGER, ;
    lcSQLCmd AS STRING, lnSuccess AS INTEGER, ;
    lcConnstr AS STRING
CLEAR

lcXLBook = PsExcelFile && [C:\SampleWorkbook.xlsx]

lcConnstr = [Driver=] + ;
    [{Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};] + ;
    [DBQ=] + lcXLBook

IF !FILE( lcXLBook )
    =MESSAGEBOX([Archivo Excel no encontrado],16,'Atención / Warning!')
    RETURN -4
ENDIF
*-- Attempt a connection to the .XLSX WorkBook.
*-- NOTE: If the specified workbook is not found,
*-- it will be created by this driver! You cannot rely on a
*-- connection failure - it will never fail. Ergo, success
*-- is not checked here. Used FILE() instead.
lnSQLHand = SQLSTRINGCONNECT( lcConnstr )

*-- Connect successful if we are here. Extract data...
lcSQLCmd = [Select * FROM "]+PsSheet+[$"]
lnSuccess = SQLEXEC( lnSQLHand, lcSQLCmd, [xlResults] )
*!*	? [SQL Cmd Success:], IIF( lnSuccess > 0, 'Good!', 'Failed' )
IF lnSuccess < 0
    LOCAL ARRAY laErr[1]
    AERROR( laErr )
    =MESSAGEBOX(laErr(3),16,'Error de conexión')
    SQLDISCONNECT( lnSQLHand )
    RETURN -3
ENDIF


*-- Show the results
SELECT xlResults
*!*	BROWSE NOWAIT
LnTotalReg	= RECCOUNT()
SQLDISCONNECT( lnSQLHand )
RETURN LnTotalReg


***************************
FUNCTION CharToBin (tcWord)
***************************
	LOCAL lnChar, lnWord
	lnWord = 0
	FOR lnChar = 1 TO LEN(tcWord)
		lnWord = lnWord + (ASC(SUBSTR(tcWord, lnChar, 1)) * (2 ^ (8 * (lnChar - 1))))
	ENDFOR

	RETURN lnWord
ENDFUNC
********************
Procedure Loader_Exe
********************
* Programa Lanzador (genérico).
LOCAL lcExecPath, lcFileName, lcSkeleton, lnFileCount
LOCAL lcExe, ltLatest, lnI
LOCAL ARRAY laFiles(1)
* Toma la ruta del directorio del archivo ejecutable
lcExecPath = JUSTPATH(SYS(16))
* Establece este directorio como predeterminado (Default)
SET DEFAULT TO (lcExecPath)
* Toma la raíz del nombre del archivo ejecutable
lcFileName = JUSTSTEM(SYS(16))
* Crea una matriz con los nombres de los EXEs posibles
lcSkeleton = lcFileName+"??.EXE"
&& lcSkeleton es un archivo comodín
&& para ADIR()
lnFileCount = ADIR(laFiles,lcSkeleton)
* Busca el archive EXE más reciente
lcEXE = ""
ltLatest = {}
FOR lnI = 1 TO lnFileCount
  IF FDATE(laFiles(lnI,1),1) > ltLatest
    ltLatest = FDATE(laFiles(lnI,1),1)
    lcExe = laFiles(lnI,1)
  ENDIF
ENDFOR
* Lanza la ejecución del EXE más reciente.
IF NOT EMPTY(lcExe)
  DO (lcEXE)
ENDIF
***********************************************************************
FUNCTION OPEN_FILE(pcFileName,pcAction,pcParams,pcDefDir,pnShowWindow ) 
*********************************************************************** 
* Filename 
If Vartype(pcFileName) <> "C" 
        MessageBox("Need a file to open!") 
        Return 0 
Endif 
* Action 
If Vartype(pcAction) <> "C" 
        pcAction = "open" 
Endif 
* Parameters 
If Vartype(pcParams) <> "C" 
        pcParams = "" 
ENDIF 
* Default Directory 
If Vartype(pcDefDir) <> "C" 
        pcDefDir = ADDBS(SYS(5)+CURDIR()) 
ENDIF 
* Show Window (min / Max etc) 
If Vartype(pnShowWindow) <> "N" 
        pnShowWindow = 1 
Endif 
#Define SE_ERR_FNF 2 
#Define SE_ERR_PNF 3 
#Define SE_ERR_ACCESSDENIED 5 
#Define SE_ERR_OOM 8 
#Define SE_ERR_DLLNOTFOUND 32 
#Define SE_ERR_SHARE 26 
#Define SE_ERR_ASSOCINCOMPLETE 27 
#Define SE_ERR_DDETIMEOUT 28 
#Define SE_ERR_DDEFAIL 29 
#Define SE_ERR_DDEBUSY 30 
#Define SE_ERR_NOASSOC 31 
#Define ERROR_BAD_FORMAT 11 
Declare Integer ShellExecute In shell32.Dll ; 
INTEGER hndWin, ; 
STRING cAction, ; 
STRING cFileName, ; 
STRING cParams, ; 
STRING cDir, ; 
INTEGER nShowWin 
cFileName = pcFileName 
cAction = pcAction 
cParams = pcParams 
cDir = pcDefDir 
nShowWin = pnShowWindow 
Local lnRetVal 
lnRetVal = 0 
lnRetVal = ShellExecute(0,cAction,cFileName,cParams,cDir,nShowWin) 
If lnRetVal <= 32 
        Local msg 
        msg = "" 
        *There was an error 
        Do Case 
                Case lnRetVal = SE_ERR_FNF 
                        msg = "File not found" 
                Case lnRetVal = SE_ERR_PNF 
                        msg = "Path not found" 
                Case lnRetVal = SE_ERR_ACCESSDENIED 
                        msg = "Access denied" 
                Case lnRetVal = SE_ERR_OOM 
                        msg = "Out of memory" 
                Case lnRetVal = SE_ERR_DLLNOTFOUND 
                        msg = "DLL not found" 
                Case lnRetVal = SE_ERR_SHARE 
                        msg = "A sharing violation occurred" 
                Case lnRetVal = SE_ERR_ASSOCINCOMPLETE 
                        msg = "Incomplete or invalid file association" 
                Case lnRetVal = SE_ERR_DDETIMEOUT 
                        msg = "DDE Time out" 
                Case lnRetVal = SE_ERR_DDEFAIL 
                        msg = "DDE transaction failed" 
                Case lnRetVal = SE_ERR_DDEBUSY 
                        msg = "DDE busy" 
                Case lnRetVal = SE_ERR_NOASSOC 
                        msg = "No association for file extension" 
                Case lnRetVal = ERROR_BAD_FORMAT 
                        msg = "Invalid EXE file or error in EXE image" 
                Otherwise 
                        msg = "Unknown error" 
        Endcase 
        RETURN .F. 
Else 
        Return .T. 
Endif 
ENDFUNC 

FUNCTION Parser_Sql
Lparameters cCmd


** Author: Rafael Copquin (Buenos Aires, Argentina)

** February 2012


** this function analizes a sql-insert statement which uses the NAME clause and converts it into
** an insert command that can be used with the SQLEXEC function to insert it directly into a SQL Server table


** example:

** select curCustomers                                      && VFP cursor
** scatter name oCustomers memo fields except idcustomers   && (autoincremental pk field. It should 
**                                                              be avoided because it is readonly)
** cCmd = 'insert into customers from name oCustomers'      && insert into SQL Server table command 
** cCmd = thisform.parser(cCmd,'customers')                 && parse the above statement  
** sqlexec(thisform.nHandle,cCmd)                           && use sqlexec function 



Local nArea,cSQL,cName,N,nPos,cObject,vValue

nArea = Select()

cSQL = ''
For i = 1 to GetWordCount(cCmd)
    
    cName = GetWordNum(cCmd,i)	                          && locate the NAME word in the insert sentence
    
    If Lower(cName) = 'name'
       N=At('name',cCmd)                                  && calculate the position of the word 'name'
    endif
EndFor

If N > 0
   nPos = At('from',cCmd)		                 && obtain the position of the word 'from'
   cSQL = Left(Alltrim(cCmd),nPos-1)+'('	         && from the beginning to the word FROM,ie:'insert into customers( '
   cObject = GetWordNum(cCmd,GetWordCount(cCmd))         && object, ie: oCustomers
endif 

AMembers(aFields,&cObject)			 && put into the aFields array all field names contained in oCustomers

For i = 1 to Alen(aFields,1)
    cSQL = cSQL + aFields(i)+[,] 
EndFor

** the following will result in "insert into customers('acc,company....' values("

cSQL = Substr(cSQL,1,Len(cSQL)-1)+') values('  


For i = 1 to Alen(aFields,1)

   cStatement = cObject+[.]+aFields(i)   && example: oCustomers.acc , oCustomers.company, etc
 
   vValue = Evaluate(cStatement)         && reads the contents of the field inside the object  
   
   
   ** adds the values for the rest of the VALUE clause according to their type
   
   Do case
      Case Vartype(vValue) = 'C'
           If Empty(vValue)
              cSQL = cSQL+['']+[,] 
           else
              cSQL = cSQL+[']+Alltrim(vValue)+[']+[,] 
           endif   
      Case InList(Vartype(vValue),'N','I')
           If vValue = 0
              cSQL = cSQL+'0'+[,]
           else
              cSQL = cSQL+Transform(vValue)+[,]          
           endif  
      Case Vartype(vValue) = 'L'
           cSQL = cSQL + Iif(vValue,'1','0')+[,]
      Case Vartype(vValue) = 'D'
           cValue = Dtos(vValue)
           vValue = [']+Left(cValue,2)+'-'+Substr(cValue,5,2)+'-'+Right(cValue,2)+[']+[,]
           cSQL = cSQL + vValue
      Case Vartype(vValue) = 'T'
           vValue = 'getdate()'+[,]
           cSQL = cSQL + vValue
      Case Vartype(vValue) = 'M'
           If Empty(vValue)
              cSQL = cSQL+['']+[,] 
           else
              cSQL = cSQL+[']+Alltrim(vValue)+[']+[,] 
           endif   
           
           
   endcase
EndFor

cSQL = Substr(cSQL,1,Len(cSQL)-1)+')'

** result: insert into customers(acc,company,....) values('1234','JOHN DOE LTD',....)

Select (nArea)

Return cSQL

*-------------------------------------------------
*** DBF_EXCEL PROGRAM *** Written by: Sumit Kumar Saha ***
*-------------------------------------------------

PROCEDURE dbf_excel
* Allows user to export tables in excel
CLOSE TABLES ALL
SET SAFETY ON
LOCAL liIndex, liMaxLength, liMaxLength1, liNumberOfFields, liNumberOfFields1, liPosition

mtext1 = "WELCOME - EXPORTING TABLES TO EXCEL"
mtext2 = "Press any key to continue and N to return"
DO head_

DO transaction_excel 

CLEAR
SET SAFETY OFF
RETURN
*** eof <dbf_excel> ***

PROCEDURE transaction_excel
* -------------------------
LOCAL lcOutFile, i, lcFi2, lcField, lcInFile
LOCAL lnNoOfFields, lnField, lcFieldName, lcFieldName1, lcFieldName2,lcfi, lcFi1
LOCAL ARRAY laStructure [1]

lcOutFile = " "
lcOutFile = GETFILE("DBF")

IF ISBLANK(lcOutFile)
	WAIT WINDOW "No File selected, the program will quit"
	RETURN
ENDIF

USE &lcOutFile IN 0 ALIAS mytable
lnNoOfFields = AFIELDS(laStructure, 'mytable')
USE
CREATE CURSOR csrExcelData FROM ARRAY laStructure

* If a table has autoincrement field, 
* so the following lines are added to verify and change
FOR nCount = 1 TO lnNoOfFields
	IF laStructure(nCount,18) > 0       && step for autoincrementing
		lfield = laStructure(nCount,1)  && name of the field
		ALTER table csrexceldata alter COLUMN &lfield N(20)  && field is changed to normal numeric
	ENDIF
ENDFOR

SELECT * FROM &lcOutFile ;
	INTO CURSOR csrTestData

i = 0
FOR lnField = 1 TO lnNoOfFields
	IF laStructure [lnField,2] = "M"
		i = i+1
		lcFieldName = ALLTRIM(laStructure[lnField,1])
		lcfi = 'lcFieldName'+ALLTRIM(STR(i))
		&lcfi = lcFieldName
		ALTER table csrExcelData DROP (lcFieldName)
*!*			WAIT WINDOW 'The memo field name is '+lcFieldName

	ENDIF
ENDFOR

FOR lnField = 1 TO i
	lcFi1 = 'lcFieldName'+ALLTRIM(STR(lnField))
	lcFieldName = &lcfi1
	WAIT WINDOW "The memo field name is "+ lcFieldName
	SELECT MAX( LEN(&lcfieldName) ) AS LargestEntry FROM ;
		&lcOutFile INTO CURSOR QUERY1

	liMaxLength1 = QUERY1.LargestEntry
	WAIT WINDOW "The maximum length is "+TRANSFORM(liMaxLength1)
	IF liMaxLength1 > 250
		liNumberOfFields1 = ROUND( liMaxLength1/250,0 )
		IF MOD(liMaxLength1, 250) > 0
			liNumberOfFields1 = liNumberOfFields1+1
		ENDIF
	ELSE
		liNumberOfFields1 = 1
	ENDIF
	*** Adding fields to the cursor as per number of fields computed ***
	IF 	liNumberOfFields1 > 1
		FOR liIndex = 1 TO liNumberOfFields1
			lcFi2 = (lcFieldName)+ALLTRIM(STR(liIndex))			
			ALTER TABLE csrExcelData ADD (lcFi2) c(250)
		ENDFOR
	ELSE
		lcFi2 = (lcFieldName) + "1"
		ALTER TABLE csrExcelData ADD (lcFi2) c(liMaxLength1)
	ENDIF

ENDFOR

SELECT csrTestData
SCAN

	SELECT csrTestData
	SCATTER MEMO MEMVAR
	INSERT INTO csrExcelData FROM memvar
	
	FOR lnField = 1 TO lnNoOfFields
		IF laStructure [lnField,2] = "M"
			lcFieldName = ALLTRIM(laStructure[lnField,1])
			lcFi1 = &lcFieldName			
			liLength = LEN(m.lcFi1)          && how many characters			
*!*				WAIT WINDOW 'The memo field name is lcFieldName i.e.'+lcFieldName NOWAIT
*!*				WAIT WINDOW "the length of the lcFi is "+ TRANSFORM(liLength) NOWAIT

			SELECT csrExcelData

			IF liLength <= 250
				lcField = (lcFieldName) + '1'
				WAIT WINDOW "The name of the lcfield is inside <=250 is "+lcField NOWAIT
				REPLACE &lcField WITH m.lcFi1
			ELSE
				liCommentLength = ROUND( (liLength/250 ),0 )
				IF MOD(liLength, 250) > 0
					liCommentLength = liCommentLength+1
				ENDIF
				liPosition = 1           && substring begins here
				* convert single memo field into blocks of 250 characters 
				* which will fit a vfp field

				FOR liIndex = 1 TO liCommentLength       && comment1, comment2, etc.           
					lcField = (lcFieldName) + ALLTRIM(STR(liIndex))
					WAIT WINDOW 'The memo field name within >250 is '+lcField NOWAIT
*!*						SUBSTR(cExpression, nStartPosition [, nCharactersReturned])
					REPLACE &lcField WITH SUBSTR(m.lcfi1,liPosition,250) IN csrExcelData
					*-- Get the next 250 characters
					liPosition = liPosition + 250
				ENDFOR
			ENDIF

		ENDIF
	ENDFOR
ENDSCAN

* For the save as dialog
lcInFile = PUTFILE("Excel File",lcOutFile,"XLS")
IF EMPTY(lcInFile)
	MESSAGEBOX('Specify Export File Name '+CHR(13)+'No file created')
	RETURN
ENDIF

SELECT csrExcelData
COPY TO (lcInFile) TYPE XLS
CLOSE TABLES ALL

*!*	WAIT WINDOW "The file to be opened is "+lcInfile
DO xlsopen WITH JUSTFNAME(lcInFile)   && refer lib3.prg for xlsopen procedure

RETURN
*** eop <transaction_excel> ***

PROCEDURE xlsopen
*----------------
#DEFINE xlMaximized -4137
#DEFINE xlLastCell 11      && added on 15/04/2010

LPARAMETERS lcOutFile

LOCAL loExcel as Excel.Application
LOCAL loWorkBook as Excel.Workbook
LOCAL loActiveSheet as Excel.Sheets
LOCAL loRange as Excel.Range
LOCAL lError, lcFileName

lError = .F.
lcFileName = SYS(5)+SYS(2003)+"\"+lcOutFile
*!*	WAIT WINDOW lcFileName

loExcel = CREATEOBJECT("Excel.Application")
* Added on 15/04/2010
* open the workbook you just created
loExcel.SheetsInNewWorkBook = 1
loWorkbook = loExcel.Workbooks.Open(lcFileName)
loActiveSheet = loExcel.ActiveSheet

* Rename the Sheet to whatever you like, if you want
*!*	loActiveSheet.Name = "MyData"
* ----------------------------------------------

loExcelApp = loExcel.Application
loExcelApp.WindowState = xlMaximized

* -----------------------------
** Added on 15/04/2010
* Find address of last occupied cell
lcLastCell = loExcel.ActiveCell.SpecialCells(xlLastCell).Address()
* Resize all columns
lnMarker1 = at("$",lcLastCell,1)  && i.e. 1 when lcLastCell = "$AF$105"
lnMarker2 = at("$",lcLastCell,2)  && i.e. 4 when lcLastCell = "$AF$105"
lnStartPos = lnMarker1 + 1
lnStrLen = lnMarker2 - lnStartPos
loExcel.Columns("A:" + SUBSTR ;
  (lcLastCell,lnStartPos,lnStrLen)).EntireColumn.AutoFit
* -----------------------------

loExcel.visible = .T.
RETURN
* eop * < xlsopen >

PROCEDURE head_
*--------------
IF MESSAGEBOX(mtext1,36,'yesno') != 6
	RETURN to master
ENDIF
RETURN
* eop <head_> *
****************
FUNCTION GetSpecial
****************
* Returns the path to one of Windows' "special folders", 
* such as My Documents, Application Data, Program Files, 
* etc.

* Parameters:
* - The folder's CSIDL;
* - A flag to say the folder should be created if it
*   doesn't already exist.

* Returns the path to the specified folder. If the CLSID
* is invalid, or the folder doesn't exist (and the second
* parameter is .F.), returns an empty string.
LPARAMETERS tnFolder, tlCreate
*!*	SET STEP ON 
LOCAL lcPath, lnPidl, lnPidlOK, lnFolderOK

#DEFINE MAX_PATH 260
#DEFINE CREATE_FLAG 32768 

* Delcare the API functions
DECLARE LONG SHGetSpecialFolderLocation IN shell32 ;
	LONG Hwnd, LONG lnFolder, LONG @pPidl
DECLARE LONG SHGetPathFromIDList IN shell32 ;
	LONG pPidl, STRING @pszPath
DECLARE CoTaskMemFree IN ole32 LONG pVoid

lcPath = SPACE(MAX_PATH)
lnPidl = 0

* If .T. is passed as second param, we want to create the 
* folder if it doesn't already exist.
IF tlCreate
	tnFolder = tnFolder + CREATE_FLAG
ENDIF 
	
* Get the PIDL
lnPidlOK = SHGetSpecialFolderLocation(0, tnFolder, @lnPidl)

IF lnPidlOK = 0
  * Pidl found OK; get the folder
  lnFolderOK = SHGetPathFromIDList(lnPidl, @lcPath)
  IF lnFolderOK = 1
    * Folder found OK; trim the string at the null terminator
    lcPath = LEFT(lcPath, AT(CHR(0), lcPath) - 1)
  ENDIF 
ENDIF 

* Free the ID List
CoTaskMemFree(lnPidl)
RETURN ALLTRIM(lcPath)
*!*	--------------------------------------------------------------------------------------
*!*	CSIDL
*!*	(decimal) 	Description 			Typical values
*!*	--------------------------------------------------------------------------------------
*!*	5	My Documents		C:\Documents and Settings\username\My Documents
*!*							C:\Users\username\Documents
*!*	6	Favorites			C:\Documents and Settings\username\Favorites
*!*							C:\Users\IserName\Favorites
*!*	8	Recent Documents	C:\Documents and Settings\username\Recent
*!*	9	Send To			C:\Documents and Settings\username\SendTo
*!*	13	My Music			C:\Documents and Settings\User\My Documents\My Music
*!*							C:\Users\UserName\Music
*!*	14	My Videos			C:\Documents and Settings\User\My Documents\My Videos
*!*							C:\Users\UserName\Videos
*!*	16	Desktop			C:\Documents and Settings\username\Desktop
*!*							C:\Users\username\Desktop
*!*	19	Network Neighborhood	C:\Documents and Settings\username\NetHood
*!*	20	Fonts					C:\Windows\Fonts
*!*	26	Application Data	C:\Documents and Settings\username\Application Data
*!*							C:\Users\username\AppData\Roaming
*!*	28	Local (non-roaming) application data	C:\Documents and Settings\username\Local Settings\Application Data
*!*												C:\Users\username\AppData\Local
*!*	33	Cookies	C:\Documents and Settings\username\Cookies
*!*	35	Common Application Data	C:\Documents and Settings\All Users\Application Data
*!*									C:\ProgramData
*!*	36	Windows	C:\Windows
*!*	37	System		C:\Windows\System32
*!*	38	Program Files	C:\Program Files
*!*	39	My Pictures		C:\Documents and Settings\User\My Documents\My Pictures
*!*						C:\Users\UserName\Pictures  
*!*	43	Common Files	C:\Program Files\Common


FUNCTION EsUnaLetra
PARAMETERS PsCaracter
IF VARTYPE(PsCaracter)<>'C'
	RETURN .F.
ENDIF
LlMinusculas	=	(ASC(LEFT(PsCaracter,1))>=97 and ASC(LEFT(PsCaracter,1))<=122)
LlMayusculas	=	(ASC(LEFT(PsCaracter,1))>=65 and ASC(LEFT(PsCaracter,1))<=90)
RETURN  LlMinusculas OR LlMayusculas 

************************
FUNCTION Report2BMP
************************
Local oListener As ReportListener, nPageIndex
oListener = Createobject("ReportListener")
oListener.ListenerType = 3

cRutaReporte=GETFILE("frx",'Nombre/Ruta:','Abrir',1,'Localizar reporte') && HOME(2)+"Solution\Reports\invoice.frx"

Report Form (cRutaReporte) Preview Object oListener

For nPageIndex=1 To oListener.PageTotal
    cOutputFile = "c:\tmp"+Trans(nPageIndex)+".bmp"
    oListener.OutputPage(nPageIndex,;
    cOutputFile, 105, 0,0,768,1024) && 105=bitmap
NEXT
*****************************
FUNCTION CheckVersionApp
*****************************
***** Comprueba Nueva Version  *******

AGETFILEVERSION(ServerApp,"\\miservidor")
Version_Mayor = VAL(SUBSTR(ServerApp(4),1,1))
Version_Menor = VAL(SUBSTR(ServerApp(4),3,AT(ServerApp(4),".",1) + 1))
Version_Mantension = VAL(SUBSTR(ServerApp(4),5,2) )

AGETFILEVERSION(MiApp,"C:\Archivos de programa\CDP\CDP.exe")
MiVersion_Mayor = VAL(SUBSTR(miapp(4),1,1))
MiVersion_Menor = VAL(SUBSTR(miapp(4),3,AT(miapp(4),".",1) + 1))
MiVersion_Mantension = VAL(SUBSTR(miapp(4),5,2) )
*
IF !(MiVersion_Mayor = Version_Mayor.AND.MiVersion_Menor = Version_Menor ;
.AND.MiVersion_Mantension = Version_Mantension)
  **** Actualizar
  ** Si soy yo copia al servidor
  IF UPPER(ALLTRIM(SUBSTR(SYS(0),AT("#",SYS(0),1) + 1,LEN(SYS(0))))) = "miUsername"
    MESSAGEBOX("Las Versiones Son: ServerApp -> " + ServerApp(4) + CHR(13) + ;
      "Local App. ->" + miApp(4) + CHR(13) + "Actualizando el Servidor")

    RUN /N "C:\Archivos de programa\CDP\UPLOAD.BAT"
  ELSE

    SET DEFAULT TO "C:\Archivos de programa\CDP"
    RUN /N "ACTUALIZA.BAT"
    QUIT
  ENDIF
ENDIF

***** Fin Comprobacion de Actualizacion

*!*	Contenido del archivo ACTUALIZA.BAT

*!*	@ECHO OFF
*!*	@ECHO Actualizando Sistema xxxxxxx
*!*	@ECHO AUTOR.: Ludwig Corales M.
*!*	@ECHO Actualizado al : %DATE%
*!*	@xCopy \\soft\CDP.EXE "C:\Archivos de programa\CDP" /C /R /Y

***** Fin Contenido **********

***** Contenido del archivo UPLOAD.BAT ******

*!*	@ECHO OFF
*!*	@ECHO Actualizando Sistema xxxxxxx
*!*	@ECHO AUTOR.: Ludwig Corales M.
*!*	@ECHO Actualizado al Servidor : %DATE%
*!*	@xCopy "C:\Archivos de programa\CDP\CDP.exe" \\soft\  /C /R /Y

***** Fin Contenido **********


* Programmer:	Michael J. Babcock
* Date:			2017-08-14
* Purpose:		My loader code to keep the client workstation updated with the latest version from a central network location.  The app's local INI file holds the location of the network Inno update.exe and compares that version to this local version and runs if newer (using version #).

* Here's a copy/paste from FabNet, called from my Main.prg:

PROCEDURE CheckForNewerVersion()
	LOCAL lcServerVersion as String, lcLocalVersion as String, lcLANFile as String, loData as _dataVersions OF .\progs\_dataVersions.prg, ;
			loShell as _ShellExecute OF HOME()+"ffc\environ.vcx", loRec as Object, llUpdateLAN as Logical, llMissing as Logical, lcLANVersion as String
	LOCAL ARRAY laInfo[1]
	lcLocalVersion = _screen.cversion && SetVersion()
	lcLANFile = ReadINI("General","SetupFile",'')
	loShell = NEWOBJECT("_ShellExecute", "_environ.vcx")

	*** mjb 09/18/2015 - updated for Admin user, plus grabbing EXE from cloud
	*** mjb 02/17/2016 - DEV NOTE:  This needs work yet to grab latest installer from web database and put in lcLANFile location; will finish later
	IF NOT EMPTY(lcLANFile) THEN
		WAIT WINDOW NOWAIT "Checking master source for latest update..."
		loData = NEWOBJECT("_dataVersions",".\progs\_dataVersions.prg")
		*** mjb 02/17/2016 - moved this next IF block outside the next IF block after that so as to get lcLANVersion for the 3rd IF block
		IF FILE(lcLANFile) THEN && see if LAN version is the cLatestVersion
			lcLANVersion = GetVersion(lcLANFile)
			CopyInstallerLocally(lcLANFile,ALLTRIM(lcLANVersion)) && mjb 05-11-16
			* oUtils.oClient.cLatestVersion allowed me to control what latest version the client could get if desired
			llUpdateLAN = loData.ConvertVersionToNumber(lcLANVersion) <> loData.ConvertVersionToNumber(oUtils.oClient.cLatestVersion)
		ELSE && update LAN with latest from web database
			llMissing = .T.
			llUpdateLAN = .T.
		ENDIF
		*** mjb 02/17/2016 - added iNetwork = 1 to only run this IF block for MBSS Cloud clients
		IF oUtils.iNetwork = 1 AND loData.ConvertVersionToNumber(lcLocalVersion) < loData.ConvertVersionToNumber(oUtils.oClient.cLatestVersion) THEN && verify update exe's version is as expected
			*** mjb 12/28/2015 - added check to only run this for PRODUCTION run
			IF oUtils.oConnection.Descript = "Production" AND llUpdateLAN THEN
				*** mjb 12/18/2015 - for now, just alert them
				IF llMissing THEN
					MESSAGEBOX("Your network installation file appears to be missing.  This is not critical; this just allows you to have your computers update from a common spot on your network rather than the internet.  Contact MBSS if you need assistance.",16,"Update file missing")
				ELSE
					MESSAGEBOX("Your network installation file (" + ALLTRIM(lcLANFile) + ") appears to be outdated (version " + ALLTRIM(lcLANVersion) + ").  Contact MBSS if you need assistance.",48,"Update file out of date")
				ENDIF && llMissing
			ENDIF && llUpdateLAN
		ENDIF && loData.ConvertVersionToNumber(lcLocalVersion) < loData.ConvertVersionToNumber(oUtils.oClient.cLatestVersion)

		IF FILE(lcLANFile) THEN
			lcServerVersion = GetVersion(lcLANFile)
			IF NOT EMPTY(lcServerVersion) THEN
				IF lcServerVersion > lcLocalVersion THEN
					IF MESSAGEBOX("An update is available for this application (version" + " " + lcServerVersion + ").  Do you want to upgrade?",4+32+0,"Upgrade available.") = 6 THEN && launch setup from server and quit this app
						*** mjb 02/17/2016 - changed next line to lcLANFile instead of lcFile
						loShell.ShellExecute(FULLPATH(lcLANFile))
						RELEASE loShell
						oUtils.Shutdown_System() && mjb 05-13-16 was QUIT
					ENDIF && msgbox = 6
				ENDIF && lcServerVersion > lcLocalVersion
			ELSE
				SET STEP ON
			ENDIF && NOT EMPTY(lcServerVersion)
		ENDIF && FILE(lcLANFile)
	ENDIF && NOT EMPTY(lcLANFile)
ENDPROC && CheckForNewerVersion()


FUNCTION SetVersion() as String
* This sets the version of the EXE for easy reference elsewhere.
	LOCAL laVersion(9), lcVersion as String, lnLevel as Integer, lcLastApp as String
	STORE 0 to laVersion
	STORE 1 TO lnLevel
	STORE "" TO lcLastApp
	DO WHILE LEN(SYS(16,lnLevel)) != 0
	   IF !INLIST(LEFT(UPPER(SYS(16,lnLevel)),4),"PROC","FUNC") AND UPPER(JUSTEXT(SYS(16,lnLevel))) = "EXE" THEN 
	     STORE SYS(16,lnLevel) TO lcLastApp
	   ENDIF && !INLIST(LEFT(UPPER(SYS(16,lnLevel)),4),"PROC","FUNC")
	   STORE lnLevel + 1 TO lnLevel
	ENDDO

	IF !EMPTY(lcLastApp) AND agetfileversion(laVersion,lcLastApp) > 0 THEN 
		lcVersion = laVersion(4)
	ELSE 
		SET STEP ON 
		lcVersion = "unknown" && mjb 10-30-14 changed to "unknown" since recursion failed
	ENDIF 	
	ADDPROPERTY(_screen,"cVersion",lcVersion)
	RETURN lcVersion
ENDFUNC && SetVersion() as String


FUNCTION GetVersion(tcFile as String) as String
*** mjb 09/24/2015 - created to quickly check version # on files
	LOCAL ARRAY laInfo[1]
	LOCAL lcVersion as String, loException as Exception
	TRY
		lcVersion = ''
		IF FILE(tcFile) THEN
			AGETFILEVERSION(laInfo,tcFile)
			lcVersion = laInfo[4]
		ENDIF
	CATCH TO loException
		lcVersion = ''
	ENDTRY
	RETURN lcVersion
ENDFUNC && GetVersion(tcFile as String) as String


*from my data object (_dataVersions):
	FUNCTION ConvertVersionToNumber(tcVersion) as Number
		LOCAL lnNumber as Number, liMajor as Integer, liMinor as Integer, liRevision as Integer, liMultiplier as Integer
		IF NOT EMPTY(tcVersion) THEN
			liMultiplier = 10000
			liMajor = VAL(GETWORDNUM(tcVersion,1,"."))
			liMinor = VAL(GETWORDNUM(tcVersion,2,"."))
			liRevision = VAL(GETWORDNUM(tcVersion,3,"."))
			lnNumber = (liMajor * liMultiplier^2) + (liMinor * liMultiplier^1) + (liRevision * liMultiplier^0) && could have skipped liMultiplier^0 but kept for logical flow
		ELSE
			lnNumber = 0
		ENDIF && NOT EMPTY(tcVersion)
		RETURN lnNumber
	ENDFUNC && ConvertVersionToNumber(tcVersion) as Number
	
	
	
*!*	I use the following code to identify Terminal Server client-sessions and "normal" sessions. Works fine on the Metaframe layer. Please note that I grabbed this code from various classes and .h files. I did not take the time to format the stuff with tabs etc properly.

*!*	? "this machine is " + IIF(IsTerminalServer(), "", "not ") + "a terminal server"
*!*	Link Citrix --> https://www.foxite.com/archives/about-citrix-0000011966.htm 
*!*	Link Citrix --> https://www.foxite.com/archives/citrix-serveur-0000206431.htm
*!*	Link Citrix --> https://www.foxite.com/archives/convesrion-0000106393.htm

***********************
FUNCTION IsTerminalServer
***********************
	#DEFINE HKEY_CLASSES_ROOT 			0x80000000
	#DEFINE SECURITY_ACCESS_MASK 983103     
	#DEFINE HKEY_LOCAL_MACHINE			-2147483646  
	#DEFINE KEY_SHARED_TOOLS_LOCATION	"Software\Microsoft\Shared Tools Location"
	#DEFINE KEY_NTCURRENTVERSION		"Software\Microsoft\Windows NT\CurrentVersion"
	#DEFINE KEY_WIN4CURRENTVERSION		"Software\Microsoft\Windows\CurrentVersion"
	#DEFINE KEY_WIN4_MSINFO				"Software\Microsoft\Shared Tools\MSInfo"
	#DEFINE KEY_QUERY_VALUE				1
	#DEFINE ERROR_SUCCESS				0
	#DEFINE REG_DWORD 4

   * WIN 32 API functions that are used
   DECLARE Integer RegOpenKey IN Win32API ;
      Integer nHKey, String @cSubKey, Integer @nResult
   DECLARE Integer RegQueryValueEx IN Win32API ;
      Integer nHKey, String lpszValueName, Integer dwReserved,;
      Integer @lpdwType, String @lpbData, Integer @lpcbData
   DECLARE Integer RegCloseKey IN Win32API ;
      Integer nHKey
   DECLARE GetVersionEx IN win32api STRING @OSVERSIONINFO

   * Local variables used
   LOCAL nErrCode	   && Error Code returned from Registry functions
   LOCAL nKeyHandle	   && Handle to Key that is opened in the Registry
   LOCAL lpdwValueType	   && Type of Value that we are looking for
   LOCAL lpbValue	   && The data stored in the value
   LOCAL lpcbValueSize	   && Size of the variable
   LOCAL lpdwReserved	   && Reserved Must be 0
   LOCAL cKey		   && Key we need to open
   LOCAL cValueToGet	   && Value to get
   LOCAL lTerminalServer   && True if it is a Terminal Server
   LOCAL nTSEnabled	   && Numeric value of TSEnabled
   LOCAL OSVersion	   && OS Version
   LOCAL cMajorVersion	   && Just the Version number i.e. 4 or 5
	
   * Initialize the variables
   cKey = "System\CurrentControlSet\Control\Terminal Server"
   cValueToGet = "TSEnabled"
   nKeyHandle = 0				
   lpdwReserved = 0	       && Must be 0
   lpdwValueType = REG_DWORD
   lpcbValueSize = 4	      && DWORD is 4 bytes
   lTerminalServer = .F.      && Assume it isn't a Terminal Server
   lpbValue = SPACE(4)

   nErrCode = RegOpenKey(HKEY_LOCAL_MACHINE, cKey, @nKeyHandle)
   * If the error code isn't 0, then the key doesn't exist or can't be opened.
   IF (nErrCode # 0) THEN
      RETURN .F.
   ENDIF

   * We need to check and see what version we are running NT 4 and Windows 2000 are different
   OSVersion = LongToStr(148) + REPLICATE(CHR(0), 144)
   =GetVersionEx(@OSVersion)
   nMajorVersion = StrToLong(SUBSTR(OSVersion, 5, 4))
   cMajorVersion = ALLTRIM(STR(nMajorVersion))

	* quick and dirty check for Win9x+Winme
   IF UPPER(LEFT(OS(), 10)) == "WINDOWS 4."
  		RETURN .F.
   ENDIF	
	
   * If it is NT 4 and we made it this far the machine is a Terminal Server
   IF (cMajorVersion = "4") THEN
      * Close the key when done.
      =RegCloseKey(nKeyHandle)
      RETURN .T.
   ENDIF

   * Get the value of TSEnabled. 1 is a Terminal  Server 0 isn't 
   nErrCode=RegQueryValueEx(nKeyHandle, cValueToGet, lpdwReserved, @lpdwValueType, @lpbValue, @lpcbValueSize)

   * Close the key when done.
   =RegCloseKey(nKeyHandle)

   IF (nErrCode # 0) THEN
      RETURN .F.
   ELSE
      nTSEnabled = StrToLong(lpbValue)
   ENDIF
	
   * Check to see if it is a Terminal Server	
   * EdD changed on 01-02-2002
   * WINXP acts like a Terminal Server: Remote Assistance
   * SYS(0) = "Windows 5.01" = WinXP http://fox.wikis.com/wc.dll?Wiki~VFPFunctionOS~VFP
   IF (nTSEnabled = 1) AND OS() # "Windows 5.01" THEN
       RETURN .T.
   ELSE
      RETURN .F.		
   ENDIF
ENDFUNC

FUNCTION StrToLong
* This function converts a String to a Long
   PARAMETERS cLongStr

   LOCAL nLoopVar, nRetval

   nRetval = 0
   FOR nLoopVar = 0 TO 24 STEP 8
      nRetval = nRetval + (ASC(cLongStr) * (2^nLoopVar))
      cLongStr = RIGHT(cLongStr, LEN(cLongStr) - 1)
   NEXT
RETURN nRetval
ENDFUNC

FUNCTION LongToStr
* This function converts a long to a string
   PARAMETERS nLongVal

   LOCAL nLoopVar, strReturn

   strReturn = ""
   FOR nLoopVar = 24 TO 0 STEP -8
      strReturn = CHR(INT(nLongVal/(2^nLoopVar))) + strReturn
      nLongVal = MOD(nLongVal, (2^nLoopVar))
   NEXT
RETURN strReturn
ENDFUNC
*******************************
PROCEDURE ModelsTryCatchFinally
*******************************
** Model 1
TRY
   DO myMenu.mpr
   DO FORM myForm
   myForm.AddObject("tm1","mytimer")
   READ EVENTS
CATCH TO oException
   IF oException.ErrorNo = 1
      STRTOFILE("Error occurred at: " + TRANSFORM(DATETIME());
         + CHR(13),"C:\Errors.log",.T.)
   ENDIF
FINALLY
   CLEAR EVENTS
ENDTRY

** Model 2

LOCAL x AS Integer, y AS Integer, result AS Integer
LOCAL oErr AS Exception, oErr1 AS Exception 
TRY
   x = 1
   TRY 
      USE nothing
      GO TOP
      y = nothing.col1
   CATCH TO oErr 
      oErr.UserValue = "Nested CATCH message: Unable to handle"
      ?[: Nested Catch! (Unhandled: Throw oErr Object Up) ]  
      ?[  Inner Exception Object: ]
      ?[  Error: ] + STR(oErr.ErrorNo) 
      ?[  LineNo: ] + STR(oErr.LineNo) 
      ?[  Message: ] + oErr.Message 
      ?[  Procedure: ] + oErr.Procedure 
      ?[  Details: ] + oErr.Details 
      ?[  StackLevel: ] + STR(oErr.StackLevel) 
      ?[  LineContents: ] + oErr.LineContents
      ?[  UserValue: ] + oErr.UserValue 
      THROW oErr 
   FINALLY
      ?[: Nested FINALLY executed ] 
      IF USED("nothing")   
         USE IN nothing
      ENDIF      
   ENDTRY   
   result = x-y
CATCH TO oErr1
   ?[: Outer CATCH! ]
      ?[  Outer Exception Object: ] 
      ?[  Error: ] + STR(oErr1.ErrorNo)
      ?[  LineNo: ] + STR(oErr1.LineNo) 
      ?[  Message: ] + oErr1.Message 
      ?[  Procedure: ] + oErr1.Procedure 
      ?[  Details: ] + oErr1.Details 
      ?[  StackLevel: ] + STR(oErr1.StackLevel) 
      ?[  LineContents: ] + oErr1.LineContents 
      ?[  ->UserValue becomes inner exception THROWn from nested TRY/CATCH ]
      ?[     Error: ] + STR(oErr1.UserValue.ErrorNo)
      ?[     Message: ] + oErr1.UserValue.Message 
      ?[     Procedure: ] + oErr1.UserValue.Procedure 
      ?[     Details: ] + oErr1.UserValue.Details 
      ?[     StackLevel: ] + STR(oErr1.UserValue.StackLevel) 
      ?[     LineContents: ] + oErr1.UserValue.LineContents 
      ?[     UserValue: ] + oErr1.UserValue.UserValue 
   result = 0   
FINALLY
   ?[: FINALLY statement executed ] 
ENDTRY
RETURN result

** Model 3

TRY
   TRY
      x=y      && The y variable does not exist and causes an error.
   CATCH TO oException2
      THROW CREATEOBJECT("myException")
   ENDTRY
CATCH TO oException1
ENDTRY

? 2, oException2.ErrorNo, oException2.UserValue
? 1, oException1.ErrorNo, oException1.UserValue.UserValue

DEFINE CLASS myException AS Exception
UserValue = "My custom error handler"
PROCEDURE Init
   STRTOFILE("An error occurred at: " + TRANSFORM(DATETIME());
 + CHR(13),"c:\errs.log",.T.)
ENDPROC
ENDDEFINE

