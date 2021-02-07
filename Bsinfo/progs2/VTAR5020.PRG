*******************************************************************************
*  NOMBRE        : VTAR5020.PRG   (GUSTAVO CANALES F.)                        *
*  Sistema       : ventas                                                     *
*  Proposito     : Registro de VENTAS POR CLIENTES ANUAL                      *
*  Creacion      : 29/03/95                                                   *
*******************************************************************************
CLEAR
* Pantalla de Datos
DO FONDO WITH GcTit1,GcTit2,GcTit3,GcTit4
Titulo = [>> REPORTE DE VENTAS POR CLIENTE ANUAL <<]
@ 2,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
@ 8,10 CLEAR TO 20,70
@ 8,10 TO 20,70 DOUBLE
@ 10,20 SAY " Del Cliente  :               al "
@ 11,20 SAY " Del Articulo :               al "
@ 12,20 SAY " A¤o          :                  "
@ 13,20 SAY " Tipo de Reporte : "
*
CLOSE DATA
DO xListar

CLOSE DATA
RETURN
*********************************************************************** EOP() *
PROCEDURE xListar
*****************
* Aperturando bases
DO lib_msgs WITH 11
USE admmtcmb IN 0 ORDER tcmb01 ALIAS TCMB
IF !USED()
   RETURN
ENDIF
*
USE vtavguia IN 0 ORDER VGUI06 ALIAS GUIA
IF !USED()
   RETURN
ENDIF
*
USE almrmovm IN 0 ORDER RMOV06 ALIAS RMOV
IF !USED()
   RETURN
ENDIF
*
USE vtavpedi IN 0 ORDER VPED01 ALIAS VPED
IF !USED()
   RETURN
ENDIF
*
USE vtarpedi IN 0 ORDER RPED02 ALIAS RPED
IF !USED()
   RETURN
ENDIF
*
USE ccbrgdoc IN 0 ORDER GDOC01 ALIAS GDOC
IF !USED()
   RETURN
ENDIF
*
USE vtaritem IN 0 ORDER ITEM01 ALIAS ITEM
IF !USED()
   RETURN
ENDIF
*
USE cbdmauxi IN 0 ORDER AUXI01 ALIAS CLIE
IF !USED()
   RETURN
ENDIF
*
USE almmmatg IN 0 ORDER MATG01 ALIAS MATG
IF !USED()
   RETURN
ENDIF
* Archivo Temporal de Trabajo
SELE 0
ARCH = PATHUSER+SYS(3)
CREATE TABLE &ARCH. ( CODCLI C(5),   CODMAT C(13),  DESMAT C(40),  NOMCLI C(50),  MES01 N(12,2),;
                      MES02 N(12,2), MES03 N(12,2), MES04 N(12,2), MES05 N(12,2), MES06 N(12,2),;
                      MES07 N(12,2), MES08 N(12,2), MES09 N(12,2), MES10 N(12,2),;
                      MES11 N(12,2), MES12 N(12,2), UNDSTK C(3) )
USE &Arch. ALIAS TEMPO EXCLU
IF !USED()
   RETURN
ENDIF
SELE GUIA
* Variables a usar *
PRIVATE XdFchDoc1,XdFchDoc2,XsCodMat1,XsCodMat2
STORE [] TO XsCodMat1,XsCodMat2
XiTipRep=1
* Pedimos datos
PRIVATE i
SAVE SCREEN TO XXX
DO WHILE .T.
   RESTORE SCREEN FROM XXX
   XsAno    = LEFT(DTOS(DATE()),4)
   XsCodCli1= SPACE(LEN(GUIA->CodCli))
   XsCodCli2= SPACE(LEN(GUIA->CodCli))
   XsCodMat1= SPACE(LEN(MATG->CodMat))
   XsCodMat2= SPACE(LEN(MATG->CodMat))
   i = 1
   UltTecla = 0
   DO lib_mtec WITH 8
   DO WHILE UltTecla # Escape
      DO CASE
      CASE i = 1
         GsMsgKey = "[Esc] Salir  [F8] Consultar  [Enter] Aceptar"
         DO lib_mtec WITH 99
         SELE CLIE
         @ 10,36 GET XsCodCli1 PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8  &&.OR. EMPTY(XsCodCli1)
            IF !vtabusca("CLIE")
               LOOP
            ENDIF
            XsCodCli1= CodAux
         ENDIF
         @ 10,36 SAY XsCodCli1
      CASE i = 2
         GsMsgKey = "[Esc] Salir  [F8] Consultar  [Enter] Aceptar"
         DO lib_mtec WITH 99
         SELE CLIE
         @ 10,54 GET XsCodCli2 PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8   &&.OR. EMPTY(XsCodCli2)
            IF !vtabusca("CLIE")
               LOOP
            ENDIF
            XsCodCli2= CodAux
         ENDIF
         @ 10,54 SAY XsCodCli2
      CASE i = 3
         GsMsgKey = "[Esc] Salir  [F8] Consultar  [Enter] Aceptar"
         DO lib_mtec WITH 99
         SELE MATG
         @ 11,36 GET XsCodMat1 PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8 &&.OR. EMPTY(XsCodMat1)
            IF !vtabusca("MATG")
               LOOP
            ENDIF
            XsCodMat1= CodMat
         ENDIF
         @ 11,36 SAY XsCodMat1
      CASE i = 4
         GsMsgKey = "[Esc] Salir  [F8] Consultar  [Enter] Aceptar"
         DO lib_mtec WITH 99
         SELE MATG
         @ 11,54 GET XsCodMat2 PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8 &&.OR. EMPTY(XsCodMat2)
            IF !vtabusca("MATG")
               LOOP
            ENDIF
            XsCodMat2= CodMat
         ENDIF
         @ 11,54 SAY XsCodMat2
      CASE i = 5
         @ 12,36 GET XsAno    PICT "@ 9999"
         READ
         IF LASTKEY() = 27
            RETURN
         ENDIF
      CASE i = 6
      	 VecOpc(1)="Resumido "
      	 VecOpc(2)="Detallado"
      	 XiTipRep=Elige(XiTipRep,13,42,2)
         IF LASTKEY() = 27
            RETURN
         ENDIF
      ENDCASE
      IF i = 6 .AND. UltTecla = Enter
         EXIT
      ENDIF
      i = IIF(INLIST(UltTecla,Arriba,BackTab),i-1,i+1)
      i = IIF(i<1,1,i)
      i = IIF(i>6,6,i)
   ENDDO
   IF UltTecla = Escape
      EXIT
   ENDIF
   ** Generamos Registro Final **
   DO xGENERA
   SELE TEMPO
   GO TOP
   IF EOF()
      GsMsgErr = [Fin de Archivo]
      DO lib_merr WITH 99
      LOOP
   ENDIF
   DO xImpre
ENDDO
RETURN
*********************************************************************** FIN() *
PROCEDURE xImpre
*********************************************************************** FIN() *
SELE TEMPO
GO TOP
if XiTipRep=2
	sNomRep = "VTAR5020"
else
	sNomRep = "VTAR502A"
endif
Largo   = 66       && Largo de pagina
IniPrn  = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN3]
DO admprint WITH "REPORTS"

RETURN
********************************************************************** FIN
PROCEDURE xGENERA
*****************
SELE TEMPO
ZAP
INDEX ON CODMAT+CODCLI TO &Arch.
SET INDEX TO &Arch.
* Barremos Guias
xTCmb = 1
XsCodCli1 = TRIM(XsCodCli1)
XsCodCli2 = TRIM(XsCodCli2)+CHR(255)
xFor = "XsCodCli1<=CodCli.AND.XsCodCli2>=CodCli"
xFor = xFor + ".AND. Motivo = 1"
XsCodMat1 = TRIM(XsCodMat1)
XsCodMat2 = TRIM(XsCodMat2)+CHR(255)
xFor1 = "XsCodMat1<=CodMat.AND.XsCodMat2>=CodMat"
SELE GUIA
SEEK [G/R ]+XsAno
IF !FOUND()
   IF RECNO(0)>0 .AND. RECNO(0)<=RECCOUNT()
      GO RECNO(0)
      IF DELETED()
         SKIP
      ENDIF
   ENDIF
ENDIF
SCAN WHILE CodDoc=[G/R ] .AND. LEFT(DTOS(FchDoc),4)=XsAno FOR &xFor
   WAIT "Procesando Guia No "+NroDoc WINDOW NOWAIT
   XcTipMov = [S]
   XsCodMov = [G]+SUBSTR(GUIA->NroDoc,2,2)
   XsNroDoc = SUBSTR(GUIA->NroDoc,4)
   XsCodCli = GUIA->CodCli
   SELE RMOV
   SEEK XcTipMov+XsCodMov+XsNroDoc
   SCAN WHILE TipMov+CodMov+NroDoc = XcTipMov+XsCodMov+XsNroDoc FOR &xFor1
      XsCodMat = RMOV->CodMat
      SELE TEMPO
      SEEK XsCodMat+XsCodCli
      IF !FOUND()
         APPEND BLANK
         REPLACE CodCli WITH GUIA->CodCli
         REPLACE NomCli WITH GUIA->NomCli
         REPLACE CodMat WITH RMOV->CodMat
         REPLACE DesMat WITH RMOV->DesMat
         REPLACE UndStk WITH RMOV->UndVta
         SELE MATG
         SEEK RMOV->CodMat
         SELE TEMPO
         REPLACE DesMat WITH MATG->DesMat
         REPLACE UndStk WITH MATG->UndStk
      ENDIF
      XfCanDes = RMOV->CanDes*RMOV->Factor   &&OJO<>
      DO CASE
      CASE MONTH(GUIA->FchDoc)=1
           REPLACE MES01 WITH TEMPO->MES01 + XfCanDes
      CASE MONTH(GUIA->FchDoc)=2
           REPLACE MES02 WITH TEMPO->MES02 + XfCanDes
      CASE MONTH(GUIA->FchDoc)=3
           REPLACE MES03 WITH TEMPO->MES03 + XfCanDes
      CASE MONTH(GUIA->FchDoc)=4
           REPLACE MES04 WITH TEMPO->MES04 + XfCanDes
      CASE MONTH(GUIA->FchDoc)=5
           REPLACE MES05 WITH TEMPO->MES05 + XfCanDes
      CASE MONTH(GUIA->FchDoc)=6
           REPLACE MES06 WITH TEMPO->MES06 + XfCanDes
      CASE MONTH(GUIA->FchDoc)=7
           REPLACE MES07 WITH TEMPO->MES07 + XfCanDes
      CASE MONTH(GUIA->FchDoc)=8
           REPLACE MES08 WITH TEMPO->MES08 + XfCanDes
      CASE MONTH(GUIA->FchDoc)=9
           REPLACE MES09 WITH TEMPO->MES09 + XfCanDes
      CASE MONTH(GUIA->FchDoc)=10
           REPLACE MES10 WITH TEMPO->MES10 + XfCanDes
      CASE MONTH(GUIA->FchDoc)=11
           REPLACE MES11 WITH TEMPO->MES11 + XfCanDes
      CASE MONTH(GUIA->FchDoc)=12
           REPLACE MES12 WITH TEMPO->MES12 + XfCanDes
      ENDCASE
      SELE RMOV
   ENDSCAN
   SELE GUIA
ENDSCAN
WAIT "Fin de Generaci¢n" WINDOW NOWAIT
RETURN
************************************************************************* FIN
