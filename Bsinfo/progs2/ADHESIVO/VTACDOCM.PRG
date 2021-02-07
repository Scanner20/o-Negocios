*------------------------------------------------------------------------------
*  Nombre    : VTacdocm.PRG
*  Autor     : VETT
*  Proposito : Correlativos de documentos de ventas
*  Creaci¢n  : 11/01/91
*------------------------------------------------------------------------------
** Abrimos areas a usar **
*IF !Master
*   RETURN
*ENDIF
sele 1
*USE ALMTABLA ORDER TABL01 ALIAS TABL
*SELE 2
USE vtatdocm ORDER DOCM01 ALIAS DOCM
SELE DOCM
** Definimos variables publicas **
PRIVATE XcTipMov,XsNroDoc,XsCodMov
STORE "" TO XsPtoVta,XnNroDoc,XsCodDoc
Temp = 1

*** Pintamos pantalla ***
CLEAR
Titulo = "CORRELATIVO DE DOCUMENTOS"
cTit1=GsNomCia
cTit2="FECHA : "+GsFecha
cTit3=""
cTit4=Titulo
DO FONDO WITH cTit1,cTit2,cTit3,cTit4
@ 10,6 FILL  TO 18,73 COLOR W/N
@ 9,7 CLEAR TO 17,72
@ 9,7 TO 17,72
@ 11,9  SAY "Documento            :"
@ 12,9  SAY "Punto de venta       :"
@ 15,9  SAY "Nro. de Documento    :"

*Titulo = "Sub.Almacen : "+GsSubAlm+ "  "+ ALLTRIM(GsNomSub)
*@  5,(80-len(Titulo))/2 SAY Titulo
*DO dB_Marco with 5,0,16,80,Simple,"Sub.Almacen : "+GsSubAlm+"  "+TRIM(GsNomSub),;
*                VSArr,HCen,.F.,.F.

** Logica Principal **
DO Lib_MTEC with 3
DO EDITA WITH 'DOCLeerK','DOCPoner','DOCTomar','DOCBorra','',;
                 [],[],'CMA'
CLOSE PROCEDURE
CLOSE DATA
RETURN


************************************************************************* EOF
* Procedimiento de Lectura de llave
******************************************************************************
PROCEDURE DOCLeerK
DO Lib_MTEC WITH 11
XsCodDoc = DOCM->CodDoc
XsPtoVta = DOCM->PtoVta
i = 1
UltTecla = 0
DO WHILE !INLIST(UltTecla,Escape,CtrlW)
   DO CASE
      CASE i = 1
        *SELE TABL
        *XsTabla = "03"
         DO LIB_MTEC WITH 12
         @ 11,33 GET XsCodDoc PICT "@!"
         READ
         UltTecla = Lastkey()
         IF UltTecla = Escape .or. UltTecla = 0
            LOOP
         ENDIF
        *IF UltTecla = F8
        *   IF !VTABUSCA("TABL")
        *      UltTecla = 0
        *      LOOP
        *   ENDIF
        *   XsCodDoc=LEFT(TABL->Codigo,4)
        *ENDIF
        *SEEK XsTabla+XsCodDoc
        *IF ! FOUND()
        *   GsMsgErr = "Documento NO Registrado"
        *   DO LIB_MERR WITH 9
        *   LOOP
        *ENDIF
        *@ 11,33 SAY XsCodDoc +" "+LEFT(TABL->NomBre,20)
         SELE DOCM
         SEEK XsCodDoc
         XsPtoVta = DOCM->PtoVta
      CASE i = 2  and XsCodDoc<>"PEDI"
         DO LIB_MTEC WITH 11
         @ 12,33 GET XsPtoVta PICT "@!"
         READ
         UltTecla = LastKey()
         IF UltTecla = Arriba
            i = 1
            LOOP
         ENDIF
         IF UltTecla = Escape .or. UltTecla = 0
            LOOP
         ENDIF
      CASE i = 3
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i < 1, 1, i)
   i = IIF(i > 3, 3, i)
ENDDO
SELE DOCM
IF UltTecla <> Escape
   SEEK (XsCodDoc+XsPtoVta)
ENDIF
RETURN
************************************************************************** FIN
* Procedimiento inicializa variables
******************************************************************************
PROCEDURE DOCInvar
XnNroDoc = 1
RETURN
************************************************************************** FIN
* Procedimiento pone datos en pantalla
******************************************************************************
PROCEDURE DOCPoner
*=SEEK("03"+CodDoc,"TABL")
*@ 11,33 SAY CODDOC+' '+LEFT(TABL->NomBre,20)
@ 11,33 SAY CODDOC
@ 12,33 SAY PTOVTA
@ 15,33 SAY RIGHT(REPLICATE("0", 7)+LTRIM(STR(DOCM->NroDoc)), 7 )
RETURN
************************************************************************** FIN
* Procedimiento de carga de variables
******************************************************************************
PROCEDURE DOCMover
XnNroDoc = DOCM->NroDoc
RETURN
************************************************************************** FIN
* Procedimiento de tomar datos
******************************************************************************
PROCEDURE DOCTomar
IF EOF()
   DO DOCInvar
ELSE
   DO DOCMover
   IF .NOT. Rec_Lock(5)
      RETURN                 && No pudo bloquear registro
   ENDIF
ENDIF

DO LIB_MTEC WITH 7
*Teclas = CHR(REscape) + Chr(REnter) + Chr(RCtrlW) + Chr(RPgUp) + Chr(RPgDn)
DO WHILE !INLIST(UltTecla,Escape,Enter,CtrlW,PgUp,PgDn)
   @ 15,33 GET XnNroDoc PICT "9999999" Valid XnNroDoc > 0
   READ
   UltTecla = Lastkey()
ENDDO
@ 15,33 SAY RIGHT(REPLICATE("0", 6)+LTRIM(STR(XnNroDoc)), 7 )
IF UltTecla <> Escape
   DO DOCGraba
ENDIF
UNLOCK ALL
DO Lib_MTEC with 3
RETURN
************************************************************************** FIN
* Procedimiento de Grabacion de informacion
******************************************************************************
PROCEDURE DOCGraba
DO LIB_MSGS WITH 4
IF EOF()                  && Creando
   SEEK (XsCodDoc+XsPtoVta)
   IF FOUND()
      DO LIB_MERR WITH 11
      RETURN
   ENDIF
   APPEND BLANK
   IF .NOT. Rec_Lock(5)
      RETURN              && No pudo bloquear registro
   ENDIF
   REPLACE DOCM->CodDoc WITH XsCodDoc
   REPLACE DOCM->PtoVta WITH XsPtoVta
ENDIF
REPLACE DOCM->NroDoc WITH XnNroDoc
RETURN
************************************************************************** FIN
* Procedimiento de borrado de un registro
******************************************************************************
PROCEDURE DOCBorra
DO Lib_MSGS with 10
IF Rec_Lock(5)
   DELETE
   SKIP
   UNLOCK
ENDIF
DO Lib_MTEC with 3
RETURN
************************************************************************** FIN
*  Proposito     : Listado de correlativos de almacenes
***************************************************************************
PROCEDURE DOCLista
PRIVATE LsCodIni,LsCodFin,LsNomIni,LsNomFin,Temp
DO Lib_mtec with 0
SAVE SCREEN TO Temp
SEEK GsSubALm
IF EOF()
   DO lib_merr WITH 7   && fin de archivo
ELSE
   *DO DOCLImpr
   Largo  = 66       && Largo de pagina
   IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN1]
   sNomRep = "ALMP1700"
   DO ADMPRINT WITH "REPORTS"
ENDIF
RESTORE SCREEN FROM Temp
DO Lib_MTEC with 3
RETURN

*************************************************************************** FIN
* Procedimiento de Listado por Impresora
******************************************************************************
PROCEDURE DOCLImpr
DIMENSION VQUIEBRE(1)
Nro_Cops = 1
VInicio  = .F.
UltTecla = 0
DO db_Print WITH Nro_Cops , VImpr , VTabla , VInicio
IF UltTecla = Escape
   RETURN
ENDIF
IniImp   = _Prn1    && 10   cpi
FinImp   = []
Largo    = 66
Ancho    = 80
MQuiebre = 1
VQuiebre(1) = [TipMov]
BEstat   = .T.
BEject   = .F.
BEncab   = .F.
Tit_SIzq = GsNomCia
Tit_IIzq = GsNomALm
Titulo   = []
SubTitulo= []
* Catalogo *****
*     ----------------------------------------------------------------------------------
En1    = GsSubAlm+ " " + TRIM(GsNomSub)
En2    = []
En3    = []
En4    = " "
En5    = "TABLA DE CORRELATIVOS"
En6    = "*********************************** **********"
En7    = "                                       Nro.   "
En8    = "       M O V I M I E N T O          Documento "
En9    = "*********************************** **********"
*          999 123456789-123456789-123456789-   000000
P1     = []
P2     = []
P3     = []
TstImp = [SubAlm = GsSubAlm]
PrgLin = [DoclQuie]
PrgFin = ""
TstLin = []
LinImp = [CodMov+' '+TMOV->DesMov+'   '+;
          RIGHT("000000"+LTRIM(STR(NroDoc)),6)]
DO DB_LIMPR
RETURN

*************************************************************************** FIN
* Procedimiento de Listado por Impresora ( Quiebres por Tpo. Mov. )
******************************************************************************
PROCEDURE DOCLQuie
NumLin = Prow() + 1
DO CASE
   CASE Nqui = 0
   CASE Nqui = 1 .AND. Inicio
       DO CASE
          CASE TipMov = "S"
             @ NumLin,17   SAY "SALIDAS"
          CASE TipMov = "I"
             @ NumLin,17   SAY "INGRESOS"
          CASE TipMov = "T"
             @ NumLin,17   SAY "TRANSFERENCIAS"
       ENDCASE
   CASE Nqui = 1 .AND. ! Inicio
       @ NumLin,17   SAY []
ENDCASE
RETURN
