	
	SELECT CodMat,CodAnt,Desmat,UndStk, ROUND(ICASE(Thisform.cCodIng1='SINIGV',PreVn1,Thisform.cCodIng1='CONIGV',PreVn1/(1+LfPorIgv/100),0),3) AS PMNSinIGV1,;
										ROUND(ICASE(Thisform.cCodIng1='SINIGV',PreVn1*(1+LfPorIgv/100)-PreVn1,Thisform.cCodIng1='CONIGV',PreVn1-PreVn1/(1+LfPorIgv/100),0),3) AS IgvMN1,;
										ROUND(ICASE(Thisform.cCodIng1='SINIGV',PreVn1*(1+LfPorIgv/100),Thisform.cCodIng1='CONIGV',PreVn1,0),3) AS PMNConIgv1,;
										ROUND(ICASE(Thisform.cCodIng2='SINIGV',PreVn2,Thisform.cCodIng2='CONIGV',PreVn2/(1+LfPorIgv/100),0),3) AS PMNSinIGV2,;
										ROUND(ICASE(Thisform.cCodIng2='SINIGV',PreVn2*(1+LfPorIgv/100)-PreVn2,Thisform.cCodIng2='CONIGV',PreVn2-PreVn2/(1+LfPorIgv/100),0),3) AS IgvMN2,;
										ROUND(ICASE(Thisform.cCodIng2='SINIGV',PreVn2*(1+LfPorIgv/100),Thisform.cCodIng2='CONIGV',PreVn2,0),3) AS PMNConIgv2,;
										ROUND(ICASE(Thisform.cCodIng3='SINIGV',PreVn3,Thisform.cCodIng3='CONIGV',PreVn3/(1+LfPorIgv/100),0),3) AS PMNSinIGV3,;
										ROUND(ICASE(Thisform.cCodIng3='SINIGV',PreVn3*(1+LfPorIgv/100)-PreVn3,Thisform.cCodIng3='CONIGV',PreVn3-PreVn3/(1+LfPorIgv/100),0),3) AS IgvMN3,;
										ROUND(ICASE(Thisform.cCodIng3='SINIGV',PreVn3*(1+LfPorIgv/100),Thisform.cCodIng3='CONIGV',PreVn3,0),3) AS PMNConIgv3,;
										ROUND(ICASE(Thisform.cCodIng1='SINIGV',PreVe1,Thisform.cCodIng1='CONIGV',PreVe1/(1+LfPorIgv/100),0),3) AS PMESinIGV1,;
										ROUND(ICASE(Thisform.cCodIng1='SINIGV',PreVe1*(1+LfPorIgv/100)-PreVe1,Thisform.cCodIng1='CONIGV',PreVe1-PreVe1/(1+LfPorIgv/100),0),3) AS IgvME1,;
										ROUND(ICASE(Thisform.cCodIng1='SINIGV',PreVe1*(1+LfPorIgv/100),Thisform.cCodIng1='CONIGV',PreVe1,0),3) AS PMEConIgv1,;
										ROUND(ICASE(Thisform.cCodIng2='SINIGV',PreVe2,Thisform.cCodIng2='CONIGV',PreVe2/(1+LfPorIgv/100),0),3) AS PMESinIGV2,;
										ROUND(ICASE(Thisform.cCodIng2='SINIGV',PreVe2*(1+LfPorIgv/100)-PreVe2,Thisform.cCodIng2='CONIGV',PreVe2-PreVe2/(1+LfPorIgv/100),0),3) AS IgvME2,;
										ROUND(ICASE(Thisform.cCodIng2='SINIGV',PreVe2*(1+LfPorIgv/100),Thisform.cCodIng2='CONIGV',PreVe2,0),3) AS PMEConIgv2,;
										ROUND(ICASE(Thisform.cCodIng3='SINIGV',PreVe3,Thisform.cCodIng3='CONIGV',PreVe3/(1+LfPorIgv/100),0),3) AS PMESinIGV3,;
										ROUND(ICASE(Thisform.cCodIng3='SINIGV',PreVe3*(1+LfPorIgv/100)-PreVe3,Thisform.cCodIng3='CONIGV',PreVe3-PreVe3/(1+LfPorIgv/100),0),3) AS IgvME3,;
										ROUND(ICASE(Thisform.cCodIng3='SINIGV',PreVe3*(1+LfPorIgv/100),Thisform.cCodIng3='CONIGV',PreVe3,0),3) AS PMEConIgv3,;
										 UndStk As UndVta,CAST(0 as numeric(7,2)) AS Cantidad,;
										 CAST(1 AS numeric(5,2) )AS FacEqu,; 
										 CAST( 0.00 AS numeric(8,2)) AS TOTAL,;
										 CAST(0 AS numeric(12,2))  AS ImpLin,.F. AS GenVta,SPACE(1) AS TipPre , 0 AS CodMon, ;
										 PreVe1,PreVe2,PreVe3,PreVn1,PreVn2,PreVn3,CAST(SPACE(3) AS Character(3)) AS SubAlm, ; 
										 CAST(PsCodCli AS Char(11) ) AS CodCli ;
										 FROM (LsRutaCatg)  WHERE EVAL(LsWhere) INTO CURSOR C_CATG READWRITE ORDER BY CodMat
	
CodMat c(LEN(arti.cdarti)),;
DesMat c(LEN(arti.DslArt)),;
CanMat n(8),;
Unidad c(LEN(tabl.Codigo)) )



CREATE TABLE (LcArcTmp) FREE (Quiebre C(5),Quiebre1 C(1),;
FchDoc D ,;
NroOrd C(LEN(crqo.Num_OrdReq)),;
Autor C(LEN(crqo.Autorizado)),;
CodMaq C(LEN(crqo.CodMaq)),;
Tipo C(LEN(crqo.Tip_Man)),;
FchProg D ,;
t01 N(16,2),;
DesMaq C(LEN(ctmq.DesMaq)),;
Ubic_Actua C(LEN(ctmq.Ubic_Actua)),;
Marca C(LEN(ctmq.Marca)),;
Modelo C(LEN(ctmq.Modelo)),;
NoSerie C(LEN(ctmq.NoSerie)),;
Des_Narr C(LEN(crqo.observac)),;
CodAct c(LEN(acti.Cod_Activi)),;
DesAct c(LEN(acti.Des_Act)),;
NroTare n(6,2),;
Especiali_ c(LEN(espe.desc_espe)),;
NomPer c(LEN(pers.NomPer)),;
CodMat c(LEN(arti.cdarti)),;
DesMat c(LEN(arti.DslArt)),;
CanMat n ,;
Unidad c(LEN(tabl.Codigo)) )



#DEFINE PRINTER_ACCESS_ADMINISTER  4 
#DEFINE PRINTER_ACCESS_USE         8 
DO decl 

LOCAL cPrinter, hPrinter, lcPrnDefaults 

cPrinter = GetPrnName()  && default printer 

* PRINTER_DEFAULTS structure 
lcPrnDefaults = Repli(Chr(0),8) +; 
    Chr(PRINTER_ACCESS_ADMINISTER) + Repli(Chr(0),3) 

hPrinter = 0 
IF OpenPrinter(cPrinter, @hPrinter, lcPrnDefaults) = 0 
    ? "Error opening printer [" + cPrinter + "]" 
    RETURN 
ENDIF 

= PrinterProperties(GetActiveWindow(), hPrinter) 
= ClosePrinter(hPrinter) 
* end of main 

FUNCTION GetPrnName 
* returns default printer name from Windows Registry 
    LOCAL lcBuffer, lcPrinter, lcDriver, lcPort 
    lcBuffer = Repli(Chr(0), 120) 
    = GetProfileString("Windows", "Device", ",,,",; 
        @lcBuffer, Len(lcBuffer)) 
    lcBuffer = STRTRAN(lcBuffer, Chr(0), "") 
RETURN SUBSTR(lcBuffer, 1, AT(",", lcBuffer, 1)-1) 

PROCEDURE decl 
    DECLARE INTEGER OpenPrinter IN winspool.drv; 
        STRING pPrinterName, INTEGER @phPrinter, STRING pDefault 

    DECLARE INTEGER GetProfileString IN kernel32; 
        STRING lpApp, STRING lpKey, STRING lpDefault,; 
        STRING @lpReturnedString, INTEGER nSize 

    DECLARE INTEGER ClosePrinter IN winspool.drv INTEGER hPrinter 
    DECLARE INTEGER GetActiveWindow IN user32 

    DECLARE INTEGER PrinterProperties IN winspool.drv; 
        INTEGER hWnd, INTEGER hPrinter 
