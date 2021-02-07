*****************************************************************************
* Programa     : cjar3600.prg
* Sistema      : Caja Bancos
* Autor        : RHC
* Proposito    : Consulta de Ingresos de Caja
* Creacion     : 03/10/94
* Actualizaciขn: 30/11/94 RHC Corregir detalle
*                05/11/94 RHC Agregar parametros de generacion
*****************************************************************************

CLEAR
* Pantalla de Datos
GcTit1 = GsNomCia
GcTit2 = [Caja Bancos]
GcTit3 = DTOC(DATE())
GcTit4 = [User : ]+TRIM(GsUsuario)
DO FONDO WITH GcTit1,GcTit2,GcTit3,GcTit4
Titulo = [>> INGRESOS DE CAJA <<]
@ 2,(80-LEN(Titulo))/2 SAY Titulo COLOR SCHEME 7
@ 5,10 CLEAR TO 21,69
@ 5,10 TO 21,69 DOUBLE
@  9,26 TO 13,47
@ 10,15 SAY "Ordenado :"
@ 15,15 SAY "Cuenta Receptora : "
@ 16,15 SAY "Cliente          : "
@ 17,15 SAY "Desde el dia     :          al dia         "
*
CLOSE DATA
DO xListar
CLOSE DATA

RETURN
*********************************************************************** EOP() *
* Objeto : Logica Principal
*******************************************************************************
PROCEDURE xListar

* Aperturando bases
DO lib_msgs WITH 11
USE cbdvmovm IN 0 ORDER VMOV01 ALIAS VMOV
IF !USED()
   RETURN
ENDIF
*
USE cbdrmovm IN 0 ORDER RMOV01 ALIAS RMOV
IF !USED()
   RETURN
ENDIF
*
USE cbdmauxi IN 0 ORDER AUXI01 ALIAS AUXI
IF ! USED()
   CLOSE DATA
   RETURN
ENDIF
*
USE cbdmtabl IN 0 ORDER TABL01 ALIAS TABL
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
*
USE cbdmctas IN 0 ORDER CTAS01 ALIAS CTAS
IF !USED()
   CLOSE DATA
   RETURN
ENDIF
SELE CTAS
SET FILTER TO AftMov=[S]
*
Arch = PathUser+SYS(3)
SELE VMOV
COPY STRU TO &Arch.
SELE 0
USE &Arch. ALIAS TEMPO1 EXCLU
IF !USED()
   RETURN
ENDIF
* * * *
Arch1 = PathUser+SYS(3)
Arch2 = PathUser+SYS(3)
SELE RMOV
COPY STRU TO &Arch1
SELE 0
USE &Arch1. ALIAS TEMPO2 EXCLU
IF !USED()
   RETURN
ENDIF
* Variables a usar *
PRIVATE XiOrden,XsCtaCja,XsCodAux,XdFechaD,XdFechaH
XiOrden = 1
XdFechaH = DATE()
XdFechaD = DATE() - DAY(DATE()) + 1
* Caso : si es diferente mes *
IF MONTH(DATE())#_MES
   XdFechaD = CTOD('01/'+TRANS(_MES,'@L 99')+'/'+STR(_ANO,4))
   XiMes = _MES + 1
   XiAno = _ANO
   IF XiMes > 12
      XiMes = XiMes - 12
      XiAno = XiAno + 1
   ENDIF
   XdFechaH = CTOD('01/'+TRANS(XiMes,'@L 99')+'/'+STR(XiAno,4))
   XdFechaH = XdFechaH - DAY(XdFechaH)
ENDIF
SAVE SCREEN TO LsPan01
DO WHILE .T.
   XsCtaCja = SPACE(LEN(CTAS->CodCta))
   XsCodAux = SPACE(LEN(AUXI->CodAux))
   UltTecla = 0
   i = 1
   DO WHILE UltTecla # Escape
      DO lib_mtec WITH 8
      DO CASE
         CASE i = 1
            GsMsgKey = "[Esc] Salir   [Enter] Aceptar   [] [] Seleccionar "
            DO lib_mtec WITH 99
            @ 10,27 PROMPT "      Por Dia       "
            @ 11,27 PROMPT "Por Cuenta Receptora"
            @ 12,27 PROMPT "    Por Cliente     "
            MENU TO XiOrden
            IF XiOrden = 0
               UltTecla = Escape
               EXIT
            ENDIF
            UltTecla = Enter
         CASE i = 2
            SELE CTAS
            GsMsgKey = "[Esc] Salir  [F8] Consultar  [Enter] Aceptar"
            DO lib_mtec WITH 99
            @ 15,34 GET XsCtaCja PICT "@!"
            READ
            UltTecla = LASTKEY()
            IF INLIST(UltTecla,BackTab,Arriba,Escape)
               i = i - 1
               LOOP
            ENDIF
            IF UltTecla = F8
               IF !cjabusca("0014")
                  LOOP
               ENDIF
               XsCtaCja = CodCta
            ENDIF
            @ 15,34 SAY XsCtaCja
            IF !EMPTY(XsCtaCja)
               SEEK XsCtaCja
               IF !FOUND()
                  DO lib_merr WITH 6
                  LOOP
               ENDIF
            ENDIF
         CASE i = 3
            SELE AUXI
            GsMsgKey = "[Esc] Salir  [F8] Consultar  [Enter] Aceptar"
            DO lib_mtec WITH 99
            XsClfAux = [CLI]  && Clientes
            @ 16,34 GET XsCodAux PICT "@!"
            READ
            UltTecla = LASTKEY()
            IF INLIST(UltTecla,BackTab,Arriba,Escape)
               i = i - 1
               LOOP
            ENDIF
            IF UltTecla = F8
               IF !cjabusca("AUXI")
                  LOOP
               ENDIF
               XsCodAux = CodAux
            ENDIF
            @ 16,34 SAY XsCodAux
            IF !EMPTY(XsCodAux)
               SEEK XsClfAux+XsCodAux
               IF !FOUND()
                  DO lib_merr WITH 6
                  LOOP
               ENDIF
               XsCodAux = CodAux
            ENDIF
         CASE i = 4
            @ 17,34 GET XdFechaD
            @ 17,50 GET XdFechaH
            READ
            UltTecla = LASTKEY()
      ENDCASE
      IF i = 4 .AND. UltTecla = Enter
         EXIT
      ENDIF
      i = IIF(INLIST(UltTecla,Arriba,BackTab),i-1,i+1)
      i = IIF(i<1,1,i)
      i = IIF(i>4,4,i)
   ENDDO
   IF UltTecla = Escape
      EXIT
   ENDIF
   DO xGenera
   SELE TEMPO1
   GO TOP
   IF !EOF()
      DO xPanta
      IF XiOrden = 3    && Por Cliente
         DO xBrowse2
      ELSE
         DO xBrowse
      ENDIF
   ELSE
      GsMsgErr= [Fin de Archivo]
      DO lib_merr WITH 99
   ENDIF
   RESTORE SCREEN FROM LsPan01
ENDDO
CLOSE DATA

RETURN
************************************************************************ FIN *
* Objeto : Pantalla de Datos
*******************************************************************************
PROCEDURE xPanta

*           1         2         3         4         5         6         7         8
**01234567890123456789012345678901234567890123456789012345678901234567890123456789
*5  ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
*6  บ   Fecha  Voucher Cuenta   Descripciขn                 Mon      Importe   บ
*7  ฬออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออน
*8  บ 99/99/99 123456  12345 123456789012345678901234567890 US$ 999,999,999.99 บ
*9  บ 99/99/99 123456  12345 12345678901234567890 12345678  US$ 999,999,999.99 บ
*0  บ 99/99/99 123456  12345 12345678901234567890 12345678  US$ 999,999,999.99 บ
*1  บ 99/99/99 123456  12345 12345678901234567890 12345678  US$ 999,999,999.99 บ
*2  บ 99/99/99 123456  12345 12345678901234567890 12345678  US$ 999,999,999.99 บ
*3  ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*4ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
*5ณ Cliente  Mon     Importe    Cheque      Banco Emisor      Cuenta Emisora     ณ
*6รฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤด
*7ณ 12345678 S/.(9,999,999.99) 1234567890  12345678901234567  123456789012345678 ณ
*8ณ 12345678 S/.(9,999,999.99) 1234567890  123456789012345  12345678901234567890 ณ
*9ณ 12345678 999,999,999.99                                                      ณ
*0ณ 12345678 999,999,999.99                                                      ณ
*1ณ 12345678 S/.(9,999,999.99) 1234567890  12345678901234567  123456789012345678 ณ
*2ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
**01234567890123456789012345678901234567890123456789012345678901234567890123456789
*           1         2         3         4         5         6         7         8


@  5,2  SAY "ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป"
@  6,2  SAY "บ   Fecha  Voucher Cuenta   Descripciขn                 Mon      Importe   บ"
@  7,2  SAY "ฬออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออน"
@  8,2  SAY "บ                                                                          บ"
@  9,2  SAY "บ                                                                          บ"
@ 10,2  SAY "บ                                                                          บ"
@ 11,2  SAY "บ                                                                          บ"
@ 12,2  SAY "บ                                                                          บ"
@ 13,2  SAY "ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ"
@ 14,0  SAY "ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ"
@ 15,0  SAY "ณ Cliente  Mon     Importe    Cheque      Banco Emisor      Cuenta Emisora     ณ"
@ 16,0  SAY "รฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤด"
@ 17,0  SAY "ณ                                                                              ณ"
@ 18,0  SAY "ณ                                                                              ณ"
@ 19,0  SAY "ณ                                                                              ณ"
@ 20,0  SAY "ณ                                                                              ณ"
@ 21,0  SAY "ณ                                                                              ณ"
@ 22,0  SAY "ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู"

@ 6,3 FILL TO 6,76 COLOR SCHEME 7
@ 15,1 FILL TO 15,78 COLOR SCHEME 7

RETURN
************************************************************************ FIN *
* Objeto : Generar la base auxiliar de trabajo
******************************************************************************
PROCEDURE xGenera

SELE TEMPO2
ZAP
INDEX ON NroMes+CodOpe+NroAst TO &Arch1.
INDEX ON IniAux               TO &Arch2.
SET INDEX TO &Arch1.,&Arch2.
SELE TEMPO1
ZAP
INDEX ON NroMes+CodOpe+NroAst TO &Arch.
* Test de grabacion *
xFOR1 = [.T.]
xFOR2 = [.T.]
xFOR3 = [XdFechaD<=FchAst.AND.XdFechaH>=FchAst]
IF !EMPTY(XsCtaCja)
   xFOR1 = [CtaCja=XsCtaCja]
ENDIF
IF !EMPTY(XsCodAux)
   xFOR2 = [CodAux=XsCodAux]
ENDIF
* * * *
SELE VMOV
XsNroMes = TRANS(_MES,"@L ##")
XsCodOpe = [005]
SEEK XsNroMes+XsCodOpe
SCAN WHILE NroMes+CodOpe = XsNroMes+XsCodOpe ;
     FOR FlgEst # [A] .AND. &xFOR1 .AND. &xFOR3
   SELE TEMPO1
   APPEND BLANK
   REPLACE NroMes WITH VMOV->NroMes
   REPLACE CodOpe WITH VMOV->CodOpe
   REPLACE NroAst WITH VMOV->NroAst
   REPLACE CodMon WITH VMOV->CodMon
   REPLACE FchAst WITH VMOV->FchAst
   REPLACE NotAst WITH VMOV->NotAst
   REPLACE CtaCja WITH VMOV->CtaCja
   REPLACE ImpChq WITH VMOV->ImpChq
   * cargamos detalles *
   SELE RMOV
   SEEK VMOV->NroMes+VMOV->CodOpe+VMOV->NroAst
   SCAN WHILE NroMes+CodOpe+NroAst=VMOV->NroMes+VMOV->CodOpe+VMOV->NroAst ;
        FOR CodCta = [121] .AND. &xFOR2   && OJO >> Facturas,N/C
      SELE TEMPO2
      APPEND BLANK
      REPLACE NroMes WITH RMOV->NroMes
      REPLACE CodOpe WITH RMOV->CodOpe
      REPLACE NroAst WITH RMOV->NroAst
      REPLACE CodCta WITH RMOV->CodCta
      REPLACE CodAux WITH RMOV->CodAux
      REPLACE CodMon WITH RMOV->CodMon
      REPLACE Import WITH IIF(CodMon=1,RMOV->Import,RMOV->ImpUsa)
      REPLACE NroChq WITH RMOV->NroChq
      REPLACE CodBco WITH RMOV->CodBco
      REPLACE NroCta WITH RMOV->NroCta
      REPLACE TpoMov WITH RMOV->TpoMov
      * buscamos cliente *
      =SEEK(CodCta,"CTAS")
      IF CTAS->PidAux = [S]
         XsTabla = "01"
         IF !EMPTY(CTAS->ClfAux)
            XsCodAux = RMOV->CodAux
            XsClfAux = CTAS->ClfAux
            IF SEEK(XsTabla+XsClfAux,"TABL")
               IF SEEK(XsClfAux+XsCodAux,"AUXI")
                  REPLACE TEMPO2->IniAux WITH IIF(EMPTY(AUXI->IniAux),AUXI->NomAux,AUXI->IniAux)
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      *
      SELE RMOV
   ENDSCAN
   *
   SELE VMOV
ENDSCAN
* Depurando Cabeceras *
SELE TEMPO1
GO TOP
DO WHILE !EOF()
   IF !SEEK(NroMes+CodOpe+NroAst,"TEMPO2")
      DELETE
   ENDIF
   SKIP
ENDDO
* Depurando Detalle *
SELE TEMPO2
GO TOP
DO WHILE !EOF()
   IF !SEEK(NroMes+CodOpe+NroAst,"TEMPO1")
      DELETE
   ENDIF
   SKIP
ENDDO
*
RETURN
************************************************************************ FIN *
* Poner datos en pantalla
******************************************************************************
PROCEDURE xBrowse

* Indexamos de acuerdo a necesidades *
SELE TEMPO1
DO CASE
   CASE XiOrden = 1
      INDEX ON DTOS(FchAst) TO &Arch.
   CASE XiOrden = 2
      INDEX ON CtaCja       TO &Arch.
   *CASE XiOrden = 3
   *   INDEX ON NomCli       TO &Arch.
   OTHER
      RETURN
ENDCASE
SELE TEMPO1
SET RELA TO CtaCja INTO CTAS
GO TOP
** datos del Browse **
PRIVATE Consulta,Modifica,Adiciona,Db_Pinta,Set_Escape
Consulta = .T.
Modifica = .F.
Adiciona = .F.
DB_Pinta = .F.
Set_Escape=.T.
PRIVATE SelLin,InsLin,EscLin,EdiLin,BrrLin,GrbLin
PRIVATE MVprgF1,MMVprgF2,MVprgF3,MVprgF4,MVprgF5,MVprgF6,MVprgF7,MVprgF8,MVprgF9
PRIVATE PrgFin,Titulo,NClave,VClave,HTitle,Yo,Xo,Largo,Ancho,TBorder
PRIVATE E1,E2,E3,LinReg
PRIVATE Static,VSombra
UltTecla = 0
SelLin   = [xBSeli]
InsLin   = []
EscLin   = []
EdiLin   = []
BrrLin   = []
GrbLin   = []
MVprgF1  = []
MVprgF2  = []
MVprgF3  = []
MVprgF4  = []
MVprgF5  = []
MVprgF6  = []
MVprgF7  = []
MVprgF8  = []
MVprgF9  = []
PrgFin   = []
Titulo   = []
NClave   = []
VClave   = []
HTitle   = 1
Yo       = 7
Xo       = 2
Largo    = 7
Ancho    = 76
TBorde   = Nulo
E1       = []
E2       = []
E3       = []
LinReg   = [DTOC(FchAst)+' '+NroAst+'  '+CtaCja+' '+LEFT(CTAS->NomCta,30)+' '+;
            IIF(CodMon=1,'S/.','US$')+' '+TRANS(ImpChq,'999,999,999.99')+' ']
Static   = .T.
VSombra  = .F.
*
SELE TEMPO1
GO TOP
GsMsgKey = " [Esc]  Salir  [Home] [End] Posicionar  [PgDn] [PgUp] Mover"
DO lib_mtec WITH 99
DO DBrowse

RETURN
************************************************************************ FIN *
* Objeto : Seleccion de Linea
******************************************************************************
PROCEDURE xBSeli

PRIVATE NumLin,LsLlave
LsLlave = NroMes+CodOpe+NroAst
SELE TEMPO2
SET ORDER TO 1
SEEK LsLlave
NumLin = 17
@ 17,1 CLEAR TO 21,78
SCAN WHILE NroMes+CodOpe+NroAst=LsLlave FOR ! INLIST(EliItm,"๙","๚","๘")
   IF NumLin <= 21
      @ NumLin,2  SAY IniAux
      @ NumLin,11 SAY IIF(CodMon=1,'S/','US$')
      @ NumLin,14 SAY IIF(TpoMov=[H],Import,-1*Import) PICT "@( 9,999,999.99"
      @ NumLin,29 SAY NroChq
      =SEEK([04]+CodBco,"TABL")
      @ NumLin,41 SAY TABL->Nombre PICT "@S17"
      @ NumLin,60 SAY NroCta PICT "@S18"
   ENDIF
   NumLin = NumLin + 1
ENDSCAN
SELE TEMPO1

RETURN
************************************************************************ FIN *
****************  SEGUNDO BROWSE DE BUSQUEDA  ********************************
************************************************************************ FIN *
* Poner datos en pantalla
******************************************************************************
PROCEDURE xBrowse2

* Indexamos de acuerdo a necesidades *
SELE TEMPO1
INDEX ON NroMes+CodOpe+NroAst TO &Arch.
SET RELA TO CtaCja INTO CTAS
SELE TEMPO2
SET ORDER TO 2
SET RELA TO [04]+CodBco INTO TABL
GO TOP
** datos del Browse **
PRIVATE Consulta,Modifica,Adiciona,Db_Pinta,Set_Escape
Consulta = .T.
Modifica = .F.
Adiciona = .F.
DB_Pinta = .F.
Set_Escape=.T.
PRIVATE SelLin,InsLin,EscLin,EdiLin,BrrLin,GrbLin
PRIVATE MVprgF1,MMVprgF2,MVprgF3,MVprgF4,MVprgF5,MVprgF6,MVprgF7,MVprgF8,MVprgF9
PRIVATE PrgFin,Titulo,NClave,VClave,HTitle,Yo,Xo,Largo,Ancho,TBorder
PRIVATE E1,E2,E3,LinReg
PRIVATE Static,VSombra
UltTecla = 0
SelLin   = [xBSeli2]
InsLin   = []
EscLin   = [xBEscl2]
EdiLin   = []
BrrLin   = []
GrbLin   = []
MVprgF1  = []
MVprgF2  = []
MVprgF3  = []
MVprgF4  = []
MVprgF5  = []
MVprgF6  = []
MVprgF7  = []
MVprgF8  = []
MVprgF9  = []
PrgFin   = []
Titulo   = []
NClave   = []
VClave   = []
HTitle   = 1
Yo       = 16
Xo       = 0
Largo    = 7
Ancho    = 80
TBorde   = Nulo
E1       = []
E2       = []
E3       = []
LinReg   = []
Static   = .T.
VSombra  = .F.
*
SELE TEMPO2
GO TOP
GsMsgKey = " [Esc]  Salir  [Home] [End] Posicionar  [PgDn] [PgUp] Mover"
DO lib_mtec WITH 99
DO DBrowse
SELE TEMPO2
SET RELA TO

RETURN
************************************************************************ FIN *
* Objeto : Seleccion de Linea
******************************************************************************
PROCEDURE xBSeli2

PRIVATE NumLin,LsLlave
LsLlave = NroMes+CodOpe+NroAst
SELE TEMPO1
SEEK LsLlave
@  8,4  SAY FchAst
@  8,13 SAY NroAst
@  8,21 SAY CtaCja
@  8,27 SAY CTAS->NomCta PICT "@S30"
SELE TEMPO2

RETURN
************************************************************************ FIN *
* Objeto : Linea a imprimir
******************************************************************************
PROCEDURE xBEscl2
PARAMETER Contenido

Contenido = IniAux+' '+IIF(CodMon=1,'S/.','US$')
IF TpoMov = [H]
   Contenido = Contenido + TRANS(Import,'@( 9,999,999.99')+' '
ELSE
   Contenido = Contenido + TRANS(-1*Import,'@( 9,999,999.99')+' '
ENDIF
Contenido = Contenido + NroChq+'  '+LEFT(TABL->Nombre,17)+' '+LEFT(NroCta,18)

RETURN
************************************************************************ FIN *
