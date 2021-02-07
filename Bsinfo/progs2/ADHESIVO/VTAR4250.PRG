***************************************************************************
*  NOMBRE        : VTAR4250.PRG
*  Sistema       : ventas
*  Proposito     : Registro de Guias x FlgEst
*  Creacion      : 21/02/95
*  Actualizacion : EMI 29/03/95 Regularizacion de variables
*                : EMI 15/05/95 Tipos de reportes detalle/resumen
***************************************************************************
CLEAR
DO FONDO WITH GcTit1,GcTit2,GcTit3,GcTit4
Titulo = [>> REGISTRO DE GUIAS DE REMISION <<]
@ 2,(80-LEN(Titulo))/2  SAY Titulo COLOR SCHEME 7
@ 10,10 CLEAR TO 16,68
@ 09,10 TO 17,68 DOUBLE
@ 10,20 SAY "Tipo Reporte :"
@ 11,20 SAY "Ordenado por :"
@ 12,20 SAY "Emitidos del :           al "
@ 13,20 SAY "Del Cliente  :           al "
@ 14,20 SAY "Del Numero   :           al "
@ 16,20 SAY "Condici¢n    :"
CLOSE DATA
DO xListar
CLOSE DATA
RETURN
*********************************************************************** EOP() *
PROCEDURE xListar
*****************
SELE 1
USE VTAVGUIA ORDER VGUI01 ALIAS VGUI
IF !USED()
  CLOSE DATA
  RETURN
ENDIF
**
SELE 2
USE ALMRMOVM ORDER RMOV06 ALIAS RMOV
IF !USED()
  CLOSE DATA
  RETURN
ENDIF
**
SELE 3
USE ALMMMATG ORDER MATG01 ALIAS MATG
IF !USED()
  CLOSE DATA
  RETURN
ENDIF
**
SELE 4
USE CBDMAUXI ORDER AUXI01 ALIAS CLIE
IF !USED()
  CLOSE DATA
   RETURN
ENDIF
*** Variables a usar ***
STORE DATE() TO XdFch1,XdFch2
nRep     = []
XiTpoRep = 1
XiOrden  = 1
XiCondi  = 1
XiMotiv  = 1
XsCod1   = SPACE(LEN(VGUI.NroDoc))
XsCod2   = SPACE(LEN(VGUI.NroDoc))
XsCli1   = SPACE(LEN(CLIE.CODAUX))
XsCli2   = SPACE(LEN(CLIE.CODAUX))
i = 1
UltTecla = 0
DO WHILE ! INLIST(UltTecla,Escape)
   DO CASE
   CASE i = 1
       VecOpc(1) = "Resumido  "
       VecOpc(2) = "Detallado "
       XiTpoRep  = Elige(XiTpoRep,10,35,2)
   CASE i = 2
       VecOpc(1) = "Fecha "
       VecOpc(2) = "Motivo"
       VecOpc(3) = "N£mero"
       XiOrden   = Elige(XiOrden,11,35,3)
   CASE i = 3
       @ 12,35 GET XdFch1
       READ
       ULTTECLA = LASTKEY()
       IF UltTecla = Escape
         EXIT
       ENDIF
       @ 12,35 SAY XdFch1
   CASE i = 4
       @ 12,49 GET XdFch2
       READ
       ULTTECLA = LASTKEY()
       IF UltTecla = Escape
         EXIT
       ENDIF
       @ 12,49 SAY XdFch2
   CASE i = 5
       GsMsgKey = "[Esc] SALIR  [F8] CONSULTAR  [Enter] ACEPTAR"
       DO lib_mtec WITH 99
       SELE CLIE
       @ 13,35 GET XsCli1 PICT "@!"
       READ
       ULTTECLA = LASTKEY()
       IF UltTecla = Escape
         EXIT
       ENDIF
       IF UltTecla = F8
         IF !vtabusca("CLIE")
           LOOP
         ENDIF
         XsCli1= CodAux
       ENDIF
       IF !(EMPTY(XsCli1))
         SEEK GsClfAux+XsCli1
         IF !FOUND()
           LOOP
         ENDIF
       ENDIF
       @ 13,35 SAY XsCli1
   CASE I = 6
       GsMsgKey = "[Esc] SALIR  [F8] CONSULTAR  [Enter] ACEPTAR"
       DO lib_mtec WITH 99
       SELE CLIE
       @ 13,49 GET XsCli2 PICT "@!"
       READ
       ULTTECLA = LASTKEY()
       IF UltTecla = Escape
         EXIT
       ENDIF
       IF ULTTECLA = F8
         IF !vtabusca("CLIE")
           LOOP
         ENDIF
         XsCli2= CodAux
       ENDIF
       IF !(EMPTY(XsCli2))
         SEEK GsClfAux+XsCli2
         IF !FOUND()
           LOOP
         ENDIF
       ENDIF
       @ 13,49 SAY XsCli2
   CASE i = 7  AND XiOrden = 3
       @ 14,35 GET XsCod1  PICT "@R 999-999999"
       READ
       UltTecla = LASTKEY()
       IF UltTecla = Escape
         EXIT
       ENDIF
       IF !EMPTY(XsCod1)
          XsCodd = RIGHT("000"+LEFT(XsCod1,3),3)
          XsCod1 = XsCodd+RIGHT("000000"+ALLTRIM(SUBS(XsCod1,4)),6)
       ENDIF
       @ 13,35 SAY XsCod1  PICT "@R 999-999999"
   CASE i = 8  AND XiOrden = 3
       @ 14,49 GET XsCod2  PICT "@R 999-999999"
       READ
       UltTecla = LASTKEY()
       IF UltTecla = Escape
         EXIT
       ENDIF
       IF !EMPTY(XsCod2)
          XsCodd = RIGHT("000"+LEFT(XsCod2,3),3)
          XsCod2 = XsCodd+RIGHT("000000"+ALLTRIM(SUBS(XsCod2,4)),6)
       ENDIF
       @ 14,49 SAY XsCod2  PICT "@R 999-999999"
   CASE i = 9  AND XiOrden = 2
       @ 15,20 SAY "Tpo.de Motivo:"
       VecOpc(1) = "Todos los Motivos"
       VecOpc(2) = "Ventas        "
       VecOpc(3) = "Transformacion"
       VecOpc(4) = "Traslado Interno"
       VecOpc(5) = "Consignaci¢n"
       VecOpc(6) = "Traslado temporal"
       VecOpc(7) = "Otros"
       XiMotiv   = Elige(XiMotiv,15,35,7)
   CASE i = 10 AND ((XiMotiv = 1 AND XiOrden = 2) OR !XiOrden = 2)
       VecOpc(1) = "Todos      "
       VecOpc(2) = "Pendientes "
       VecOpc(3) = "Facturados "
       VecOpc(4) = "Anulados   "
       XiCondi   = Elige(XiCondi,16,35,4)
   ENDCASE
   IF UltTecla = Enter AND i=10
     EXIT
   ENDIF
   i = IIF(INLIST(UltTecla,Escape,BackTab,Arriba),i-1,i+1)
   i = IIF(I< 1, 1,i)
   i = IIF(I>10,10,i)
ENDDO
IF UltTecla = Escape
   CLOSE DATA
   RETURN
ENDIF
***  FILTROS  ***
XsCli1 = TRIM(XsCli1)
XsCli2 = TRIM(XsCli2)+CHR(255)
XsCod1 = TRIM(XsCod1)
XsCod2 = TRIM(XsCod2)+CHR(255)
DO xGENERA
xFor      = []
xWhile    = []
SELE TEMPO
GO TOP
IF EOF()
   GsMsgErr = [Fin de Archivo]
   DO lib_merr WITH 99
   CLOSE DATA
   RETURN
ENDIF
Largo  = 66       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN3]
sNomRep = nRep
DO admprint WITH "REPORTS"
RETURN
*********************************************************************** FIN() *
* Generacion de Archivo Auxiliar
*******************************************************************************
PROCEDURE xGENERA

SELE 0
ARCH = PATHUSER+SYS(3)
CREATE TABLE &ARCH. ( MOTIVO N(1), FCHDOC D, CODDOC C(4), TPOGUI C(4), NRODOC C(9),;
                      CODCLI C(5), NOMCLI C(50), DIRCLI C(60), CODMAT C(13),;
                      DESMAT C(40), CANGUI N(14,4), FACTOR N(12,4), FLGEST C(1),;
                      NROFAC C(9), CODFAC C(4) )
USE &ARCH. ALIAS TEMPO EXCLU
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
xFor1  = "XsCli1<=CodCli AND XsCli2>=CodCli"
DO CASE
CASE XiTpoRep = 1 AND XiOrden = 1  && resumen por fecha
     INDEX ON DTOS(FCHDOC)+NRODOC+CODCLI TO &ARCH.
     nRep = "VTA4250A"
     xWhile1= "XdFch1<=FchDoc AND XdFch2>=FchDoc"
CASE XiTpoRep = 1 AND XiOrden = 2 && resumen por motivo
     INDEX ON STR(Motivo,1,0)+NRODOC+CODCLI TO &ARCH.
     nREP="VTA4250B"  && [C]
     xWhile1= "XdFch1<=FchDoc AND XdFch2>=FchDoc"
     IF XiMotiv > 1
        xFor1  = xFor1+" AND Motivo=XiMotiv"
     ENDIF
CASE XiTporep = 1 AND XiOrden = 3 &&resumen por numero
     INDEX ON NRODOC+CODCLI TO &ARCH.
     nREP="VTA4250C"
     xWhile1= "XsCod1<=NroDoc AND XsCod2>=NroDoc"
     xFor1  = xFor1+" AND XdFch1<=FchDoc AND XdFch2>=FchDoc"
CASE XiTpoRep = 2 AND XiOrden = 1  && detalle por fecha
     INDEX ON DTOS(FCHDOC)+NRODOC+CODCLI TO &ARCH.
     nRep = "VTA4250D"
     xWhile1= "XdFch1<=FchDoc AND XdFch2>=FchDoc"
CASE XiTpoRep = 2 AND XiOrden = 2 && detalle por motivo
     INDEX ON STR(Motivo,1,0)+NRODOC+CODCLI TO &ARCH.
     nREP="VTA4250E"
     xWhile1= "XdFch1<=FchDoc AND XdFch2>=FchDoc"
     IF XiMotiv > 1
        xFor1  = xFor1 +" AND Motivo=XiMotiv"
     ENDIF
CASE XiTporep = 2 AND XiOrden = 3 &&detalle por numero
     INDEX ON NRODOC+CODCLI TO &ARCH.
     nREP="VTA4250F"
     xWhile1= "XsCod1<=NroDoc AND XsCod2>=NroDoc"
     xFor1  = xFor1+" AND XdFch1<=FchDoc AND XdFch2>=FchDoc"
ENDCASE
SET INDEX TO &Arch.
DO CASE
CASE XiCondi = 2
     XFor1 = xFor1+" AND FlgEst = [P]"
CASE XiCondi = 3
     XFor1 = xFor1+" AND FlgEst = [F]"
CASE XiCondi = 4
     XFor1 = xFor1+" AND FlgEst = [A]"
ENDCASE
SELE VGUI
IF XiOrden = 3
   SET ORDER TO VGUI01
   SEEK [G/R ]+XsCod1
ELSE
   SET ORDER TO VGUI06
   SEEK [G/R ]+DTOS(XdFch1)
ENDIF
IF !FOUND()
   IF RECNO(0)>0 .AND. RECNO(0)<=RECCOUNT()
      GO RECNO(0)
      IF DELETED()
         SKIP
      ENDIF
   ENDIF
ENDIF
xIni = .T.
SCAN WHILE &xWhile1 FOR &xFor1
     WAIT "Procesando Guia No "+NroDoc WINDOW NOWAIT
     IF XiTporep = 1
        DO xGrabr
     ELSE
        DO CASE
        CASE VGUI->Motivo = 1
           LcTipMov = [S]
        CASE VGUI->Motivo = 2
           LcTipMov = [S]
        CASE VGUI->Motivo = 3
           LcTipMov = [T]
        CASE VGUI->Motivo = 4
           LcTipMov = [T]
        CASE VGUI->Motivo = 5
           LcTipMov = [T]
        CASE VGUI->Motivo = 6
           LcTipMov = [S]
        ENDCASE
        LsCodMov = [G]+SUBSTR(VGUI->NRODOC,2,2)
        LsNroDoc = SUBSTR(VGUI->NRODOC,4)
        SELE RMOV
        SEEK LcTipMov+LsCodMov+LsNroDoc
        IF !FOUND()
           DO xGrabR
        ELSE
           SCAN WHILE TipMov+CodMov+NroDoc = LcTipMov+LsCodMov+LsNroDoc
                DO xGrabR
                SELE TEMPO
                REPLACE CODMAT WITH RMOV->CODMAT
                REPLACE CANGUI WITH (RMOV->CANGUI*RMOV->FACTOR)
                SELE MATG
                SEEK TRIM(TEMPO->CODMAT)
                SELE TEMPO
                REPLACE DESMAT WITH MATG->DESMAT
                SELE RMOV
           ENDSCAN
        ENDIF
     ENDIF
     SELE VGUI
ENDSCAN
WAIT "Fin de Generaci¢n" WINDOW NOWAIT
RETURN
*********************************************************************** FIN() *
*Graba resumen cuando es resumen
*********************************************************************** FIN() *
PROCEDURE xGrabR
SELE TEMPO
APPEND BLANK
REPLACE MOTIVO WITH VGUI->MOTIVO
REPLACE FCHDOC WITH VGUI->FCHDOC
REPLACE TPOGUI WITH VGUI->TPOGUI
REPLACE NRODOC WITH VGUI->NRODOC
REPLACE CODCLI WITH VGUI->CODCLI
IF VGUI->FLGEST = "A"
   REPLACE NOMCLI WITH " ***  A N U L A D O  ***"
ELSE
   REPLACE CODFAC WITH VGUI->CODFAC
   REPLACE NROFAC WITH VGUI->NROFAC
   REPLACE NOMCLI WITH VGUI->NOMCLI
   REPLACE DIRCLI WITH VGUI->DIRCLI
ENDIF
SELE VGUI
RETURN
*********************************************************************** FIN() *
FUNCTION _dMotivo
PARAMETER cMotivo
DO CASE
   CASE cMotivo = 1
      RETURN [Todos Los Motivos]
   CASE cMotivo = 2
      RETURN [VENTAS           ]
   CASE cMotivo = 3
      RETURN [Transformaci¢n   ]
   CASE cMotivo = 4
      RETURN [Traslado Interno ]
   CASE cMotivo = 5
      RETURN [Consignaci¢n     ]
   CASE cMotivo = 6
      RETURN [Traslado Temporal]
   CASE cMotivo = 7
      RETURN [Otros            ]
ENDCASE
RETURN 0
*********************************************************************** FIN() *
FUNCTION _Motivo
****************
PARAMETER cMotivo
DO CASE
   CASE cMotivo = 1
      RETURN [VENTAS           ]
   CASE cMotivo = 2
      RETURN [TRANSFORMACION   ]
   CASE cMotivo = 3
      RETURN [TRASLADO INTERNO ]
   CASE cMotivo = 4
      RETURN [CONSIGNACION     ]
   CASE cMotivo = 5
      RETURN [TRASLADO TEMPORAL]
   CASE cMotivo = 6
      RETURN [OTROS            ]
ENDCASE
RETURN 0
*********************************************************************** FIN() *
FUNCTION _Status
PARAMETER cStatus
DO CASE
   CASE cStatus = 1
      RETURN [Todos los Status ]
   CASE cStatus = 2
      RETURN [Pendientes       ]
   CASE cStatus = 3
      RETURN [Facturados       ]
   CASE cStatus = 4
      RETURN [Anulados         ]
ENDCASE

RETURN 0
*********************************************************************** FIN() *
