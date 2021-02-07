**************************************************************************
*         .----------------------------------------------------.         *
*         |       Sistema de Cuentas por cobrar                |         *
*         |      Disponible para MS-DOS, XENIX System V        |         *
*         |             ---  Foxbase + V.2.1.1 ---             |         *
*         `----------------------------------------------------'         *
*                                                                        *
*  Nombre    : CcbCjAu1.PRG                                              *
*  Autor     : R.H.                                                      *
*  Objeto    : Canje por Letras en base a la PROFORMA                    *
*                                                                        *
*  Par metros:                                                           *
*                                                                        *
*  Creaci¢n     : 08/03/94                                               *
*  Actualizaci¢n: RHC 7/5/94 Archivo temporal de Trabajo                 *
*                 RHC 13/03/95 Generacion del asiento contable           *
**************************************************************************

DO xPanta
SAVE SCREEN TO LsScreen
**********************************
* Aperturando Archivos a usar    *
**********************************
SELECT 1
USE ccbntasg IN 1 ORDER TASG01 ALIAS TASG
IF !USED(1)
   CLOSE DATA
   RETURN
ENDIF
**
USE ccbmvtos IN 2 ORDER VTOS01 ALIAS VTOS
IF !USED(2)
   CLOSE DATA
   RETURN
ENDIF
**
USE ccbrgdoc IN 3 ORDER GDOC04 ALIAS GDOC
IF !USED(3)
   CLOSE DATA
   RETURN
ENDIF
**
USE ccbtbdoc IN 4 ORDER BDOC01 ALIAS TDOC
IF !USED(4)
   CLOSE DATA
   RETURN
ENDIF
**
USE cbdmauxi IN 5 ORDER AUXI01 ALIAS AUXI
IF !USED(5)
   CLOSE DATA
   RETURN
ENDIF
**
USE ccbnrasg IN 7 ORDER RASG01 ALIAS RASG
IF !USED(7)
   CLOSE DATA
   RETURN
ENDIF
** BASES DE CONTABILIDAD **
SELE 0
USE CBDMCTAS ORDER CTAS01 ALIAS CTAS
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 0
USE ADMMTCMB ORDER TCMB01 ALIAS TCMB
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
** RELACIONES A USAR **
SELE TASG
SET RELA TO XsClfAux+CodCli INTO AUXI
**********************************
* Inicializando Variables a usar *
**********************************
** variables de la cabecera **
SELECT TASG
m.coddoc = "CANJ"
m.nrodoc = SPACE(LEN(NroDoc))
m.fchdoc = DATE()
m.codcli = SPACE(LEN(CodCli))
m.glodoc = SPACE(LEN(GloDoc))
m.codmon = 1
m.tpocmb = 0.00
m.impdoc = 0
m.flgest = [P]
m.codref = [PROF]
m.nroref = SPACE(LEN(NroRef))
** variables de control de datos intermedios **
m.import  = 0.00     && importe de documentos
m.impdoc  = 0.00     && importe de letras (= importe del canje)
m.nrolet  = 0        && Cantidad de letras a generar
m.letini  = 0        && Nro. de letra de arranque
m.plazo   = 0        && Dias de vencimiento a partir de la fchdoc
m.crear   = .T.
** Datos del Browse de Documentos **
CIMAXELE = 200
DIMENSION AsCodRef(CIMAXELE)
DIMENSION AsNroRef(CIMAXELE)
DIMENSION AfImport(CIMAXELE)
GiTotDoc = 0
** Datos del Browse de Letras **
DIMENSION AsNroDoc(CIMAXELE)
DIMENSION AdFchDoc(CIMAXELE)
DIMENSION AdFchVto(CIMAXELE)
DIMENSION AfImpTot(CIMAXELE)
GiTotLet = 0
** Variables Contables a usar **
PRIVATE _MES,XsNroMes,XsNroAst,XsCodOpe
STORE [] TO _MES,XsNroMes,XsNroAst,XsCodOpe
XsCodOpe = [012]  && << OJO <<
** Logica Principal **
*************************************************
** OJO >> Solo de va a permitir CREAR y ANULAR **
*************************************************
GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] C¢digo [PgUp] [PgDn] [^PgUp] [^PgDn] Posicionar"
DO LIB_MTEC WITH 99
xCodDoc = m.CodDoc
DO EDITA WITH [xLlave],[xPoner],[xTomar],[xBorrar],'',;
              [CodDoc],XCodDoc,'CA'

CLOSE DATA
RETURN
************************************************************************ EOP()
* Pintado de Pantalla
***************************************************************************
PROCEDURE xPanta

*          1         2         3         4         5         6         7
*0123456789012345678901234567890123456789012345678901234567890123456789012345678
*1    Canje #      : 1234567890     Proforma : 1234567890    Fecha : 99/99/99
*2    Cod.Cliente  :
*3    Observaciones:
*4    Moneda       :                               Tipo Cambio : 99,999.9999
*5                  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*6                  ³ Tpo.Doc.   Nro.Documento          Importe  ³
*7                  ³--------------------------------------------³
*8                  ³  1234       12345678901     999,999,999.99 ³
*9                  ³                                            ³
*0                  ³                                            ³
*1                  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*2    ------------------------>  Importe Total :  999,999,999.99
*3                        Letra Inicial : 123456
*4                ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ--------ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*5                ³ No.Letra   Emision   Vencto.     Imp.Letra. ³
*6                ³---------------------------------------------³
*7                ³ 1234567890 99/99/99 99/99/99 999,999,999.99 ³
*8                ³                                             ³
*9                ³                                             ³
*0                ³                                             ³
*1                ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ--------ÄÄÙ
*2    ------------------------> Importe Total :  999,999,999.99
*          1         2         3         4         5         6         7
*0123456789012345678901234567890123456789012345678901234567890123456789012345678

CLEAR
Titulo = "** CANJE POR LETRAS EN BASE A LA PROFORMA **"
@  0,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
@  1,5  SAY "Canje #      :                Proforma :               Fecha :"
@  2,5  SAY "Cod.Cliente  :                                              "
@  3,5  SAY "Observaciones:                                              "
@  4,5  SAY "Moneda       :                               Tipo Cambio :  "
@  5,5  SAY "              ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@  6,5  SAY "              ³ Tpo.Doc.   Nro.Documento          Importe  ³"
@  7,5  SAY "              ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@  8,5  SAY "              ³                                            ³"
@  9,5  SAY "              ³                                            ³"
@ 10,5  SAY "              ³                                            ³"
@ 11,5  SAY "              ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
@ 12,5  SAY "------------------------>  Importe Total :                  "
@ 13,5  SAY "                    Letra Inicial :                         "
@ 14,5  SAY "            ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿ "
@ 15,5  SAY "            ³ No.Letra   Emision   Vencto.     Imp.Letra. ³ "
@ 16,5  SAY "            ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ "
@ 17,5  SAY "            ³                                             ³ "
@ 18,5  SAY "            ³                                             ³ "
@ 19,5  SAY "            ³                                             ³ "
@ 20,5  SAY "            ³                                             ³ "
@ 21,5  SAY "            ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ "
@ 22,5  SAY "------------------------> Importe Total :                   "

@  6,20 SAY " Tpo.Doc.   Nro.Documento          Importe  " COLOR SCHEME 7
@ 15,18 SAY " No.Letra   Emision   Vencto.     Imp.Letra. " COLOR SCHEME 7

RETURN
********************************************************************** FIN
* Llave de Acceso
******************************************************************************
PROCEDURE xLlave

* buscamos correlativo
IF !SEEK(m.coddoc,"TDOC")
   WAIT "No existe correlativo" NOWAIT WINDOW
   UltTecla = Escape
   RETURN
ENDIF
*m.nrodoc = RIGHT('000000'+ALLTRIM(STR(TDOC->nrodoc)),6)+;
*         SPACE(LEN(m.nrodoc)-6)
m.NroDoc = PADR(PADL(ALLTRIM(STR(TDOC->NroDoc)),6,'0'),LEN(TASG->NroDoc))
*
SELE TASG
m.crear  = .T.
UltTecla = 0
i = 1
DO WHILE !INLIST(UltTecla,Escape,Enter)
   DO CASE
      CASE i = 1
         @ 1,20 GET m.NroDoc PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = F8
            xCodDoc = m.CodDoc
            IF !ccbbusca("0013")
               LOOP
            ENDIF
            m.NroDoc = TASG->NroDoc
         ENDIF
   ENDCASE
   i = IIF(UltTecla=Arriba,i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>1,1,i)
ENDDO
SEEK m.CodDoc+m.Nrodoc
RETURN
************************************************************************ FIN *
* Poner Datos en Pantalla
******************************************************************************
PROCEDURE xPoner

@ 1,20 SAY NroDoc
@ 1,46 SAY NroRef
@ 1,68 SAY FchDoc
@ 2,20 SAY CodCli
@ 2,30 SAY AUXI->NomAux
@ 3,20 SAY GloDoc SIZE 1,40 PICT "@!"
@ 4,20 SAY IIF(CodMon=1,'S/.','US$')
@ 4,64 SAY TpoCmb PICT "99,999.9999"
** Pintamos el Browse de Documentos origen **
** Definimos variables a usar en el Browse **
PRIVATE SelLin,EdiLin,BrrLin,InsLin,GrbLin,EscLin
PRIVATE Consulta,Modifica,Adiciona,Db_Pinta
SelLin   = ""
EscLin   = ""
EdiLin   = ""
BrrLin   = ""
InsLin   = ""
GrbLin   = ""
Consulta = .F.    && valores iniciales
Modifica = .F.
Adiciona = .F.
Db_Pinta = .T.
*
PRIVATE MVprgF1,MVprgF2,MVprgF3,MVprgF4,MVprgF5,MVprgF6,MVprgF7,MVprgF8
PRIVATE MVprgF9,NClave,VClave,LinReg,Titulo,VTitle,HTitle
PRIVATE Yo,Xo,Largo,Ancho,TBorde
PRIVATE BBVerti,Static,VSombra,E1,E2,E3
MVprgF1  = ""
MVprgF2  = ""
MVprgF3  = ""
MVprgF4  = ""
MVprgF5  = ""
MVprgF6  = ""
MVprgF7  = ""
MVprgF8  = ""
MVprgF9  = ""
NClave   = "CodDoc+NroDoc"
VClave   = TASG->CodDoc+TASG->NroDoc
Titulo   = ""
VTitle   = 0
HTitle   = 0
Yo       = 7
Xo       = 19
Largo    = 5
Ancho    = 46
Tborde   = Nulo
BBverti  = .T.
Static   = .T.
VSombra  = .F.
E1 = ""
E2 = ""
E3 = ""
LinReg   = [' '+CodRef+'      '+NroRef+'     '+TRANS(Import,'999,999,999.99')]
** Revisamos de que base es **
IF TASG->FlgEst = [E]
   SELE VTOS
ELSE
   SELE RASG
ENDIF
DO dbrowse
** Pintamos el Browse de Documento Letras **
SELE GDOC
SET ORDER TO GDOC03
NClave   = "TpoRef+CodRef+NroRef+TpoDoc+CodDoc"
VClave   = "Canje"+TASG->CodDoc+TASG->NroDoc+"CARGO"+"LETR"
Yo       = 16
Xo       = 17
Largo    = 6
Ancho    = 47
LinReg   = [NroDoc+' '+DTOC(FchEmi)+' '+DTOC(FchVto)+' '+TRANS(ImpTot,'999,999,999.99')+' ']
Consulta = .F.    && valores iniciales
Modifica = .F.
Adiciona = .F.
Db_Pinta = .T.
DO dbrowse
SET ORDER TO GDOC04
SELE TASG

RETURN
************************************************************************ FIN *
* Inicializa valores de las variables
***************************************************************************
PROCEDURE xInvar

m.fchdoc = DATE()
m.codcli = SPACE(LEN(CodCli))
m.glodoc = SPACE(LEN(GloDoc))
m.codmon = 1
m.tpocmb = 0.00
m.impdoc = 0
m.flgest = 'P'
m.codref = [PROF]
m.nroref = SPACE(LEN(NroRef))
** variables de control de datos intermedios **
m.import  = 0.00     && importe de documentos
m.impdoc  = 0.00     && importe de letras (= importe del canje)
m.nrolet  = 0        && Cantidad de letras a generar
m.letini  = 0        && Nro. de letra de arranque
m.plazo   = 0        && Dias de vencimiento a partir de la fchdoc
m.crear   = .T.
** Datos del Browse de Documentos **
STORE SPACE(LEN(GDOC->coddoc)) TO AsCodRef
STORE SPACE(LEN(GDOC->nrodoc)) TO AsNroRef
STORE 0.00                        TO AfImport
GiTotDoc = 0
** Datos del Browse de Letras **
STORE SPACE(LEN(GDOC->nrodoc))    TO AsNroDoc
STORE CTOD(SPACE(10))              TO AdFchDoc
STORE CTOD(SPACE(10))              TO AdFchVto
STORE 0.00                        TO AfImpTot
GiTotLet = 0
* Variables Contables *
_MES     = 0
XsNroMes = SPACE(LEN(GDOC.NroMes))
XsNroAst = SPACE(LEN(GDOC.NroAst))
XsCodOpe = [012]  && << OJO <<

RETURN
************************************************************************ FIN *
* Editar Datos de Cabezera
***************************************************************************
PROCEDURE xTomar

** OJO >> Siempre es Crear **
SELE TASG
m.Crear  = .T.
DO xInvar
UltTecla = 0
i = 1
DO WHILE !INLIST(UltTecla,Escape)
   DO lib_mtec WITH 7
   DO CASE
      CASE i = 1
         SELE TASG
         SET ORDER TO TASG03
         @  1,46 GET m.NroRef PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape)
            i = i - 1
            LOOP
            SET ORDER TO TASG01
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(m.NroRef)
            IF !ccbbusca("0008")
               SET ORDER TO TASG01
               LOOP
            ENDIF
            m.NroRef = NroDoc
         ENDIF
         SEEK m.CodRef+[P]+m.NroRef
         IF !FOUND()
            GsMsgErr = [ Dato Invalido ]
            DO lib_merr WITH 99
            SET ORDER TO TASG01
            LOOP
         ENDIF
         IF FlgEst = [E]   && Ya asignado
            GsMsgErr = [ Proforma ya Genero Letras ]
            DO lib_merr WITH 99
            SET ORDER TO TASG01
            LOOP
         ENDIF
         ** cargamos informacion **
         m.CodCli = CodCli
         m.CodMon = CodMon
         m.TpoCmb = TpoCmb
         m.NroLet = CanLet
         m.Plazo  = DiaLet
         SET ORDER TO TASG01
         * * * *
         DO DOCbmove
         * * * *
         DO LETbmove
         ** pintamos detalle **
         @  1,46 SAY m.NroRef
         @  2,20 SAY m.CodCli+' '+AUXI->NomAux
         @  4,20 SAY IIF(m.CodMon=1,'S/.','US$')
         @  4,64 SAY m.TpoCmb PICT "99,999.9999"
         ** pintamos documentos **
         NumEle = 1
         FOR NumLin = 8 TO 10
            IF NumEle > GiTotDoc
               EXIT
            ENDIF
            DO DOCbline WITH NumEle,NumLin
            NumEle = NumEle + 1
         ENDFOR
         NumEle = 1
         FOR NumLin = 17 TO 20
            IF NumEle > GiTotLet
               EXIT
            ENDIF
            DO LETbline WITH NumEle,NumLin
            NumEle = NumEle + 1
         ENDFOR
         * * * * * * * * * * * * *
      CASE i = 2
         @  1,68 GET m.FchDoc
         READ
         UltTecla = LASTKEY()
      CASE i = 3
         @ 3,20 GET m.GloDoc PICT "@!S40"
         READ
         UltTecla = LASTKEY()
      CASE i = 4
         DO DOCBrows
      CASE i = 5
         =SEEK([LETR],[TDOC])
         m.LetIni = TDOC->NroDoc
         @ 13,41 GET m.LetIni PICT "999999"
         READ
         UltTecla = LASTKEY()
      CASE i = 6
         DO LetBrows    && Browse de Letras a Generar
      CASE i = 7
         ** preguntar grabacion **
         cResp = [S]
         cResp = Aviso(12,[ Datos Correctos (S/N) ? ],[],[],2,'SN',0,.F.,.F.,.T.)
         IF cResp = "N"
            UltTecla = 0
            i = 1
            LOOP
         ENDIF
         ** preguntar aprobacion de letras **
         cResp = [S]
         cResp = Aviso(12,[ Letras Aprobadas (S/N) ? ],[],[],2,'SN',0,.F.,.F.,.T.)
         IF cResp = "S"
            m.FlgEst = "E"    && Aprobado
            ** Rutina que apertura las base contables a usar y ademas **
            ** verifica que el mes contables NO este cerrado **
            IF !ctb_aper(m.FchDoc)
               i = 1
               UltTecla = 0
               LOOP
            ENDIF
         ENDIF
         UltTecla = Enter
   ENDCASE
   IF i = 7 .AND. UltTecla = Enter
      EXIT
   ENDIF
   i = IIF(UltTecla=Arriba,i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>7,7,i)
ENDDO
IF UltTecla # Escape
   DO xGraba
ENDIF
SELE TASG
UNLOCK ALL
RETURN
************************************************************************ FIN *
* Editar Datos en los Items (rutina de Browse)
***************************************************************************
PROCEDURE DocBrows

**
EscLin   = "Docbline"
EdiLin   = "Docbedit"
BrrLin   = "Docbborr"
InsLin   = "Docbinse"
PrgFin   = []
*
Yo       = 7
Xo       = 19
Largo    = 5
Ancho    = 46
Tborde   = Nulo
Titulo   = []
En1 = ""
En2 = ""
En3 = ""
MaxEle   = GiTotDoc
TotEle   = CIMAXELE
*
DO aBrowse
*
IF INLIST(UltTecla,Escape)
   UltTecla = Arriba
ENDIF
*
RETURN
************************************************************************ FIN *
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE DocBLine
PARAMETERS NumEle, NumLin
@ NumLin,22 SAY AsCodRef(NumEle)
@ NumLin,33 SAY AsNroRef(NumEle)
@ NumLin,49 SAY AfImport(NumEle) PICT "999,999,999.99"
RETURN
************************************************************************ FIN *
* Objeto : Edita una linea
******************************************************************************
PROCEDURE DocBEdit
PARAMETERS NumEle, NumLin

i        = 1
UltTecla = 0
*
LsCodRef = AsCodRef(NumEle)
LsNroRef = AsNroRef(NumEle)
LfImport = AfImport(NumEle)
m.sdodoc = 0   && Control del saldo
DO WHILE !INLIST(UltTecla,Escape)
   DO CASE
      CASE i = 1
         SELE TDOC
         @ NumLin,22 GET LsCodRef PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape)
            LOOP
         ENDIF
         IF UltTecla = F8
            IF !ccbbusca("TDOC")
               LOOP
            ENDIF
            LsCodRef = TDOC->CodDoc
         ENDIF
         @ NumLin,22 SAY LsCodRef
         SEEK LsCodRef
         IF !FOUND()
            GsMsgErr = [Documento no Existe]
            DO lib_merr WITH 99
            LOOP
         ENDIF
         IF TpoDoc # "CARGO"
            GsMsgErr = "No es un documento de CARGO"
            DO lib_merr WITH 99
            LOOP
         ENDIF

      CASE i = 2
         SELE GDOC
         @ NumLin,33 GET LsNroRef PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape,Arriba)
            i = i - 1
            LOOP
         ENDIF
         IF UltTecla = F8
            PRIVATE XsCodCli,XsTpoRef,XsCodRef
            XsCodCli = m.CodCli
            XsTpoRef = "CARGO"
            XsCodRef = LsCodRef
            IF !ccbbusca("ASIG")
               LOOP
            ENDIF
            LsNroRef = GDOC->NroDoc
         ENDIF
         @ NumLin,33 SAY LsNroRef
         SEEK m.codcli+"P"+"CARGO"+LsCodRef+LsNroRef
         IF !FOUND()
            DO lib_merr WITH 6
            LOOP
         ENDIF
         ** verificamos que no se repita **
         PRIVATE j
         j = 1
         DO WHILE j <= GiTotDoc
            IF j <> NumEle
               IF AsCodRef(j)+AsNroRef(j) = LsCodRef+LsNroRef
                  WAIT "Dato ya Registrado" NOWAIT WINDOW
                  LOOP
               ENDIF
            ENDIF
            j = j + 1
         ENDDO
         IF !RLOCK()
            LOOP
         ENDIF
         LfImport = GDOC->SdoDoc
         IF GDOC->CodMon # m.codmon
            IF GDOC->CodMon = 1
               LfImport = ROUND(LfImport/m.tpocmb,2)
            ELSE
               LfImport = ROUND(LfImport*m.tpocmb,2)
            ENDIF
         ENDIF
         m.sdodoc = LfImport

      CASE i = 3
         @ NumLin,49 GET LfImport PICT "999,999,999.99" VALID LfImport>0 .AND. LfImport <= m.sdodoc
         READ
         UltTecla = LASTKEY()
   ENDCASE
   IF i = 3 .AND. UltTecla = Enter
      EXIT
   ENDIF
   i = IIF(UltTecla=Arriba,i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>3,3,i)
ENDDO
IF UltTecla # Escape
   AsCodRef(NumEle) = LsCodRef
   AsNroRef(NumEle) = LsNroRef
   AfImport(NumEle) = LfImport
   DO DocRegen
ELSE
   UNLOCK IN GDOC
ENDIF
RETURN
************************************************************************ FIN *
* Objeto : Borra una linea
******************************************************************************
PROCEDURE DocbBorr
PARAMETERS ElePrv, Estado

PRIVATE i
i = ElePrv + 1

DO WHILE i <  GiTotDoc
   AsCodRef(i) = AsCodRef(i+1)
   AsNroRef(i) = AsNroRef(i+1)
   AfImport(i) = AfImport(i+1)
   i = i + 1
ENDDO
AsCodRef(i) = SPACE(LEN(GDOC->coddoc))
AsNroRef(i) = SPACE(LEN(GDOC->nrodoc))
AfImport(i) = 0.00
GiTotDoc = GiTotDoc - 1
Estado = .T.
DO DocRegen    && recalcula importe
RETURN
************************************************************************ FIN *
* Objeto : Carga informacion al arreglo
******************************************************************************
PROCEDURE DOCbmove

SELE GDOC
SET ORDER TO GDOC01
PRIVATE i
i = 1
SELE RASG
SEEK m.CodRef+m.NroRef+[CARGO]
DO WHILE CodDoc+NroDoc+TpoRef=m.CodRef+m.NroRef+[CARGO] .AND. i <= CIMAXELE
   IF CodRef = [LETR]
      SKIP
      LOOP
   ENDIF
   AsCodRef(i) = CodRef
   AsNroRef(i) = NroRef
   =SEEK(RASG->TpoRef+RASG->CodRef+RASG->NroRef,"GDOC")
   AfImport(i) = GDOC->SdoDoc
   IF m.CodMon # GDOC->CodMon
      IF m.CodMon = 1
         AfImport(i) = ROUND(GDOC->SdoDoc*m.TpoCmb,2)
      ELSE
         AfImport(i) = ROUND(GDOC->SdoDoc/m.TpoCmb,2)
      ENDIF
   ENDIF
   i = i + 1
   SKIP
ENDDO
GiTotDoc = i - 1
SELE GDOC
SET ORDER TO GDOC04
SELE RASG
DO DOCRegen

RETURN
************************************************************************ FIN *
* Objeto : Inserta una linea
******************************************************************************
PROCEDURE DocbInse

PARAMETERS ElePrv, Estado
PRIVATE i
i = GiTotDoc + 1
IF i > CIMAXELE
   Estado = .F.
   RETURN
ENDIF
DO WHILE i > ElePrv + 1
   AsCodRef(i) = AsCodRef(i-1)
   AsNroRef(i) = AsNroRef(i-1)
   AfImport(i) = AfImport(i-1)
   i = i - 1
ENDDO
i = ElePrv + 1
AsCodRef(i) = SPACE(LEN(GDOC->coddoc))
AsNroRef(i) = SPACE(LEN(GDOC->nrodoc))
AfImport(i) = 0.00
GiTotDoc = GiTotDoc + 1
Estado = .T.

RETURN
************************************************************************ FIN *
* Objeto : Recalcula Importes y saldos
******************************************************************************
PROCEDURE DocRegen

PRIVATE j
j = 1
STORE 0 TO m.import
DO WHILE j <= GiTotDoc
   m.import = m.import + AfImport(j)
   j = j + 1
ENDDO
@ 12,49 SAY m.import PICT "999,999,999.99"
RETURN
************************************************************************ FIN *
* Editar Datos en los Items (rutina de Browse)
***************************************************************************
PROCEDURE LetBrows

**
EscLin   = "Letbline"
EdiLin   = "Letbedit"
BrrLin   = "Letbborr"
InsLin   = "Letbinse"
PrgFin   = []
*
Yo       = 16
Xo       = 25
Largo    = 6
Ancho    = 40
Tborde   = Nulo
Titulo   = []
En1 = ""
En2 = ""
En3 = ""
MaxEle   = GiTotLet
TotEle   = CIMAXELE
*
DO LETbiniv
*
DO WHILE .T.
   DO aBrowse
   IF (UltTecla = Escape) .OR. (m.Import = m.ImpDoc)
      EXIT
   ELSE
      GsMsgErr = [ Los montos deben ser exactos ]
      DO lib_merr WITH 99
   ENDIF
ENDDO
*
IF INLIST(UltTecla,Escape)
   UltTecla = Arriba
ELSE
   UltTecla = Enter
ENDIF
*
RETURN
************************************************************************ FIN *
* Objeto : Carga informacion al arreglo
******************************************************************************
PROCEDURE LETbmove

**
PRIVATE i
i = 1
SELE RASG
SEEK m.CodRef+m.NroRef+[CARGO]
DO WHILE CodDoc+NroDoc+TpoRef=m.CodRef+m.NroRef+[CARGO] .AND. i <= CIMAXELE
   IF ! CodRef = [LETR]
      SKIP
      LOOP
   ENDIF
   AsNroDoc(i) = SPACE(LEN(VTOS->NroRef))
   AdFchDoc(i) = FchRef
   AdFchVto(i) = VtoRef
   AfImpTot(i) = ImpTot
   i = i + 1
   SKIP
ENDDO
GiTotLet = i - 1
DO LetRegen

RETURN
************************************************************************ FIN *
* Objeto : Carga los # de letras
******************************************************************************
PROCEDURE LETbiniv
**
PRIVATE i,m.NroLet
i = 1
m.NroLet = m.LetIni
FOR i = 1 TO GiTotLet
   AsNroDoc(i) = PADR(PADL(ALLTRIM(STR(m.NroLet)),6,'0'),LEN(GDOC->NroDoc))
   m.NroLet = m.NroLet + 1
   ** verificamos si existen letras en el archivo **
   SELECT GDOC
   SET ORDER TO GDOC01
   SEEK "CARGO"+"LETR"+TRIM(AsNroDoc(i))
   IF FOUND()
      GsMsgErr = [ERROR: Letra ]+AsNroDoc(i)+[ YA EXISTE]
      DO lib_merr WITH 99
      CLOSE DATA
      RETURN TO MASTER
   ENDIF
   SET ORDER TO GDOC04
ENDFOR

RETURN
************************************************************************ FIN *
* Objeto : Recalcula Importes y saldos
******************************************************************************
PROCEDURE LetRegen

PRIVATE j
j = 1
STORE 0 TO m.impdoc
DO WHILE j <= GiTotLet
   m.impdoc = m.impdoc + AfImpTot(j)
   j = j + 1
ENDDO
@ 22,49 SAY m.impdoc PICT "999,999,999.99"

RETURN
********************************************************************** FIN
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE LetBLine

PARAMETERS NumEle, NumLin
@ NumLin,19 SAY AsNroDoc(NumEle)
@ NumLin,30 SAY AdFchDoc(NumEle)
@ NumLin,39 SAY AdFchVto(NumEle)
@ NumLin,48 SAY AfImpTot(NumEle)            PICT "999,999,999.99"

RETURN
************************************************************************ FIN *

******************************************************************************
* Objeto : Edita una linea
******************************************************************************
PROCEDURE LetBEdit
PARAMETERS NumEle, NumLin

i        = 1
UltTecla = 0
*
LsNroDoc = AsNroDoc(NumEle)
LdFchVto = AdFchVto(NumEle)
LfImpTot = AfImpTot(NumEle)

@ NumLin,27 GET LsNroDoc PICT "@!" VALID _lsnrodoc()
READ
UltTecla = LASTKEY()
IF LASTKEY() # 27
   AsNroDoc(NumEle) = LsNroDoc
   AdFchVto(NumEle) = LdFchVto
   AfImpTot(NumEle) = LfImpTot
   DO LetRegen
ENDIF
RETURN

FUNCTION _lsnrodoc
******************
IF LASTKEY() = 27
   RETURN .T.
ENDIF
IF EMPTY(LsNroDoc)
   RETURN 0
ENDIF
**
SELECT GDOC
SET ORDER TO GDOC01
SEEK TRIM("CARGO"+"LETR"+LsNroDoc)
IF FOUND()
   SET ORDER TO GDOC04
   WAIT "Dato ya Registrado" NOWAIT WINDOW
   RETURN 0
ENDIF
SET ORDER TO GDOC04
RETURN .T.

************************************************************************ FIN *
* Objeto : Borra una linea
******************************************************************************
PROCEDURE LetbBorr
PARAMETERS ElePrv, Estado
Estado = .F.
RETURN
************************************************************************ FIN *
* Objeto : Inserta una linea
******************************************************************************
PROCEDURE LetbInse
PARAMETERS ElePrv, Estado
PRIVATE i
Estado = .F.
RETURN

************************************************************************ FIN *
* Procedimiento de Grabacion de informacion de Cabezera
******************************************************************************
PROCEDURE xGraba

**
WAIT "GRABANDO" NOWAIT WINDOW
** grabamos cabezera **
SELECT TDOC
SEEK m.coddoc
IF !RLOCK()
   RETURN
ENDIF
**
SELECT TASG
SEEK m.CodRef+m.NroRef
IF ! RLOCK()
   RETURN
ENDIF
APPEND BLANK
IF !RLOCK()
   RETURN
ENDIF
**
SELECT TDOC
IF VAL(m.nrodoc)>= NroDoc
   REPLACE NroDoc WITH VAL(m.nrodoc)+1
ENDIF
UNLOCK
**
SELECT TASG
REPLACE CodDoc WITH m.coddoc
REPLACE NroDoc WITH m.nrodoc
REPLACE FchDoc WITH m.fchdoc
REPLACE CodCli WITH m.codcli
REPLACE GloDoc WITH m.glodoc
REPLACE CodMon WITH m.codmon
REPLACE TpoCmb WITH m.tpocmb
REPLACE ImpDoc WITH m.impdoc
REPLACE FlgEst WITH m.flgest
* * * *
REPLACE CodRef WITH m.CodRef
REPLACE NroRef WITH m.NroRef
** generamos detalles **
j = 1
DO WHILE j <= GiTotDoc
   Do CjLActDoc WITH AsCodRef(j),AsNroRef(j),AfImport(j)
   j = j + 1
ENDDO
**
j = 1
DO WHILE j <= GiTotLet
   LsNroDoc = AsNroDoc(j)
   LdFchDoc = AdFchDoc(j)
   LdFchVto = AdFchVto(j)
   LfImpTot = AfImpTot(j)
   Do CjLActLet
   j = j + 1
ENDDO
** ACTUALIZACION CONTABLE **
IF TASG.FlgEst = [E]
   DO xACT_CTB IN ccbcjap1
ENDIF
* * * * * * * * * * * * * * *
SELE TASG
IF TASG->FlgEst = [E]
   SEEK m.CodRef+m.NroRef
   REPLACE FlgEst WITH [E]
ENDIF

RETURN
************************************************************************** FIN
* Cancelando Documentos
***************************************************************************
PROCEDURE CjLActDoc
PARAMETER cCodDoc,cNroDoc,nImpTot

PRIVATE LfImpDoc
SELECT GDOC
SEEK m.codcli+"P"+"CARGO"+cCodDoc+cNroDoc
IF !RLOCK()
   RETURN
ENDIF
************************************************************************
** SI ESTA APROBADO SE GRABA EN VTOS, SI NO LO ESTA, SE GRABA EN RASG **
************************************************************************
IF TASG->FlgEst = [E]
   SELECT VTOS
   APPEND BLANK
   IF ! RLOCK()
      RETURN
   ENDIF
ELSE
   SELECT RASG
   APPEND BLANK
   IF ! RLOCK()
      RETURN
   ENDIF
ENDIF
LsAlias = ALIAS()
******************************************************
* SOLO ACTUALIZAMOS SALDOS SI EL CANJE ESTA APROBADO *
******************************************************
IF TASG->FlgEst = "E"   && Canje Aprobado
   ** actualizamos documento origen **
   SELECT GDOC
   LfImpDoc = nImpTot
   IF CodMon <> m.codmon
      IF m.codmon = 1
         LfImpDoc = nImpTot / m.tpocmb
      ELSE
         LfImpDoc = nImpTot * m.tpocmb
      ENDIF
   ENDIF
   REPLACE SdoDoc WITH SdoDoc - LfImpDoc
   IF SdoDoc <= 0.01
      REPLACE FlgEst WITH 'C'
      REPLACE FchAct WITH m.fchdoc
   ELSE
      REPLACE FlgEst WITH 'P'
   ENDIF
   REPLACE FchAct WITH DATE()
   REPLACE FlgSit WITH 'X'
   UNLOCK
ENDIF
***** Actualiza el movimiento realizado ****
SELECT (LsAlias)
REPLACE CodDoc WITH m.coddoc
REPLACE NroDoc WITH m.nrodoc
REPLACE TpoDoc WITH "Canje"
REPLACE FchDoc WITH m.fchdoc
REPLACE CodCli WITH m.codcli
REPLACE CodMon WITH m.codmon
REPLACE TpoCmb WITH m.tpocmb
REPLACE TpoRef WITH [CARGO]
REPLACE CodRef WITH cCodDoc
REPLACE NroRef WITH cNroDoc
REPLACE Import WITH nImpTot
UNLOCK

RETURN
************************************************************************** FIN
* Grabando Letras
***************************************************************************
PROCEDURE CjLActLet

SELECT TDOC
SEEK [LETR]
DO WHILE !RLOCK()
ENDDO
SELECT GDOC
APPEND BLANK
IF !RLOCK()
   RETURN
ENDIF
REPLACE CodDoc WITH "LETR"
REPLACE NroDoc WITH LsNroDoc
REPLACE TpoDoc WITH "CARGO"
REPLACE FchEmi WITH LdFchDoc
REPLACE FchDoc WITH m.FchDoc     && Con la Fecha del Canje
REPLACE CodCli WITH m.codcli
REPLACE CodMon WITH m.codmon
REPLACE TpoCmb WITH m.tpocmb
REPLACE ImpNet WITH LfImpTot
REPLACE ImpTot WITH LfImpTot
REPLACE FchVto WITH LdFchVto
REPLACE SdoDoc WITH LfImpTot
REPLACE TpoRef WITH 'Canje'
REPLACE CodRef WITH m.coddoc
REPLACE NroRef WITH m.nrodoc
REPLACE FlgEst WITH 'T'    && Tramite de Aprobacion
REPLACE FlgUbc WITH 'C'
** actualizamos control correlativo **
SELE TDOC
IF VAL(LsNroDoc)>=NroDoc
   REPLACE NroDoc WITH VAL(LsNroDoc)+1
ENDIF
******************************************************
* SOLO ACTUALIZAMOS SALDOS SI EL CANJE ESTA APROBADO *
******************************************************
IF TASG->FlgEst = "E"   && Canje Aprobado
   SELE GDOC
   REPLACE FlgEst WITH 'P'    && Pendiente de Pago
ENDIF
RETURN
************************************************************************** FIN
* Borrando Informacion
***************************************************************************
PROCEDURE xBorrar

IF TASG.FlgCtb
   IF !ctb_aper(TASG.FchDoc)
      SELE TASG
      UNLOCK ALL
      RETURN
   ENDIF
ENDIF
** Verificamos si alguna LETRA presenta problemas al anularla **
OK = .T.
SELECT GDOC
SET ORDER TO GDOC03
SEEK "Canje"+TASG->CodDoc+TASG->NroDoc+"CARGO"+"LETR"
SCAN WHILE TpoRef+CodRef+NroRef+TpoDoc+CodDoc = "Canje"+TASG->CodDoc+TASG->NroDoc+"CARGO"+"LETR"
   IF FlgEst # [T]   && Letras fuera de transito
      IF ! (FlgEst=[P] .AND. ImpTot=SdoDoc)
         GsMsgErr = [La Letra : ]+NroDoc+[ NO puede ser anulada]
         DO lib_merr WITH 99
         OK = .F.
         EXIT
      ENDIF
   ENDIF
ENDSCAN
SET ORDER TO GDOC04
IF !OK
   RETURN
ENDIF
** FIN DE VERIFICACION DE CONSISTENCIA DE LETRAS **
WAIT "BORRANDO" NOWAIT WINDOW
** grabamos cabecera **
SELE TASG
IF !RLOCK()
   UNLOCK ALL
   RETURN
ENDIF
STORE RECNO() TO iNumReg
m.CodRef = CodRef
m.NroRef = NroRef
SEEK m.CodRef+m.NroRef
IF !RLOCK()
   UNLOCK ALL
   RETURN
ENDIF
*
GO iNumReg
** DIVIDIMOS LA ANULACION DE ACUERDO A SI HA SIDO APROBADO O NO LOS DOCUMENTOS **
IF TASG->FlgEst = [P]   && Aun no estan aprobadas
   SELECT RASG
   SEEK TASG->coddoc+TASG->nrodoc
   DO WHILE CodDoc+NroDoc = TASG->coddoc+TASG->nrodoc .AND. !EOF()
      IF !RLOCK()
         LOOP
      ENDIF
      DELETE
      UNLOCK
      SKIP
   ENDDO
ELSE
   SELECT VTOS
   SEEK TASG->coddoc+TASG->nrodoc
   DO WHILE CodDoc+NroDoc = TASG->coddoc+TASG->nrodoc .AND. ! EOF()
      IF !RLOCK()
         LOOP
      ENDIF
      SELECT GDOC
      SET ORDER TO GDOC01
      SEEK "CARGO"+VTOS->codref+VTOS->nroref
      IF !RLOCK()
         SELE VTOS
         LOOP
      ENDIF
      LfImpDoc = VTOS->Import
      IF CodMon <> TASG->codmon
         IF TASG->codmon = 1
            LfImpDoc = LfImpDoc / TASG->tpocmb
         ELSE
            LfImpDoc = LfImpDoc * TASG->tpocmb
         ENDIF
      ENDIF
      REPLACE SdoDoc WITH SdoDoc + LfImpDoc
      IF SdoDoc <= 0.01
         REPLACE FlgEst WITH 'C'
      ELSE
         REPLACE FlgEst WITH 'P'
      ENDIF
      REPLACE FlgSit WITH ' '
      UNLOCK
      SELECT GDOC
      SET ORDER TO GDOC04
      * * * *
      SELECT VTOS
      DELETE
      UNLOCK
      SKIP
   ENDDO
ENDIF
**
SELECT GDOC
SET ORDER TO GDOC03
SEEK "Canje"+TASG->CodDoc+TASG->NroDoc+"CARGO"+"LETR"
DO WHILE TpoRef+CodRef+NroRef+TpoDoc+CodDoc = ;
         "Canje"+TASG->CodDoc+TASG->NroDoc+"CARGO"+"LETR"
   ** borramos informacion **
   IF ! RLOCK()
      LOOP
   ENDIF
   SELECT GDOC
   DELETE
   UNLOCK
   SKIP
ENDDO
SET ORDER TO GDOC04
SELE TASG
IF TASG->FlgEst = [E]
   SEEK m.CodRef+m.NroRef
   REPLACE FlgEst WITH [P]
ENDIF
SELE TASG
GO iNumReg
** ANULACION DEL ASIENTO CONTABLE **
IF TASG.FlgCtb
   DO xANUL_CTB IN ccbcjlt1
ENDIF
**
SELE TASG
REPLACE FlgEst WITH [A]
REPLACE ImpDoc WITH 0
UNLOCK ALL

RETURN
*********************************************************************** FIN() *
