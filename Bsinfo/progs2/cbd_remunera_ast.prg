
goentorno.open_dbf1('ABRIR','ADMMTCMB','TCMB','TCMB01','')
goentorno.open_dbf1('ABRIR','CBDMAUXI','PROV','AUXI01','')
goentorno.open_dbf1('ABRIR','CBDVMOVM','VMOV','VMOV01','')
goentorno.open_dbf1('ABRIR','CBDRMOVM','RMOV','RMOV01','')
goentorno.open_dbf1('ABRIR','CBDTOPER','OPER','OPER01','')
lReturnOk=goentorno.open_dbf1('ABRIR','CBDTCIER','CIER','','')

XsNoMes_1 = '10'
XsNoMes_2 = '11'

XsCdOpe_Origen = '006'
XsCdOpe_Destino= '006'

XsNoAst_1 = '10010831'
XsNoAst_2 = ''

XsNoAst_A = '10010899'
LnAst_New = VAL(XsNoAst_A)
TsCodDiv1 = '01'

** Seleccionamos el periodo contable y operación a procesar
DO FORM Cbd_Reclasifica_Numero_Asientos.scx	
 

******************
PROCEDURE PROCESAR
******************
** Cerramos el mes a Procesar **
SELECT CIER
RegAct = _Mes + 1
IF RegAct <= RECCOUNT()
   GOTO RegAct
   m.Cierre = Cierre
ELSE
   DO WHILE !RECCOUNT()=RegAct
        APPEND BLANK
   ENDDO
   m.cierre  = .F.
ENDIF
*
YaestaCerrado = .F.
IF !m.Cierre
	SELE CIER
	REPLACE CIERRE WITH .T.
ELSE
	** Ya esta cerrado **	
	YaEstaCerrado = .T.
ENDIF

** Mes a Procesar ** 
XsMesPro = TRANSFORM(_Mes,'@L 99')
** Ultimo numero de asiento del mes anterior ** 
IF XnTipoCor=1
	=SEEK(XsCdOpe_Origen ,'OPER')
	iNroDoc = 1
	LnLen_ID = OPER.Len_ID
	LnLen_ID_CORR = LnLen_ID - IIF(gocfgcbd.tIPO_CONSO=2 and .F.,2,0) - IIF(OPER.Origen,2,0)
	LsPict = "@L "+REPLICATE("#",LnLen_ID)
	LsCadPref=IIF(gocfgcbd.tIPO_CONSO=2 and .F.,TsCodDiv1,'')
	LsCadPref=IIF(OPER.ORIGEN,LsCadPref+XsNroMes,LsCadPref)
	iNroDoc = VAL(LsCadPref+RIGHT(TRANSF(iNroDoc,LsPict),LnLen_ID_CORR))
	 LnNroAst=VAL(RIGHT(repli("0",LnLen_ID) + LTRIM(STR(iNroDoc)), LnLen_ID))
	
ELSE
	XsMesAnt = TRANSFORM(VAL(XsMesPro) - 1,"@L 99")
	SELECT RIGHT(MAX(nroast),6) as NroAst FROM VMOV ; 
	WHERE Nromes+codope=XsMesAnt+XsCdOpe_Origen ; 
	GROUP BY nromes,codope INTO CURSOR UltimoAst
	** 
	IF EMPTY(UltimoAst.NroAst)
		** Cogemos el correlativo de inicio del maestro de operaciones contables	
		SELECT OPER
		SEEK XsCdOpe_Origen
		LsCmpMes = 'NDOC'+XsMesAnt
		LnNroAst = VAL(RIGHT(TRANSFORM(EVALUATE(LsCmpMes),'@L 99999999'),6))
	ELSE
		LnNroAst = VAL(UltimoAst.NroAst) + 1
	ENDIF
ENDIF
**
SELECT VMOV
SET ORDER TO VMOV03   && NROMES+CODOPE+DTOC(FCHAST,1)+NROAST 
SEEK XsMesPro+XsCdOpe_Origen
COPY TO ARRAY vAsientos FIELDS NroMes,CodOpe,NroAst ,NroVou WHILE NroMes+CodOpe = XsMesPro+XsCdOpe_Origen
SET ORDER TO VMOV01   && NROMES+CODOPE+NROAST 
DIMENSION vRepetido(1,2)
STORE '' TO vRepetido
nRep = 0
FOR K = 1 TO ALEN(vAsientos,1)
	IF LEFT(vAsientos(K,4),1)=CHR(251) && Ya NO se procesa 
	ELSE
		LsLlave = vAsientos(k,1)+vAsientos(k,2)+vAsientos(k,3)
		IF XnTipoCor=1
			LsNewAst = TRANSFORM(LnNroAst,'@L 99999999')
		ELSE
			LsNewAst = XsMesPro+TRANSFORM(LnNroAst,'@L 999999')
		ENDIF
	
		** Que hacemos si el nuevo numero de asiento a colocar ya esta utilizado **
		** Ahhhh!!! , que burros...
		SELECT VMOV
		SEEK vAsientos(k,1)+vAsientos(k,2)+LsNEwAst
		IF FOUND()
			IF SEEK(LsNewAst,'RMOV')
				nRep = nRep + 1
				IF ALEN(vRepetido,1)<nRep
					DIMENSION vRepetido(nRep,1)	
				ENDIF
				vRepetido(nRep,2) = LsNewAst			
			ENDIF
		ENDIF
		**
		SELECT VMOV
		SET FILTER TO NOT (NroAst=vAsientos(k,3) AND NroVou=CHR(251))
		LsLlave = vAsientos(k,1)+vAsientos(k,2)+vAsientos(k,3)
		SEEK LsLlave
		IF FOUND()
			SELECT RMOV
			SET FILTER TO NOT NumOri=CHR(251)+CHR(251) 
			SEEK LsLlave
			DO WHILE NroMes+CodOpe+NroAst = LsLlave
				** Cambiamos al nuevo numero
				REPLACE NroAst WITH LsNewAst 
				WAIT WINDOW LsNewAst NOWAIT 
				** Guardamos el asiento original 
				REPLACE NumOri WITH CHR(251)+CHR(251)+vAsientos(k,3) 
				SEEK LsLlave
			ENDDO
			SELECT RMOV
			SET FILTER TO 
			SELECT VMOV
			REPLACE NroAst WITH LsNewAst , NroVou WITH CHR(251)+vAsientos(k,3)
			LnNroAst = LnNroAst + 1
			SET FILTER TO 
		ENDIF
	ENDIF
ENDFOR
** Actualizamos correlativo para el proximo MES  
SELECT OPER
IF XnTipoCor = 1
	SEEK XsCdOpe_Origen
	LsCmpMes = 'NDOC'+XsMesPro
	=RLOCK()
	REPLACE  (LsCmpMes) WITH  LnNroAst 
ELSE
	XsNewMes = TRANSFORM(VAL(XsMesPro)+ 1,'@L 99')
	SEEK XsCdOpe_Origen
	LsCmpMes = 'NDOC'+XsNewMes
	=RLOCK()
	REPLACE  (LsCmpMes) WITH  LnNroAst 
ENDIF
UNLOCK IN "OPER"
** Re-Abrimos el mes de proceso si es que no estaba cerrado previamente **
IF NOT YaEstaCerrado
	SELE CIER
	REPLACE CIERRE WITH .F.
ENDIF
** 