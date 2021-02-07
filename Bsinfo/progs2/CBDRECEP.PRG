*    ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*    ณ  Nombre        : cjap5100.prg                             ณÛÛ
*    ณ  Sistema       : CAJA BANCOS                              ณÛÛ
*    ณ  Autor         :                                          ณÛÛ
*    ณ  Propขsito     : Recepciขn de Documentos de Proveedores   ณÛÛ
*    ณ  Actualizaciขn : Eduardo Tapia Castillo                   ณÛÛ
*    ณ  Actualizaciขn : VETT  25/05/95                           ณÛÛ
*    ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพÛÛ
*      ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*
* VARIABLES DE CONTROL *

PUBLIC XsNroMes
PRIVATE XsClfAux,XsTabla
XsClfAux = [01 ]     && Proveedores/Clientes
XsTabla  = [02]      && Codigo de Documentos
XsNroMes = TRANSF(_MES,"@L ##")
XsAno    = RIGHT(STR(_ANO,4),2)
TsCodDiv1= [01]  && Divisionaria por defecto

* pantalla de datos *
DO xPanta
SAVE SCREEN TO LsPanta1

* bases a usar *
CLOSE DATA
SELECT 1
USE CBDTCIER                           && VERIFICAR CIERRE DEL MES
IF !USED(1)
    CLOSE DATA
    RETURN
ENDIF
RegAct = _Mes + 1
Modificar = ! Cierre
IF RegAct <= RECCOUNT()
   GOTO RegAct
   Modificar = ! Cierre
ENDIF

IF ! Modificar
   GsMsgErr = "Mes Cerrado, registro no puede ser alterado"
   DO LIB_MERR WITH 99
   CLOS DATA
   RETURN
ENDIF

SELE 1
USE CJADPROV ORDER DPRO06 ALIAS DPRO
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 2
USE cbdmauxi ORDER AUXI01 ALIAS AUXI
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 3
USE cbdmtabl ORDER TABL01 ALIAS TABL
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 4
USE cbdtoper ORDER OPER01 ALIAS OPER
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
SELE 5
USE CBDTCIER ALIAS CIERRE
IF !USED()
   CLOSE DATA
   RETURN
ENDIF

SELE 10
USE admmtcmb ORDER tcmb01   ALIAS TCMB
IF !USED()
   CLOSE DATA
   RETURN
ENDIF

SELE 11
USE cjatprov ORDER PROV01   ALIAS PROV
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
SET FILTER TO TipReg="R"

* relaciones a usar *
SELE DPRO
SET RELA TO XsClfAux+CodAux INTO AUXI

* variables del sistema *
PRIVATE XsCodDoc,XsNroDoc,XdFchDoc,XdFchVto,XsCodAux,XfImport,XiCodMon,XfTpoCmb,XsFchPol
PRIVATE XdFchRec,XsNomRec,XsNomEnv,XcFlgEst,XfSdoDoc,XsObserv,XsNroO_C,XsNroGui
PRIVATE XiDiaVto,XfImpBrt,XfImpIgv,XsRucAux,XsNomAux,XsCodOpe
Private XdFchPed

XsCodDoc = SPACE(LEN(DPRO->CodDoc))
XsNroDoc = SPACE(LEN(DPRO->NroDoc))
XsNroRef = SPACE(LEN(DPRO->NroRef))
XdFchDoc = CTOD(SPACE(8))
XdFchVto = CTOD(SPACE(8))
XdFchPol = CTOD(SPACE(8))
XiDiaVto = 0
XsCodAux = SPACE(LEN(DPRO->CodAux))
XsRucAux = SPACE(LEN(DPRO->RucAux))
XsNomAux = SPACE(LEN(DPRO->NomAux))
XfImport = 0.00
XfImpBrt = 0.00
XfImpIgv = 0.00
XiCodMon = 1
XfTpoCmb = 0.00
XdFchRec = DATE()
XdFchPed = Date() + 45
XsNomRec = SPACE(LEN(DPRO->NomRec))
XsNomEnv = SPACE(LEN(DPRO->NomEnv))
XcFlgEst = [P]       && Provisionado, Cancelado , Anulado
XfSdoDoc = 0.00
XsObserv = []
XsNroO_C = SPACE(LEN(DPRO->NroO_C))
XsNroGui = SPACE(LEN(DPRO->NroGui))
** Variables de Contabilidad **
XsCodOpe = SPACE(LEN(DPRO->CodOpe))
XsNroMes = TRANSF(_MES,"@L ##")
XsNroAst = SPACE(LEN(DPRO->NroAst))
XsNroVou = SPACE(LEN(DPRO->NroVou))
*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ*

** Logica principal **
SELE DPRO
GO TOP
UltTecla = 0
GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] Cขdigo [PgUp] [PgDn] Posicionar"
DO LIB_MTEC WITH 99

xCodDoc = XsCodDoc
VCLAVE=XsNroMes
DO EDITA WITH [xLlave],[xPoner],[xTomar],[xBorrar],[xReporte],'NROMES',VCLAVE,'CMAR',[]
CLOSE DATA
RETURN


* ีอออออออออออออออออออออออออออออออออออออธ
* ณ Objetivo : Pantalla de Datos        ณ
* ิอออออออออออออออออออออออออออออออออออออพ
PROCEDURE xPanta
*           1         2         3         4         5         6         7         8
**012345678901234567890123456789012345678901234567890123456789012345678901234567890
*1   ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
*2   ณ Nro.Ingreso: 123456789             Fecha de Recepcion : 99/99/99      ณ
*3   ณ  Proveedor : 12345  1234567890123456789012345678901234567890          ณ
*4   ณ        RUC : 1234567890      Documento del Proveedor : 123 1234567890 ณ
*5   ณ                                        Fecha Emision : 99/99/99       ณ
*6   ณ No. O/C.  : 123456                     Dias de Vcmto.: 9999 Dias      ณ
*7   ณ No. Guia  : 123456                    Fecha de Vcmto.: 99/99/99       ณ
*8   ณฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ  ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟณ
*9   ณณ  Mes Contable   : Diciembre  ณ  ณ          Moneda : S/.             ณณ
*0   ณณ  No. de Asiento : 123456     ณ  ณ  Tipo de Cambio : 9,999.9999      ณณ
*1   ณณ       Operacion : 123        ณ  ณ     Importe IGV : 999,999,999.99  ณณ
*2   ณภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  ณ   Importe Total : 999,999,999.99  ณณ
*3   ณ Situacion     : Provisionado     ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูณ
*4   ณ Nro.Poliza Imp: 123456789012345                 Pago Aduana: 99/99/99 ณ
*5   ณ Enviado a     : 123456789012345678901234567890                        ณ
*6   ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*7   ฺฤObservacionesฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
*8   ณ                                                                       ณ
*9   ณ                                                                       ณ
*0   ณ                                                                       ณ
*1   ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
        **012345678901234567890123456789012345678901234567890123456789012345678901234567890
        *           1         2         3         4         5         6         7         8

CLEAR
@ 0,0,24,79 BOX 'ฒฒฒฒฒฒฒฒฒ'
@  1,3  SAY "ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ"
@  2,3  SAY "ณ Tipo Doc. :                       Fecha de Recepciขn :                ณ"
@  3,3  SAY "ณ Correlat. :                                                           ณ"
@  4,3  SAY "ณ Prov.:                                         # Doc :                ณ"
@  5,3  SAY "ณ RUC  :                                 Fecha Emisiขn :                ณ"
@  6,3  SAY "ณ No. O/C.  :                            Dias de Vcmto.:      Dias      ณ"
@  7,3  SAY "ณ No. Guia  :                           Fecha de Vcmto.:                ณ"
@  8,3  SAY "ณฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ       Fecha de Pago  :                ณ"
@  9,3  SAY "ณณ  Mes Contable   :            ณ  ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟณ" 
@ 10,3  SAY "ณณ  No. de Asiento :            ณ  ณ          Moneda :                 ณณ"
@ 11,3  SAY "ณณ       Operaciขn :            ณ  ณ  Tipo de Cambio :                 ณณ"
@ 12,3  SAY "ณภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  ณ     Importe IGV :                 ณณ"
@ 13,3  SAY "ณ Sit. Registro :                  ณ   Importe Total :                 ณณ"
@ 14,3  SAY "ณ Poliza Nro    :                  ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูณ"
@ 15,3  SAY "ณ Enviado a     :                               Pago Aduana :           ณ"
@ 16,3  SAY "ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู"
@ 17,3  SAY "ฺฤObservacionesฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ"
@ 18,3  SAY "ณ                                                                       ณ"
@ 19,3  SAY "ณ                                                                       ณ"
@ 20,3  SAY "ณ                                                                       ณ"
@ 21,3  SAY "ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู"
Titulo = [ ** RECEPCION DE DOCUMENTOS ** ]
@  0,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
@  9,24 SAY PADR(MES(VAL(XsNroMes),1),10,' ')
RETURN
*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ*


* ีออออออออออออออออออออออออออออออออออออออออออออธ
* ณ Objetivo : Inicializa variables            ณ
* ิออออออออออออออออออออออออออออออออออออออออออออพ
PROCEDURE xInvar
XsNroRef = SPACE(LEN(DPRO->NroRef))
XsRucAux = SPACE(LEN(DPRO->RucAux))
XsCodAux = SPACE(LEN(DPRO->CodAux))
*XsCodDoc = SPACE(LEN(DPRO->CodDoc))
XdFchDoc = CTOD(SPACE(8))
XdFchVto = CTOD(SPACE(8))
XiDiaVto = 0
XfImport = 0.00
XfImpBrt = 0.00
XfImpIgv = 0.00
XiCodMon = 1
XfTpoCmb = 0.00
XdFchRec = DATE()
XdFchPed = Date() + 45
XsNomRec = SPACE(LEN(DPRO->NomRec))
XsNomEnv = SPACE(LEN(DPRO->NomEnv))
XcFlgEst = [P]       && Provisionado, Cancelado, Anulado
XfSdoDoc = 0.00
XsObserv = []
XsNroO_C = SPACE(LEN(DPRO->NroO_C))
XsNroGui = SPACE(LEN(DPRO->NroGui))
** Variables de Contabilidad **
XsCodOpe = SPACE(LEN(DPRO->CodOpe))
*XsNroMes = SPACE(LEN(DPRO->NroMes))
XsNroAst = SPACE(LEN(DPRO->NroAst))
XsNroVou = SPACE(LEN(DPRO->NroVou))
RETURN
*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ*


* ีอออออออออออออออออออออออออออออออออออออออธ
* ณ Objetivo : Pedir Llave de Acceso      ณ
* ิอออออออออออออออออออออออออออออออออออออออพ
PROCEDURE xLlave
SELE DPRO
IF &RegVal
   XsCodDoc = CodDoc
   XsNroDoc = NroDoc
   XsCodOpe = CodOpe
ELSE
   XsCodDoc = SPACE(LEN(CodDoc))
   XsNroDoc = SPACE(LEN(NroDoc))
   XsCodOpe = SPACE(LEN(CodOpe))
ENDIF

UltTecla = 0
i = 1
DO WHILE ! INLIST(UltTecla,Escape)
   DO CASE
      CASE i = 1
         SELE PROV
         @  2,18 GET XsCodDoc PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(XsCodDoc)
            IF ! CBDBUSCA("PROV")
               LOOP
            ENDIF
            XsCodDoc = TpoDoc
         ENDIF
         @  2,18 SAY XsCodDoc
         SEEK XsCodDoc
         IF !FOUND()
            DO lib_merr WITH 6
            LOOP
         ENDIF
         @  2,18 SAY XsCodDoc
         IF !(TIPO$"CN")
            XsCodOpe = CodOpe
            =SEEK(CodOpe,"OPER")
            LsNroAst = NroAst()
            XsNroDoc = LsNroAst+SPACE(LEN(XsNroDoc)-LEN(LsNroAst))
         ENDIF
         SELE DPRO
      CASE i = 2 .AND. ChrVal = [C]
         SELE DPRO
         IF PROV->TIPO="A" .AND. EMPTY(SUBSTR(XsNroDoc,10,2))
            XsNroDoc = SUBSTR(XsNroDoc,1,8)+"-"+RIGHT(STR(_ANO,4),2)
         ENDIF
         IF PROV.Tipo=[A]
			LsNroDoc=LEFT(XsNroDoc,2)+[-]+SUBS(XsNroDoc,3,2)+[-]+SUBS(XsNroDoc,5)         		
	         @ 3,18 SAY LsNroDoc
         ELSE
	         @ 3,18 SAY XsNroDoc
         ENDIF
         UltTecla = Enter
      CASE i = 2 .AND. !( ChrVal = [C] )
         SELE DPRO
         IF PROV->TIPO="A" .AND. EMPTY(SUBSTR(XsNroDoc,10,2))
            XsNroDoc = SUBSTR(XsNroDoc,1,8)+"-"+RIGHT(STR(_ANO,4),2)
         ENDIF
         IF PROV->TIPO="A"
			LsNroDoc=LEFT(XsNroDoc,2)+[-]+SUBS(XsNroDoc,3,2)+[-]+SUBS(XsNroDoc,5)         		
            @ 3,18 SAY LsNroDoc
            
            DATO=SPACE(4)
            @ 3,24 GET DATO PICT "9999" VALID LEN(ALLTRIM(DATO))=4 .AND. ! EMPTY(DATO)
            READ
            XsNroDoc = TsCodDiv1+XsNroMes+DATO+'-'+XsAno
         ELSE
            @ 3,18  GET XsNroDoc PICT "@!"
            READ
         ENDIF
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,Arriba,Escape,Izquierda)
            i = i - 1
            LOOP
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(XsNroDoc)
            IF ! cbdbusca("DPRO")
               LOOP
            ENDIF
            XsNroDoc = NroDoc
         ENDIF
         IF PROV.Tipo=[A]
	         @  3,18 SAY XsNroDoc 
         ELSE
	         @  3,18 SAY XsNroDoc
         ENDIF
   ENDCASE
   IF i = 2 .AND. UltTecla = Enter
      EXIT
   ENDIF
   i = IIF(UltTecla=Arriba,1-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>2,2,i)
ENDDO
SELE DPRO
LsLlave = XsNroMes + XsCodOPE + XsNroDoc
SEEK LsLlave
RETURN
*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ*


*  ีออออออออออออออออออออออออออออออออออออออออออธ
*  ณ  Objetivo : Poner datos en pantalla      ณ
*  ิออออออออออออออออออออออออออออออออออออออออออพ
PROCEDURE xPoner
SELE DPRO
@  2,18 SAY CodDoc
IF PROV.tipo=[A]
	LsNroDoc=LEFT(NroDoc,2)+[-]+SUBS(NroDoc,3,2)+[-]+SUBS(NroDoc,5)         		
	@  3,18 SAY LsNroDoc
ELSE
	@  3,18 SAY NroDoc 
ENDIF
@  2,60 SAY FchRec
@  4,11 SAY CodAux
@  4,18 SAY NomAux PICT "@S33"
@  5,11 SAY RucAux
@  4,60 SAY NroRef
@  5,60 SAY FchDoc
@  6,17 SAY NroO_C
@  6,60 SAY DiaVto PICT "9999"
@  7,17 SAY NroGui
@  7,60 SAY FchVto
@  8,60 say fchped
@  9,24 SAY PADR(MES(VAL(NroMes),1),10,' ')
@ 10,24 SAY NroAst
@ 11,24 SAY CodOpe
DO CASE
   CASE FlgEst = "G"
        @13,21 SAY "ASIENTO GENERADO "
   CASE FlgEst = "P"
        @13,21 SAY "REGISTRADO       "
   CASE FlgEst = "X"
        @13,21 SAY "ASTO. DESCUADRADO"
   CASE FlgEst = "A"
        @13,21 SAY "ANULADO          "
   OTHER
        @13,21 SAY "                 "
ENDCASE
@ 14,21 SAY NomRec
@ 14,21 SAY fchPol
@ 15,21 SAY NomEnv

@ 10,58 SAY IIF(CodMon=1,'S/.','US$')
@ 11,58 SAY TpoCmb PICT "9,999.9999"
@ 12,58 SAY ImpIgv PICT "999,999,999.99"
@ 13,58 SAY Import PICT "999,999,999.99"
@ 18,4  EDIT Observ SIZE 3,71 DISABLE
RETURN
*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ*


* ีอออออออออออออออออออออออออออออออออออออออออออออธ
* ณ Objetivo : Tomar datos adicionales          ณ
* ิอออออออออออออออออออออออออออออออออออออออออออออพ
PROCEDURE xTomar
Crear = .T.
IF &RegVal
   Crear = .F.
   IF FlgEst $ [G|X]
      GsMsgErr = [ NO PUEDE MODIFICAR ESTE REGISTRO  < CONSULTE EN CONTABILIDAD > ]
      DO lib_merr WITH 99
      UltTecla = Escape
      RETURN
   ENDIF
   IF FlgEst = [A]
      GsMsgErr = [ ASIENTO ANULADO ]
      DO lib_merr WITH 99
      UltTecla = Escape
      RETURN
   ENDIF
   IF ! RLOCK()
      UltTecla = Escape
      RETURN
   ENDIF
   DO xMover
ELSE
   DO xInvar
ENDIF
* * * *
PRIVATE i
i = 1
UltTecla = 0
DO WHILE ! INLIST(UltTecla,Escape)
   i = IIF(!Crear.AND.i<2,2,i)
   GsMsgKey = "[Esc] Salir  [Arriba] [Abajo] [Tab] [S-Tab] Mover "
   DO lib_mtec WITH 99
   DO CASE
      CASE i = 1 .AND. Crear
         @  2,60 GET XdFchRec
         READ
         @  2,60 SAY XdFchRec
         XdFchPed = XdFchRec + 45
         UltTecla = LASTKEY()

      CASE i = 2
         SELE AUXI
         @  4,11 GET XsCodAux PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(XsCodAux)
            IF ! cjabusca("AUXI")
               LOOP
            ENDIF
            XsCodAux = CodAux
         ENDIF
         SEEK XsClfAux+XsCodAux
         IF ! FOUND()
            DO lib_merr WITH 6
            LOOP
         ENDIF
         XsRucAux = AUXI->RucAux
         XsNomAux = AUXI->NomAux
         @  4,11 SAY XsCodAux
         @  4,18 SAY XsNomAux PICT "@S33"

      CASE i = 3
         @  4,18 GET XsNomAux PICT "@S33"
         READ
         @  4,18 SAY XsNomAux PICT "@S33"
         UltTecla = LASTKEY()

      CASE i = 4
        *@  4,17 GET XsRucAux PICT '########' VALID  LEN(ALLTRIM(XsRucAux))=8 .and. ! EMPTY(XsRucAux)
         @  5,11 GET XsRucAux PICT '########' VALID  LEN(ALLTRIM(XsRucAux))=8 .OR. EMPTY(XsRucAux)
         READ
         @  5,11 SAY XsRucAux
         UltTecla = LASTKEY()

     *CASE i = 4
     *   SELE PROV
     *   @  4,60 GET XsCodDoc PICT "@!"
     *   READ
     *   UltTecla = LASTKEY()
     *   IF UltTecla = Escape
     *      EXIT
     *   ENDIF
     *   IF UltTecla = F8 .OR. EMPTY(XsCodDoc)
     *      IF ! CBDBUSCA("PROV")
     *         LOOP
     *      ENDIF
     *      XsCodDoc = TpoDoc
     *   ENDIF
     *   @  4,60 SAY XsCodDoc
     *   SEEK XsCodDoc
     *   IF !FOUND()
     *      DO lib_merr WITH 6
     *      LOOP
     *   ENDIF
         @  4,60 SAY XsCodDoc
     *   SELE DPRO
         UltTecla = Enter
      CASE i = 5
         if val(xscoddoc)<=7  &&& FACTURAS, N/D, N/C
            @04,60 GET XsNroRef PICT "@R 999-9999999"  VALID  ! EMPTY(XsNroRef)
            READ
            if XsNroRef <> space(10)
               XsNroRef = tran(val(left(xsnroref,3)),[@L 999])+;
                          tran(val(subs(xsnroref,4)),[@L 9999999])
            endif
            @04,60 SAY XsNroRef pict '@R 999-9999999'
         else
            @04,60 GET XsNroRef PICT "@!"  VALID  ! EMPTY(XsNroRef)
            READ
         endif
         UltTecla = LASTKEY()
         IF CREAR
           IF ! VERIFICA()
              GsMsgErr = [DOCUMENTO DE PROVEEDOR DUPLICADO < CONSULTE EN CONTABILIDAD >]
              DO lib_merr WITH 99
              GsMsgErr = [Prov:]+DPRO.NroAst+[ ]+DPRO.CodAux+[ ]+DPRO.NomAux+[ ]+DPRO.RucAux
              DO lib_merr WITH 99
              i = 1
              RETURN
           ENDIF
         ENDIF


      CASE i = 6
         @  5,60 GET XdFchDoc
         READ
         @  5,60 SAY XdFchDoc
         UltTecla = LASTKEY()

      CASE i = 7
         @  6,60 GET XiDiaVto PICT "9999" RANGE 0,
         READ
         @  6,60 SAY XiDiaVto PICT "9999"
         UltTecla = LASTKEY()
         XdFchVto = XdFchRec + XiDiaVto
         @  7,60 GET XdFchVto
         READ
         @  7,60 SAY XdFchVto
         UltTecla = LASTKEY()
         
      CASE i = 8
         @  8,60 GET XdFchPed
         READ
         @  8,60 SAY XdFchPed
         UltTecla = LASTKEY()

      CASE i = 9
         @  6,17 GET XsNroO_C PICT "@!"
         READ
         @  6,17 SAY XsNroO_C
         UltTecla = LASTKEY()

      CASE i = 10
         @  7,17 GET XsNroGui PICT "@!"
         READ
         @  7,17 SAY XsNroGui
         UltTecla = LASTKEY()

      CASE i = 11 .AND. Crear
         XsCodOpe = PROV->CodOpe
         XsNroAst = LEFT(XsNroDoc,8)
         @ 10,24 SAY XsNroAst
         @ 11,24 SAY XsCodOpe

      CASE i = 12
         DO LIB_MTEC WITH 16
         VecOpc(1)="S/."
         VecOpc(2)="US$"
         XiCodMon= Elige(XiCodMon,10,58,2)

      CASE i = 13
         SELE TCMB
         SEEK DTOS(XdFchDoc)
         XfTpoCmb = iif(OPER->TpoCmb=1,OFICMP,OFIVTA)
         @ 11,58 SAY XfTpoCmb PICT "9,999.9999"
         IF XfTpoCmb <= 0
            GsMsgErr = [ Tipo de Cambio NO ESTA AL DIA]
            DO lib_merr WITH 99
            i = 1
            UltTecla = 0
            LOOP
         ENDIF

      CASE i = 14
         @ 12,58 GET XfImpIgv PICT "999,999,999.999" RANGE 0,
         READ
         @ 12,58 SAY XfImpIgv PICT "999,999,999.999"
         UltTecla = LASTKEY()

      CASE i = 15
         @ 13,58 GET XfImport PICT "999,999,999.999" RANGE 0,
         READ
         @ 13,58 SAY XfImport PICT "999,999,999.999"
         UltTecla = LASTKEY()

      CASE i = 16
         @ 14,21 GET XsNomRec
         READ
         @ 14,21 SAY XsNomRec
         UltTecla = LASTKEY()
                 *******
      CASE i = 17
         @ 15,65 GET XdFchPol
         READ
         @ 15,65 SAY XdFchPol
         UltTecla = LASTKEY()

      CASE i = 18
         @ 15,21 GET XsNomEnv
         READ
         @ 15,21 SAY XsNomEnv
         UltTecla = LASTKEY()

      CASE i = 19
         GsMsgKey = "[Shift+Tab] Anterior  [F10] Grabar  [Esc] Cancelar"
         DO lib_mtec WITH 99
         @ 18,4  EDIT XsObserv SIZE 3,71 COLOR SCHEME 7
         READ
         UltTecla = LASTKEY()
         IF INLIST(UltTecla,F10,CtrlW)
            EXIT
         ENDIF
   ENDCASE
   i = IIF(INLIST(UltTecla,Arriba,BackTab),i-1,i+1)
   i = IIF(i<1,1,i)
   i = IIF(i>19,19,i)
ENDDO
IF UltTecla # Escape
   DO xGrabar
ENDIF
SELE DPRO
UNLOCK ALL
GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] Cขdigo [PgUp] [PgDn] Posicionar"
DO LIB_MTEC WITH 99

RETURN
*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ*


*  ีอออออออออออออออออออออออออออออออออออออออธ
*  ณ VERIFICA   DUPLICIDAD DE DOCUMENTOS   ณ
*  ิอออออออออออออออออออออออออออออออออออออออพ
   FUNCTION VERIFICA
   SELE DPRO
   SET ORDE TO DPRO07
   SEEK XsCodAux+XsCodDoc+XsNroRef
   IF FOUND() .AND. ( XsRucAux = RucAux )
      SET ORDE TO DPRO06
      RETURN .F.
   ENDIF
   SET ORDE TO DPRO06
   RETURN .T.
*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ*


* ีออออออออออออออออออออออออออออออออออออออออธ
* ณ Objetivo : Cargar variables            ณ
* ิออออออออออออออออออออออออออออออออออออออออพ
PROCEDURE xMover
SELE DPRO
XsCodDoc = DPRO->CodDoc
XsNroDoc = DPRO->NroDoc
XsNroRef = DPRO->NroRef
**
XsCodAux = DPRO->CodAux
XsNomAux = DPRO->NomAux
XsRucAux = DPRO->RucAux
XdFchDoc = DPRO->FchDoc
XdFchVto = DPRO->FchVto
XiDiaVto = DPRO->DiaVto
XfImport = DPRO->Import
XfImpBrt = DPRO->ImpBrt
XfImpIgv = DPRO->ImpIgv
XiCodMon = DPRO->CodMon
XfTpoCmb = DPRO->TpoCmb
XdFchRec = DPRO->FchRec
XdFchPed = dpro->fchped
XsNomRec = DPRO->NomRec
XsFchPol = DPRO->FchPol
XsNomEnv = DPRO->NomEnv
XcFlgEst = DPRO->FlgEst
XsObserv = DPRO->Observ
XsNroO_C = DPRO->NroO_C
XsNroGui = DPRO->NroGui
** Variables de Contabilidad **
XsCodOpe = DPRO->CodOpe
XsNroAst = DPRO->NroAst
XsNroVou = DPRO->NroVou
RETURN
*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ*


* ีออออออออออออออออออออออออออออออออธ
* ณ Objetivo : Grabar informaciขn  ณ
* ิออออออออออออออออออออออออออออออออพ
PROCEDURE xGrabar
SELE DPRO
IF Crear
   ** Siempre se toma el control correlativo **
   SELE OPER
   SEEK XsCodOpe
   IF ! REC_LOCK(5)
      RETURN
   ENDIF
   XsNroAst = NroAst()          && << OJO >>
   XsNroDoc = XsNroAst+SPACE(LEN(XsNroDoc)-LEN(XsNroAst))
   IF PROV->TIPO="A"
      XsNroDoc = SUBSTR(XsNroDoc,1,8)+"-"+RIGHT(STR(_ANO,4),2)
   ENDIF
   WAIT [Correlativo Generado >>> ]+XsNroDoc WINDOW NOWAIT
   * * * *
   SELE DPRO
   LsLlave = XsNroMes+XsNroDoc
   SEEK LsLlave
   IF FOUND()
      GsMsgErr = [Registro creado por otro usuario]
      DO lib_merr WITH 99
      RETURN
   ENDIF
   APPEND BLANK
   IF ! REC_LOCK(5)
      RETURN
   ENDIF
   REPLACE NroDoc WITH XsNroDoc
   **
   SELE OPER
   =NroAst(XsNroAst)    && << Actualiza # de asiento en el correlativo >>
   UNLOCK
ENDIF
SELE DPRO
REPLACE CodDoc WITH XsCodDoc
REPLACE NroRef WITH XsNroRef
REPLACE ClfAux WITH XsClfAux
REPLACE CodAux WITH XsCodAux
REPLACE NomAux WITH ALLTRIM(XsNomAux)
REPLACE RucAux WITH XsRucAux
REPLACE FchDoc WITH XdFchDoc
REPLACE FchVto WITH XdFchVto
REPLACE DiaVto WITH XiDiaVto
REPLACE ImpBrt WITH XfImpBrt
REPLACE ImpIgv WITH XfImpIgv
REPLACE Import WITH XfImport
REPLACE SdoDoc WITH XfImport
REPLACE CodMon WITH XiCodMon
REPLACE TpoCmb WITH XfTpoCmb
REPLACE FchRec WITH XdFchRec
repla   FchPed with XdFchPed
REPLACE NomRec WITH XsNomRec
REPLACE FchPol WITH XdFchPol
REPLACE NomEnv WITH XsNomEnv
REPLACE FlgEst WITH XcFlgEst
REPLACE Observ WITH XsObserv
REPLACE NroO_C WITH XsNroO_C
REPLACE NroGui WITH XsNroGui
REPLACE CodOpe WITH XsCodOpe
REPLACE NroMes WITH XsNroMes
REPLACE NroAst WITH LEFT(XsNroDoc,8)
REPLACE NroVou WITH XsNroDoc
REPLACE FchAst WITH XdFchRec
REPLACE CodCta WITH PROV->CodCta

RETURN
*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ*


*ีออออออออออออออออออออออออออออออออออออออออธ
*ณ Objetivo : Borrar informaciขn          ณ
*ิออออออออออออออออออออออออออออออออออออออออพ
PROCEDURE xBorrar

SELE DPRO
IF FlgEst = [G]
   GsMsgErr = [NO PUEDE ANULAR ESTE REGISTRO]
   DO lib_merr WITH 99
   RETURN
ENDIF
IF FlgEst = [X]
   GsMsgErr = [NO PUEDE ANULAR ESTE REGISTRO]
   DO lib_merr WITH 99
   RETURN
ENDIF
IF FlgEst = [C]
   GsMsgErr = [Documento Cancelado]
   DO lib_merr WITH 99
   RETURN
ENDIF
IF FlgEst = [A]
   GsMsgErr = [Documento Anulado]
   DO lib_merr WITH 99
   RETURN
ENDIF
IF ! RLOCK()
   RETURN
ENDIF
SELE DPRO
DELETE
UNLOCK ALL
SKIP
RETURN
*อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ*


* ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
* ณ  Reporte de Documentos digitados por dia de recepciขn   ณ
* ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
PROCEDURE XREPORTE
SAVE SCREEN TO  PANT
CLEAR
@ 2,0 TO 20,79 PANEL
@ 2,20  SAY "LISTADO DE DOCUMENTOS RECEPCIONADOS DE PROVEEDORES"
** variables a usar **
PRIVATE XdFchRec
XcFlgEst = " "
XdFchRe1 = DATE()
XdFchRe2 = DATE()
** pantalla de datos **
@ 10,20 SAY "F.Recepcion Desde :" GET XdFchRe1
@ 11,20 SAY "F.Recepcion Hasta :" GET XdFchRe2
@ 12,20 SAY "Situaciขn         :" GET XcFlgEst VALID FlgEst$"GPAX "
READ
IF LASTKEY() = Escape
   RESTORE  SCREEN FROM  PANT
   RETURN
ENDIF
** test de impresiขn **
XFOR1 = [.T.]
IF !EMPTY(XcFlgEst)
   XFOR1=[FlgEst=XcFlgEst]
ENDIF
XFOR   = "FchRec>=XdFchRe1 .AND. FchRec<=XdFchRe2 .AND."+XFOR1
XWHILE = "NroMes=XsNroMes"
** buscamos registro de arranque **
SELE DPRO
SET ORDER TO DPRO06
SEEK XsNroMes
Largo  = 66       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN3]
*IniPrn = ''
sNomRep = "cjar5100"
DO admprint WITH "REPORTS"
RESTORE  SCREEN FROM PANT
SET ORDER TO DPRO06
RETURN


********************************************************************** FIN() *
* Objetivo : Localizar el documento por el No. de Asiento
******************************************************************************
PROCEDURE xLocalizar

GsMsgKey = "[Esc] Salir  [Enter] Registrar"
DO LIB_MTEC WITH 99
SELE DPRO
PRIVATE XsNroAst
XsNroDoc = SPACE(LEN(DPRO->NroAst))
@ 10,18 GET XsNroAst PICT "@!"
READ
IF LASTKEY() # Escape .AND. !EMPTY(XsNroAst+XsNroO_C)
   DO CASE
      CASE !EMPTY(XsNroAst) .AND. EMPTY(XsNroO_C)
         LOCATE FOR TRIM(XsNroAst)$NroAst
      CASE EMPTY(XsNroAst) .AND. !EMPTY(XsNroO_C)
         LOCATE FOR TRIM(XsNroO_C)$NroO_C
      OTHER
         LOCATE FOR TRIM(XsNroO_C)$NroO_C .AND. TRIM(XsNroAst)$NroAst
   ENDCASE
   DO WHILE FOUND()
      DO xPoner
      cResp = [N]
      cResp = aviso(18,[Continua la Busqueda],[<S>i  o  <N>o],[],;
              3,[SN],0,.F.,.F.,.T.)
      IF cResp = [N]
         EXIT
      ENDIF
      CONTINUE
   ENDDO
ENDIF
GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] Cขdigo [PgUp] [PgDn] Posicionar"
DO LIB_MTEC WITH 99
RETURN

***************
FUNCTION NROAST
***************

PARAMETER XsNroAst
DO CASE
   CASE XsNroMES = "00"
     iNroDoc = OPER->NDOC00
   CASE XsNroMES = "01"
     iNroDoc = OPER->NDOC01
   CASE XsNroMES = "02"
     iNroDoc = OPER->NDOC02
   CASE XsNroMES = "03"
     iNroDoc = OPER->NDOC03
   CASE XsNroMES = "04"
     iNroDoc = OPER->NDOC04
   CASE XsNroMES = "05"
     iNroDoc = OPER->NDOC05
   CASE XsNroMES = "06"
     iNroDoc = OPER->NDOC06
   CASE XsNroMES = "07"
     iNroDoc = OPER->NDOC07
   CASE XsNroMES = "08"
     iNroDoc = OPER->NDOC08
   CASE XsNroMES = "09"
     iNroDoc = OPER->NDOC09
   CASE XsNroMES = "10"
     iNroDoc = OPER->NDOC10
   CASE XsNroMES = "11"
     iNroDoc = OPER->NDOC11
   CASE XsNroMES = "12"
     iNroDoc = OPER->NDOC12
   CASE XsNroMES = "13"
     iNroDoc = OPER->NDOC13
   OTHER
     iNroDoc = OPER->NRODOC
ENDCASE

IF OPER->ORIGEN
   ZZ      = TsCOdDiv1+XsNroMes + RIGHT("00000000" + LTRIM(STR(iNroDoc)), 4)
   iNroDoc = VAL(ZZ)
ENDIF

IF PARAMETER() = 1
   IF VAL(XsNroAst) > iNroDoc
     iNroDoc = VAL(XsNroAst) + 1
   ELSE
     iNroDoc = iNroDoc + 1
   ENDIF

   DO CASE
      CASE XsNroMES = "00"
        REPLACE   OPER->NDOC00 WITH iNroDoc
      CASE XsNroMES = "01"
        REPLACE   OPER->NDOC01 WITH iNroDoc
      CASE XsNroMES = "02"
        REPLACE   OPER->NDOC02 WITH iNroDoc
      CASE XsNroMES = "03"
        REPLACE   OPER->NDOC03 WITH iNroDoc
      CASE XsNroMES = "04"
        REPLACE   OPER->NDOC04 WITH iNroDoc
      CASE XsNroMES = "05"
        REPLACE   OPER->NDOC05 WITH iNroDoc
      CASE XsNroMES = "06"
        REPLACE   OPER->NDOC06 WITH iNroDoc
      CASE XsNroMES = "07"
        REPLACE   OPER->NDOC07 WITH iNroDoc
      CASE XsNroMES = "08"
        REPLACE   OPER->NDOC08 WITH iNroDoc
      CASE XsNroMES = "09"
        REPLACE   OPER->NDOC09 WITH iNroDoc
      CASE XsNroMES = "10"
        REPLACE   OPER->NDOC10 WITH iNroDoc
      CASE XsNroMES = "11"
        REPLACE   OPER->NDOC11 WITH iNroDoc
      CASE XsNroMES = "12"
        REPLACE   OPER->NDOC12 WITH iNroDoc
      CASE XsNroMES = "13"
        REPLACE   OPER->NDOC13 WITH iNroDoc
      OTHER
        REPLACE   OPER->NRODOC WITH iNroDoc
   ENDCASE
   UNLOCK IN OPER
ENDIF
RETURN  RIGHT("00000000" + LTRIM(STR(iNroDoc)), 8)
