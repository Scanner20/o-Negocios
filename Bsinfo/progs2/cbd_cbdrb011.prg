********************************************************************************
* Progrma       : CBDRB011.PRG                                                 *
* Objeto        : An lisis de cuentas por meses                                *
* Creaci¢n      : 26/07/93                                                     *
* Actualizaci¢n : 14/04/2000 VETT         									   *	
* Actualizacion : 2007/07/10 VETT Proyectos/Centro Costo / Cta. Presupuestal   *
* Actualizacion : 2008/05/22 VETT Detalle por C/Costo o presupuesto o proyecto *
********************************************************************************
#INCLUDE CONST.H
DIMENSION SAC(6,12)
DIMENSION vIMP(12),vTot(12),vAux(12)
STORE 0 to vImp,vTot,vAux
STORE "" TO ArcTmp,ArcTmp2,ArcTmp3
*
gosvrcbd.odatadm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
gosvrcbd.odatadm.abrirtabla('ABRIR','CBDACMCT','ACCT','ACCT02','')
gosvrcbd.odatadm.abrirtabla('ABRIR','CBDCNFG1','CNFG1','NIVCTA','')
gosvrcbd.odatadm.abrirtabla('ABRIR','CBDRMOVM','RMOV','RMOV09','')
gosvrcbd.odatadm.abrirtabla('ABRIR','CBDMAUXI','AUXI','AUXI01','')
gosvrcbd.odatadm.abrirtabla('ABRIR','CBDMTABL','TABL','TABL01','')
gosvrcbd.odatadm.abrirtabla('ABRIR','CBDVMOVM','VMOV','VMOV01','')
gosvrcbd.odatadm.abrirtabla('ABRIR','CBDPPRES','PPRE','PPRE01','')
gosvrcbd.odatadm.abrirtabla('ABRIR','CBDTOPER','OPER','OPER01','')
******
cTit1 = GsNomCia
cTit2 = MES(_MES,3)+" "+TRANS(_ANO,"9999")
cTit3 = "Usuario : "+TRIM(GsUsuario)
cTit4 = "ANALISIS DE LA CLASE 9 POR MES"
*!*	Do Fondo WITH cTit1,cTit2,cTit3,cTit4
UltTecla = 0
INC = 0   && SOLES
XiCodMon = 1
*Escape_ = 27
Cancelar = .F.

*!*	DO LIB_MTEC WITH 16
XiMesIni = 1
XiMesFin = _Mes
XiNroDig = 1
LiNroDig = 3
XsCtaDes = PADR(CTAS.CodCta,LEN(CTAS.CODCTA))
XsCtaHas = PADR(CTAS.CodCta,LEN(CTAS.CODCTA))
XsCodCco = PADR(RMOV.CodCco,LEN(rmov.CodCco))  
XsCtaPre = PADR(RMOV.CtaPre,LEN(rmov.CtaPre))  
LsDesCodCCo = ''
LsDesCtaPre = ''
LsEtiqueta  = ''
LDetalle = .f.
XlDetalle_RMOV = .f.
XnOrd_Aux_Det = 1
XnFl_Cja = 1
nd=0
XlFormato = .F.  && Sin decimales por defecto para Gerencia 
IF XlFormato
	XnEsp	 = 14
	XsPicture	= "@Z ####,###,###"
ELSE
	XnEsp	 = 17
	XsPicture	= "@Z ####,###,###.##"
ENDIF
EXTERNAL ARRAY VecOpc

XnCodDiv = 1+GnDivis
Store [] TO XsCodDiv
XsForLibros = "SEEK(CodOpe,'OPER') AND OPER.Libros"

DO FORM Cbd_Analisis_Cuentas_x_Meses
RETURN 
******************
PROCEDURE __Procesar_Reporte
******************
IF XlFormato
	XnEsp	 = 14
	XsPicture	= "@Z ####,###,###"
ELSE
	XnEsp	 = 17
	XsPicture	= "@Z ####,###,###.##"
ENDIF

sele cnfg1
set order to nrodig
=SEEK(STR(LiNroDig,2,0),"CNFG1")
*lDetalle=IiF(Cnfg1.Ultimo=1,.T.,.F.)

VecOpc(1)="NUEVOS SOLES      "
VecOpc(2)="DOLARES AMERICANOS"

*!*	@ 20,20 SAY " ****  En proceso de Actualizaci¢n **** " COLOR -
*!*	@ 21,20 SAY "       Espere un momento por favor      " COLOR SCHEME 11

ArcTmp = Pathuser+SYS(3)
XsCodCco = TRIM(XsCodCco)
XsCtaPre = TRIM(XsCtaPre)
XsCtaDes = TRIM(XsCtaDes)
XsCtaHas = TRIM(XsCtaHas)+CHR(255)
LlPreCCo = !EMPTY(XsCodCCo) OR !EMPTY(XsCtaPre)



IF !XlDetalle_RMOV AND !LlPreCCo
	SELECT ACCT
	SEEK XsCtaDes
	IF XiCodMon = 1
		COPY TO &ArcTmp FOR LEN(TRIM(CodCta))=LiNroDig  .AND. (Val(NroMes)>=XiMesIni .AND. Val(NroMes)<=XiMesFin) .AND. (DBENAC - HBENAC)#0 WHILE CODCTA<=XsCtaHas
	ELSE
		COPY TO &ArcTmp FOR LEN(TRIM(CodCta))=LiNroDig  .AND. (Val(NroMes)>=XiMesIni .AND. Val(NroMes)<=XiMesFin) .AND. (DBEEXT - HBEEXT)#0 WHILE CODCTA<=XsCtaHas
	ENDIF
	SELECT 0
	USE (ArcTmp) ALIAS TEMPO Excl 
ELSE
	=CreaTemp_Rmov_Aux_Det()
	LsFiltro = IIF(EMPTY(XsCodCCo),'.T.','CodCCo = XsCodCCo')
	LsFiltro = LsFiltro + ' AND ' + IIF(EMPTY(XsCtaPre),'.T.','CtaPre = XsCtaPre')
	
	SELECT RMOV
	SET ORDER TO RMOV03
	SEEK TRANSFORM(XiMesIni,"@L ##")+XsCtaDes
	COPY TO &ArcTmp. FOR 0>1  && Creamos un temporal vacio
	SELECT 0
	USE (ArcTmp) ALIAS TEMPO Excl 
	INDEX on NroMes+CodCta+CodAux+CodCco TAG TEMP00
	SET ORDER TO TEMP00
	XsFor1= IIF(!GoCfgCbd.TIPO_CONSO=2 OR XsCodDiv='**','.T.','CodDiv=XsCodDiv')
	
	IF XnFl_Cja = 1
		FOR TnMes = XiMesIni TO XiMesFin
			SELECT RMOV
			SEEK TRANSFORM(TnMes,'@L 99')
			SCAN WHILE NroMes=TRANSFORM(TnMes,'@L 99') FOR EVALUATE(XsFor1)
*!*			    	        IF !(INLIST(CodCta,[9],[10],[79],[61])) AND INLIST(CodOpe,[001],[002],[009])  && Harcode de Jenny para Trinidad/EquiTransport 
					 ** VETT  25/06/2010 01:15 PM : Mejor lo configuramos y controlamos desde el maestro de OPERaciones contables. 
				 IF SEEK(CodOpe,'OPER') AND OPER.Libros   
			    	        IF Import <> 0 OR ImpUsa <> 0 AND !EMPTY(CodOpe) AND !EMPTY(NroAst)
							IF SEEK(NroMes+CodOpe+NroAst,'VMOV')
								=CALC_Import(0,RMOV.CtaPre)
								LsFiltro_D_H = '.T.'
								IF EMPTY(PPRE.D_H)
									LsFiltro_D_H = '.T.'
								ELSE	
									LsFiltro_D_H = 'TpoMov=PPRE.D_H'							
								ENDIF
								IF &LsFiltro AND &LsFiltro_D_H
									DO GenDetalle_Rmov
									SELECT TEMPO
									SEEK RMOV.NroMes+RMOV.CodCta+RMOV.CodAux+RMOV.CodCCo
									IF !FOUND()
										APPEND BLANK 
										REPLACE  NroMes WITH RMOV.Nromes, CodCta WITH RMOV.CodCta,CodAux ;
										 WITH RMOV.CodAux, CodCco WITH RMOV.CodCco
										SELECT RMOV
									ENDIF
								ENDIF		
		 					ENDIF	
					ENDIF	
				ENDIF
				SELECT RMOV 
				Cancelar = ( INKEY() = k_esc )
			ENDSCAN
			SELECT CTAS
		ENDFOR
		
	ELSE
		     
	
		SELECT CTAS
		SEEK XsCtaDes 
		SCAN WHILE CodCta <=XsCtaHas FOR  LEN(TRIM(CodCta))=LiNroDig AND !Cancelar
*!*				IF codcta='63210200'
*!*					SET STEP ON 
*!*				endif
			FOR TnMes = XiMesIni TO XiMesFin
				SELECT RMOV
				SEEK TRANSFORM(TnMes,'@L 99')+CTAS.CodCta
				SCAN WHILE NroMes=TRANSFORM(TnMes,'@L 99') AND CodCta=CTAS.CodCta FOR EVALUATE(XsFor1)
					IF SEEK(CodOpe,'OPER') AND OPER.Libros   
						IF Import <> 0 OR ImpUsa <> 0 AND !EMPTY(CodOpe) AND !EMPTY(NroAst)
							IF SEEK(NroMes+CodOpe+NroAst,'VMOV')
								IF &LsFiltro
									DO GenDetalle_Rmov
									SELECT TEMPO
									SEEK RMOV.NroMes+RMOV.CodCta+RMOV.CodAux+RMOV.CodCCo
									IF !FOUND()
										APPEND BLANK 
										REPLACE  NroMes WITH RMOV.Nromes, CodCta WITH RMOV.CodCta,CodAux ;
										 WITH RMOV.CodAux, CodCco WITH RMOV.CodCco
										SELECT RMOV
									ENDIF
								ENDIF		
			 				ENDIF	
						ENDIF	
					ENDIF
					SELECT RMOV 
					Cancelar = ( INKEY() = k_esc )
				ENDSCAN
				SELECT CTAS
			ENDFOR
		ENDSCAN
	ENDIF
ENDIF	
*!*	SET TALK OFF
SELECT TEMPO
IF !EMPTY(XsCodCCo) OR !EMPTY(XsCtaPre)
	INDEX ON CODCTA+NroMes Tag  temp01  UNIQUE
ELSE
	INDEX ON CODCTA+CODREF Tag  temp01 
ENDIF	
INDEX on CodRef+CodCta TAG TEMP02 UNIQUE
INDEX ON CodCta TAG TEMP03 UNIQUE 
IF !XlDetalle_RMOV AND !LlPreCCo
	SET order TO temp01
ELSE
	INDEX ON CodAux TAG TEMP04 UNIQUE 
	DO CASE 
		CASE XnOrd_Aux_Det = 1
			SET ORDER TO TEMP03
		CASE XnOrd_Aux_Det = 2
			SET ORDER TO TEMP04
	ENDCASE	
ENDIF	
LOCATE
if eof()
	MESSAGEBOX("No existen datos a listar...Pulse una tecla",64,'!ATENCION!')
	return
ENDIF

IF lDetalle
	DO gentempo
	RETURN
ELSE
	*** Pantalla de datos  ***
	DO F0PRINT
	IF UltTecla = ESCAPE_
	   RETURN
	ENDIF
	DO IMP_X  &&& BARRE CBDRMOVM  OJO - JENNY
ENDIF
RETURN 
***************
PROCEDURE IMP_X
***************
IF USED('RMOV_AUX')
	USE IN 'RMOV_AUX'
ENDIF
*!*	IF USED('RMOV_AUX_DET')
*!*		USE IN 'RMOV_AUX_DET'
*!*	ENDIF

Ancho = 252
Cancelar = .F.
*** VETT 2008-05-30 ----- INI
LnOrientacion=PRTINFO(1)    && 0 Vertical (Portrait), 1 Horizontal (Landscape)
XnLargo = IIF(LnOrientacion=0,66,IIF(LnOrientacion=1,60,66)) 
Largo    = XnLargo
LinFin   = Largo - 2
*** VETT 2008-05-30 ----- FIN
IniImp  = _PRN4+_PRN8A
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = ""
Tit_SDER = "FECHA : "+DTOC(DATE())
Tit_IDER = ""
Titulo  = "ANALISIS DE CUENTA X MESES"
SubTitulo = "De "+Mes(XiMesIni,3)+" A "+Mes(XiMesFin,3)+"-"+STR(_Ano,4)
En1 = "(EXPRESADO EN "+TRIM(VECOPC(XiCodMon))+")"
En2 = "<HORA : "+TIME()
En3 = ""
IF !EMPTY(LsDesCodCCo)
	En4 = "Centro Costo: "+XsCodCco+' '+LsDesCodCco
ELSE
	En4 = ""
ENDIF
IF !EMPTY(LsDesCtaPre)
	En5 = LsEtiqueta+": "+XsCtaPre+' '+LsDesCtaPre
ELSE
	En5 = ""
ENDIF
En6 = ""
DO CASE
	CASE !XlDetalle_RMOV
	
En7 = "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
En8 = "     CUENTAS - CONCEPTOS             ENERO          FEBRERO             MARZO           ABRIL              MAYO            JUNIO           JULIO          AGOSTO         SETIEMBRE          OCTUBRE         NOVIEMBRE    "
En9 = "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
En7 =En7+"-----------------------------------"
En8 =En8+"   DICIEMBRE       ACUMULADO       "
En9 =En9+"-----------------------------------"
		STORE "" TO  LsEncab1,LsEncab2,LsEncab3,LsEncab4
		LsEncab1 = LEFT(En7,30)
		LsEncab2 = LEFT(En8,30)
		LsEncab3 = LEFT(En9,30)
		PRIVATE K
		FOR K = 1 TO 13
		    LsEncab1 = LsEncab1 + REPLI('-',XnEsp)
		    LsEncab2 = LsEncab2 + IIF(k<13,PADC(TRIM(MES(K,1)),XnEsp-1)+[ ],PADC('ACUMULADO',XnEsp-1)+[ ])
		    LsEncab3 = LsEncab3 + REPLI('-',XnEsp)
		ENDFOR
		RELEASE K
		En7 = LsEncab1
		En8 = LsEncab2
		En9 = LsEncab3
		Ancho = 30+ XnEsp*13

	CASE XlDetalle_RMOV AND XiMesIni<>XiMesFin
En7 = "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
En8 = "     CUENTAS - CONCEPTOS             ENERO          FEBRERO             MARZO           ABRIL              MAYO            JUNIO           JULIO          AGOSTO         SETIEMBRE          OCTUBRE         NOVIEMBRE    "
En9 = "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
En7 =En7+"-----------------------------------"
En8 =En8+"   DICIEMBRE       ACUMULADO       "
En9 =En9+"-----------------------------------"

			STORE "" TO  LsEncab1,LsEncab2,LsEncab3,LsEncab4
			LsEncab1 = LEFT(En7,30)
			LsEncab2 = LEFT(En8,30)
			LsEncab3 = LEFT(En9,30)
			PRIVATE K
			FOR K = 1 TO 13
			    LsEncab1 = LsEncab1 + REPLI('-',XnEsp)
			    LsEncab2 = LsEncab2 + IIF(k<13,PADC(TRIM(MES(K,1)),XnEsp-1)+[ ],PADC('ACUMULADO',XnEsp-1)+[ ])
			    LsEncab3 = LsEncab3 + REPLI('-',XnEsp)
			ENDFOR
			RELEASE K
			En7 = LsEncab1
			En8 = LsEncab2
			En9 = LsEncab3
			Ancho = 30+ XnEsp*13

	CASE XlDetalle_RMOV AND XiMesIni=XiMesFin
En7 = "--------------------------------------------------------------------------------------------------------------"
En8 = "     CUENTAS - CONCEPTOS                                      DOCUMENTO            FECHA          TOTAL       "
En9 = "--------------------------------------------------------------------------------------------------------------"
	Ancho = LEN(En9)
ENDCASE
 	  *-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
	  *     CUENTAS - CONCEPTOS         1234567890123456789012345 12345678901234567890 99/99/9999   999,999,999.99 
	  *-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
	  *1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	  *                                34                         60                   81           94 
	  *-------------------------------------"
	  *    DICIEMBRE        ACUMULADO       "
	  *-------------------------------------"
	  * ###,###,###.## CR ###,###,###.## CR


*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Texto1 = PADL("A "+Mes(_Mes,3),20)
Texto2 = PADL("A "+Mes(iif(_Mes>0,_mes-1,0),3),20)
Cancelar = .F.
Pos1 = 50
Pos2 = 71
*@ 20,20 SAY " *****   En proceso de Impresi¢n  ***** " COLOR SCHEME 11
*@ 21,20 SAY " Presione [ESC] para cancelar Impresi¢n " COLOR SCHEME 11
*@ 21,31 SAY "ESC" COLOR SCHEME 7
SELECT TEMPO
LOCATE
SET DEVICE TO PRINT
SET MARGIN TO 0
PRINTJOB
	Inicio = .T.
	NumPag  = 0
	NumLin  = 0
	STORE 0 TO vTot
	DO WHILE ! EOF() AND  !Cancelar
		LsCodCta = CodCta
		vImp = 0
		LlPreCCo = !EMPTY(XsCodCCo) OR !EMPTY(XsCtaPre)
		LHayMovimiento = .F.	
		IF !XlDetalle_RMOV AND !LlPreCco
			IF DBENAC=0 AND HbeNAC =0 AND XiCodMon=1 AND !LlPreCCo
				SKIP
				LOOP
			ENDIF
			IF DBEEXT=0 AND HbeEXT =0 AND XiCodMon=2 AND !LlPreCCo
				SKIP
				LOOP
			ENDIF
			IF DBEEXT=0 AND HbeEXT =0 AND DBENAC=0 AND HbeNAC =0
				SKIP
				LOOP
			ENDIF
			DO Calculo
			DO LinImp
			SELECT TEMPO
		ELSE
			LsCodAux = CodAux
			SELECT RMOV_AUX_DET
			IF XnOrd_Aux_Det  = 1
				SET ORDER TO CodCta
				LsLlave1	= LsCodCta
				LsCampos1	= [CodCta]
				LsLLave2 	= LsCodCta+LsCodAux
				LsCampos2	= [CodCta+CodAux]
			ELSE
				SET ORDER TO CodAux
				LsLlave1	= LsCodAux
				LsCampos1	= [CodAux]
				LsLLave2	= LsCodAux+LsCodCta
				LsCampos2	= [CodAux+CodCta]
			ENDIF			
			=SEEK(LsCodCta,'CTAS','CTAS01')
			LsClfAux = CTAS.ClfAux
			DO LinImp_RMOV
			DO LinImp_Aux_Total
*!*				IF XiMesIni<>XiMesFin
*!*					DO LinImp_Aux
*!*				ELSE
				DO LinImp_Aux_Docs
*!*				ENDIF
			SELECT TEMPO
			SKIP 
		ENDIF
		Cancelar = ( INKEY() = k_esc )
	ENDDO
	NumLin = PROW() + 1
	DO TOTIMP
	EJECT PAGE
ENDPRINTJOB
SET MARGIN TO 0
SET DEVICE TO SCREEN
DO F0PRFIN
RETURN
*****************
PROCEDURE Calculo
*****************
DO CASE 
*!*		CASE !LlPreCCo    && No es por centro de costo , No es por CtaPre (Proyecto)
	CASE !LlPreCCo AND !XlDetalle_RMOV   && No es por centro de costo , No es por CtaPre (Proyecto) , ni detallado por auxiliar
		LHayMovimiento = .T.
		DO WHILE !EOF() AND CodCta=LsCodCta
			xmes = VAL(NroMes)
			IF XiCodMon = 1
				vImp(xMes) = vImp(xMes) + (DbeNac - HbeNac)
			ELSE
				vImp(xMes) = vImp(xMes) + (DbeExt - HbeExt)
			ENDIF
			SKIP
		ENDDO
	CASE LlPreCCo OR XlDetalle_RMOV
		LsFiltro = IIF(EMPTY(XsCodCCo),'.T.','CodCCo = XsCodCCo')
		LsFiltro = LsFiltro + ' AND ' + IIF(EMPTY(XsCtaPre),'.T.','CtaPre = XsCtaPre')
		LsAreaAct = ALIAS()		
		DO WHILE !EOF() AND CodCta=LsCodCta
			LsNroMes = TRANSFORM(VAL(NroMes),"@L ##")
			SELECT RMOV_AUX_DET
			SET ORDER TO RMOV03
			SEEK LsNroMes+LsCodCta
			SCAN WHILE nromes+codcta = LsNroMes+LsCodCta
				IF &LsFiltro
					LHayMovimiento = .T.
					xmes = VAL(NroMes)
					IF XiCodMon = 1
						vImp(xMes) = vImp(xMes) + IIF(XlFormato,ROUND(IIF(TpoMov='D',1,-1)*Import,0),IIF(TpoMov='D',1,-1)*Import) 
					ELSE
						vImp(xMes) = vImp(xMes) + IIF(XlFormato,ROUND(IIF(TpoMov='D',1,-1)*ImpUsa,0),IIF(TpoMov='D',1,-1)*ImpUsa)
					ENDIF
				ENDIF		
			ENDSCAN
			SELECT TEMPO
			SKIP
		ENDDO		
		SELECT (LsAreaAct)
ENDCASE
RETURN
****************
PROCEDURE LinImp
****************
DO RESETPAG
Numlin = PROW() + 1
TOT    = 0
=SEEK(LsCodCta,"CTAS")
@ NumLin,0 SAY LsCodCta+" "+CTAS->nomCta PICT "@S30"
FOR i = 1 to 12
	@ NumLin,30-XnEsp+I*XnEsp   SAY PICNUM(vImp[I])
	TOT      = TOT + vImp[i]
	vTot(i)     = vTot(i) + vImp[i]
	vImp[i] = 0
NEXT
@ NumLin,30 + 12*XnEsp  SAY PICNUM(TOT)
RETURN
*********************
PROCEDURE LinImp_RMOV
*********************
DO RESETPAG
Numlin = PROW() + 1
TOT    = 0
IF XnOrd_Aux_Det = 1
	=SEEK(LsCodCta,"CTAS")
	@ NumLin,0 SAY LsCodCta+" "+CTAS->nomCta PICT "@S30"
ELSE
	=SEEK(LsClfAux+LsCodAux,"AUXI")
	@ NumLin,0 SAY LsCodAux+" "+AUXI.NomAux PICT "@S30"
ENDIF
**************************
PROCEDURE LinImp_Aux_Total
**************************
LsAreaAct=SELECT()
IF !USED('RMOV_AUX_DET')
	RETURN
ENDIF
LnRegAct = RECNO()

TOT		= 0
vAux	= 0
SEEK LsLlave1
DO WHILE !EOF() AND &LsCampos1=LsLlave1 AND !Cancelar
	IF XnOrd_Aux_Det = 1
		=SEEK(ClfAux+CodAUX,"AUXI")
		LsLLave2 = LsCodCta+CodAux
	ELSE
		=SEEK(CodCta,"CTAS")
		LsLLave2 = LsCodAux+CodCta
	ENDIF
	SCAN WHILE &LsCampos2 = LsLlave2 AND !Cancelar
		xmes = VAL(NroMes)
		IF XiCodMon = 1
			LfImport = IIF(XlFormato,ROUND(IIF(TpoMov='D',1,-1)*Import,0),IIF(TpoMov='D',1,-1)*Import) 
			vAux(xMes) = vAux(xMes) + IIF(XlFormato,ROUND(IIF(TpoMov='D',1,-1)*Import,0),IIF(TpoMov='D',1,-1)*Import) 
		ELSE
			vAux(xMes) = vAux(xMes) + IIF(XlFormato,ROUND(IIF(TpoMov='D',1,-1)*ImpUsa,0),IIF(TpoMov='D',1,-1)*ImpUsa)
			LfImport = IIF(XlFormato,ROUND(IIF(TpoMov='D',1,-1)*Import,0),IIF(TpoMov='D',1,-1)*Import) 
		ENDIF
		Cancelar = ( INKEY() = k_esc )
	ENDSCAN
	Cancelar = ( INKEY() = k_esc )
ENDDO
IF LnRegAct>0
	GO LnRegAct
ENDIF
SELECT (LsAreaAct)

DO RESETPAG
Numlin = PROW()  && En la misma linea
FOR i = 1 to 12
	IF XiMesIni<>XiMesFin
		@ NumLin,30-XnEsp+I*XnEsp   SAY PICNUM(vAux[I],XsCtaPre)
	ENDIF
	TOT      = TOT + vAux[i]
	vAux[i] = 0
NEXT
IF XiMesIni<>XiMesFin
	@ NumLin,30 + 12*XnEsp  SAY PICNUM(TOT,XsCtaPre)
ELSE
	@ NumLin,94  SAY PICNUM(TOT,XsCtaPre)
ENDIF	
RETURN

********************
PROCEDURE LinImp_Aux
********************
*!*	SET STEP ON 
LsAreaAct=SELECT()
IF !USED('RMOV_AUX_DET')
	RETURN
ENDIF
DO RESETPAG
Numlin = PROW() + 1
TOT    = 0
vAux	= 0



SELECT RMOV_AUX_DET
SEEK LsCodCta
DO WHILE !EOF() AND CodCta=LsCodCta AND !Cancelar 
	=SEEK(ClfAux+CodAUX,"AUXI")
	@ NumLin,2 SAY CodAux+" "+AUXI.NomAux PICT "@S28" 
	LsCodAux=CodAux
	Tot = 0
	SCAN WHILE CodCta= LsCodCta AND CodAux = LsCodAux
		xmes = VAL(NroMes)
		IF XiCodMon = 1
			vAux(xMes) = vAux(xMes) + IIF(XlFormato,ROUND(IIF(TpoMov='D',1,-1)*Import,0),IIF(TpoMov='D',1,-1)*Import) 
		ELSE
			vAux(xMes) = vAux(xMes) + IIF(XlFormato,ROUND(IIF(TpoMov='D',1,-1)*ImpUsa,0),IIF(TpoMov='D',1,-1)*ImpUsa)
		ENDIF
	ENDSCAN
	FOR i = 1 to 12
		@ NumLin,30-XnEsp+I*XnEsp   SAY PICNUM(vAux[I],XsCtaPre)
		TOT      = TOT + vAux[i]
		vTot(i)     = vTot(i) + vAux[i]
		vAux[i] = 0
	NEXT
	@ NumLin,30 + 12*XnEsp  SAY PICNUM(TOT,XsCtaPre)
	DO RESETPAG
	Numlin = PROW() + 1
	Cancelar = ( INKEY() = k_esc )
ENDDO
*!*	SET STEP ON 
SELECT (LsAreaAct)
RETURN

*************************
PROCEDURE LinImp_Aux_Docs
*************************
*!*	SET STEP ON 
LsAreaAct=SELECT()
IF !USED('RMOV_AUX_DET')
	RETURN
ENDIF

TOT    = 0
vAux	= 0
SEEK LsLlave1
DO WHILE !EOF() AND &LsCampos1=LsLlave1 AND !Cancelar
	DO RESETPAG
	Numlin = PROW() + 1
	IF XnOrd_Aux_Det = 1
		=SEEK(ClfAux+CodAUX,"AUXI")
		@ NumLin,2 SAY CodAux+" "+AUXI.NomAux PICT "@S28" 
		LsCodAux = CodAux
		LsLLave2 = LsCodCta+LsCodAux
	ELSE
		=SEEK(CodCta,"CTAS")
		@ NumLin,2 SAY CodCta+" "+CTAS.NomCta PICT "@S28" 
		LsCodCta = CodCta
		LsLLave2 = LsCodAux+LsCodCta
	ENDIF
	Tot = 0
	SCAN WHILE &LsCampos2 = LsLlave2 AND !Cancelar
		xmes = VAL(NroMes)
		IF XiCodMon = 1
			LfImport = IIF(XlFormato,ROUND(IIF(TpoMov='D',1,-1)*Import,0),IIF(TpoMov='D',1,-1)*Import) 
			vAux(xMes) = vAux(xMes) + IIF(XlFormato,ROUND(IIF(TpoMov='D',1,-1)*Import,0),IIF(TpoMov='D',1,-1)*Import) 
		ELSE
			vAux(xMes) = vAux(xMes) + IIF(XlFormato,ROUND(IIF(TpoMov='D',1,-1)*ImpUsa,0),IIF(TpoMov='D',1,-1)*ImpUsa)
			LfImport = IIF(XlFormato,ROUND(IIF(TpoMov='D',1,-1)*ImpUsa,0),IIF(TpoMov='D',1,-1)*ImpUsa) 
		ENDIF
		IF XiMesIni=XiMesFin
			DO RESETPAG
			Numlin = PROW() + 1
			=SEEK(PADR(GsClfCct,LEN(TABL.Tabla))+PADR(CodCCo,LEN(Tabl.Codigo)),'TABL')
			@ NumLin,2    SAY PADR(GLODOC,30)
			@ NumLin,34   SAY PADR(TRIM(CodCco)+' '+TABL.NomBre,20)
			@ NumLin,60   SAY PADR(NroDoc,20)
			@ NumLin,81   SAY PADR(DTOC(FchDoc),10)
			@ NumLin,94   SAY PICNUM(LfImport,CtaPre)
		ENDIF
		Cancelar = ( INKEY() = k_esc )
	ENDSCAN
	FOR i = 1 to 12
		IF XiMesIni<>XiMesFin
			DO RESETPAG
			Numlin = PROW()
			@ NumLin,30-XnEsp+I*XnEsp   SAY PICNUM(vAux[I],XsCtaPre)
		ENDIF	
		TOT      = TOT + vAux[i]
		vTot(i)     = vTot(i) + vAux[i]
		vAux[i] = 0
	NEXT
	IF XiMesIni<>XiMesFin
		@ NumLin,30 + 12*XnEsp  SAY PICNUM(TOT,XsCtaPre)
	ELSE
		DO RESETPAG
		Numlin = PROW() + 1
		@ NumLin,94  SAY PICNUM(TOT,XsCtaPre)
	ENDIF	
	Cancelar = ( INKEY() = k_esc )
ENDDO
*!*	SET STEP ON 
SELECT (LsAreaAct)
RETURN

****************
PROCEDURE LinTOT
****************
TOT    = 0
FOR i = 1 to 12
	TOT      = TOT + vImp[i]
*!*		vTot(i)     = vTot(i) + vImp[i]
*!*		vImp[i] = 0
NEXT
RETURN TOT
****************
PROCEDURE TotImp
****************
DO RESETPAG
Numlin = PROW() + 1
@NumLin ,00 SAY REPLI("=",ANCHO)
Numlin = PROW() + 1
TOT    = 0
@ NumLin,0 SAY "TOTAL GENERAL"
FOR i = 1 to 12
	IF XiMesIni <> XiMesFin
		@ NumLin,30-XnEsp+I*XnEsp   SAY PICNUM(vTot[I],XsCtaPre)
	ENDIF
	TOT      = TOT + vTot[i]
NEXT
IF XiMesIni<>XiMesFin
	@ NumLin,30 + 12*XnEsp  SAY PICNUM(TOT,XsCtaPre)
ELSE
	@ NumLin,94  SAY PICNUM(TOT,XsCtaPre)
ENDIF	
RETURN
****************
PROCEDURE PICNUM
****************
PARAMETER Valor,_CtaPre
IF PARAMETERS()<2
	_CtaPre = ''
ENDIF
Valor = Calc_Import(Valor,_CtaPre)
IF XlFormato   && Formato de gerencia
	IF Valor<0
		RETURN TRANSF(-Valor,XsPicture)+"-"
	ELSE
		RETURN TRANSF( Valor,XsPicture)+" "
	ENDIF
ELSE 
	IF Valor<0
		RETURN TRANSF(-Valor,XsPicture)+"-"
	ELSE
		RETURN TRANSF( Valor,XsPicture)+" "
	ENDIF
ENDIF
********************
FUNCTION Calc_Import
********************
PARAMETERS PfImport,_CtaPre
LnSigno = 1
IF XnFl_Cja = 1 AND !EMPTY(_CtaPre)
	=SEEK(_CtaPre,'PPRE')
	LnSigno = IIF(PPRE.Signo=0,1,PPRE.Signo)
	FfImport = ABS(PfImport) * LnSigNo	
ELSE	
	FfImport = PfImport
ENDIF

RETURN FfImport
******************
procedure ResetPag
******************
IF LinFin <= PROW() .OR. Inicio
	Inicio  = .F.
	DO F0MBPRN
	IF UltTecla = Escape_
		Cancelar = .T.
	ENDIF
ENDIF
RETURN
******************
PROCEDURE GENTEMPO
******************
ArcTmp2 = pathuser+sys(3)
SELE 0
CREATE TABLE FREE (ArcTmp2) (CodCta C(LEN(ACCT.CodCta)), NomCta C(Len(CTAS.NomCta)), ;
				CodRef C(LEN(ACCT.CodRef)),;	
				vImp01 n(14,2),vImp02 n(14,2),vImp03 n(14,2),;
				vImp04 n(14,2),vImp05 n(14,2),vImp06 n(14,2),;
				vImp07 n(14,2),vImp08 n(14,2),vImp09 n(14,2),;
				vImp10 n(14,2),vImp11 n(14,2),vImp12 n(14,2),;
				Total  n(14,2) )
				
Use (ArcTmp2) EXCLU	alias tempo2			 
INDEX ON CodCta+CodRef tag temp01
set order to temp01				
SELE tempo
GO TOP
SCAN  
	nimport= 0
	xmes = VAL(NroMes)
	IF XiCodMon = 1
		nImport = (DbeNac - HbeNac)
	ELSE
		nImport = (DbeExt - HbeExt)
	ENDIF
	SELECT tempo2
	SEEK Tempo.CodCta+Tempo.CodRef
	IF !FOUND()
		APPEND BLANK
		REPLACE CODCTA WITH tempo.CODCTA 
		REPLACE codref with tempo.codref
		=SEEK(CodCta,"CTAS")
		REPLACE NomCta WITH CTAS.NomCta
	ENDIF
	CmpMes = "vImp"+TRAN(xMes,"@L 99")   
   	REPLACE (CmpMes) WITH EVAL(CmpMes) + nImport
    REPLACE total with total + nImport
	SELECT tempo
ENDSCAN
DO imprime
IF USED('TEMPO')
	USE IN tempo 
ENDIF
IF USED('TEMPO2')
	USE IN tempo2 
ENDIF

RETURN
*******************************
FUNCTION CreaTemp_Rmov_Aux_Det
*******************************
IF !USED('RMOV_AUX_DET')
	=INKEY(.1)
	ArcTmp3 = pathuser+sys(3)
	SELE 0
	CREATE TABLE (ArcTmp3) FREE (CodCta C(LEN(ACCT.CodCta)), NomCta C(Len(CTAS.NomCta)), ;
					CodRef C(LEN(ACCT.CodRef)),;	
					vImp01 n(14,2),vImp02 n(14,2),vImp03 n(14,2),;
					vImp04 n(14,2),vImp05 n(14,2),vImp06 n(14,2),;
					vImp07 n(14,2),vImp08 n(14,2),vImp09 n(14,2),;
					vImp10 n(14,2),vImp11 n(14,2),vImp12 n(14,2),;
					Total  n(14,2),;
					Nromes C(LEN(RMOV.NroMes)),;
					CodOpe C(LEN(RMOV.CodOpe)),;
					NroAst C(LEN(RMOV.NroAst)),;
					ClfAux C(LEN(RMOV.ClfAux)),;
					CodAux C(LEN(RMOV.CodAux)),;
					NomAux C(30),;
					CodDoc C(LEN(RMOV.CodDoc)),;
					NroDoc C(LEN(RMOV.NroDoc)+4),;
					FchDoc D ,;
					Import N(14,2),;
					ImpUsa N(14,2),;
					TpoMov C(1),;
					CodCco C(LEN(RMOV.CodCco)),;
					CtaPre C(LEN(RMOV.CtaPre)),;
					TpoGto C(LEN(RMOV.TpoGto)),;
					GloDoc c(LEN(RMOV.GloDoc)))
					
					
	Use (ArcTmp3) EXCLU	alias RMOV_AUX_DET			 
	INDEX ON CodCta+CodAux+CodCCo tag CODCTA
	INDEX ON CodAux+CodCta+CodCCo tag CODAUX
	INDEX ON NroMes+CodCta+CodAux TAG RMOV03
	SET ORDER TO CodCta
ELSE
	SELECT RMOV_AUX_DET
	ZAP
ENDIF

RETURN
************************
FUNCTION GenDetalle_Rmov
************************
SELECT RMOV
SCATTER MEMVAR  
SELECT RMOV_AUX_DET
APPEND BLANK
SELECT RMOV
LsCmp = 'm.vImp'+RMOV.NroMes
STORE 0 TO &LsCmp
IF XiCodMon = 1
   &LsCmp. = &LsCmp. + IIF(XlFormato,ROUND(IIF(TpoMov='D',1,-1)*Import,0),IIF(TpoMov='D',1,-1)*Import) 
ELSE
   &LsCmp. = &LsCmp. + IIF(XlFormato,ROUND(IIF(TpoMov='D',1,-1)*ImpUsa,0),IIF(TpoMov='D',1,-1)*ImpUsa)
ENDIF
LOCAL LoDetDoc AS Busca_Doc OF SYS(5)+"\aplvfp\BsInfo\Progs\cbd_cbdrb011.prg"
LoDetDoc = CREATEOBJECT("Busca_Doc")

LaDetAux=LoDetDoc.busca_doc(m.NroMes,m.CodOpe,m.NroAst,m.ChkCta)
SELECT RMOV_AUX_DET

m.NroDoc = IIF(EMPTY(m.NroDoc),LaDetAux[1],m.NroDoc)
m.FchDoc = IIF(EMPTY(m.FchDoc),LaDetAux[2],m.FchDoc) && CTOD(SUBSTR(LsDoc_Fecha,AT('@',LsDoc_Fecha)+1))
m.ClfAux = IIF(EMPTY(m.ClfAux),LaDetAux[3],m.ClfAux )
m.CodAux = IIF(EMPTY(m.CodAux),LaDetAux[4],m.CodAux )
GATHER MEMVAR
SELECT rmov

*****************
procedure Imprime
*****************
SELE TEMPO2
GO TOP
IF EOF()
	WAIT WINDOW "No hay registros a listar...pulse una tecla"
	return
ENDIF
Ancho = 252
Cancelar = .F.
*** VETT 2008-05-30 ----- INI
LnOrientacion=PRTINFO(1)    && 0 Vertical (Portrait), 1 Horizontal (Landscape)
XnLargo = IIF(LnOrientacion=0,66,IIF(LnOrientacion=1,60,66)) 
Largo    = XnLargo
LinFin   = Largo - 2
*** VETT 2008-05-30 ----- FIN
*!*	Largo   = 66       && Largo de pagina
*!*	LinFin  = 88    - 6
IniPrn=[_Prn0+_PRN5a+chr(Largo)+_Prn5b+_Prn4]
Tit_SIZQ = TRIM(GsNomCia)
Tit_IIZQ = ""
Tit_SDER = "FECHA : "+DTOC(DATE())
Tit_IDER = ""
Titulo  = "ANALISIS DE CUENTAS X MES"
SubTitulo = "De "+Mes(XiMesIni,3)+" A "+Mes(XiMesFin,3)+"-"+STR(_Ano,4)
En1 = "(EXPRESADO EN "+TRIM(VECOPC(XiCodMon))+")"
En2 = "<HORA : "+TIME()
sNomRep = "cbdrb011"
do F0print with "REPORTS"
return

**************************************
* Creacion	:	17/09/2009 
* Autor		:	VETT
* Notas		:   Rutina que pretende mostrar el detalle de los costos y gastos
*				consolidado por cuenta , auxiliar (C.costo, Tpo. Gasto, proyecto, presupuesto, etc)
*				el problema aqui es que el detalle del reporte a generar no solo es a nivel 
*				de filas (Registros, Grupo, Sub grupo, ejem: Mayor auxiliar resumido o Balance de
*				comprobacion detallado por cuenta , PERO tambien debe estar detallado a nivel de columnas
*					 
*************************
PROCEDURE detalle_costos
*************************

**********************************
DEFINE CLASS Busca_Doc AS Custom 
**********************************
DIMENSION aDetAux[4]
	FUNCTION Busca_Doc(PsNroMes,PsCodOpe,PsNroAst,PsChkCta)
	LOCAL LsClfAux,LsNroDoc,LdFchDoc,LsCodAux
	IF !USED('RMOV_DOCS')
		=gosvrcbd.odatadm.abrirtabla('ABRIR','CBDRMOVM','RMOV_DOCS','RMOV01','')
	ENDIF
	IF !EMPTY(PsChkCta)
		LlEvalChkCta = .T.
	ELSE
		LlEvalChkCta = .F.	
	ENDIF
	LsNroDoc=''
	LdFchDoc={}
	LsClfAux = ''
	LsCodAux = ''
	STORE "" TO This.aDetAux
	SELECT RMOV_DOCS
	SEEK PsNroMes+PsCodOpe+PsNroAst
	SCAN WHILE NroMes+CodOpe+NroAst = PsNroMes+PsCodOpe+PsNroAst
		IF INLIST(CodCta,'42','46') AND (TpoMov = 'H' OR (TpoMov='D' AND CodDoc='07'))
			IF LlEvalChkCta AND !EMPTY(ChkCta) AND ChkCta = PsChkCta
				This.aDetAux[1] = NroDoc
				This.aDetAux[2] = FchDoc
				This.aDetAux[3] = ClfAux
				This.aDetAux[4] = CodAux
				EXIT
			ELSE
				This.aDetAux[1] = NroDoc
				This.aDetAux[2] = FchDoc
				This.aDetAux[3] = ClfAux
				This.aDetAux[4] = CodAux
				EXIT
			ENDIF
		ELSE

		ENDIF
	ENDSCAN
	IF EMPTY(this.aDetAux[1])
		this.aDetAux[1]=PsNroMes+'-'+PsCodOpe+'-'+SUBSTR(PsNroAst,4)
	ENDIF
	IF EMPTY(LdFchDoc)

	ENDIF
	&&RETURN LsNroDoc+"@"+DTOC(LdFchDoc)+"@"+LsClfAux+"@"+LsCodAux
	RETURN @THIS.aDetAux
	
ENDDEFINE 
