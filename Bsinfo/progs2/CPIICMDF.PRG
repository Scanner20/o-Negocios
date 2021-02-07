*+---------------+-------------------------------------------------------------+
*: Nombre        : cpiicmdf.prg                                                :
*:---------------+-------------------------------------------------------------+
*: Sistema       : Control de producci¢n industrial.                           :
*:---------------+-------------------------------------------------------------+
*: Autor         : VETT                   Telf: 4841538 - 9437638              :
*:---------------+-------------------------------------------------------------+
*: Ciudad        : LIMA , PERU                                                 :
*:---------------+-------------------------------------------------------------+
*: Direcci¢n     : Av. Bertello 170 - 401 Ciudad Satelite Sta. Rosa. - Callao  :
*:---------------+-------------------------------------------------------------+
*: Prop¢sito     : Inf. consumo de materiales directos de fabricaci¢n.         :
*:---------------+-------------------------------------------------------------+
*: Creaci¢n      : 22/12/95                                                    :
*:---------------+-------------------------------------------------------------+
*: Actualizaci¢n : qq                                                          :
*:               :                                                             :
*+---------------+-------------------------------------------------------------+
PARAMETERS _QUEDIV
=F1_BASE(GsNomCia,GsSistema,"USUARIO:"+GsUsuario,"FECHA:"+GsFecha)

DO AbrirDbfs



IF NOT WEXIST("csmomatdir") ;
 OR UPPER(WTITLE("CSMOMATDIR")) == "CSMOMATDIR.PJX" ;
 OR UPPER(WTITLE("CSMOMATDIR")) == "CSMOMATDIR.SCX" ;
 OR UPPER(WTITLE("CSMOMATDIR")) == "CSMOMATDIR.MNX" ;
 OR UPPER(WTITLE("CSMOMATDIR")) == "CSMOMATDIR.PRG" ;
 OR UPPER(WTITLE("CSMOMATDIR")) == "CSMOMATDIR.FRX" ;
 OR UPPER(WTITLE("CSMOMATDIR")) == "CSMOMATDIR.QPR"
 DEFINE WINDOW csmomatdir ;
  FROM INT((SROW()-17)/2),INT((SCOL()-70)/2) ;
  TO INT((SROW()-17)/2)+16,INT((SCOL()-70)/2)+69 ;
  TITLE "CONSUMO DE MATERIALES DIRECTOS - MENSUAL" ;
  FLOAT ;
  NOCLOSE ;
  SHADOW ;
  NOMINIMIZE ;
  DOUBLE ;
  COLOR SCHEME 1
ENDIF
IF WVISIBLE("csmomatdir")
 ACTIVATE WINDOW csmomatdir SAME
ELSE
 ACTIVATE WINDOW csmomatdir NOSHOW
ENDIF

m.QueDiv  = _QueDiv
m.CodMatD = SPACE(LEN(CATG.COdMat))
m.CodMatH = SPACE(LEN(CATG.CodMat))
m.CodDivD = SPACE(GaLenCod(1))
m.CodDivH = SPACE(GaLenCod(1))
m.CodFamD = SPACE(GaLenCod(2))
m.CodFamH = SPACE(GaLenCod(2))
m.Fch1    = CTOD("01/"+STR(_MES,2,0)+"/"+STR(_ANO,4,0))
m.Fch2    = GDFECHA
m.codmon  = 1
m.Control = 1
m.TpoCmb  = 1
m.QueVal  = 1

DIMENSION aCodPro(15),aValPro(15)
STORE [] TO aCodPro,LsEnCab1,LsEnCab2,LsEnCab3,LsEncab4,LsLinTot,LsLinFam
STORE 0  TO aValPro
STORE 0  TO XfValFor,XfValAdi,XfVMerma,XfValO_T

@ 0,20 GET m.quediv PICT "@^ \<Divisi¢n;\<Familia;\<Producto" SIZE 3,12 ;
                    DEFAULT "Divisi¢n" COLOR SCHEME 1, 2 WHEN .F.

@ 1,10 SAY "Por :" SIZE 1,5, 0


IF m.QueDiv<3
   @ 4,3 SAY "Desde :" SIZE 1,7, 0

   @ 5,3 SAY "Hasta :" SIZE 1,7, 0
   @ 7,3 SAY "Del   :           Al :"
ELSE

   @ 4,3 SAY "Familia:" SIZE 1,7, 0

   @ 5,3 SAY "Desde :" SIZE 1,7, 0
   @ 6,3 SAY "Hasta :" SIZE 1,7, 0
   @ 8,3 SAY "Del   :           Al :"
ENDIF

@ 10,03 SAY "Moneda   :"

**IF m.QueDiv=3
   @ 11,03 SAY "Valor de :"
**ENDIF

DO CASE
CASE m.QueDiv = 1
 @ 4,12 GET m.CodDivD VALID F1_Busca(m.CodDivD,"CODFAM","DIVF","DIVF","01",.T.,[bDescrip])
 @ 5,12 GET m.coddivH VALID F1_Busca(m.CodDivH,"CODFAM","DIVF","DIVF","01",.T.,[bDescrip])
 @ 7,12 GET m.Fch1  DISABLE
 @ 7,27 GET m.Fch2  DISABLE
CASE m.QueDiv = 2
 @ 4,12 GET m.CodFamD VALID F1_Busca(m.CodFamD,"CODFAM","DIVF","DIVF","02",.T.,[bDescrip])
 @ 5,12 GET m.codFamH VALID F1_Busca(m.CodFamH,"CODFAM","DIVF","DIVF","02",.T.,[bDescrip])
 @ 7,12 GET m.Fch1  DISABLE
 @ 7,27 GET m.Fch2  DISABLE
CASE m.QueDiv = 3
 @ 4,14 GET m.CodFamD VALID F1_Busca(m.CodFamD,"CODFAM","DIVF","DIVF","02",.T.,[bDescrip])
*@ 5,12 GET m.CodMatD VALID F1_Busca(m.CodMatD,"CODMAT","CATGF","CATG",m.CodFamD,.T.,[bDescrip])
*@ 6,12 GET m.codMatH VALID F1_Busca(m.CodMatH,"CODMAT","CATGF","CATG",m.CodFamD,.T.,[bDescrip])
 @ 5,12 GET m.CodMatD VALID F1_Busca(m.CodMatD,"CODMAT","CATGF","CATG",[],.T.,[bDescrip])
 @ 6,12 GET m.codMatH VALID F1_Busca(m.CodMatH,"CODMAT","CATGF","CATG",[],.T.,[bDescrip])
 @ 8,12 GET m.Fch1  DISABLE
 @ 8,27 GET m.Fch2  DISABLE
ENDCASE

@ 10,20 GET m.CodMon PICTURE "@*RHN \<Soles;\<Dolares" SIZE 1,11,0
**IF m.QueDiv=3
	@ 11,20 GET m.QueVal PICTURE "@*RHN A\<lmacen;Ca\<talogo" SIZE 1,15,0
**ENDIF
@ 12,24 GET m.control PICT "@*HT \<Aceptar;\<Cancelar" SIZE 1,10,4 DEFAULT 1




IF NOT WVISIBLE("csmomatdir")
 ACTIVATE WINDOW csmomatdir
ENDIF

READ CYCLE
UltTecla = LASTKEY()
IF m.Control = 2
   UltTecla = K_ESC
ENDIF
IF UltTecla # K_ESC AND Encabezado()
   DO GenTempo
   DO Imprimir
ENDIF

Ven_Actual = woutput()
IF !EMPTY(Ven_Actual)
    DEACTIVATE WINDOW (Ven_Actual)
    RELEASE WINDOW (Ven_actual)
ENDIF
CLOSE DATA
RETURN
****************
FUNCTION wTpoCmb
****************
IF EMPTY(m.TpoCmb)
   IF SEEK(DTOS(m.Fch2),"TCMB")
      m.TpoCmb = TCMB->OfiVta
   ELSE
      GsMsgErr = [ Tipo de Cambio del dia NO definido ]
      DO f1msgerr WITH GsMsgErr
   ENDIF
ENDIF
RETURN .T.
*******************
PROCEDURE AbrirDbfs
*******************
=F1QEH("ABRE_DBF")
SELE 0
USE ADMMTCMB ORDER TCMB01 ALIAS TCMB
IF !USED()
   RETURN .F.
ENDIF
SELE 0
USE ALMTDIVF ORDER DIVF01 ALIAS DIVF
IF !USED()
   RETURN .F.
ENDIF
SELE 0
USE ALMCATGE ORDER CATG01 ALIAS CATG
IF !USED()
   RETURN .F.
ENDIF
SELE 0
USE CPICFPRO ORDER CFPR01 ALIAS CFPRO
IF !USED()
   RETURN .F.
ENDIF
SELE 0
USE CPIDFPRO ORDER DFPR01 ALIAS DFPRO
IF !USED()
   RETURN .F.
ENDIF
SELE 0
USE CPICO_TB ORDER CO_T02 ALIAS CO_T
IF !USED()
   RETURN .F.
ENDIF
SELE 0
USE ALMESTCM ORDER ESTA02 ALIAS ESTA
IF !USED()
   RETURN .F.
ENDIF

wait window [Preparando informacion..] nowait
Arch = PathUser+SYS(3)
wait window [Preparando informacion..] nowait
Arch2= PathUser+SYS(3)
SELE 0
USE CPIICMDF
COPY STRU TO &ARCH.
USE &Arch. ALIAS TEMPO EXCLU
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
INDEX ON NIVEL+CODMAT TAG TEMP01
SET ORDER TO TEMP01
*
SELE 0
USE CPITO_TB ORDER TO_T02 ALIAS TO_T
IF !USED()
   CLOSE DATA
   RETURN
ENDIF

SELE 0
CREATE TABLE &Arch2. ( CODPRD C(8)   ,;
                       VALO_T N(14,4),;
                       VALADI N(14,4),;
                       VALREA N(14,4),;
                       VALFOR N(14,4),;
                       VMERMA N(14,4),;
                       PORMER N(14,4),;
                       CANOBJ N(14,4),;
                       CANFIN N(14,4),;
                       BATPRO N(14,4),;
                       UNIREA N(14,4),;
                       UNIFOR N(14,4),;
                       UNIMER N(14,4) )


USE &ARCH2. ALIAS RPRO EXCLU
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
INDEX ON CODPRD TAG RPRO01
SET ORDER TO RPRO01




=F1QEH("OK")
RETURN .T.
******************
PROCEDURE bDescrip
******************
DO CASE
   CASE UPPER(VARREAD())=[CODDIVD]
        @ 4,12+GaLenCod(1)+3    SAY DIVF.DesFam SIZE 1,30
   CASE UPPER(VARREAD())=[CODDIVH]
        @ 5,12+GaLenCod(1)+3    SAY DIVF.DesFam SIZE 1,30
   CASE UPPER(VARREAD())=[CODFAMD]
        @ 4,12+GaLenCod(2)+3    SAY DIVF.DesFam SIZE 1,30
   CASE UPPER(VARREAD())=[CODFAMH]
        @ 5,12+GaLenCod(2)+3    SAY DIVF.DesFam SIZE 1,30
   CASE UPPER(VARREAD())=[CODMATD]
        @ 5,12+GaLenCod(3)+3    SAY CATG.DesMAT SIZE 1,30
   CASE UPPER(VARREAD())=[CODMATH]
        @ 6,12+GaLenCod(3)+3    SAY CATG.DesMAT SIZE 1,30
   CASE UPPER(VARREAD())=[CODFAM]
        @ 4,12+GaLenCod(2)+3    SAY divf.DesfAM SIZE 1,30
ENDCASE
******************
PROCEDURE Imprimir
******************
SELE TEMPO
GO TOP
SET RELA TO CODMAT INTO CATG,GaClfDiv(2)+LEFT(CodMat,GaLenCod(2)) INTO DIVF

IF EOF()
   GsMsgErr = [Fin de Archivo]
   DO f1msgerr WITH gsmsgerr
   RETURN
ENDIF
**
Largo = 66
IniPrn = [_Prn0+_Prn5a+CHR(Largo)+_Prn5b+_Prn4]
do case
	case _dos
		sNomRep = "Cpiicmdf"
	case _Windows
		sNomRep = "Cpiicmd1"
endcase
DO F0print WITH "REPORTS"
RETURN
********************
PROCEDURE Encabezado
********************
SET STEP ON 
m.Len0 = LEN(CATG.CodMat)
m.Len1 = m.Len0 - GaLenCod(1)
m.Len2 = m.Len0 - GaLenCod(2)
m.Len3 = m.Len0 - GaLenCod(3)
DO CASE
   CASE m.QueDiv = 1
        SELE DIVF
        m.CodDivD = TRIM(m.CodDivD)
        m.CodDivH = TRIM(m.CodDivH)+CHR(255)
        m.ClfDiv  = GaClfDiv(m.QueDiv)
        IF EMPTY(m.CodDivD)
           SEEK m.ClfDiv
        ELSE
           SEEK m.ClfDiv+m.CodDivD
           IF ! FOUND() .AND. RECNO(0) > 0
              GOTO RECNO(0)
              IF DELETED()
                 SKIP
              ENDIF
           ENDIF
        ENDIF
        zi = 0
        SCAN WHILE ClfDiv+CodFam<=m.ClfDiv+m.CodDivH AND zi<=12
             zi = zi + 1
             if alen(aCodPro)< zi
                dimension aCodPro(zi+5)
             endif
             aCodPro(zi) = LEFT(CodFam,GaLenCod(1))+SPACE(m.Len1)
        ENDSCAN
        IF zi>0
           IF zi>12
              zi = 12
           ENDIF
           DIMENSION  aCodPro(zi)
        ELSE
           DO F1MsgErr WITH [No estan definidas las divisiones por material]
           RETURN .F.
        ENDIF
   CASE m.QueDiv = 2
        SELE DIVF
        m.CodFamD = TRIM(m.CodFamD)
        m.CodFamH = TRIM(m.CodFamH)+CHR(255)
        m.ClfDiv  = GaClfDiv(m.QueDiv)
        IF EMPTY(m.CodFamD)
           SEEK m.ClfDiv
        ELSE
           SEEK m.ClfDiv+m.CodFamD
           IF ! FOUND() .AND. RECNO(0) > 0
              GOTO RECNO(0)
              IF DELETED()
                 SKIP
              ENDIF
           ENDIF
        ENDIF
        zi = 0
        SCAN WHILE ClfDiv+CodFam<=m.ClfDiv+m.CodFamH AND zi<=12
             zi = zi + 1
             if alen(aCodPro)< zi
                dimension aCodPro(zi+5)
             endif
             aCodPro(zi) = LEFT(CodFam,GaLenCod(2))+SPACE(m.Len2)
        ENDSCAN
        IF zi>0
           IF zi>12
              zi = 12
           ENDIF
           DIMENSION  aCodPro(zi)
        ELSE
           DO F1MsgErr WITH [No estan definidas las familias por material]
           RETURN .F.
        ENDIF
   CASE m.QueDiv = 3
        SELE CATG
        IF EMPTY(m.CodMatD)
           m.CodMatD = m.CodFamD
        ENDIF
        IF EMPTY(m.CodMatH)
           m.CodMatH = m.CodFamD
        ENDIF
        m.CodMatD = TRIM(m.CodMatD)
        m.CodMatH = TRIM(m.CodMatH)+CHR(255)
        m.ClfDiv  = GaClfDiv(m.QueDiv)
        IF EMPTY(m.CodMatD)
           GO TOP
        ELSE
           SEEK m.CodMatD
           IF ! FOUND() .AND. RECNO(0) > 0
              GOTO RECNO(0)
              IF DELETED()
                 SKIP
              ENDIF
           ENDIF
        ENDIF
        zi = 0
        SCAN WHILE CodMat<=m.CodMatH AND zi<=12
             zi = zi + 1
             if alen(aCodPro)< zi
                dimension aCodPro(zi+5)
             endif
             aCodPro(zi) = CodMat
        ENDSCAN
        IF zi>0
           IF zi>12
              zi = 12
           ENDIF
           DIMENSION  aCodPro(zi)
        ELSE
           DO F1MsgErr WITH [No existen materiales en el rango]
           RETURN .F.
        ENDIF
ENDCASE
FOR KK = 1 TO ALEN(aCodPro)
    =SEEK(aCodPro(kk),[CATG])
    =SEEK(m.ClfDiv+TRIM(aCodPro(kk)),[DIVF])
    DIMENSION xxDesMat(3)
    STORE [] TO xxDesMat
    IF m.QueDiv = 3
       LsxxDesMat = CATG.DesMat
    ELSE
       LsxxDesMat = DIVF.DesFam
    ENDIF
    NumDes = 0
    DO WHILE .T.
       IF EMPTY(LsxxDesMat)
          EXIT
       ENDIF
       NumDes = NumDes + 1
       IF NumDes > ALEN(xxDesMat)
          DIMENSION xxDesMat(NumDes+1)
       ENDIF
       Z = AT("-",LsxxDesMat)
       IF Z = 0
          Z = LEN(LsxxDesMat) + 1
       ENDIF
       xxDesMat(NumDes) = PADC(LEFT(LsxxDesMat,Z-1),15)
       IF Z > LEN(LsxxDesMat)
          EXIT
       ENDIF
       LsxxDesMat = SUBSTR(LsxxDesMat,Z+1)
    ENDDO
    LsEncab1=LsEncab1 + PADL(TRIM(xxDesMat(1)),15)+[ ]
    LsEncab2=LsEncab2 + PADL(TRIM(xxDesmat(2)),15)+[ ]
    LsEncab3=LsEncab3 + PADL(TRIM(xxDesMat(3)),15)+[ ]
    LsEncab4=LsEncab4 + [  Cant.]+[ ]+[  Valor]+[ ]
    LsLinTot=LsLinTot + [       ]+[ ]+[=======]+[ ]
    LsLinFam=LsLinFam + [       ]+[ ]+[-------]+[ ]
ENDFOR
nEspac   = 210-LEN(LsEnCab1)-19
sEspacio = IIF(nEspac>0,SPACE(nEspac),[])
LsEncab1 = LsEncab1 +sEspacio+PADC(SPACE(16),19)
LsEncab2 = LsEncab2 +sEspacio+PADC([T O T A L],19)
LsEncab3 = LsEncab3 +sEspacio+PADC(SPACE(16),19)
LsEncab4 = LsEncab4 +sEspacio+PADC([  Cant.]+[ ]+[  Valor],19)
LsLinTot = LsLinTot +sEspacio+[         ]+[ ]+[=========]
LsLinFam = LsLinFam +sEspacio+[         ]+[ ]+[---------]
**DO SelMatForm

RETURN .T.
********************
PROCEDURE SelMatForm
********************
PRIVATE K
FOR K = 1 TO ALEN(aCodPro)
    m.CodPro = TRIM(aCodPro(K))
    SEEK m.CodPro
    SCAN WHILE CodPro=m.CodPro
         m.CodMat = CodMat
         SELE TEMPO
         SEEK [D01]+m.CodMat
         IF !FOUND()
            APPEND BLANK
            REPLACE Nivel  WITH [D01]
            REPLACE CodMat WITH m.CodMat
            =SEEK(CodMat,[CATG])
            REPLACE DesMat WITH CATG.DesMat
         ENDIF
         SELE DFPRO
    ENDSCAN
ENDFOR
RETURN

**************
FUNCTION _Prod
**************
PARAMETER LsCodPrd
PRIVATE xAlias
xAlias = ALIAS()
STORE 0 TO LfValFor,LfCanObj,LfBatObj,LfValO_T,LfValfor,LfCanFin,LfVMerma,LfBatPro
SELE TO_T
SEEK LsCodPrd+DTOS(m.Fch1)
IF !FOUND() AND RECNO(0)>0
   GO RECNO(0)
ENDIF
LsClfDiv  = GaClfDiv(m.QueDiv)
SCAN WHILE CodPrd = LsCodPrd AND FchDoc <= m.Fch2 FOR ClfDiv=LsClfDiv
     LfCanObj = LfCanObj + CanObj
     LfCanFin = LfCanFin + CanFin
     LfBatPro = LfBatPro + BatPro
     LFValFor = LfValFor + IIF(m.CodMon=1,VForm1,VForm2)
     LFValO_T = LfValO_T + IIF(m.CodMon=1,VReal1,VReal2)
     LFVMerma = LfVMerma + IIF(m.CodMon=1,VMerma1,VMerma2)
ENDSCAN

IF LfCanObj>0
   LfUniFor = ROUND(LfValFor/LfCanObj,2)
ELSE
   LfUniFor = 0
ENDIF
IF LfCanFin>0
   LfUniRea = ROUND(LfValO_T/LfCanFin,2)
ELSE
   LfUniRea = 0
ENDIF
LfUniMer = ROUND(LfUniRea - LfUniFor,2)
*LfVMerma = ROUND(LfUniMer*LfCanFin,2)
LFValAdi  = LFCtoPro - LfValO_T

SELE RPRO
SEEK LsCodPrd
IF !FOUND()
   APPEND BLANK
   REPLACE CodPrd WITH LsCodPrd
ENDIF
REPLACE UNIFOR WITH LfUniFor
REPLACE UNIREA WITH LfUniRea
REPLACE UNIMER WITH LfUniMer
REPLACE CANOBJ WITH LfCanObj
REPLACE CANFIN WITH LfCanFin
REPLACE VALFOR WITH LfValFor
REPLACE VALREA WITH LfCtoPro
REPLACE VALADI WITH LfValAdi
REPLACE VALO_T WITH LfValO_T
REPLACE BATPRO WITH LfBatPro
REPLACE VMERMA WITH LfVmerma
LfValor = LfValO_T - LfVmerma
IF LfValor>0
   REPLACE PORMER WITH ROUND(LfVmerma/LfValor*100,2)
ELSE
   REPLACE PORMER WITH 0
ENDIF
SELE (xAlias)
XfValFor = XfValFor + LfValFor
XfVMerma = XfVMerma + LfVMerma
XfValAdi = XfValAdi + LfValAdi
XfValO_T = XfValO_T + LfValO_T


RETURN
************
FUNCTION _vr
************
parameter m.col,m.Campo

IF Alen(acodpro)<m.col
   RETURN 0
ENDIF

PRIVATE LsCodPrd,xalias
xAlias = ALIAS()
LsCodPrd = aCodPro(m.Col)
LfValor  = 0
SELE RPRO
SEEK LsCodPrd
IF FOUND()
   LfValor  = &Campo.
ENDIF

SELE (xAlias)

RETURN LfValor
******************
PROCEDURE GenTempo  && Carga informaci¢n al archivo temporal
******************
=F1QEH("PROC_INFO")
FOR K = 1 TO ALEN(aCodPro)
    m.CodPro = aCodPro(K)
    m.ClfDiv  = GaClfDiv(m.QueDiv)
    =SEEK(aCodPro(k),[CATG])
    =SEEK(m.ClfDiv+TRIM(aCodPro(k)),[DIVF])
    IF m.QueDiv = 3
       LsDesMat = CATG.DesMat
    ELSE
       LsDesMat = DIVF.DesFam
    ENDIF
    WAIT WINDOW LsDesmat nowait
    SELE ESTA
    SET ORDER TO ESTA01
    m.Fecha  = m.Fch1
    LsFecha  = PADR(LEFT(DTOS(m.Fecha),6),LEN(ESTA.Periodo))
    SEEK LsFecha+m.CodPro
    DO WHILE Periodo+CodPro = LsFecha+m.CodPro AND !EOF()
       STORE 0 TO m.CanIng,m.CanSal,m.VCtIng,m.VCtSal
       STORE 0 TO m.CnForm,m.VcForm
       WAIT WINDOW [INSUMOS DE:]+LsDesmat+[ ]+MES(_MES,1) nowait
       m.CodMat=CodMat
       SCAN WHILE Periodo+CodPro = LsFecha+m.CodPro  AND CodMat=m.CodMat
            m.CanSal = m.CanSal + CanSal
            m.CanIng = m.CanIng + CanIng
            m.VctSal = m.VctSal + IIF(m.CodMon=1,VSalMn,VSalUs)
            m.VctIng = m.VctIng + IIF(m.CodMon=1,VIngMn,VIngUs)


       ENDSCAN
       SELE TEMPO
       SEEK [D01]+m.CodMat
       IF !FOUND()
          APPEND BLANK
          REPLACE Nivel  WITH [D01]
          REPLACE CodMat WITH m.CodMat
          =SEEK(CodMat,[CATG])
          REPLACE DesMat WITH CATG.DesMat
       ENDIF
       Campo1 = "C"+TRAN(K,"@L ##")
       Campo2 = "V"+TRAN(K,"@L ##")
       Campo3 = "B"+TRAN(K,"@L ##")
      *Campo4 = "M"+TRAN(K,"@L ##")
       IF m.QueVal=2
          LfPreUni=0
          IF SEEK(CodMat,[CATG])
             LfPreUni = IIF(m.CodMon=1,CATG.PUINMN,CATG.PUINUS)
		  ENDIF	
          m.VctoCsm = ROUND((m.CanSal - m.CanIng)*LfPreUni,2)
       ELSE
          m.VctoCsm = m.VctSal - m.VctIng
       ENDIF
       REPLACE &Campo1. WITH &Campo1. + m.CanSal - m.CanIng
       REPLACE &Campo2. WITH &Campo2. + m.VCtoCsm
       aValPro(K) = aValPro(K) + m.VCtoCsm
       REPLACE TOTCOM WITH TOTCOM + m.CanSal - m.CanIng
       REPLACE TOTVAL WITH TOTVAL + m.VCtoCsm
       SELE ESTA
    ENDDO
    ** acumulando resumen por producto
    LfCtoPro  = aValPro(K)
    =_Prod(m.CodPro)
    **
ENDFOR
=F1QEH("OK")
RETURN
