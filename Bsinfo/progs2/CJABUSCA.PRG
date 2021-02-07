**************************************************************************
*  Consultas en general
**************************************************************************

PARAMETER XLookUp
PRIVATE Titulo, TstLin, xoRDER, Sorteo, LsNombre
PRIVATE Xo, Yo, Largo, Ancho, LinReg, Key1, Key2

GsMsgKey = "[Teclas de Cursor] Buscar   [Enter] Aceptar   [Esc] Cancelar"
PUSH KEY CLEAR

xoRDER   = ORDER()
Key1     = ""
Key2     = ""
Sorteo   = 1
Yo       = 8
Largo    = 14
LinReg   = ""
Ancho    = 2
Titulo   = ""
TstLin   = ""
Localizar = .F.
LsNombre = []

DO CASE
   CASE XLookUp = "AUXI"
      GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar [F4] Cont. Busca"
      KEY1      = XsClfAux
      KEY2      = XsClfAux
      LnNomAux=60
      Titulo    = "C¢digo      Nombre/Razon Social"
      LinReg    = [CodAux+" "+LEFT(NomAux,LnNomAux)]
      Ancho     = LEN( &LinReg ) + 2
      ON KEY LABEL F5 DO XAUXF5
      ON KEY LABEL F4  DO XF4

   CASE XLookUp = "PEND"
     KEY1      = LcFlgCan+LsCodCli+PROV->TpoEqu
     KEY2      = LcFlgCan+LsCodCli+PROV->TpoEqu
     Titulo    = [  NRODOC    CODIGO    FECHA          S  A  L  D  O]
                  **********  ******  ********  ***  ****************
     LinReg    = [NRODOC+"  "+CODAUX+"  "+DTOC(FCHDOC)+"  "+IIF(CODMON=1,"S/.","US$")+"  "+TRANS(IIF(FlgCan="P",SDOACT,IMPORT),"9,999,999,999.99")]
     Ancho     = LEN( &LinReg ) + 2
   CASE XLookUp = "MCLI"
     GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar"
     Titulo    = [Cod. Cli.   NomBre\Raz¢n Social                ]
     LinReg    = [CODAUX+"  "+NomAux]
     Ancho     = LEN( &LinReg ) + 2
     ON KEY LABEL F5 DO XMCLI
   CASE XLookUp = "OPER"
      Titulo    = "OPERACION   DESCRIPCION"
      LinReg    = [CodOpe+" "+NomOpe]
      Ancho     = LEN( &LinReg ) + 2

   CASE XLookUp = "CTAS"
      GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar"
      Titulo    = "CUENTA    DESCRIPCION"
      LinReg    = [CodCta+" "+LEFT(NomCta,40)]
      Ancho     = LEN( &LinReg ) + 2
      TstLin    = [AFTMOV="S"]
      ON KEY LABEL F5 DO XCTAF5

   CASE XLookUp = "CAJA1"
      KEY1      = "104"
      KEY2      = "104"
      GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar"
      Titulo    = "CUENTA    DESCRIPCION              NRO. CUENTA"
      LinReg    = [CodCta+" "+LEFT(NomCta,40)+' '+NroCta]
      Ancho     = LEN( &LinReg ) + 2
      TstLin    = [AFTMOV="S"]

   CASE XLookUp = "CTA2"
      GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar"
      Titulo    = "CUENTA    DESCRIPCION"
      LinReg    = [CodCta+" "+LEFT(NomCta,40)]
      Ancho     = LEN( &LinReg ) + 2
      TstLin    = [AFTMOV="S" .AND. CtaCja $ "DH"]
      ON KEY LABEL F5 DO XCTAF5
   CASE XLookUp = "MCTA"
      GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar"
      Titulo    = "CUENTA    DESCRIPCION"
      LinReg    = [CodCta+" "+LEFT(NomCta,40)]
      Ancho     = LEN( &LinReg ) + 2
      ON KEY LABEL F5 DO XCTAF5

   CASE XLookUp = "TABL"
      GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar"
      SEEK "00"+XsTabla
      nDigitos = IIF(Digitos>0,Digitos,LEN(Codigo))
      STORE SPACE(nDigitos) TO Desde,Hasta,LsNombre
      Key1     = XsTabla
      Key2     = XsTabla
      LinReg   = "LEFT(Codigo,nDigitos)+' '+LEFT(Nombre,30)"
      Ancho    = LEN( &LinReg ) + 2
      Titulo   = PADC(TRIM(Nombre),Ancho-2)
      ON KEY LABEL F5 DO XTABL5
      ON KEY LABEL F4  DO XF4

   CASE XLookUp = "NLIQ"
      Titulo    = "LIQUIDACION"
      LinReg    = [NRODOC]
      Ancho     = LEN( &LinReg ) + 2

   CASE XLookUp = "0001"
      ** LIQUIDACIONES **
      KEY1      = XsCodDoc
      KEY2      = XsCodDoc
      Titulo    = "Liquidaci¢n Del Dia Status"
                  *1234567890 99/99/99   1
      LinReg    = [NroDoc+" "+DTOC(FchDoc)+'   '+FlgEst+'   ']
      Ancho     = LEN( &LinReg ) + 2

   CASE XLookUp = "0002"
      ** BANCOS **
      Key1     = "04"
      Key2     = "04"
      Titulo   = "BANCO  NOMBRE"
                 * 123
      LinReg   = "Codigo+' '+Nombre"
      Ancho    = LEN( &LinReg ) + 2

   CASE XLookUp = "0003"
      ** LIQUIDACIONES **
      KEY1      = XsCodDoc
      KEY2      = XsCodDoc
      Titulo    = " N£mero     Fecha  "
                  *1234567890 99/99/99
      LinReg    = [NroDoc+" "+DTOC(FchDoc)]
      Ancho     = LEN( &LinReg ) + 2

   CASE XLookUp = "0004"
      ** DEPOSITOS **
      KEY1      = XsCodDoc
      KEY2      = XsCodDoc
      Titulo    = "N£mero  Fecha     Importe S/.    Importe US$ "
                  *123456 99/99/99 999,999,999.99 999,999,999.99
      LinReg    = [NroDoc+" "+DTOC(FchDoc)+" "+TRAN(ImpNAC,'999,999,999.99')+' '+TRAN(ImpUSA,'999,999,999.99')]
      Ancho     = LEN( &LinReg ) + 2

   CASE XLookUp = "0005"
      ** LIQUIDACIONES POR DEPOSITAR **
      KEY1      = XsCodRef+[E]
      KEY2      = XsCodRef+[E]
      Titulo    = "Liquidaci¢n  Fecha  Sdo.Efec.S/. Sdo.Efec.US$ Sdo.Cheq.S/. Sdo.Cheq.US$"
                  *1234567890 99/99/99 9,999,999.99 9,999,999.99 9,999,999.99 9,999,999.99
      LinReg    = [NroDoc+' '+DTOC(FchDoc)+' '+TRAN(EfeNac-EfeNacD,'9,999,999.99')+' '+;
                   TRAN(EfeUSA-EfeUSAD,'9,999,999.99')+' '+;
                   TRAN(ChqNAC-ChqNACD,'9,999,999.99')+' '+;
                   TRAN(ChqUSA-ChqUSAD,'9,999,999.99')]
      Ancho     = LEN( &LinReg ) + 2

   CASE XLookUp = "0006"
      ** DOCUMENTOS POR PROVEEDOR **

      KEY1      = XsCodAux+XsCodDoc
      KEY2      = XsCodAux+XsCodDoc
      Titulo    = "Doc.   N£mero    Fecha       Importe   Sit Provision No.O/C"
                  *123  1234567890 99/99/99 999,999,999.99 1   123456   123456
      LinReg    = [CodDoc+'  '+NroDoc+' '+DTOC(FchDoc)+' '+TRAN(Import,'999,999,999.99')+' '+;
                   FlgEst+'   '+NroAst+'   '+NroO_C]
      Ancho     = LEN( &LinReg ) + 2

   CASE XLookUp = "0007"
      ** CENTROS DE COSTO **
      KEY1 = [9]
      KEY2 = [9]
      Titulo    = "CUENTA    DESCRIPCION"
      LinReg    = [CodCta+" "+LEFT(NomCta,40)]
      Ancho     = LEN( &LinReg ) + 2
   CASE XLookUp = "0008"
      ** CIERRE DE CAJA CHICA **
      KEY1 = []
      KEY2 = []
      Titulo    = "FECHAS"
      LinReg    = [DTOC(Fecha)]
      Ancho     = LEN( &LinReg ) + 2
   CASE XLookUp = "0009"
      ** ASIENTOS CONTABLES **
      KEY1 = XsNroMes
      KEY2 = XsNroMes
      Titulo    = "ASIENTO   FECHA "
                  *123456  99/99/99"
      LinReg    = [NroAst+'  '+DTOC(FchAst)]
      Ancho     = LEN( &LinReg ) + 2
   CASE XLookUp = "0010"
      ** CONCEPTOS DE CAJA **
      KEY1 = [CJ]
      KEY2 = [CJ]
      Titulo    = "CODIGO     DESCRIPCION               "
                  *12345  123456789012345678901234567890
      LinReg    = [Codigo+'  '+Nombre]
      Ancho     = LEN( &LinReg ) + 2
   CASE XLookUp = "0011"
      ** RECEPCION DE DOCUMENTOS **
      KEY1      = XsCodDoc
      KEY2      = XsCodDoc
      Titulo    = "Doc.   N£mero    Fecha       Importe   Sit Provision No.O/C"
                  *123  1234567890 99/99/99 999,999,999.99 1   123456   123456
      LinReg    = [CodDoc+'  '+NroDoc+' '+DTOC(FchDoc)+' '+TRAN(Import,'999,999,999.99')+' '+;
                   FlgEst+'   '+NroAst+'   '+NroO_C]
      Ancho     = LEN( &LinReg ) + 2

   CASE XLookUp = "0012"
      ** DOCUMENTOS PENDIENTES DE CLIENTES **
      KEY1      = [P]+XsTpoRef+XsCodRef
      KEY2      = [P]+XsTpoRef+XsCodRef
      Titulo    = "Doc.   N£mero    Fecha         Saldo      "
                  *1234 123-456789 99/99/99 S/.999,999,999.99
      LinReg    = [CodDoc+' '+TRANS(NroDoc,'@R 999-'+REPLI('9',LEN(NroDoc)-3))+' '+DTOC(FchDoc)+' '+IIF(CodMon=1,'S/.','US$')+TRANS(SdoDoc,'999,999,999.99')]
      Ancho     = LEN( &LinReg ) + 2

   OTHER
      RETURN .F.
ENDCASE

SAVE SCREEN TO SLookUp
Xo       = 80-Ancho
DO Lib_MTEC  WITH 99
DO Busca WITH "",Key1,Key2,LinReg,Titulo,Yo,Xo,Largo,Ancho,TstLin
RESTORE SCREEN FROM SLookUp
POP KEY
IF XLookUp <> "PEND"
   SET ORDER TO (xoRDER)
ENDIF
RETURN LASTKEY() <> 27


****************
PROCEDURE XCTAF5
****************
SAVE SCREEN
PUSH KEY CLEAR
LsNombre = SPACE(LEN(NomCta))
@ 13,1 CLEAR TO 22,34
@ 14,1,22,33 BOX "Û   ßßßÛ" COLOR SCHEME 11
@ 13,2 TO 21,34 DOUBLE
Localizar = .f.
STORE SPACE(LEN(CodCta)) TO Desde,Hasta
@ 17,4  SAY "Desde : " GET Desde  PICT "@!S20"
@ 18,4  SAY "Hasta : " GET Hasta  PICT "@!S20"
READ
Ciclo = .F.
Key1   = TRIM(Desde)
Key2   = TRIM(Hasta)
POP KEY
RESTORE SCREEN
RETURN

****************
PROCEDURE XAUXF5
****************
SAVE SCREEN
PUSH KEY CLEAR
LsNombre = SPACE(LEN(NomAux))
@ 13,1 CLEAR TO 22,34
@ 14,1,22,33 BOX "Û   ßßßÛ" COLOR SCHEME 11
@ 13,2 TO 21,34 DOUBLE
@ 14,12 SAY "Ordenado : " GET Sorteo PICT "@^ C¢digo;Nombre"
READ
Localizar = .f.
IF Sorteo = 1
   SET ORDER TO AUXI01
   STORE SPACE(LEN(CodAux)) TO Desde,Hasta
ELSE
   SET ORDER TO AUXI02
   STORE SPACE(LEN(NomAux)) TO Desde,Hasta
ENDIF
@ 17,4  SAY "Desde : " GET Desde  PICT "@!S20"
@ 18,4  SAY "Hasta : " GET Hasta  PICT "@!S20"
@ 19,4  SAY "Localizar : " GET LsNombre  PICT "@!S15"
READ
Ciclo = .F.
Key1   = XsClfAux + TRIM(Desde)
Key2   = XsClfAux + TRIM(Hasta)
IF ! EMPTY(LsNombre)
   SEEK Key1
   IF Sorteo = 1
      LOCATE WHILE CLFAUX+CODAUX<=Key2 FOR TRIM(LsNombre)$UPPER(NomAux)
   ELSE
      LOCATE WHILE CLFAUX+NOMAUX<=Key2 FOR TRIM(LsNombre)$UPPER(NomAux)
   ENDIF
   LeeReg = FOUND()
   Localizar = LeeReg
ENDIF
POP KEY
RESTORE SCREEN
RETURN

***************
PROCEDURE XMCLI
***************
SAVE SCREEN
PUSH KEY CLEAR
LsNombre = SPACE(LEN(NomAux))
@ 13,1 CLEAR TO 22,34
@ 14,1,22,33 BOX "Û   ßßßÛ" COLOR SCHEME 11
@ 13,2 TO 21,34 DOUBLE
@ 14,12 SAY "Ordenado : " GET Sorteo PICT "@^ C¢digo;Nombre"
READ
Localizar = .f.
IF Sorteo = 1
   SET ORDER TO 1
   STORE SPACE(LEN(CodAux)) TO Desde,Hasta
ELSE
   SET ORDER TO 2
   STORE SPACE(LEN(NomAux)) TO Desde,Hasta
ENDIF
@ 17,4  SAY "Desde : " GET Desde  PICT "@!S20"
@ 18,4  SAY "Hasta : " GET Hasta  PICT "@!S20"
@ 19,4  SAY "Localizar : " GET LsNombre  PICT "@!S15"
READ
Ciclo = .F.
Key1   = TRIM(Desde)
Key2   = TRIM(Hasta)
IF ! EMPTY(LsNombre)
   SEEK Key1
   IF Sorteo = 1
      LOCATE WHILE CLFAUX+CODAUX<=Key2 FOR TRIM(LsNombre)$UPPER(NomAux)
   ELSE
      LOCATE WHILE CLFAUX+NOMAUX<=Key2 FOR TRIM(LsNombre)$UPPER(NomAux)
   ENDIF
   LeeReg = FOUND()
   Localizar = LeeReg
ENDIF
POP KEY
RESTORE SCREEN
RETURN
*************
PROCEDURE XF4
*************
IF ! Localizar
   RETURN
ENDIF
CONTINUE
IF FOUND()
   Listar = .t.
ELSE
  ?? CHR(7)
ENDIF

*****************
***PROCEDURE XTABLF5
PROCEDURE XTABL5
*****************
SAVE SCREEN
PUSH KEY CLEAR
LsNombre = SPACE(LEN(Nombre))
@ 13,1 CLEAR TO 22,34
@ 14,1,22,33 BOX "Û   ßßßÛ" COLOR SCHEME 11
@ 13,2 TO 21,34 DOUBLE
@ 14,12 SAY "Ordenado : " GET Sorteo PICT "@^ C¢digo;Nombre"
READ
Localizar = .f.
IF Sorteo = 1
   SET ORDER TO TABL01
   STORE SPACE(nDigitos) TO Desde,Hasta
ELSE
   SET ORDER TO TABL02
   STORE SPACE(LEN(Nombre)) TO Desde,Hasta
ENDIF
@ 17,4  SAY "Desde : " GET Desde  PICT "@!S20"
@ 18,4  SAY "Hasta : " GET Hasta  PICT "@!S20"
@ 19,4  SAY "Localizar : " GET LsNombre  PICT "@!S15"
READ
Ciclo = .F.
Key1   = XsTabla + TRIM(Desde)
Key2   = XsTabla + TRIM(Hasta)
IF ! EMPTY(LsNombre)
   SEEK Key1
   Localizar = .t.
   IF Sorteo = 1
      LOCATE WHILE TABLA+CODIGO<=Key2 FOR TRIM(LsNombre)$UPPER(Nombre)
   ELSE
      LOCATE WHILE TABLA+NOMBRE<=Key2 FOR TRIM(LsNombre)$UPPER(Nombre)
   ENDIF
   LeeReg = FOUND()
ENDIF
POP KEY
RESTORE SCREEN
RETURN

*****************
PROCEDURE XPROVF5
*****************
SAVE SCREEN
PUSH KEY CLEAR
@ 13,1 CLEAR TO 22,34
@ 14,1,22,33 BOX "Û   ßßßÛ" COLOR SCHEME 11
@ 13,2 TO 21,34 DOUBLE
Localizar = .f.
STORE SPACE(LEN(NroDoc)) TO Desde,Hasta
STORE SPACE(LEN(NroAst)) TO LsNombre
@ 17,4  SAY "Del No: " GET Desde  PICT "@!"
@ 18,4  SAY "Al  No: " GET Hasta  PICT "@!"
@ 19,4  SAY "Provision : " GET LsNombre  PICT "@!"
READ
Ciclo = .F.
Key1   = XsCodAux + XsCodDoc + TRIM(Desde)
Key2   = XsCodAux + XsCodDoc + TRIM(Hasta)
IF ! EMPTY(LsNombre)
   SEEK Key1
   LOCATE WHILE CODAUX+CODDOC+NRODOC<=Key2 FOR TRIM(LsNombre)$NroAst
   LeeReg = FOUND()
ENDIF
POP KEY
RESTORE SCREEN
RETURN
