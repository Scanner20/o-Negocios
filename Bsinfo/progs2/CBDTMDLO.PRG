**********************************************************************
*  Nombre        : CBDTMDLO.prg
*  Sistema       : Contabilidad
*  Autor         : VETT
*  Proposito     : VOUCHER TIPOS
*  Creacion      : 17/06/93
*  Actualizacion :
***************************************************************************
IF ! Master
   GsMsgErr = "ACCESO DENEGADO"
   DO LIB_MERR WITH 99
   RETURN
ENDIF
XsNroMes = TRANSF(_MES,"@L ##")
PANT1 = 1
XsGimpo1 = space(20)
XsGimpo2 = space(20)
XsGimpo3 = space(20)
XsGimpo4 = space(20)
DO MOVgPant
DO MOVApert
IF ! USED(1)
   CLOSE DATA
   RETURN
ENDIF
UltTecla = 0
**********************
** Rutina Principal **
**********************
SELECT VMOV
GOTO BOTTOM
XsCodMod = CODMOD
XiCodMon = CodMon
XsCodOpe = Codope
XsNotAst = NotAst
Crear    = .t.
IF ! EOF()
   DO MOVPinta
ENDIF
DO WHILE (.t.)
   SELECT VMOV
   @ 1,68 GET XsCodMod PICT "@!"
   READ
   UltTecla = LASTKEY()
   Edita    = .F.
   DO CASE
      CASE UltTecla = F9
         DO MOVBOrra
      CASE UltTecla = F8
         IF CBDBUSCA("MDLO")
            XsCodMod = CodMod
            UltTecla = Enter
         ENDIF

      CASE UltTecla = Escape
         EXIT
      CASE UltTecla = Home
         GOTO TOP
         XsCodMod = CodMod
      CASE UltTecla = End
         GOTO BOTTOM
         XsCodMod = CodMod
      CASE UltTecla = PgUp
         IF ! BOF()
            SKIP -1
         ENDIF
         XsCodMod = CodMod
      CASE UltTecla = PgDn
         IF ! EOF()
            SKIP
         ENDIF
         XsCodMod = CodMod
      OTHER
         EDITA = .T.
   ENDCASE
   IF CodMod <> XsCodMod
      SEEK XsCodMod
   ENDIF
   DO MOVPINTA
   IF EDITA
      DO MOVEdita
      DO MOVGraba
      DO MOVBrows
      UNLOCK ALL
   ENDIF
   SELECT VMOV
ENDDO
CLOSE DATA
CLOSE PROCEDURE
RETURN
************************************************************************* FIN
* Procedimiento de Apertura de archivos a usar
******************************************************************************
PROCEDURE MOVAPERT
******************
** Abrimos areas a usar **
SELE 1
USE cbdmctas ORDER ctas01   ALIAS CTAS
IF !used(1)
    close data
    return
ENDIF
SELE 2
USE cbdmauxi ORDER auxi01   ALIAS AUXI
IF ! used(2)
    close data
    return
ENDIF
SELE 3
USE cbdVMDLO ORDER VMDL01   ALIAS VMOV
IF !used(3)
    close data
    return
ENDIF
SELE 4
USE cbdRMDLO ORDER RMDL01   ALIAS RMOV
IF !used(4)
    close data
    return
ENDIF
SELE 5
USE cbdTOPER ORDER OPER01   ALIAS OPER
IF !used(5)
    close data
    return
ENDIF
SELE 6
USE cbdmtabl ORDER tabl01   ALIAS TABL
IF !used(6)
    close data
    return
ENDIF
RETURN
************************************************************************* FIN
* Procedimiento de Pintado de pantalla
******************************************************************************
PROCEDURE MOVgPant
CLEAR
@ 0,0 TO 23,79
@ 0,11 SAY " A S I E N T O S    M O D E L O S"

@ 5,0  SAY "ร"
@ 5,1  TO  5,49
@ 5,79 SAY "ณ"

@ 0,50 SAY "ย"
@ 1,50 TO 5,50
@ 5,50 SAY "ู"

@ 3,0 SAY "ร"
@ 3,1 TO  3,49 COLOR SCHEME 7
@ 3,50 SAY "ด"


@ 20,0  SAY "ร"
@ 20,1 TO 20,78
@ 20,79 SAY "ด"

@ 1,1 SAY PADR(" COMPAฅIA  : "+GsCodCia+" "+GsNomCia,49) COLOR SCHEME 7
@ 2,1 SAY PADR(" Usuario   : "+GsUsuario,49)             COLOR SCHEME 7

cTitulo =" "+Mes(VAL(XsNroMes),1)+" "+TRANS(_ANO,"9999 ")
nCol    = (49-LEN(cTitulo))/2
@ 3,1+nCol SAY cTitulo
@ 4,1 SAY PADR(" OPERACION : ",49) COLOR SCHEME 7

@ 1,52 SAY "MODELO        :"
@ 2,52 SAY "---------------"
@ 3,52 SAY "MONEDA        :"
@ 4,52 SAY "               "
@ 5,52 SAY "               "
@ 6,2  SAY "OBSERVACIONES : "

@ 7,0  SAY "ร"
@ 7,1  TO  7,78
@ 7,79 SAY "ด"
@ 8,1  SAY "  CTRO.  COD.   COD. Nง                             T                         " COLOR SCHEME 7
@ 9,1  SAY "  REFE.  CTA.  AUXI. DOCUMENTO  DESCRIPCION         M                 IMPORTE " COLOR SCHEME 7
*             XXXXX XXXXX  XXXXX XXXXXXXXXX XXXXXXXXXXXXXXXXXXX X {1}%20+{2}%30
@ 10,0  SAY "ร"
@ 10,1  TO  10,78
@ 10,79 SAY "ด"

RETURN
************************************************************************** FIN
* Procedimiento inicializa variables
******************************************************************************
PROCEDURE MOVInVar
XiCodMon = 1
XsNotAst = SPACE(LEN(VMOV->NOTAST))
XsGimpo1 = SPACE(LEN(VMOV->Gimpo1))
XsGimpo2 = SPACE(LEN(VMOV->Gimpo2))
XsGimpo3 = SPACE(LEN(VMOV->Gimpo3))
XsGimpo4 = SPACE(LEN(VMOV->Gimpo4))
XsCodope = VMOV->CodOpe
RETURN
************************************************************************** FIN
* Procedimiento pinta datos en pantalla
******************************************************************************
PROCEDURE MOVPinta
=SEEK(VMOV->CODOPE,"OPER")
@ 4,1  SAY " OPERACION : "+CodOpe+"  "+OPER->NomOpe COLOR SCHEME 7
@ 2,1  SAY PADR(" Usuario   : "+GsUsuario,49)             COLOR SCHEME 7
@ 3,68 SAY IIF(VMOV->CODMON=1,"S/.","US$")
@ 6,18 SAY VMOV->NOTAST
LinAct = 11
@ LinAct,1 CLEAR TO 22,78
SELECT RMOV
SEEK XsCodMod
DO WHILE XsCodMod = (CodMod) .AND. ! EOF() .AND. LinAct < 20
   Contenido = ""
   DO MOVBLine WITH Contenido
   @ LinAct,2 SAY Contenido
   LinAct = LinAct + 1
   SKIP
ENDDO
@ 20,1 TO 20,78
RETURN
************************************************************************** FIN
* Procedimiento de edita las variables de cabecera
******************************************************************************
PROCEDURE MOVEdita
SELECT VMOV
UltTecla = 0
Crear = EOF()
IF ! Crear
   IF .NOT. RLock()
      GsMsgErr = "Asiento usado por otro usuario"
      DO LIB_MERR WITH 99
      UltTecla = Escape
      RETURN              && No pudo bloquear registro
   ENDIF
ENDIF
I        = 1
DO LIB_MTEC WITH 7
DO WHILE .NOT. INLIST(UltTecla,F10,CtrlW,Escape)
   DO CASE
      CASE I = 1
         SELECT OPER
         @ 4,14 GET XsCodOpe PICT REPLICATE("9", LEN(OPER->CodOpe))
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape
            LOOP
         ENDIF
         IF UltTecla = F8
            IF ! CBDBUSCA("OPER")
               LOOP
            ENDIF
            XsCodOpe = CodOpe
         ENDIF
         SEEK XsCodOpe
         @ 4,1  SAY " OPERACION : "+XsCodOpe+"  "+OPER->NomOpe COLOR SCHEME 7
         IF ! FOUND()
            DO LIB_MERR WITH 9
            UltTecla = 0
            LOOP
         ENDIF

      CASE I = 2
         VecOpc(1)="S/."
         VecOpc(2)="US$"
         DO CASE
            CASE OPER->CODMON = 1
              XiCodMon= 1
            CASE OPER->CODMON = 2
              XiCodMon= 2
            OTHER
              XiCodMon= Elige(XiCodMon,3,68,2)
         ENDCASE
         @ 3,68 SAY IIF(XiCODMON=1,"S/.","US$")
      SAVE SCREEN TO PANT1
      @ 5,55 CLEAR TO 10,76
      @ 5,55 FILL TO 10,76 COLOR SCHEME 7
      @ 5,55 TO 10,76 DOUBLE
      @ 5,57 SAY "GLOSA DE IMPORTES" COLOR SCHEME 7
      @ 6,56 GET XsGimpo1 PICT "@!"
      @ 7,56 GET XsGimpo2 PICT "@!"
      @ 8,56 GET XsGimpo3 PICT "@!"
      @ 9,56 GET XsGimpo4 PICT "@!"
      READ
      RESTORE SCREEN FROM PANT1
      CASE I = 3
         @ 6, 18 GET XsNotAst
         READ
         UltTecla = LastKey()
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>3,3, i)
   i = IIF(i<1, 1, i)
ENDDO
SELECT VMOV
RETURN
************************************************************************** FIN
* Procedimiento de Borrado ( Auditado ) de un documento
******************************************************************************
PROCEDURE MOVBorra
IF .NOT. RLock()
   GsMsgErr = "Asiento usado por otro usuario"
   DO LIB_MERR WITH 99
   UltTecla = Escape
   RETURN              && No pudo bloquear registro
ENDIF
DO LIB_MSGS WITH 10
SELECT RMOV
SEEK XsCodMod
ok     = .t.
DO WHILE ! EOF() .AND.  ok .AND. CodMod = XsCodMod
   IF Rlock()
      SELECT RMOV
      DELETE
      UNLOCK
   ELSE
      ok = .f.
   ENDIF
   SKIP
ENDDO
SELECT VMOV
IF Ok
   DELETE
ENDIF
UNLOCK ALL
RETURN
************************************************************************** FIN
* Procedimiento de Grabar las variables de cabecera
******************************************************************************
PROCEDURE MOVGraba
IF UltTecla = Escape
   RETURN
ENDIF
UltTecla = 0
IF Crear                  && Creando
   SELECT VMOV
   SEEK (XsCodMod)
   IF FOUND()
      DO LIB_MERR WITH 11
      UltTecla = Escape
      RETURN
   ENDIF
   APPEND BLANK
   IF ! Rec_Lock(5)
      UltTecla = Escape
      RETURN              && No pudo bloquear registro
   ENDIF
ENDIF
REPLACE VMOV->CodMod WITH XsCodMod
REPLACE VMOV->CodOpe WITH XsCodOpe
REPLACE VMOV->CodMon WITH XiCodMon
REPLACE VMOV->NotAst WITH XsNotAst
REPLACE VMOV->Gimpo1 WITH XsGimpo1
REPLACE VMOV->Gimpo2 WITH XsGimpo2
REPLACE VMOV->Gimpo3 WITH XsGimpo3
REPLACE VMOV->Gimpo4 WITH XsGimpo4
RETURN
******************************************************************************
*  Proposito     : Procedimientos de browse (Ingresos de almacen)
******************************************************************************
PROCEDURE MOVBrows
IF UltTecla = Escape
   RETURN
ENDIF
UltTecla = 0
SelLin   = "MOVbcomp"
InsLin   = "MOVInser"
EscLin   = "MOVbline"
EdiLin   = "MOVbedit"
BrrLin   = "MOVbborr"
GrbLin   = "MOVbGRAB"
MVprgF1  = [MOVF1]
MVprgF2  = []
MVprgF3  = [MOVF3]
MVprgF4  = []
MVprgF5  = []
MVprgF6  = []
MVprgF7  = []
MVprgF8  = []
MVprgF9  = []
PrgFin   = []
Titulo   = []
NClave   = [CodMod]
VClave   = XsCodMod
HTitle   = 1
Yo       = 10
Xo       = 0
Largo    = 21 - Yo
Ancho    = 80
TBorde   = Nulo
Titulo   = []
E1       = []
E2       = []
E3       = []
LinReg   = []
Consulta = .F.
Modifica = .T.
Adiciona = .T.
Static   = .F.
VSombra  = .F.
DB_Pinta = .F.
SELECT RMOV
*** Variable a Conocer ****
XsCodCta = SPACE(LEN(RMOV->CodCta))
XsClfAux = SPACE(LEN(RMOV->ClfAux))
XsCodAux = SPACE(LEN(RMOV->CodAux))
XsCodRef = SPACE(LEN(RMOV->CodRef))
XsGloDoc = SPACE(LEN(RMOV->GloDoc))
*XdFchVto = {,,}
XdFchVto = {  ,  ,    }
XsCodDoc = SPACE(LEN(RMOV->CodDoc))
XsNroDoc = SPACE(LEN(RMOV->NroDoc))
XsNroRef = SPACE(LEN(RMOV->NroRef))
XiCodMon = VMOV->CodMon
XcTpoMov = "D"
XsImport = SPACE(40)
XiNroItm = VMOV->NroItm+1
GsMsgKey = " [Tecla de Cursor] Selecciona [Ins] Inserta [Del] Anula [F3] Recacula [F7] Distribuye"
DO LIB_MTEC WITH 14
DO DBrowse
SELECT VMOV
RETURN
************************************************************************ FIN *
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE MOVbline
PARAMETERS Contenido
Contenido = CodRef+" "+CodCta+" "+CodAux+" "+NroDoc+" "
Contenido = Contenido + LEFT(GloDoc,22)+" "+TpoMov+" "
Contenido = Contenido + PADR(IMPORT,22)
RETURN
************************************************************************ FIN *
* Objeto : Complementa una linea del browse
******************************************************************************
PROCEDURE MOVbcomp
@ 20,02 SAY PADC(ALLTRIM(STR(RMOV->NroItm,5))+"/"+ALLTRIM(STR(VMOV->NroItm,5)),11) COLOR SCHEME 7
@ 21,1 clear to 22,78
=SEEK(RMOV->CodCta,"CTAS")
IF ! EMPTY(CODAUX)
   =SEEK(CLFAUX+CODAUX,"AUXI")
   @ 22,1 SAY "AUXILIAR: "+AUXI->NomAux
ENDIF
RETURN
************************************************************************ FIN *
* Objeto : Edita una linea
******************************************************************************
PROCEDURE MOVbedit
IF ! Crear
   XsCodCta = RMOV->CodCta
   XsClfAux = RMOV->ClfAux
   XsCodAux = RMOV->CodAux
   XsCodRef = RMOV->CodRef
   XcTpoMov = RMOV->TpoMov
   XiNroItm = RMOV->NroItm
   XsGloDoc = RMOV->GloDoc
   XsNroDoc = RMOV->NroDoc
   XsNroRef = RMOV->NroRef
   XsImport = RMOV->Import
ELSE
   XsClfAux = SPACE(LEN(RMOV->ClfAux))
   XsCodAux = SPACE(LEN(RMOV->CodAux))
   XsCodRef = SPACE(LEN(RMOV->CodRef))
   XsCodDoc = SPACE(LEN(RMOV->CodDoc))
   XsNroDoc = SPACE(LEN(RMOV->NroDoc))
   XsImport = SPACE(LEN(RMOV->Import))
   XiNroItm = VMOV->NroItm+1
   @ 21,1 CLEAR TO 22,78
ENDIF
*
DO Lib_MTec WITH 7    && Teclas edicion linea
i = 1
LinRef = 2
LinCta = LinRef + 6
LinAux = LinCta + 6
LinDoc = LinAux + 6
LinGlo = LinDoc + 11
LinTpo = LinGlo + 23
LinImp = LinTpo + 2

UltTecla = 0
DO WHILE .NOT. INLIST(UltTecla,Escape,CtrlW,F10)
   DO CASE
      CASE i = 1        && Cขdigo de Cuenta
         SELECT CTAS
         @ LinAct,LinCta GET XsCodCta PICT REPLICATE("9",LEN(XsCodCta))
         READ
         UltTecla = LastKey()
         IF UltTecla = Escape
            LOOP
         ENDIF
         IF UltTecla = F8
            SEEK TRIM(XsCodCta)
            IF ! CBDBUSCA("CTAS")
               LOOP
            ENDIF
            XsCodCta = CTAS->CodCta
         ENDIF
         @ LinAct,LinCta SAY XsCodCta
         SEEK XsCodCta
         IF ! FOUND()
            GsMsgErr = "Cuenta no Registrada"
            DO Lib_MErr WITH 99
            UltTecla = 0
            LOOP
         ENDIF
         IF CTAS->AFTMOV#"S"
            GsMsgErr = "Cuenta no Afecta a movimiento"
            DO Lib_MErr WITH 99
            UltTecla = 0
            LOOP
         ENDIF
         @ 21,1 CLEAR TO 22,78
         @ 21,1 SAY "CUENTA CONTABLE  : "+CTAS->NomCta

      CASE i = 3
         IF CTAS->PIDAUX="S"
            SELECT TABL
            XsTabla = "01"
            IF EMPTY(CTAS->CLFAUX)
               GsMsgErr = " Invalida Configuraciขn de Cuenta. No registro la clasificaciขn del auxiliar"
               DO LIB_MERR WITH 99
               UltTecla = Escape
               EXIT
            ELSE
               XsClfAux = CTAS->ClfAux
            ENDIF
            SEEK XsTabla+XsClfAux
            IF ! FOUND()
               GsMsgErr = " Invalida Configuraciขn de Cuenta. No registro la clasificaciขn del auxiliar"
               DO LIB_MERR WITH 99
               UltTecla = Escape
               EXIT
            ENDIF
            @ 22,1 SAY "Tipo de Auxiliar : "+TABL->Nombre
            iDigitos = TABL->Digitos
            IF iDigitos < 0 .OR. iDigitos > LEN(XsCodAux)
               iDigitos = LEN(XsCodAux)
            ENDIF
            SELECT AUXI
            @ LinAct,LinAux GET XsCodAux PICT REPLICATE("9",iDigitos)
            READ
            UltTecla = LASTKEY()
            IF UltTecla = Escape
               LOOP
            ENDIF
            IF UltTecla = F8
               IF ! CBDBUSCA("AUXI")
                  LOOP
               ENDIF
               XsCodAux = AUXI->CodAux
            ELSE
               XsCodAux = RIGHT("00000000"+ALLTRIM(XsCodAux),iDigitos)
            ENDIF
            XsCodAux = PADR(XsCodAux,LEN(RMOV->CodAUX))
            @ LinAct,LinAux SAY XsCodAux
            SEEK XsClfAux+XsCodAux
            IF ! FOUND()
               DO Lib_MErr WITH 9 && no registrado
               UltTecla = 0
               LOOP
            ENDIF
            @ 22,1 SAY "AUXIL. : "+AUXI->NomAux
         ELSE
            XsClfAux = SPACE(LEN(RMOV->CLFAUX))
            XsCodAux = SPACE(LEN(RMOV->CODAUX))
         ENDIF
      CASE i = 4
         IF CTAS->PidDoc="S"
            IF CTAS->CODDOC="COM" .AND. OPER->ORIGEN
               XsNroDoc = XsNroDoc+RIGHT(XsNroAst,4)
            ELSE
               @ LinAct,LinDoc GET XsNroDoc PICT "@!" VALID ! EMPTY(XsNroDoc)
               READ
            ENDIF
            UltTecla = LastKey()
            @ LinAct,LinDoc SAY XsNroDoc
         ELSE
            XsNroDoc = SPACE(LEN(RMOV->NroDoc))
         ENDIF
      CASE i = 6
         @ LinAct,LinGlo GET XsGloDoc PICT "@!S22"
         READ
         UltTecla = LastKey()
         @ LinAct,LinGlo SAY XsGloDoc PICT "@S22"
      CASE i = 7
         VecOpc(1)="D"
         VecOpc(2)="H"
         XcTpoMov= Elige(XcTpoMov,LinAct,LinTpo,2)
      CASE i = 8 .AND. OPER->CodMon = 4
         VecOpc(1)="S/."
         VecOpc(2)="US$"
         XiCodMon= Elige(XiCodMon,LinAct,Linimp,2)
      CASE i = 9
         @ LinAct,LinImp GET XsImport PICT "@S22"
         READ
         UltTecla = LASTKEY()
         @ LinAct,LinImp SAY XsImport PICT "@S22"
      CASE i = 10 .AND. CTAS->PidGlo = "S"
         @ 21,1 CLEAR TO 22,78
         @ 21,01 SAY "Nง Doc.:"
         @ 21,14 GET XsNroRef PICT "@!"
         READ
         UltTecla = LASTKEY()
      CASE i = 11
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
         i = 1
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>11,11, i)
   i = IIF(i<1, 1, i)
ENDDO
SELECT RMOV
DO LIB_MTEC WITH 14
RETURN
************************************************************************ FIN *
* Objeto : Borra una linea
******************************************************************************
PROCEDURE MOVbborr
DO LIB_MSGS WITH 10
IF ! REC_LOCK(5)
   UltTecla = Escape
   RETURN
ENDIF
DELETE
UNLOCK
XiNroItm = NroItm
REPLACE VMOV->NroItm  WITH VMOV->NroItm-1
SKIP
DO RenumItms WITH XiNroItm
DO LIB_MTEC WITH 14
RETURN
************************************************************************ FIN *
* Renumerar los items
******************************************************************************
PROCEDURE RenumItms
PARAMETERS T_Itms
DO WHILE &RegVal .AND. ! EOF()
   IF RLOCK()
      REPLACE NroItm   WITH T_Itms
   ENDIF
   UNLOCK
   SKIP
   T_Itms = T_Itms + 1
ENDDO
RETURN
**********************************************************************
* Inserta Items
**********************************************************************
PROCEDURE MovInser
******************
RegAct = RECNO()
DO RenumItms WITH XiNroItm + 1
GOTO RegAct
DO MovbGrab
RETURN
************************************************************************ FIN *
* Objeto : Grabar los registros
******************************************************************************
PROCEDURE MOVbgrab
DO LIB_MSGS WITH 4
SELE RMOV
IF Crear
   APPEND BLANK
ENDIF
IF ! Rec_Lock(5)
   RETURN
ENDIF
XsCodRef = ""
IF SEEK(XsCodCta,"CTAS")
   IF CTAS->MAYAUX = "S"
      XsCodRef = PADR(XsCodAux,LEN(CodRef))
   ENDIF
ENDIF
IF Crear
   REPLACE RMOV->CodMod WITH XsCodMod
   REPLACE RMOV->NroItm WITH XiNroItm
ENDIF
REPLACE RMOV->CodCta WITH XsCodCta
REPLACE RMOV->CodRef WITH XsCodRef
REPLACE RMOV->ClfAux WITH XsClfAux
REPLACE RMOV->CodAux WITH XsCodAux
REPLACE RMOV->TpoMov WITH XcTpoMov
REPLACE RMOV->Import WITH XsImport
REPLACE RMOV->GloDoc WITH XsGloDoc
REPLACE RMOV->CodDoc WITH XsCodDoc
REPLACE RMOV->NroDoc WITH XsNroDoc
REPLACE RMOV->NroRef WITH XsNroRef
UNLOCK
DO LIB_MTEC WITH 14
RETURN
**********************************************************************
* Pantalla de Ayuda    ===============================================
**************************************************************************
PROCEDURE MovF1
***************
SAVE SCREEN
GsMsgKey = "[Esc] Retorna"
DO LIB_MTEC WITH 99
@ 3,12 FILL TO 19,64 COLOR W/N
@ 2,13 TO 18,65 COLOR SCHEME 7
@  3,14 SAY  'Teclas de Selecciขn :                              ' COLOR SCHEME 7
@  4,14 SAY  '   Cursor Arriba ....... Retroceder un Registro    ' COLOR SCHEME 7
@  5,14 SAY  '   Cursor Abajo  ....... Adelentar un Registro     ' COLOR SCHEME 7
@  6,14 SAY  '   Home          ....... Primer Registro           ' COLOR SCHEME 7
@  7,14 SAY  '   End           ....... Ultimo Registro           ' COLOR SCHEME 7
@  8,14 SAY  '   PgUp          ....... Retroceder en Bloque      ' COLOR SCHEME 7
@  9,14 SAY  '   PgDn          ....... Adelantar en Bloque       ' COLOR SCHEME 7
@ 10,14 SAY  'Teclas de Ediciขn :                                ' COLOR SCHEME 7
@ 11,14 SAY  '   Enter         ....... Modificar el Registro     ' COLOR SCHEME 7
@ 12,14 SAY  '   Del  (Ctrl G) ....... Anular el Registro        ' COLOR SCHEME 7
@ 13,14 SAY  '   Ins  (Ctrl V) ....... Insertar un  Registro     ' COLOR SCHEME 7
@ 14,14 SAY  '                                                   ' COLOR SCHEME 7
@ 15,14 SAY  '   F1            ....... Pantalla Actual de Ayuda  ' COLOR SCHEME 7
@ 16,14 SAY  '   F3            ....... Renumerar Items           ' COLOR SCHEME 7
@ 17,14 SAY  '   F10           ....... Terminar el Proceso       ' COLOR SCHEME 7
DO WHILE INKEY(0)<>Escape
ENDDO
RESTORE SCREEN
RETURN
**********************************************************************
* Regenerar Acumulados ===============================================
**********************************************************************
PROCEDURE MovF3
*******************
SAVE SCREEN
DO LIB_MSGS WITH 4
@ 11,22 FILL TO 14,54
@ 10,23 SAY "ษอออออออออออออออออออออออออออออออป" COLOR SCHEME 7
@ 11,23 SAY "ณ    R E C A L C U L A N D O    ณ" COLOR SCHEME 7
@ 12,23 SAY "ณ  Espere un momento por favor  ณ" COLOR SCHEME 7
@ 13,23 SAY "ศอออออออออออออออออออออออออออออออผ" COLOR SCHEME 7
**** Recalculando Importes *************************
T_Itms =0
Chqado =0
SEEK VCLAVE
DO WHILE EVALUATE(RegVal) .AND. ! EOF()
   T_Itms = T_Itms + 1
   IF T_Itms <> NroItm
      Chqado =Chqado +1
   ENDIF
   IF RLOCK()
      REPLACE ChkItm   WITH T_Itms
   ENDIF
   UNLOCK
   SELECT RMOV
   SKIP
ENDDO
SELECT VMOV
REPLACE VMOV->NroItm   WITH T_Itms
SELECT RMOV
**** Chequeo del Nro de Items **********************
IF Chqado > 0
   TnItms = 0
   DO WHILE TnItms < T_Itms
      TnItms =0
      SEEK VCLAVE
      DO WHILE EVALUATE(RegVal) .AND. ! EOF()
         IF NroItm <> ChkItm
            IF RLOCK()
               REPLACE NroItm   WITH ChkItm
            ENDIF
            UNLOCK
         ELSE
            TnItms = TnItms + 1
         ENDIF
         SKIP
      ENDDO
   ENDDO
ENDIF
RESTORE SCREEN
Fin  = .T.
RETURN
