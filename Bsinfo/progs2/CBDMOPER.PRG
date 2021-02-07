SELECT 2
USE CBDMTABL order TABL01 ALIAS TABL
IF ! USED(2)
   CLOSE DATA
   RETURN
ENDIF
SELE 1
USE CBDTOPER order OPER01 ALIAS OPER
IF ! USED(1)
   CLOSE DATA
   RETURN
ENDIF
**** Variables *****
STORE 0 TO ;
  XsCodOpe,XsNOMOpe,XnCODMON,XnTPOCOR,XiNroDoc,XsCodUsr,XsSiglas,XiTpoCmb,XlDiario,XsLibros
_Libro = "LC"  
*** Pintamos pantalla *************
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "OPERACIONES CONTABLES"
Do Fondo WITH cTit1,cTit2,cTit3,cTit4

XsNroMes = TRANSF(_MES,"@L ##")

@ 10,3 FILL  TO 19,73      COLOR W/N
@ 08,5 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" COLOR SCHEME 11
@ 09,5 SAY "³                                                                     ³" COLOR SCHEME 11
@ 10,5 SAY "³         C¢digo :                                                    ³" COLOR SCHEME 11
@ 11,5 SAY "³    Descripci¢n :                                                    ³" COLOR SCHEME 11
@ 12,5 SAY "³         Siglas :                                                    ³" COLOR SCHEME 11
@ 13,5 SAY "³                         Moneda  :                                   ³" COLOR SCHEME 11
@ 14,5 SAY "³                 Tipo de Cambio  :                                   ³" COLOR SCHEME 11
@ 15,5 SAY "³        Correlativo de Documento :                                   ³" COLOR SCHEME 11
@ 16,5 SAY "³        Antepone el Mes en el N§ :                                   ³" COLOR SCHEME 11
@ 17,5 SAY "³             Usuario Responsable :                                   ³" COLOR SCHEME 11
@ 18,5 SAY "³         Libro contable asociado :                                   ³" COLOR SCHEME 11
@ 19,5 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" COLOR SCHEME 11
**********************************************************************
** Rutina principal *****
**********************************************************************
GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] C¢digo [PgUp] [PgDn] [^PgUp] [^PgDn] Otro Registro"
DO LIB_MTEC WITH 99
DO EDITA WITH 'Llave','Muestra','Editar','Elimina','Reporte','','','CMAR'
CLOSE DATA
CLEAR
RETURN
*********************************************************************
* Pide Variables de Busqueda ( Crear , Modificar , Anular )          *
**********************************************************************
PROCEDURE Llave
****************
GsMsgKey = "[Esc] Cancela         [Enter] [F10] Acepta         [F8] Consulta "
DO LIB_MTEC WITH 99
XsCodOpe = CodOpe
UltTecla = 0
i        = 1
DO WHILE ! INLIST(UltTecla,CTRLW,ESCAPE,F10)
   DO CASE
      CASE i = 1
         @ 10,24 GET XsCODOpe PICTURE REPLICATE("9",LEN(XsCODOpe))
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8 .OR. EMPTY(XsCODope)
            IF ! CBDBUSCA("OPER")
               LOOP
            ENDIF
            XsCODOPE = CODTOPE
            UltTecla = Enter
         ENDIF
         @ 10,24 SAY XsCODOPE
      CASE i = 2
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
         i = 0
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>2,2, i)
   i = IIF(i<1 , 1, i)
ENDDO
SEEK XsCodOPE
IF UltTecla = Escape
   GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] C¢digo [PgUp] [PgDn] [^PgUp] [^PgDn] Otro Registro"
   DO LIB_MTEC WITH 99
ENDIF
RETURN
**********************************************************************
* Muestra datos en la pantalla ( Modificar , Anular ,Localizar )     *
**********************************************************************
PROCEDURE Muestra
*****************
@ 10,24  SAY  CodOPE
@ 11,24  SAY  NOMOPE
@ 12,24  SAY  SIGLAS
DO CASE
   CASE CODMON = 1
      @ 13,41  SAY  "SOLES             "
   CASE CODMON = 2
      @ 13,41  SAY  "DOLARES AMERICANOS"
   CASE CODMON = 3
      @ 13,41  SAY  "SOLES/DOLARES     "
   CASE CODMON = 4
      @ 13,41  SAY  "MULTIPLE          "
ENDCASE

DO CASE
   CASE tpocmb = 1
      @ 14,41  SAY  "COMPRA            "
   OTHER
      @ 14,41  SAY  "VENTA             "
ENDCASE

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
@ 15,41  SAY  iNroDoc PICT "@L ########"

DO CASE
   CASE ORIGEN
      @ 16,41  SAY  "SI                "
   OTHER
      @ 16,41  SAY  "NO                "
ENDCASE


@ 17,41  SAY  CodUsr
@ 18,41  SAY  Libros+" "+padr(IIF(SEEK(_Libro+Libros,"TABL"),TABL.Nombre," "),30)

RETURN
**********************************************************************
* Edita registro seleccionado (Crear Modificar , Anular )            *
**********************************************************************
PROCEDURE EDITAR
****************
GsMsgKey = "[] [] [Enter] Registra [F10] Graba [Esc] Cancela"
DO LIB_MTEC WITH 99
DO TOMA
IF ! CREAR
   DO CASE
      CASE Master
      CASE EMPTY(XsCodUsr)
      CASE XsCodUsr = GsUsuario
      OTHER
         GsMsgErr = "Usuario no autorizado"
         DO LIB_MERR WITH 99
         UltTecla = Escape
         RETURN
   ENDCASE
ENDIF
i = 1
UltTecla = 0
DO WHILE ! INLIST(UltTecla,CTRLW,ESCAPE,F10,PgUp,PgDn)
   DO CASE
      CASE i = 1
          @ 11,24  GET XsNomOPE
          READ
          UltTecla = LASTKEY()
          @ 11,24  SAY XsNomOPE
      CASE i = 2
          @ 12,24  GET XsSiglas
          READ
          UltTecla = LASTKEY()
          @ 12,24  SAY XsSiglas
      CASE i = 3
         VecOpc(1) = "Soles             "
         VecOpc(2) = "Dolares Americanos"
         VecOpc(3) = "Soles/Dolares     "
         VecOpc(4) = "Multiple          "
         XnCodMon=Elige(XnCodMon,13,41,4)
      CASE i = 4
         VecOpc(1) = "Compra            "
         VecOpc(2) = "Venta             "
         XiTpoCmb=Elige(XiTpoCmb,14,41,2)
      CASE i = 5
         @ 15,41  GET  XiNroDoc PICT "@L ########"
         READ
         UltTecla = LASTKEY()
      CASE i = 6
         XiDiario = 2
         IF XlDiario
            XiDiario = 1
         ENDIF
         VecOpc(1) = "Si"
         VecOpc(2) = "No"
         XiDiario=Elige(XiDiario,16,41,2)
         XlDiario = XiDiario = 1


      CASE i = 7 .AND. Master
         @ 17,41  GET  XsCodUsr PICT "@!"
         READ
         UltTecla = LASTKEY()
      CASE i = 8 
		 sele TABL	      
         XsTabla = _Libro
         @ 18,41  GET  XsLibros PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = F8
         	IF !cbdbusca("TABL")
         		LOOP
         	ENDIF
            XsLibros = PADR(TABL.Codigo,LEN(oper.Libros))
			UltTecla = Enter
         ENDIF
         IF !Seek(_Libro+XsLibros,"TABL")
         	DO F1msgerr with "Libro contable mal Configurado"
         	UltTecla = 0
         	Loop
         endif
         @ 18,41  SAY XsLibros+" "+padr(IIF(SEEK(_Libro+XsLibros,"TABL"),TABL.Nombre," "),30)
         SELE OPER
      CASE i = 9
         IF UltTecla = Enter
            UltTecla = CtrlW
         ENDIF
         i = 0
   ENDCASE
   i = IIF(UltTecla = Arriba, i-1, i+1)
   i = IIF(i>9,9, i)
   i = IIF(i<1 , 1, i)
ENDDO
IF UltTecla <> Escape
   DO GRABA
ENDIF
GsMsgKey = "[Esc] Salir  [Enter] Registrar [End] C¢digo [PgUp] [PgDn] [^PgUp] [^PgDn] Otro Registro"
DO LIB_MTEC WITH 99
RETURN
**********************************************************************
* ELIMINA REGISTRO                                                   *
**********************************************************************
PROCEDURE ELIMINA
*****************
IF ! Master
   GsMsgErr = "Usuario no autorizado"
   DO LIB_MERR WITH 99
   UltTecla = Escape
   RETURN
ENDIF
IF RLock()
   DELETE
   SKIP
   UNLOCK
ENDIF
RETURN
*************************************************************************** FIN
* Procedimiento de CARGA A VARIABLES
******************************************************************************
PROCEDURE TOMA
**************
XlDiario=Origen
XsSIGLAS=SIGLAS
XsNOMOPE=NOMOPE
XnCodMon=CodMon
XnTpoCor=TpoCor
XiTpoCmb=TpoCmb
XsCodUsr=CodUsr
XsLibros= Libros
IF ! Crear
   XsCodOpe = CodOpe
   DO CASE
      CASE XsNroMES = "00"
        XiNroDoc = OPER->NDOC00
      CASE XsNroMES = "01"
        XiNroDoc = OPER->NDOC01
      CASE XsNroMES = "02"
        XiNroDoc = OPER->NDOC02
      CASE XsNroMES = "03"
        XiNroDoc = OPER->NDOC03
      CASE XsNroMES = "04"
        XiNroDoc = OPER->NDOC04
      CASE XsNroMES = "05"
        XiNroDoc = OPER->NDOC05
      CASE XsNroMES = "06"
        XiNroDoc = OPER->NDOC06
      CASE XsNroMES = "07"
        XiNroDoc = OPER->NDOC07
      CASE XsNroMES = "08"
        XiNroDoc = OPER->NDOC08
      CASE XsNroMES = "09"
        XiNroDoc = OPER->NDOC09
      CASE XsNroMES = "10"
        XiNroDoc = OPER->NDOC10
      CASE XsNroMES = "11"
        XiNroDoc = OPER->NDOC11
      CASE XsNroMES = "12"
        XiNroDoc = OPER->NDOC12
      CASE XsNroMES = "13"
        XiNroDoc = OPER->NDOC13
      OTHER
        XiNroDoc = OPER->NRODOC
   ENDCASE
ELSE
   XnCodMon = 1
   XiTpoCmb = 2
   XnTpoCor = 1
   XiNroDoc = 1
ENDIF

RETURN
*************************************************************************** FIN
* Procedimiento Para Grabaci¢n
******************************************************************************
PROCEDURE GRABA
***************
IF Crear
   APPEND BLANK
ENDIF
IF ! RLOCK()
   RETURN
ENDIF
IF Crear
   REPLACE CODOPE WITH XSCODOPE
   REPLACE   OPER->NDOC00 WITH 1
   REPLACE   OPER->NDOC01 WITH 1
   REPLACE   OPER->NDOC02 WITH 1
   REPLACE   OPER->NDOC03 WITH 1
   REPLACE   OPER->NDOC04 WITH 1
   REPLACE   OPER->NDOC05 WITH 1
   REPLACE   OPER->NDOC06 WITH 1
   REPLACE   OPER->NDOC07 WITH 1
   REPLACE   OPER->NDOC08 WITH 1
   REPLACE   OPER->NDOC09 WITH 1
   REPLACE   OPER->NDOC10 WITH 1
   REPLACE   OPER->NDOC11 WITH 1
   REPLACE   OPER->NDOC12 WITH 1
   REPLACE   OPER->NDOC13 WITH 1
   REPLACE   OPER->NRODOC WITH 1
ENDIF
REPLACE SIGLAS    WITH XsSIGLAS
REPLACE NOMOPE    WITH XsNOMOPE
REPLACE CODMON    WITH XnCodMon
REPLACE CODUSR    WITH XsCodUsr
REPLACE TPOCmb    WITH XiTPOCmb
REPLACE TPOCOR    WITH XnTPOCOR
REPLACE ORIGEN    WITH XlDiario
Replace Libros    WITH XsLibros
DO CASE
   CASE XsNroMES = "00"
     REPLACE   OPER->NDOC00 WITH XiNroDoc
   CASE XsNroMES = "01"
     REPLACE   OPER->NDOC01 WITH XiNroDoc
   CASE XsNroMES = "02"
     REPLACE   OPER->NDOC02 WITH XiNroDoc
   CASE XsNroMES = "03"
     REPLACE   OPER->NDOC03 WITH XiNroDoc
   CASE XsNroMES = "04"
     REPLACE   OPER->NDOC04 WITH XiNroDoc
   CASE XsNroMES = "05"
     REPLACE   OPER->NDOC05 WITH XiNroDoc
   CASE XsNroMES = "06"
     REPLACE   OPER->NDOC06 WITH XiNroDoc
   CASE XsNroMES = "07"
     REPLACE   OPER->NDOC07 WITH XiNroDoc
   CASE XsNroMES = "08"
     REPLACE   OPER->NDOC08 WITH XiNroDoc
   CASE XsNroMES = "09"
     REPLACE   OPER->NDOC09 WITH XiNroDoc
   CASE XsNroMES = "10"
     REPLACE   OPER->NDOC10 WITH XiNroDoc
   CASE XsNroMES = "11"
     REPLACE   OPER->NDOC11 WITH XiNroDoc
   CASE XsNroMES = "12"
     REPLACE   OPER->NDOC12 WITH XiNroDoc
   CASE XsNroMES = "13"
     REPLACE   OPER->NDOC13 WITH XiNroDoc
   OTHER
     REPLACE   OPER->NRODOC WITH XiNroDoc
ENDCASE
UNLOCK ALL
RETURN
*************************************************************************** FIN
* Procedimiento de Reporte
******************************************************************************
PROCEDURE REPORTE
*****************
SAVE SCREEN TO TMP
Largo = 66
IniPrn=[_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn1]
xWhile = []
xFor   = []
GOTO TOP
sNomREP = "cbdmoper"
DO ADMPRINT WITH "REPORTS"
RESTORE SCREEN FROM TMP
RETURN
