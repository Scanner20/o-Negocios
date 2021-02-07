*************************************************************************
*  Nombre    : CcbLtrRn.PRG
*  Autor     : R.H.
*  Objeto    : Renovaci¢n de Letra
*  Par metros: Ninguno
*  Creaci¢n  : 06/05/94
*  Actualizaci¢n: Eduardo Tapia Castillo  ( 7/7/94 )
*************************************************************************

DO xPanta
SAVE SCREEN TO LsScreen
**********************************
* Aperturando Archivos a usar    *
**********************************
SELECT 0
USE ccbntasg ORDER TASG01 ALIAS TASG
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
**
USE ccbmvtos IN 0 ORDER VTOS01 ALIAS VTOS
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
**
USE ccbrgdoc IN 0 ORDER GDOC04 ALIAS GDOC
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
**
USE ccbtbdoc IN 0 ORDER BDOC01 ALIAS TDOC
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
**
USE cbdmauxi IN 0 ORDER AUXI01 ALIAS CLIE
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
SELE 0
USE admmtcmb ORDER TCMB01 ALIAS TCMB
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
*
SELE 0
USE CBDMCTAS ORDER CTAS01 ALIAS CTAS
IF !USED()
	CLOSE DATA
	RETURN
ENDIF
** RELACIONES A USAR **
SELE TASG
SET RELA TO XsClfAux+CodCli INTO CLIE
**********************************
* Inicializando Variables a usar *
**********************************
** variables de la cabecera **
XSCODOPE=[012]
SELECT TASG
m.coddoc = "RENV"
m.nrodoc = SPACE(LEN(NroDoc))
m.fchdoc = DATE()
m.codcli = SPACE(LEN(CodCli))
m.glodoc = SPACE(LEN(GloDoc))
m.codmon = 1
m.tpocmb = 0.00
m.flgest = [E]       && Emitido
** variables de control de datos intermedios **
m.impdoc  = 0.00     && importe de letras (= importe del canje)
m.canlet  = 0        && Cantidad de letras a generar
m.TipInt  = [P]      && [P]orcentaje o [I]mporte
m.PorInt  = 0.00
m.DiaLet  = 0        && Dias de vencimiento a partir de la fchdoc
m.SdoDoc  = 0
m.ImpCup  = 0
m.crear   = .T.
** datos del detalle de renovacion **
m.tporef  = [CARGO]
m.codref  = [LETR]
m.nroref  = SPACE(LEN(GDOC->NroDoc))
m.import  = 0.00     && Importe de Amortizacion
m.CodCta  = SPACE(LEN(GDOC->CodCta))
m.CodBco  = SPACE(LEN(GDOC->CodBco))
m.NroCta  = SPACE(LEN(GDOC->NroCta))
m.FchUbc  = CTOD(SPACE(10))
m.FlgUbc  = SPACE(LEN(GDOC->FlgUbc))
m.FlgSit =  SPACE(LEN(GDOC->FlgSit))
** Datos del Browse de Letras **
CIMAXELE = 200
DIMENSION AsNroDoc(CIMAXELE)
DIMENSION AdFchDoc(CIMAXELE)
DIMENSION AdFchVto(CIMAXELE)
DIMENSION AfImpTot(CIMAXELE)
DIMENSION AiNumReg(CIMAXELE)  && Nuevo
GiTotLet = 0
**  valores iniciales
XlFchUbc =' '
XlFlgSit =' '
XsCodCta =spac(5)


** Logica Principal **
*************************************************
** OJO >> Solo de va a permitir CREAR y ANULAR **
*************************************************
GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] C¢digo [PgUp] [PgDn] [^PgUp] [^PgDn] Posicionar"
DO LIB_MTEC WITH 99
cCodDoc = m.CodDoc
DO EDITA WITH [xLlave],[xPoner],[xTomar],[xBorrar],'',;
              [CodDoc],cCodDoc,'CA'
CLOSE DATA

RETURN
************************************************************************ EOP()
* Pintado de Pantalla
***************************************************************************
PROCEDURE xPanta

*           1         2         3         4         5         6         7
*00123456789012345678901234567890123456789012345678901234567890123456789012345678
*0ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*1³    Renovacion # :                                     Fecha : 99/99/9999    ³
*2³    Cod.Cliente  :                                                           ³
*3³    Observaciones:                                                           ³
*4³    Moneda       :                              Tipo Cambio : 99,999.9999    ³
*5ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*6³ Letra a Renovar : 1234567890              Fecha de Emision : 99/99/9999     ³
*7³                                           Fecha de Vencto. : 99/99/9999     ³
*8³                                                                             ³
*9³                                          Saldo de la Letra : 999,999,999.99 ³
*0³ Amortizar en Porcentaje : 999.99 %  Importe de Amortizacion:(999,999,999.99)³
*1³                                                             ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ³
*2³                                          Saldo a Financiar : 999,999,999.99 ³
*3³                                                                             ³
*4³                            ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*5³Cantidad de Letras: 123     ³ No.Letra    Emision    Vencto.     Imp.Letra.  ³
*6³Plazo de Vencto.  : 123 diasÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*7³                            ³ 1234567890 99/99/9999 99/99/9999 999,999,999.99³
*8³                            ³                                                ³
*9³                            ³                                                ³
*0³                            ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*1³                                                  ³     Total  999,999,999.99³
*2ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*           1         2         3         4         5         6         7
*00123456789012345678901234567890123456789012345678901234567890123456789012345678


CLEAR
Titulo = "** RENOVACION DE LETRAS **"
@  0,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
@  0,0  SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@  1,0  SAY "³    Renovacion # :                                    Fecha :                ³"
@  2,0  SAY "³    Cod.Cliente  :                                                           ³"
@  3,0  SAY "³    Observaciones:                                                           ³"
@  4,0  SAY "³    Moneda       :                              Tipo Cambio :                ³"
@  5,0  SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@  6,0  SAY "³ Letra a Renovar :                         Fecha de Emision :                ³"
@  7,0  SAY "³                                           Fecha de Vencto. :                ³"
@  8,0  SAY "³                                                                             ³"
@  9,0  SAY "³                                          Saldo de la Letra :                ³"
@ 10,0  SAY "³ Amortizar en Porcentaje :        %  Importe de Amortizacion:                ³"
@ 11,0  SAY "³                                                             ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ³"
@ 12,0  SAY "³                                          Saldo a Financiar :                ³"
@ 13,0  SAY "³                                                                             ³"
@ 14,0  SAY "³                            ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 15,0  SAY "³Cantidad de Letras:         ³ No.Letra   Emision   Vencto.     Imp.Letra.    ³"
@ 16,0  SAY "³Plazo de Vencto.  :     diasÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 17,0  SAY "³                            ³                                                ³"
@ 18,0  SAY "³                            ³                                                ³"
@ 19,0  SAY "³                            ³                                                ³"
@ 20,0  SAY "³                            ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 21,0  SAY "³                                                  ³ Total                    ³"
@ 22,0  SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"

@ 15,31 SAY " No.Letra    Emision    Vencto.     Imp.Letra. " COLOR SCHEME 7

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
*           SPACE(LEN(m.nrodoc)-6)
m.NroDoc = PADR(PADL(ALLTRIM(STR(TDOC->NroDoc)),6,'0'),LEN(m.NroDoc))
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
            IF !ccbbusca("0002")
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
@ 1,63 SAY FchDoc
@ 2,20 SAY CodCli+' '+CLIE->NomAux
@ 3,20 SAY GloDoc SIZE 1,40 PICT "@!"
@ 4,20 SAY IIF(CodMon=1,'S/.','US$')
@ 4,63 SAY TpoCmb PICT "99,999.9999"
** pintamos detalle de la renovacion **
=SEEK(TASG->CodDoc+TASG->NroDoc,"VTOS")
SET ORDER TO GDOC01 IN "GDOC"
=SEEK(VTOS->TpoRef+VTOS->CodRef+VTOS->NroRef,"GDOC")
@  6,20 SAY VTOS->NroRef
@  6,63 SAY GDOC->FchDoc
@  7,63 SAY GDOC->FchVto
@  9,63 SAY VTOS->Import+ImpCup PICT "999,999,999.99"
@ 10,62 SAY -1*ImpCup           PICT "@( 999,999,999.99"
@ 12,63 SAY VTOS->Import        PICT "999,999,999.99"
@ 10,28 SAY IIF(TipInt=[P],PorInt,0) PICT "999.99"
@ 15,21 SAY CanLet PICT "999"
@ 16,21 SAY DiaLet PICT "999"
@ 21,64 SAY ImpDoc PICT "999,999,999.99"
** Pintamos el Browse de Documento Letras **
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
NClave   = "TpoRef+CodRef+NroRef+TpoDoc+CodDoc"
VClave   = "Renov"+TASG->CodDoc+TASG->NroDoc+"CARGO"+"LETR"
Titulo   = ""
VTitle   = 0
HTitle   = 0
Yo       = 16
Xo       = 29
Largo    = 5
Ancho    = 50
Tborde   = Nulo
BBverti  = .T.
Static   = .T.
VSombra  = .F.
E1 = ""
E2 = ""
E3 = ""
LinReg   = [NroDoc+' '+DTOC(FchEmi)+' '+DTOC(FchVto)+' '+TRANS(ImpTot,'999,999,999.99')]
Consulta = .F.    && valores iniciales
Modifica = .F.
Adiciona = .F.
Db_Pinta = .T.
SELE GDOC
SET ORDER TO GDOC03
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
m.flgest = [E]
** variables de control de datos intermedios **
m.impdoc  = 0.00     && importe de letras (= importe del canje)
m.canlet  = 0        && Cantidad de letras a generar
m.TipInt  = [P]      && [P]orcentaje o [I]mporte
m.PorInt  = 0.00
m.DiaLet  = 0        && Dias de vencimiento a partir de la fchdoc
m.SdoDoc  = 0
m.ImpCup  = 0
m.crear   = .T.
m.CodCta  = SPACE(LEN(GDOC->CodCta))
m.CodBco  = SPACE(LEN(GDOC->CodBco))
m.NroCta  = SPACE(LEN(GDOC->NroCta))
m.FchUbc  = CTOD(SPACE(10))
m.FlgUbc  = SPACE(LEN(GDOC->FlgUbc))
** datos del detalle de renovacion **
m.tporef  = [CARGO]
m.codref  = [LETR]
m.nroref  = SPACE(LEN(GDOC->NroDoc))
m.import  = 0.00     && Importe de Amortizacion
** Datos del Browse de Letras **
STORE SPACE(LEN(GDOC->nrodoc))    TO AsNroDoc
STORE CTOD(SPACE(10))              TO AdFchDoc
STORE CTOD(SPACE(10))              TO AdFchVto
STORE 0.00                        TO AfImpTot
STORE 0                           TO AiNumReg
GiTotLet = 0

RETURN
************************************************************************ FIN *
* Editar Datos de Cabecera
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
         @  1,63 GET m.FchDoc
         READ
         UltTecla = LASTKEY()
      CASE i = 2
         SELE CLIE
         @ 2,20 GET m.CodCli PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape,Arriba)
            i = i - 1
            LOOP
         ENDIF
         IF UltTecla = F8
            IF !ccbbusca("CLIE")
               LOOP
            ENDIF
            m.CodCli = CLIE->CodAux
         ENDIF
         @ 2,20 SAY m.CodCli
         SEEK XsClfAux+m.CodCli
         IF !FOUND()
            GsMsgErr = [ Cliente no Registrado ]
            DO lib_merr WITH 99
            LOOP
         ENDIF
         @ 2,20 SAY m.CodCli+' '+CLIE->NomAux
      CASE i = 3
         @ 3,20 GET m.GloDoc PICT "@!S40"
         READ
         UltTecla = LASTKEY()
      CASE i = 4
         DO LIB_MTEC WITH 16
         VecOpc(1)="S/."
         VecOpc(2)="US$"
         m.CodMon= Elige(m.CodMon,4,20,2)
      CASE i = 5
         IF SEEK(DTOS(m.FchDoc),"TCMB")
            m.TpoCmb = TCMB->OfiVta
         ENDIF
         @ 4,63 GET m.TpoCmb PICT "99,999.9999" VALID m.tpocmb>0
         READ
         UltTecla = LASTKEY()
      * * * * * * * *
      CASE i = 6
         SELE GDOC
         @ 6,20 GET m.NroRef PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Escape,Arriba)
            i = i - 1
            LOOP
         ENDIF
         IF UltTecla = F8
            IF !ccbbusca("0010")
               LOOP
            ENDIF
            m.NroRef = GDOC->NroDoc
         ENDIF
         SEEK m.CodCli+[P]+m.TpoRef+m.CodRef+m.NroRef
         IF ! FOUND()
            DO lib_merr WITH 6
            LOOP
         ENDIF
         @ 6,20 SAY m.NroRef
         @ 6,63 SAY GDOC->FchDoc
         @ 7,63 SAY GDOC->FchVto
         IF GDOC->CodMon # m.CodMon
            cResp = [S]
            cResp = Aviso(18,[Letra no corresponde a la moneda de renovacion],;
                    [Continuamos (S-N)?],[],3,'SN',0,.F.,.F.,.T.)
            IF cResp = [N]
               UltTecla = 0
               LOOP
            ENDIF
         ENDIF
         m.SdoDoc = GDOC->SdoDoc
         IF m.CodMon # GDOC->CodMon
            IF m.CodMon = 1
               m.SdoDoc = ROUND(GDOC->SdoDoc*m.TpoCmb,2)
            ELSE
               m.SdoDoc = ROUND(GDOC->SdoDoc/m.TpoCmb,2)
            ENDIF
         ENDIF
         @ 9,63 SAY m.SdoDoc PICT "999,999,999.99"
         ** Dato adicionales **
         m.CodCta = CodCta
         m.CodBco = CodBco
         m.NroCta = NroCta
         m.FchUbc = FchUbc
         m.FlgUbc = FlgUbc
         m.FlgSit = FlgSit     && modificaci¢n

         ** Valores iniciales de la letra **

         XlFlgUbc = FlgUbc            && lalo
         XlFlgSit = FlgSit
         XsCodCta = CodCta

      CASE i = 7
         DO LIB_MTEC WITH 16
         VecOpc(1)="Porcentaje"
         VecOpc(2)="Importe"
         m.TipInt= Elige(m.TipInt,10,15,2)
      CASE i = 8 .AND. m.TipInt = [P]   && Porcentaje
         @ 10,28 GET m.PorInt PICT "999.99" RANGE 0,
         READ
         UltTecla = LASTKEY()
         @ 10,28 SAY m.PorInt PICT "999.99"
      CASE i = 9 .AND. m.TipInt = [P]
         m.ImpCup = ROUND(m.SdoDoc*m.PorInt/100,2)
         @ 10,62 SAY -1*m.ImpCup PICT "@( 999,999,999.99"
      CASE i = 9 .AND. m.TipInt = [I]
         m.PorInt = 0
         @ 10,28 SAY m.PorInt PICT "999.99"
         @ 10,63 GET m.ImpCup PICT "999,999,999.99" VALID(m.ImpCup>=0)
         READ
         UltTecla = LASTKEY()
         @ 10,62 SAY -1*m.ImpCup PICT "@( 999,999,999.99"
      CASE i = 10
         m.Import = m.SdoDoc-m.ImpCup
         @ 12,63 SAY m.Import PICT "999,999,999.99"
         @ 15,21 GET m.CanLet PICT "999" RANGE 0,
         READ
         UltTecla = LASTKEY()
      CASE i = 11
         @ 16,21 GET m.DiaLet PICT "999" RANGE 0,
         READ
         UltTecla = LASTKEY()
      CASE i = 12
         DO LetBrows    && Browse de Letras a Generar
   ENDCASE
   IF i = 12 .AND. UltTecla = Enter
      EXIT
   ENDIF
   i = IIF(UltTecla=Arriba,i-1,i+1)
   i = IIF(i<1 , 1,i)
   i = IIF(i>12,12,i)
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
PROCEDURE LetBrows

LiMaxEle = m.canlet
**
EscLin   = "Letbline"
EdiLin   = "Letbedit"
BrrLin   = "Letbborr"
InsLin   = "Letbinse"
PrgFin   = []
*
Yo       = 16
Xo       = 32
Largo    = 5
Ancho    = 47
Tborde   = Nulo
Titulo   = []
En1 = ""
En2 = ""
En3 = ""
DO Letbiniv    && Inicializa el arreglo
IF GiTotLet = 0
   GsMsgErr = [No se puede cargar informacion]
   DO lib_merr WITH 99
   UltTecla = Arriba
   RETURN
ENDIF
GiTotItm = GiTotLet
MaxEle   = GiTotItm
TotEle   = CIMAXELE
*
DO WHILE .t.
   DO aBrowse
   IF INLIST(UltTecla,Escape) .OR. (m.ImpDoc = m.Import)
      EXIT
   ELSE
      GsMsgErr = [ Los montos deben ser exactos ]
      DO lib_merr WITH 99
   ENDIF
ENDDO
*
GiTotLet = GiTotItm
*
IF INLIST(UltTecla,Escape)
   UltTecla = Arriba
ELSE
   UltTecla = Enter
ENDIF
*
RETURN
************************************************************************ FIN *
* Objeto : Inicializar el arreglo
******************************************************************************
PROCEDURE Letbiniv

=SEEK(m.CodCli+[P]+m.TpoRef+m.CodRef+m.NroRef,"GDOC")
**
PRIVATE i
i = 1
LfImpRef    = ROUND(m.import/m.canlet,2)
LfSdoDoc    = m.import
LdFchDoc    = GDOC->FchVto    && Parte del Vencimiento
LiNroCor    = 1   && por default
** verificamos cual fue el ultimo correlativo **
SELECT GDOC
SET ORDER TO GDOC01
SEEK m.TpoRef+m.CodRef+LEFT(TRIM(m.NroRef),6)
SCAN WHILE TpoDoc+CodDoc+LEFT(NroDoc,6)=m.TpoRef+m.CodRef+LEFT(TRIM(m.NroRef),6)
   IF AT('-',NroDoc)>0
      LiNroCor = VAL(SUBSTR(NroDoc,RAT('-',NroDoc)+1))+1
   ENDIF
ENDSCAN
SET ORDER TO GDOC04
************************************************
XiVtoAct=0
FOR i = 1 TO LiMaxEle
	XiVtoAct=XiVtoAct + m.Dialet
   AsNroDoc(i) = PADR(LEFT(m.NroRef,7)+'-'+LTRIM(STR(LiNroCor)),LEN(GDOC->NroDoc))
   AiNumReg(i) = 0
   AdFchDoc(i) = LdFchDoc
   AdFchVto(i) = LdFchDoc + XiVtoAct
   AfImpTot(i) = LfImpRef
   LfSdoDoc    = LfSdoDoc - LfImpRef
   LiNroCor    = LiNroCor+ 1
ENDFOR
GiTotLet = i - 1
GiTotItm = GiTotLet
IF LfSdoDoc <> 0
   AfImpTot(1) = AfImpTot(1) + LfSdoDoc
ENDIF
DO LetRegen
RETURN

************************************************************************ FIN *
* Objeto : Recalcula Importes y saldos
******************************************************************************
PROCEDURE LetRegen

PRIVATE j
j = 1
STORE 0 TO m.impdoc
DO WHILE j <= GiTotItm
   m.impdoc = m.impdoc + AfImpTot(j)
   j = j + 1
ENDDO
@ 21,64 SAY m.impdoc PICT "999,999,999.99"

RETURN
********************************************************************** FIN
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE LetBLine

PARAMETERS NumEle, NumLin
@ NumLin,31 SAY AsNroDoc(NumEle)
@ NumLin,42 SAY AdFchDoc(NumEle)
@ NumLin,53 SAY AdFchVto(NumEle)
@ NumLin,64 SAY AfImpTot(NumEle)            PICT "999,999,999.99"

RETURN
************************************************************************ FIN *

******************************************************************************
* Objeto : Edita una linea
******************************************************************************
PROCEDURE LetBEdit
PARAMETERS NumEle, NumLin

** NO se puede modificar si la letra YA EXISTIA antes del canje **
IF AiNumReg(NumEle)>0
   GsMsgErr = [Letra no puede ser modificada]
   DO lib_merr WITH 99
   UltTecla = Arriba
   RETURN
ENDIF
******************************************************************
i        = 1
UltTecla = 0
*
LsNroDoc = AsNroDoc(NumEle)
LdFchDoc = AdFchDoc(NumEle)
LdFchVto = AdFchVto(NumEle)
LfImpTot = AfImpTot(NumEle)

@ NumLin,31 GET LsNroDoc PICT "@!" VALID _lsnrodoc()
@ NumLin,42 GET LdFchDoc
@ NumLin,53 GET LdFchVto
@ NumLin,64 GET LfImpTot PICT "999,999,999.99" VALID LfImpTot>0
READ
UltTecla = LASTKEY()
IF LASTKEY() # Escape
   AsNroDoc(NumEle) = LsNroDoc
   AdFchDoc(NumEle) = LdFchDoc
   AdFchVto(NumEle) = LdFchVto
   AfImpTot(NumEle) = LfImpTot
   DO LetRegen
ENDIF
RETURN

FUNCTION _lsnrodoc
******************
IF LASTKEY() = Escape
   RETURN .T.
ENDIF
IF EMPTY(LsNroDoc)
   RETURN 0
ENDIF
**
SELECT GDOC
SET ORDER TO GDOC01
SEEK TRIM(m.Tporef+m.CodRef+LsNroDoc)
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
* Procedimiento de Grabacion de informacion de CabeCera
******************************************************************************
PROCEDURE xGraba

** preguntar grabacion **
cResp = [S]
cResp = Aviso(12,[ Datos Correctos (S/N) ? ],[],[],2,'SN',0,.F.,.F.,.T.)
IF cResp = "N"
   RETURN
ENDIF
**
WAIT "GRABANDO" NOWAIT WINDOW
** grabamos cabecera **
SELECT TDOC
SEEK m.coddoc
IF !RLOCK()
   RETURN
ENDIF
**
SELECT TASG
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
REPLACE ImpCup WITH m.ImpCup
REPLACE DiaLet WITH m.DiaLet
REPLACE TipInt WITH m.TipInt
REPLACE PorInt WITH m.PorInt
REPLACE CanLet WITH m.CanLet
** generamos detalles **
DO CjLActDoc WITH m.CodRef,m.NroRef,m.Import
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
DO ACT_CONTAB

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
**
SELECT VTOS
APPEND BLANK
IF ! RLOCK()
   RETURN
ENDIF
*
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
   REPLACE FlgEst WITH 'P'                     && aqui
ENDIF
REPLACE FchAct WITH DATE()
*REPLACE FlgSit WITH 'R'    && Renovada
UNLOCK
**** Actualiza el movimiento realizado ****
SELECT VTOS
REPLACE CodDoc WITH m.coddoc
REPLACE NroDoc WITH m.nrodoc
REPLACE TpoDoc WITH "Renov"
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
** buscamos si ya existe la letra **
SELECT GDOC
SET ORDER TO GDOC01
SEEK [CARGO]+[LETR]+TRIM(LsNroDoc)
IF FOUND()     && Letra YA registrada
   IF !RLOCK()
      SET ORDER TO GDOC04
      RETURN
   ENDIF
   REPLACE TpoRef WITH 'Renov'
   REPLACE CodRef WITH m.coddoc
   REPLACE NroRef WITH m.nrodoc
ELSE
   APPEND BLANK
   IF !RLOCK()
      SET ORDER TO GDOC04
      RETURN
   ENDIF
   REPLACE CodDoc WITH "LETR"
   REPLACE NroDoc WITH LsNroDoc
   REPLACE TpoDoc WITH "CARGO"
   REPLACE FchEmi WITH LdFchDoc
   REPLACE FchDoc WITH m.FchDoc     && Con la Fecha de la Renovacion
   REPLACE CodCli WITH m.codcli
   REPLACE CodMon WITH m.codmon
   REPLACE TpoCmb WITH m.tpocmb
   REPLACE ImpNet WITH LfImpTot
   REPLACE ImpTot WITH LfImpTot
   REPLACE FchVto WITH LdFchVto
   REPLACE SdoDoc WITH LfImpTot
   REPLACE TpoRef WITH 'Renov'
   REPLACE CodRef WITH m.coddoc
   REPLACE NroRef WITH m.nrodoc

   REPLACE FlgEst WITH [P]                      &&  ACA

   REPLACE FlgUbc WITH m.FlgUbc
   REPLACE FlgSit WITH m.FlgSit
   REPLACE CodCta WITH m.CodCta

   REPLACE CodBco WITH m.CodBco
   REPLACE NroCta WITH m.NroCta
   REPLACE FchUbc WITH m.FchUbc

   *
   SELE GDOC
   REPLACE FlgEst WITH 'P'    && Pendiente de Pago
ENDIF
SELE GDOC
SET ORDER TO GDOC04

RETURN

*********************************************************************** FIN() *
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
SEEK "Renov"+TASG->CodDoc+TASG->NroDoc+"CARGO"+"LETR"
SCAN WHILE TpoRef+CodRef+NroRef+TpoDoc+CodDoc = "Renov"+TASG->CodDoc+TASG->NroDoc+"CARGO"+"LETR"
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
SELECT TASG
IF !RLOCK()
   RETURN
ENDIF
**
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
  *REPLACE FlgSit WITH ' '
   UNLOCK
   SELECT GDOC
   SET ORDER TO GDOC04
   * * * *
   SELECT VTOS
   DELETE
   UNLOCK
   SKIP
ENDDO
**
SELECT GDOC
SET ORDER TO GDOC03
SEEK "Renov"+TASG->CodDoc+TASG->NroDoc+"CARGO"+"LETR"
DO WHILE TpoRef+CodRef+NroRef+TpoDoc+CodDoc = ;
         "Renov"+TASG->CodDoc+TASG->NroDoc+"CARGO"+"LETR" .AND. !EOF()
   ** borramos informacion **
   IF !RLOCK()
      LOOP
   ENDIF
   SELECT GDOC
   DELETE
   UNLOCK
   SKIP
ENDDO
SET ORDER TO GDOC04
**
** ANULACION DEL ASIENTO CONTABLE **
IF TASG.FlgCtb
   DO xANUL_CTB
ENDIF
**

SELECT TASG
REPLACE FlgEst WITH 'A'
REPLACE ImpDoc WITH 0
UNLOCK ALL
RETURN
*********************************************************************** FIN() *

********************
PROCEDURE ACT_CONTAB
********************
IF !ctb_aper(m.FchDoc)
	UltTecla = 0
	LOOP
ENDIF
IF TASG.FLGEST=[E]
	DO xACT_CONTA && para contab
ENDIF

********************
PROCEDURE xACT_CONTA
********************

SELE OPER
SEEK XsCodOpe
IF !REC_LOCK(5)
	GsMsgErr = [NO se pudo generar el asiento contable]
	DO lib_merr WITH 99
	RETURN
ENDIF
XsNroMes = TRANSF(MONTH(M.FCHDOC),"@L ##")
XsNroAst = NROAST()
SELECT VMOV
SEEK (XsNroMes + XsCodOpe + XsNroAst)
IF FOUND()
	DO LIB_MERR WITH 11
	RETURN
ENDIF
APPEND BLANK
IF ! Rec_Lock(5)
	GsMsgErr = [NO se pudo generar el asiento contable]
	DO lib_merr WITH 99
	RETURN              && No pudo bloquear registro
ENDIF
WAIT [Generando Asiento Nro. ]+XsNroAst WINDOW NOWAIT
REPLACE VMOV->NROMES WITH XsNroMes
REPLACE VMOV->CodOpe WITH XsCodOpe
REPLACE VMOV->NroAst WITH XsNroAst
REPLACE VMOV->FLGEST WITH "R"
SELECT OPER
=NROAST(XsNroAst)
SELECT VMOV
REPLACE VMOV->FchAst  WITH TASG.FchDoc
REPLACE VMOV->NroVou  WITH []
REPLACE VMOV->CodMon  WITH TASG.CodMon
REPLACE VMOV->TpoCmb  WITH TASG.TpoCmb
REPLACE VMOV->NotAst  WITH TASG.CodDoc+[ ]+TASG.NroDoc
REPLACE VMOV->Digita  WITH GsUsuario
** ACTUALIZAR DATOS DE CABECERA **
REPLACE TASG.NroMes WITH XsNroMes
REPLACE TASG.CodOpe WITH XsCodOpe
REPLACE TASG.NroAst WITH XsNroAst
REPLACE TASG.FlgCtb WITH .T.
* * * * * * * * * * * * * * * * * *
* Barremos el detalle *
PRIVATE XiNroItm,XcEliItm,XdFchAst,XsNroVou,XiCodMon,XfTpoCmb,XsCodCta,XsCodRef
PRIVATE XsCodAux,XcTpoMov,XfImport,XfImpUsa,XsGloDoc,XsCodDoc,XsNroDoc,XsNroRef
PRIVATE XdFchDoc,XdFchVto,nImpNac,nImpUsa
XiNroItm = 1
XcEliItm = SPACE(LEN(RMOV.EliItm))
XdFchAst = VMOV.FchAst
XsNroVou = VMOV.NroVou
XiCodMon = VMOV.CodMon
XfTpoCmb = VMOV.TpoCmb
XsGloDoc = SPACE(LEN(RMOV.GloDoc))
XdFchDoc = XdFchAst
XdFchVto = XdFchAst
nImpNac  = 0
nImpUsa  = 0
** Grabamos las cuentas de detalle **
SELE GDOC
SET ORDER TO GDOC03
SEEK [Renov]+TASG.CodDoc+TASG.NroDoc+[CARGO]+[LETR]
SCAN WHILE TpoRef+CodRef+NroRef+TpoDoc+CodDoc = [Renov]+TASG.CodDoc+TASG.NroDoc+[CARGO]+[LETR]
	=SEEK(CodDoc,"TDOC")
	XsCodCta = TDOC.CodCta
	XsCodRef = SPACE(LEN(RMOV.CodRef))
	=SEEK(XsCodCta,"CTAS")
	XsClfAux = []
	XsCodAux = SPACE(LEN(RMOV.CodAux))
	XsGloDoc = SPACE(LEN(RMOV.GloDoc))
	IF CTAS.PIDAUX=[S]
		XsClfAux = CTAS.ClfAux
		XsCodAux = GDOC.CodCli
		=SEEK(XsClfAux+XsCodAux,"CLIE")
		XsGloDoc = CLIE.NomAux
	ENDIF
	XdFchDoc = GDOC.FchDoc
	XdFchVto = GDOC.FchVto
	XsCodDoc = GDOC.CodDoc
	XsNroDoc = GDOC.NroDoc
	XsNroRef = []
	XiCodMon = GDOC.CodMon
	XfTpoMon = GDOC.TpoCmb
	XcTpoMov = [D]
	XfImport = GDOC.ImpTot
	IF XiCodMon = 1
		IF XfTpoCmb>0
			XfImpUsa = ROUND(XfImport/XfTpoCmb,2)
		ELSE
			XfImpUsa = 0
		ENDIF
	ELSE
		XfImpUsa = XfImport
		XfImport = ROUND(XfImpUsa*XfTpoCmb,2)
	ENDIF
	_MES=MONTH(M.FCHDOC)
	DO movbveri IN ccb_ctb
	* * * *
	SELE GDOC
ENDSCAN
SELE GDOC
SET ORDER TO GDOC04
* * * *
SELE VTOS
SEEK TASG.CodDoc+TASG.NroDoc
SCAN WHILE CodDoc+NroDoc = TASG.CodDoc+TASG.NroDoc
	=SEEK(VTOS.CodRef,"TDOC")
	XsCodCta = TDOC->CodCta
	XsCodRef = SPACE(LEN(RMOV.CodRef))
	=SEEK(XsCodCta,"CTAS")
	XsClfAux = []
	XsGloDoc = SPACE(LEN(RMOV.GloDoc))
	IF CTAS.PIDAUX=[S]
		XsClfAux = CTAS->ClfAux
		XsCodAux = VTOS.CodCli
		=SEEK(XsClfAux+XsCodAux,"CLIE")
		XsGloDoc = CLIE.NOMAUX
	ENDIF
	XdFchDoc = VTOS.FchDoc
	XdFchVto = {  ,  ,    }
	XsCodDoc = VTOS.CodRef
	XsNroDoc = VTOS.NroRef
	XsNroRef = []
	XiCodMon = VTOS.CodMon
	XfTpoMon = VTOS.TpoCmb
	XcTpoMov = [H]
	XfImport = VTOS.Import
	IF XiCodMon = 1
		IF XfTpoCmb>0
			XfImpUsa = ROUND(XfImport/XfTpoCmb,2)
		ELSE
			XfImpUsa = 0
		ENDIF
	ELSE
		XfImpUsa = XfImport
		XfImport = ROUND(XfImpUsa*XfTpoCmb,2)
	ENDIF
	_MES=MONTH(M.FCHDOC)
	DO movbveri IN ccb_ctb
	* * * *
	SELE VTOS
ENDSCAN
** Cerramos bases de datos **
WAIT [Fin de Generacion] WINDOW NOWAIT
DO ctb_cier
RETURN
*********************************************************************** FIN() *
* Objeto : Anulacion del asiento contable
******************************************************************************
PROCEDURE xANUL_CTB

XsNroMes = TASG.NroMes
XsCodOpe = TASG.CodOpe
XsNroAst = TASG.NroAst
SELE VMOV
SEEK XsNroMes+XsCodOpe+XsNroAst
IF !REC_LOCK(5)
   GsMsgErr = [No se pudo anular el asiento contable]
   DO lib_merr WITH 99
   DO ctb_cier
   RETURN
ENDIF
DO MOVBorra IN ccb_ctb
SELE VMOV
*DELETE   && Por Ahora
DO ctb_cier

RETURN
************************************************************************ FIN *
