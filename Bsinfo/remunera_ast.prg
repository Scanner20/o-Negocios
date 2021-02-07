
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
XsMesAnt = TRANSFORM(VAL(XsMesPro) - 1,"@L 99")
SELECT RIGHT(MAX(nroast),6) as NroAst FROM VMOV ; 
WHERE Nromes+codope=XsMesAnt+XsCdOpe_Origen ; 
GROUP BY nromes,codope INTO CURSOR UltimoAst
** 
LnNroAst = VAL(UltimoAst.NroAst) + 1

**
SELECT VMOV
SET ORDER TO VMOV03   && NROMES+CODOPE+DTOC(FCHAST,1)+NROAST 
SEEK XsMesPro+XsCdOpe_Origen
COPY TO ARRAY vAsientos FIELDS NroMes,CodOpe,NroAst ,NroVou WHILE NroMes+CodOpe = XsMesPro+XsCdOpe_Origen
SET ORDER TO VMOV01   && NROMES+CODOPE+NROAST 

FOR K = 1 TO ALEN(vAsientos,1)
	IF LEFT(vAsientos(K,4),1)=CHR(251) && Ya se procesa 
	ELSE
		LsLlave = vAsientos(k,1)+vAsientos(k,2)+vAsientos(k,3)
		LsNewAst = XsMesPro+TRANSFORM(LnNroAst,'@L 999999')
		SELECT VMOV
		LsLlave = vAsientos(k,1)+vAsientos(k,2)+vAsientos(k,3)
		SEEK LsLlave
		IF FOUND()
			SELECT RMOV
			SEEK LsLlave
			DO WHILE NroMes+CodOpe+NroAst = LsLlave
				** Cambiamos al nuevo numero
				REPLACE NroAst WITH LsNewAst 
				SEEK LsLlave
			ENDDO
			SELECT VMOV
			REPLACE NroAst WITH LsNewAst , NroVou WITH CHR(251)+vAsientos(k,3)
			LnNroAst = LnNroAst + 1
		ENDIF
	ENDIF
ENDFOR
** Actualizamos correlativo para el proximo MES  
SELECT OPER
XsNewMes = TRANSFORM(VAL(XsMesPro)+ 1,'@L 99')
SEEK XsCdOpe_Origen
LsCmpMes = 'NDOC'+XsNewMes
REPLACE  (LsCmpMes) WITH  LnNroAst 

** Re-Abrimos el mes de proceso si es que no estaba cerrado previamente **
IF NOT YaEstaCerrado
	SELE CIER
	REPLACE CIERRE WITH .F.
ENDIF
** 