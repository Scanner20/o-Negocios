********************************************************************************
* Progrma       : Cbd_PrgRepAnal9Mes.PRG                                       *
* Objeto        : Análisis de la clase 9                                       *
* Autor         : JC-JA                                                        *
* Creación      : 03/09/2009                                                   *
********************************************************************************
PUBLIC LoContab as Contabilidad OF '\AplVfp\Clases\Vcxs\DosVr.vcx'
LoDatAdm = CREATEOBJECT('Dosvr.DataAdmin')
*!*	Apertuaramos las tablas
gosvrcbd.odatadm.abrirtabla('ABRIR','CBDMTABL','TABL','TABL01','')
gosvrcbd.odatadm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
gosvrcbd.odatadm.abrirtabla('ABRIR','CBDCNFG1','CNFG1','NIVCTA','')
gosvrcbd.odatadm.abrirtabla('ABRIR','CBDRMOVM','RMOV','RMOV05','')
*!*	Declaramos variables
DIMENSION SAC(6,12)
DIMENSION vIMP(12),vTot(12)
STORE 0 TO vImp,vTot
STORE '' TO ArcTmp,ArcTmp2,ArcTmp3
XiCodMon = 1
XsMesIni = '01'
XsMesFin = TRANSFORM(_Mes,'@L ##')
XnNivCta = 1
LiNroDig = 1
XiTpoCco = 1
XiForm   = 1
XiTipo   = 2  && El OptionGroup, devuelve 1, 2, 3... segun el numero de Opciones que tenga
 

*!*	Cargamos el formulario
DO FORM Cbd_FrmRepAnal9Mes
RETURN

**************************
PROCEDURE Procesar_Reporte
**************************
SELECT CNFG1
SET ORDER TO NroDig
=SEEK(STR(LiNroDig,2,0),"CNFG1")
lDetalle = IIF(Cnfg1.Ultimo=1,.T.,.F.)
XiMesIni = VAL(XsMesIni)
XiMesFin = VAL(XsMesFin)
VecOpc(1)="Nuevos Soles      "
VecOpc(2)="Dólares Americanos"
*!*	Cargamos Tempral
WAIT WINDOW 'Generando Temporal Inicial' TIMEOUT 0.25
ArcTmp = Pathuser + SYS(3)
WAIT WINDOW 'Generando Temporal Final' TIMEOUT 0.25
Tempo_a = Pathuser + SYS(3)
SELECT 0
CREATE TABLE (Tempo_a) FREE (CodCco c(LEN(RMOV.CodCco)), NomCco c(80),;
                             CodAux c(LEN(RMOV.CodAux)), NomAux c(LEN(CTAS.NomCta)),;
                             CodCta c(LEN(RMOV.CodCta)), NomCta c(LEN(CTAS.NomCta)),;
                             CodRef c(LEN(RMOV.CodRef)), CtaPre c(LEN(RMOV.CtaPre)),;
							 Mes01 n(16,2),Mes02 n(16,2),Mes03 n(16,2),Mes04 n(16,2),;
							 Mes05 n(16,2),Mes06 n(16,2),Mes07 n(16,2),Mes08 n(16,2),;
							 Mes09 n(16,2),Mes10 n(16,2),Mes11 n(16,2),Mes12 n(16,2),;
							 Total n(16,2))
IF USED('Clase_9')
	USE IN Clase_9
ENDIF
USE (Tempo_a) ALIAS Clase_9 EXCLUSIVE
INDEX ON CodAux + CodCco + CodCta TAG CCTO01
INDEX ON CodAux + CodCta          TAG CCTO02 addi
INDEX ON CodCco + CodAux + CodCta TAG CCTO03 addi 
SET ORDER TO CCTO01
*!* Carga los centros de costos en una variable
cCentroCostos = ''
IF XiTpoCco = 2
   SELECT CCTO
   GO TOP
   SCAN WHILE !EOF()
	    IF chk = .T.
		   cCentroCostos = cCentroCostos + '"' + ALLTRIM(Codigo) + '"' + ','
	    ENDIF
   ENDSCAN
   nCentroCostos = LEN(cCentroCostos) - 1
   cCentroCostos = LEFT(cCentroCostos,nCentroCostos)
ENDIF
* 
SELECT RMOV
SEEK [6]
IF XiTpoCco = 1
   COPY TO &ArcTmp WHILE CODCTA=[6] FOR((Val(NroMes)>=XiMesIni AND Val(NroMes)<=XiMesFin) AND !EMPTY(CodAux) AND !INLIST(LEFT(codcta,2),[66],[67]))
else
   COPY TO &ArcTmp WHILE CODCTA=[6] FOR((Val(NroMes)>=XiMesIni AND Val(NroMes)<=XiMesFin) AND !EMPTY(CodAux) AND INLIST(ALLTRIM(CodCco),&cCentroCostos) AND !INLIST(LEFT(codcta,2),[66],[67]))
ENDIF
IF USED('TEMP')
   USE IN TEMP
ENDIF
SELECT 0
USE (ArcTmp) ALIAS TEMP EXCLUSIVE
INDEX ON CodAux + CodCCo + CodCta  Tag TEMP01 
INDEX ON CodAux + CodCta           Tag TEMP02 addi
INDEX ON CodCco + CodAux + CodCta  Tag TEMP03 addi 
SET ORDER TO TEMP01
*
SELECT CCTO
GO TOP
*
SELECT TEMP
DO CASE 
   CASE XiTpoCco = 1
	    IF XiTipo = 1
           DO Imp_Clase_9_D
        ELSE
           DO Imp_Clase_9_R
        ENDIF
   OTHERWISE
	    IF XiTipo = 1
           DO Imp_Clase_9_D
        ELSE
           DO Imp_Clase_9_CR
        ENDIF
ENDCASE        
*
SubTitulo = 'DE ' + Mes(XiMesIni,3) + ' - ' + STR(_Ano,4) + ' A ' + Mes(XiMesFin,3) + ' - ' + STR(_Ano,4)
Expresado = '(EXPRESADO EN ' + TRIM(VECOPC(XiCodMon)) + ')'
LOCAL lcRptTxt,lcRptGraph,lcRptDesc
LOCAL LcArcTmp,LcAlias,LnNumReg,LnNumCmp,LlPrimera
LcArcTmp = GoEntorno.TmpPath + SYS(3)
LcAlias = ALIAS()
LnControl = 1
SELECT Clase_9
GO TOP
IF EOF()
	WAIT WINDOW 'No existen registros a Listar' NOWAIT
	IF NOT EMPTY(LcAlias)
		SELECT (LcAlias)
	ENDIF
	RETURN
ENDIF
*
DO case
   CASE XiTpoCco = 1
   		IF XiTipo = 1
   		   IF XiForm = 1
	          lcRptTxt = 'cbd_frmrepanal9_d'
	          lcRptGraph = 'cbd_frmrepanal9_d'
	       ELSE
	          lcRptTxt = 'cbd_frmrepanal9_dg'
	          lcRptGraph = 'cbd_frmrepanal9_dg'
	       ENDIF
        ELSE
   		   IF XiForm = 1
	          lcRptTxt = 'cbd_frmrepanal9_r'
	          lcRptGraph = 'cbd_frmrepanal9_r'
   		   ELSE
	          lcRptTxt = 'cbd_frmrepanal9_rg'
	          lcRptGraph = 'cbd_frmrepanal9_rg'
   		   ENDIF
        ENDIF	    
   OTHERWISE
   		IF XiTipo = 1
   		   IF XiForm = 1
	          lcRptTxt = 'cbd_frmrepanal9_dc'
	          lcRptGraph = 'cbd_frmrepanal9_dc'
   		   ELSE
	          lcRptTxt = 'cbd_frmrepanal9_dcg'
	          lcRptGraph = 'cbd_frmrepanal9_dcg'
   		   ENDIF
        ELSE
   		   IF XiForm = 1
	          lcRptTxt = 'cbd_frmrepanal9_rc'
	          lcRptGraph = 'cbd_frmrepanal9_rc'
   		   ELSE
	          lcRptTxt = 'cbd_frmrepanal9_rcg'
	          lcRptGraph = 'cbd_frmrepanal9_rcg'
   		   ENDIF
        ENDIF	    
ENDCASE
*
lcRptDesc = 'Clase 9'
LoTipRep = ''
DO FORM ClaGen_Spool WITH lcRptTxt , lcRptGraph , '1' , 2 , lcRptDesc
USE IN Clase_9
IF NOT EMPTY(LcAlias)
	SELECT (LcAlias)
ENDIF
RELEASE LcArcTmp,LcAlias,LnNumReg
USE IN TEMP
RETURN
*
************************
PROCEDURE Imp_Clase_9_CR
************************
SELECT Clase_9
SET ORDER TO CCTO03 
SELECT TEMP
SET ORDER TO TEMP03 
GO TOP
DO WHILE !EOF()
   XsCodCco = CodCco
   =SEEK(ALLTRIM(GsClfCct)+ALLTRIM(XsCodCco),'TABL')
   XsNomCco = ALLTRIM(TABL.Nombre)
   DO WHILE !EOF() AND CodCco = XsCodCco
   XsCodAux = LEFT(CodAux,2) 
   =SEEK(PADR(XsCodAux,LEN(CTAS.CodCta)),'CTAS')
   XsNomAux = ALLTRIM(CTAS.NomCta)   
   DO WHILE !EOF() AND CodCco = XsCodCco AND LEFT(CodAux,2) = XsCodAux
      XsCodCta = CodCta
	  =SEEK(XsCodCta,'CTAS')
	  XsNomCta = ALLTRIM(CTAS.NomCta)
      SCAN WHILE !EOF() AND CodCco = XsCodCco AND LEFT(CodAux,2) = XsCodAux AND CodCta = XsCodcta
           xMes    = VAL(NroMes)
           nImport = IIF(XiCodMon=1,IIF(TpoMov='D',1,-1)*Import,IIF(TpoMov='D',1,-1)*ImpUsa)
           SELECT Clase_9
           SEEK XsCodCco+PADR(XsCodAux,LEN(Clase_9.CodAux))+XsCodCta
		   IF !FOUND()
		       APPEND BLANK
		       REPLACE CodCco WITH XsCodCco, NomCco WITH XsNomCco		       
		       REPLACE CodAux WITH XsCodAux, NomAux WITH XsNomAux
		       REPLACE CodCta WITH XsCodCta, NomCta WITH XsNomCta
	       ENDIF
	       CmpMes = "Mes"+TRAN(xMes,"@L 99")   
   	       REPLACE (CmpMes) WITH EVAL(CmpMes) + nImport
           REPLACE Total    WITH Total + nImport
		   SELECT TEMP
      ENDSCAN
   ENDDO
ENDDO      
ENDDO
RETURN
*
***********************
PROCEDURE Imp_Clase_9_R
***********************
SELECT Clase_9
SET ORDER TO CCTO02 
SELECT TEMP
SET ORDER TO TEMP02 
GO TOP
DO WHILE !EOF()
   XsCodAux = LEFT(CodAux,2) 
   =SEEK(PADR(XsCodAux,LEN(CTAS.CodCta)),'CTAS')
   XsNomAux = ALLTRIM(CTAS.NomCta)   
   DO WHILE !EOF() AND LEFT(CodAux,2) = XsCodAux
      XsCodCta = CodCta
	  =SEEK(XsCodCta,'CTAS')
	  XsNomCta = ALLTRIM(CTAS.NomCta)
      SCAN WHILE !EOF() AND LEFT(CodAux,2) = XsCodAux AND CodCta = XsCodcta
           xMes    = VAL(NroMes)
           nImport = IIF(XiCodMon=1,IIF(TpoMov='D',1,-1)*Import,IIF(TpoMov='D',1,-1)*ImpUsa)
           SELECT Clase_9
           SEEK PADR(XsCodAux,LEN(Clase_9.CodAux))+XsCodCta
		   IF !FOUND()
		       APPEND BLANK
		       REPLACE CodAux WITH XsCodAux, NomAux WITH XsNomAux
		       REPLACE CodCta WITH XsCodCta, NomCta WITH XsNomCta
	       ENDIF
	       CmpMes = "Mes"+TRAN(xMes,"@L 99")   
   	       REPLACE (CmpMes) WITH EVAL(CmpMes) + nImport
           REPLACE Total    WITH Total + nImport
		   SELECT TEMP
      ENDSCAN
   ENDDO
ENDDO      
RETURN
*
***********************
PROCEDURE Imp_Clase_9_D
***********************
SELECT Clase_9
IF XiTpoCco = 1
   SET ORDER TO CCTO01 
ELSE
   SET ORDER TO CCTO03 
ENDIF
*
SELECT TEMP
IF XiTpoCco = 1
   SET ORDER TO TEMP01 
ELSE
   SET ORDER TO TEMP03 
ENDIF
*
GO TOP
DO WHILE !EOF()
   IF XiTpoCco = 1
      XsCodAux = CodAux 
      =SEEK(PADR(XsCodAux,LEN(CTAS.CodCta)),'CTAS')
      XsNomAux = ALLTRIM(CTAS.NomCta)   
      XsCond1  = [CodAux = XsCodAux]
   ELSE
      XsCodCco = CodCco
      =SEEK(ALLTRIM(GsClfCct)+ALLTRIM(XsCodCco),'TABL')
	  XsNomCco = ALLTRIM(TABL.Nombre)
      XsCond1 = [CodCco = XsCodCco]	  
   ENDIF
   *
   DO WHILE !EOF() AND &XsCond1
      IF XiTpoCco = 1
         XsCodCco = CodCco
         =SEEK(ALLTRIM(GsClfCct)+ALLTRIM(XsCodCco),'TABL')
	     XsNomCco = ALLTRIM(TABL.Nombre)
         XsCond2 = [CodCco = XsCodCco]	  
	  ELSE
         XsCodAux = CodAux 
         =SEEK(PADR(XsCodAux,LEN(CTAS.CodCta)),'CTAS')
         XsNomAux = ALLTRIM(CTAS.NomCta)   
         XsCond2  = [CodAux = XsCodAux]
	  ENDIF
	  *
      DO WHILE !EOF() AND &XsCond1 AND &XsCond2
         XsCodCta = CodCta
		 =SEEK(XsCodCta,'CTAS')
		 XsNomCta = ALLTRIM(CTAS.NomCta)
         SCAN WHILE !EOF() AND &XsCond1 AND &XsCond2 AND CodCta=XsCodCta
              IF !INLIST(LEFT(codcta,2),[66],[67])
         	  xMes    = VAL(NroMes)
         	  nImport = IIF(XiCodMon=1,IIF(TpoMov='D',1,-1)*Import,IIF(TpoMov='D',1,-1)*ImpUsa)
         	  SELECT Clase_9
         	  IF XiTpoCco = 1
         	     SEEK XsCodAux+XscodCco+XsCodCta
         	  ELSE
         	     SEEK XsCodCco+XsCodAux+XsCodCta         	  
         	  ENDIF
			  IF !FOUND()
		          APPEND BLANK
		          REPLACE CodAux WITH XsCodAux, NomAux WITH XsNomAux
		          REPLACE CodCco WITH XsCodCco, NomCco WITH XsNomCco
		          REPLACE CodCta WITH XsCodCta, NomCta WITH XsNomCta
	          ENDIF
	          CmpMes = "Mes"+TRAN(xMes,"@L 99")   
   	          REPLACE (CmpMes) WITH EVAL(CmpMes) + nImport
              REPLACE Total    WITH Total + nImport
              ENDIF
			  SELECT TEMP
         ENDSCAN
      ENDDO
   ENDDO
ENDDO 
RETURN     
*
