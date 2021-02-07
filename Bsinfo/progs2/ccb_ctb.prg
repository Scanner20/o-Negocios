**********************************************************************
*  Nombre        : ccb_ctb.prg
*  Sistema       : Caja y Bancos
*  Proposito     : Rutinas Contables para Caja
*  Creacion      : 01/08/94
*  Actualizacion : VETT - 2000
***************************************************************************

************************************************************************ FIN *
* Objeto : Verificar si debe generar cuentas autom ticas
******************************************************************************
PROCEDURE MovbVeri
XiNroItm = XiNroItm + 1
GOSVRCBD.MovbVeri(XsNroMes+XsCodOpe+XsNroAst+STR(XiNroItm,5),0,'','')
*!*	**** Grabando la linea activa ****
*!*	XcEliItm = " "
*!*	DO movbgrab IN ccb_ctb
*!*	RegAct = RECNO()
*!*	*** Requiere crear cuentas automaticas ***
*!*	=SEEK(XsCodCta,"CTAS")
*!*	IF CTAS->GenAut <> "S"
*!*	   RETURN
*!*	ENDIF
*!*	**** Actualizando Cuentas Autom ticas ****
*!*	XcEliItm = "*"
*!*	TsClfAux = ""
*!*	TsCodAux = ""
*!*	TsAn1Cta = CTAS->AN1CTA
*!*	TsCC1Cta = CTAS->CC1Cta
*!*	  ** Verificamos su existencia **
*!*	IF ! SEEK(TsAn1Cta,"CTAS")
*!*	   GsMsgErr = "Cuenta Autom tica no existe. Actualizaci¢n queda pendiente"
*!*	   DO LIB_MERR WITH 99
*!*	   RETURN
*!*	ENDIF
*!*	IF ! SEEK(TsCC1Cta,"CTAS")
*!*	   GsMsgErr = "Cuenta Autom tica no existe. Actualizaci¢n queda pendiente"
*!*	   DO LIB_MERR WITH 99
*!*	   RETURN
*!*	ENDIF
*!*	*****
*!*	SKIP
*!*	** Grabando la primera cuenta autom tica **
*!*	XiNroItm = XiNroItm + 1
*!*	XsCodCta = TsAn1Cta
*!*	XcTpoMov = IIF(XcTpoMov = 'D' , 'D' , 'H' )
*!*	XsClfAux = TsClfAux
*!*	XsCodAux = TsCodAux
*!*	DO MOVbGrab             IN ccb_ctb
*!*	SKIP
*!*	** Grabando la segunda cuenta autom tica **
*!*	XiNroItm = XiNroItm + 1
*!*	XsCodCta = TsCC1Cta
*!*	XcTpoMov = IIF(XcTpoMov = 'D' , 'H' , 'D' )
*!*	XsClfAux = SPACE(LEN(RMOV->ClfAux))
*!*	XsCodAux = SPACE(LEN(RMOV->CodAux))
*!*	DO movbgrab IN ccb_ctb
RETURN
**********************************************************************
* Objeto : Grabar los registros
******************************************************************************
PROCEDURE MOVbgrab

SELE RMOV
APPEND BLANK
IF ! Rec_Lock(5)
   RETURN
ENDIF
XsCodRef = ""
IF SEEK(XsCodCta,"CTAS")
   IF CTAS->MAYAUX = "S"
      XsCodRef = PADR(XsCodAux,LEN(RMOV->CodRef))
   ENDIF
ENDIF
REPLACE RMOV->NroMes WITH XsNroMes
REPLACE RMOV->CodOpe WITH XsCodOpe
REPLACE RMOV->NroAst WITH XsNroAst
REPLACE VMOV->NroItm WITH VMOV->NroItm + 1
REPLACE RMOV->NroItm WITH VMOV.NroItm
REPLACE RMOV->EliItm WITH XcEliItm
REPLACE RMOV->FchAst WITH XdFchAst
IF TYPE("NROVOU")="C"
	REPLACE RMOV->NroVou WITH XsNroVou
ENDIF
REPLACE RMOV->CodMon WITH XiCodMon
REPLACE RMOV->TpoCmb WITH XfTpoCmb
REPLACE RMOV->FchDoc WITH XdFchAst
REPLACE RMOV->CodCta WITH XsCodCta
REPLACE RMOV->CodRef WITH XsCodRef
REPLACE RMOV->ClfAux WITH XsClfAux
REPLACE RMOV->CodAux WITH XsCodAux
REPLACE RMOV->TpoMov WITH XcTpoMov
*IF CodMon = 1
*   REPLACE RMOV->Import WITH XfImport
*   IF TpoCmb = 0
*      REPLACE RMOV->ImpUsa WITH 0
*    ELSE
*      REPLACE RMOV->ImpUsa WITH round(XfImport/TpoCmb,2)
*   ENDIF
*ELSE
*   REPLACE RMOV->Import WITH round(XfImport*TpoCmb,2)
*   REPLACE RMOV->ImpUsa WITH XfImport
*ENDIF
REPLACE RMOV->Import WITH XfImport
REPLACE RMOV->ImpUsa WITH XfImpUsa
REPLACE RMOV->GloDoc WITH XsGloDoc
REPLACE RMOV->CodDoc WITH XsCodDoc
REPLACE RMOV->NroDoc WITH XsNroDoc
REPLACE RMOV->NroRef WITH XsNroRef
REPLACE RMOV->FchDoc WITH XdFchDoc
REPLACE RMOV->FchVto WITH XdFchVto
REPLACE VMOV->ChkCta  WITH VMOV->ChkCta+VAL(TRIM(XsCodCta))
replace Rmov.fchdig  with date()
replace Rmov.hordig  with time() 

IF ! XsCodOpe = "9"
   DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , Import , ImpUsa
ELSE  && EXTRA CONTABLE
   DO CBDACTEC WITH  CodCta , CodRef , _MES , TpoMov , Import , ImpUsa
ENDIF
SELECT RMOV
DO CalImp IN ccb_ctb
IF RMOV->TpoMov = 'D'
   REPLACE VMOV->DbeNac  WITH VMOV->DbeNac+nImpNac
   REPLACE VMOV->DbeUsa  WITH VMOV->DbeUsa+nImpUsa
ELSE
   REPLACE VMOV->HbeNac  WITH VMOV->HbeNac+nImpNac
   REPLACE VMOV->HbeUsa  WITH VMOV->HbeUsa+nImpUsa
ENDIF
SELE RMOV
UNLOCK
RETURN
**********************************************************************
* CALCULO DE IMPORTES
**********************************************************************
PROCEDURE CalImp

nImpNac = Import
nImpUsa = ImpUsa

RETURN
**********************************************************************
* Procedimiento de Borrado ( Auditado ) de un documento
******************************************************************************
PROCEDURE MOVBorra

* * * *
DO LIB_MSGS WITH 10
SELECT RMOV
Llave = (XsNroMes + XsCodOpe + XsNroAst )
SEEK Llave
OK     = .T.
DO WHILE ! EOF() .AND. OK .AND. Llave = (NroMes + CodOpe + NroAst)
   IF RLOCK()
      SELECT RMOV
      IF ! XsCodOpe = "9"
         DO CBDACTCT WITH  CodCta , CodRef , VAL(XsNroMes) , TpoMov , -Import , -ImpUsa
      ELSE
         DO CBDACTEC WITH  CodCta , CodRef , VAL(XsNroMes) , TpoMov , -Import , -ImpUsa
      ENDIF
      SELE RMOV
      DELETE
      UNLOCK
   ELSE
      OK = .f.
   ENDIF
   SKIP
ENDDO
* * * *
SELECT VMOV
IF Ok
   REPLACE FlgEst WITH "A"    && Marca de anulado
ENDIF
DO LIB_MSGS WITH 0
RETURN
************************************************************************** FIN
* Objeto : GENERA ITEM DE DIFERENCIA DE CAMBIO
******************************************************************************
PROCEDURE DIFCMB
****************
** Chequemos moneda de provision en caso que se regrabe el asiento
=SEEK(PADR(XsChkTpoDoc,LEN(PROV.TPODOC)),"PROV")
** 		 

LfImport = 0
LfImpUsa = 0
xCodMon  = 0   && Control Moneda Original
SELECT RMOV
SET ORDER TO RMOV06
Llave = XsCodCta+PADR(XsCodAux,LEN(RMOV.CODAUX))+XsNroDoc
SEEK Llave
DO WHILE ! EOF() .AND. CodCta+CodAux+NroDoc = Llave
   IF CodOpe == PROV->CodOpe OR (NROMES="00"  AND CODOPE="000")
		xCodMon=CodMon	&& Capturo la moneda de la provision
   ENDIF
   ** No contaban con mi astucia...!!Hu#&%nazo!! despues de 5 a¤os me doy
   ** cuenta VETT 11/07/2000
   LfImport = LfImport + IIF(TpoMov="H",-1,1)*Import
   LfImpUsa = LfImpUsa + IIF(TpoMov="H",-1,1)*ImpUsa
   SKIP
ENDDO
SET ORDER TO RMOV01
*** Verificando la cancelaci¢n del documento ***
oK = .T.
IF xCodMon = 1
  *OK = .F.     && NO genero en caso de S/.
   IF ABS(LfImport-IIF(XcTpoMov="H",1,-1)*XfImport) > 0.90   && Ajuste y Matar puchos
      oK = .F.
   ENDIF
ELSE
   IF ABS(LfImpUsa-IIF(XcTpoMov="H",1,-1)*XfImpUsa) > 0.10   && Ajuste y Matar puchos
      oK = .F.
   ENDIF
ENDIF
*** Grabando el Documento ***
IF oK
   XfImpUsa = LfImpUsa
   XfImpNac = LfImport
   IF XcTpoMov = "D"
      XfImpUsa = -LfImpUsa
      XfImpNac = -LfImport
   ENDIF
ENDIF
XiNroItm = XiNroItm + 1
GOSVRCBD.MovbVeri(XsNroMes+XsCodOpe+XsNroAst+STR(XiNroItm,5),0,'','')
IF ! oK
   RETURN
ENDIF
**** Calculando REDONDEO y DIFERENCIA DE CAMBIO ****
IF XiCodMon = 1
   IF TpoMov = "H"
      LfImport = Import - iImport
      LfImpUsa = ImpUsa - ROUND(iImport/XfTpoCmb,2)
   ELSE
      LfImport = - Import - iImport
      LfImpUsa = - ImpUsa - ROUND(iImport/XfTpoCmb,2)
   ENDIF
ELSE
   IF TpoMov = "H"
      LfImport = Import - ROUND(iImport*XfTpoCmb,2)
      LfImpUsa = ImpUsa - iImport
   ELSE
      LfImport = -Import - ROUND(iImport*XfTpoCmb,2)
      LfImpUsa = -ImpUsa - iImport
   ENDIF
ENDIF
***** Grabando el redondeo y el ajuste ****
XcEliItm = ":"
XfImpUsa = LfImpUsa
XfImport = LfImport
XfImpNac = LfImport    && Vett 15/SET/2006
**-------------------*** Vett 24/jun/2000
XfDcbUsa = LfImpUsa
XfDcbNac = LfIMport
**-------------------***  Importes de dif.cmb

IF XfDcbNac # 0
   IF XfDcbNac > 0
      XsCodCta = XsCdCta1
      =SEEK(XsCodCta,"CTAS")
      XsClfAux = CTAS->ClfAux
      XsCodAux = ""
      XcTpoMov = [D]
      **-------------------***
      XfImport = XfDcbNac
      XfIMpUsa = 0
      XfImpNac = XfDcbNac	&& Vett 15/SET/2006
      **-------------------***
   ELSE
      **-------------------***
      XfImpUsa = 0
      XfImport = -XfDcbNac
      XfImpNac = -XfDcbNac	&& Vett 15/SET/2006
      **-------------------***
      XsCodCta = XsCdCta2
      =SEEK(XsCodCta,"CTAS")
      XsClfAux = CTAS->ClfAux
      XcTpoMov = [H]
      XsCodAux = XsCdAux2
   ENDIF
	XiNroItm = XiNroItm + 1
	GOSVRCBD.MovbVeri(XsNroMes+XsCodOpe+XsNroAst+STR(XiNroItm,5),0,'','')

ENDIF
IF XfDcbUsa # 0
   IF XfDcbUsa > 0
      XsCodCta = XsCdCta1
      =SEEK(XsCodCta,"CTAS")
      XsClfAux = CTAS->ClfAux
      XsCodAux = ""
      XcTpoMov = [D]
 	  **-------------------***	  
      XfImpUsa = XfDcbUsa
      XfImport = 0
      XfImpNac = 0	&& Vett 15/SET/2006
      **-------------------***
   ELSE
 	  **-------------------***	  
      XfImpUsa = -XfDcbUsa
      XfImport = 0
      XfImpNac = 0	&& Vett 15/SET/2006
      **-------------------***
      XsCodCta = XsCdCta2
      =SEEK(XsCodCta,"CTAS")
      XsClfAux = CTAS->ClfAux
      XcTpoMov = [H]
      XsCodAux = XsCdAux2
   ENDIF
    XiNroItm = XiNroItm + 1
	GOSVRCBD.MovbVeri(XsNroMes+XsCodOpe+XsNroAst+STR(XiNroItm,5),0,'','')

ENDIF

RETURN

******************
PROCEDURE IMPRVOUC
******************
IF MESSAGEBOX('Desea Imprimir voucher contable',32+4,'ATENCION!!!')=6
	DO IMPRVOUC IN Cbd_DiarioGeneral
ENDIF
*!*	PRIVATE Largo,Ancho,Temp,LinFin
*!*	cTitulo =" "+Mes(VAL(XsNroMes),1)+" "+TRANS(YEAR(DATE()),"9999 ")
*!*	GsMsgErr = "Coloque papel para impresi¢n de voucher contable"
*!*	DO LIB_MERR WITH 99
*!*	SAVE SCREEN TO Temp
*!*	REGACT=RECNO()
*!*	*DO DIRPRINT IN ADMPRINT
*!*	DO f0print
*!*	IF LASTKEY() = ESCAPE_
*!*	   RESTORE SCREEN FROM TEMP
*!*	   RETURN
*!*	ENDIF
*!*	Tit_SIZQ = TRIM(GsNomCia)
*!*	Tit_IIZQ = TRIM(GsDirCia)
*!*	Tit_SDER = "FECHA : "+DTOC(DATE())
*!*	Tit_IDER = ""
*!*	Tit_I_CEN= []
*!*	TITULO   = ""
*!*	SUBTITULO = ""
*!*	IniImp   = _Prn3    && 16.6 cpi
*!*	Largo    = 66
*!*	LinFin   = Largo - 5
*!*	Ancho    = 140
*!*	numpag  = 0
*!*	En1 =[]
*!*	En2 =[]
*!*	En3 =[]
*!*	En4 =[]
*!*	En5 = "***** ********** ************************* ****** ************************************************** ****************** ******************"
*!*	En6 = "COD.                D O C U M E N T O      CUENTA                                                                                         "
*!*	En7 = "AUXI-  N§        ************************* CONTAB               D E S C R I P C I O N                    C A R G O S         A B O N O S  "
*!*	En8 = "LIAR  REFERENCIA Tpo   No.        VENCTO.                                                                                                 "
*!*	En9 = "***** ********** *** ********** ********** ****** ************************************************** ****************** ******************"
*!*	*      12345 1234567890 123 1234567890 1234567890 123456 12345678901234567890123456789012345678901234567890
*!*	*      00    06         17  21         32         43     50                                                 101                120
*!*	SET DEVICE TO PRINTER
*!*	PRINTJOB
*!*	   sKey = XsNroMes+XsCodOpe+XsNroAst
*!*	   =SEEK(sKey,"VMOV")
*!*	   =SEEK(VMOV.CodOpe,'OPER')
*!*	   LsNomOpe=OPER->NomOpe
*!*	   DO MovMemb
*!*	   nDbe = 0
*!*	   nHbe = 0
*!*	   SELECT RMOV
*!*	   cNroChq = []
*!*	   SEEK XsNroMes+XsCodOpe+XsNroAst
*!*	   DO WHILE  ! EOF() .AND. sKey = RMOV->NroMes+RMOV->CodOpe+RMOV->NroAst
*!*	     IF ELIITM#'ú'
*!*	        IF Prow() > (Largo - 4)
*!*	          DO MovMemb
*!*	        ENDIF
*!*	        NumLin = Prow() + 1
*!*	        @ NumLin,00  SAY CodAux
*!*	        @ NumLin,06  SAY NroRef
*!*	        @ NumLin,17  SAY CodDoc
*!*	        @ NumLin,21  SAY NroDoc
*!*	        IF ! EMPTY(FchVto)
*!*	           @ NumLin,32  SAY FchVto
*!*	        ENDIF
*!*	        @ NumLin,43  SAY CodCta
*!*	        =SEEK(ClfAux+CodAux,"AUXI")
*!*	        DO CASE
*!*	           CASE ! EMPTY(RMOV->Glodoc)
*!*	              LsGlodoc = LEFT(RMOV->GloDoc,50)
*!*	           CASE ! EMPTY(VMOV->NotAst)
*!*	              LsGlodoc = LEFT(VMOV->NotAst,50)
*!*	           OTHER
*!*	              LsGlodoc = LEFT(AUXI->NOMAUX,50)
*!*	        ENDCASE
*!*	        IF RMOV->CodMon <> 1
*!*	           LsImport = 'US$' + ALLTRIM(STR(ImpUsa,14,2))
*!*	           IF RIGHT(LsImport,3)=".00"
*!*	              LsImport = '(US$' + ALLTRIM(STR(ImpUsa,14,0))+")"
*!*	           ENDIF
*!*	           LsGloDoc = LEFT(LsGloDoc,50-LEN(LsImport))+LsImport
*!*	        ENDIF
*!*	        @ NumLin,50  SAY LsGloDoc PICT "@S50"
*!*	        DO CalImp
*!*	        IF TpoMov='D'
*!*	           @ NumLin,101 SAY nImpNac PICT "999,999,999.99"
*!*	           nDbe = nDbe + nImpNac
*!*	        ELSE
*!*	           @ NumLin,120 SAY nImpNac PICT "999,999,999.99"
*!*	           nHbe = nHbe + nImpNac
*!*	        ENDIF
*!*	     ENDIF
*!*	     SKIP
*!*	   ENDDO
*!*	   IF Prow() > (Largo - 10)
*!*	     DO MovMemb
*!*	   ENDIF
*!*	   NumLin = PROW() + 2
*!*	   @ NumLin,80  SAY _Prn7a+"TOTALES"+_Prn7B
*!*	   @ NumLin,0  SAY [ ]
*!*	   @ NumLin,101 SAY _Prn6a
*!*	   @ NumLin,101 SAY nDbe PICT "999,999,999.99"
*!*	   @ NumLin,120 SAY nHbe PICT "999,999,999.99"
*!*	   @ NumLin,Ancho-1 SAY _Prn6a
*!*	   DO MovIPie
*!*	ENDPRINTJOB
*!*	EJECT PAGE
*!*	SET DEVICE TO SCREEN
*!*	DO F0PRFIN
*!*	RESTORE SCREEN FROM TEMP
RETURN
**********************************************************************
PROCEDURE MovMemb
*****************
IF NumPag = 0
   @ 0,0 SAY _PRN0+IIF(_PRN5A==[],[],_PRN5a+CHR(Largo)+_PRN5b)
ENDIF
IF NumPag > 0
   NumLin = PROW() + 1
   @ NumLin,80  SAY "VAN ......"
   @ NumLin,116 SAY nDbe PICT "999,999,999.99"
   @ NumLin,134 SAY nHbe PICT "999,999,999.99"
ENDIF
NumPag = NumPag + 1
@ 0,0  SAY IniImp
@ 1,0  SAY _Prn7a+GsNomCia+_Prn7b
@ 2,0  SAY GsDirCia
@ 2,Ancho - 33  SAY "OPERACION  "+_Prn7a+Vmov->CodOpe+_Prn7b
@ 3,0           SAY "REGISTRO "+LsNomOpe
@ 3,Ancho - 33  SAY "ASIENTO    "+_Prn7a+XsNroAst+_Prn7b
@ 4,0           SAY cTitulo
@ 4,Ancho - 54  SAY "MONEDA     "+IIF(Vmov->CodMon=1,"S/.","US$")
@ 4,Ancho - 33  SAY "REFERENCIA "+VMOV->NroVou
@ 5,0           SAY Vmov->NotAst
@ 5,Ancho - 54  SAY "T/C   "+TRAN(VMOV->TpoCmb,"##,###.####")
@ 5,Ancho - 33  SAY "Fecha      "+DTOC(Vmov->FchAst)
@ 6, 0          SAY En5
@ 7, 0          SAY En6
@ 8, 0          SAY En7
@ 9, 0          SAY En8
@ 10,0          SAY En9
IF NumPag > 1
   NumLin = PROW() + 1
   @ NumLin,80  SAY "VIENEN ..."
   @ NumLin,116 SAY nDbe PICT "999,999,999.99"
   @ NumLin,134 SAY nHbe PICT "999,999,999.99"
ENDIF
RETURN
**********************************************************************
PROCEDURE MovIPie
*****************
NumLin = Largo - 7
Pn1 = "   PREPARADO        REVISADO        GERENCIA                                             _________________________________________________________________"
Pn2 = "                                                                                                                  Recibi Conforme                         "
Pn3 = "_______________ _______________ _______________                                          L.E. /L.T. No : _________________________________________________"
Pn4 = PADC(VMOV->Digita,15)
@ NumLin+1,0    SAY Pn1
@ NumLin+2,0    SAY Pn2
@ NumLin+3,0    SAY Pn3
@ NumLin+4,0    SAY Pn4
*@ NumLin+5,0    SAY Pn5
RETURN
**********************************************************************

