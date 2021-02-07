**********************************************************************
*  Nombre        : vtap4250.prg
*  Sistema       : ventas
*  Proposito     : Registro de guias x FlgEst
*  Creacion      : 21/02/95
*  Actualizacion : 21/02/95
***************************************************************************
CLEAR
DO FONDO WITH GcTit1,GcTit2,GcTit3,GcTit4
Titulo = [>> REGISTRO DE GUIAS DE REMISION <<]
@ 2,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
@ 5,10 CLEAR TO 20,68
@ 5,10 TO 20,68 DOUBLE
CLOSE DATA
WAIT "Aperturando Sistema" NOWAIT WINDOW
** bases de datos a usar **
DO SDOLista
CLOSE DATA
RETURN
*********************************************************************** EOP() *
PROCEDURE SDOLISTA
SELE 1
USE cbdmauxi ORDER AUXI01 ALIAS CLIE
IF !USED()
   RETURN
ENDIF
**
SELE 2
USE ccbrgdoc ORDER GDOC01 ALIAS GDOC
IF !USED()
   RETURN
ENDIF
**
SELE 3
USE ccbrrdoc ORDER RDOC01 ALIAS RDOC
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
**
SELE GDOC
Arch = PATHUSER+SYS(3)
COPY STRU TO &Arch.
SELE 0
USE &Arch.  ALIAS TEMPO EXCLU
IF !USED()
   RETURN
ENDIF
INDEX ON TpoDoc+CodDoc+NroDoc TO &Arch.
SET INDEX TO &Arch.
** variables a usar **
STORE DATE() TO XdFecha1,XdFecha2
@  8,20 SAY "Del Dia     :" GET XdFecha1
@ 10,20 SAY " Al Dia     :" GET XdFecha2
READ
IF LASTKEY() = 27
   RETURN
ENDIF
** Generamos Registro Final **
DO xGENERA
** test de impresion **
XFOR = []
XWHILE = []
** buscamos registro de arranque **
SELE TEMPO
GO TOP
STORE 0 TO XfTotIgv,XfTotTot
DO WHILE !EOF()
   IF TpoDoc = [D]
      XfTotIgv = XfTotIgv - ImpIgv
      XfTotTot = XfTotTot - ImpTot
   ELSE
      XfTotIgv = XfTotIgv + ImpIgv
      XfTotTot = XfTotTot + ImpTot
   ENDIF
   SKIP
ENDDO
GO TOP
Largo  = 66       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN3]
sNomRep = "vtar4100"
DO admprint WITH "REPORTS"

RETURN
   RETURN
ENDIF
**
PROCEDURE xGENERA
*  Impresion ---------------------------------------------------------------------------
DO ADMPRINT
IF LASTKEY() = Escape
   CLOSE DATA
   RETURN
ENDIF
IniImp   = _Prn1    && 10   cpi
Largo    = 66
Ancho    = 80
Tit_SIzq = GsNomCia
Tit_IIzq = GsNomSub
Tit_SDer =''
Tit_IDer =''
Titulo   = []
SubTitulo= []
En1    = "EXISTENCIAS POR ALMACEN"
En2    = TRIM(GsNomSub)
IF ! TRIM(LsCodMatD) == ""
  En2  = "Materiales del "+TRIM(LsCodMatD)+" al "+TRIM(LsCodMatH)
ENDIF
En3    = Lde+SPACE(5)+IIF(LiTpoRep=1,"ORDENADO POR FECHA","ORDENADO POR CORRELATIVO")
En4    = '=========================================================================================================================='
En5    = '        !  No.  !   No.   !CODIGO                                 ! CODIGO                                                '
En6    = ' FECHA  ! GUIA. ! FACTURA !CLIENTE     NOMBRE DE CLIENTE          ! MATERIAL    DESCRIPCION                      CANTIDAD '
En7    = '=========================================================================================================================='
En8    = []
En9    = []
LinFin = Largo - 8
IF UltTecla = Escape
   CLOSE DATA
   RETURN
ENDIF
Cancelar  = .F.
RegIni = RECNO()
SET DEVICE TO PRINT
PRINTJOB
   GOTO RegIni
   NumPag   = 0
   NumEle   = 0
   cCodFam = SPACE(LEN(FAMI->CodFam))
   DO WHILE MATE->SubAlm+MATE->CodMat <= GsSubAlm+LsCodMatH ;
            .AND. ! EOF() .AND. ! Cancelar
      IF iConStk = 1 .AND. MATE->StkAct <= 0
         SKIP
         LOOP
      ENDIF
      IF PROW() > LinFin .OR. NumPag = 0
         DO ResetPag IN ALML3211
      ENDIF
      SELECT MATE
      NumLin = PROW() + 1
      @ NumLin,2   SAY MATE->CodMat
      @ NumLin,18  SAY MATG->DesMat PICT "@S40"
      @ NumLin,60  SAY MATE->StkAct PICT "99,999,999.99"
      @ NumLin,74  SAY MATG->UndStk
      SKIP
      DO WHILE MATE->CodMat = cCodFam  .AND. ! EOF() .AND. iConStk = 1
         IF MATE->StkAct > 0
            EXIT
         ENDIF
         SKIP
      ENDDO
      Cancelar = INKEY() = Escape .OR. Cancelar
   ENDDO
EJECT PAGE
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO ADMPRFIN IN ADMPRINT
CLOSE DATA
RETURN
