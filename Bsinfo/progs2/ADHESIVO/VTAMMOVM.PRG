****************************************************************************
* Programa     : vtammovm.prg
* Sistema      : Ventas
* Autor        : RHC
* Proposito    : Rutinas de Actualizacion Contable Automatica
* Creacion     : 26/07/94
* Parametros   :
* Actualizacion:
****************************************************************************
* Objeto : Actualizacion Contable
******************************************************************************
PROCEDURE MovbVeri

**** Grabando la linea activa ****
DO MOVbGrab
RegAct = RECNO()
*** Requiere crear cuentas automaticas ***
=SEEK(XsCodCta,"CTAS")
IF CTAS->GenAut <> "S"
   RETURN
ENDIF
**** Actualizando Cuentas Autom ticas ****
XcEliItm = "ú"
TsClfAux = "04 "
TsCodAux = CTAS->TpoGto
TsAn1Cta = RMOV->CodAux
TsCC1Cta = CTAS->CC1Cta
** Verificamos su existencia **
IF ! SEEK("05 "+TsAn1Cta,"AUXI")
   GsMsgErr = "Cuenta Autom tica no existe. Actualizaci¢n queda pendiente"
   DO LIB_MERR WITH 99
   RETURN
ENDIF
IF ! SEEK(TsCC1Cta,"CTAS")
   GsMsgErr = "Cuenta Autom tica no existe. Actualizaci¢n queda pendiente"
   DO LIB_MERR WITH 99
   RETURN
ENDIF
*****
SKIP
** Grabando la primera cuenta autom tica **
XiNroItm = XiNroItm + 1
XsCodCta = TsAn1Cta
XcTpoMov = IIF(XcTpoMov = 'D' , 'D' , 'H' )
XsClfAux = TsClfAux
XsCodAux = TsCodAux
DO MOVbGrab
SKIP
** Grabando la segunda cuenta autom tica **
XiNroItm = XiNroItm + 1
XsCodCta = TsCC1Cta
XcTpoMov = IIF(XcTpoMov = 'D' , 'H' , 'D' )
XsClfAux = SPACE(LEN(RMOV->ClfAux))
XsCodAux = SPACE(LEN(RMOV->CodAux))
DO MOVbGrab

RETURN
**********************************************************************
* Objeto : Grabar los registros
******************************************************************************
PROCEDURE MOVbgrab

SELE Item
APPEND BLANK
IF ! Rec_Lock(5)
   RETURN
ENDIF
XsCodRef = ""
IF SEEK(XsCodCta,"CTAS")
   IF CTAS->MAYAUX = "S"
      XsCodRef = PADR(XsCodAux,LEN(Item->CodRef))
   ENDIF
ENDIF
REPLACE Item->NroMes WITH XsNroMes
REPLACE Item->CodOpe WITH XsCodOpe
REPLACE Item->NroAst WITH XsNroAst
REPLACE Item->NroItm WITH XiNroItm
REPLACE Head->NroItm WITH Head->NroItm + 1
REPLACE Item->EliItm WITH XcEliItm
REPLACE Item->CodMon WITH XiCodMon
REPLACE Item->TpoCmb WITH XfTpoCmb
REPLACE Item->FchDoc WITH XdFchAst
REPLACE Item->CodCta WITH XsCodCta
REPLACE Item->CodRef WITH XsCodRef
REPLACE Item->ClfAux WITH XsClfAux
REPLACE Item->CodAux WITH XsCodAux
REPLACE Item->TpoMov WITH XcTpoMov
REPLACE Item->NroRuc WITH XsNroRuc
replace ITEM.fchdig  with date()
replace ITEM.hordig  with time() 

IF OPER->CodMon = 4
   REPLACE Item->Import WITH XfImpNac
   REPLACE Item->ImpUsa WITH XfImpUsa
ELSE
   IF CodMon = 1
      REPLACE Item->Import WITH XfImport
      IF TpoCmb = 0
         REPLACE Item->ImpUsa WITH 0
       ELSE
         REPLACE Item->ImpUsa WITH ROUND(XfImport/TpoCmb,2)
      ENDIF
   ELSE
      REPLACE Item->Import WITH ROUND(XfImport*TpoCmb,2)
      REPLACE Item->ImpUsa WITH XfImport
   ENDIF
ENDIF
REPLACE Item->GloDoc WITH XsGloDoc
REPLACE Item->CodDoc WITH XsCodDoc
REPLACE Item->NroDoc WITH XsNroDoc
REPLACE Item->NroRef WITH XsNroRef
REPLACE Item->FchDoc WITH XdFchDoc
REPLACE Item->FchVto WITH XdFchVto
REPLACE Head->ChkCta WITH Head->ChkCta+VAL(TRIM(XsCodCta))
IF ! XsCodOpe = "9"
   DO CBDACTCT WITH  CodCta , CodRef , _MES , TpoMov , Import , ImpUsa
ELSE  && EXTRA CONTABLE
   DO CBDACTEC WITH  CodCta , CodRef , _MES , TpoMov , Import , ImpUsa
ENDIF
SELECT Item
nImpNac = Import
nImpUsa = ImpUsa
IF Item->TpoMov = 'D'
   REPLACE Head->DbeNac  WITH Head->DbeNac+nImpNac
   REPLACE Head->DbeUsa  WITH Head->DbeUsa+nImpUsa
ELSE
   REPLACE Head->HbeNac  WITH Head->HbeNac+nImpNac
   REPLACE Head->HbeUsa  WITH Head->HbeUsa+nImpUsa
ENDIF
UNLOCK

RETURN
**********************************************************************
******************
PROCEDURE ImprVouc
******************
PRIVATE Largo,Ancho,Temp
SAVE SCREEN TO Temp
DO DIRPRINT IN ADMPRINT
*DO ADMPRINT
IF LASTKEY() = ESCAPE
   RESTORE SCREEN FROM TEMP
   RETURN
ENDIF
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = TRIM(GsDirCia)
Tit_SDER = "FECHA : "+DTOC(HEAD->FCHAST)
Tit_IDER = ""
Tit_I_CEN= []
TITULO   = ""
SUBTITULO = ""
IniImp   = _Prn3    && 15   cpi
Largo    = 36
LinFin   = Largo - 5
Ancho    = 136
numpag  = 0
En1 =[]
En2 =[]
En3 =[]
En4 =[]
En5 = "****** ********************** ************ ***** ********************************************************* ************** ***************"
En6 = "CUENTA    D O C U M E N T O                COD.                                                                                         "
En7 = "CONTAB **********************     No.      AUXI-                   D E S C R I P C I O N                    C A R G O S     A B O N O S "
En8 = "GRAL.    No.        VENCTO.    REFERENCIA  LIAR                                                                                         "
En9 = "****** *********** ********** ************ ***** ********************************************************* ************** **************"
***** *********** ********** ************ ***** ********************************************************* ************** **************"
****   012345 89012345678901234567890 1234567890=3456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123
****             1         2         3         4         5         6         7         8         9         0         1         2         3         4
****                                                                                               US$99,999,999.99
SET DEVICE TO PRINTER
PRINTJOB
   sKey = XsNroMes+XsCodOpe+XsNroAst
   =SEEK(sKey,"HEAD")
   =SEEK(HEAD.CodOpe,'OPER')
   LsNomOpe=OPER->NomOpe
   DO MovMemb
   IF HEAD->FlgEst="A"
      @ PROW()+1,11 SAY "     #    #     # #     # #          #    ######  #######  "
      @ PROW()+1,11 SAY "    # #   ##    # #     # #         # #   #     # #     #  "
      @ PROW()+1,11 SAY "   #   #  # #   # #     # #        #   #  #     # #     #  "
      @ PROW()+1,11 SAY "  #     # #  #  # #     # #       #     # #     # #     #  "
      @ PROW()+1,11 SAY "  ####### #   # # #     # #       ####### #     # #     #  "
      @ PROW()+1,11 SAY "  #     # #    ## #     # #       #     # #     # #     #  "
      @ PROW()+1,11 SAY "  #     # #     #  #####  ####### #     # ######  #######  "
   ELSE
      nDbe = 0
      nHbe = 0
      SELECT ITEM
      cNroChq = []
      SEEK XsNroMes+XsCodOpe+XsNroAst
      DO WHILE  ! EOF() .AND. sKey = ITEM->NroMes+ITEM->CodOpe+ITEM->NroAst
         IF Prow() > (Largo - 4)
           DO MovMemb
         ENDIF
         NumLin = Prow() + 1
         @ NumLin,00  SAY CodCta
         @ NumLin,07  SAY NroDoc
         IF ! EMPTY(FchVto)
            @ NumLin,19  SAY FchVto
         ENDIF
         @ NumLin,30  SAY NroRef
         @ NumLin,43  SAY CodAux
         =SEEK(ClfAux+CodAux,"CLIE")
         DO CASE
            CASE ! EMPTY(ITEM->Glodoc)
               LsGlodoc = PADR(ITEM->GloDoc,60)
            CASE ! EMPTY(CLIE->NomAux)
               LsGlodoc = PADR(CLIE->NOMAUX,60)
            OTHER
               LsGlodoc = PADR(HEAD->NotAst,60)
         ENDCASE
         IF ITEM->CodMon <> 1
            LsImport = '(US$' + ALLTRIM(TRANSF(ImpUsa,"###,###,###.##"))+")"
            IF RIGHT(LsImport,4)=".00)"
               LsImport = '(US$' + ALLTRIM(STR(ImpUsa,14,0))+")"
               LsImport = '(US$' + ALLTRIM(TRANSF(ImpUsa,"##,###,###,###"))+")"
            ENDIF
            LsGloDoc = LEFT(LsGloDoc,57-LEN(LsImport))+LsImport
         ENDIF
         @ NumLin,49  SAY LsGloDoc PICT "@S57"
         IF TpoMov='D'
            @ NumLin,107 SAY Import PICT "999,999,999.99"
            nDbe = nDbe +  Import
         ELSE
            @ NumLin,122 SAY Import PICT "999,999,999.99"
            nHbe = nHbe +  Import
         ENDIF
         SKIP
      ENDDO
      IF Prow() > (Largo - 10)
        DO MovMemb
      ENDIF
      NumLin = PROW() + 2
      @ NumLin,80  SAY _Prn7a+"TOTALES"+_Prn7B
      @ NumLin,0  SAY [ ]
      @ NumLin,107 SAY _Prn6a
      @ NumLin,107 SAY nDbe PICT "999,999,999.99"
      @ NumLin,122 SAY nHbe PICT "999,999,999.99"
      @ NumLin,Ancho-1 SAY _Prn6a
   ENDIF
   DO MovIPie
ENDPRINTJOB
EJECT PAGE
SET DEVICE TO SCREEN
DO ADMPRFIN IN ADMPRINT
RESTORE SCREEN FROM Temp
SELECT ITEM
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
   @ NumLin,107 SAY nDbe PICT "999,999,999.99"
   @ NumLin,122 SAY nHbe PICT "999,999,999.99"
ENDIF
NumPag = NumPag + 1
cTitulo =+Mes(VAL(XsNroMes),1)+" "+TRANS(_ANO,"9,999 ")
@ 0,0  SAY IniImp
@ 1,0  SAY _Prn7a+GsNomCia+_Prn7b
@ 2,0  SAY GsDirCia
@ 2,Ancho - 23  SAY "OPERACION  "+_Prn7a+HEAD->CodOpe+_Prn7b
@ 3,0           SAY "REGISTRO "+LsNomOpe
@ 3,Ancho/2-14  SAY _Prn7a+"VOUCHER GENERAL"+_Prn7b
@ 3,Ancho - 36  SAY "ASIENTO    "+_Prn7a+XsNroAst+_Prn7b
@ 4,0           SAY cTitulo
@ 4,Ancho - 44  SAY "MONEDA     "+IIF(HEAD->CodMon=1,"S/.","US$")
@ 4,Ancho - 23  SAY "REFERENCIA "+HEAD->NroVou
@ 5,0           SAY HEAD->NotAst
@ 5,Ancho - 44  SAY "T/C   "+TRAN(HEAD->TpoCmb,"##,###.####")
@ 5,Ancho - 23  SAY "Fecha      "+DTOC(HEAD->FchAst)
@ 6, 0          SAY En5
@ 7, 0          SAY En6
@ 8, 0          SAY En7
@ 9, 0          SAY En8
@ 10,0          SAY En9
IF NumPag > 1
   NumLin = PROW() + 1
   @ NumLin,80  SAY "VIENEN ..."
   @ NumLin,107 SAY nDbe PICT "999,999,999.99"
   @ NumLin,122 SAY nHbe PICT "999,999,999.99"
ENDIF
RETURN
**********************************************************************
PROCEDURE MovIPie
*****************
NumLin = Largo - 7
Pn1 = "   PREPARADO        REVISADO        GERENCIA                                                                                                              "
Pn2 = "                                                                                                                                                          "
Pn3 = "                                                                                                                                                          "
Pn4 = "_______________ _______________ _______________                                                                                                           "
Pn5 = PADC(HEAD->Digita,15)
@ NumLin+1,0    SAY Pn1
@ NumLin+2,0    SAY Pn2
@ NumLin+3,0    SAY Pn3
@ NumLin+4,0    SAY Pn4
@ NumLin+5,0    SAY Pn5
RETURN
