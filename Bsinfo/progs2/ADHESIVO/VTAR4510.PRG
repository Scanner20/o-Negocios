*****************************************************************************
* Programa     : vtar4510.prg
* Sistema      : Ventas
* Autor        : RHC
* Proposito    : Reporte de Ventas x Producto/Clientes
* Parametros   : El reporte se basa en la Guias de Remision Facturadas o No
* Creacion     : 27/02/94
* Actualizaci¢n: EMI 27/02/95 Rangos de Productos
*              : EMI 15/05/95 barre desde factura
*****************************************************************************

CLEAR
* Pantalla de Datos
DO FONDO WITH GcTit1,GcTit2,GcTit3,GcTit4
Titulo = [>> REPORTE DE VENTAS POR CLIENTES/ARTICULOS <<]
@ 2,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
@ 8,10 CLEAR TO 20,70
@ 8,10 TO 20,70 DOUBLE
@ 10,20 SAY " Tipo Reporte :"
@ 11,20 SAY "  Del Cliente :               al "
@ 12,20 SAY " Del Articulo :               al "
@ 13,20 SAY " Emitidos del :               al "
*
CLOSE DATA
DO xListar
CLOSE DATA

RETURN
*********************************************************************** EOP() *
PROCEDURE xListar
* Aperturando bases
DO lib_msgs WITH 11
USE admmtcmb IN 0 ORDER tcmb01 ALIAS TCMB
IF !USED()
   RETURN
ENDIF
*
USE ccbrgdoc IN 0 ORDER GDOC08 ALIAS GDOC
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
Arch = PATHUSER+SYS(3)
CREATE TABLE &Arch. ( CodCli C(5), NomCli C(50) , FchDoc D, CodMat C(13), CanDes N(14,2), DesMat C(50),NroGui C(9),;
                      UndVta C(3), PreUni N(12,2), ImpLin N(12,2), CodDoc C(4), NroDoc C(9), CodMon N(1), TpoCmb N(10,4) )
USE &Arch. ALIAS TEMPO EXCLU
IF !USED()
   RETURN
ENDIF
* Variables a usar *
PRIVATE XdFch1,XdFch2,XsCod1,XsCod2,XsCli1,XsCli2
XdFch1   = DATE()
XdFch2   = DATE()
XsCli1   = SPACE(LEN(GDOC->CodCli))
XsCli2   = SPACE(LEN(GDOC->CodCli))
XsCod1   = SPACE(LEN(MATG->CodMat))
XsCod2   = SPACE(LEN(MATG->CodMat))
XiTpoRep = 1
* Pedimos datos
PRIVATE i
SAVE SCREEN TO XXX
DO WHILE .T.
   RESTORE SCREEN FROM XXX
   XdFch1   = DATE()
   XdFch2   = DATE()
   XsCli1   = SPACE(LEN(GDOC->CodCli))
   XsCli2   = SPACE(LEN(GDOC->CodCli))
   XsCod1   = SPACE(LEN(MATG->CodMat))
   XsCod2   = SPACE(LEN(MATG->CodMat))
   XiTpoRep = 1
   i = 1
   UltTecla = 0
   DO lib_mtec WITH 8
   DO WHILE UltTecla # Escape
      DO CASE
      CASE i = 1
         VecOpc(1) = "Resumido  "
         VecOpc(2) = "Detallado x Art¡culo "
         VecOpc(3) = "Detallado x Documento"
         XiTpoRep  = Elige(XiTpoRep,10,36,3)
      CASE i = 2
         GsMsgKey = "[Esc] Salir  [F8] Consultar  [Enter] Aceptar"
         DO lib_mtec WITH 99
         SELE CLIE
         @ 11,36 GET XsCli1 PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8  &&.OR. EMPTY(XsCli1)
            IF !vtabusca("CLIE")
               LOOP
            ENDIF
            XsCli1= CodAux
         ENDIF
         @ 11,36 SAY XsCli1
      CASE i = 3
         GsMsgKey = "[Esc] Salir  [F8] Consultar  [Enter] Aceptar"
         DO lib_mtec WITH 99
         SELE CLIE
         @ 11,54 GET XsCli2 PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8   &&.OR. EMPTY(XsCli2)
            IF !vtabusca("CLIE")
               LOOP
            ENDIF
            XsCli2= CodAux
         ENDIF
         @ 11,54 SAY XsCli2
      CASE i = 4
         GsMsgKey = "[Esc] Salir  [F8] Consultar  [Enter] Aceptar"
         DO lib_mtec WITH 99
         SELE MATG
         @ 12,36 GET XsCod1 PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8
            IF !vtabusca("MATG")
               LOOP
            ENDIF
            XsCod1= CodMat
         ENDIF
         @ 12,36 SAY XsCod1
      CASE i = 5
         GsMsgKey = "[Esc] Salir  [F8] Consultar  [Enter] Aceptar"
         DO lib_mtec WITH 99
         SELE MATG
         @ 12,54 GET XsCod2 PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8
            IF !vtabusca("MATG")
               LOOP
            ENDIF
            XsCod2= CodMat
         ENDIF
         @ 12,54 SAY XsCod2
      CASE i = 6
         @ 13,36 GET XdFch1
         READ
         IF UltTecla = Escape
           EXIT
         ENDIF
      CASE i = 7
         @ 13,54 GET XdFch2
         READ
         IF UltTecla = Escape
           EXIT
         ENDIF
      ENDCASE
      IF i = 8 .AND. UltTecla = Enter
         EXIT
      ENDIF
      i = IIF(INLIST(UltTecla,Arriba,BackTab),i-1,i+1)
      i = IIF(i<1,1,i)
      i = IIF(i>8,8,i)
   ENDDO
   IF UltTecla = Escape
      EXIT
   ENDIF
   ** Generamos Registro Final **
   DO xGENERA
   SELE TEMPO
   SET RELA TO CodMat INTO MATG
   GO TOP
   IF EOF()
      GsMsgErr = [Fin de Archivo]
      DO lib_merr WITH 99
      LOOP
   ENDIF
   DO CASE
   CASE XiTpoRep = 1
        sNomRep = "vta4510a"   && RESUMIDO
   CASE XiTpoRep = 2
        sNomRep = "vta4510b"   && DETALLADO x articulo
   CASE XiTpoRep = 3
        sNomRep = "vta4510c"   && DETALLADO x documento
   ENDCASE
   DO xImpre
ENDDO
RETURN
*********************************************************************** FIN() *
PROCEDURE xImpre
*********************************************************************** FIN() *
SELE TEMPO
GO TOP
Largo   = 66       && Largo de pagina
IniPrn  = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN2]
DO admprint WITH "REPORTS"

RETURN
*********************************************************************** FIN() *
* Generacion de Archivo Auxiliar
*******************************************************************************
PROCEDURE xGENERA

SELE TEMPO
ZAP
IF XiTpoRep = 3
  INDEX ON CodCli+CodDoc+NroDoc+CodMat TO &Arch.
ELSE
  INDEX ON CodCli+CodMat TO &Arch.
ENDIF
SET INDEX TO &Arch.
* Barremos Facturas
xTCmb  = 1
XsCli1 = TRIM(XsCli1)
XsCli2 = TRIM(XsCli2)+CHR(255)
xFor1  = "XsCli1<=CodCli .AND. XsCli2>=CodCli .AND. FlgEst#[A] .AND. CodDoc$'FACT|BOLE'"
XsCod1 = TRIM(XsCod1)
XsCod2 = TRIM(XsCod2)+CHR(255)
xFor2  = "XsCod1<=CodMat AND XsCod2>=CodMat"
xWhile1= "DTOS(FchDoc)>=DTOS(XdFch1) AND DTOS(FchDoc)<=DTOS(XdFch2)"
SELE GDOC
SEEK DTOS(XdFch1)
IF !FOUND() AND RECNO(0)>0
   GOTO Recno(0)
ENDIF
SCAN WHILE &xWhile1 FOR &xFor1
     WAIT "Procesando Documento "+GDOC.CodDoc+[ ]+GDOC.NroDoc WINDOW NOWAIT
     LsCodDoc = GDOC.CodDoc
     LsNroDoc = GDOC.NroDoc
     SELE ITEM
     SEEK LsCodDoc+LsNroDoc
     IF !FOUND()
        DO xGrabR
     ELSE
        SCAN WHILE CodDoc+NroDoc = LsCodDoc+LsNroDoc FOR &xFor2
             DO xGrabR
             SELE TEMPO
             REPLACE CodMat WITH ITEM.CodMat
			 REPLACE DesMat WITH ITEM.DesMat
			 REPLACE UNDVTA WITH ITEM.UNDVTA
             REPLACE CanDes WITH ITEM.CanFac
             REPLACE ImpLin WITH ITEM.ImpLin
             REPLACE NroGui WITH ITEM.NroRef
             SELE ITEM
        ENDSCAN
     ENDIF
     SELE GDOC
ENDSCAN
WAIT "Fin de Generaci¢n" WINDOW NOWAIT
RETURN
*********************************************************************** FIN() *
*Graba resumen cuando es resumen
*********************************************************************** FIN() *
PROCEDURE xGrabR
SELE TEMPO
APPEND BLANK
REPLACE CodDoc WITH GDOC->CodDoc
REPLACE NroDoc WITH GDOC->NroDoc
REPLACE CodCli WITH GDOC->CodCli
REPLACE FchDoc WITH GDOC->FchDoc
REPLACE CodMon WITH GDOC->CodMon
SELE TCMB
SEEK DTOS(GDOC->FchDoc)
IF FOUND()
   xTCmb = IIF(OfiVTA>0,OfiVTA,GDOC->TpoCmb)
ELSE
   xTCmb = IIF(GDOC->TpoCmb>0,GDOC->TpoCmb,1)
ENDIF
xTCmb = IIF(xTCmb >0,xTCmb ,1)
SELE TEMPO
REPLACE TpoCmb WITH xTCmb
REPLACE NomCli WITH GDOC->NomCli
SELE GDOC
RETURN
*********************************************************************** FIN() *
