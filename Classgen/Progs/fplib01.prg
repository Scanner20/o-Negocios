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

PUBLIC gscodcia,gsnomcia,gsdircia,gssigcia,gslogcia,gsruccia,m.estoy,Gsprogram

STORE [] TO gscodcia,gsnomcia,gsdircia,gssigcia,gslogcia,gsruccia,m.estoy

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

PUBLIC Saltopag,GsTerminal,Pathorg1,PathOrg,Pathdef,PathDef1,PathUser,GsMsgErr,sErr,GlEscape
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
return
SET COLOR OF SCHEME  1 TO W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+
SET COLOR OF SCHEME  2 TO BG/W,N/W,N/W,B/W,W/N,N/BG,W+/W,N+/N,B/W,W/N,+
SET COLOR OF SCHEME  3 TO BG/W,N/W,BG/N,BG/N,BG/N,N/BG,W+/W,N+/N,BG/N,BG/N,+
SET COLOR OF SCHEME  4 TO BG/W,N/W,N/W,B/W,W/N,N/BG,W+/W,N+/N,B/W,W/N,+
SET COLOR OF SCHEME  5 TO W+/RB,W+/BG,W+/RB,W+/RB,W/RB,W+/B,GR+/RB,N+/N,W+/RB,W/RB,+
SET COLOR OF SCHEME  6 TO W/BG,W+/BG,W+/RB,W+/RB,W/RB,W+/B,BG+/BG,N+/N,W+/RB,W/RB,+
SET COLOR OF SCHEME  7 TO B/W,W+/W,GR+/R,W+/R,W/R,W+/N,GR+/R,N+/N,W+/R,W/R,+
SET COLOR OF SCHEME  8 TO W+/BG,W+/W,GR+/W,GR+/W,N+/W,W+/GR,BG+/BG,N+/N,B/BG,W/BG,+
SET COLOR OF SCHEME  9 TO W/BG,W+/BG,B/BG,GR+/W,N+/W,W+/GR,W+/B,N+/N,GR+/W,N+/W,+
SET COLOR OF SCHEME 16 TO W+/BG,GR+/B,b/W,N+/W,N+/W,GR+/GR,W+/B,N+/N,GR+/W,N+/W,+  &&
SET COLOR OF SCHEME 11 TO W+/BG,W+/W,GR+/W,GR+/W,N+/W,W+/GR,W/B,N+/N,W+/B,W/BG,+
SET COLOR OF SCHEME 12 TO GR+/R,W+/W,GR+/R,W+/R,W/R,W+/N,GR+/R,N+/N,W+/R,W/R,+
IF _WINDOWS
ELSE
	SET COLOR OF SCHEME 13 TO W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+ &&
	SET COLOR OF SCHEME 14 TO W+/G,W+/RB,W+/RB,W+/RB,W/RB,W+/B,BG+/BG,N+/N,W+/RB,W/RB,+
ENDIF
SET COLOR OF SCHEME 15 TO W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+
SET COLOR OF SCHEME 16 TO W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+
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
   c_fondo = "N+/N"
   c_linea = "N/W"
   c_say   = "N/W"
   c_get   = "N+/W"
   c_sayr  = "N+/W"
ENDIF
SET COLOR OF SCHEME 16 TO W+/BG,GR+/B,b/W,N+/W,N+/W,GR+/GR,W+/B,N+/N,GR+/W,N+/W,+
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
*!*	PROCEDURE sis_menu
*!*	SET SYSMENU TO

*!*	*SET SYSMENU ON

*!*	DEFINE PAD _r4t1e4tep OF _msysmenu PROMPT "\<Aplicaciones" COLOR SCHEME 3 ;
*!*	   KEY alt+A, ""
*!*	DEFINE PAD _r4t1e4tew OF _msysmenu PROMPT "\<Configuraci¢n" COLOR SCHEME 3 ;
*!*	   KEY alt+C, ""
*!*	DEFINE PAD _qau0r8jpa OF _msysmenu PROMPT "\<Ventanas"      COLOR SCHEME 3 KEY alt+v, ""
*!*	DEFINE PAD _px0106h0q OF _msysmenu PROMPT "\<Utilitarios"     COLOR SCHEME 3 KEY alt+u,""
*!*	DEFINE PAD _r4t1e4tf3 OF _msysmenu PROMPT "\<Salir" COLOR SCHEME 3 ;
*!*	   KEY alt+s, ""
*!*	ON PAD _r4t1e4tep OF _msysmenu ACTIVATE POPUP aplicacion
*!*	ON PAD _r4t1e4tew OF _msysmenu ACTIVATE POPUP configurac
*!*	ON     PAD _qau0r8jpa OF _msysmenu ACTIVATE POPUP _mwindow
*!*	ON     PAD _px0106h0q OF _msysmenu ACTIVATE POPUP sistema
*!*	ON SELECTION PAD _r4t1e4tf3 OF _msysmenu QUIT

*!*	DEFINE POPUP aplicacion MARGIN RELATIVE SHADOW COLOR SCHEME 4
*!*	DEFINE BAR 1 OF aplicacion PROMPT "\<ALMACEN E INVENTARIOS"
*!*	DEFINE BAR 2 OF aplicacion PROMPT "CONTROL Y \<PROGRAMA DE PRODUCCION"
*!*	DEFINE BAR 3 OF aplicacion PROMPT "\<CONTABILIDAD"
*!*	DEFINE BAR 4 OF aplicacion PROMPT "C\<OMPRAS"
*!*	DEFINE BAR 5 OF aplicacion PROMPT "\<TRANSFERENCIA DE INFORMACION"
*!*	DEFINE BAR 6 OF aplicacion PROMPT "\<FLUJO DE CAJA"
*!*	DEFINE BAR 7 OF aplicacion PROMPT "\<PLANILLAS"
*!*	DEFINE BAR 8 OF aplicacion PROMPT "\<CTA.CTE. PERSONAL"

*!*	ON SELECTION BAR 1 OF aplicacion DO alm_s_vb
*!*	ON SELECTION BAR 2 OF aplicacion DO cpi_s_vb
*!*	ON SELECTION BAR 3 OF aplicacion DO cbd_s_vb
*!*	ON SELECTION BAR 4 OF aplicacion DO cmp_s_vb
*!*	ON SELECTION BAR 5 OF aplicacion DO trf_s_vb
*!*	ON SELECTION BAR 6 OF aplicacion DO fcj_s_vb
*!*	ON SELECTION BAR 7 OF aplicacion DO pln_s_vb
*!*	ON SELECTION BAR 8 OF aplicacion DO plnMCCTE


*!*	DEFINE POPUP configurac MARGIN RELATIVE SHADOW COLOR SCHEME 4
*!*	DEFINE BAR _mfi_setup OF configurac PROMPT "\<Impresoras"
*!*	DEFINE BAR 2 OF configurac PROMPT "\-"
*!*	DEFINE BAR 3 OF configurac PROMPT "\<Tipos de Cambio"
*!*	DEFINE BAR 4 OF configurac PROMPT "\<Sistemas"
*!*	*ON SELECTION BAR 1 OF configurac do cfgprint
*!*	ON SELECTION BAR 2 OF configurac DO cfgusuar
*!*	ON SELECTION BAR 3 OF configurac DO admmtcmb_x
*!*	ON SELECTION BAR 4 OF configurac DO cfgsiste



*!*	DEFINE POPUP _mwindow MARGIN RELATIVE SHADOW COLOR SCHEME 4
*!*	DEFINE BAR _mwi_hide OF _mwindow PROMPT "\<Esconder"
*!*	DEFINE BAR _mwi_hidea OF _mwindow PROMPT "\<Esconder Todo"
*!*	DEFINE BAR _mwi_showa OF _mwindow PROMPT "\<Mostrar Todo"
*!*	DEFINE BAR _mwi_clear OF _mwindow PROMPT "\<Limpiar"
*!*	DEFINE BAR _mwi_sp100 OF _mwindow PROMPT "\-"
*!*	DEFINE BAR _mwi_move OF _mwindow PROMPT "\<M\<over" ;
*!*	   KEY ctrl+f7, "^F7"
*!*	DEFINE BAR _mwi_size OF _mwindow PROMPT "\<Tama¤o" ;
*!*	   KEY ctrl+f8, "^F8"
*!*	DEFINE BAR _mwi_zoom OF _mwindow PROMPT "\<Zoom " ;
*!*	   KEY ctrl+f10, "^F10"
*!*	DEFINE BAR _mwi_min OF _mwindow PROMPT "Z\<oom " ;
*!*	   KEY ctrl+f9, "^F9"
*!*	DEFINE BAR _mwi_rotat OF _mwindow PROMPT "\<Permutar" ;
*!*	   KEY ctrl+f1, "^F1"
*!*	DEFINE BAR _mwi_color OF _mwindow PROMPT "\<Color..."
*!*	DEFINE BAR _mwi_sp200 OF _mwindow PROMPT "\-"
*!*	DEFINE BAR _mwi_debug OF _mwindow PROMPT "\<Debug"
*!*	DEFINE BAR _mwi_trace OF _mwindow PROMPT "\<Trace"
*!*	DEFINE BAR _mwi_view OF _mwindow PROMPT "\<View"


*!*	DEFINE POPUP sistema MARGIN RELATIVE SHADOW COLOR SCHEME 4
*!*	DEFINE BAR _mst_about OF sistema PROMPT "\<FoxPro Info."
*!*	DEFINE BAR _mst_help  OF sistema PROMPT "\<Help..."
*!*	DEFINE BAR _mst_macro OF sistema PROMPT "\<Macros"
*!*	DEFINE BAR 3          OF sistema PROMPT "\-"
*!*	DEFINE BAR _mst_calcu OF sistema PROMPT "\<Calculadora"   KEY f12, "F12"
*!*	DEFINE BAR _mst_diary OF sistema PROMPT "Calendario/\<Diario"
*!*	DEFINE BAR 4          OF sistema PROMPT "\-"
*!*	DEFINE BAR _mst_captr OF sistema PROMPT "Ca\<pturar"

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
      **   SET STEP ON
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
      **   SET STEP ON
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
      m.rgb_color= [rgb(255,0,0,0,0,0)]
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
	**	DO F1CANCEL   		
	
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
   SUSPEND
   **DO F1SUSPEN
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
   FONT 'Ms Sans Serif',8;
   MESSAGE 'Cambia al primer registro.'

@ nfedit,4 GET m.prev_btn ;
   PICTURE "@*HN \<-1" ;
   SIZE 1,4,0 ;
   DEFAULT 1 ;
   VALID btn_val('PREV') ;
   FONT 'Ms Sans Serif',8;
   MESSAGE 'Cambia al registro anterior.'

@ nfedit,8 GET m.next_btn ;
   PICTURE "@*HN \<+1" ;
   SIZE 1,4,0 ;
   DEFAULT 1 ;
   VALID btn_val('NEXT') ;
   FONT 'Ms Sans Serif',8;
   MESSAGE 'Cambia al siguiente registro.'

@ nfedit,12 GET m.end_btn ;
   PICTURE "@*HN \<0" ;
   SIZE 1,3,0 ;
   DEFAULT 1 ;
   VALID btn_val('END') ;
   FONT 'Ms Sans Serif',8;
   MESSAGE 'Cambia al £ltimo registro.'

@ nfedit,16 GET m.pll_btn ;
   PICTURE spic_clave ;
   SIZE 1,9 ;
   DEFAULT 0 ;
   VALID btn_val('READKEY');
   FONT 'Ms Sans Serif',8;
   MESSAGE 'Clave de la tabla.'

@ nfedit,29 GET m.ca1_btn ;
   PICTURE spic_cmpad1 ;
   SIZE 1,08 ;
   DEFAULT 1 ;
   WHEN haycmpad1 VALID btn_val('CMPAD1') ;
   FONT 'Ms Sans Serif',8;
   MESSAGE msgcmpad1

@ nfedit,39 GET add_btn ;
   PICTURE "@*HN \<Crea" ;
   SIZE 1,6,0 ;
   DEFAULT 1 ;
   WHEN [C]$controles VALID btn_val('ADD') ;
   FONT 'Ms Sans Serif',8;
   MESSAGE 'Agrega un nuevo registro.' ;
   COLOR SCHEME 1

@ nfedit,46 GET m.edi_btn ;
   PICTURE "@*HN \<Edita" ;
   SIZE 1,7,0 ;
   DEFAULT 1 ;
   WHEN [M]$controles VALID btn_val('EDIT') ;
   MESSAGE 'Edita el registro actual.' ;
   FONT 'Ms Sans Serif',8;
   COLOR SCHEME 1

@ nfedit,54 GET m.del_btn ;
   PICTURE "@*HN \<Borra" ;
   SIZE 1,7,0 ;
   DEFAULT 1 ;
   WHEN [A]$controles VALID btn_val('DELETE') ;
   MESSAGE 'Elimina el registro actual.' ;
   FONT 'Ms Sans Serif',8;
   COLOR SCHEME 1

@ nfedit,62 GET m.prnt_btn ;
   PICTURE "@*HN \<Infor." ;
   SIZE 1,8,0 ;
   DEFAULT 1 ;
   WHEN [R]$controles VALID btn_val('PRINT') ;
   MESSAGE 'Emitir documento o listado.' ;
   FONT 'Ms Sans Serif',8;
   COLOR SCHEME 1

@ nfedit,71 GET m.exit_btn ;
   PICTURE "@*HN \<Cerrar" ;
   SIZE 1,8,0 ;
   DEFAULT 1 ;
   VALID btn_val('EXIT') ;
   MESSAGE 'Cierra la pantalla.' ;
   FONT 'Ms Sans Serif',8;
   COLOR SCHEME 1
   
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
                  IF f1_alert("Desea anular el registro ?",2)=1
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
   IF f1_alert("Desea anular el registro ?",2)=1
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
		DEFINE WINDOW __WFondo AT 05,10 SIZE 40,90 CLOSE FLOAT GROW ;
		 TITLE (m.titulo) COLOR SCHEME 16
			 
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
IF !EMPTY(m.curwin)
   SHOW WINDOW (m.curwin) BOTTOM REFRESH
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
	_FontSize	= 8
ENDIF
IF VARTYPE(_FontStyle)<>'C'
	_FontStyle	= 'N' 
ENDIF	

IF VERSION()=[Visual FoxPro]
	do form Gen_f0print
ELSE
	LsCommand = 'DO f0print.spr'
	&LsCommand
ENDIF
IF (LASTKEY()=27) OR (m.control=2)
   ulttecla = 27
   
   DEACTIVATE WINDOW impresion
   RELEASE WINDOW impresion
   RETURN
ENDIF
SELECT (m.select)
IF RECNO() <> m.regact .AND. ! EMPTY(m.dbf)
   GOTO m.regact
ENDIF

ON KEY LABEL ctrl+R
ON KEY LABEL ctrl+q
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
   
CASE _destino = 2
	IF VERSION()='Visual FoxPro'
		_archivo = goentorno.tmppath+SYS(3)+".pat"
	ELSE
	   _archivo = pathuser+SYS(3)+".pat"
	ENDIF   
   DELETE FILE (_archivo)
   SET PRINTER TO (_archivo)
   STORE "" TO _prn0,_prn1,_prn2,_prn3,_prn4,_prn5a,_prn5b,_prn6a,_prn6b,;
      _prn7a,_prn7b,_prn8a,_prn8b,_prn9a,_prn9b
CASE _destino = 3

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
CASE _destino = 2
   *RUN README &_Archivo
	IF _DOS OR _UNIX or TYPE("XTipRep") != "C"
		MODI COMM &_archivo NOEDIT
    ENDIF
    DELETE FILE (_archivo)
CASE _destino = 3
   *RUN README &_Archivo
   MODI COMM &_archivo NOEDIT
   @ 00,00 CLEAR TO 02,31 COLOR SCHEME 15
   respuesta = 1
   @ 01,02 GET respuesta PICTURE "@*HT \<Salir;\<Borrar;\<Imprimir" COLOR SCHEME 15
   READ CYCLE
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
	@ numlin,0      SAY iniimp
ENDIF


@ numlin,0      SAY gsnomcia
DO CASE
CASE titulo="@"
   IF _destino <> 3
      coltit = (ancho - 2*(LEN(titulo)-1) - 1)/2
   ENDIF
	DO CASE
		CASE _DOS OR _UNIX
			@ numlin,coltit SAY _prn7b+SUBSTR(titulo,2)+_prn7b
	   CASE _WINDOWS
   			@ numlin,coltit SAY SUBSTR(titulo,2)  &&FONT "Courier New",12
	ENDCASE
	   
   IF _destino <> 3
      @ numlin,0 SAY ""
   ENDIF
OTHER
   @ numlin,coltit SAY titulo &&FONT "Courier New",10
ENDCASE
@ numlin,colder SAY tit_sder

numlin = numlin + 1
@ numlin,0        SAY gsdircia
DO CASE
CASE titulo="@"
   IF _destino <> 2
      colstt = (ancho - 2*(LEN(subtitulo)-1) - 1)/2
   ENDIF
   DO CASE 
	CASE _DOS OR _UNIX
   		@ numlin,colstt SAY _prn7b+SUBSTR(subtitulo,2)+_prn7b
   CASE _WINDOWS
   		@ numlin,colstt SAY SUBSTR(subtitulo,2) &&FONT "Courier New",12
   ENDCASE		
   IF _destino <> 2
      @ numlin,0 SAY ""
   ENDIF
OTHER
   @ numlin,colstt   SAY subtitulo &&FONT "Courier New",10
ENDCASE
@ numlin,ancho-14 SAY "PAGINA: "+STR(numpag,5) &&FONT "Courier New",10

lin      = 1
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
         @ numlin,COL SAY leyenda &&FONT "Courier New",10
      ELSE
         xx = LEFT(leyenda,254)
         xy = SUBS(leyenda,255)
         @ numlin,COL     SAY xx &&FONT "Courier New",10
         @ numlin,COL+254 SAY xy &&FONT "Courier New",10
      ENDIF
   ENDIF
   lin        = lin + 1
ENDDO


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
*********************************************************************
*                                                                   *
*          FUNCTION F1BROWSE : VENTANA EXAMINAR (BROWSE)            *
*                                                                   *
*********************************************************************
*!*****************************************************************************
*!
*!       Function: F1BROWSE_CLON
*!
*!          Calls: &PRGBUSCA.PRG
*!               : &PRGPREP.PRG
*!               : BBORRA_REG         (procedure in belcsoft.PRG)
*!               : BAGREGA_REG        (procedure in belcsoft.PRG)
*!               : WBRW()             (function in belcsoft.PRG)
*!               : VBRW()             (function in belcsoft.PRG)
*!               : &PRGPOST.PRG
*!
*!*****************************************************************************
*!*	*!*	FUNCTION f1browse_clon
*!*	*!*	PARAMETERS skey,lmodifica,ladiciona,lborra,lpintar
*!*	*!*	IF PARAMETERS() < 1
*!*	*!*	   skey = []
*!*	*!*	ENDIF
*!*	*!*	lsbrwmensaje =[]
*!*	*!*	IF PARAMETERS() < 2
*!*	*!*	   smodifica = []
*!*	*!*	   lmodifica = .T.
*!*	*!*	ELSE
*!*	*!*	   smodifica = IIF(lmodifica,"","NOMODIFY")
*!*	*!*	ENDIF

*!*	*!*	IF PARAMETERS() < 3
*!*	*!*	   sadiciona = []
*!*	*!*	   ladiciona = .T.
*!*	*!*	ELSE
*!*	*!*	   sadiciona = IIF(ladiciona,"","NOAPPEND")
*!*	*!*	ENDIF
*!*	*!*	IF ladiciona
*!*	*!*	   lsbrwmensaje = lsbrwmensaje+[CTRL+INS Agrega item. ]
*!*	*!*	ENDIF
*!*	*!*	IF PARAMETERS() < 4
*!*	*!*	   sborrar   = []
*!*	*!*	   lborra    = .T.
*!*	*!*	ELSE
*!*	*!*	   sborrar   = IIF(lborra   ,"","NODELETE")

*!*	*!*	ENDIF
*!*	*!*	IF lborra
*!*	*!*	   lsbrwmensaje = lsbrwmensaje+[CTRL+DEL Borra item. ]
*!*	*!*	ENDIF

*!*	*!*	IF PARAMETERS() < 5
*!*	*!*	   lpintar   = .F.
*!*	*!*	ENDIF

*!*	*!*	IF TYPE("m.bBorde")#"C"
*!*	*!*	   sborde = [NONE]
*!*	*!*	ELSE
*!*	*!*	   sborde = m.bborde
*!*	*!*	ENDIF

*!*	*!*	IF TYPE("m.Area_Sel")#"C"
*!*	*!*	   m.area_sel = [TEMP]
*!*	*!*	ENDIF

*!*	*!*	snoclear = [NOCLEAR]
*!*	*!*	IF TYPE("M.lStatic")="L"
*!*	*!*	   IF !m.lstatic
*!*	*!*	      snoclear = []
*!*	*!*	   ENDIF
*!*	*!*	ENDIF
*!*	*!*	PRIVATE m.area_ant
*!*	*!*	m.area_ant = ALIAS()

*!*	*!*	PUSH KEY CLEAR


*!*	*!*	IF TYPE("m.PrgBusca")=[C]
*!*	*!*	   IF !EMPTY(m.prgbusca)
*!*	*!*	      ON KEY LABEL f5 DO &prgbusca.
*!*	*!*	      lsbrwmensaje = lsbrwmensaje + [F5 Buscar ]
*!*	*!*	   ENDIF
*!*	*!*	ENDIF

*!*	*!*	IF TYPE("m.PrgPrep")=[C]
*!*	*!*	   IF !EMPTY(m.prgprep)
*!*	*!*	      DO &prgprep.
*!*	*!*	   ENDIF
*!*	*!*	ENDIF
*!*	*!*	lsvenpadre=[]
*!*	*!*	lhayvenpadre=.F.
*!*	*!*	IF TYPE("m.VenPadre")=[C]
*!*	*!*	   IF !EMPTY(m.venpadre)
*!*	*!*	      lsvenpadre = [IN WINDOW ]+venpadre
*!*	*!*	      lhayvenpadre=.T.
*!*	*!*	   ENDIF
*!*	*!*	ENDIF

*!*	*!*	** Redefinici¢n de teclas
*!*	*!*	IF TYPE([m.bPrgkeyF4])=[C]
*!*	*!*	   IF !EMPTY(m.bprgkeyf4)
*!*	*!*	      ON KEY LABEL f4 DO (m.bprgkeyf4)
*!*	*!*	      IF TYPE([m.bPrgkeyF4])=[C]
*!*	*!*	         IF EMPTY(m.bdescrif4)
*!*	*!*	            m.bdescrif4=m.bprgkeyf4
*!*	*!*	         ENDIF
*!*	*!*	      ELSE
*!*	*!*	         m.bdescrif4=m.bprgkeyf4
*!*	*!*	      ENDIF
*!*	*!*	      lsbrwmensaje = lsbrwmensaje + [F4 ]+m.bdescrif4
*!*	*!*	   ENDIF
*!*	*!*	ENDIF
*!*	*!*	IF TYPE([m.bPrgkeyF5])=[C]
*!*	*!*	   IF !EMPTY(m.bprgkeyf5)
*!*	*!*	      ON KEY LABEL f5 DO (m.bprgkeyf5)
*!*	*!*	      IF TYPE([m.bPrgkeyF5])=[C]
*!*	*!*	         IF EMPTY(m.bdescrif5)
*!*	*!*	            m.bdescrif5=m.bprgkeyf5
*!*	*!*	         ENDIF
*!*	*!*	      ELSE
*!*	*!*	         m.bdescrif5=m.bprgkeyf5
*!*	*!*	      ENDIF
*!*	*!*	      lsbrwmensaje = lsbrwmensaje + [F5 ]+m.bdescrif5
*!*	*!*	   ENDIF
*!*	*!*	ENDIF
*!*	*!*	*
*!*	*!*	IF TYPE([m.bPrgkeyF6])=[C]
*!*	*!*	   IF !EMPTY(m.bprgkeyf6)
*!*	*!*	      ON KEY LABEL f6 DO (m.bprgkeyf6)
*!*	*!*	      IF TYPE([m.bPrgkeyF6])=[C]
*!*	*!*	         IF EMPTY(m.bdescrif6)
*!*	*!*	            m.bdescrif6=m.bprgkeyf6
*!*	*!*	         ENDIF
*!*	*!*	      ELSE
*!*	*!*	         m.bdescrif6=m.bprgkeyf6
*!*	*!*	      ENDIF
*!*	*!*	      lsbrwmensaje = lsbrwmensaje + [F6 ]+m.bdescrif6
*!*	*!*	   ENDIF
*!*	*!*	ENDIF
*!*	*!*	*
*!*	*!*	IF TYPE([m.bPrgkeyF7])=[C]
*!*	*!*	   IF !EMPTY(m.bprgkeyf7)
*!*	*!*	      ON KEY LABEL f7 DO (m.bprgkeyf7)
*!*	*!*	      IF TYPE([m.bPrgkeyF7])=[C]
*!*	*!*	         IF EMPTY(m.bdescrif7)
*!*	*!*	            m.bdescrif7=m.bprgkeyf7
*!*	*!*	         ENDIF
*!*	*!*	      ELSE
*!*	*!*	         m.bdescrif7=m.bprgkeyf7
*!*	*!*	      ENDIF
*!*	*!*	      lsbrwmensaje = lsbrwmensaje + [F7 ]+m.bdescrif7
*!*	*!*	   ENDIF
*!*	*!*	ENDIF

*!*	*!*	ON KEY LABEL ctrl+pgup GOTO TOP
*!*	*!*	ON KEY LABEL ctrl+pgdn GOTO BOTTOM

*!*	*!*	ON KEY LABEL ctrl+del  DO bborra_reg
*!*	*!*	ON KEY LABEL ctrl+ins  DO bagrega_reg

*!*	*!*	** Definimos ventana activa **
*!*	*!*	IF lpintar
*!*	*!*	   m.venactiv = m.btitulo
*!*	*!*	   m.vendeact = m.bdeta
*!*	*!*	ELSE
*!*	*!*	   m.venactiv = m.bdeta
*!*	*!*	   m.vendeact = m.btitulo
*!*	*!*	ENDIF
*!*	*!*	IF TYPE([bTitBrow])#[C]
*!*	*!*	   btitbrow = m.venactiv
*!*	*!*	ELSE
*!*	*!*	   btitbrow = IIF(EMPTY(btitbrow),m.venactiv,btitbrow)
*!*	*!*	ENDIF
*!*	*!*	** Ventana actual **
*!*	*!*	PRIVATE w_act_tra
*!*	*!*	w_act_tra=WOUTPUT()
*!*	*!*	**
*!*	*!*	blborrar = .F.
*!*	*!*	lgrb_arch= .F.
*!*	*!*	IF !EMPTY(m.vendeact) AND m.vendeact<>m.venactiv
*!*	*!*	   IF WVISIBLE(m.vendeact)
*!*	*!*	      DEACTIVATE WINDOW (m.vendeact)
*!*	*!*	      RELEASE WINDOW (m.vendeact)
*!*	*!*	   ENDIF
*!*	*!*	ENDIF
*!*	*!*	DO CASE
*!*	*!*	CASE _WINDOWS
*!*	*!*	   nx1=nx1 - 1
*!*	*!*	ENDCASE
*!*	*!*	lcrearwin=.F.
*!*	*!*	IF !WEXIST(m.venactiv)
*!*	*!*	   DEFINE WINDOWS (m.venactiv) FROM nx0,ny0 TO nx1,ny1 FLOAT GROW ZOOM NOCLOSE;
*!*	*!*	      SHADOW NONE COLOR SCHEME 10 &lsvenpadre.
*!*	*!*	   lcrearwin=.T.
*!*	*!*	ENDIF

*!*	*!*	IF !lpintar
*!*	*!*	   lsbrwmensaje = lsbrwmensaje + [ ESC Salir F10 Graba]
*!*	*!*	ELSE
*!*	*!*	   lsbrwmensaje = lsbrwmensaje + [ ESC Salir ]
*!*	*!*	ENDIF
*!*	*!*	IF !lpintar
*!*	*!*	   STORE WOUTPUT() TO currwind
*!*	*!*	   IF SYS(2016) = "" OR SYS(2016) = "*"

*!*	*!*	      IF _DOS OR _UNIX
*!*	*!*	         ACTIVATE SCREEN
*!*	*!*	         @ 24,0 SAY PADC(lsbrwmensaje,80) COLOR (c_linea)
*!*	*!*	      ELSE
*!*	*!*	         @ 30,0 SAY PADC(lsbrwmensaje,80) COLOR (c_linea) FONT "MS SANS SERIF",8 STYLE "B"
*!*	*!*	      ENDIF
*!*	*!*	   ENDIF
*!*	*!*	   IF NOT EMPTY(currwind)
*!*	*!*	      ACTIVATE WINDOW (currwind) SAME
*!*	*!*	   ENDIF
*!*	*!*	   SELE (area_sel)
*!*	*!*	   DO CASE
*!*	*!*	   CASE _DOS

*!*	*!*	      IF WEXIST(m.venactiv) AND m.venactiv=m.vendeact AND !lhayvenpadre
*!*	*!*	         RELEASE WINDOW (m.venactiv)
*!*	*!*	         DEFINE WINDOWS (m.venactiv) FROM nx0,ny0 TO nx1,ny1 FLOAT GROW ZOOM NOCLOSE;
*!*	*!*	            SHADOW NONE COLOR SCHEME 10 &lsvenpadre.

*!*	*!*	         ACTIVATE WINDOW (m.venactiv)
*!*	*!*	      ENDIF



*!*	*!*	      lsenquewin = [WINDOW ]+m.venactiv
*!*	*!*	      IF lhayvenpadre
*!*	*!*	         lsenquewin = [IN WINDOW ]+m.venactiv
*!*	*!*	         IF WOUTPUT()<>m.venactiv
*!*	*!*	            ACTIVATE WINDOW (m.venactiv)
*!*	*!*	         ENDIF
*!*	*!*	      ENDIF
*!*	*!*	      **BROWSE FIELD &bCampos. KEY sKEY TITLE (bTitBrow) COLOR SCHEME 10 ;
*!*	*!*	      **             FOR EVALUATE(m.bFiltro) &LsEnQueWin. NOWAIT &sNOCLEAR. FONT 'Ms Sans Serif',8
*!*	*!*	      **RELEASE WINDOW (m.VenActiv)
*!*	*!*	      BROWSE FIELD &bcampos. KEY skey TITLE (btitbrow) COLOR SCHEME 10  ;
*!*	*!*	         FOR EVALUATE(m.bfiltro) &snoclear. SAVE WHEN wbrw() VALID vbrw() ;
*!*	*!*	         &smodifica. &sadiciona. &sborrar. &lsenquewin. FONT 'Ms Sans Serif',8

*!*	*!*	   CASE _WINDOWS
*!*	*!*	      *BROWSE FIELD &bCampos. KEY sKEY TITLE (bTitBrow) COLOR SCHEME 10 ;
*!*	*!*	      *             FOR EVALUATE(m.bFiltro) WINDOW (m.VenActiv) NOWAIT &sNOCLEAR.
*!*	*!*	      lsenquewin = [WINDOW ]+m.venactiv
*!*	*!*	      IF lhayvenpadre
*!*	*!*	         lsenquewin = [IN WINDOW ]+m.venactiv
*!*	*!*	         IF WOUTPUT()<>m.venactiv
*!*	*!*	            ACTIVATE WINDOW (m.venactiv)
*!*	*!*	         ENDIF
*!*	*!*	      ENDIF
*!*	*!*	      BROWSE FIELD &bcampos. KEY skey TITLE (btitbrow) COLOR SCHEME 10  ;
*!*	*!*	         FOR EVALUATE(m.bfiltro) &snoclear. SAVE WHEN wbrw() VALID vbrw() ;
*!*	*!*	         &smodifica. &sadiciona. &sborrar. &lsenquewin. FONT 'Ms Sans Serif',8
*!*	*!*	   ENDCASE
*!*	*!*	ELSE
*!*	*!*	   lsbrwmensaje=[]
*!*	*!*	   IF !WVISIBLE(m.venactiv)
*!*	*!*	      ACTIVATE WINDOW (m.venactiv)
*!*	*!*	   ELSE
*!*	*!*	   ENDIF
*!*	*!*	   SELE (area_sel)
*!*	*!*	   IF lhayvenpadre
*!*	*!*	      IF WONTOP()<>m.venactiv
*!*	*!*	         IF !WEXIST(m.venactiv)
*!*	*!*	            DEFINE WINDOWS (m.venactiv) FROM nx0,ny0 TO nx1,ny1 FLOAT GROW ZOOM NOCLOSE;
*!*	*!*	               SHADOW NONE COLOR SCHEME 10 &lsvenpadre.
*!*	*!*	         ENDIF
*!*	*!*	         ACTIVATE WINDOW (m.venactiv)
*!*	*!*	      ENDIF
*!*	*!*	      BROWSE FIELD &bcampos. KEY skey TITLE (btitbrow) COLOR SCHEME 10 ;
*!*	*!*	         FOR EVALUATE(m.bfiltro) IN WINDOW (m.venactiv) SAVE NOWAIT NOAPPEND NOMODIFY NODELETE &snoclear. FONT 'Ms Sans Serif',8
*!*	*!*	   ELSE
*!*	*!*	      IF WONTOP()<>m.venactiv
*!*	*!*	         IF !WEXIST(m.venactiv)
*!*	*!*	            DEFINE WINDOWS (m.venactiv) FROM nx0,ny0 TO nx1,ny1 FLOAT GROW ZOOM NOCLOSE;
*!*	*!*	               SHADOW NONE COLOR SCHEME 10 &lsvenpadre.
*!*	*!*	         ENDIF
*!*	*!*	         ACTIVATE WINDOW (m.venactiv)

*!*	*!*	      ENDIF

*!*	*!*	      * ** IF INLIST(M.ESTOY,[PID],[EDIT])
*!*	*!*	      DEFINE WINDOWS (m.venactiv) FROM nx0,ny0 TO nx1,ny1 FLOAT GROW ZOOM NOCLOSE;
*!*	*!*	         SHADOW NONE COLOR SCHEME 10 &lsvenpadre.
*!*	*!*	      ACTIVATE WINDOW (m.venactiv)
*!*	*!*	      * ** ENDIF
*!*	*!*	      ** IF WEXIST(M.VENACTIV) AND !LCrearWin
*!*	*!*	      **    brow last save nowait
*!*	*!*	      ** ELSE
*!*	*!*	      BROWSE FIELD &bcampos. KEY skey TITLE (btitbrow) COLOR SCHEME 10 ;
*!*	*!*	         FOR EVALUATE(m.bfiltro) WINDOW (m.venactiv) SAVE NOWAIT NOAPPEND NOMODIFY NODELETE FONT 'Ms Sans Serif',8

*!*	*!*	      RELEASE WINDOW (m.venactiv)
*!*	*!*	      ** ENDIF
*!*	*!*	   ENDIF
*!*	*!*	ENDIF
*!*	*!*	IF TYPE("m.PrgPost")=[C] AND !lpintar
*!*	*!*	   IF !EMPTY(m.prgpost)
*!*	*!*	      DO &prgpost.
*!*	*!*	   ENDIF
*!*	*!*	ENDIF
*!*	*!*	xx=WONTOP()
*!*	*!*	yy=WOUTPUT()
*!*	*!*	IF WEXIST(m.venactiv) AND m.venactiv==m.vendeact AND !lhayvenpadre
*!*	*!*	   DO CASE
*!*	*!*	   CASE TYPE([CVCTRL])#[C]
*!*	*!*	      IF TYPE([m.lStatic])#[L]
*!*	*!*	         DEACTIVATE WINDOW (m.venactiv)
*!*	*!*	      ELSE
*!*	*!*	         IF !m.lstatic
*!*	*!*	            DEACTIVATE WINDOW (m.venactiv)
*!*	*!*	         ENDIF
*!*	*!*	      ENDIF
*!*	*!*	   CASE TYPE([CVCTRL])=[C]
*!*	*!*	      IF TYPE([m.lStatic])#[L]
*!*	*!*	         DEACTIVATE WINDOW (m.venactiv)
*!*	*!*	      ELSE
*!*	*!*	         IF !m.lstatic
*!*	*!*	            DEACTIVATE WINDOW (m.venactiv)
*!*	*!*	         ENDIF
*!*	*!*	      ENDIF
*!*	*!*	   ENDCASE
*!*	*!*	ENDIF
*!*	*!*	SELE (m.area_ant)
*!*	*!*	IF INLIST(LASTKEY(),k_ctrlw,k_esc,k_f10)
*!*	*!*	   m.bdefbrow = .T.
*!*	*!*	ENDIF
*!*	*!*	POP KEY
*!*	*!*	IF !EMPTY(w_act_tra)
*!*	*!*	   ACTIVATE WINDOW (w_act_tra) SAME
*!*	*!*	ELSE
*!*	*!*	   IF SYS(2016) = "" OR SYS(2016) = "*"
*!*	*!*	      ACTIVATE SCREEN
*!*	*!*	   ENDIF
*!*	*!*	ENDIF
*!*	*!*	RETURN

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
************************************************
*
*     FUNCION FASELEC :
*
************************************************
*!*****************************************************************************
*!
*!       Function: FASELEC
*!
*!          Calls: AVECTOR()          (function in ?)
*!
*!*****************************************************************************
*!*	FUNCTION faselec
*!*	PARAMETERS var1,avector,lvacio,nlencmp
*!*	PRIVATE lok,opvc
*!*	glescape = .F.
*!*	ulttecla = LASTKEY()
*!*	opcv     = 1
*!*	IF ulttecla = k_f8
*!*	   IF ALEN(avector)<=0
*!*	      RETURN .F.
*!*	   ENDIF
*!*	   PRIVATE currwind,nfil,ncol,nancho,nlargo
*!*	   STORE WOUTPUT() TO currwind
*!*	   IF SYS(2016) = "" OR SYS(2016) = "*"
*!*	   		IF _DOS OR _UNIX
*!*		      ACTIVATE SCREEN      
*!*		    ELSE  
*!*			ENDIF	      
*!*	   ENDIF
*!*	   nancho=LEN(avector(1))
*!*	   nlargo=ALEN(avector)
*!*	   nfil = 23 - nlargo
*!*	   ncol = 80 - nancho
*!*	   @ nfil,ncol GET opcv PICTURE "@^" FROM avector SIZE nlargo,nancho
*!*	   READ
*!*	   ulttecla = LASTKEY()
*!*	   IF ulttecla = k_esc
*!*	      glescape = .T.
*!*	      RETURN .F.
*!*	   ENDIF
*!*	   var1     = LEFT(avector(opcv),nlencmp)
*!*	   ulttecla = k_enter
*!*	ENDIF
*!*	lok = .F.
*!*	FOR K = 1 TO ALEN(avector)
*!*	   IF var1 = LEFT(avector(K),nlencmp)
*!*	      lok = .T.
*!*	      EXIT
*!*	   ENDIF
*!*	ENDFOR
*!*	IF EMPTY(var1) AND lvacio
*!*	   RETURN .T.
*!*	ENDIF
*!*	IF ulttecla = k_esc OR ulttecla = k_enter
*!*	   RETURN lok
*!*	ENDIF
*!*	RETURN lok
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
PARAMETER filmsg1,colmsg1,filmsg2,colmsg2
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

dirnew = pathdef+lcslash+"CIA"+gscodcia+lcslash+"C"+STR(_ano+1,4,0)
diract = SYS(2003)
LsComando= 'RUN MKDIR '+DIRNEW+ '> null'
DO CASE
CASE _DOS OR _UNIX
   &LsComando.
CASE _WINDOWS OR _MAC
   MKDIR (dirnew)

ENDCASE
dirnew = pathdef+lcslash+"CIA"+gscodcia+lcslash+"C"+STR(_ano+1,4,0)+lcslash
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

SELE 0
carchivo= lcslash+LEFT(sist.codigo,3)+[*.dbf]
carcact = SYS(2000,diract+carchivo)
DO WHILE ! EMPTY(carcact)
   carcnew = dirnew+carcact
   =SEEK(PADR(gssistema,LEN(dbfs.sistema))+LEFT(carcact,8),[DBFS])
   IF ! FILE(carcnew)
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
carchivo= lcslash+[CBDTCIER]+[.DBF]
carcact = SYS(2000,diract+carchivo)
DO WHILE ! EMPTY(carcact)
   carcnew = dirnew+carcact
   IF lescmsg2
      @ filmsg2,colmsg2 SAY [CREANDO :]+carcnew SIZE 1,xancho - colmsg2 - 2
   ENDIF
   USE (carcact)
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
   **DO INDEX_TAG
   USE
   carcact = SYS(2000,diract+carchivo,1)
ENDDO

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
   SELECT dat
   SET TALK ON
   SET TALK WINDOW
   INDEX ON &campos.  TAG  &tagidx.  COMPACT
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
*************************************************************
*                                                           *
*       FUNCTION F1DBFALT : CAPTURA ARCHIVO ALTERNATIVO     *
*                                                           *
*************************************************************
*!*****************************************************************************
*!
*!       Function: F1DBFALT
*!
*!           Uses: SISTDBFS.DBF           Alias: DBFS
*!
*!      CDX files: SISTDBFS.CDX
*!
*!*****************************************************************************
FUNCTION f1dbfalt
PARAMETER Arch_Dbf
EXTERNAL ARRAY vDbf_ctb
private nb
m.alias_act = ALIAS()
IF !(PARAMETERS()<1 OR EMPTY(Arch_Dbf))
   SELE (curalias)
   return .t.
ENDIF
lspathdbf=DBF()
IF ALEN(vDbf_ctb)=1
	IF !USED([DBFS])
	   SELE 0
	   USE sistdbfs ORDER sistema
	   IF !USED()
	      RETURN .F.
	   ENDIF
	ENDIF
	SEEK gssistema
	SCAN WHILE sistema = gssistema
		IF !EMPTY(Path001)
			DO CASE
				CASE Ubicacion=[R]
					LsSubDir=TRIM(Path001)
				CASE Ubicacion=[C]
				
			    	LsSubDir=IIF(Ubicacion=[C],[\Cia]+GsCodCia+[\],[]) 
				CASE Ubicacion=[A]
		    	
		    ENDCASE
			LsPath_y_Dbf=[]
	    ENDIF
		vDbf_Ctb(nb) = ALIAS+[ ]+archivo
	
	ENDSCAN
ENDIF	
SELE (m.alias_act)
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
***********************************
*
*    FUNCTION F1_DTIEM
*
***********************************
*!*	*!*	FUNCTION F1_DTIEM
*!*	*!*	PARAMETER hora1,hora2
*!*	*!*	IF SET("TALK") = "ON"
*!*	*!*	   SET TALK OFF
*!*	*!*	   m.talkstat = "ON"
*!*	*!*	ELSE
*!*	*!*	   m.talkstat = "OFF"
*!*	*!*	ENDIF
*!*	*!*	m.compstat = SET("COMPATIBLE")
*!*	*!*	SET COMPATIBLE FOXPLUS
*!*	*!*	totsegdia=86400
*!*	*!*	hora1 = segundos(hora1)
*!*	*!*	hora2 = segundos(hora2)
*!*	*!*	IF hora2<hora1
*!*	*!*	   hora2 = hora2+totsegdia
*!*	*!*	ENDIF
*!*	*!*	final = hora2-hora1
*!*	*!*	final = STR(INT(MOD(final/3600,24)),2,0)+":"+;
*!*	*!*	   STR(INT(MOD(final/60,60)),2,0)+":"+;
*!*	*!*	   STR(INT(MOD(final,60)),2,0)
*!*	*!*	IF LEFT(final,1)=" "
*!*	*!*	   final = STUFF(final,1,1,"0")
*!*	*!*	ENDIF
*!*	*!*	IF SUBSTR(final,4,1)=" "
*!*	*!*	   final = STUFF(final,4,1,"0")
*!*	*!*	ENDIF
*!*	*!*	IF SUBSTR(final,7,1)=" "
*!*	*!*	   final = STUFF(final,7,1,"0")
*!*	*!*	ENDIF
*!*	*!*	IF m.talkstat = "ON"
*!*	*!*	   SET TALK ON
*!*	*!*	ENDIF
*!*	*!*	IF m.compstat = "ON"
*!*	*!*	   SET COMPATIBLE ON
*!*	*!*	ENDIF
*!*	RETURN final
*****************************************************
*                                                   *
*       FUNCTION F1_SEGDS : SEGUNDOS                *
*                                                   *
*                                                   *
*****************************************************
*!*****************************************************************************
*!
*!       Function: F1_SEGDS
*!
*!*****************************************************************************
FUNCTION f1_segds
PARAMETER tempo,inicio
IF SET("TALK") = "ON"
   SET TALK OFF
   m.talkstat = "ON"
ELSE
   m.talkstat = "OFF"
ENDIF
m.compstat = SET("COMPATIBLE")
SET COMPATIBLE FOXPLUS
IF PARAMETERS()=2
   horas = VAL(LEFT(tempo,2))-VAL(LEFT(inicio,2))
   minutos=VAL(SUBS(tempo,4,2))-VAL(SUBS(inicio,4,2))
   s1=VAL(SUBS(tempo,7,2))
   s2=VAL(SUBS(inicio,7,2))
   IF s2<=s1
      segs=s1-s2
   ELSE
      segs=s1+(60-s2)
   ENDIF
   tempo=STUFF(tempo,1,2,STR(horas,2))
   tempo=STUFF(tempo,4,2,STR(minutos,2))
   tempo=STUFF(tempo,7,2,STR(segs,2))
ENDIF
final = VAL(LEFT(tempo,2))*3600+VAL(SUBSTR(tempo,4,2))*60+VAL(SUBSTR(tempo,7,2))
IF m.talkstat = "ON"
   SET TALK ON
ENDIF
IF m.compstat = "ON"
   SET COMPATIBLE ON
ENDIF
RETURN final
*!*****************************************************************************
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
*!*****************************************************************************
FUNCTION vmarca

RETURN
*+-----------------------------------------------------------------------------+
*Ý Nombre        Ý admmsede.prg                                                Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Sistema       Ý sistema integral APLICA                                     Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Autor         Ý VETT                   Telf: 4841538                        Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Ciudad        Ý LIMA , PERU                                                 Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Direcci¢n     Ý Av. Bertello 170 - 401 Ciudad Satelite Sta. Rosa. - Callao  Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Prop¢sito     Ý Maestro de sedes                                            Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Creaci¢n      Ý 18/12/95                                                    Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Actualizaci¢n Ý                                                             Ý
*Ý               Ý                                                             Ý
*+-----------------------------------------------------------------------------+
*!*****************************************************************************
*!
*!      Procedure: ADMMSEDE
*!
*!          Calls: F1_BASE()          (function in belcsoft.PRG)
*!               : ABRIRDBFS          (procedure in belcsoft.PRG)
*!               : BROWS_SEDE         (procedure in belcsoft.PRG)
*!
*!*****************************************************************************
PROCEDURE admmsede
SAVE SCREEN
stit = [TABLA DE SEDES]
=f1_base(gsnomcia,[ADMINISTRADOR:]+stit,"USUARIO:"+gsusuario,"FECHA:"+DTOC(DATE()))

PRIVATE nx0,ny0,nx1,ny1,smodulo
PRIVATE m.btitulo,m.bdeta,m.bclave1,m.bclave2,m.bcampos,m.bfiltro,m.bbdorde
PRIVATE m.prgprep,m.prgpost,m.prgbusca,m.area_sel
STORE [] TO m.btitulo,m.bdeta,m.bclave1,m.bclave2,m.bcampos,m.bfiltro,m.bbdorde
STORE [] TO m.prgprep,m.prgpost,m.prgbusca,m.area_sel
smodulo = [TPO_CMB]

arctmp = pathuser+SYS(3)
IF !abrirdbfs_y()
   CLOSE DATA
   RETURN
ENDIF

* Variables del Browse *

ulttecla  = 0
m.primera = .T.
m.estoy   = [MOSTRANDO]
m.salir   = 1
SELE sede
GO TOP
DO brows_sede WITH .F.,[SEDE]
CLOSE DATA
RESTORE SCREEN
RETURN
*******************
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
PROCEDURE abrirdbfs_Y
*******************
=f1qeh([ABRE_DBF])
USE sedes IN 0 ALIAS sede
IF !USED()
   CLOSE DATA
   RETURN .F.
ENDIF
=f1qeh([OK])
RETURN
********************
*!*****************************************************************************
*!
*!      Procedure: BROWS_SEDE
*!
*!      Called by: ADMMSEDE           (procedure in belcsoft.PRG)
*!
*!          Calls: BDEF_SEDE()        (function in belcsoft.PRG)
*!               : F1BROWSE()         (function in F1BROWSE.PRG)
*!
*!*****************************************************************************
PROCEDURE brows_sede
********************
PARAMETER lmostrar,m.area

m.btitulo = [SEDES]
m.bdeta   = [_SEDES]
IF lmostrar
   m.bclave1 = []
   m.bclave2 = []
ELSE
   m.bclave1 = []
   m.bclave2 = []
ENDIF
m.bfiltro = [.T.]
m.bcampos = bdef_sede(smodulo)
m.bborde  = [DOUBLE]
m.area_sel= m.area
m.prgbusca= []
m.prgprep = []
m.prgpost = []
nx0 = 4
ny0 = 15
nx1 = 20
ny1 = 65

IF lmostrar
   lmodi_reg = .F.
   ladic_reg = .F.
   lborr_reg = .F.
ELSE
   lmodi_reg = .T.
   ladic_reg = .T.
   lborr_reg = .T.
ENDIF
m.lstatic = .F.
DO f1browse WITH m.bclave1,lmodi_reg,ladic_reg,lborr_reg,lmostrar
RETURN
******************
*!*****************************************************************************
*!
*!       Function: BDEF_SEDE
*!
*!      Called by: BROWS_SEDE         (procedure in belcsoft.PRG)
*!
*!          Calls: VSEDES()           (function in ?)
*!
*!*****************************************************************************
FUNCTION bdef_sede
******************
PARAMETERS smodulo
IF PARAMETERS() = 0
   WAIT "Falta definir campos a examinar(Browse)" WINDOW NOWAIT
   RETURN TO MASTER
ENDIF
PRIVATE scmp
DO CASE
CASE INLIST(smodulo,[SEDES])
   scmp = [CODIGO:H='COD.':V=vsedes():E=sErr,]
   scmp = scmp +[Nombre:H='Nombre  ',]
   scmp = scmp +[ACTIVA:H='A':V=ACTIVA$'X ']
OTHER
   WAIT "Falta definir plantilla de campos a examinar(Browse)" WINDOW NOWAIT
   RETURN TO MASTER
ENDCASE
RETURN scmp

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
*!*	*!*****************************************************************************
*!*	*!
*!*	*!      Procedure: ADMMTSIS
*!*	*!
*!*	*!          Calls: F1_BASE()          (function in belcsoft.PRG)
*!*	*!               : ABRIRDBFS          (procedure in belcsoft.PRG)
*!*	*!               : BROWS_TSIS         (procedure in belcsoft.PRG)
*!*	*!
*!*	*!*****************************************************************************
*!*	PROCEDURE admmtsis
*!*	PARAMETER arc_tabl
*!*	SAVE SCREEN
*!*	stit = [TABLAS DEL SISTEMA]
*!*	=f1_base(gsnomcia,[ADMINISTRADOR:]+stit,"USUARIO:"+gsusuario,"FECHA:"+DTOC(DATE()))

*!*	PRIVATE nx0,ny0,nx1,ny1,smodulo
*!*	PRIVATE m.btitulo,m.bdeta,m.bclave1,m.bclave2,m.bcampos,m.bfiltro,m.bbdorde
*!*	PRIVATE m.prgprep,m.prgpost,m.prgbusca,m.area_sel
*!*	STORE [] TO m.btitulo,m.bdeta,m.bclave1,m.bclave2,m.bcampos,m.bfiltro,m.bbdorde
*!*	STORE [] TO m.prgprep,m.prgpost,m.prgbusca,m.area_sel
*!*	PRIVATE xaliasact
*!*	xaliasact= ALIAS()
*!*	smodulo = [TABLAS]
*!*	lcierratcmb = .F.
*!*	arctmp = pathuser+SYS(3)
*!*	IF !abrirdbfs()
*!*	   **CLOSE DATA
*!*	   RETURN
*!*	ENDIF

*!*	* Variables del Browse *

*!*	ulttecla  = 0
*!*	m.primera = .T.
*!*	m.estoy   = [MOSTRANDO]
*!*	m.salir   = 1
*!*	SELE tcmb
*!*	GO TOP
*!*	DO brows_tsis WITH .F.,[TSIS]
*!*	**CLOSE DATA
*!*	IF lcierratcmb
*!*	   USE
*!*	ENDIF

*!*	IF !EMPTY(xaliasact)
*!*	   SELE (xaliasact)
*!*	ENDIF
*!*	KEYBOARD '{DNARROW}' CLEAR
*!*	RESTORE SCREEN
*!*	RETURN
*******************
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
*!*****************************************************************************
*!
*!      Procedure: BROWS_TSIS
*!
*!      Called by: ADMMTSIS           (procedure in belcsoft.PRG)
*!
*!          Calls: BDEF_CMP()         (function in belcsoft.PRG)
*!               : F1BROWSE()         (function in F1BROWSE.PRG)
*!
*!*****************************************************************************
*!*	PROCEDURE brows_tsis
*!*	********************
*!*	PARAMETER lmostrar,m.area

*!*	m.btitulo = [TABL_SIS]
*!*	m.bdeta   = [TABL_SIS]
*!*	IF lmostrar
*!*	   m.bclave1 = []
*!*	   m.bclave2 = []
*!*	ELSE
*!*	   m.bclave1 = []
*!*	   m.bclave2 = []
*!*	ENDIF
*!*	m.bfiltro = [.T.]
*!*	m.bcampos = bdef_cmp(smodulo)
*!*	m.bborde  = [DOUBLE]
*!*	m.area_sel= m.area
*!*	m.prgbusca= []
*!*	m.prgprep = []
*!*	m.prgpost = []
*!*	nx0 = 4
*!*	ny0 = 15
*!*	nx1 = 20
*!*	ny1 = 65

*!*	IF lmostrar
*!*	   lmodi_reg = .F.
*!*	   ladic_reg = .F.
*!*	   lborr_reg = .F.
*!*	ELSE
*!*	   lmodi_reg = .T.
*!*	   ladic_reg = .T.
*!*	   lborr_reg = .T.
*!*	ENDIF
*!*	m.lstatic = .F.
*!*	DO f1browse WITH m.bclave1,lmodi_reg,ladic_reg,lborr_reg,lmostrar
*!*	RETURN
******************
*!*****************************************************************************
*!
*!       Function: BDEF_TSIS
*!
*!          Calls: VCODTABL()         (function in ?)
*!
*!*****************************************************************************
FUNCTION bdef_tsis
******************
PARAMETERS smodulo
IF PARAMETERS() = 0
   WAIT "Falta definir campos a examinar(Browse)" WINDOW NOWAIT
   RETURN TO MASTER
ENDIF
PRIVATE scmp
DO CASE
CASE INLIST(smodulo,[TABLAS])
   scmp = [Codigo:H='Codigo':V=vCodTabl():E=sErr,]
   scmp = scmp +[Nombre:H='Nombre']

OTHER
   WAIT "Falta definir plantilla de campos a examinar(Browse)" WINDOW NOWAIT
   RETURN TO MASTER
ENDCASE
RETURN scmp
*!*****************************************************************************
*!
*!      Procedure: DESCRIPT
*!
*!*****************************************************************************
PROCEDURE descript
PARAMETER parametro1, parametro2
PRIVATE LEN,retorno,xchar,x,rotado,dato,enc1
SET TALK OFF
SET ECHO OFF
dato = parametro1
enc1 = parametro2
LEN=LEN(dato)
retorno=[]
x=1
DO WHILE LEN>0
   xchar=ASC(SUBSTR(dato,LEN,1))
   IF xchar>127
      xchar=xchar-127
   ELSE
      xchar=xchar+127
   ENDIF
   xchar=xchar+32-x
   IF xchar<0
      xchar=0
   ENDIF
   retorno=retorno+CHR(xchar)
   LEN=LEN-1
   x=x+1
ENDDO
rotado=[]
LEN=LEN(dato)
x=LEN - MOD(enc1,LEN)+1
DO WHILE LEN(rotado)<LEN
   IF x>LEN
      x=1
   ENDIF
   xchar=SUBSTR(retorno,x,1)
   rotado=rotado+xchar
   x=x+1
ENDDO
RETURN rotado

***************************************************************
*
*
*    PROCEDIMIENTO PKUNPRG : DESEMPAQUETA ARCHIVOS DE PKZIP
*
***************************************************************
*!*****************************************************************************
*!
*!       Function: PKUNPRG
*!
*!          Calls: PKUNPRG.SPR
*!
*!*****************************************************************************
*!*	*!*	FUNCTION pkunprg
*!*	*!*	m.diract = CURDIR()
*!*	*!*	m.diremp = GETDIR()
*!*	*!*	SET DEFA TO (m.diremp)
*!*	*!*	m.arcpk=GETFILE([ae;zip;atc;gme])
*!*	*!*	m.archivos=SPACE(11)
*!*	*!*	m.pass=.F.
*!*	*!*	m.control = 1
*!*	*!*	ulttecla = 0
*!*	*!*	DO pkunprg.spr
*!*	*!*	ulttecla = LASTKEY()
*!*	*!*	IF m.control=2
*!*	*!*	   ulttecla = 27
*!*	*!*	ENDIF
*!*	*!*	IF ulttecla = 27
*!*	*!*	   RETURN
*!*	*!*	ENDIF
*!*	*!*	lspass = IIF(m.pass,[-s],[])
*!*	*!*	m.archivos = TRIM(m.archivos)
*!*	*!*	IF _WINDOWS OR _MAC
*!*	*!*	   IF m.pass
*!*	*!*	      RUN /N pkunzip -s &arcpk. &archivos.
*!*	*!*	   ELSE
*!*	*!*	      RUN /N pkunzip &arcpk. &archivos.
*!*	*!*	   ENDIF
*!*	*!*	ELSE
*!*	*!*	   IF m.pass
*!*	*!*	      RUN pkunzip -s &arcpk. &archivos.
*!*	*!*	   ELSE
*!*	*!*	      RUN pkunzip  &arcpk. &archivos.
*!*	*!*	   ENDIF
*!*	*!*	ENDIF
*!*	*!*	SET DEFA TO (m.diract)
*****************
*!*****************************************************************************
*!
*!       Function: CFGUSUAR
*!
*!      Called by: SIS_MENU           (procedure in belcsoft.PRG)
*!
*!*****************************************************************************
FUNCTION cfgusuar
RETURN
*****************
*!*****************************************************************************
*!
*!       Function: CFGSISTE
*!
*!      Called by: SIS_MENU           (procedure in belcsoft.PRG)
*!
*!*****************************************************************************
FUNCTION cfgsiste
RETURN
*!*****************************************************************************
*!
*!       Function: F1ABREDBF
*!
*!       PROPOSITO: ABRIR UNA TABLA 
*!
*!*****************************************************************************
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
*!      Procedure: CASCADE
*!
*!*****************************************************************
*!*	*!*	PROCEDURE cascade
*!*	*!*	PARAMETERS aliasname, mode
*!*	*!*	* Recursive procedure to cascade deletes out of the aliasname file and
*!*	*!*	* its children.  Aliasname is the alias of a database known to be open.
*!*	*!*	* Delete any child records with a key of keyvalue, but only if the user
*!*	*!*	* has selected the cascading delete option for the child database.
*!*	*!*	PRIVATE i, aliasname, keyfield, keyvalue
*!*	*!*	aliasname = makealias(juststem(UPPER(ALLTRIM(aliasname))))

*!*	*!*	* First, see which files are children of this one and cascade them
*!*	*!*	FOR i = 1 TO m.numareas
*!*	*!*	   IF makealias(Juststem(UPPER(ALLTRIM(dbflist[i,m.pdbfnum])))) == m.aliasname
*!*	*!*	      * 'i' points at a child of 'aliasname'
*!*	*!*	      * Did the user elect to cascade deletes into this file?  Are there
*!*	*!*	      * any matching child records to delete?
*!*	*!*	      IF dbflist[i,m.cascadenum] = 'Y' and !EOF(dbflist[i,m.cstemnum])
*!*	*!*	         * Select the child database
*!*	*!*	         SELECT (dbflist[i,m.cstemnum])
*!*	*!*	         
*!*	*!*	         * We will already be positioned on the key value because of the
*!*	*!*	         * relations that have been set.
*!*	*!*	         keyfield = dbflist[i,m.cfldnum]
*!*	*!*	         keyvalue = &keyfield
*!*	*!*	         DO WHILE &keyfield == m.keyvalue and !EOF()
*!*	*!*	            * But first delete any applicable children of this child database
*!*	*!*	            DO cascade WITH dbflist[i,m.cstemnum], mode
*!*	*!*	            
*!*	*!*	            * Delete this child database record itself
*!*	*!*	            IF mode = "DELETE"
*!*	*!*	               DELETE
*!*	*!*	               IF !EOF()
*!*	*!*	                  SKIP
*!*	*!*	               ENDIF
*!*	*!*	            ENDIF
*!*	*!*	         ENDDO
*!*	*!*	      ENDIF
*!*	*!*	   ENDIF
*!*	*!*	ENDFOR
*!*	*!*	SELECT (aliasname)

*!*	*!*	RETURN


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
*!*	PROCEDURE showpop
*!*	* Determine if a popup can be displayed for this field
*!*	PARAMETERS sourcedbf, varname

*!*	PRIVATE sourcedbf, targetdbf, varname, i, retval

*!*	* varname is in Proper case coming from BROWSE
*!*	varname = UPPER(ALLTRIM(m.varname))

*!*	* See if any databases are keyed on varname
*!*	m.targetdbf = 0
*!*	FOR i = 1 TO m.numareas
*!*	   IF SUBSTR(dbflist[i,m.cfldnum],AT('.',dbflist[i,m.cfldnum])+1);
*!*	         == m.varname
*!*	      m.targetdbf = i
*!*	   ENDIF
*!*	ENDFOR

*!*	* Make sure we can display list
*!*	DO CASE
*!*	CASE m.targetdbf = 0
*!*	   WAIT WINDOW "No hay lista de selecci¢n disponible para ";
*!*	      +PROPER(m.varname)+'.' NOWAIT
*!*	   retval = "NULL"
*!*	CASE dbflist[m.targetdbf,m.cstemnum] = m.sourcedbf
*!*	   * The target database is the one we are in!

*!*	   * Show the popup, but don't allow any replacements.
*!*	   =disppop(dbflist[m.targetdbf,m.cdbfnum], m.varname)
*!*	   retval = "NULL"
*!*	OTHERWISE
*!*	   retval = disppop(dbflist[m.targetdbf,m.cdbfnum], m.varname)
*!*	ENDCASE

*!*	* Replace the selected value into the current field
*!*	IF TYPE("retval") = "C"
*!*	   IF retval <> "NULL"
*!*	      REPLACE &varname WITH retval
*!*	   ENDIF
*!*	ELSE
*!*	   REPLACE &varname WITH retval
*!*	ENDIF

*!*	RETURN
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
*!*	*!*	*!*****************************************************************************
*!*	*!*	*!
*!*	*!*	*!      Procedure: SIS_MNU1
*!*	*!*	*!
*!*	*!*	*!      Called by: belcsoft.PRG
*!*	*!*	*!
*!*	*!*	*!          Calls: ALM_S_VB.PRG
*!*	*!*	*!               : CPI_S_VB.PRG
*!*	*!*	*!               : CBD_S_VB.PRG
*!*	*!*	*!               : CMP_S_VB.PRG
*!*	*!*	*!               : TRF_S_VB.PRG
*!*	*!*	*!               : FCJ_S_VB.PRG
*!*	*!*	*!               : PLN_S_VB.PRG
*!*	*!*	*!               : CFGUSUAR()         (function in belcsoft.PRG)
*!*	*!*	*!               : ADMMTCMB           (procedure in belcsoft.PRG)
*!*	*!*	*!               : CFGSISTE()         (function in belcsoft.PRG)
*!*	*!*	*!
*!*	*!*	*!*****************************************************************************
*!*	*!*	PROCEDURE sis_mnu1
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
*!*	*!*	DEFINE BAR 2 OF aplicacion PROMPT "\<VENTAS"

*!*	*!*	ON SELECTION BAR 1 OF aplicacion DO alm_s_vb
*!*	*!*	ON SELECTION BAR 2 OF aplicacion DO vta_s_vb


*!*	*!*	DEFINE POPUP configurac MARGIN RELATIVE SHADOW COLOR SCHEME 4
*!*	*!*	DEFINE BAR _mfi_setup OF configurac PROMPT "\<Impresoras"
*!*	*!*	DEFINE BAR 2 OF configurac PROMPT "\-"
*!*	*!*	DEFINE BAR 3 OF configurac PROMPT "\<Tipos de Cambio"
*!*	*!*	DEFINE BAR 4 OF configurac PROMPT "\<Sistemas"
*!*	*!*	*ON SELECTION BAR 1 OF configurac do cfgprint
*!*	*!*	ON SELECTION BAR 2 OF configurac DO cfgusuar
*!*	*!*	ON SELECTION BAR 3 OF configurac DO admmtcmb
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
		
*********************
function cap_almdtran  && Capturamos registros de la cabecera de almacen
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
			PcTipMov=''
			PcCodMov=''
			PcNroDoc=''			
		case PARAMETERS()=3
			PcCodMov=''
			PcNroDoc=''			
		case PARAMETERS()=4
			PcNroDoc=''			
		case PARAMETERS()=5
			PcNroDoc=TRIM(PcNroDoc)
	ENDCASE
	LsWhere = [almdtran.Subalm+almdtran.TipMov+almDtran.CodMov+almDtran.NroDoc+STR(almdtran.nroitm,3,0)=PcSubAlm+PcTipMov+PcCodMov+PcNroDoc]
ENDIF



LOCAL lsRutaDtra,LsRutaCatg
lsRutaDtra=goentorno.remotepathentidad('almdtran')
lsRutaCatg=goentorno.remotepathentidad('almcatge')
IF USED(PcAlias)
	USE IN (PcAlias)
ENDIF
if empty(lsWhere)
	select * from lsRutaDtra into table (PcAlias)
ELSE
	IF VERSION(5)<700
		select almdtran.*,almcatge.desmat,almcatge.undstk,RECNO('almdtran') AS NROREG from &LsRutaDtra inner join &LsRutaCatg on ;
		 almdtran.codmat=almcatge.codmat where &LsWhere. ;
		 into Cursor temporal
 		SELE Temporal
		LcArcTmp = GoEntorno.TmpPath+SYS(3)
		COPY TO (LcArcTmp)
		USE IN TEMPORAL
		SELE 0
		USE (LcArcTmp) ALIAS (PcAlias) exclusive
		
	ELSE
		select almdtran.*,almcatge.desmat,almcatge.undstk,RECNO('almdtran') AS NROREG from &LsRutaDtra inner join &LsRutaCatg on ;
		 almdtran.codmat=almcatge.codmat where &LsWhere. ;
		 into Cursor (PcAlias) readwrite
	ENDIF
endif		
************************
FUNCTION CORRELATIVO_ALM
************************
Lparameters _tabla,_tipMov,_CodMov,_Almacen,_Valor

_Tabla=goentorno.remotepathentidad(_Tabla)
SELECT * from (_tabla) where TipMov=_Tipmov and Codmov=_Codmov and SubAlm=_Almacen INTO CURSOR C_CDOC
Local LsCampo,LnNroDoc,LsPicture,LnLenSufijo,LnLenNDoc,LsCampo2
IF GlCorrU_I
**	m.sNroDoc = RIGHT(REPLI("0",LEN(m.sNroDoc)) + LTRIM(STR(cDOC->NroDoc)),LEN(m.sNroDoc))
	LsCampo = 'C_CDOC.NroDoc'
	LsCampo2 = 'NroDoc'
ELSE
	LsCampo = 'C_CDOC.NDOC'+XsNroMes
	LsCampo2 = 'NDOC'+XsNroMes
ENDIF	
LnNroDoc= EVAL(LsCampo)
IF EMPTY(LnNroDoc) OR ISNULL(LnNroDoc)
	WAIT WINDOW NOWAIT "Falta definir en maestro de correlativos por almacen"
ENDIF
LsPicture = "@L "+REPLI('#',LEN(c_dtra.NroDoc))
LnLenNDoc = LEN(c_dtra.NroDoc) - LEN(XsNroMes)
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
RETURN  RIGHT(REPLI('0',LEN(c_dtra.NroDoc)) + LTRIM(STR(LnNroDoc)), 10)




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


FUNCTION ConcatenaValores
PARAMETERS _cCmpKey,_cDataSource,_cSeparador
IF EMPTY(_cCmpKey) 
	RETURN ''
ENDIF

IF EMPTY(_cDataSource) 
	RETURN ''
ENDIF
IF EMPTY(_cSeparador) 
	_cSeparador = '+'
ENDIF

LOCAL LcValKey AS STRING 

LOCAL ARRAY  laValoresClaveDestino(1)
STORE '' TO laValoresClaveDestino,lcValKey
=chrtoarray(_cCmpKey , _cSeparador , @laValoresClaveDestino )
FOR LnNumCmp = 1 TO ALEN(laValoresClaveDestino)
	LsCmpEva 	=	_cDataSource+'.'+laValoresClaveDestino(LnNumCmp)
	LcValKey	= LcValKey + EVALUATE(LsCmpEva)
ENDFOR

RETURN LcValKey


********************************************
FUNCTION Cargar_actividad_defecto_detalle_OT
********************************************
PARAMETERS _oRegistro,_cTabla_destino,_cTabla_Origen
LOCAL _CodCia,_CodigoTA,_CodigoTM,_CodMaq,_Num_OrdReq
_CodCia		=_oRegistro.CodCia 
_CodigoTA	=_oRegistro.CodigoTA
_CodigoTM	=_oRegistro.CodigoTM
_CodMaq		=_oRegistro.CodMaq
_Num_OrdReq	=_oRegistro.Num_OrdReq

LlHayDatosOrigen = .f.
SELECT (_cTabla_Origen)
SEEK _CodCia+_CodigoTA+CodigoTM+_CodMaq
IF FOUND() AND !EOF()
	LlHayDatosOrigen = .t.
ENDIF
** Nos posicionamos en la primera parte , del el primer equipo de la primera seccion de la maquina 
SELECT SECM
SEEK _CodCia+_CodigoTA+_CodigoTM+_CodMaq
SELECT EQSE
SEEK _CodCia+_CodigoTA+_CodigoTM+_CodMaq+SECM.CodSec
SELECT PXEQ
SEEK _CodCia+_CodigoTA+_CodigoTM+_CodMaq+SECM.CodSec+EQSE.CodEqu
SELECT 	ACTI
SEEK _CodCia+_CodigoTA+_CodigoTM+_CodMaq+SECM.CodSec+EQSE.CodEqu+PXEQ.CodPar

*

SELECT (_cTabla_Destino)
replace CodCia  		WITH	_CodCia 
replace CodigoTA		WITH	_CodigoTA 	
replace CodigoTM		WITH	_CodigoTM
replace CodMaq			WITH	_CodMaq
replace Num_OrdReq		WITH	_Num_OrdReq
 	
REPLACE CodSec		WITH	SECM.CodSec	
REPLACE CodEqu		WITH	EQSE.CodEqu
REPLACE CodPar		WITH	PXEQ.CodPar
REPLACE Cod_activi	WITH 	ACTI.Cod_activi
REPLACE Parametro	WITH 	_oRegistro.Parametro
REPLACE DesSec		WITH 	SECM.DesSec
REPLACE Desc_Equ	WITH 	EQSE.Desc_Equ
REPLACE Desc_Parte	WITH 	PXEQ.Desc_Parte
REPLACE Des_Act		WITH 	ACTI.Des_Act

******************************
FUNCTION Borra_detalle_ot_mtto
******************************
PARAMETERS _ccampos_PK,_cvalor_pk

DELETE FROM MOUT WHERE EVALUATE(_ccampos_PK) = _cvalor_pk
DELETE FROM MTUT WHERE EVALUATE(_ccampos_PK) = _cvalor_pk
DELETE FROM TARR WHERE EVALUATE(_ccampos_PK) = _cvalor_pk
 

RETURN
**************************
FUNCTION Verificar_Almacen 
**************************
PARAMETERS _TpoRef,_NuOrde,_FeOrde,_CodCia,_CodigoTA,_CodigoTM,_CodMaq,_CodSec,_CodEqu,_CodPar,_Parametro,_Cod_Activi
LOCAL lSoloCheq as Boolean
IF PARAMETERS()=4
	lSoloCheq = .t.
ENDIF

IF PARAMETERS()<2
	_FeOrde = {}
ENDIF
ASSERT VARTYPE(_Nuorde)='C' MESSAGE 'Numero de orden de trabajo debe ser C(10)'

IF EMPTY(_NuOrde)
	RETURN .f.
ENDIF
LOCAL LoDB as DataAdmin OF k:\aplvfp\classgen\vcxs\FPDosvr.vcx
LoDB = CREATEOBJECT("FPDosvr.DataAdmin")
*
DIMENSION aAlias(10,2)
STORE '' TO aALIAS
LlRetVal = .T.
#include CONST.H
*
** La integración  con el sistema de almacen depende de si es con el sistema propio
DO CASE 
	CASE INLIST(GsSigCia,'DELFINES')
		**
		IF !LoDB.AbrirTabla('ABRIR','IVMART01','CATG','A1','')		
		   aALIAS(1,1) = ALIAS()
		   aALIAS(1,2) = '*'
		ENDIF
		**
		IF !LoDB.AbrirTabla('ABRIR','IVTMOV02','DTRA','A1','')		
		   aALIAS(1,1) = ALIAS()
		   aALIAS(1,2) = '*'
		ENDIF
		*!*	_FeOrde = {}  		&& <@j@> Borrar esta linea para probar todo el codigo
		*!*	_NuOrde	= '00081'	&& <@j@> Borrar esta linea para probar todo el codigo

		LsWhile = IIF(EMPTY(_FeOrde),"NuOrde=RIGHT(_NuOrde,5)","DTOS(FeOrde)+RIGHT(NuOrde,5) =DTOS(_FeOrde)+_NuOrde")

	**CASE INLIST(GsSigCia,'PROSARIO','DEMO')
	OTHERWISE  && Cuando esta integrado al almacen del sistema O-NEGOCIOS
		IF !LoDB.AbrirTabla('ABRIR','ALMCATGE','CATG','CATG01','','',_CodCia,LEFT(DTOS(_FeOrde),4))		
		   aALIAS(1,1) = ALIAS()
		   aALIAS(1,2) = '*'
		ENDIF
		**
		IF !LoDB.AbrirTabla('ABRIR','ALMDTRAN','DTRA','DTRA04','','',_CodCia,LEFT(DTOS(_FeOrde),4) )		
		   aALIAS(1,1) = ALIAS()
		   aALIAS(1,2) = '*'
		ENDIF
**		LsWhile = IIF(EMPTY(_FeOrde),"TpoRef+NroRef=_TpoRef+TRIM(_NuOrde)","DTOS(FchDoc)+TpoRef+NroRef =DTOS(_FeOrde)+_TpoRef+TRIM(_NuOrde)")
		LsWhile = "TpoRef+NroRef=_TpoRef+PADR(_NuOrde,LEN(NroRef))"	
ENDCASE		
IF USED("c_dtra")
	USE IN c_dtra
ENDIF

LlExisteO_T = .F.
SELECT dtra 
*!*	IF !EMPTY(_FeOrde)
*!*		SEEK DTOS(_FeOrde)
*!*		IF !FOUND() AND RECNO(0)>0
*!*			GO RECNO(0)
*!*		ENDIF
*!*		SCAN FOR (LsWhile)
*!*			LlExisteO_T = .F.
*!*		ENDSCAN 
*!*	ELSE
	LsSqlCmd="SELECT * FROM dtra WHERE " + LsWhile + " into cursor c_dtra"
	&LsSqlCmd.
*!*	ENDIF

IF USED("c_dtra")
	IF !EOF("c_dtra")
		IF lSoloCheq	
			RETURN .T.
		ENDIF
		** Estos son parametros **
		m.CodCia		=	_CodCia
		m.CodigoTa		=	_CodigoTa
		m.CodigoTm		=	_CodigoTm
		m.CodMaq		=	_CodMaq
		m.CodSec		=	_CodSec
		m.CodEqu 		=	_CodEqu 
		m.CodPar		=   _CodPar 
		m.Parametro		= 	_Parametro 
		m.Cod_Activi	= 	_Cod_Activi
		LsNroO_T 		= RIGHT(REPLICATE('0',10)+TRIM(_NuOrde),10)
		LsLlaveMUTI = m.CODCIA+m.CODIGOTA+m.CODIGOTM+m.CODMAQ+m.CODSEC+m.CODEQU+m.CODPAR+m.PARAMETRO+m.COD_ACTIVI+LsNroO_T
		DO CASE 
			CASE INLIST(GsSigCia,'DELFINES')
				SELECT c_dtra
				SCAN
					SCATTER memvar
					m.codmat		=	m.cdArti
					m.Pu_soles_r	=	m.Cosmerc
					m.Cant_Util		=	m.CaArti
					m.Unidad		=   IIF(SEEK(cdfami+cdsufa+cdarti,'CATG'),CATG.Cdunis,'N/A') 
					m.TablaUnd		=	'UD'	
					m.Num_OrdReq	=	_NuOrde
					INSERT INTO MTUT FROM memvar
				ENDSCAN
			OTHERWISE 
				LOCAL LoNeg as oNegocios OF "k:\aplvfp\classgen\vcxs\FPdosvr.vcx" 
				LoNeg = CREATEOBJECT('FPDosvr.oNegocios')
				
				DELETE FROM MTUT WHERE CODCIA+CODIGOTA+CODIGOTM+CODMAQ+CODSEC+CODEQU+CODPAR+PARAMETRO+COD_ACTIVI+NUM_ORDREQ = LsLlaveMUTI
				SELECT c_dtra
				SCAN

					SCATTER memvar
					=SEEK(m.CodMat,'CATG')
*					m.codmat		=	m.cdArti
					m.CdFami		=	m.CodMat
					m.CdSufa		=	m.CodMat
					m.Pu_soles_r	=	LoNeg.costo_almacen(GsCodSed,m.CodMat,m.FchDoc,1,COSTO_UNIT_ALMACEN) 	
					m.Pu_Dolar_r	=   LoNeg.costo_almacen(GsCodSed,m.CodMat,m.FchDoc,2,COSTO_UNIT_ALMACEN) 	
*					LfCostoUni = LoNeg.costo_almacen(GsCodSed,ITEM.CodMat,LdFecha_alm,XiCodMon,COSTO_UNIT_ALMACEN) 	
					m.Cant_Util		=	m.Candes
					m.Unidad		=   IIF(EMPTY(m.UndVta),CATG.UndStk,m.UndVta)
					m.TablaUnd		=	'UD'	
					m.Num_OrdReq	=	RIGHT(REPLICATE('0',10)+TRIM(_NuOrde),10)
					INSERT INTO MTUT FROM memvar
				ENDSCAN
				RELEASE LoNeg
		ENDCASE 
		
		RETURN .t.
	ELSE
		RETURN .f.
	ENDIF
ELSE
	RETURN .F.	
ENDIF

*****************************
FUNCTION __Mto_Mante_x_equipo
***************************** 
DO CASE 
CASE Quiebre1='A'
	replace col01 WITH desmaq 
	replace col02 wITH Ubic_actua 
	replace col03 wITH Marca 
	replace col04 wITH Modelo
	replace col05 wITH noserie
CASE Quiebre1='B'
	replace col01 WITH DTOC(FchDoc)+SPACE(5)+NroOrd + IIF(Codmon=1,'  M.N.',' M.E.')+ "  T/C:"+TRANSFORM(TpoCmb,"9.999") +" "
	replace col02 wITH Proveedor &&Autor 
	replace col03 wITH IIF(SEEK('MT'+TRIM(Tipo),'TABL'),TABL.Nombre,'No definido') 
	replace col04 wITH DTOC(Fchprog)
	replace col05 wITH Nro_O_C    && Des_narr
**CASE Quiebre1='C1'	
**	REPLACE col07 WITH TRIM(SecEquPar) 	
CASE Quiebre1='C'
	** Longitud disponible
	**LnLenAct=IIF(LEN(TRIM(DesAct))>0,LEN(TRIM(DesAct)),2)

	LnLenAct=LEN(Col01) - (LEN(TRIM(codact)) + 1)
	replace col01 WITH TRIM(codact)+SPACE(1)+desact
	replace col02 WITH SUBSTR(DesAct,LnLenAct+1)
	replace col03 WITH SUBSTR(DesAct,LnLenAct+1+LEN(Col02))
	replace col04 WITH STR(NroTare,0)
	IF CostoAc>0
		replace col05 wITH PADL(TRANSFORM(CostoAC,'9,999,999,999.99'),16)
	ENDIF
	REPLACE col07 WITH TRIM(desact) && TRIM(codact)+SPACE(1)+TRIM(desact)
CASE Quiebre1='D'
	replace col01 WITH SPACE(2)+Especial
	replace col02 WITH Nomper
	replace col03 WITH PADL(TRANSFORM(Horusad,'999.99'),10)
	replace col04 WITH []
	replace col05 wITH PADL(TRANSFORM(CostoMo,'9,999,999,999.99'),16)

CASE Quiebre1='E'
	LenDes=LEN(Col01) - (LEN(TRIM(codmat)) + 3)
	replace col01 WITH SPACE(2)+TRIM(CodMat)+SPACE(1)+Desmat
	replace col02 WITH SUBSTR(DesMat,LenDes+1)
	replace col03 WITH PADL(TRANSFORM(CanMat,'999.99'),10)
	replace col04 WITH PADL(Unidad,LEN(Col04))
	replace col05 WITH PADL(TRANSFORM(CostoMt,'9,999,999,999.99'),16)

CASE Quiebre1='G1'
	REPLACE col01 WITH REPLICATE("=",LEN(COL01))
	REPLACE col02 WITH REPLICATE("=",LEN(COL02))
	REPLACE col03 WITH REPLICATE("=",LEN(COL03))
	REPLACE col04 WITH REPLICATE("=",LEN(COL04))
	REPLACE col05 WITH REPLICATE("=",LEN(COL05))
	
ENDCASE 

RETURN
***********************************
FUNCTION __Mto_Mante_x_equipo_linea
*********************************** 
PARAMETERS oRegLin
m.AreaAct = SELECT()
DO CASE 

	CASE oRegLin.Quiebre1='G'
		oRegLin.CodAct		= "__"	
		SELECT Temporal
		APPEND BLANK 
		GATHER NAME oRegLin
		
		REPLACE col01 WITH REPLICATE("-",LEN(COL01))
		REPLACE col02 WITH REPLICATE("-",LEN(COL02))
		REPLACE col03 WITH REPLICATE("-",LEN(COL03))
		REPLACE col04 WITH REPLICATE("-",LEN(COL04))
		REPLACE col05 WITH REPLICATE("-",15)
		
	CASE oRegLin.Quiebre1='M'
		oRegLin.NroOrd		= REPLICATE("_",LEN(oRegLin.NroOrd))
		oRegLin.CodAct		= "__"	

		SELECT Temporal
		APPEND BLANK 
		GATHER NAME oRegLin
		
		REPLACE col01 WITH REPLICATE("=",LEN(COL01))
		REPLACE col02 WITH REPLICATE("=",LEN(COL02))
		REPLACE col03 WITH REPLICATE("=",LEN(COL03))
		REPLACE col04 WITH REPLICATE("=",LEN(COL04))
		REPLACE col05 WITH REPLICATE("=",15)
	
ENDCASE 

SELECT(m.AreaAct)
*************************************
FUNCTION __Mto_Mante_x_equipo_Totales
*************************************
PARAMETERS oRegLin
m.AreaAct = SELECT()

DO CASE 
CASE oRegLin.Quiebre1='DT'
	SELECT Temporal
	APPEND BLANK 
	GATHER NAME oRegLin
	REPLACE col01 WITH REPLICATE(".",LEN(COL01))
	REPLACE col02 WITH REPLICATE(".",LEN(COL02))
	REPLACE col03 WITH REPLICATE(".",LEN(COL03))
	REPLACE col04 WITH REPLICATE(".",LEN(COL04))
	REPLACE col05 WITH REPLICATE(".",LEN(COL05)-3)
	APPEND BLANK 	
	GATHER NAME oRegLin
	REPLACE Col03 WITH "Total Mano de Obra -->" 
	REPLACE col05 WITH PADL(TRANSFORM(oRegLin.CostoMO,'99,999,999,999.99'),17)
	APPEND BLANK 
	GATHER NAME oRegLin
	REPLACE col01 WITH REPLICATE("-",LEN(COL01))
	REPLACE col02 WITH REPLICATE("-",LEN(COL02))
	REPLACE col03 WITH REPLICATE("-",LEN(COL03))
	REPLACE col04 WITH REPLICATE("-",LEN(COL04))
	REPLACE col05 WITH REPLICATE("-",LEN(COL05)-3)

CASE oRegLin.Quiebre1='ET'
	SELECT Temporal
	APPEND BLANK 
	GATHER NAME oRegLin
	REPLACE col01 WITH REPLICATE(".",LEN(COL01))
	REPLACE col02 WITH REPLICATE(".",LEN(COL02))
	REPLACE col03 WITH REPLICATE(".",LEN(COL03))
	REPLACE col04 WITH REPLICATE(".",LEN(COL04))
	REPLACE col05 WITH REPLICATE(".",LEN(COL05)-3)
	APPEND BLANK 	
	GATHER NAME oRegLin
	REPLACE Col03 WITH "Total Materiales -->" 
	REPLACE col05 WITH PADL(TRANSFORM(oRegLin.CostoMt,'99,999,999,999.99'),17)
	APPEND BLANK 
	GATHER NAME oRegLin
	REPLACE col01 WITH REPLICATE("-",LEN(COL01))
	REPLACE col02 WITH REPLICATE("-",LEN(COL02))
	REPLACE col03 WITH REPLICATE("-",LEN(COL03))
	REPLACE col04 WITH REPLICATE("-",LEN(COL04))
	REPLACE col05 WITH REPLICATE("-",LEN(COL05)-3)

CASE oRegLin.Quiebre1='G'
	oRegLin.CodAct		= "__"	
	SELECT Temporal
	APPEND BLANK 
	GATHER NAME oRegLin
	REPLACE col01 WITH REPLICATE(".",LEN(COL01))
	REPLACE col02 WITH REPLICATE(".",LEN(COL02))
	REPLACE col03 WITH REPLICATE(".",LEN(COL03))
	REPLACE col04 WITH REPLICATE(".",LEN(COL04))
	REPLACE col05 WITH REPLICATE(".",LEN(COL05)-3)
	APPEND BLANK 	
	GATHER NAME oRegLin
	REPLACE Col03 WITH "Total O/T -->" 
	REPLACE col05 WITH PADL(TRANSFORM(oRegLin.CostoMt,'99,999,999,999.99'),17)
	APPEND BLANK 
	GATHER NAME oRegLin
	REPLACE col01 WITH REPLICATE("-",LEN(COL01))
	REPLACE col02 WITH REPLICATE("-",LEN(COL02))
	REPLACE col03 WITH REPLICATE("-",LEN(COL03))
	REPLACE col04 WITH REPLICATE("-",LEN(COL04))
	REPLACE col05 WITH REPLICATE("-",LEN(COL05)-3)	
CASE oRegLin.Quiebre1='M'
	oRegLin.NroOrd		= REPLICATE("_",LEN(oRegLin1.NroOrd))
	oRegLin.CodAct		= "__"	
	SELECT Temporal
	APPEND BLANK 
	GATHER NAME oRegLin
	REPLACE col01 WITH REPLICATE(".",LEN(COL01))
	REPLACE col02 WITH REPLICATE(".",LEN(COL02))
	REPLACE col03 WITH REPLICATE(".",LEN(COL03))
	REPLACE col04 WITH REPLICATE(".",LEN(COL04))
	REPLACE col05 WITH REPLICATE(".",LEN(COL05)-3)
	APPEND BLANK 	
	GATHER NAME oRegLin
	REPLACE Col02 WITH "Total "+TRIM(oReglin.Desmaq)+" -->" 
	REPLACE col05 WITH PADL(TRANSFORM(oRegLin.CostoMt,'99,999,999,999.99'),17)
	APPEND BLANK 
	GATHER NAME oRegLin
	REPLACE col01 WITH REPLICATE("=",LEN(COL01))
	REPLACE col02 WITH REPLICATE("=",LEN(COL02))
	REPLACE col03 WITH REPLICATE("=",LEN(COL03))
	REPLACE col04 WITH REPLICATE("=",LEN(COL04))
	REPLACE col05 WITH REPLICATE("=",LEN(COL05)-3)	
	
CASE oRegLin.Quiebre1='T'
	oRegLin.NroOrd		= REPLICATE("_",LEN(oRegLin1.NroOrd))
	oRegLin.CodAct		= "__"	
	SELECT Temporal
	APPEND BLANK 
	GATHER NAME oRegLin
	REPLACE col01 WITH REPLICATE(".",LEN(COL01))
	REPLACE col02 WITH REPLICATE(".",LEN(COL02))
	REPLACE col03 WITH REPLICATE(".",LEN(COL03))
	REPLACE col04 WITH REPLICATE(".",LEN(COL04))
	REPLACE col05 WITH REPLICATE(".",LEN(COL05)-3)
	APPEND BLANK 	
	GATHER NAME oRegLin
	REPLACE Col03 WITH "TOTAL GENERAL -->" 
	REPLACE col05 WITH PADL(TRANSFORM(oRegLin.CostoMt,'99,999,999,999.99'),17)
	APPEND BLANK 
	GATHER NAME oRegLin
	REPLACE col01 WITH REPLICATE("=",LEN(COL01))
	REPLACE col02 WITH REPLICATE("=",LEN(COL02))
	REPLACE col03 WITH REPLICATE("=",LEN(COL03))
	REPLACE col04 WITH REPLICATE("=",LEN(COL04))
	REPLACE col05 WITH REPLICATE("=",LEN(COL05)-3)	

ENDCASE 

SELECT(m.AreaAct)



********************************
FUNCTION UPDATE_Guia_almacen_IG
*******************************
PARAMETERS _NuOrde
IF EMPTY(_NuOrde)
	RETURN .f.
ENDIF
LOCAL LoDB as DataAdmin OF k:\aplvfp\classgen\vcxs\FPDosvr.vcx
LoDB = CREATEOBJECT("FPDosvr.DataAdmin")

IF !LoDB.AbrirTabla('ABRIR','IVTMOV01','CTRA','A4','')		
	RETURN .f.
ENDIF
LLRETURN = .F.	
IF VARTYPE(CTRA.OA)='C'

	LsCmdSql = "UPDATE CTRA SET OA='X' where NuOrde = "+_NuOrde
	&LsCmdSql.
	
	LsCmdSqlCheck="SELECT * FROM CTRA where NuOrde = "+_NuOrde +" INTO Cursor Xtmp"
	SELECT xTmp

	IF OA='X' AND NuOrde = _NuOrde
		LLRETURN = .T.	
	ENDIF
	USE IN xtmp
ENDIF
RETURN llReturn






