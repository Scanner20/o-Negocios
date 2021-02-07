PROCEDURE GENBrows
PRIVATE EscLin,EdiLin,BrrLin,InsLin,Xo,Yo,Largo,Ancho,TBorde,Titulo
PRIVATE En1,En2,En3,MaxEle,TotEle
EscLin   = "GENbline"
EdiLin   = "GENbedit"
BrrLin   = "GENbborr"
InsLin   = "GENbinse"
yo       = 09
xo       = 24
Largo    = 15
Ancho    = 45
Xo       = 78 - Ancho
Tborde   = Simple
Titulo   = ""
En1 = " CODIGO     NOMBRE                    "
En2 = ""
En3 = ""
LiUtecla = 0
MaxEle = GiMaxEle
TotEle = 30
PRGFIN = ""
VSombra = .f.
SAVE SCREEN
DO LIB_MTEC WITH 14
DO ABROWSE
RESTORE SCREEN
GiMaxEle = MaxEle
RETURN
******************************************************************************
* Objeto : Escribe una linea del browse
******************************************************************************
PROCEDURE GENbline
PARAMETERS NumEle, NumLin
@ NumLin,Xo+2 SAY AsCodigo(NumEle)
SELECT PERS
SEEK AsCodigo(NumEle)
@ NumLin,Xo+8 SAY NOMBRE()     PICT "@S35"
RETURN
************************************************************************ FIN *
* Objeto : Edita una linea
******************************************************************************
PROCEDURE GENbedit
PARAMETERS NumEle, NumLin
LsCodigo = AsCodigo(NumEle)
UltTecla = 0
i = 1
DO LIB_MTEC WITH 13
DO WHILE  .NOT. INLIST(UltTecla,Escape,Arriba,Abajo,f10,CTRLW)
   DO CASE
      CASE i = 1
         SELECT PERS
         @ NumLin,Xo+2 GET LsCodigo PICT "@!"
         READ
         UltTecla = Lastkey()
         LsCodigo = RIGHT("000000"+ALLTRIM(LsCodigo),LEN(LsCodigo))
         IF UltTecla = Escape
            LOOP
         ENDIF
         IF UltTecla = F8
            IF PLN_PLNBUSCA("PERS")
               LsCodigo = PERS->CodPer
            ENDIF
         ENDIF
         SEEK LsCodigo
         IF .NOT. FOUND()
            DO lib_merr WITH 9 && no registrado
            UltTecla = 0
            LOOP
         ENDIF
         IF UltTecla = Enter
            EXIT
         ENDIF
   ENDCASE
   i = IIF(UltTecla = Izquierda, i-1, i+1)
   i = IIF( i > 1 , 1, i)
   i = IIF( i < 1 , 1, i)
ENDDO
DO LIB_MTEC WITH 14
IF UltTecla <> Escape
   AsCodigo(NumEle) = LsCodigo
ENDIF
RETURN
************************************************************************ FIN *
* Objeto : Borra una linea
******************************************************************************
PROCEDURE GENbborr
PARAMETERS ElePrv, Estado
PRIVATE i
i = ElePrv + 1
DO WHILE i <  MaxEle
   AsCodigo(i) = AsCodigo(i+1)
   i = i + 1
ENDDO
AsCodigo(i) = SPACE(LEN(PERS->CodPer))
Estado = .T.
RETURN
******************************************************************************
* Objeto : Inserta una linea
******************************************************************************
PROCEDURE GENbinse
PARAMETERS ElePrv, Estado
PRIVATE i
i = MaxEle + 1
IF i > TotEle
   Estado = .F.
   RETURN
ENDIF
DO WHILE i > ElePrv + 1
   AsCodigo(i) = AsCodigo(i-1)
   i = i - 1
ENDDO
i = ElePrv + 1
AsCodigo(i) = SPACE(LEN(PERS->CodPer))
Estado = .T.
RETURN
**************************************************************************
PROCEDURE SexPer
****************
RETURN IIF(PERS->SexPer = "F","Femenino","Masculino")

****************
PROCEDURE SitPer
****************
PRIVATE XSITPER
VecOpc(1)= " Activo          "
Vecopc(2)= " Descanso Médico "
VecOpc(3)= " Permiso sin goce"
VecOpc(4)= " Suspendido      "
VecOpc(5)= " Inactivo        "
VecOpc(6)= " Vacaciones      "
VecOpc(7)= " Licencia        "
VecOpc(8)= " Accidente       "
xSitper = VALCAL("@SIT")
IF xSitPer < 2
	xSitPer = 1
ENDIF
IF xSitPer > 0 .and. xSitPer < 8
	RETURN VecOpc(xSitPer)
ENDIF
RETURN ""

**************************************************************************
PROCEDURE EDAD
**************
IF CTOD("  /  /  ") <> PERS->FchNac
   RETURN INT( ( VAL(DTOC(GdFecha,1))-VAL(DTOC(PERS->FchNac,1)) )/10000 )
ELSE
   RETURN 0
ENDIF

**************************************************************************
PROCEDURE EstCvl
****************
DO CASE
  CASE PERS->EstCvl='S'
     RETURN      "Soltero/a   "
  CASE PERS->EstCvl='C'
     RETURN      "Casado/a    "
  CASE PERS->EstCvl='V'
     RETURN      "Viudo/a     "
  CASE PERS->EstCvl='D'
     RETURN      "Divorciado/a"
  CASE PERS->EstCvl='-'
     RETURN      "Conviviente "
ENDCASE

****************
PROCEDURE ValCal
****************
PARAMETER Var,xPer,xMoneda
PRIVATE WKnVal
IF TYPE("Var") <> 'C'
   RETURN 0
ENDIF
xNroPer =XsNroPer
IF TYPE("xPer")="N"
	IF xPer>0
	   xNroPer = TRANSF(xPer,"@L ##")
    ENDIF 
ENDIF
** Planillas expresada en Dolares
IF TYPE("xMoneda")#[N] AND TYPE([XnMonPln])=[N]
	xMoneda=XnMonPln
ENDIF


WKnVal = 0
DO CASE
   CASE Var = "A"
      xLlave = SPACE(1+Len(DMOV->NroPer))+SPACE(Len(DMOV->CodPer))
      =SEEK(xLlave+Var,"DMOV")
      WKnVaL = DMOV->ValCal
   OTHER
      xLlave = XsCodPln+xNroPer+PERS->CodPer+Var
      m.cursel = select()
      SELECT DMOV
      SEEK xLlave
      DO WHILE CodPln+NroPer+CodPer+CodMov = xLlave .AND. ! EOF()
         WKnVaL = WKnVaL + DMOV->ValCal
         SKIP
      ENDDO
      SELECT (m.cursel)
ENDCASE
**
IF TYPE("xMoneda")=[N]
	IF xMoneda=2 AND TYPE([XfTpoCmb])=[N]
		WKnVal = IIF(XfTpoCmb<=0,WknVal,ROUND(WKnVal/XfTpoCmb,2))			
	ENDIF
ENDIF
**
RETURN WKnVal
**************************************************************************
PROCEDURE ValAnt
****************
PARAMETER Var
PRIVATE WKnVal
IF TYPE("Var") <> 'C'
   RETURN 0
ENDIF
xNroPer =VAL(XsNroPer)-1
xNroPer = TRANSF(xNroPer,"@L ##")
WKnVal = 0
DO CASE
   CASE Var = "A"
      xLlave = SPACE(1+Len(DMOV->NroPer))+SPACE(Len(DMOV->CodPer))
      =SEEK(xLlave+Var,"DMOV")
      WKnVaL = DMOV->ValCal
   OTHER
      xLlave = XsCodPln+xNroPer+PERS->CodPer+Var
      m.cursel = select()
      SELECT DMOV
      SEEK xLlave
      DO WHILE CodPln+NroPer+CodPer+CodMov = xLlave .AND. ! EOF()
         WKnVaL = WKnVaL + DMOV->ValCal
         SKIP
      ENDDO
      SELECT (m.cursel)
ENDCASE
RETURN WKnVal
**************************************************************************
PROCEDURE ValAnt2
****************
PARAMETER Var,N
PRIVATE WKnVal
IF TYPE("Var") <> 'C'
   RETURN 0
ENDIF
xNroPer =VAL(XsNroPer)-N
xNroPer = TRANSF(xNroPer,"@L ##")
WKnVal = 0
DO CASE
   CASE Var = "A"
      xLlave = SPACE(1+Len(DMOV->NroPer))+SPACE(Len(DMOV->CodPer))
      =SEEK(xLlave+Var,"DMOV")
      WKnVaL = DMOV->ValCal
   OTHER
      xLlave = XsCodPln+xNroPer+PERS->CodPer+Var
      m.cursel = select()
      SELECT DMOV
      SEEK xLlave
      DO WHILE CodPln+NroPer+CodPer+CodMov = xLlave .AND. ! EOF()
         WKnVaL = WKnVaL + DMOV->ValCal
         SKIP
      ENDDO
      SELECT (m.cursel)
ENDCASE
RETURN WKnVal
**************************************************************************
PROCEDURE ValAcm
****************
PARAMETER Var,xPer
PRIVATE WKnVal,xNroPer
IF TYPE("Var") <> 'C'
   RETURN 0
ENDIF
WKnVal = 0
xNroPer = VAL(XsNroPer)
IF TYPE("xPer")="N"
   xNroPer = xPer
ENDIF
FOR i = 1 to xNroPer
   LsNroPer = TRANSF(i,"@L ##")
   =SEEK(XsCodPln+LsNroPer+PERS->CodPer+Var,"DMOV")
   WKnVaL = WKnVaL + DMOV->ValCal
ENDFOR
RETURN WKnVal
**************************************************************************
PROCEDURE SUMANT
****************
PARAMETER Var
PRIVATE WKnVal
IF TYPE("Var") <> 'C'
   RETURN 0
ENDIF
WKnVal = 0
FOR i = 1 to VAL(XsNroPer)-1
   LsNroPer = TRANSF(i,"@L ##")
   =SEEK(XsCodPln+LsNroPer+PERS->CodPer+Var,"DMOV")
   WKnVaL = WKnVaL + DMOV->ValCal
ENDFOR
RETURN WKnVal
************************************************************************
* CONVIERTE FORMATO   HH.MM   A HORAS
************************************************************************
PROCEDURE HORAS
PARAMETERS WKnVal
RETURN  ( INT(WknVal)*60 + (WknVal - INT(WknVal))*100 )/60
************************************************************************
* NOMBRE
************************************************************************
PROCEDURE NOMBRE
PARAMETER ZNOMPER
IF TYPE("ZNOMBRE") <> "C"
	ZNOMPER = PERS->NOMPER
ENDIF
RETURN  PADR(TRIM(SUBSTR(ZNomPer,1,20))+" "+TRIM(SUBSTR(ZNomPer,21,20))+" "+TRIM(SUBSTR(ZNomPer,41)),40)
************************************************************************
* AFP
************************************************************************
PROCEDURE AFP
RETURN  VAL(PERS->CODAFP)
************************************************************************
* NHIJOS
************************************************************************
PROCEDURE NHIJOS
RETURN PERS->NHIJOS
************************************************************************
* @VENTAS()
************************************************************************
PROCEDURE VENTAS
RETURN VAL(PERS->Nplaza)
************************************************************************
* CODPLN
************************************************************************
PROCEDURE CODPLN
RETURN  VAL(PERS->CODPLN)
************************************************************************
* SCTR
************************************************************************
PROCEDURE SCT
RETURN  VAL(PERS->CODSCT)
************************************************************************
* ESS
************************************************************************
PROCEDURE ESS
RETURN  VAL(PERS->CODESS)


************************************************************************
*@CCOSTO()
************************************************************************
PROCEDURE CCOSTO
RETURN  VAL(PERS->CTACTS)
************************************************************************

************************************************************************
* DIAS DE GRATIFICACION
************************************************************************
FUNC DGRAT
**********
PRIV XFECHA,DD
IF VALCAL("@SIT")=5
   RETU (0)
ENDI
do case
   case val(xsnromes)=07
        xFECHA = CTOD('30/06/'+ STR(YEAR(DATE()),4,0))
        dAdi=iif(inlist(month(pers.fching),02,06),1,0)
   case val(xsnromes)=12
        xFECHA = CTOD('31/12/'+ STR(YEAR(DATE()),4,0))
        dAdi=iif(inlist(month(pers.fching),12),1,0)
endcase
DD = XFECHA-PERS.FchIng &&FCHING
DD = DD +dAdi
IF DD>179
   DD=180
ENDIF
RETU(DD)


************************************************************************
* DIAGRA()
************************************************************************
PROCEDURE DIAGRA
DO CASE
   CASE XSNROPER="07"
        RETU ({^1998-06-30}-PERS.FCHING) + iif(inlist(month(pers.fching),02,06),1,0)
   CASE XSNROPER="12"
        RETU ({^1998-12-31}-PERS.FCHING)+iif(inlist(month(pers.fching),12),1,0)
ENDCASE


************************************************************************
* PROMEDIOS PARA GRATIFICACION
************************************************************************
FUNC SUMGRA
****************
PARAMETER Var
PRIVATE WKnVal
IF TYPE("Var") <> 'C'
   RETU (0)
ENDIF
WKnVal = 0
PRIV XCONTA
XCONTA = 0
FOR i = XSINIGRA to XSFINGRA
   LsNroPer = TRANSF(i,"@L ##")
   =SEEK(XsCodPln+LsNroPer+PERS.CodPer+Var,"DMOV")
   WKnVaL = WKnVaL + DMOV.ValCal
   IF FOUN('DMOV')
      XCONTA = XCONTA + 1
   ENDI
ENDFOR
IF XCONTA >0
   RETURN (WKnVal/XCONTA)
ENDI
RETU (0)
*****************
FUNC SUMGRA2
****************
PARAMETER Var
PRIVATE WKnVal
IF TYPE("Var") <> 'C'
   RETU (0)
ENDIF
WKnVal = 0
PRIV XCONTA
XCONTA = 0
FOR i = 6 to 11
   LsNroPer = TRANSF(i,"@L ##")
   =SEEK(XsCodPln+LsNroPer+PERS.CodPer+Var,"DMOV")
   WKnVaL = WKnVaL + DMOV.ValCal
   IF FOUN('DMOV')
      XCONTA = XCONTA + 1
   ENDI
ENDFOR
**IF XCONTA >0
**   RETURN (WKnVal/XCONTA)
**ENDI
**RETU (0)
RETURN WKNVAL


************************************************************************
* PROMEDIOS PARA VACACIONES
************************************************************************
FUNC SUMVAC
****************
PARAMETER Var
PRIVATE WKnVal
IF TYPE("Var") <> 'C'
   RETU (0)
ENDIF
WKnVal = 0
PRIV XCONTA
XCONTA = 0
PRIV XSINIGRA,XSFINGRA
XSINIGRA = 0
IF XSCODPLN = '1'
   XSINIGRA = XsNroPer-6
 ELSE
   XSINIGRA = XsNroPer-(6*4)
ENDI
FOR i = XSINIGRA to XSFINGRA
   LsNroPer = TRANSF(i,"@L ##")
   =SEEK(XsCodPln+LsNroPer+PERS.CodPer+Var,"DMOV")
   WKnVaL = WKnVaL + DMOV.ValCal
   IF FOUN('DMOV')
      XCONTA = XCONTA + 1
   ENDI
ENDFOR
IF XCONTA >0
   RETURN (WKnVal/XCONTA)
ENDI
RETU (0)





************************************************************************
*tiempo de servicio PARA CTS
************************************************************************
FUNCTION TMPAMD
PARA XOPC,XVFECINI,XVFECFIN
*OPC  = 1  DEVUELVE EL NUMERO DE ANOS
*OPC  = 2  DEVUELVE EL NUMERO DE MESES
*OPC  = 3  DEVUELVE EL NUMERO DE DIAS
PRIV MESI,SERV,DIAS,XFECHA
MESI = 0
IF EMPT(XVFECINI)
   RETU (0)
ENDI
PRIV SERV,DIAS,MESE
Serv = INT( ( VAL(DTOC(XVFECFIN,1))-VAL(DTOC(XVFECINI,1)) )/10000 )
IF DAY(XVFECFIN)>DAY(XVFECINI)
   Dias = DAY(XVFECFIN) - DAY(XVFECINI)
   Mese = MONTH(XVFECFIN)
 ELSE
   Dias = DAY(XVFECFIN - DAY(XVFECFIN)) + DAY(XVFECFIN) - DAY(XVFECINI)
   Mese = MONTH(XVFECFIN) - 1
ENDIF
IF Mese>=MONTH(XVFECINI)
   Mesi = Mese - MONTH(XVFECINI)
 ELSE
   Mesi = Mese - MONTH(XVFECINI) + 12
ENDIF

IF DIAS >= 30
   DIAS = 0
   MESI = MESI + 1
   IF MESI >= 12
      MESI = 0
      SERV = SERV + 1
   ENDI
ENDI
IF MESI >= 12
   MESI = 0
   SERV = SERV + 1
ENDI

DO CASE
   CASE XOPC = 1
        RETU SERV
   CASE XOPC = 2
        RETU MESI
   CASE XOPC = 3
        RETU DIAS
ENDC
RETU 0





************************************************************************
*tiempo de servicio solo devuelve el numero de meses
************************************************************************
FUNCTION TMPMES
PRIV MESI
MESI = 0
IF EMPT(PERS.FchIng)
   RETU (0)
ENDI
PRIV SERV,DIAS,MESE
Serv = INT( ( VAL(DTOC(DATE(),1))-VAL(DTOC(PERS.FchIng,1)) )/10000 )
IF DAY(DATE())>DAY(PERS.FchIng)
   Dias = DAY(DATE()) - DAY(PERS.FchIng)
   Mese = MONTH(DATE())
 ELSE
   Dias = DAY(DATE() - DAY(DATE())) + DAY(DATE()) - DAY(PERS.FchIng)
   Mese = MONTH(DATE()) - 1
ENDIF
IF Mese>=MONTH(PERS.FchIng)
   Mesi = Mese - MONTH(PERS.FchIng)
 ELSE
   Mesi = Mese - MONTH(PERS.FchIng) + 12
ENDIF
RETU ((SERV*12)+MESI)
******************
PROCEDURE PRMVAR_X
******************
PARAMETER Var
PRIVATE WKnVal,NroProm,wRecord,SaveComp,mCurrArea
IF TYPE("Var") <> 'C'
   RETURN 0
ENDIF
IF SET('COMPATIBLE') = 'ON'	
	SET COMPATIBLE OFF	
	SaveComp = 'ON'	
ELSE				
	SaveComp = 'OFF'
ENDIF
SET COMPATIBLE OFF
mCurrArea=Selec()
STORE 0 TO WKnVal,NroProm,I
xNroPer =VAL(XsNroPer)-6
IF xNroPer <=0
   xNroPer=12-ABS(xNroPer)
   LsCodCia = "cia"+GsCodCia
   LsMovtCia  =PathDef+"\"+LsCodCia+"\C"+LTRIM(STR(PlnNroAno-1))+"\PLNDMOVT.DBF"
   IF FILE(LsMovtCia)
      Sele 0
      Use &LsMovtCia order DMOV01 ALIAS TMPDMOV
      SELE TMPDMOV
      FOR I=XNroPer TO 12
          XlPeri=TRANSF(I,"@L ##")
          xLlave = XsCodPln+XlPeri+PERS->CodPer+Var
          SEEK xLlave
          If Found()
             WKnVal=WKnVal+ValCal
             NroProm=NroProm+IIF(VALCAL>0,1,0)
          EndIf
      ENDFOR
      USE
      IF XNroPer>7
         SELE DMOV
         FOR I=1 TO XNroPer-7
             XlPeri=TRANSF(I,"@L ##")
             xLlave = XsCodPln+XlPeri+PERS->CodPer+Var
             SEEK xLlave
             If Found()
                WKnVal=WKnVal+ValCal
                NroProm=NroProm+IIF(VALCAL>0,1,0)
             EndIf
         ENDFOR
      ENDIF
      WKnVal=IIF(NroProm>0,ROUND(WKnVal/NroProm,2),0)
   ENDIF
ELSE
   SELE DMOV
   wRecord=Recno()
   FOR I=XNroPer TO XNroPer+5
       XlPeri=TRANSF(IIF(I>12,I-12,I),"@L ##")
       xLlave = XsCodPln+XlPeri+PERS->CodPer+Var
       SEEK xLlave
       If Found()
          WKnVal=WKnVal+ValCal
          NroProm=NroProm+IIF(VALCAL>0,1,0)
       EndIf
   ENDFOR
   WKnVal=IIF(NroProm>0,ROUND(WKnVal/NroProm,2),0)
   IF BETW(wRecord,1,RECC())
      Go wRecord
   ENDI
ENDIF
Sele (mCurrArea)
SET COMPATIBLE &SaveComp
RETURN WKnVal
****************
PROCEDURE FValCal
****************
PARAMETER Var,xPer,SAREA
PRIVATE WKnVal
IF TYPE("Var") <> 'C'
	RETURN 0
ENDIF
xNroPer =XsNroPer
IF TYPE("xPer")="N"
	xNroPer = TRANSF(xPer,"@L ##")
ENDIF
WKnVal = 0
DO CASE
	CASE Var = "A"
		xLlave = SPACE(1+Len(&sArea..NroPer))+SPACE(Len(&sArea..CodPer))
		=SEEK(xLlave+Var,sArea)
		WKnVaL = &sArea..ValCal
	OTHER
		xLlave = XsCodPln+xNroPer+PERS->CodPer+Var
		m.cursel = select()
		SELECT (sArea)
		SEEK xLlave
		DO WHILE CodPln+NroPer+CodPer+CodMov = xLlave .AND. ! EOF()
			WKnVaL = WKnVaL + &sArea..ValCal
			SKIP
		ENDDO
		SELECT (m.cursel)
ENDCASE
RETURN WKnVal
***************
FUNCTION PRMSAL
***************
PARAMETER NPERINI,NPERFIN,XVAR
PRM=0
FOR K=NPERINI TO NPERFIN
	PRM=PRM+VALCAL(XVAR,K)
ENDFOR
RETURN PRM
***************
FUNCTION SEMGRA
***************
PRIV XFECHA1,DD1
IF VALCAL("@SIT")=5
   RETU (0)
ENDI
do case
   case val(xsnromes)=07
        xFECHA1 = CTOD('30/06/'+ STR(YEAR(DATE()),4,0))
        dAdi1=iif(inlist(month(pers.fching),02,06),1,0)
   case val(xsnromes)=12
        xFECHA1 = CTOD('31/12/'+ STR(YEAR(DATE()),4,0))
        dAdi1=iif(inlist(month(pers.fching),12),1,0)
endcase
DD1 = XFECHA1-PERS.FchIng &&FCHING
DD1 = DD1 +dAdi1
IF DD1>179
   DD1=180
ENDIF
DDS=DD1/7
N=31
XSCODMOV=[RD01]
NROSEM=0
FOR M=1 TO INT(DDS)
	SELE DMOV
	LLAVE_S=XSCODPLN+TRANS(N,[@L ##])+PERS.CODPER+XSCODMOV
	SEEK LLAVE_S
	IF FOUND()
		NROSEM=NROSEM+1
	ENDIF
	N=N+1
ENDFOR
RETU(NROSEM)
