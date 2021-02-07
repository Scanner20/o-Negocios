do form cbd_cbdmauxi
RETURN 

PROCEDURE CbdMauxi_dos
PARAMETER cClfAux
IF PARAMETER() = 0
   cClfAux = ""
ENDIF
*
**sele 3
**use \aplica\cia001\almtdivf order divf01 alias divf
**if !used(3)
**   close data
**   return
**endif
*
SELECT 2
USE CBDMTABL order TABL01 ALIAS TABL
IF ! USED(2)
   CLOSE DATA
   RETURN
ENDIF
SELE 1
USE CBDMAUXI order AUXI01 ALIAS AUXI
IF ! USED(1)
   CLOSE DATA
   RETURN
ENDIF
**** Variables *****
STORE "" TO XsTlfAux,XsCodAux,XsNOMAux,XsCLFAUX,XsDirAux,XsRucAux,XsTPOAUX,XsLocAux
STORE "" TO XsNomC_V,XSCALAUX,XSINGEGR,XSFLGING
store [] to xscodfam,xsdisaux
*** Pintamos pantalla *************
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "CUENTAS AUXILIARES"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
@ 09,4 FILL  TO 22,73      COLOR W/N
@ 23,0
@ 08,5 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" COLOR SCHEME 11
@ 09,5 SAY "³                                                                     ³" COLOR SCHEME 11
@ 10,5 SAY "³  CLASIFICACION :                                                    ³" COLOR SCHEME 11
@ 11,5 SAY "³                                                                     ³" COLOR SCHEME 11
@ 12,5 SAY "³         CODIGO :                                                    ³" COLOR SCHEME 11
@ 13,5 SAY "³                                                                     ³" COLOR SCHEME 11
@ 14,5 SAY "³    DESCRIPCION :                                                    ³" COLOR SCHEME 11
@ 15,5 SAY "³                                                                     ³" COLOR SCHEME 11
@ 16,5 SAY "³                                                                     ³" COLOR SCHEME 11
@ 17,5 SAY "³                                                                     ³" COLOR SCHEME 11
@ 18,5 SAY "³                                                                     ³" COLOR SCHEME 11
@ 19,5 SAY "³                                                                     ³" COLOR SCHEME 11
@ 20,5 SAY "³                                                                     ³" COLOR SCHEME 11
@ 21,5 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" COLOR SCHEME 11

****** Solicitando la Clasificaci¢n a trabajar *********
SELECT AUXI
IF EMPTY(cClfAux)
   GOTO TOP
   XsCLFAUX = CLFAUX
ELSE
   XsCLFAUX = cCLFAUX
   SELECT TABL
   SEEK "01"+XsClfAux
   @ 10,24 SAY XsClfAux
   @ 10,30 SAY TABL->Nombre PICT "@S30"
ENDIF

DO WHILE EMPTY(cClfAux)
   SELECT TABL
   XsTabla = "01"
   @ 10,24 GET XsClfAux PICTURE REPLICATE("9",LEN(XsClfAux))
   READ
   UltTecla = LASTKEY()
   IF UltTecla = Escape
      CLOSE DATA
      RETURN
   ENDIF
   IF UltTecla = F8 .OR. EMPTY(XsCLFaUX)
      IF ! CBDBUSCA("TABL")
         LOOP
      ENDIF
      XsClfAux = LEFT(CODIGO,len(XsClfAux))
      UltTecla = Enter
   ENDIF
   IF ! SEEK("01"+XsClfAux,"TABL")
      GsMsgErr = "Clasificaci¢n no registrada"
      DO LIB_MERR WITH 99
      LOOP
   ENDIF
   @ 10,24 SAY XsClfAux
   @ 10,30 SAY TABL->Nombre PICT "@S30"
   EXIT
ENDDO
LsClfAux = XsClfAux
iDigitos = tabl->Digitos
IF iDigitos > LEN(AUXI->CODAUX) .OR. iDigitos < 1
   iDigitos = LEN(AUXI->CODAUX)
ENDIF
SELECT AUXI
IF XsClfAux = "01 "
   @ 15,5 SAY "³    DIRECCION   :                                                    ³" COLOR SCHEME 11
   @ 16,5 SAY "³    DISTRITO    :                                                    ³" COLOR SCHEME 11   
   @ 17,5 SAY "³    R.U.C.      :                                                    ³" COLOR SCHEME 11
   @ 18,5 SAY "³    TELEFONOS   :                                                    ³" COLOR SCHEME 11
   @ 19,5 SAY "³    CONTACTO    :                                                    ³" COLOR SCHEME 11
   @ 20,5 SAY "³    CALIFICACION:                                                    ³" COLOR SCHEME 11
ENDIF
IF XSCLFAUX = "99 "
   @ 15,5 SAY "³    INGRE\EGRES :                                                    ³" COLOR SCHEME 11
ENDIF
*
if xsclfaux = [60]  &&& Insumos
   @ 15,5 SAY "³        FAMILIA :                                                    ³" COLOR SCHEME 11
endif
*
**********************************************************************
** Rutina principal *****
**********************************************************************
GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] C¢digo [PgUp] [PgDn] [^PgUp] [^PgDn] Otro Registro"
DO LIB_MTEC WITH 99
DO EDITA WITH 'Llave','Muestra','Editar','Elimina','','CLFAUX',LsClfAux,'CMA'
CLOSE DATA
CLEAR
RETURN
*********************************************************************
* Pide Variables de Busqueda ( Crear , Modificar , Anular )          *
**********************************************************************
PROCEDURE Llave
****************
GsMsgKey = "[Esc] Cancela         [Enter] [F10] Acepta         [F8] Consulta "
DO LIB_MTEC WITH 99
XsCodAux = CodAux
UltTecla = 0
i        = 1
DO WHILE ! INLIST(UltTecla,CTRLW,ESCAPE,F10)
   DO CASE
      CASE i = 1
         IF Crear
            SEEK XsClfAux
            XsCodAux = PADL("1",iDigitos,"0")
            SCAN WHILE CLFAUX = XsCLFAUX FOR CODAUX <> "99"
               LiCodAux = VAL(CodAux)+1
               XsCodAux = PADL(ALLTRIM(STR(LiCodAux)),iDigitos,'0')
            ENDSCAN
         ENDIF
         SELECT AUXI
         @ 12,24 GET XsCODAux PICTURE REPLICATE("9",iDigitos)
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8 &&.OR. EMPTY(XsCODAUX)
            IF ! CBDBUSCA("AUXI")
               LOOP
            ENDIF
            XsCodAux = CodAux
            UltTecla = Enter
         ELSE
            **XsCodAux = RIGHT("0000000"+ALLTRIM(XsCodAux),iDigitos)
         ENDIF
         XsCodAux = PADR(XsCodAux,LEN(AUXI->CodAux))
         @ 12,24 SAY XsCODAux
      CASE i = 2
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
         i = 0
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>2,2, i)
   i = IIF(i<1 , 1, i)
ENDDO
SELECT AUXI
SEEK XsClfAux+XsCodAux
IF UltTecla = Escape
   GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] C¢digo [PgUp] [PgDn] [^PgUp] [^PgDn] Otro Registro"
   DO LIB_MTEC WITH 99
ENDIF
RETURN
**********************************************************************
* Muestra datos en la pantalla ( Modificar , Anular ,Localizar )     *
**********************************************************************
PROCEDURE Muestra
*****************
@ 12,24  SAY  CodAux
@ 14,24  SAY  NomAux PICT "@S40"
IF CLFAUX = "01 "
   @ 15,24  SAY  DirAux PICT "@S40"
ENDIF
IF CLFAUX = "99 "
   IF FLGING = "I"
      @ 15,24  SAY  "INGRESO"
   ELSE
      @ 15,24  SAY  "EGRESOS"
   ENDIF
ENDIF
IF CLFAUX = [60 ]
   @ 15,24  SAY  codfam
   @ 15,31 say iif(seek([02]+codfam,[divf]),divf.desfam,space(30))
ENDIF
@ 16,24  say  disaux
@ 17,24  SAY  RucAux
@ 18,24  SAY  TlfAux
@ 19,24  SAY  NomC_V
@ 20,24  SAY  CALAUX
RETURN
**********************************************************************
* Edita registro seleccionado (Crear Modificar , Anular )            *
**********************************************************************
PROCEDURE EDITAR
****************
GsMsgKey = "[] [] [Enter] Registra [F10] Graba [Esc] Cancela"
DO LIB_MTEC WITH 99
DO TOMA
i = 1
UltTecla = 0
DO WHILE ! INLIST(UltTecla,CTRLW,ESCAPE,F10,PgUp,PgDn)
   DO CASE
      CASE i = 1
          @ 14,24  GET XsNomAux PICT "@!S40"
          READ
          UltTecla = LASTKEY()
      CASE i = 2 .AND. XsClfAux = "99 "
          @ 15,24  GET XSINGEGR FUNCT "M INGRESO,EGRESOS"
          READ
          UltTecla = LASTKEY()
          IF XSINGEGR = "INGRESO"
             XSFLGING = "I"
          ELSE
             XSFLGING = "S"
          ENDIF
      CASE i = 2 .AND. XsClfAux = "01 "
          @ 15,24 GET XsDirAux PICT "@!S40"
          @ 16,24 GET XsDisAux PICT "@!"          
          @ 17,24 GET XsRucAux PICT "@!"
          @ 18,24 GET XsTLFAux PICT "@!"
          @ 19,24 GET XsNomC_V PICT "@!"
          @ 20,24 GET XsCALAUX FUNC "M 1,2,3"
          READ
          UltTecla = LASTKEY()
      *
      case i = 2 .and. xsclfaux = [60 ]
          sele divf
          @ 15,24  get xscodfam pict [@!] valid vCodFam()
          read
          sele auxi
          ulttecla = lastkey()
      *
      CASE i = 5
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
         i = 0
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>5,5, i)
   i = IIF(i<1 , 1, i)
ENDDO
IF UltTecla <> Escape
   DO GRABA
ENDIF
GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] C¢digo [PgUp] [PgDn] [^PgUp] [^PgDn] Otro Registro"
DO LIB_MTEC WITH 99
RETURN
**********************************************************************
* ELIMINA REGISTRO                                                   *
**********************************************************************
PROCEDURE ELIMINA
*****************
IF RLock()
   DELETE
   SKIP
   UNLOCK
ENDIF
RETURN

*************************************************************************** FIN
* Procedimiento de CARGA A VARIABLES
******************************************************************************
PROCEDURE TOMA
**************
IF ! Crear
   XsCodAux = CodAux
ENDIF
XsNOMAUX=NOMAUX
XsDIRAUX=DIRAUX
XsDisAux=DisAux
XsRUCAUX=RUCAUX
XsTlfAUX=TlfAUX
XsLOCAUX=LOCAUX
XsNomC_V=NomC_V
XSCALAUX=CALAUX
xscodfam=codfam
IF XSCLFAUX = "99 "
   IF FLGING = "I"
      XSINGEGR="INGRESO"
      XSFLGING="I"
   ELSE
      XSINGEGR="EGRESOS"
      XSFLGING="S"
   ENDIF
ENDIF
RETURN
*************************************************************************** FIN
* Procedimiento Para Grabaci¢n
******************************************************************************
PROCEDURE GRABA
***************
IF Crear
   APPEND BLANK
ENDIF
IF ! RLOCK()
   RETURN
ENDIF
IF Crear
   REPLACE CLFAUX WITH XSCLFAUX
   REPLACE CODAUX WITH XSCODAUX
ENDIF
REPLACE NOMAUX    WITH XsNOMAUX
REPLACE DIRAUX    WITH XsDIRAUX
REPLACE DisAUX    WITH XsDIsAUX
REPLACE RUCAUX    WITH XsRUCAUX
REPLACE TlfAUX    WITH XsTlfAUX
REPLACE LOCAUX    WITH XsLOCAUX
REPLACE NomC_V    WITH XsNomC_V
REPLACE CALAUX    WITH XSCALAUX
REPLACE FLGING    WITH XSFLGING
replace codfam    with xscodfam
UNLOCK ALL
RETURN

****************
FUNCTION vCodFam
****************
ulttecla = lastkey()
if ulttecla = f8
   if ! cbdbusca("DIVF")
      return .f.
   endif
   xscodfam = codfam
   ulttecla = enter
endif
seek [02] + xscodfam
if !found()
   gsmsgerr = "**Familia No Registrada **"
   do lib_merr with 99
   ulttecla = 0
   return .f.
endif
return .t.
