********************************************************************************
* Programa      : CBDRL006.PRG                                                 *
* Objeto        : LIBRO COMPRAS                                                *
* Creaci¢n      : 05/09/93                                                     *
* Actualizaci¢n : 12/11/94  VETT                                    - VISOL    *
* Actualizaci¢n : 23/05/2000  VETT                                  - NAVIERA  *
*	ASOCIACION DE OPERACIONES A LIBROS CONTABLES SEGUN TABLA
*	CREACION DE REPORTE SEGUN FORMATO CON REPORT			 	
********************************************************************************
PARAMETER  _Libro
PRIVATE XsNroMes
*** Abrimos Bases ****
sele 3
use cbdmctas order ctas01 alias CTAS
if !used(3)
	close data
	return
endif
sele 4
use cbdrmovm order RMOV01 ALIAS RMOV
if !used(4)
	close data
	return
endif
sele 5
use cbdvmovm order VMOV01 ALIAS VMOV
IF !used(5)
	close data
	return
ENDIF
SELE 6
USE cbdmtabl ORDER tabl01   ALIAS TABL
IF !used(6)
	close data
	return
ENDIF
SELE 7
USE cbdmauxi ORDER auxi01   ALIAS AUXI
IF !used(7)
	close data
	return
ENDIF
SELE 8
USE cbdtoper ORDER oper01   ALIAS OPER
IF !used(8)
	close data
	return
ENDIF
SELE 9
USE cjatprov ORDER prov02   ALIAS PROV
IF !used(9)
	close data
	return
ENDIF
SELE OPER
SET FILTER TO INLIST(Libros,_libro)
go top


******
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "LIBRO COMPRAS v1.1"
Do F1_base WITH cTit1,cTit2,cTit3,cTit4
********* Variables  a usar ***********

@ 9,10 FILL  TO 15,68      COLOR W/N
@ 8,11 CLEAR TO 14,69
@ 8,11       TO 14,69

XiCodMon = 1
XdFchAst = DATE()
XsCodOpe = "003"

XiNroMes = _Mes


@ 10,18 SAY "         Mes de Trabajo : "
@ 11,18 SAY "         Operaci¢n      : "
DO LIB_MTEC WITH 16
i = 1
UltTecla = 0
DO WHILE UltTecla <> Escape
   DO CASE
      CASE i = 1
         @ 10,44 GET XiNroMes PICT "@LZ 99" RANGE 1,12
         READ
         UltTecla = LASTKEY()
      CASE i = 2
         SELE OPER
         @ 11,44 GET XsCodOpe PICT "@!"
         READ
         UltTecla = LASTKEY()
         IF UltTecla = Escape
            EXIT
         ENDIF
         IF UltTecla = F8
            IF !CBDBUSCA("OPER")
               UltTecla = 0
               LOOP
            ELSE
                XsCodOpe = CodOpe
                UltTecla = Enter
            ENDIF
         ENDIF
         SEEK XsCodOpe
         IF !FOUND() AND !EMPTY(XsCodOpe)
            GsMsgErr = "Operaci¢n inv lida"
            DO LIB_MERR WITH 99
            UltTecla = 0
            LOOP
         ENDIF
         IF !EMPTY(XsCodOpe)
	         @ 11,44 SAY XsCodOpe+[ ]+LEFT(OPER.NomOpe,20)
         else
	         @ 11,44 SAY padr("TODAS",30)
         endif
   ENDCASE
   DO CASE
      CASE UltTecla = Arriba
         i = IIF( i > 2 , i - 1 , 1)

      CASE UltTecla = Abajo
         i = IIF( i< 2 , i + 1, 1 )

      CASE UltTecla = Enter
         IF  i < 2
           i = i + 1
         ELSE
           EXIT
         ENDIF
   ENDCASE
ENDDO
IF UltTecla = Escape
   CLOSE DATA
   RETURN
ENDIF
=SEEK(XsCodOpe,"OPER")
SELECT VMOV

XsNroMes = transf(XiNroMES,"@L ##")
IF EMPTY(XsCodOpe)
ELSE
   xLLave = XsNroMes+XsCodOpe
   SEEK xLLave
   IF ! FOUND()
      GsMsgErr = "No Existen registros a Listar"
      DO LIB_MERR WITH 99
      CLOSE DATA
      RETURN
   ENDIF
ENDIF
DO ADMPRINT
IF LASTKEY() = ESCAPE
   CLOSE DATA
   RETURN
ENDIF
IF XiCodMon = 2
   INC = 6
ELSE
   INC = 0
ENDIF
Ancho = 235
Cancelar = .F.
Largo   = 66       && Largo de pagina
LinFin  = 88 - 8
IniImp  = _PRN8A+_PRN4
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = TRIM(GsDirCia)
Tit_SDER = "FECHA : "+DTOC(DATE())
Titulo   = ""
SubTitulo= ""
En1 = "L I B R O    C O M P R A S"
En2 = "MES DE "+MES(VAL(XsNroMes),1)+" DE "+TRANS(_ANO,"9999")
En3 = " "
En4 = ""
En5 = ""
En6 = "********** ****** ************************************* ********* ********** ************** ******** ****************************************************** ******************************* ******************************* ***************"
En7 = "            COD.                                          Nro.    Fecha      Nro.           Nro.                                                                 ** MONTO IMPONIBLE **              ** IMPUESTOS **             IMPORTE    "
En8 = "   FECHA    AUX.               P R O V E E D O R          RUC     DOCUME.    DOCUMENTO      REGIS.                        C O N C E P T O                      AFECTA         NO AFECTA         I.G.V.          OTROS            TOTAL     "
En9 = "********** ****** ************************************* ********* ********** ************** ******** ****************************************************** *************** *************** *************** *************** ***************"
*      0----------11-----18------------------------------------56--------66---------77-------------92-------101----------------------------------------------------156-------------172-------------188-------------204-------------220-----------234
*      0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
*      0        10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       190       200       210       220       230       240
DIMENSION vImport(5),vTotal(5)
DIMENSION vCodCta(10)
STORE [] TO vCodCta
NumCta = 0
NumCta1= 0
SELE OPER
SEEK TRIM(XsCodOpe)
DO WHILE !EOF() AND CodOpe = TRIM(XsCodOpe)
   SELE PROV
   SEEK OPER->CodOpe
   DO WHILE !EOF() AND CodOpe = OPER->CodOpe
      LsxxCodCta = ALLTRIM(PROV->CodCta)
      DO WHILE .T.
         IF EMPTY(LsxxCodCta)
            EXIT
         ENDIF
         NumCta = NumCta + 1
         IF NumCta > ALEN(vCodCta)
            DIMENSION vCodCta(NumCta+5)
         ENDIF
         Z = AT(",",LsxxCodCta)
         IF Z = 0
            Z = LEN(LsxxCodCta) + 1
         ENDIF

         okk = .T.
         FOR k = 1 TO NumCta1
             IF vCodCta(k)= PADR(LEFT(LsxxCodCta,Z-1),LEN(RMOV->CODCTA))
                Okk = .F.
             ENDIF
         NEXT
         NumCta1 = NumCta
         IF okk
             vCodCta(NumCta) = PADR(LEFT(LsxxCodCta,Z-1),LEN(RMOV->CODCTA))
         ELSE
             vCodCta(NumCta) = []
         ENDIF
         IF Z > LEN(LsxxCodCta)
            EXIT
         ENDIF
         LsxxCodCta = SUBSTR(LsxxCodCta,Z+1)
      ENDDO
      SKIP
   ENDDO
   SELE OPER
   SKIP
ENDDO
***
SELECT VMOV
SET DEVICE TO PRINT
PRINTJOB
   NumPag   = 0

   SELE OPER
   SEEK TRIM(XsCodOpe)
   DO WHILE !EOF() AND CodOpe=TRIM(XsCodOpe)
       SALTOPAG = .T.
       EN1 = TRIM(OPER->NomOpe)
       xLlave = XsNroMes+OPER->CodOpe
       SELECT VMOV
       Seek xLLave
       STORE 0 TO vTotal
       DO WHILE NroMes+CodOpe = xLLave .AND. ! EOF() .AND. ! Cancelar
          STORE 0 TO vImport
          XdFchDoc = {  ,  ,    }         
          XsCodAux = ""
          XsCodAux40 = ""
          XsNomAux = ""
          XsTipdoc = [  ]
          XsNomDoc = [  ]
          XsNroRef = ""
          XsRefImp = ""
          XsNroRuc = ""
          XfImport = 0
          XfImpInf = 0
          XfDolar  = 0
          XlAfecto = .F.
          CHK      = 0
          sKey = NroMes+CodOpe+NroAst
          SELECT RMOV
          SEEK sKey
          XsCtaAnt = SPACE(LEN(RMOV->CodCta))
          DO WHILE NroMes+CodOpe+NroAst = sKey .AND. ! EOF()
             CHK        = CHK        + IIF(TpoMov="D",Import,-Import)
            *IF  (ELiItm = "ú")
             IF  INLIST(ELiItm,"*","ú")            
                 SKIP
                 LOOP
             ENDIF
             DO CASE
                CASE ChkCta(CodCta) AND TpoMov="H"
                     =SEEK(CLFAUX+padr(CODAUX,len(auxi.codaux)),"AUXI")
                     XdFchDoc   = FchDoc
                     XsCodAux   = CodAux
                     XsNroRef   = NroRef
                     XsTipdoc   = TipDoc
                     XsNomDoc   = [  ]
                     if inlist(XsTipdoc,[NO],[  ])
                     else
                        =seek([SN]+tipdoc,[TABL])
                        XsNomDoc=left(Tabl.Nombre,2)
                     endif
                     if inlist(xscodaux,[20999])
                        XsNomAux   = AUXI.NOMAUX
                        XsNroRuc   = nroruc
                     else
                        XsNomAux   = AUXI->NOMAUX
                        XsNroRuc   = AUXI->RUCAUX
                     endif
                     vImport(5) = vImport(5) + IIF(TpoMov="H",Import,-Import)
                     XfDolar  = XfDolar  + IIF(TpoMov="H",ImpUsa,-ImpUsa)
                CASE INLIST(CODCTA,"4011111")
                     XlAfecto = .T.
                     XsCodAux40 = CodAux
                     XsRefImp   = NroRef
                     vImport(3) = vImport(3) + IIF(TpoMov="D",Import,-Import)


                CASE CODCTA="40"
                     vImport(4) = vImport(4) + IIF(TpoMov="D",Import,-Import)
                     XsCodAux   = CodAux
                OTHER
                    IF !INLIST(CodCta,"40","42")
                       XfImport = XfImport + IIF(TpoMov="D",Import,-Import)
                    ENDIF
             ENDCASE
             SELECT RMOV
             XsCtaAnt = CODCTA
             SKIP
          ENDDO
          SELECT VMOV
          Chk = ROUND((ABS(XfImport*18/100) - ABS(vImport(3))),2)
          IF XlAfecto
             vImport(1) = XfImport
             vImport(2) = 0
             IF ABS(Chk) > .01
                vImport(1) = ROUND(vImport(3)*100/18,2)
             ENDIF
          ELSE
             vImport(1) = 0
             vImport(2) = XfImport
          ENDIF
          LsImport = []
          IF VMOV->CodMon <> 1
             LsImport = ' (US$' + ALLTRIM(STR(XfDolar,14,2))+")"
             IF RIGHT(LsImport,3)=".00"
                LsImport = ' (US$' + ALLTRIM(STR(XfDolar,14,0))+")"
             ENDIF
          ENDIF
          LsGloDoc = LEFT(VMOV->NotAst,52-LEN(LsImport))+LsImport
          DO ResetPag
          NumLin = PROW() + 1
          @ NumLin,00 SAY FchAst
          @ NumLin,11 SAY XsCodAux PICT "@S6"
          @ NumLin,18 SAY XsNomAux PICT "@S36"
          @ NumLin,56 SAY XsNroRuc PICT "@S8"
          @ NumLin,66 SAY XdFchDoc
          *
          if inlist(XsTipdoc,[NO],[  ])
             @ NumLin,77 say XsNroRef
          else
             @ NumLin,77 say XsNomDoc + [/]
             @ NumLin,80 say XsNroRef pict '@R 999-9999999'
          endif
          *
          @ NumLin,92 SAY NroAst
          @ NumLin,101 SAY LsGloDoc
          FOR i = 1 to 5
              Col = 156 + (i-1)*16
              vTotal(i) = vTotal(i) + vImport(i)
              @ NumLin,Col SAY vImport(i) PICTURE "@Z ####,###,###.##"
          NEXT
          IF ABS(CHK)>.01
             @ NumLin,Ancho SAY "*"
          ENDIF
          SKIP
          Cancelar = (INKEY() = ESCAPE) .OR. Cancelar
       ENDDO
       IF ! Cancelar
          DO ResetPag
          NumLin = PROW() + 1
          @ Numlin,000 SAY REPLICATE("=",Ancho)
          NumLin = PROW() + 1
          @ NumLin,000 SAY "** TOTAL GENERAL **"
          FOR i = 1 to 5
              Col = 156 + (i-1)*16
              @ NumLin,Col SAY vTotal(i) PICTURE "@Z ####,###,###.##"
          NEXT
          NumLin = PROW() + 1
          @ Numlin,000 SAY REPLICATE("=",Ancho)
       ENDIF
       SELE OPER
       SKIP
   ENDDO
   EJECT PAGE
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO ADMPRFIN &&IN ADMPRINT
CLOSE DATA
RETURN
******************
procedure ResetPag
******************
IF LinFin <= PROW() .OR. NumPag = 0 .or. SALTOPAG
   SALTOPAG = .F.
   IF NumPag > 0
      NumLin = LINFIN + 1
      IF NumLin < (PROW() + 1)
         NumLin = (PROW() + 1)
      ENDIF
      @ NumLin,0          SAY REPLICATE(".",Ancho)
      @ NumLin+1,100      SAY "VAN ....."
      FOR i = 1 to 5
          Col = 156 + (i-1)*16
          @ NumLin+1,Col SAY vTotal(i) PICTURE "@Z ####,###,###.##"
      NEXT
   ENDIF
   DO ADMMBPRN &&IN ADMPRINT
   IF NumPag > 1
      NumLin = PROW() + 1
      @ NumLin,100      SAY "VIENEN .."
      FOR i = 1 to 5
          Col = 156 + (i-1)*16
          @ NumLin,Col SAY vTotal(i) PICTURE "@Z ####,###,###.##"
      NEXT
      @ NumLin+1,0      SAY REPLICATE(".",Ancho)
   ENDIF
   IF UltTecla = Escape
      Cancelar = .T.
   ENDIF
ENDIF
RETURN
********************
FUNCTION ChkCta
parameter _cta

FOR KK = 1 TO NumCta
	IF vCodCta(kk)=_Cta
		RETURN .T.
	ENDIF
ENDFOR
RETURN .F.
********************
