**************************************************************************
*  Consultas en general
**************************************************************************
PARAMETER XLookUp

PRIVATE Titulo, TstLin, xoRDER, Sorteo
PRIVATE Xo, Yo, Largo, Ancho, LinReg, Key1, Key2
LsNombre = ""

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

DO CASE
   CASE XLookUp = "TDOC"
     
                  **1234  123456789012345678901234567890
      Titulo    = "C¢digo      Descripcion              "
      LinReg    = [CodDoc+"  "+DesDoc]
      
      Ancho     = LEN( &LinReg ) + 2

   CASE XLookUp = "TREF"
      Titulo    = "C¢digo      Descripcion              "
                  **1234  123456789012345678901234567890
      LinReg    = [CodDoc+"  "+DesDoc]
      Ancho     = LEN( &LinReg ) + 2

   CASE XLookUp = "GDOC"
      KEY1      = XsTpoDoc+XsCodDoc
      KEY2      = XsTpoDoc+XsCodDoc
      Titulo    = "   NUMERO    FECHA           NOMBRE / RAZON SOCIAL               SALDO ACTUAL"
                  **1234567890 99/99/99 1234567890123456789012345678901234567890 S/.9,999,999.99
      LinReg    = [NroDoc+" "+DTOC(FchDoc)+" "+LEFT(NomCli,40)+" "+IIF(CodMon=1,'S/.','US$')+TRANS(SdoDoc,'9,999,999.99')]
      Ancho     = LEN( &LinReg ) + 2

   CASE XLookUp = "CLIE2"
      KEY1 = GsClfCli
      KEY2 = GsClfCli
      GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar [F4] Cont. Busca"
      Titulo    = " CLIENTE         NOMBRE / RAZON SOCIAL            "
                  **1234567  1234567890123456789012345678901234567890
	  LnNomAux=60                  
      LinReg    = [CodAux+" "+SUBSTR(RazSoc,LnNomAux)]
      Ancho     = LEN( &LinReg ) + 2
      GsClfAux = GsClfCli
      ON KEY LABEL F5 DO XCLIF5_2
      ON KEY LABEL F4  DO XF4
      
   CASE XLookUp = "CLIE"
      KEY1 = GsClfCli
      KEY2 = GsClfCli
      LnNomAux=60
      GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar [F4] Cont. Busca"
      Titulo    = " CLIENTE         NOMBRE / RAZON SOCIAL            "
                  **1234567  1234567890123456789012345678901234567890
      LinReg    = [CodAux+" "+LEFT(NomAux,LnNomAux)]
      Ancho     = LEN( &LinReg ) + 2
      GsClfAux = GsClfCli
      ON KEY LABEL F5 DO XCLIF5
      ON KEY LABEL F4  DO XF4

   CASE XLookUp = "VEND"
      KEY1 = GsClfVen
      KEY2 = GsClfVen
      GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar [F4] Cont. Busca"
      Titulo    = " CODIGO           NOMBRE                          "
                  **1234567  1234567890123456789012345678901234567890
      LinReg    = [CodAux+" "+NomAux]
      Ancho     = LEN( &LinReg ) + 2


   CASE XLookUp = "MCTA"
      KEY1 = [104]
      KEY2 = [104]
      GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar"
      Titulo    = " CUENTA    DESCRIPCION                                NUMERO DE CTA.                  "
                  * 12345678 1234567890123456789012345678901234567890 12345678901234567890123456789012345"
      LinReg    = [CodCta+" "+LEFT(NomCta,40)+' '+NroCta]
      Ancho     = LEN( &LinReg ) + 2
      ON KEY LABEL F5 DO XCTAF5

   CASE XLookUp = "CTAX"
      GsMsgKey  = "[T.Cursor] Seleccionar [Enter] Aceptar [Esc] Cancelar [F5] Buscar"
      Titulo    = "CUENTA    DESCRIPCION"
      LinReg    = [CodCta+" "+LEFT(NomCta,40)]
      Ancho     = LEN( &LinReg ) + 2
      TstLin    = [AFTMOV="S"]
      Key1      = cCodCta
      Key2      = cCodCta

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

   CASE XLookUp = "ASIG"
      Key1     = XsCodCli+"P"+XsTpoRef+XsCodRef
      Key2     = XsCodCli+"P"+XsTpoRef+XsCodRef
      Titulo   = " DOC.   NUMERO   MON      SALDO    "
                 **1234 1234567890 US$ 999,999,999.99
      LinReg   = "CodDoc+' '+NroDoc+' '+IIF(CodMon=1,'S/.','US$')+' '+TRANS(SdoDoc,'999,999,999.99')"
      Ancho    = LEN( &LinReg ) + 2
   CASE XLookUp = "ASPROF"
      Key1     = XsCodCli+"P"
      Key2     = XsCodCli+"P"
      Titulo   = " DOC.   NUMERO   MON      SALDO    "
                 **1234 1234567890 US$ 999,999,999.99
      LinReg   = "CodDoc+' '+NroDoc+' '+IIF(CodMon=1,'S/.','US$')+' '+TRANS(SdoDoc,'999,999,999.99')"
      Ancho    = LEN( &LinReg ) + 2

   CASE XLookUp = "0001"
      Key1     = "NA"
      Key2     = "NA"
      Titulo   = " CODIGO    D E S C R I P C I O N               "
                 **12345 1234567890123456789012345678901234567890
      LinReg   = "Codigo+' '+Nombre"
      Ancho    = LEN( &LinReg ) + 2

   CASE XLookUp = "0002.1"
      Key1     = xCodDoc
      Key2     = xCodDoc
      Titulo   = " NUMERO     NOMBRE/RAZON SOCIAL                  SIT"
                 **12345  1234567890123456789012345678901234567890  1
      LinReg   = "DTOC(FCHDOC)+' '+NroDoc+'  '+LEFT(CLIE->RazSoc,35)+'  '+FlgEst+' '+IIF(CodMon=1,'S/.','US$')+' '+TRANS(ImpDoc,'99,999,999.99')"
      Ancho    = LEN( &LinReg ) + 2

   CASE XLookUp = "0002"
      Key1     = xCodDoc
      Key2     = xCodDoc
      Titulo   = " NUMERO     NOMBRE/RAZON SOCIAL                  SIT"
                 **12345  1234567890123456789012345678901234567890  1
      LinReg   = "NroDoc+'  '+LEFT(CLIE->NomAux,40)+'  '+FlgEst+' '"
      Ancho    = LEN( &LinReg ) + 2


   CASE XLookUp = "0003"
      Key1     = xCodDoc+"P"
      Key2     = xCodDoc+"P"
      Titulo   = " NUMERO     NOMBRE/RAZON SOCIAL                  SIT"
                 **12345  1234567890123456789012345678901234567890  1
      LinReg   = "NroDoc+'  '+LEFT(CLIE->NomAux,40)+'  '+FlgEst+' '"
      Ancho    = LEN( &LinReg ) + 2

   CASE XLookUp = "0004"
      Key1     = m.flgest+m.tpodoc+m.coddoc
      Key2     = m.flgest+m.tpodoc+m.coddoc
      Titulo   = " NUMERO             NOMBRE/RAZON SOCIAL             "
                 **1234567890 1234567890123456789012345678901234567890
      LinReg   = "NroDoc+' '+LEFT(AUXI.NomAux,40)"
      Ancho    = LEN( &LinReg ) + 2

   CASE XLookUp = "0005"
      Key1     = "NC"
      Key2     = "NC"
      Titulo   = " CODIGO    D E S C R I P C I O N               "
                 **12345 1234567890123456789012345678901234567890
      LinReg   = "Codigo+' '+Nombre"
      Ancho    = LEN( &LinReg ) + 2

   CASE XLookUp = "0006"
      ** DOCUMENTOS PENDIENTES EN CARTERA **
      Key1     = 'P'+'C'+m.tpodoc+m.coddoc
      Key2     = 'P'+'C'+m.tpodoc+m.coddoc
      Titulo   = " NUMERO             NOMBRE/RAZON SOCIAL             "
                 **1234567890 1234567890123456789012345678901234567890
      LinReg   = "NroDoc+' '+LEFT(cbdmauxi.NomAux,40)"
      Ancho    = LEN( &LinReg ) + 2

   CASE XLookUp = "0007"
      Key1     = XsCodDoc
      Key2     = XsCodDoc
      Titulo   = " PROFORMA   NOMBRE/RAZON SOCIAL                      SIT"
                 **1234567890 1234567890123456789012345678901234567890  1
      LinReg   = "NroDoc+'  '+LEFT(CLIE.NomAux,40)+'  '+FlgEst+' '"
      Ancho    = LEN( &LinReg ) + 2

   CASE XLookUp = "0008"
      ** PROFORMAS PENDIENTES DE GENERAR LETRAS **
      Key1     = m.CodRef+[P]
      Key2     = m.CodRef+[P]
      Titulo   = " PROFORMA   NOMBRE/RAZON SOCIAL                      SIT"
                 **1234567890 1234567890123456789012345678901234567890  1
      LinReg   = "NroDoc+'  '+LEFT(CLIE.NomAux,40)+'  '+FlgEst+' '"
      Ancho    = LEN( &LinReg ) + 2

   CASE XLookUp = "00A8"
      ** PROFORMAS PENDIENTES DE GENERAR LETRAS **
      Key1     = m.CodRef+[P]
      Key2     = m.CodRef+[P]
      Titulo   = " PROFORMA   NOMBRE/RAZON SOCIAL                      SIT"
                 **1234567890 1234567890123456789012345678901234567890  1
      LinReg   = "NroDoc+'  '+LEFT(AUXI.NomAux,40)+'  '+FlgEst+' '"
      Ancho    = LEN( &LinReg ) + 2

   CASE XLookUp = "0009"
      ** LETRAS EN BANCO **
      Key1     = XsCodCta+XsTpoRef+XsCodRef+[P]+[B]
      Key2     = XsCodCta+XsTpoRef+XsCodRef+[P]+[B]
      Titulo   = " DOC.   NUMERO   MON      SALDO    "
                 **1234 1234567890 US$ 999,999,999.99
      LinReg   = "CodDoc+' '+NroDoc+' '+IIF(CodMon=1,'S/.','US$')+' '+TRANS(SdoDoc,'999,999,999.99')"
      Ancho    = LEN( &LinReg ) + 2

   CASE XLookUp = "0010"
      ** DOCUMENTOS PENDIENTES POR CLIENTE **
      Key1     = m.CodCli+"P"+m.TpoRef+m.CodRef
      Key2     = m.CodCli+"P"+m.TpoRef+m.CodRef
      Titulo   = " DOC.   NUMERO   MON      SALDO    "
                 **1234 1234567890 US$ 999,999,999.99
      LinReg   = "CodDoc+' '+NroDoc+' '+IIF(CodMon=1,'S/.','US$')+' '+TRANS(SdoDoc,'999,999,999.99')"
      Ancho    = LEN( &LinReg ) + 2

   CASE XLookUp = "0011"
      ** DOCUMENTOS PENDIENTES EN CARTERA **
      Key1     = 'P'+'C'+m.tpodoc+m.coddoc
      Key2     = 'P'+'C'+m.tpodoc+m.coddoc
      Titulo   = " NUMERO             NOMBRE/RAZON SOCIAL             "
                 **1234567890 1234567890123456789012345678901234567890
      LinReg   = "NroDoc+' '+LEFT(AUXI->NomAux,40)+' '+IIF(CodMon=1,'S/.','US$')+TRANS(SdoDoc,'9,999,999.99')"
      Ancho    = LEN( &LinReg ) + 2

   CASE XLookUp = "0012"
      Key1     = xCodDoc+"P"
      Key2     = xCodDoc+"P"
      Titulo   = " NUMERO     NOMBRE/RAZON SOCIAL                  SIT"
                 **12345  1234567890123456789012345678901234567890  1
      LinReg   = "NroDoc+'  '+LEFT(AUXI.NomAux,40)+'  '+FlgEst+' '"
      Ancho    = LEN( &LinReg ) + 2

   CASE XLookUp = "0013"
      Key1     = xCodDoc
      Key2     = xCodDoc
      Titulo   = " NUMERO     NOMBRE/RAZON SOCIAL                 SIT  FECHA   MON    IMPORTE"
                 **12345  1234567890123456789012345678901234567890  1
      LinReg   = "NroDoc+'  '+LEFT(AUXI.NomAux,35)+'  '+FlgEst+' '+DTOC(FchDoc)+' '+IIF(CodMon=1,'S/.','US$')+' '+TRANSFORM(ImpDoc,'999,999.99')"
      Ancho    = LEN( &LinReg ) + 2

   CASE XLookUp = "0014"
      ** DOCUMENTOS PENDIENTES - POR APROBAR O APROBADOS EN BANCOS **
      Key1     = 'P'+m.SitPre+m.tpodoc+m.coddoc
      Key2     = 'P'+m.SitPre+m.tpodoc+m.coddoc
      Titulo   = " NUMERO             NOMBRE/RAZON SOCIAL             "
                 **1234567890 1234567890123456789012345678901234567890
      LinReg   = "NroDoc+' '+LEFT(AUXI->NomAux,40)+' '+IIF(CodMon=1,'S/.','US$')+TRANS(SdoDoc,'9,999,999.99')"
      Ancho    = LEN( &LinReg ) + 2

   CASE XLookUp = "0015"
     ** PLANILLAS BANCARIAS PARA LETRAS                           **
     Key1     = m.CodDoc+m.FlgUbc+m.FlgSit
     Key2     = m.CodDoc+m.FlgUbc+m.FlgSit
     Titulo   = " Planilla   Banco                   Mon.    Saldo   "
                **1234567890 123456789012345678901234 678901234567890
     LinReg   = [NroPla+' '+IIF(SEEK('04'+CodBco,'TABLA'),LEFT(TABLA.NomBre,25),SPACE(25))+' '+IIF(CodMon=1,'S/.','US$')+TRANS(SdoDoc,'9,999,999.99')]
     Ancho    = LEN( &LinReg ) + 2

   CASE XLookUp = "0016"
      Key1     = XsCodCli
      Key2     = XsCodCli
      Titulo   = " PROFORMA   FECHA         SIT"
                 **1234567890 1234567890123456789012345678901234567890  1
      LinReg   = "NroDoc+'  '+DTOC(FchDoc)+'  '+FlgEst+' '"
      Ancho    = LEN( &LinReg ) + 2
   CASE XLookUp = "NCPR"
	      KEY1      = XsTpoDoc+XsCodDoc
	      KEY2      = XsTpoDoc+XsCodDoc
	      Titulo    = "   NUMERO    FECHA           NOMBRE / RAZON SOCIAL               SALDO ACTUAL"
	                  **1234567890 99/99/99 1234567890123456789012345678901234567890 S/.9,999,999.99
	      LinReg    = [NroDoc+" "+DTOC(FchDoc)+" "+LEFT(NomCli,40)+" "+IIF(CodMon=1,'S/.','US$')+TRANS(SdoDoc,'9,999,999.99')]
	      Ancho     = LEN( &LinReg ) + 2
    CASE XLookUp = "ANPR"
	      KEY1      = XsTpoDoc+XsCodDoc
	      KEY2      = XsTpoDoc+XsCodDoc
	      Titulo    = "   NUMERO    FECHA           NOMBRE / RAZON SOCIAL               SALDO ACTUAL"
	                  **1234567890 99/99/99 1234567890123456789012345678901234567890 S/.9,999,999.99
	      LinReg    = [NroDoc+" "+DTOC(FchDoc)+" "+LEFT(NomCli,40)+" "+IIF(CodMon=1,'S/.','US$')+TRANS(SdoDoc,'9,999,999.99')]
	      Ancho     = LEN( &LinReg ) + 2  
   CASE XLookUp = "VPRO"
*!*	      KEY1      = XsTpoDoc+XsCodDoc
*!*	      KEY2      = XsTpoDoc+XsCodDoc
      Titulo    = "   NUMERO    FECHA           NOMBRE / RAZON SOCIAL               SALDO ACTUAL"
                  **1234567890 99/99/99 1234567890123456789012345678901234567890 S/.9,999,999.99
      LinReg    = [NroDoc+" "+DTOC(FchDoc)+" "+LEFT(NomCli,40)+" "+IIF(CodMon=1,'S/.','US$')+TRANS(SdoDoc,'9,999,999.99')]
      Ancho     = LEN( &LinReg ) + 2
   CASE XLookUp = "PROF"
*!*	      KEY1      = XsTpoDoc+XsCodDoc
*!*	      KEY2      = XsTpoDoc+XsCodDoc
      Titulo    = "   NUMERO    FECHA           NOMBRE / RAZON SOCIAL               SALDO ACTUAL"
                  **1234567890 99/99/99 1234567890123456789012345678901234567890 S/.9,999,999.99
      LinReg    = [NroDoc+" "+DTOC(FchDoc)+" "+LEFT(NomCli,40)+" "+IIF(CodMon=1,'S/.','US$')+TRANS(SdoDoc,'9,999,999.99')]
      Ancho     = LEN( &LinReg ) + 2

   OTHER
      RETURN .F.
ENDCASE

SAVE SCREEN TO SLookUp
Xo       = 100-Ancho
DO Lib_MTEC  WITH 99
DO Busca WITH "",Key1,Key2,LinReg,Titulo,Yo,Xo,Largo,Ancho,TstLin
RESTORE SCREEN FROM SLookUp
POP KEY
SET ORDER TO (xoRDER)
RETURN LASTKEY() <> 27


****************
PROCEDURE XCTAF5
****************
SAVE SCREEN
PUSH KEY CLEAR
LsNombre = SPACE(LEN(NomCli))
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
PROCEDURE XCLIF5
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
Key1   = GsClfAux+TRIM(Desde)
Key2   = GsClfAux+TRIM(Hasta)
IF ! EMPTY(LsNombre)
   SEEK Key1
   IF Sorteo = 1
      LOCATE WHILE CLFAUX+CODAUX<=Key2 FOR TRIM(LsNombre)$CodAux
   ELSE
      LOCATE WHILE CLFAUX+UPPER(NOMAUX)<=Key2 FOR TRIM(LsNombre)$UPPER(NomAux)
   ENDIF
   LeeReg = FOUND()
   Localizar = LeeReg
ENDIF
POP KEY
RESTORE SCREEN
RETURN

****************
PROCEDURE XCLIF5_2
****************
SAVE SCREEN
PUSH KEY CLEAR
LsNombre = SPACE(LEN(RazSoc))
@ 13,1 CLEAR TO 22,34
@ 14,1,22,33 BOX "Û   ßßßÛ" COLOR SCHEME 11
@ 13,2 TO 21,34 DOUBLE
@ 14,12 SAY "Ordenado : " GET Sorteo PICT "@^ C¢digo;Nombre"
READ
Localizar = .f.
IF Sorteo = 1
   SET ORDER TO CLIEN04
   STORE SPACE(LEN(CodAux)) TO Desde,Hasta
ELSE
   SET ORDER TO CLIEN02
   STORE SPACE(LEN(RazSoc)) TO Desde,Hasta
ENDIF
@ 17,4  SAY "Desde : " GET Desde  PICT "@!S20"
@ 18,4  SAY "Hasta : " GET Hasta  PICT "@!S20"
@ 19,4  SAY "Localizar : " GET LsNombre  PICT "@!S15"
READ
Ciclo = .F.
IF Sorteo = 1
	Key1   = GsClfAux+TRIM(Desde)
	Key2   = GsClfAux+TRIM(Hasta)
ELSE
	Key1   = TRIM(Desde)
	Key2   = TRIM(Hasta)

ENDIF
IF ! EMPTY(LsNombre)
   SEEK Key1
   IF Sorteo = 1
      LOCATE WHILE CLFAUX+CODAUX<=Key2 FOR TRIM(LsNombre)$CodAux
   ELSE
      LOCATE WHILE UPPER(RazSoc)<=Key2 FOR TRIM(LsNombre)$UPPER(RazSoc)
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
   Localizar = LeeReg
ENDIF
POP KEY
RESTORE SCREEN
RETURN
