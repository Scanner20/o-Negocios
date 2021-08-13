PARAMETERS PsAAAA , PsMes
#INCLUDE CONST.H


LsMesAct	=	PsMes
LnAAAA		=	VAL(PsAAAA)
LnMes 		=	VAL(PsMes)
PsAAAAMM	=	PsAAAA + PsMes




IF LnMes < 12
   LdFchFin=CTOD("01/"+STR(LnMes+1,2,0)+"/"+STR(LnAAAA,4,0))-1
ELSE
   LdFchFin=CTOD("31/12/"+STR(LnAAAA,4,0))
ENDIF
PsAAAA_Ant		= TRANSFORM(VAL(PsAAAA)-1,"@L ####")
LnMesAnt		= IIF(LnMes>1,LnMes-1,12)
PsAAAAMM_Ant	= IIF(LnMes>1,PsAAAA+TRANSFORM(LnMesAnt,'@L ##'),PsAAAA_Ant+"12")

LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','VTAVPEDI','VPED','VPED01','')
LoDatAdm.abrirtabla('ABRIR','ALMCTRAN','CTRA','CTRA01','')
LoDatAdm.abrirtabla('ABRIR','CCBRGDOC','GDOC','GDOC01','')
LoDatAdm.abrirtabla('ABRIR','VTAVGUIA','GUIA','VGUI01','')
LoDatAdm.abrirtabla('ABRIR','CCBMVTOS','VTOS','VTOS03','')
LoDatAdm.abrirtabla('ABRIR','CBDVMOVM','VMOV','VMOV01','')


IF USED("CurAlma1")
	USE IN CurAlma1
ENDIF
IF USED("CurPedAnt")
	USE IN CurPedAnt
ENDIF
IF USED("CurPedAnt")
	USE IN CurPedAnt
ENDIF
IF USED("CurFact1")
	USE IN CurFact1
ENDIF
IF USED("CurCobr1")
	USE IN CurCobr1
ENDIF

*!*	SELECT  *, MAX(FCHDOC) AS fecha FROM VPED WHERE  DTOS(FCHDOC)=PsAAAAMM_Ant
** VETT:Ultimo registro del periodo anterior 2021/07/16 19:04:30 ** 
SELECT nrodoc,fchdoc,fchcrea  FROM VPED WHERE  DTOS(FCHDOC)=PsAAAAMM_Ant ORDER BY fchdoc DESC TOP 1  INTO CURSOR CurPedAnt  
    
Cancelar = .F.
SELECT *, SPACE(10)  AS LLEGADA,00.00 as min_ped,00.00 as min_alm, ;
		SPACE(LEN(CTRA.TpoRf1)) AS TpoRf1, SPACE(LEN(CTRA.NroRf1)) AS NroRf1 , {//::} As FchGuia ,;
		00.00 AS Min_Fac, SPACE(LEN(GDOC.CodDoc)) AS CodFac, SPACE(LEN(GDOC.NroDoc)) AS NroFac , {//::} As FchFact ,;
		00.00 AS Min_Cobr, {//::} As FchCobr  ;
 		FROM VPED WHERE DTOS(FCHDOC)=PsAAAAMM ORDER BY FchDOC INTO CURSOR CurPedMes READWRITE

LdFch1 = CurPedAnt.FchCrea
LdFch2 = {}
LlPrimera = .T.
SELECT CurPedMes
LOCATE
DO WHILE !Cancelar AND !EOF()
	IF LlPrimera
		LdFch1 = CurPedAnt.FchCrea
		LdFch2	= FchCrea
		replace Llegada WITH HMSDif(LdFch2,LdFch1)
		replace min_ped WITH VAL(SUBSTR(Llegada,AT(":",Llegada)-1))*60+VAL(SUBSTR(Llegada,AT(":",Llegada)+1,AT(":",Llegada,2)-1))
		LlPrimera = .F.
	ELSE
		replace Llegada WITH HMSDif(LdFch2,LdFch1)
		replace min_ped WITH VAL(SUBSTR(Llegada,AT(":",Llegada)-1))*60+VAL(SUBSTR(Llegada,AT(":",Llegada)+1,AT(":",Llegada,2)-1))
	ENDIF
	LdFch1  = FchCrea
	
	** Consulta a almacen **
	SELECT * FROM CTRA WHERE TpoRfb+NroRfb = CurPedMes.CodDoc+CurPedMes.Nrodoc  INTO CURSOR CurAlma1
	SELECT CurPedMes
	IF !EMPTY(CurAlma1.NroRfb)
		LsHMS= HMSDif(CurAlma1.fchhora,FchCrea)
		REPLACE min_alm WITH  VAL(SUBSTR(LsHMS,AT(":",LsHMS)-1))*60+VAL(SUBSTR(LsHMS,AT(":",LsHMS)+1,AT(":",LsHMS,2)-1))
		replace FchGuia WITH CurAlma1.fchhora
		replace TpoRf1 WITH CurAlma1.TpoRf1
		replace NroRf1 WITH CurAlma1.NroRf1
	ENDIF
	** Consulta a Facturación **
	SELECT CODFAC,NROFAC,GDOC.FchCrea FROM GUIA ;
	INNER JOIN GDOC ON GDOC.CODDOC+GDOC.NRODOC=GUIA.CODFAC+GUIA.NROFAC;
	WHERE GUIA.CODDOC+GUIA.NRODOC = CurPedMes.TpoRf1+CurPedMes.NroRf1 ;  
	INTO CURSOR CurFact1
	
	SELECT CurPedMes
	IF !EMPTY(CurFact1.NroFac)
		LsHMS= HMSDif(CurFact1.fchCrea,FchGuia)
		REPLACE min_fac WITH  VAL(SUBSTR(LsHMS,AT(":",LsHMS)-1))*60+VAL(SUBSTR(LsHMS,AT(":",LsHMS)+1,AT(":",LsHMS,2)-1))
		replace FchFact WITH CurFact1.fchCrea
		replace CODFAC WITH CurFact1.CodFac
		replace NroFAC WITH CurFact1.NroFac
	ENDIF
	** Consulta Cobranza **
	SELECT VTOS.CodREF,VTOS.NroRef, CTOT(DTOC(VMOV.FCHDIG)+" "+VMOV.HORDIG) AS FchCobr FROM VTOS ; 
			INNER JOIN VMOV ON VMOV.NROMES+VMOV.CODOPE+VMOV.NROAST=VTOS.NROMES+VTOS.CODOPE+VTOS.NROAST ; 
			WHERE  VTOS.CodREF+VTOS.NroRef = CurFact1.CodFac+CurFact1.NroFac INTO CURSOR CurCobr1
	
	SELECT CurPedMes
	IF !EMPTY(CurCobr1.Nroref)
		LsHMS= HMSDif(CurCobr1.FchCobr,CurPedMes.FchFact)
		REPLACE min_Cobr WITH  VAL(SUBSTR(LsHMS,AT(":",LsHMS)-1))*60+VAL(SUBSTR(LsHMS,AT(":",LsHMS)+1,AT(":",LsHMS,2)-1))
		replace FchCobr WITH CurCobr1.fchCobr
*!*			replace CODCobr WITH CurFact1.CodRef
*!*			replace NroCobr WITH CurFact1.NroRef
	ENDIF	

	SKIP
	LdFch2	= FchCrea
	Cancelar = ( INKEY() = k_esc )
ENDDO

RELEASE LoDatAdm
RETURN 
****************************************
Function HMSDif (tDateTime1, tDateTime2)
****************************************
Local cRet, nS
cRet = ""
If! Vartype(tDateTime1)= "T" Or !Vartype(tDateTime2)= "T"
    cRet = "E"
Endif
If Empty(cRet)
    If tDateTime2 > tDateTime1
        nS = tDateTime2 - tDateTime1
	Else
        nS = tDateTime1 - tDateTime2
    Endif
    nS = Int(nS)
    cTime = Transform(Int(nS/3600),"9999")+":"+ ;
    Transform(Mod(Int(nS/60),60),"99")+":"+ ;
    Transform(Mod(nS,60)," 99")
    
	Return cTime
Else
    =Messagebox("Los valores deben ser DateTime")
    Return ""
Endif
ENDFUNC 