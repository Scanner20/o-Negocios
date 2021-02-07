SET DISPLAY TO VGA25
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 

LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','CBDTOPER','OPER','OPER01','')
DO def_teclas IN FxGen_2

lReturnOk=goentorno.open_dbf1('ABRIR','CBDTOPER','OPER','OPER01','')

DO NroRela
RELEASE LoDatAdm

IF WEXIST('__WFONDO')
	RELEASE WINDOWS __WFONDO
ENDIF
CLEAR 
CLEAR MACROS
IF USED('OPER')
	USE IN OPER
ENDIF

*****************
PROCEDURE NroRela
XiNroRel=0
*** Pintamos pantalla *************
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9,999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "N╖ RELACION"
Do Fondo WITH cTit4,cTit2,cTit3,cTit1
@ 7,4 FILL  TO 20,74      COLOR W/N
@  6,5 SAY "зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©" COLOR SCHEME 11
@  7,5 SAY "Ё                          *** GIRO DE CHEQUES ***                    Ё" COLOR SCHEME 11
@  8,5 SAY "Ё                                                                     Ё" COLOR SCHEME 11
@  9,5 SAY "Ё                                                                     Ё" COLOR SCHEME 11
@ 10,5 SAY "Ё                                                                     Ё" COLOR SCHEME 11
@ 11,5 SAY "Ё                                                                     Ё" COLOR SCHEME 11
@ 12,5 SAY "Ё           No. de Relaci╒n :                                         Ё" COLOR SCHEME 11
@ 13,5 SAY "Ё                                                                     Ё" COLOR SCHEME 11
@ 14,5 SAY "Ё                                                                     Ё" COLOR SCHEME 11
@ 15,5 SAY "Ё                                                                     Ё" COLOR SCHEME 11
@ 16,5 SAY "Ё                                                                     Ё" COLOR SCHEME 11
@ 17,5 SAY "Ё                                                                     Ё" COLOR SCHEME 11
@ 18,5 SAY "Ё                                                                     Ё" COLOR SCHEME 11
@ 19,5 SAY "юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды" COLOR SCHEME 11
SELECT OPER
SEEK "006"
IF ! FOUND()
   GsMsgErr = "No registrado la operaci╒n de caja egreso"
   DO LIB_MERR WITH 99
   
   RETURN
ENDIF
XiNroRel = NROREL
@ 12,37 Get XiNroRel PICT "@L ######"
READ
IF LASTKEY() = Escape_
   
   RETURN
ENDIF
IF Rec_lock(5)
   REPLACE NROREL WITH XiNroRel
ENDIF

RETURN
