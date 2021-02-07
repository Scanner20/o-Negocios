cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9,999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "REPORTE DE INGRESOS DE CAJA"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4
**
SELE 1
USE CBDRMOVM ORDER RMOV01 ALIAS RMOV
IF USED()
   CLOSE DATA
   RETURN
ENDIF
**
SELE 2
USE CBDVMOVM ORDER VMOV01 ALIAS VMOV
IF USED()
   CLOSE DATA
   RETURN
ENDIF
**
SELE 3
USE CBDMAUXI ORDER AUXI01 ALIAS AUXI
IF USED()
   CLOSE DATA
   RETURN
ENDIF
**
SELE 4
USE CBDMTABL ORDER TABL01 ALIAS TABL
IF USED()
   CLOSE DATA
   RETURN
ENDIF
**
SELE 5
USE CBDMCTAS ORDER CTAS01 ALIAS CTAS
IF USED()
   CLOSE DATA
   RETURN
ENDIF
**
XdFch1 = DATE()
XdFch2 = DATE()
XiTipo = 1
@  9,10 FILL  TO 16,68      COLOR W/N
@  8,11 CLEAR TO 15,69
@  8,11       TO 15,69

DO LIB_MTEC WITH 16
@ 10,20 SAY " Ordenado por: "
@ 11,20 SAY " Desde       : "
@ 12,20 SAY " Hasta       : "
i = 1
UltTecla = 0
DO WHILE UltTecla <> Escape
   DO CASE
      CASE i =1
         VecOpc(1) = 'Fecha           '
         VecOpc(2) = 'Cuenta Receptora'
         VecOpc(3) = 'Cliente         '
         XiTipo    = Elige(1,10,36,3)
      CASE i =2
         @ 11,36 GET XdFch1
         @ 12,36 GET XdFch2
         READ
         UltTecla = LASTKEY()
   ENDCASE
   DO CASE
      CASE UltTecla = Arriba
         i = IIF( i > 1 , i - 1 , 1)
      CASE UltTecla = Abajo
         i = IIF( i< 2 , i + 1, 2 )
      CASE UltTecla = Enter
         IF  i < 2
           i = i + 1
         ELSE
           EXIT
         ENDIF
   ENDCASE
ENDDO
IF LASTKEY() = Escape
   CLOSE DATA
   RETURN
ENDIF
** Archivo Temporal
XsCodOpe = "001"     && INGRESOS DE CAJA
TnMes1 = MONTH(XdFch1)
TnMes2 = MONTH(XdFch2)

ArcTmp = SYS(5)
COPY STRU TO &ArcTmp
SELE 0
USE &ArcTmp ALIAS TEMPO EXCL
INDEX ON DTOS(FchDoc) TAG TEMP01  && Fecha
INDEX ON INIAUX       TAG TEMP02  && Cliente
INDEX ON NroCta2      TAG TEMP03  && Cuenta Receptora
FOR TnMes = TnMes1  TO TnMes2
   XsNroMes = TRANS(TnMes,"@L ##")
   SELE VMOV
   SEEK XsNroMes+XsCodOpe+DTOC(XdFCh1)
   IF !FOUND() .AND. RECNO(0)>0
      GO RECNO(0)
   ENDIF
   DO WHILE !EOF() .AND. NroMes+CodOpe  .AND. FchAst<=XdFch2
      SELE RMOV
      SEEK VMOV->NroMes+VMOV->CodOpe+VMOV->NroAst
      DO WHILE !EOF() .AND. VMOV->NroMes+VMOV->CodOpe+VMOV->NroAst =;
                            RMOV->NroMes+RMOV->CodOpe+RMOV->NroAst
          SELE TEMPO
          APPEND BLANK
          REPLACE NroMes WITH RMOV->NroMes
          REPLACE CodOpe WITH RMOV->CodOpe
          REPLACE NroAst WITH RMOV->NroAst
          REPLACE NroItm WITH RMOV->NroItm
          REPLACE CodMon WITH RMOV->CodMon
          REPLACE TpoCmb WITH RMOV->TpoCmb
          REPLACE CodCta WITH RMOV->CodCta
          REPLACE CodRef WITH RMOV->CodRef
          REPLACE NroRef WITH RMOV->NroRef
          REPLACE ClfAux WITH RMOV->ClfAux
          REPLACE CodAux WITH RMOV->CodAux
          REPLACE TpoMov WITH RMOV->TpoMov
          REPLACE Import WITH RMOV->Import
          REPLACE ImpUsa WITH RMOV->ImpUsa
          REPLACE GloDoc WITH RMOV->GloDoc
          REPLACE CodDoc WITH RMOV->CodDoc
          REPLACE NroDoc WITH RMOV->NroDoc
          REPLACE EliItm WITH RMOV->EliItm

          REPLACE FchDoc WITH RMOV->FchDoc
          REPLACE FchVto WITH RMOV->FchVto

          REPLACE CodBco WITH RMOV->CodBco
          REPLACE NroCta WITH RMOV->NroCta
          REPLACE NroChq WITH RMOV->NroChq

          REPLACE NroCta2 WITH VMOV->NroCta
          IF !EMPTY(CodAux)
              =SEEK(ClfAux+CodAux,"AUXI")
              REPLACE IniAux WITH AUXI->IniAux
          ENDIF
          SELE RMOV
          SKIP
      ENDDO
      SELE VMOV
      SKIP
   ENDDO
ENDFOR
**
DO ADMPRINT
IF LASTKEY() = ESCAPE
   CLOSE DATA
   RETURN
ENDIF
Ancho = 163
Cancelar = .F.
Largo   = 66       && Largo de pagina
LinFin  = 88 - 6
IniImp  = _PRN8A+_PRN4
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = TRIM(GsDirCia)
Tit_SDER = "FECHA : "+DTOC(DATE())
Tit_IDER = ""
Titulo   = "I N G R E S O S   D E   C A J A"
SubTitulo= "MES DE "+MES(_MES,1)+" DE "+TRANS(_ANO,"9999")
En2 = "(EXPRESADO EN "+TRIM(VECOPC(XiCodMon))+")"
En3 = " "
En4 = ""
En5 = ""
En6 = "***** ****** *** ****** ********** ******* ********* **************************************** ************* *************************** ***************************"
En7 = ""
En8 = ""
En9 = "***** ****** *** ****** ********** ****** ********** **************************************** ************* ************* ************* ************* *************"
*      0**** 6***** 13* 17**** 24******** 35**** 42******** 53************************************** 94*********** 108********** 122********** 136********** 150**********"
*      12-12 123456 123 123456 123456789- 123456 123456789- 123456789-123456789-123456789-123456789- 123456789-123 123456789-123 123456789-123 123456789-123 123456789-123

NumCol = 5
DIMENSION X(NumCol),Y(NumCol),Z(NumCol),W(NumCol)
SET DEVICE TO PRINT
SET MARGIN TO 0
LsCodRef = ""
PRINTJOB
   NumPag  = 0
   SalTapag = .T.
   SELE TEMPO
   GO TOP
   STORE 0 TO TotNac,TotExt
   DO WHILE ! EOF() .AND. ! Cancelar
      IF EMPTY(CodDoc)
         SKIP
         LOOP
      ENDIF
      DO LINIMP
      SKIP
   ENDDO
   IF ! CANCELAR
      DO ResetPag
      NumLin = PROW() + 1
      @ Numlin,000 SAY REPLICATE("*",Ancho)
      NumLin = PROW() + 1
      @ NumLin,000 SAY "** TOTAL   GENERAL **"
   ENDIF
   EJECT PAGE
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO ADMPRFIN IN ADMPRINT
CLOSE DATA
RETURN
****************
PROCEDURE LinImp
****************
PRIVATE NumLin
@ NumLin , 00 SAY CodDoc
@ NumLIn , 00 SAY NroDoc
=SEEK(ClfAux+CodAux,"AUXI")
@ NumLin , 00 SAY AUXI->IniAux
@ NumLin , 00 SAY IIF(VMOV->CODMON=1,"S/.","US$")
IF VMOV->CodMon = 1
   @ NumLin , 00 SAY Import  PICT "999,999,999.99"
ELSE
   @ NumLin , 00 SAY ImpUsa  PICT "999,999,999.99"
ENDIF
@ NumLin , 00 SAY NroAst
@ NumLin , 00 SAY VMOV->FchAst
** Banco Pagador ???
=SEEK("04"+CodBco,"TABL")
@ NumLin, 00 SAY LEFT(TABL->Nombre,20)
@ NumLin, 00 SAY Nrocta
@ NumLin, 00 SAY NroChq
** Banco Receptor
=SEEK(VMOV->CtaCja,"CTAS")
=SEEK("04"+CTAS->CodBco,"TABL")
@ NumLin, 00 SAY LEFT(TABL->Nombre,20)
@ NumLin, 00 SAY CTAS->Nrocta
NumLin = PROW() + 1
TotNac = TotNac + Import
TotExt = TotExt + ImpUsa
RETURN
******************
procedure ResetPag
******************
IF LinFin <= PROW() .OR. NumPag = 0 .OR. SaltaPag
   IF NumPag > 0 .AND. ! SaltaPag
   ENDIF
   SaltaPag = .F.
   DO ADMMBPRN IN ADMPRINT
   IF UltTecla = Escape
      Cancelar = .T.
   ENDIF
   IF NumPag > 1
   ENDIF
ENDIF
RETURN

