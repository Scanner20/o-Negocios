********************************************************************************
* Progrma       : Cbd_PrgRepAnal6Mes.PRG                                       *
* Objeto        : Análisis de la clase 6 por mes y por Centro de Cosots        *
* Autor         : JC-JA                                                        *
* Creación      : 06/09/2009                                                   *
********************************************************************************
PUBLIC LoContab as Contabilidad OF "\AplVfp\Clases\Vcxs\DosVr.vcx" 
LoDatAdm = CREATEOBJECT('Dosvr.DataAdmin')
*!*	Aperturamos tablas
gosvrcbd.odatadm.abrirtabla('ABRIR','CBDMTABL','TABL','TABL01','')
gosvrcbd.odatadm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
gosvrcbd.odatadm.abrirtabla('ABRIR','CBDACMCT','ACCT','ACCT02','')
*!*	gosvrcbd.odatadm.abrirtabla('ABRIR','CBDACMC1','ACC1','ACCT02','')
gosvrcbd.odatadm.abrirtabla('ABRIR','CBDCNFG1','CNFG1','NIVCTA','')
gosvrcbd.odatadm.abrirtabla('ABRIR','CBDRMOVM','RMOV','RMOV05','')
*!*	Declaramos varibles
DIMENSION SAC(6,12)
DIMENSION vIMP(12),vTot(12)
STORE 0 to vImp,vTot
XiCodMon = 1
XsMesIni = '01'
XsMesFin = TRANSFORM(_Mes,'@L ##')
XnNivCta = 1
LiNroDig = 1
XiTpoCco = 1
XiForm   = 1
XiTipo   = 2  && Inicializamos en la option 2

*!*	Ejecutamos Formulario

DO FORM Cbd_FrmRepAnal6Mes
RELEASE LoDatAdm
RETURN

****************
PROCEDURE Listar
****************
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
IF USED('Clase6_Normal')
   USE IN Clase6_Normal
ENDIF
USE (Tempo_a) ALIAS Clase6_Normal EXCLUSIVE
*!*	INDEX ON CodCta + CodCco + CodAux TAG CCTO01
*!*	INDEX ON CodCta + CodAux          TAG CCTO02 addi
*!*	INDEX ON CodCco + CodCta + CodAux TAG CCTO03 addi 
INDEX ON CodCta + CodCco TAG CCTO01
INDEX ON CodCta          TAG CCTO02 addi
INDEX ON CodCco + CodCta TAG CCTO03 addi 
SET ORDER TO CCTO01
*
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
   COPY TO &ArcTmp WHILE CODCTA=[6] FOR((Val(NroMes)>=XiMesIni AND Val(NroMes)<=XiMesFin))
else
   COPY TO &ArcTmp WHILE CODCTA=[6] FOR((Val(NroMes)>=XiMesIni AND Val(NroMes)<=XiMesFin) AND INLIST(ALLTRIM(CodCco),&cCentroCostos))
ENDIF
IF USED('TEMP')
   USE IN TEMP
ENDIF
SELECT 0
USE (ArcTmp) ALIAS TEMP EXCLUSIVE
*!*	INDEX ON CodCta + CodAux + CodCCo Tag TEMP01 
*!*	INDEX ON CodCta + CodAux          Tag TEMP02 addi
*!*	INDEX ON CodCco + CodCta+ CodAux  Tag TEMP03 addi 
INDEX ON CodCta + CodCCo Tag TEMP01
INDEX ON CodCta          Tag TEMP02 addi
INDEX ON CodCco + CodCta Tag TEMP03 addi 
SET ORDER TO TEMP01
*
SELECT CCTO
GO TOP
*
SELECT TEMP
DO CASE 
   CASE XiTpoCco = 1
	    IF XiTipo = 1
           DO Imp_Clase_6_D
        ELSE
           DO Imp_Clase_6_R
        ENDIF
   OTHERWISE
	    IF XiTipo = 1
           DO Imp_Clase_6_D
        ELSE
           DO Imp_Clase_6_CR
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
SELECT Clase6_Normal
GO TOP
IF EOF()
	WAIT WINDOW 'No existen registros a Listar' NOWAIT
	IF NOT EMPTY(LcAlias)
		SELECT (LcAlias)
	ENDIF
	RETURN
ENDIF
*
DO CASE
   CASE XiTpoCco = 1
   		IF XiForm = 1
           IF XiTipo = 1
	          lcRptTxt = 'Cbd_RptRepAnal6Mes_A'
	          lcRptGraph = 'Cbd_RptRepAnal6Mes_A'
           ELSE
	          lcRptTxt = 'Cbd_RptRepAnal6Mes_AR'
	          lcRptGraph = 'Cbd_RptRepAnal6Mes_AR'
           ENDIF
   	    ELSE
           IF XiTipo = 1
	          lcRptTxt = 'Cbd_RptRepAnal6Mes_AG'
	          lcRptGraph = 'Cbd_RptRepAnal6Mes_AG'
           else
	          lcRptTxt = 'Cbd_RptRepAnal6Mes_AGR'
	          lcRptGraph = 'Cbd_RptRepAnal6Mes_AGR'
	       ENDIF   
	    ENDIF
   OTHERWISE
        IF XiForm = 1
	       lcRptTxt = 'Cbd_RptRepAnal6Mes_B'
	       lcRptGraph = 'Cbd_RptRepAnal6Mes_B'
        ELSE 
	       lcRptTxt = 'Cbd_RptRepAnal6Mes_BG'
	       lcRptGraph = 'Cbd_RptRepAnal6Mes_BG'
   		ENDIF
ENDCASE
*
lcRptDesc = 'Clase 6'
LoTipRep = ''
DO FORM ClaGen_Spool WITH lcRptTxt , lcRptGraph , '1' , 2 , lcRptDesc
USE IN Clase6_Normal
IF NOT EMPTY(LcAlias)
	SELECT (LcAlias)
ENDIF
RELEASE LcArcTmp,LcAlias,LnNumReg
USE IN TEMP
RETURN
*
************************
PROCEDURE Imp_Clase_6_CR
************************
SELECT Clase6_Normal
SET ORDER TO CCTO03 
SELECT TEMP
SET ORDER TO TEMP03 
GO TOP
DO WHILE !EOF()
   XsCodCco = CodCco
   =SEEK(ALLTRIM(GsClfCct)+ALLTRIM(XsCodCco),'TABL')
   XsNomCco = ALLTRIM(TABL.Nombre)
   DO WHILE !EOF() AND CodCco = XsCodCco
      XsCodCta = CodCta
	  =SEEK(XsCodCta,'CTAS')
	  XsNomCta = ALLTRIM(CTAS.NomCta)
      SCAN WHILE !EOF() AND CodCco = XsCodCco AND CodCta = XsCodcta
           xMes    = VAL(NroMes)
           nImport = IIF(XiCodMon=1,IIF(TpoMov='D',1,-1)*Import,IIF(TpoMov='D',1,-1)*ImpUsa)
           SELECT Clase6_Normal
           SEEK XsCodCco+XsCodCta
		   IF !FOUND()
		       APPEND BLANK
		       REPLACE CodCco WITH XsCodCco, NomCco WITH XsNomCco		       
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
PROCEDURE Imp_Clase_6_R
***********************
SELECT Clase6_Normal
SET ORDER TO CCTO02 
SELECT TEMP
SET ORDER TO TEMP02 
GO TOP
DO WHILE !EOF()
   XsCodCta = CodCta
   =SEEK(XsCodCta,'CTAS')
   XsNomCta = ALLTRIM(CTAS.NomCta)
   SCAN WHILE !EOF() AND CodCta = XsCodcta
        xMes    = VAL(NroMes)
        nImport = IIF(XiCodMon=1,IIF(TpoMov='D',1,-1)*Import,IIF(TpoMov='D',1,-1)*ImpUsa)
        SELECT Clase6_Normal
        SEEK XsCodCta
		IF !FOUND()
		    APPEND BLANK
		    REPLACE CodCta WITH XsCodCta, NomCta WITH XsNomCta
	    ENDIF
	    CmpMes = "Mes"+TRAN(xMes,"@L 99")   
   	    REPLACE (CmpMes) WITH EVAL(CmpMes) + nImport
        REPLACE Total    WITH Total + nImport
		SELECT TEMP
   ENDSCAN
ENDDO      
RETURN
*
***********************
PROCEDURE Imp_Clase_6_D
***********************
SELECT Clase6_Normal
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
      XsCodCta = CodCta
	  =SEEK(XsCodCta,'CTAS')
	  XsNomCta = ALLTRIM(CTAS.NomCta)
      XsCond1  = [CodCta = XsCodCta]
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
         XsCodCta = CodCta
	     =SEEK(XsCodCta,'CTAS')
	     XsNomCta = ALLTRIM(CTAS.NomCta)
         XsCond2  = [CodCta = XsCodCta]
	  ENDIF
	  *
      SCAN WHILE !EOF() AND &XsCond1 AND &XsCond2
           xMes    = VAL(NroMes)
           nImport = IIF(XiCodMon=1,IIF(TpoMov='D',1,-1)*Import,IIF(TpoMov='D',1,-1)*ImpUsa)
           SELECT Clase6_Normal
           IF XiTpoCco = 1
              SEEK XsCodCta
           ELSE
              SEEK XsCodCco+XsCodCta         	  
           ENDIF
		   IF !FOUND()
		       APPEND BLANK
		       REPLACE CodCta WITH XsCodCta, NomCta WITH XsNomCta		       
               IF XiTpoCco = 2		       
		       REPLACE CodCco WITH XsCodCco, NomCco WITH XsNomCco
		       ENDIF
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
