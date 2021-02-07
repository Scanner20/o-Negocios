lodatadm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','ALMDTRAN','DTRA','DTRA01','')
LoDatAdm.abrirtabla('ABRIR','ALMCTRAN','CTRA','CTRA01','')
LoDatAdm.abrirtabla('ABRIR','ALMTALMA','ALMA','ALMA01','')
LoDatAdm.abrirtabla('ABRIR','ALMTDIVF','DIVF','DIVF01','')
LoDatAdm.abrirtabla('ABRIR','ALMCFTRA','CFTR','CFTR01','')
LoDatAdm.abrirtabla('ABRIR','ALMCATGE','CATG','CATG01','')
LoDatAdm.abrirtabla('ABRIR','ALMDLOTE','DLOTE','DLOTE02','')
LoDatAdm.abrirtabla('ABRIR','SEDES','SEDES','SEDE01','')
LoDatAdm.abrirtabla('ABRIR','VTARITEM','ITEM','ITEM01','')
*LoDatAdm.abrirtabla('ABRIR','VTAPRCPT','PRCOM','PRCP01','')
*LoDatAdm.abrirtabla('ABRIR','VTACOMPE','COMPE','COMP01','')
LoDatAdm.abrirtabla('ABRIR','EMPRESAS','EMPRESA','EMPR01','')
RELEASE LoDatAdm
XiCostoBase = 1


DO FORM FUNVTA_VTAR4900



*********************
FUNCTION Ventas_Rango
********************* 
LPARAMETERS cItem1,cItem2,dFch1,dFch2

SELECT		item.coddoc, ;
			item.nrodoc, ;
			item.fchdoc,;
			item.Codmat,;
			Desmat,;
			canfac,;
			item.preuni,;
			implin,;
			vctomn,;
			vctous,;
			STKACT,;
			IIF(STKACT>0,ROUND(VCTOMN/STKACT,3),0) AS PCTOMN,;
			IIF(STKACT>0,ROUND(VCTOus/STKACT,3),0) AS PCTOus,;
			DTRA.TpoRef,DTRA.Nroref ;
			 FROM ITEM ;
			 INNER JOIN DTRA ;
			 ON DTRA.TpoRef+DTRA.NroRef+DTRA.CodMat = 'G/R '+item.nroref+item.codmat ;
			 WHERE item.Codmat>=cItem1 AND item.Codmat<=cItem2 AND ;
			 	  item.fchdoc>=dFch1 AND item.fchdoc<=dFch2 ;
			 	 ORDER BY item.codmat,item.fchdoc,item.coddoc,item.nrodoc ;
			 	 INTO CURSOR Cto_vtas


******************
FUNCTION Costo_Alm
******************
LPARAMETERS cItem1,cItem2,dFch1,dFch2
SELECT	codmat,;
		fchdoc,;
		PreUni,;
		impcto,;  
		vctomn,;
		stkact,;
		IIF(STKACT>0,ROUND(VCTOMN/STKACT,3),0) AS PCTOMN,;
		IIF(STKACT>0,ROUND(VCTOus/STKACT,3),0) AS PCTOus ;
		from Dtra ;
		WHERE TipMOv='I' AND CodAjt='A' AND ;
			DTRA.Codmat>=cItem1 AND DTRA.Codmat<=cItem2 AND ;
			DTRA.fchdoc>=dFch1 AND DTRA.fchdoc<=dFch2 ;
		order by codmat,fchdoc DESC INTO CURSOR  UEPS_PEPS
		
		
RETURN
		
**------------------------**
FUNCTION COSTOS_COMPETIDOR
**------------------------**		
LsArcTmp = SYS(2023)+'\'+ SYS(2015)
SELECT 0
CREATE TABLE (lsArcTmp) FREE  (Articulo C(LEN(CATG.CodMat)), Modelo C(LEN(CATG.DesMat)), ;
				CANT01 N(12,2),;
				COSTO01 N(14,4),;
				FECHA01 D ,;
				CANT02 N(12,2),;
				COSTO02 N(14,4),;
				FECHA02 D ,;
				CANT03 N(12,2),;
				COSTO03 N(14,4),;
				FECHA03 D ,;
				CANT04 N(12,2),;
				COSTO04 N(14,4),;
				FECHA04 D ,;
				CANT05 N(12,2),;
				COSTO05 N(14,4),;
				FECHA05 D ,;
				CANT06 N(12,2),;
				COSTO06 N(14,4),;
				FECHA06 D ,;
				CANT07 N(12,2),;
				COSTO07 N(14,4),;
				FECHA07 D ,;
				CANT08 N(12,2),;
				COSTO08 N(14,4),;
				FECHA08 D ,;
				CANT09 N(12,2),;
				COSTO09 N(14,4),;
				FECHA09 D ,;
				CANT10 N(12,2),;
				COSTO10 N(14,4),;
				FECHA10 D, ;
				QUIEBRE C(10), ;
				TIPO	C(5), ;
				FAMILIA C(5), ;
				SigCia01 C(20),;
				SigCia02 C(20),;
				SigCia03 C(20),;
				SigCia04 C(20),;
				SigCia05 C(20),;
				SigCia06 C(20),;
				SigCia07 C(20),;
				SigCia08 C(20),;
				SigCia09 C(20),;
				SigCia10 C(20))
				
				
				
		
USE (LsArcTmp)	EXCL ALIAS TEMPO
INDEX ON QUIEBRE+ARTICULO TAG TEMPO01
			
** 				
LsSigCia = ''				
LnCol = 1				
SELECT VTAPRCPT
SET ORDER TO 1   && CODIGO+CODMAT 
SELECT COMPE
SCAN
	SELECT EMPRESA	
	LOCATE FOR ruccia=compe.Codigo 
	IF FOUND('EMPRESA')
		TnCol = 1
	ELSE
		IF SEEK(COMPE.Codigo,'VTAPRCPT','PRCP01')		
			LnCol = LnCol + 1	
			TnCol = LnCol
		ELSE
			SELECT COMPE
			LOOP	
		ENDIF	
	ENDIF	
	SELECT COMPE

	IF TnCol = 1
		SELECT VTAPRCPT 
		SET ORDER TO PRCP02
		Arch_Temp = SYS(2023)+'\'+SYS(2015)
		TOTAL ON CODMAT TO (Arch_Temp)
		SELECT 0
		USE (Arch_Temp) ALIAS xVTAPRCPT		
		SCAN 
		
			SELECT TOP 1 DTRA.CodMat AS ARTICULO,;
						CATG.Desmat AS MODELO ,;
						DTRA.CanDes AS Cantidad, ;
						ROUND(DTRA.PreUni,2) AS Costo ,;
						DTRA.FchDoc As Fecha,;
						DTRA.CodMon ,; 
						IIF(DTRA.STKACT>0,ROUND(DTRA.VCTOMN/DTRA.STKACT,3),0) AS PCTOMN,;
						IIF(DTRA.STKACT>0,ROUND(DTRA.VCTOus/DTRA.STKACT,3),0) AS PCTOus ;
			 from dtra INNER JOIN CFTR ON CFTR.TipMov+CFTR.CodMov=DTRA.TipMov+DTRA.CodMov ;
			 INNER JOIN CATG ON CATG.CodMat = DTRA.CodMat ;
			 WHERE DTRA.CodMat=xVTAPRCPT.CodMat AND CodAjt='A' AND DTRA.TIPMOV='I' AND CFTR.Es_Imp ORDER BY DTRA.fchdoc DESCENDING ;
			 INTO ARRAY ULT_COMPRA
			 IF _Tally >0
				DO GrbTempo IN VTA_MARGEN_VENTAS
			 ENDIF	
			SELECT xVTAPRCPT
		ENDSCAN 
		IF USED('xVTAPRCPT')
			USE IN xVTAPRCPT
		ENDIF
	ELSE
		SELECT VTAPRCPT 
		SET ORDER TO PRCP01
		=SEEK(COMPE.Codigo)
		SCAN WHILE  Codigo = COMPE.Codigo
			LsCodMat = CodMat
			LsCodigo = Codigo
			SELECT TOP 1 VTAPRCPT.CodMat AS ARTICULO,;
					CATG.DesMat AS MODELO ,;
					Cantidad ,;
					Precio_CIF AS Costo,;
					FchDoc AS FECHA ,;
					Fact_Fijo, ;
					2 AS CODMON ;
			from VTAPRCPT ;
 			 INNER JOIN CATG ON CATG.CodMat = VTAPRCPT.CodMat ;
			WHERE VTAPRCPT.CodMat+VTAPRCPT.Codigo=LsCodMat+LsCodigo  ORDER BY fchdoc DESCENDING ;
			INTO ARRAY ULT_COMPRA
			
			DO GrbTempo IN VTA_MARGEN_VENTAS
			SELECT VTAPRCPT
		ENDSCAN
	ENDIF	
	SELECT COMPE
ENDSCAN


FUNCTION GrbTempo
SELECT TEMPO
SEEK PADR('B',LEN(Quiebre))+ULT_COMPRA(1)
IF !FOUND()
	APPEND BLANK
	REPLACE Articulo WITH ULT_COMPRA(1)
	REPLACE MODELO   WITH ULT_COMPRA(2)
	REPLACE QUIEBRE  WITH 'B'
ENDIF
LsCmpCant 	= 'CANT'+TRANSFORM(TnCol,'@L 99')
LsCmpCosto	= 'COSTO'+TRANSFORM(TnCol,'@L 99')
LsCmpFecha	= 'FECHA'+TRANSFORM(TnCol,'@L 99')
LsSigCia	= 'SIGCIA'+TRANSFORM(TnCol,'@L 99')
Replace (LsCmpCant) 	WITH ULT_COMPRA(3)
Replace (LsCmpCosto) 	WITH ULT_COMPRA(4)
Replace (LsCmpFecha) 	WITH ULT_COMPRA(5)
IF !SEEK('A') 
	APPEND BLANK
	REPLACE QUIEBRE WITH 'A'
ENDIF
Replace (LsSigCia) WITH PADC(Compe.SigCia,20)
