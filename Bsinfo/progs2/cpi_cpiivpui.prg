*имммммммммммммммяммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╩
*╨ Nombre        Ё cpiivpui.prg                                                ╨
*гдддддддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╤
*╨ Sistema       Ё Control de producci╒n industrial.                           ╨
*гдддддддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╤
*╨ Autor         Ё VETT                   Telf: 4841538                        ╨
*гдддддддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╤
*╨ Ciudad        Ё LIMA , PERU                                                 ╨
*гдддддддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╤
*╨ Direcci╒n     Ё Av. Bertello 170 - 401 Ciudad Satelite Sta. Rosa. - Callao  ╨
*гдддддддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╤
*╨ Prop╒sito     Ё Inf. variacion de precio de insumos por meses.              ╨
*гдддддддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╤
*╨ Creaci╒n      Ё 15/04/96                                                    ╨
*гдддддддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╤
*╨ Actualizaci╒n Ё                                                             ╨
*╨               Ё                                                             ╨
*хмммммммммммммммоммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪

*=F1_BASE(GsNomCia,GsSistema,"USUARIO:"+GsUsuario,GsPeriodo)

*DO AbrirDbfs

PUBLIC LsLinTot,LsLinFam,LsEncab1,LsEncab2,LsEncab3,LsEncab4,m.codmon,m.AnoRef,;
m.MesRef,m.QueAnoMes,aPeriodo,m.CodMatD,m.CodMatH

*IF NOT WEXIST("csmomatdir") ;
 OR UPPER(WTITLE("CSMOMATDIR")) == "CSMOMATDIR.PJX" ;
 OR UPPER(WTITLE("CSMOMATDIR")) == "CSMOMATDIR.SCX" ;
 OR UPPER(WTITLE("CSMOMATDIR")) == "CSMOMATDIR.MNX" ;
 OR UPPER(WTITLE("CSMOMATDIR")) == "CSMOMATDIR.PRG" ;
 OR UPPER(WTITLE("CSMOMATDIR")) == "CSMOMATDIR.FRX" ;
 OR UPPER(WTITLE("CSMOMATDIR")) == "CSMOMATDIR.QPR"
* DEFINE WINDOW csmomatdir ;
  FROM INT((SROW()-13)/2),INT((SCOL()-70)/2) ;
  TO INT((SROW()-13)/2)+12,INT((SCOL()-70)/2)+69 ;
  TITLE "VARIACION MENSUAL DE PRECIO UNITARIO DE INSUMOS" ;
  FLOAT ;
  NOCLOSE ;
  SHADOW ;
  NOMINIMIZE ;
  DOUBLE ;
  COLOR SCHEME 1
*ENDIF
*IF WVISIBLE("csmomatdir")
* ACTIVATE WINDOW csmomatdir SAME
*ELSE
* ACTIVATE WINDOW csmomatdir NOSHOW
*ENDIF
**m.Subalm  = SPACE(LEN(CALM.SUBALM))

*m.CodMatD = SPACE(LEN(CATG.COdMat))
*m.CodMatH = SPACE(LEN(CATG.CodMat))
STORE [] TO LsLinTot,LsLinFam,LsEncab1,LsEncab2,LsEncab3,LsEncab4
m.codmon  = 1
m.AnoRef  = _ANO
m.MesRef  = _MES
m.QueAnoMes = 1
DIMENSION aPeriodo(12)
STORE [] TO aPeriodo

=SelecMes()
DO FORM cpi_cpiivpui
*m.Control = 1
*SELE CATG
*SET RELA TO GsClfDiv+LEFT(CodMat,GnLenDiv) INTO DIVF
*SET FILTER TO DIVF.TIPFAM = 1

*

*@ 01,06 SAY [Cod. Mat. Desde :] GET m.CodMatD VALID F1_Busca(m.CodMatD,"CODMAT","CATG","CATG",[],.T.,[pDescri])
*@ 03,06 SAY [Cod. Mat. Hasta :] GET m.codMatH VALID F1_Busca(m.CodMatH,"CODMAT","CATG","CATG",[],.T.,[pDescri])
*@ 05,06 SAY [Moneda          :] GET m.CodMon  PICTURE "@*RHN S/.;US$" SIZE 1,7,0
*@ 07,06 SAY [Referencia      :] GET m.QueAnoMes ;
  	PICTURE "@^" ;
  	FROM aPeriodo ;
  	SIZE 3,12 ;
  	DEFAULT 1 ;
  	WHEN SelecMes()

*@ 10,24 GET m.control PICT "@*HT \<Aceptar;\<Cancelar" SIZE 1,10,4 DEFAULT 1

*IF NOT WVISIBLE("csmomatdir")
* ACTIVATE WINDOW csmomatdir
*ENDIF

*READ CYCLE
*UltTecla = LASTKEY()
*IF m.Control = 2
*   UltTecla = K_ESC
*ENDIF
*IF UltTecla # K_ESC
*   DO GenTempo
*   DO Imprimir
*ENDIF

*Ven_Actual = woutput()
*IF !EMPTY(Ven_Actual)
*    DEACTIVATE WINDOW (Ven_Actual)
*    RELEASE WINDOW (Ven_actual)
*ENDIF
*CLOSE DATA
RETURN
*******************
PROCEDURE AbrirDbfs
*******************
=F1QEH("ABRE_DBF")
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
USE ALMESTCM ORDER ESTA03 ALIAS ESTA
IF !USED()
   RETURN .F.
ENDIF
Arch = PathUser+SYS(3)
SELE 0
CREATE TABLE &Arch. (CodMat C(8) ,C01 N(14,2) , C02 N(14,2) , C03 N(14,2), ;
                   C04 N(14,2) ,  C05 N(14,2) , C06 N(14,2) , C07 N(14,2), ;
                   C08 N(14,2) ,  C09 N(14,2) , C10 N(14,2) , C11 N(14,2), ;
                   C12 N(14,2) , ;
                   V01 N(14,2) ,  V02 N(14,2) , V03 N(14,2) , V04 N(14,2), ;
                   V05 N(14,2) ,  V06 N(14,2) , V07 N(14,2) , V08 N(14,2), ;
                   V09 N(14,2) ,  V10 N(14,2) , V11 N(14,2) , V12 N(14,2), ;
                   TOTCOM N(14,2), TOTVAL N(14,2) )

USE &Arch. ALIAS TEMPO EXCLU
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
INDEX ON CODMAT TAG TEMP01
SET ORDER TO TEMP01

=F1QEH("OK")
RETURN .T.
*****************
PROCEDURE pDescri
*****************
DO CASE
   CASE UPPER(VARREAD())=[CODMATD]
        @ 1,24+GaLenCod(3)+1    SAY CATG.DesMAT SIZE 1,30
   CASE UPPER(VARREAD())=[CODMATH]
        @ 3,24+GaLenCod(3)+1    SAY CATG.DesMat SIZE 1,30
ENDCASE
******************
PROCEDURE GenTempo  && Carga informaci╒n al archivo temporal
******************
=F1QEH("PROC_INFO")
**DO SelecMes
SELE CATG
SET FILTER TO
SET RELA TO
** ARMAR LOS TEST DE IMPRESION **
m.CodMatD = TRIM(m.CodMatD)
m.CodMatH = TRIM(m.CodMatH)+CHR(255)
IF EMPTY(m.CodMatD)
   GO TOP
ELSE
   SEEK m.CodmatD
   IF !FOUND()
      IF RECNO(0)>0
         GO RECNO(0)
         IF DELETED()
            SKIP
         ENDIF
      ENDIF
   ENDIF
ENDIF
SCAN WHILE  CodMat>=m.CodMatD AND CodMat<=m.CodMatH
     =SEEK(GsClfDiv+LEFT(CodMat,GnLenDiv),[DIVF])
     *IF DIVF.TipFam#1&&AMAA 27-02-07
     *   LOOP
     *ENDIF
     WAIT CodMat+[ ]+Desmat NOWAIT WINDOW
     m.CodMat=CodMat
     FOR TnMes = 1 TO 12
         LsAnoMes = PADR(aPeriodo(TnMes),LEN(ESTA.Periodo))
         STORE 0 TO m.CanIng,m.CanSal,m.VCtIng,m.VCtSal
         SELE ESTA
         SEEK GaClfDiv(1)+m.CodMat+LsAnoMes
         SCAN WHILE CodMat=m.CodMat AND ClfDiv=GaClfDiv(1) AND Periodo=LsAnoMes
              m.CanSal = m.CanSal + CanSal
              m.CanIng = m.CanIng + CanIng
              m.VctSal = m.VctSal + IIF(m.CodMon=1,VSalMn,VSalUs)
              m.VctIng = m.VctIng + IIF(m.CodMon=1,VIngMn,VIngUs)
         ENDSCAN
         SELE TEMPO
         SEEK m.CodMat
         IF !FOUND()
            APPEND BLANK
            REPLACE CodMat WITH m.CodMat
         ENDIF
         LsMes = TRAN(TnMes,"@L ##")
         Campo1 = "C"+LsMes
         Campo2 = "V"+LsMes
         REPLACE &Campo1. WITH &Campo1. + m.CanSal - m.CanIng
         REPLACE &Campo2. WITH &Campo2. + m.VctSal - m.VctIng
         REPLACE TOTCOM WITH TOTCOM + m.CanSal - m.CanIng
         REPLACE TOTVAL WITH TOTVAL + m.VctSal - m.VctIng
     ENDFOR
     SELE CATG
ENDSCAN
=F1QEH("OK")
RETURN
******************
PROCEDURE Imprimir
******************
SELE CATG
SET FILTER TO
SET RELA TO
SELE TEMPO
GO TOP
SET RELA TO CODMAT INTO CATG
SET RELA TO GSCLFDIV+LEFT(CODMAT,GSLENDIV) INTO DIVF ADDITIVE
IF EOF()
   GsMsgErr = [Fin de Archivo]
   DO f1msgerr WITH gsmsgerr
   RETURN
ENDIF
PRIVATE K
FOR K = ALEN(aPeriodo) TO 1 STEP -1
    LsEncab1 = LsEncab1 + REPLI('-',12)
    LsEncab2 = LsEncab2 + PADC(TRIM(LEFT(MES(VAL(SUBS(aPeriodo(K),5,2)),1),3))+[ ]+TRIM(SUBST(aPeriodo(K),1,4)),18)
    LsEncab3 = LsEncab3 + PADC([ P.Uni.    Difer. ],18)
    LsEncab4 = LsEncab4 + REPLI('-',12)
ENDFOR
FOR KK = 1 TO 12
    LsLinTot=LsLinTot + [       ]+[ ]+[=======]+[  ]
    LsLinFam=LsLinFam + [       ]+[ ]+[-------]+[  ]
ENDFOR
LsLinTot = LsLinTot+[         ]+[ ]+[=========]
LsLinFam = LsLinFam+[         ]+[ ]+[---------]

**
Largo = 66
IniPrn = [_Prn0+_Prn5a+CHR(Largo)+_Prn5b+_Prn4]
sNomRep = "Cpiivpui"
DO F0print WITH "REPORTS"
RETURN
********************
******************
PROCEDURE SelecMes
******************
PRIVATE K,J
STORE [] TO aPeriodo
** Meses del a╓o actual **
FOR K = 1 TO m.MesRef
    LnMes = 1 + m.MesRef - K
    aPeriodo(K) = TRAN(m.AnoRef,"9999")+TRAN(LnMes,"@L ##")
ENDFOR
IF m.MesRef = 12
   RETURN
ENDIF
** Meses del a╓o anterior **
FOR J = m.MesRef+ 1 TO 12
    LnMes = m.MesRef + 1 + (12 - J)
    aPeriodo(J) = TRAN(m.AnoRef-1,"9999")+TRAN(LnMes,"@L ##")
ENDFOR
RETURN
*************
FUNCTION _PUN  && Precio Unitario
*************
PARAMETER nPos
private LfPreUNi,LfUNiRef,LfDifer,LsCan,LsVal
LsCan = [C]+TRAN(nPos,"@L ##")
LsVal = [V]+TRAN(nPos,"@L ##")
LfPreUni = IIF(&LsCan.>0,ROUND(&LsVal./&LsCan.,2),0)
RETURN LfPreUni
*****************
FUNCTION _PUniRef
*****************
LsCan = [C]+TRAN(m.QueAnoMes,"@L ##")
LsVal = [V]+TRAN(m.QueAnoMes,"@L ##")
LfPreUni = IIF(&LsCan.#0,ROUND(&LsVal./&LsCan.,2),0)
RETURN LfPreUni
*************
FUNCTION _Por   && Porcentaje
*************
PARAMETER nPos
private LfPreUNi,LfUNiRef,LfDifer,LfPorcen

LfPreUNi = _PUN(nPos)
LfUniRef = _PUN(m.QueAnoMes)
LfDifer  = _DIF(nPos)
LfPorcen = IIF(LfUniRef#0,ROUND(LfDifer/LfUniRef,2)*100,0)

RETURN LfPorCen
***************
FUNCTION _DIF
***************
PARAMETER nPos
IF _PUN(nPos)=0 OR _PUN(m.QueAnoMes)=0
   RETURN 0
ENDIF
RETURN (_PUN(nPos) - _PUN(m.QueAnoMes))


