PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
*!*	Aperturamos tablas
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
LoDatAdm.abrirtabla('ABRIR','CBDMTABL','TABL','TABL01','')
LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','AUXI','AUXI01','')
LoDatAdm.abrirtabla('ABRIR','CJATPROV','PROV','PROV01','')
LoDatAdm.abrirtabla('ABRIR','CBDVMOVM','VMOV','VMOV01','')
LoDatAdm.abrirtabla('ABRIR','CBDRMOVM','RMOV','RMOV06','')
LoDatAdm.abrirtabla('ABRIR','ADMMTCMB','TCMB','TCMB01','')
STORE '' TO vDatos,vCdCta,vCodCta,vMovDoc,XsCodAux
XdFchVto = {}
STORE 0 TO XiForma,NumEle,NumCta,ZiOpcion
LfSalAct1 = 0.00
LfSalAct2 = 0.00
DO FORM cja_cjaccpag
RELEASE LoDatAdm
RETURN

*******************
PROCEDURE PROVEEDOR  && Para caso 1
*******************
*!*	PARAMETERS LoCntGrid
SELE AUXI
IF GdFecha < DATE()
	Fch = DTOC(GdFecha)
ELSE
	Fch = DTOC(DATE())
ENDIF
*!*	Cargando los provedores con los que hay deuda *!*
DIMENSION vDatos(20,5),vCdCta(20)
STORE '' TO vDatos
DO Carga0
IF NumEle = 0
	GsMsgErr = "No Existe Deudas pendientes"
	MESSAGEBOX(GsMsgErr,0+48,"Atenci๓n")
	RETURN
ENDIF
RETURN

***************
PROCEDURE OTRAS		&& Para el caso 2
***************
PARAMETER CodCta1
IF GdFecha < DATE()
	Fch = DTOC(GdFecha)
ELSE
	Fch = DTOC(DATE())
ENDIF
DIMENSION vDatos(20,5),vCdCta(20)
STORE '' TO vDatos
LsCodCta = CodCta1
DO CARGA1
IF NumEle = 0
	GsMsgErr = "No existe adelantos en esta contabilidad"
	MESSAGEBOX(GsMsgErr,0+48,"Atenci๓n")
	RETURN
ENDIF
RETURN

****************
PROCEDURE DEUDAS	&& Para el caso 4
****************
SELE AUXI
** Vector de Acumulaciขn de Cuentas ***********
IF GdFecha < DATE()
   Fch = DTOC(GdFecha)
ELSE
   Fch = DTOC(DATE())
ENDIF
XdFchVto = CTOD(Fch)+LiDias
XiForma  = 1
FCH = DTOC(XdFchVto)
DIMENSION vDatos(20,5),vCdCta(20,2)
DO CARGA0
**** OTRAS DEUDAS PENDIENTES  ****
LsCodCta = "461001"
DO CARGA1
IF NumEle = 0
	GsMsgErr = "No Existe Deudas pendientes"
	MESSAGEBOX(GsMsgErr,0+48,"Atenci๓n")
	RETURN
ENDIF
DIMENSION vDatos(NumEle*3),vCdCta(NumEle,2)
**** Ordenando ***
=ASORT(vDatos,1,NumEle)
X = ALEN(vDatos)
FOR I= 1 TO X
	IF MOD(I,3)=1
		xFchVto   = SUBSTR(vDatos(i),7,2)+"/"+SUBSTR(vDatos(i),5,2)+"/"+SUBSTR(vDatos(i),3,2)
		xSegLin   = SUBSTR(vDatos(i),78)
		vDatos(i) = xFchVto+SUBSTR(vDatos(i),9,70)
		=AINS(vDatos,i+1)
		vDatos(i+1) = xSegLin
		=AINS(vDatos,i+2)
		vDatos(i+2) = SPACE(78)
	ENDIF
NEXT

GsMsgKey = " [] [] Selecciona [Enter] Analiza [Esc] Cancela [F5] r [F4] Continua Buscando"
DO LIB_MTEC WITH 99

@ 21,54 SAY "TOTAL S/."
IF LfSalAct1 >= 0
   @ 21,66 SAY TRANSF(LfSalAct1,"@Z 9,999,999.99  ")
ELSE
   @ 21,66 SAY TRANSF(-LfSalAct1,"@Z 9,999,999.99- ")
ENDIF
@ 22,54 SAY "TOTAL US$"
IF LfSalAct2 >= 0
   @ 22,66 SAY TRANSF(LfSalAct2,"@Z 9,999,999.99  ")
ELSE
   @ 22,66 SAY TRANSF(-LfSalAct2,"@Z 9,999,999.99- ")
ENDIF
TotGen = ROUND(LfSalAct1/XfTpoCmb,2)+LfSalAct2
@ 22,02 SAY "TOTAL GENERAL US$"
IF TotGen    >= 0
   @ 22,20 SAY TRANSF(TotGen   ,"@Z 9,999,999.99  ")
ELSE
   @ 22,20 SAY TRANSF(-TotGen   ,"@Z 9,999,999.99- ")
ENDIF

SAVE SCREEN TO LsPanCon
LsNombre = SPACE(30)
LiDesde  = 0
UltTecla= 0
PV = 1
DO WHILE .T.
   RESTORE SCREEN FROM LsPanCon
   @ 5,0 GET PV FROM vDatos SIZE 16,80 VALID dato1()
   READ
   IF UltTecla = Escape_
      EXIT
   ENDIF
   IF UltTecla = Enter .AND. MOD(PV,2) = 1
      XsCodCta = vCdCta((PV+1)/2)
      XsCodAux = vCdCta((PV+1)/2)
      XsNroDoc = SUBSTR(vDatos(PV),10,10)
      =SEEK(XsCodCta,"CTAS")
      XsClfAux = CTAS->CLFAUX
      SELECT AUXI
      SEEK XsClfAux+XsCodAux
   ENDIF
   IF UltTecla = F5
      @ 21,14 FILL  TO 23,65 COLOR W/N
      @ 20,15 CLEAR TO 22,66
      @ 20,15 TO 22,66
      @ 21,17 SAY "DATO  : " GET LsNombre PICT "@!"
      READ
      IF LASTKEY() = Escape_
         LOOP
      ENDIF
      LiDesde = 0
      FOR I=1 TO ALEN(vDatos)
          IF ALLTRIM(LsNombre)$UPPER(vDatos(i))
             LiDesde = i
             EXIT
          ENDIF
      NEXT
      IF LiDesde = 0
         ?? CHR(7)
         WAIT "DATO NO SELECCIONADO" NOWAIT WINDOW
      ELSE
         PV = LiDesde
      ENDIF
   ENDIF
   IF UltTecla = F4 .AND. LiDesde > 0
      z = LiDesde
      LiDesde = 0
      FOR I=z+1  TO ALEN(vDatos)
          IF ALLTRIM(LsNombre)$vDatos(i)
             LiDesde = i
             EXIT
          ENDIF
      NEXT
      IF LiDesde = 0
         ?? CHR(7)
         WAIT "NO EXISTEN OTROS DATOS" NOWAIT WINDOW
         PV = z
         LiDesde = z
      ELSE
         PV = LiDesde
      ENDIF
   ENDIF
ENDDO
RETURN

***************
PROCEDURE PIDE1
***************
DIMENSION vDatos(NumEle),vCdCta(NumEle)
LsNombre = SPACE(30)
LiDesde = 0
PV = 1
UltTecla = 0
UltTecla = LASTKEY()
LsCodCta = vCdCta(PV)
IF LsCodCta = "PROV"
	XsClfAux = GsClfPro
	XsCodAux = Cur_Saldo.Codigo
	SELECT AUXI
	SEEK XsClfAux+XsCodAux
	DO xCstMov
ELSE
	=SEEK(LsCodCta,"CTAS")
	XsClfAux = CTAS.CLFAUX
	XsCodAux = Cur_Saldo.Codigo
	SELECT AUXI
	SEEK XsClfAux+XsCodAux
	DO xCstMov1
ENDIF
RETURN

************************************************************
*!*	Segunda pantalla a Presentar (Detalle por Documento) *!*
************************************************************
PROCEDURE xCstMov	&& Proveedores
*****************
DIMENSION vDocum(20,7)
ZfSalAct1 = 0
ZfSalAct2 = 0
NumEle = 0
FOR Item = 1 TO NumCta
	LsCodCta = vCodCta(Item,1)
	SELECT RMOV
	SEEK LsCodCta+XsCodAux
	DO WHILE CodCta+CodAux = LsCodCta+XsCodAux .AND. ! EOF()
		SalAct1  = 0
		SalAct2  = 0
		LsNroDoc = NroDoc
		LsNroRef = NroRef
		LdFchVto = FchVto
		LiCodMon = CodMon
		LsGloDoc = GloDoc
		IF EMPTY(LsGloDoc)
			=SEEK(NROMES+CODOPE+NROAST,"VMOV")
			LsGloDoc = VMOV->NotAst
		ENDIF
		DO WHILE CodCta+CodAux+NroDoc = LsCodCta+XsCodAux+LsNroDoc .AND. ! EOF()
			IF CodOpe == vCodCta(Item,3)
				LiCodMon = CodMon
				LdFchVto = FchVto
				LsNroRef = NroRef
				LsGloDoc = GloDoc
				IF EMPTY(LsGloDoc)
					=SEEK(NROMES+CODOPE+NROAST,"VMOV")
					LsGloDoc = VMOV->NotAst
				ENDIF
			ENDIF
			IF TpoMov = "H"
				SalAct1 = SalAct1 + IMPORT
				SalAct2 = SalAct2 + IMPUSA
			ELSE
				SalAct1 = SalAct1 - IMPORT
				SalAct2 = SalAct2 - IMPUSA
			ENDIF
			SKIP
		ENDDO
		Ok = 0
		IF LiCodMon = 1 .AND. SalAct1 # 0
			Ok = 1
			SalAct2 = 0
		ENDIF
		IF LiCodMon = 2 .AND. SalAct2 # 0
			Ok = 2
			SalAct1 = 0
		ENDIF
		IF Ok # 0
			IF EMPTY(XdFchVto) .OR. LdFchVto <= XdFchVto
				NumEle = NumEle + 1
				IF NumEle < ALEN(vDocum)
					DIMENSION vDocum(NumEle+10,7)
				ENDIF
				vDocum(NumEle,1) = LsCodCta
				vDocum(NumEle,2) = LsNroDoc
				vDocum(NumEle,3) = LsNroRef
				vDocum(NumEle,4) = LdFchVto
				vDocum(NumEle,5) = LsGloDoc
				IF LiCodmON = 1
					IF SalAct1 >= 0
						vDocum(NumEle,6) = SalAct1
					ELSE
						vDocum(NumEle,6) = -SalAct1
					ENDIF
					vDocum(NumEle,7) = 0.00
				ELSE
					IF SalAct2 >= 0
						vDocum(NumEle,7) = SalAct2
					ELSE
						vDocum(NumEle,7) = -SalAct2
					ENDIF
					vDocum(NumEle,6) = 0.00
				ENDIF
				ZfSalAct1 = ZfSalAct1 + SalAct1
				ZfSalAct2 = ZfSalAct2 + SalAct2
			ENDIF
		ENDIF
	ENDDO
NEXT
IF NumEle = 0
	RETURN
ENDIF
LsCursorA = GoEntPub.tmppath+SYS(3)
IF USED('Cur_DetDoc')
	USE IN 'Cur_DetDoc'
ENDIF
SELECT 0
CREATE TABLE (LsCursorA) FREE (CodCta C(LEN(RMOV.CodCta)),;
							   NroDoc C(LEN(RMOV.NroDoc)),;
							   NroRef C(LEN(RMOV.NroRef)),;
							   FchVto D(8),;
							   GloDoc C(LEN(RMOV.GloDoc)),;
							   SaldoS n(16,2),;
							   SaldoD n(16,2) )
USE
USE (LsCursorA) ALIAS Cur_DetDoc
FOR K = 1 TO NumEle && ALEN(vDatos,1)
	APPEND BLANK
	REPLACE CodCta WITH vDocum(k,1)
	REPLACE NroDoc WITH vDocum(k,2)
	REPLACE NroRef WITH vDocum(k,3)
	REPLACE FchVto WITH vDocum(k,4)
	REPLACE GloDoc with vDocum(k,5)
	REPLACE SaldoS with vDocum(k,6)
	REPLACE SaldoD with vDocum(k,7)
ENDFOR
LOCATE
RETURN

******************
PROCEDURE xCstMov1
******************
*** Buscando los Documentos Pendientes de un Proveedor ***
@  0,0  SAY "ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออหออออออออออออออออออป"
@  1,0  SAY "บ                                                           บ     S A L D O S  บ"
@  2,0  SAY "ฬอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฮออออออออออออออออออน"
@  3,0  SAY "บ Tpo    Nง.Docto.  Nง Refer.   Vto.     Concepto           บ         S/.  US$ บ"
@  4,0  SAY "ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออสออออออออออออออออออผ"
@  1,1 SAY  PADC(ALLTRIM(NomAux),59) COLOR SCHEME 7
@  3,1  SAY " Tpo  Nง.Docto.  Nง Refer.   Vto.     Concepto             " COLOR SCHEME 7
@  1,61 SAY "     S A L D O S  " COLOR SCHEME 7
@  3,61 SAY "        S/.   US$ " COLOR SCHEME 7
ZfSalAct1 = 0
ZfSalAct2 = 0
DIMENSION vDocum(20)
NumEle = 0
SELECT RMOV
SEEK LsCodCta+XsCodAux
DO WHILE CodCta+CodAux = LsCodCta+XsCodAux .AND. ! EOF()
   SalAct1  = 0
   SalAct2  = 0
   LsNroDoc = NroDoc
   LsNroRef = NroRef
   LdFchVto = FchVto
   LiCodMon = CodMon
   LsGloDoc = GloDoc
   LdFchVto = RMOV->FchVto
   IF EMPTY(LsGloDoc)
      =SEEK(NROMES+CODOPE+NROAST,"VMOV")
      LsGloDoc = VMOV->NotAst
   ENDIF
   DO WHILE CodCta+CodAux+NroDoc = LsCodCta+XsCodAux+LsNroDoc .AND. ! EOF()
      @ 24,0 say NroDoc
      IF TpoMov = "H"
         SalAct1 = SalAct1 + IMPORT
         SalAct2 = SalAct2 + IMPUSA
      ELSE
         SalAct1 = SalAct1 - IMPORT
         SalAct2 = SalAct2 - IMPUSA
      ENDIF
      SKIP
   ENDDO
   Ok = 0
   IF LiCodMon = 1 .AND. SalAct1 # 0
      Ok = 1
      SalAct2 = 0
   ENDIF
   IF LiCodMon = 2 .AND. SalAct2 # 0
      Ok = 2
      SalAct1 = 0
   ENDIF
   IF Ok # 0
      IF EMPTY(XdFchVto) .OR. LdFchVto <= XdFchVto
         NumEle = NumEle + 1
         IF NumEle < ALEN(vDOCUM)
            DIMENSION vDOCUM(NumEle+10)
         ENDIF
         vDOCUM(NumEle) = PADR(LsCodCta+" "+LsNroDoc+" "+LsNroRef+" "+DTOC(LdFchVto)+" "+LsGloDoc+" ",58)
         IF LiCodmON = 1
            IF SalAct1 >= 0
               vDocum(NumEle) = vDocum(NumEle) + TRANSF(SalAct1,"@Z 9,999,999.99  ")
            ELSE
               vDocum(NumEle) = vDocum(NumEle) + TRANSF(-SalAct1,"@Z 9,999,999.99- ")
            ENDIF
            vDocum(NumEle) = vDocum(NumEle) + SPACE(6)
         ELSE
            vDocum(NumEle) = vDocum(NumEle) + SPACE(6)
            IF SalAct2 >= 0
               vDocum(NumEle) = vDocum(NumEle) + TRANSF(SalAct2,"@Z 9,999,999.99  ")
            ELSE
               vDocum(NumEle) = vDocum(NumEle) + TRANSF(-SalAct2,"@Z 9,999,999.99- ")
            ENDIF
         ENDIF
         ZfSalAct1 = ZfSalAct1 + SalAct1
         ZfSalAct2 = ZfSalAct2 + SalAct2
      ENDIF
   ENDIF
ENDDO
IF NumEle = 0
   RETURN
ENDIF
DIMENSION vDocum(NumEle)
ND = 1
UltTecla = 0
GsMsgKey = " [] [] Selecciona   [Enter] Analiza   [Esc] Cancela"
DO LIB_MTEC WITH 99
SAVE SCREEN TO LsPanMov
DO WHILE .T.
   RESTORE SCREEN FROM LsPanMov
   @ 5,0 GET ND FROM vDocum SIZE 18,80 VALID Dato1()
   READ
   UltTecla = LASTKEY()
   IF UltTecla = Escape_
      EXIT
   ENDIF
   IF UltTecla = Enter
      DO xCstDoc
   ENDIF
   UltTecla = 0
ENDDO
RETURN

******************
PROCEDURE xCstMov2
******************
MaxEle = 10
DIMENSION vCodCta(MaxEle,4)
DIMENSION vDocum(20,7)
*!*	XsCodAux = LsCodAux
XsCodAux = PADR(XsCodAux,LEN(RMOV.CodAux))
 NumCta = 0
NumEle = 0
ZfSalAct1 = 0
ZfSalAct2 = 0
***------------------arv1.0 -------------***
* Culpable : 			Amaro Infante R.
* Fecha del Desastre :  28.02.2008
* Intencion			 :  Cancelar documentos segun el auxiliar por Operacion.
* OJO                :  Adicionar campo clfaux c(3), en la tabla cjatprov
DIMENSION xxCodCta(4)
NumCtas = 0
LsxxCodCta = ALLTRIM(PROV->CodCta)
DO WHILE .T.
	IF EMPTY(LsxxCodCta)
		EXIT
	ENDIF
	NumCtas = NumCtas + 1
	IF NumCtas > ALEN(xxCodCta)
		DIMENSION xxCodCta(NumCtas+5)
	ENDIF
	Z = AT(",",LsxxCodCta)
	IF Z = 0
		Z = LEN(LsxxCodCta) + 1
	ENDIF
	xxCodCta(NumCtas) = PADR(LEFT(LsxxCodCta,Z-1),LEN(RMOV->CODCTA))   
	SELE CTAS
	SEEK xxCodCta(NumCtas)    
		NumCta = NumCta + 1
		IF NumCta = MaxEle
			MaxEle = MaxEle + 10
			DIMENSION vCodCta(MaxEle,4)
		ENDIF
		vCodCta(NumCta,1) = CodCta
		vCodCta(NumCta,2) = NomCta
		vCodCta(NumCta,3) = ""
		vCodCta(NumCta,4) = SUBSTR(CodCta,3)
		SELECT PROV
		GOTO TOP
		DO WHILE ! EOF()
			IF TRIM(CTAS->CODCTA)$CODCTA
				vCodCta(NumCta,3) = CODOPE
				vCodCta(NumCta,4) = TpoDoc
			ENDIF
			SKIP
		ENDDO    
	SELECT CTAS
	SKIP	
   	IF Z > LEN(LsxxCodCta)
		EXIT
	ENDIF
	LsxxCodCta = SUBSTR(LsxxCodCta,Z+1)
ENDDO
***------------------arv1.0 -------------***
*** SOLO DQ AQUI
*!*	DO WHILE CodCta=[42] .AND. ! EOF()
*!*		IF AFTMOV='S' AND PIDAUX='S'
*!*			NumCta = NumCta + 1
*!*			IF NumCta = MaxEle
*!*				MaxEle = MaxEle + 10
*!*				DIMENSION vCodCta(MaxEle,4)
*!*			ENDIF
*!*			vCodCta(NumCta,1) = CodCta
*!*			vCodCta(NumCta,2) = NomCta
*!*			vCodCta(NumCta,3) = ""
*!*			vCodCta(NumCta,4) = SUBSTR(CodCta,3)
*!*			SELECT PROV
*!*			GOTO TOP
*!*			DO WHILE ! EOF()
*!*				IF TRIM(CTAS->CODCTA)$CODCTA
*!*					vCodCta(NumCta,3) = CODOPE
*!*					vCodCta(NumCta,4) = TpoDoc
*!*				ENDIF
*!*				SKIP
*!*			ENDDO
*!*		ENDIF
*!*		SELECT CTAS
*!*		SKIP
*!*	ENDDO
*** AQUI
IF NumCta = 0
	GsMsgErr = "Cuentas de provedores no registradas"
	MESSAGEBOX(GsMsgErr,0+48,"Atenci๓n")
	RETURN
ENDIF
FOR Item = 1 TO NumCta
	LsCodCta = vCodCta(Item,1)
	SELECT RMOV
	SEEK LsCodCta+XsCodAux
	DO WHILE CodCta+CodAux = LsCodCta+XsCodAux .AND. ! EOF()
		SalAct1  = 0
		SalAct2  = 0
		LsNroDoc = NroDoc
		LsNroRef = NroRef
		LdFchVto = FchVto
		LiCodMon = CodMon
		LsGloDoc = GloDoc
		IF EMPTY(LsGloDoc)
			=SEEK(NROMES+CODOPE+NROAST,"VMOV")
			LsGloDoc = VMOV->NotAst
		ENDIF
		DO WHILE CodCta+CodAux+NroDoc = LsCodCta+XsCodAux+LsNroDoc .AND. ! EOF()
			IF CodOpe == vCodCta(Item,3)
				LiCodMon = CodMon
				LdFchVto = FchVto
				LsNroRef = NroRef
				LsGloDoc = GloDoc
				IF EMPTY(LsGloDoc)
					=SEEK(NROMES+CODOPE+NROAST,"VMOV")
					LsGloDoc = VMOV->NotAst
				ENDIF
			ENDIF
			IF TpoMov = "H"
				SalAct1 = SalAct1 + IMPORT
				SalAct2 = SalAct2 + IMPUSA
			ELSE
				SalAct1 = SalAct1 - IMPORT
				SalAct2 = SalAct2 - IMPUSA
			ENDIF
			SKIP
		ENDDO
		Ok = 0
		IF LiCodMon = 1  && .AND. SalAct1 # 0
			Ok = 1
			SalAct2 = 0
		ENDIF
		IF LiCodMon = 2  && .AND. SalAct2 # 0
			Ok = 2
			SalAct1 = 0
		ENDIF
		IF Ok # 0
			NumEle = NumEle + 1
			IF NumEle < ALEN(vDocum)
				DIMENSION vDocum(NumEle+10,7)
			ENDIF
			vDocum(NumEle,1) = LsCodCta
			vDocum(NumEle,2) = LsNroDoc
			vDocum(NumEle,3) = LsNroRef
			vDocum(NumEle,4) = LdFchVto
			vDocum(NumEle,5) = LsGloDoc
			IF LiCodmON = 1
				IF SalAct1 >= 0
					vDocum(NumEle,6) = SalAct1
				ELSE
					vDocum(NumEle,6) = -SalAct1
				ENDIF
				vDocum(NumEle,7) = 0.00
			ELSE
				IF SalAct2 >= 0
					vDocum(NumEle,7) = SalAct2
				ELSE
					vDocum(NumEle,7) = -SalAct2
				ENDIF
				vDocum(NumEle,6) = 0.00
			ENDIF
			ZfSalAct1 = ZfSalAct1 + SalAct1
			ZfSalAct2 = ZfSalAct2 + SalAct2
		ENDIF
	ENDDO
NEXT
LsCursorA = GoEntPub.tmppath+SYS(3)
IF USED('Cur_DetDoc')
	USE IN 'Cur_DetDoc'
ENDIF
SELECT 0
CREATE TABLE (LsCursorA) FREE (CodCta C(LEN(RMOV.CodCta)),;
							   NroDoc C(LEN(RMOV.NroDoc)),;
							   NroRef C(LEN(RMOV.NroRef)),;
							   FchVto D(8),;
							   GloDoc C(LEN(RMOV.GloDoc)),;
							   SaldoS n(16,2),;
							   SaldoD n(16,2) )
USE
USE (LsCursorA) ALIAS Cur_DetDoc
FOR K = 1 TO NumEle && ALEN(vDatos,1)
	APPEND BLANK
	REPLACE CodCta WITH vDocum(k,1)
	REPLACE NroDoc WITH vDocum(k,2)
	REPLACE NroRef WITH vDocum(k,3)
	REPLACE FchVto WITH vDocum(k,4)
	REPLACE GloDoc with vDocum(k,5)
	REPLACE SaldoS with vDocum(k,6)
	REPLACE SaldoD with vDocum(k,7)
ENDFOR
LOCATE
RETURN

****************************************
*!* Tercera pantalla de presentaci๓n *!*
****************************************
PROCEDURE xCstDoc
*****************
DIMENSION vMovDoc(20,7)
LsCodCta = Cur_DetDoc.CodCta
LsNroDoc = Cur_DetDoc.NroDoc
LiCodMon = IIF(Cur_DetDoc.SaldoS<>0.00,1,2)
xKey1 = LsCodCta+XsCodAux+LsNroDoc
xKey2 = LsCodCta+XsCodAux+LsNroDoc
xLinReg = [xLinReg()]
xTITULO = " COMPROBANTE     FECHA    CONCEPTO                              ABONOS CARGOS"
xTstLin = [xFiltro()]
SELECT RMOV
SEEK xKey1
NumEle = 0
DO WHILE CodCta + CodAux + NroDoc = xKey1
	NumEle = NumEle + 1
	DO xLinReg
	SKIP
ENDDO
LsCursorB = GoEntPub.tmppath+SYS(3)
IF USED('Cur_DocDet')
	USE IN 'Cur_DocDet'
ENDIF
SELECT 0
CREATE TABLE (LsCursorB) FREE (NroMes C(LEN(RMOV.NroMes)),;
							   CodOpe C(LEN(RMOV.CodOpe)),;
							   NroAst C(LEN(RMOV.NroAst)),;
							   FchDoc D(8),;
							   GloDoc C(LEN(RMOV.GloDoc)),;
							   SaldoS n(16,2),;
							   SaldoD n(16,2) )
USE
USE (LsCursorB) ALIAS Cur_DocDet
FOR K = 1 TO NumEle && ALEN(vDatos,1)
	APPEND BLANK
	REPLACE NroMes WITH vMovDoc(k,1)
	REPLACE CodOpe WITH vMovDoc(k,2)
	REPLACE NroAst WITH vMovDoc(k,3)
	REPLACE FchDoc WITH vMovDoc(k,4)
	REPLACE GloDoc with vMovDoc(k,5)
	REPLACE SaldoS with vMovDoc(k,6)
	REPLACE SaldoD with vMovDoc(k,7)
ENDFOR
LOCATE
RETURN

*****************
PROCEDURE xFiltro
*****************
IF LiCodMon = 1
   return IMPORT#0
ELSE
   return IMPUSA#0
ENDIF

*****************
PROCEDURE xLinReg
*****************
vMovDoc(NumEle,1) = NroMes
vMovDoc(NumEle,2) = CodOpe
vMovDoc(NumEle,3) = NroAst
vMovDoc(NumEle,4) = FchDoc
=SEEK(NROMES+CODOPE+NROAST,"VMOV")
LsGloDoc = PADR(VMOV->NotAst,34)+" "
IF EMPTY(LsGloDoc)
	LsGloDoc = PADR(RMOV->GloDoc,34)+" "
ENDIF
vMovDoc(NumEle,5) = LsGloDoc
IF LiCodMon = 1
	LnImport = Import
ELSE
	LnImport = ImpUsa
ENDIF
IF TpoMov = "D"
	vMovDoc(NumEle,6) = LnImport
	vMovDoc(NumEle,7) = 0.00
ELSE
	vMovDoc(NumEle,6) = 0.00
	vMovDoc(NumEle,7) = LnImport
ENDIF
RETURN

****************
PROCEDURE Carga0	&& Proveedores: Todas las cuentas 42
****************
NumCta = 0
MaxEle = 10
DIMENSION vCodCta(MaxEle,4)
SELE CTAS
SEEK [42]
DO WHILE CodCta=[42] AND !EOF()
	IF AFTMOV='S' AND PIDAUX='S'
		NumCta = NumCta + 1
		IF NumCta = MaxEle
			MaxEle = MaxEle + 10
			DIMENSION vCodCta(MaxEle,4)
		ENDIF
		vCodCta(NumCta,1) = CodCta
		vCodCta(NumCta,2) = NomCta
		vCodCta(NumCta,3) = ""
		vCodCta(NumCta,4) = SUBSTR(CodCta,3)
		SELECT PROV
		GOTO TOP
		DO WHILE ! EOF()
			IF TRIM(CTAS.CODCTA) $ CODCTA
				vCodCta(NumCta,3) = CodOpe
				vCodCta(NumCta,4) = TpoDoc
			ENDIF
			SKIP
		ENDDO
		SELECT CTAS
	ENDIF
	SKIP
ENDDO
IF NumCta = 0
	RETURN
ENDIF
DIMENSION vCodCta(NumCta,4)
XsClfAux = GsClfPro
SELECT AUXI
SEEK XsClfAux
*!*	LfSalAct1 = 0
*!*	LfSalAct2 = 0
DO WHILE ClfAux = XsClfAux .AND. ! EOF()
	WAIT  WINDOW PADC(TRIM(CodAux)+" "+TRIM(NomAux),80) NOWAIT
	LsCodAux = CodAux
	LsNomAux = NomAux
	ZfSalAct1 = 0
	ZfSalAct2 = 0
	LiNroItm = 0
	FOR Item = 1 TO NumCta
		LsCodCta = vCodCta(Item,1)
		SELECT RMOV
		SEEK LsCodCta+LsCodAux
		DO WHILE CodCta+CodAux = LsCodCta+LsCodAux .AND. ! EOF()
			SalAct1  = 0
			SalAct2  = 0
			=SEEK(NROMES+CODOPE+NROAST,"VMOV")
			LsNroDoc = NroDoc
			LiCodMon = CodMon
			LdFchVto = FchVto
			LsNroRef = NroRef
			LsGloDoc = GloDoc
			LsNotAst = VMOV->NotAst
			DO WHILE CodCta+CodAux+NroDoc = LsCodCta+LsCodAux+LsNroDoc .AND. ! EOF()
				IF CodOpe == vCodCta(Item,3)
					=SEEK(NROMES+CODOPE+NROAST,"VMOV")
					LiCodMon = CodMon
					LdFchVto = FchVto
					LsNroRef = NroRef
					LsGloDoc = GloDoc
					LsNotAst = VMOV->NotAst
				ENDIF
				IF TpoMov = "H"
					SalAct1 = SalAct1 + IMPORT
					SalAct2 = SalAct2 + IMPUSA
				ELSE
					SalAct1 = SalAct1 - IMPORT
					SalAct2 = SalAct2 - IMPUSA
				ENDIF
				SKIP
			ENDDO
			IF EMPTY(XdFchVto) .OR. LdFchVto <= XdFchVto
				IF LiCodMon = 1
					ZfSalAct1 = ZfSalAct1 + SalAct1
					TfSalAct  = SalAct1
				ELSE
					ZfSalAct2 = ZfSalAct2 + SalAct2
					TfSalAct  = SalAct2
				ENDIF
				IF XiForma = 1 .AND. TfSalAct <> 0
					NumEle = NumEle + 1
					IF NumEle < ALEN(vDatos)
						DIMENSION vDatos(NumEle+10)
						DIMENSION vCdCta(NumEle+10,2)
					ENDIF
					vCdCta(NumEle,1) = LsCodCta
					vCdCta(NumEle,2) = LsCodAux
					IF LsCodAux = "99"
						vDatos(NumEle) = PADR(DTOC(LdFCHVTO,1)+" "+LsNroDoc+" "+LsGloDoc+" ",60)
					ELSE
						vDatos(NumEle) = PADR(DTOC(LdFCHVTO,1)+" "+LsNroDoc+" "+LsNomAux+" ",60)
					ENDIF
					IF LiCodMon = 1
						IF SalAct1 >= 0
							vDatos(NumEle) = vDatos(NumEle) + " S/."+TRANSF(SalAct1,"@Z 9,999,999.99 ")
						ELSE
							vDatos(NumEle) = vDatos(NumEle) + " S/."+TRANSF(-SalAct1,"@Z 9,999,999.99-")
						ENDIF
					ELSE
						IF SalAct2 >= 0
							vDatos(NumEle) = vDatos(NumEle) + " US$"+TRANSF(SalAct2,"@Z 9,999,999.99 ")
						ELSE
							vDatos(NumEle) = vDatos(NumEle) + " US$"+TRANSF(-SalAct2,"@Z 9,999,999.99-")
						ENDIF
					ENDIF
					vDatos(NumEle) = vDatos(NumEle) + PADR(SPACE(9)+LSNROREF + " "+ LSNOTAST,60)
				ENDIF
			ENDIF
		ENDDO
	NEXT
	IF ZfSalAct1#0 .OR. ZfSalAct2#0
		LfSalAct1 = LfSalAct1 + ZfSalAct1
		LfSalAct2 = LfSalAct2 + ZfSalAct2
		IF XiForma = 0
			NumEle = NumEle + 1
			IF NumEle < ALEN(vDatos)
				DIMENSION vDatos(NumEle+10,5)
				DIMENSION vCdCta(NumEle+10)
			ENDIF
			vCdCta(NumEle) = "PROV"
			vDatos(NumEle,1) = PADR(LsCodAux,LEN(rmov.CodAux))
			vdatos(NumEle,2) = LsNomAux
			IF ZfSalAct1 >= 0
				vDatos(NumEle,3) = ZfSalAct1 		&& TRANSF(ZfSalAct1,"@Z 9,999,999.99  ")
			ELSE
				vDatos(NumEle,3) = ZfSalAct1  		&& TRANSF(-ZfSalAct1,"@Z 9,999,999.99- ")
			ENDIF
			IF ZfSalAct2 >= 0
				vDatos(NumEle,4)   =  ZfSalAct2 		&& TRANSF(ZfSalAct2,"@Z 9,999,999.99  ")
			ELSE
				vDatos(NumEle,4)   =  ZfSalAct2 		&& TRANSF(-ZfSalAct2,"@Z 9,999,999.99- ")
			ENDIF
		ENDIF
	ENDIF
	SELECT AUXI
	SKIP
ENDDO
*!*	Cargamos en cursor *!*
DO CASE
	CASE XiForma=0
		LsCursor = GoEntPub.tmppath+SYS(3) 
		IF USED('Cur_Saldo')
			USE IN 'Cur_Saldo'
		ENDIF
		SELECT 0
		CREATE TABLE (LsCursor) FREE (Codigo C(11), Nombre C(50), SaldoMN n(14,2),SaldoME N(14,2) )
		USE
		USE (LsCursor) ALIAS Cur_Saldo
		FOR K = 1 TO NumEle && ALEN(vDatos,1)
			APPEND BLANK
			REPLACE Codigo WITH IIF(EMPTY(vDatos(k,1)),'',vDatos(k,1))
			REPLACE Nombre WITH IIF(EMPTY(vDatos(k,2)),'',vDatos(k,2))
			REPLACE SaldoMN WITH IIF(EMPTY(vDatos(k,3)),0.00,vDatos(k,3))
			REPLACE SaldoME WITH IIF(EMPTY(vDatos(k,4)),0.00,vdatos(k,4))
		ENDFOR
		LOCATE
ENDCASE
RETURN

****************
PROCEDURE CARGA1	&& Seg๚n las cuentas [LsCodCta]
****************
=SEEK(LsCodCta,"CTAS")
XsClfAux = CTAS->CLFAUX
SELECT RMOV
SEEK LsCodCta
DO WHILE CodCta = LsCodCta .AND. !EOF()
	LsCodAux = CodAux
	=SEEK(XsClfAux+LsCodAux,"AUXI")
	LsNomAux = AUXI->NomAux
*!*		@ 24,0 SAY PADC(TRIM(LsCodAux)+" "+TRIM(LsNomAux),80)
	ZfSalAct1 = 0
	ZfSalAct2 = 0
	DO WHILE CodCta+CodAux = LsCodCta+LsCodAux .AND. ! EOF()
		SalAct1  = 0
		SalAct2  = 0
		=SEEK(NROMES+CODOPE+NROAST,"VMOV")
		LsNroDoc = NroDoc
		LiCodMon = CodMon
		LdFchVto = FchVto
		LsNroRef = NroRef
		LsGloDoc = GloDoc
		LsNotAst = VMOV->NotAst
		DO WHILE CodCta+CodAux+NroDoc = LsCodCta+LsCodAux+LsNroDoc .AND. ! EOF()
			IF TpoMov = "H"
				SalAct1 = SalAct1 + IMPORT
				SalAct2 = SalAct2 + IMPUSA
			ELSE
				SalAct1 = SalAct1 - IMPORT
				SalAct2 = SalAct2 - IMPUSA
			ENDIF
			SKIP
		ENDDO
		IF EMPTY(XdFchVto) .OR. LdFchVto <= XdFchVto
			IF LiCodMon = 1
				ZfSalAct1 = ZfSalAct1 + SalAct1
				TfSalAct  = SalAct1
			ELSE
				ZfSalAct2 = ZfSalAct2 + SalAct2
				TfSalAct  = SalAct2
			ENDIF
			IF XiForma = 1 .AND. TfSalAct <> 0
				NumEle = NumEle + 1
				IF NumEle < ALEN(vDatos)
					DIMENSION vDatos(NumEle+10,5)
					DIMENSION vCdCta(NumEle+10,2)
				ENDIF
				vCdCta(NumEle,1) = LsCodCta
				vCdCta(NumEle,2) = LsCodAux
				IF LsCodAux = "99"
					vDatos(NumEle) = PADR(DTOC(LdFCHVTO,1)+" "+LsNroDoc+" "+LsGloDoc+" ",60)
				ELSE
					vDatos(NumEle) = PADR(DTOC(LdFCHVTO,1)+" "+LsNroDoc+" "+LsNomAux+" ",60)
				ENDIF
				IF LiCodMon = 1
					IF SalAct1 >= 0
						vDatos(NumEle) = vDatos(NumEle) + " S/."+TRANSF(SalAct1,"@Z 9,999,999.99 ")
					ELSE
						vDatos(NumEle) = vDatos(NumEle) + " S/."+TRANSF(-SalAct1,"@Z 9,999,999.99-")
					ENDIF
				ELSE
					IF SalAct2 >= 0
						vDatos(NumEle) = vDatos(NumEle) + " US$"+TRANSF(SalAct2,"@Z 9,999,999.99 ")
					ELSE
						vDatos(NumEle) = vDatos(NumEle) + " US$"+TRANSF(-SalAct2,"@Z 9,999,999.99-")
					ENDIF
				ENDIF
				vDatos(NumEle) = vDatos(NumEle) + PADR(SPACE(9)+LSNROREF +" "+ LSNOTAST,60)
			ENDIF
		ENDIF
	ENDDO
	IF ZfSalAct1#0 .OR. ZfSalAct2#0
		LfSalAct1 = LfSalAct1 + ZfSalAct1
		LfSalAct2 = LfSalAct2 + ZfSalAct2
		IF XiForma = 0
			NumEle = NumEle + 1
			IF NumEle < ALEN(vDatos)
				DIMENSION vDatos(NumEle+10),vCdCta(NumEle+10)
			ENDIF
			vCdCta(NumEle) = LsCodCta
			vDatos(NumEle) = PADR(PADR(LsCodAux,LEN(rmov.CodAux))+" "+LsNomAux+" ",49)
			IF ZfSalAct1 >= 0
				vDatos(NumEle) = vDatos(NumEle) + TRANSF(ZfSalAct1,"@Z 9,999,999.99  ")
			ELSE
				vDatos(NumEle) = vDatos(NumEle) + TRANSF(-ZfSalAct1,"@Z 9,999,999.99- ")
			ENDIF
			IF ZfSalAct2 >= 0
				vDatos(NumEle) = vDatos(NumEle) + TRANSF(ZfSalAct2,"@Z 9,999,999.99  ")
			ELSE
				vDatos(NumEle) = vDatos(NumEle) + TRANSF(-ZfSalAct2,"@Z 9,999,999.99- ")
			ENDIF
		ENDIF
	ENDIF
ENDDO
RETURN

********************
PROCEDURE Close_File
********************
IF USED('CTAS')
	USE IN CTAS
ENDIF
IF USED('AUXI')
	USE IN AUXI
ENDIF
IF USED('VMOV')
	USE IN VMOV
ENDIF
IF USED('RMOV')
	USE IN RMOV
ENDIF
IF USED('TCMB')
	USE IN TCMB
ENDIF
IF USED('TABL')
	USE IN TABL
ENDIF
IF USED('PROV')
	USE IN PROV
ENDIF
FUNCTION v1
UltTecla = LASTKEY()
WAIT WINDOW STR(UltTecla) nowait

**************
FUNCTION Dato1
**************
UltTecla = Lastkey()
OK = 1
CLEAR READ
RETURN .T.

**************
FUNCTION Dato2
**************
UltTecla = Lastkey()
OK = 1
CLEAR READ
RETURN .T.