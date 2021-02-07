SELE 4
USE CBDMAUXI order AUXI01 ALIAS AUXI
IF ! USED(4)
   CLOSE DATA
   RETURN
ENDIF
SELE 3
USE CBDACMCT order ACCT01 ALIAS ACCT
IF ! USED(3)
   CLOSE DATA
   RETURN
ENDIF
SELE 2
USE CBDMTABL order TABL01 ALIAS TABL
IF ! USED(2)
   CLOSE DATA
   RETURN
ENDIF
SELE 1
USE CBDMCTAS order CTAS01 ALIAS CTAS
IF ! USED(1)
   CLOSE DATA
   RETURN
ENDIF
**** Variables *****
STORE "" TO ;
  XsCodCta,XsNOMCTA,XiNIVCTA,XcTPOMOV,XcAFTMOV,XcAFTDCB,XiCODMON,XiTPOCMB,;
  XcPIDAUX,XsCLFAUX,XcPIDDOC,XcCIERES,XsAN1CTA,XsCC1CTA,XsAN2CTA,XsCC2CTA,;
  XcGenAut,XiTpoCta,XsCodDoc,XsTpoGto,XcPidGlo,XcMayAux
*** Pintamos pantalla *************
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "PLAN DE CUENTAS"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4

@ 8,4 FILL  TO 22,74      COLOR W/N
@  7,5 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" COLOR SCHEME 11
@  8,5 SAY "³  C¢digo :                                                           ³" COLOR SCHEME 11
@  9,5 SAY "³  Nombre :                                                           ³" COLOR SCHEME 11
@ 10,5 SAY "³  Nivel  :                  Tipo de Movimiento :                     ³" COLOR SCHEME 11
@ 11,5 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" COLOR SCHEME 11
@ 12,5 SAY "³  Afecta el Resultado .........................:                     ³" COLOR SCHEME 11
@ 13,5 SAY "³  Afecto a Movimientos ........................:                     ³" COLOR SCHEME 11
@ 14,5 SAY "³  Genera Ajuste por diferencia de Cambio ......:                     ³" COLOR SCHEME 11
@ 15,5 SAY "³  Requiere Cuentas Auxiliares .................:                     ³" COLOR SCHEME 11
@ 16,5 SAY "³  Registra al Mayor la Cuenta Auxiliar.........:                     ³" COLOR SCHEME 11
@ 17,5 SAY "³  Requiere registro de Documentos .............:                     ³" COLOR SCHEME 11
@ 18,5 SAY "³  Requiere registro de Documento Referencia....:                     ³" COLOR SCHEME 11
@ 19,5 SAY "³  Genera Cuentas Autom ticas ..................:                     ³" COLOR SCHEME 11
@ 20,5 SAY "³  Tipo de Gastos...............................:                     ³" COLOR SCHEME 11
@ 21,5 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" COLOR SCHEME 11
**********************************************************************
** Rutina principal *****
**********************************************************************
GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] C¢digo [PgUp] [PgDn] [^PgUp] [^PgDn] Otro Registro"
DO LIB_MTEC WITH 99
DO EDITA WITH 'Llave','Muestra','Editar','Elimina','Reporte','','','CMAR'
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
XsCodCta = CodCta
UltTecla = 0
i        = 1
DO WHILE ! INLIST(UltTecla,Enter,Escape,F10,CtrlW)
   @ 08,17 GET XsCodCta PICTURE REPLICATE("9",LEN(XsCodCta))
   READ
   UltTecla = LASTKEY()
   IF UltTecla = Escape
      EXIT
   ENDIF
   IF UltTecla = F8 .OR. EMPTY(XsCodCta)
   		SEEK TRIM(XsCodCta)	
      IF ! CBDBUSCA("MCTA")
         LOOP
      ENDIF
      XsCodCta = CodCta
      UltTecla = Enter
   ENDIF
   @ 08,17 SAY XsCodCta
ENDDO
SEEK XsCodCta
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

@  8,17  SAY  CodCta
@  9,17  SAY  NomCta  PICT "@S55"
@ 10,17  SAY  NivCta  PICT "#"
@ 10,55 SAY IIF(TpoMov="D","Debe      ",IIF(TpoMov="H","Haber     ","Cualquiera"))
IF CodCta >= '60'
   DO CASE
      CASE TpoCta = 1
         @ 12,55 SAY "Naturaleza          "
      CASE TpoCta = 2
         @ 12,55 SAY "Funcion             "
      CASE TpoCta = 3
         @ 12,55 SAY "Naturaleza y Funcion"
      OTHER
         @ 12,55 SAY "Ninguna             "
   ENDCASE
ELSE
   DO CASE
      CASE TpoCta = 1
         @ 12,55 SAY "Activo Corriente    "
      CASE TpoCta = 2
         @ 12,55 SAY "Activo no Corriente "
      CASE TpoCta = 3
         @ 12,55 SAY "Pasivo Corriente    "
      CASE TpoCta = 4
         @ 12,55 SAY "Pasivo no Corriente "
      CASE TpoCta = 5
         @ 12,55 SAY "Patrimonio          "
      OTHER
         @ 12,55 SAY "Seg£n Saldo         "
   ENDCASE
ENDIF
@ 13,55 SAY IIF(AftMov="S","Si","No")
@ 14,55 SAY IIF(AftDcb="S","Si","No")
@ 15,55 SAY IIF(PidAux="S","Si","No")
IF PidAux="S" .and. ! EMPTY(ClfAux)
   @ 15,60 SAY 'Auxiliar : '+ClfAux
ELSE
   @ 15,60 SAY '           '+SPACE(LEN(ClfAux))
ENDIF
@ 16,55 SAY IIF(MayAux="S","Si","No")
@ 17,55 SAY IIF(PidDoc="S","Si","No")
IF PidDoc="S" .and. ! EMPTY(CodDoc)
   @ 17,60 SAY 'Documento: '+CodDoc
ELSE
   @ 17,60 SAY '           '+SPACE(LEN(CodDoc))
ENDIF
@ 18,55 SAY IIF(PidGlo="S","Si","No")
@ 19,55 SAY IIF(GenAut="S","Si","No")
@ 20,55 SAY TpoGto

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
          @ 09,17  GET XsNomCta PICT "@S55"
          READ
          UltTecla = LASTKEY()
          @ 09,17  SAY XsNomCta
      CASE i = 2
          @ 10,17  GET XiNivCta PICT "#"
          READ
          UltTecla = LASTKEY()
          @ 10,17  SAY XiNivCta  PICT "#"
      CASE i = 3
         VecOpc(1) = "Debe"
         VecOpc(2) = "Heber"
         VecOpc(3) = "Cualquiera"
         XcTpoMov=Elige(XcTpoMov,10,55,3)
      CASE i = 4
         IF XsCodCta >= "60"
            VecOpc(1) = "Naturaleza"
            VecOpc(2) = "Funci¢n"
            VecOpc(3) = "Naturaleza y Funci¢n"
            VecOpc(4) = "Ninguna"
            XiTpoCta=Elige(XiTpoCta,12,55,4)
         ELSE
            VecOpc(1) = "Activo Corriente"
            VecOpc(2) = "Activo no Corriente"
            VecOpc(3) = "Pasivo Corriente"
            VecOpc(4) = "Pasivo no Corriente"
            VecOpc(5) = "Patrimonio"
            VecOpc(6) = "Seg£n Saldo"
            XiTpoCta=Elige(XiTpoCta,12,55,6)
         ENDIF
      CASE i = 5
         VecOpc(1) = "S¡"
         VecOpc(2) = "No"
         XcAftMov=Elige(XcAftMov,13,55,2)
      CASE i = 6  .AND. XcAftMov = "S"
         VecOpc(1) = "S¡"
         VecOpc(2) = "No"
         XcAftDcb=Elige(XcAftDcb,14,55,2)
         IF ! INLIST(UltTecla,Arriba,Escape) .AND. XcAftDcb = "S"
            DO V1DFCMB
         ENDIF
      CASE i = 7  .AND. XcAftMov = "S"
         VecOpc(1) = "S¡"
         VecOpc(2) = "No"
         XcPidAux=Elige(XcPidAux,15,55,2)
         IF ! INLIST(UltTecla,Arriba,Escape) .AND. XcPidAux = "S"
            XsTabla = "01"
            @ 15,60 SAY 'Auxiliar :'GET  XsClfAux     PICTURE "@!"
            READ
            DO CASE
               CASE LastKey() = Escape
                  LOOP
               CASE LastKey() = F8
                  SELECT TABL
                  IF ! CBDBUSCA("TABL")
                     LOOP
                  ENDIF
                  SELECT CTAS
                  XsClfAux = LEFT(TABL->CODIGO,LEN(XsClfAux))
               OTHER
                  IF ! EMPTY(XsClfAux)
                     IF ! SEEK(XsTabla+XsClfAux,"TABL")
                        GsMsgErr = "Clasificaci¢n de Auxiliar no registrado"
                        DO LIB_MERR WITH 99
                        LOOP
                     ENDIF
                  ENDIF
            ENDCASE
            @ 15,60 SAY 'Auxiliar : '+XsClfAux
         ENDIF
      CASE i = 8  .AND. XcAftMov = "S"
         VecOpc(1) = "No"
         VecOpc(2) = "S¡"
         IF XcPidAux = "S"
            XcMayAux=Elige(XcMayAux,16,55,2)
         ELSE
            XcMayAux="N"
         ENDIF
      CASE i = 9  .AND. XcAftMov = "S"
         VecOpc(1) = "S¡"
         VecOpc(2) = "No"
         XcPidDoc=Elige(XcPidDoc,17,55,2)
         IF ! INLIST(UltTecla,Arriba,Escape) .AND. XcPidDoc = "S"
            XsTabla = "02"
            @ 17,60 SAY 'Documento:'GET  XsCodDoc     PICTURE "@!"
            READ
            DO CASE
               CASE LastKey() = Escape
                  LOOP
               CASE LastKey() = F8
                  SELECT TABL
                  IF ! CBDBUSCA("TABL")
                     LOOP
                  ENDIF
                  SELECT CTAS
                  XsCodDoc = LEFT(TABL->CODIGO,LEN(XsCodDoc))
               OTHER
                  IF ! EMPTY(XsCodDoc)
                     IF ! SEEK(XsTabla+XsCodDoc,"TABL")
                        GsMsgErr = "C¢digo de Documento no registrado"
                        DO LIB_MERR WITH 99
                        LOOP
                     ENDIF
                  ENDIF
            ENDCASE
            @ 17,60 SAY 'Documento: '+XsCodDoc
         ENDIF
      CASE i = 10 .AND. XcAftMov = "S"
         VecOpc(1) = "S¡"
         VecOpc(2) = "No"
         XcPidGlo=Elige(XcPidGlo,18,55,2)
      CASE i = 11 .AND. XcAftMov = "S"
         VecOpc(1) = "S¡"
         VecOpc(2) = "No"
         XcGenAut=Elige(XcGenAut,19,55,2)
         IF ! INLIST(UltTecla,Arriba,Escape) .AND. XcGenAut = "S"
            DO V2CTAUT
         ENDIF
      CASE i = 12  .AND. XcAftMov = "S"
         SELECT AUXI
         LsClfAux = XsClfAux
         XsClfAux = "04 "
         @ 20,55 GET XsTpoGto     PICTURE "@!"
         READ
         DO CASE
            CASE LastKey() = Escape
            CASE LastKey() = F8
               IF ! CBDBUSCA("AUXI")
                  XsClfAux = LsClfAux
                  LOOP
               ENDIF
               XsTpoGto = LEFT(AUXI->CODAUX,LEN(XsTpoGto))
               UltTecla = Enter
            OTHER
               IF ! EMPTY(XsTpoGto)
                  IF ! SEEK(XsCLFAux+XsTpoGto,"AUXI")
                     GsMsgErr = "Dato no registrado"
                     DO LIB_MERR WITH 99
                     XsClfAux = LsClfAux
                     LOOP
                  ENDIF
               ENDIF
               XsClfAux = LsClfAux
         ENDCASE
         @ 20,55 SAY XsTpoGto
      CASE i = 13
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
         i = 0
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>13,13, i)
   i = IIF(i<1 , 1, i)
ENDDO
SELECT CTAS
IF UltTecla <> Escape
   DO GRABA
ENDIF
GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] C¢digo [PgUp] [PgDn] [^PgUp] [^PgDn] Otro Registro"
DO LIB_MTEC WITH 99
RETURN
**********************************************************************
* VENTANA DE CONFIGURACION POR AJUSTE EN DIFERENCIA DE CAMBIO        *
**********************************************************************
PROCEDURE V1DFCMB
*****************
SAVE SCREEN
@ 16,43 FILL  TO 19,77 COLOR W+/N
@ 15,44 CLEAR TO 18,78
@ 15,44 TO       18,78
@ 16,46 SAY "Moneda Cuenta   : "
@ 17,46 SAY "T/Cambio a Usar : "
@ 15,44 FILL TO  18,78  COLOR SCHEME 7

DO WHILE .T.
   VecOpc(1) = "S¢lo Soles   "
   VecOpc(2) = "S¢lo Dolares "
   VecOpc(3) = "Ambas Monedas"
   XiCodMon=Elige(XiCodMon,16,64,3)
   IF UltTecla = Escape
      EXIT
   ENDIF
   VecOpc(1) = "Compra     "
   VecOpc(2) = "Venta      "
   VecOpc(3) = "Seg£n Saldo"
   XiTpoCmb=Elige(XiTpoCmb,17,64,3)
   IF UltTecla = Arriba
      LOOP
   ENDIF
   EXIT
ENDDO
IF UltTecla = Escape
   UltTecla = Arriba
ELSE
   UltTecla = 0
ENDIF
RESTORE SCREEN
RETURN
**********************************************************************
* VENTANA DE CONFIGURACION DE GENERACION DE CUENTAS AUTOMATICAS      *
**********************************************************************
PROCEDURE V2CTAUT
*****************
lEof = EOF()
nReg = RECNO()
SAVE SCREEN
@ 16,43 FILL  TO 21,77 COLOR W+/N
@ 15,44 CLEAR TO 20,78
@ 15,44 TO       20,78
@ 16,46 SAY "Cuenta Autom tica 1: "
@ 17,46 SAY "Contra Cuenta     1: "
*@ 18,46 SAY "Cuenta Autom tica 2: "
*@ 19,46 SAY "Contra Cuenta     2: "
@ 15,44 FILL TO  21,78  COLOR SCHEME 10
@ 16,67 GET XsAn1Cta    COLOR SCHEME 10
@ 17,67 GET XsCC1Cta    COLOR SCHEME 10
*@ 18,67 GET XsAn2Cta    COLOR SCHEME 10
*@ 19,67 GET XsCC2Cta    COLOR SCHEME 10
READ
IF LASTKEY() = Escape
   UltTecla = Arriba
ELSE
   UltTecla = Enter
ENDIF
IF ! lEof
   GOTO nREg
ELSE
   GOTO BOTTOM
   IF ! EOF()
      SKIP
   ENDIF
ENDIF
RESTORE SCREEN
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
   XsCodCta = CodCta
ENDIF
XsNOMCTA=NOMCTA
XiNIVCTA=NIVCTA
XcTPOMOV=TPOMOV
XiTPOCta=TPOCta
XcAFTMOV=AFTMOV
XcAFTDCB=AFTDCB
XiCODMON=CODMON
XiTPOCMB=TPOCMB
XcPIDAUX=PIDAUX
XsCLFAUX=CLFAUX
XcPIDDOC=PIDDOC
XcPIDGLO=PIDGLO
XsCodDOC=CodDOC
XcCIERES=CIERES
XcMAYAUX=MAYAUX
XcGenAut=IIF(EMPTY(GenAut),"N",GENAUT)
XsAN1CTA=AN1CTA
XsCC1CTA=CC1CTA
XsAN2CTA=AN2CTA
XsCC2CTA=CC2CTA
XsTpoGto=TpoGto
IF Crear
   XiNivCta = IIF(LEN(ALLTRIM(XsCODCTA))=4,3,LEN(ALLTRIM(XsCodCta))-1)
   XcAftMov = "N"
   XcAftDcb = "N"
   XcPidAux = "N"
   XcMayAux = "N"
   XcPidDoc = "N"
   XcPidGlo = "N"
   XcCieRes = "N"
   XcGenAut = "N"
   XiCodMon = 1
   XiTpoCmb = 1
ENDIF
RETURN
*************************************************************************** FIN
* Procedimiento Para Grabacion
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
   REPLACE CODCTA WITH XSCODCTA
ENDIF
REPLACE NOMCTA    WITH XsNOMCTA
REPLACE NIVCTA    WITH XiNIVCTA
REPLACE TPOMOV    WITH XcTPOMOV
REPLACE AFTMOV    WITH XcAFTMOV
REPLACE AFTDCB    WITH XcAFTDCB
REPLACE CODMON    WITH XiCODMON
REPLACE TPOCMB    WITH XiTPOCMB
REPLACE PIDAUX    WITH XcPIDAUX
REPLACE MAYAUX    WITH XcMAYAUX
REPLACE CLFAUX    WITH XsCLFAUX
REPLACE PIDGLO    WITH XcPIDGLO
REPLACE PIDDOC    WITH XcPIDDOC
REPLACE CODDOC    WITH XsCODDOC
REPLACE CIERES    WITH XcCIERES
REPLACE GenAut    WITH XcGenAut
REPLACE AN1CTA    WITH XsAN1CTA
REPLACE CC1CTA    WITH XsCC1CTA
REPLACE AN2CTA    WITH XsAN2CTA
REPLACE CC2CTA    WITH XsCC2CTA
REPLACE TpoGto    WITH XsTpoGto
REPLACE TPOCta    WITH XiTPOCta
UNLOCK ALL
RETURN

*************************************************************************** FIN
* Procedimiento de Reporte
******************************************************************************
PROCEDURE REPORTE
*****************
SAVE SCREEN TO TMP
GOTO TOP
Largo = 66
IniPrn=[_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn1]
xWhile = []
xFor   = []
sNomREP = "cbdmctas"
DO ADMPRINT WITH "REPORTS"
RESTORE SCREEN FROM TMP
RETURN
