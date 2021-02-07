CLEAR
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
USE ccbrgdoc IN 3 ORDER GDOC01 ALIAS GDOC
IF !USED(3)
   CLOSE DATA
   RETURN
ENDIF
**
USE ccbrrdoc IN 4 ORDER RDOC01 ALIAS RDOC
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
*
USE ccbnrasg IN 7 ORDER RASG01 ALIAS RASG
IF !USED(7)
   CLOSE DATA
   RETURN
ENDIF
m.codref = [PROF]
m.CodDoc = [CANJ]
UltTecla = 0
DESDE = SPACE(LEN(VTOS.NroDoc))
HASTA = SPACE(LEN(VTOS.NroDoc))

@ 2,0 TO 20,79 PANEL
@ 2,25  SAY "INTERESES POR CANJE/PROFORMAS"
GsMsgKey = " [Enter] Aceptar [Esc] Salir "
DO LIB_MTEC WITH 99
XdFch1 = DATE()
XdFch2 = DATE()
XsTpoDoc = "CARGO"
XsCodDoc = "N/C "
XnAno    = YEAR(DATE())
XnMes    = MONTH(DATE())

@ 09,10 SAY "Periodo          :    /  "    COLOR SCHEME 11
@ 11,10 SAY "N/D‚bito  Desde  :"    COLOR SCHEME 11
@ 12,10 SAY "N/D‚bito  Hasta  :"    COLOR SCHEME 11
@ 14,10 SAY "Fecha     Desde  :"    COLOR SCHEME 11
@ 15,10 SAY "Fecha     Hasta  :"    COLOR SCHEME 11
UltTecla = 0
i = 1
DO LIB_MTEC WITH 11
DO WHILE !INLIST(UltTecla,Escape,CtrlW)
   DO CASE
      CASE i = 1
           @ 09,28 GET XnAno PICT "9999" VALID XnAno>0
           @ 09,33 GET XnMes PICT "99"   RANGE 1,12
           READ
           UltTecla = LASTKEY()
           XdFch1=CTOD("01/"+TRANS(XnMes,"@L ##")+"/"+RIGHT(STR(XnAno,4,0),2))
           XdFch2=CTOD("01/"+TRANS(XnMes+1,"@L ##")+"/"+RIGHT(STR(XnAno,4,0),2))-1
      CASE i = 2
           @ 11,28 GET Desde   PICT "@!"  VALID _vLook(Desde,"NroDoc")
           @ 12,28 GET Hasta   PICT "@!"  VALID _vLook(Hasta,"NroDoc")
           READ
           UltTecla = LASTKEY()
      CASE i = 3
           @ 14,28 GET XdFch1  PICT "@!" VALID MONTH(XdFch1)=XnMes AND YEAR(XdFch1)=XnAno
           @ 15,28 GET XdFch2  PICT "@!" VALID MONTH(XdFch2)=XnMes AND YEAR(XdFch2)=XnAno
           READ
           UltTecla = LASTKEY()
           IF UltTecla = Enter
              UltTecla = CtrlW
           ENDIF
   ENDCASE
   i = IIF(UltTecla=Arriba,i-1,i+1)
   i = IIF(i<1 , 1,i)
   i = IIF(i>3 ,3 ,i)
ENDDO
IF UltTecla = Escape
   CLOSE DATA
   RETURN
ENDIF
*
Arch = PathUser+SYS(3)
SELE 0
CREATE TABLE &Arch. (NroDoc C(10) ,FDoc D(8),FVto D(8),Dias N(5),T_Int N(14,2),;
                       T_Itm N(2)  ,  T01 N(14,2) , T02 N(14,2) , T03 N(14,2), ;
                       T04 N(14,2) ,  T05 N(14,2) , T06 N(14,2) , T07 N(14,2), ;
                       T08 N(14,2) ,  T09 N(14,2) , T10 N(14,2) , T11 N(14,2), ;
                       T12 N(14,2) ,  T13 N(14,2) , T14 N(14,2) , T15 N(14,2), ;
                       D01 N(06,0) ,  D02 N(06,0) , D03 N(06,0) , D04 N(06,0), ;
                       D05 N(06,0) ,  D06 N(06,0) , D07 N(06,0) , D08 N(06,0), ;
                       D09 N(06,0) ,  D10 N(06,0) , D11 N(06,0) , D12 N(06,0), ;
                       D13 N(06,0) ,  D14 N(06,0) , D15 N(06,0) , Tipo C(1)    )

USE &Arch. ALIAS TEMPO EXCLU
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
INDEX ON NRODOC+TIPO TAG TEMP01
SET ORDER TO TEMP01
*
SELE VTOS
SET ORDER TO VTOS03
SEEK XsCodDoc+TRIM(Desde)
IF !FOUND()
   GsMsgErr = "No existen registros a listar"
   DO LIB_MERR WITH 99
   CLOSE DATA
   DELE FILE &Arch..DBF
   DELE FILE &Arch..CDX
   RETURN
ENDIF
**
***
MesIni = 300001
MesFin = 0
HASTA = TRIM(HASTA)
HASTA = LEFT(HASTA+REPLI("z",LEN(GDOC.NroDoc)),LEN(GDOC.NroDoc))
*** Registro de arranque ***
WAIT "Procesando informaci¢n...Un momento por favor" NOWAIT WINDOW
SELE VTOS
SCAN WHILE CodRef=XsCodDoc AND NroRef<=HASTA
     IF CodDoc="CANJ"
        SELE TASG
        SEEK "CANJ"+VTOS.NroDoc
        IF CodRef="PROF" AND FOUND()
           lHay_ND = SEEK(XsTpoDoc+XsCodDoc+VTOS.NroRef,"GDOC")
           m.CodRef = CodRef
           m.NroRef = NroRef
           IF GDOC->FchDoc<=XdFch2 AND GDOC->FchDoc>=XdFch1 AND lHay_ND
              DO Cal_int
           ENDIF
        ENDIF
     ENDIF
     SELE VTOS
ENDSCAN
SELE TEMPO
GO TOP
IF EOF()
   GsMsgErr = "No existen registros a listar"
   DO LIB_MERR WITH 99
   CLOSE DATA
   DELE FILE &Arch..DBF
   DELE FILE &Arch..CDX
   RETURN
ENDIF
** Totalizamos
TOTAL TO BELU ON NRODOC
SELE 0
USE BELU EXCL
IF !USED()
   CLOSE DATA
   DELE FILE &Arch..DBF
   DELE FILE &Arch..CDX
   RETURN
ENDIF
REPLACE ALL TIPO WITH [2]
DELE ALL FOR T_itm=1
USE
SELE TEMPO
APPEND FROM BELU
GO TOP
WAIT "Imprimiendo..."  NOWAIT WINDOW
LsEncab1 = []
LsEncab2 = []
DO xEncab
Largo   = 66       && Largo de pagina
LinFin  = 88 - 6
IniPrn=[_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn4]
IniImp =_PRN4+_PRN8A
sNomREP = "Ccbr4int"
DO ADMPRINT WITH "REPORTS"
CLOSE DATA
DELE FILE &Arch..DBF
DELE FILE &Arch..CDX
RETURN
*****************
PROCEDURE Cal_Int
*****************
LfIntLet = 0
SELE RASG
SEEK m.CodRef+m.NroRef+[CARGO]
SCAN WHILE CodDoc+NroDoc+TpoRef=m.CodRef+m.NroRef+[CARGO] FOR CodRef = [LETR]
     LfIntLet  = LfIntLet + ImpInt
ENDSCAN
LfIntN_D = 0
SELE RDOC
SEEK GDOC.TpoDoc+GDOC.CodDoc+GDOC.NroDoc
SCAN WHILE TpoDoc+CodDoc+NroDoc=GDOC.TpoDoc+GDOC.CodDoc+GDOC.Nrodoc FOR Codigo="108"  && Intereses por financiaci¢n
     LfIntN_D = LfIntN_D + RDOC->Import
ENDSCAN
primera = .T.
SELE RASG
SEEK m.CodRef+m.NroRef+[CARGO]
SCAN WHILE CodDoc+NroDoc+TpoRef=m.CodRef+m.NroRef+[CARGO] FOR CodRef = [LETR]
     DIMENSION vDias(12),vInt(12),vper(12)
     STORE [] TO vDias,NumPer,vInt,vPer
     STORE 0 TO RfIntDoc,RfImpTot,LfTotInt
     DO DocbInte
     SELE TEMPO
     APPEND BLANK
     REPLACE Tipo   WITH [1]
     REPLACE NroDoc WITH VTOS.NroRef
     REPLACE FDoc   WITH GDOC.FchDoc
     REPLACE FVto   WITH RASG.VtoRef
     REPLACE Dias   WITH RASG.VtoRef - GDOC.FchDoc
     FOR k = 1 TO NumPer
         Campo = "T"+TRANS(K,"@L ##")
         Campo1= "D"+TRANS(K,"@L ##")
         REPLACE &Campo.  WITH vInt(k)
         REPLACE &Campo1. WITH vper(k)
         LfTotInt = LfTotInt + &Campo.
     ENDFOR
     REPLACE T_Int  WITH LfTotInt
     REPLACE T_Itm  WITH 1
     SELE RASG
     primera = .F.
ENDSCAN
RETURN
******************
PROCEDURE DocbInte
******************
PRIVATE j,i,P,n,m,V
j = 1
T_Dias   = VtoRef - GDOC.FchDoc
T_Import = Import
XdFchIni = GDOC.FchDoc
XdFchFin = VtoRef
**--- Datos de la proforma ---**
=SEEK(m.CodRef+m.NroRef,"TASG")
XfPorInt = TASG->PorInt
XcTipInt = TASG->TipInt
XiTipTas = TASG->TipTas
T_Mes    = MONTH(TASG->FchDoc)
**----------------------------**
DO Periodos
store 0 TO n,vInt,RfIntDoc,RfImpTot
LfImpInt = RASG.ImpInt
IF LfIntN_D<>LfIntLet and primera
   LfImpInt = LfImpInt + (LfIntN_D-LfIntLet)
ENDIF
FOR  zz = 1 TO NumPer
  *LfTotInt = Ccb_Inte(T_Import,vDias(zz),XfPorInt,XcTipInt,XiTipTas)
  *vInt(zz) = LfTotInt
  ** Solo prorrateamos **
  *vInt(zz) = ROUND((vDias(zz)*RASG.ImpInt)/T_Dias,2)
  ** Directamente de la nota de debito
  vInt(zz) = ROUND((vDias(zz)*LfImpInt)/T_Dias,2)
ENDFOR
RETURN
******************
PROCEDURE Periodos
******************
XdFecha = XdFchIni + 1
NumPer  = 0
DiaAcm  = 0
Mes_Act = MONTH(XdFecha)
DO WHILE XdFecha <= XdFchFin
   Mes_Ant = Mes_Act
   IF Mes_Act <> MONTH(XdFecha)
      Mes_Act = MONTH(XdFecha)
   ENDIF
   IF MONTH(XdFecha) <> Mes_Ant
      IF ALEN(vDias) < NumPer + 1
         DIMENSION vDias(NumPer + 5),vInt(NumPer + 5),vper(NumPer + 5)
      ENDIF
      NumPer        = NumPer + 1
      vDias(NumPer) = DiaAcm
      vPer (NumPer) = VAL(LEFT(DTOS(XdFecha -1),6))
      DiaAcm = 0
   ENDIF
   IF XdFecha + 1 > XdFchFin
      IF ALEN(vDias) < NumPer + 1
         DIMENSION vDias(NumPer + 5),vInt(NumPer + 5),vPer(NumPer + 5)
      ENDIF
      NumPer        = NumPer + 1
      vDias(NumPer) = DiaAcm + 1
      vPer (NumPer) = VAL(LEFT(DTOS(XdFecha),6))
      DiaAcm = 0
   ENDIF
   DiaAcm   = DiaAcm  + 1
   XdFecha  = XdFecha + 1
ENDDO
RETURN
****************************
procedure _vlook
****************************
parameters var1,campo1
UltTecla = LAStKEY()
IF UltTecla = F8
   select GDOC
   IF ! ccbbusca("GDOC")
      SELECT ccbrgdoc
      return .T.
   ENDIF
   var1    = &campo1
   ulttecla= Enter
   SELECT ccbrgdoc
ENDIF
IF UltTecla = ESCAPE .OR. UltTecla = ENTER
   return .T.
ENDIF
IF EMPTY(VAR1)
   RETURN .T.
ENDIF
IF !SEEK(XsTpoDoc+XsCodDoc+VAR1,"GDOC")
   RETURN .F.
ELSE
   IF !(FchDoc>=XdFch1 AND FchDoc<=XdFch2)
      GsMsgErr = "No corresponde al periodo"
      DO LIB_MERR WITH 99
      RETURN .F.
   ENDIF
ENDIF
RETURN .T.
****************
PROCEDURE xEncab
****************
XsAnoIni = TRAN(XnAno,"9999")
XsMesIni = TRAN(XnMes+1,"@L ##")
IF Val(XsMesIni)=13
   XsAnoAni = STR(VAL(XsAnoIni) + 1,4,0)
   XsMesIni = "01"
ENDIF
nMes = VAL(XsMesIni)
sAno = XsAnoIni
FOR KK = 1 TO 12
    sMes = LEFT(MES(nMes,3),3)
    LsEncab1=LsEncab1 + PADC(sAno,10)+[ ]
    LsEncab2=LsEncab2 + PADC(LEFT(MES(nMes,3),3),10)+[ ]
    nMes = nMes + 1
    IF nMes = 13
       nMes = 1
       sAno = STR(VAL(sAno) + 1,4,0)
    ENDIF
ENDFOR
RETURN
