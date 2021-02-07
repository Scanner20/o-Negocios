

XnCodMon = 2
IF !Abrir_Dbfs()
	MESSAGEBOX('Sin conexion a la base de datos',0+16,'ATENCION !!!')	
	RETURN 
ENDIF

** Llamar al formulario y capturar variables para generar el reporte
DO FORM Mto_Materiales_x_Maquina
** 

*******************
FUNCTION Gen_Report
*******************
PARAMETERS LsCdFami, LsCdSufa,LsCodMatD, LsCodMatH,LdFch1,LdFch2,XnCodMon
IF PARAMETERS()<7
	XnCodMon = 1
ENDIF
IF PARAMETERS()<6
	LdFch2 = DATE()
ENDIF
IF PARAMETERS()<5
	LdFch1 = DATE()
ENDIF
IF PARAMETERS()<4
	LsCodMatH = LsCodMatD
ENDIF

*!*	LOCAL LsCodMaqD , LsCodMaqH, LsCodMatD, LsCodMatH, LsCdFami, LsCdSufa AS String
*!*	LOCAL LdFch1,LdFch2 AS Date 
*!*	LOCAL XnCodMon AS Integer
*** Creamos Temporal 
LcArcTmp = GoEntorno.TmpPath+SYS(3)

SELECT 0
CREATE TABLE (LcArcTmp) FREE (	MATERIAL	C(40),;
								Codigo		C(LEN(MTUT.CodMat)),;
								Fecha 		D(8),;
								Numero_OT	C(LEN(CO_T.Num_OrdReq)),;
								Equipo		C(40),;
								Cantidad	N(12,2),;
								UND			C(4),;
								IMPORTE		N(16,2),;
								KEY1		C(20),;
								KEY2		C(20) )

USE (LcArcTmp) ALIAS TEMPO EXCL
INDEX ON key1+key2 TAG pk1


SELECT CO_T
SCAN FOR Fech_ord>=LdFch1 AND Fech_Ord<=LdFch2
	SCATTER MEMVAR 
	LsLLaveOT= m.CodCia+m.CodigoTA+m.CodigoTM+m.CodMaq+m.Num_OrdReq
	SELECT ACTM
	SEEK  m.CodCia+m.CodigoTA+m.CodigoTM+m.CodMaq
	SELECT DO_T	
	SEEK LsLLaveOT
	SCAN WHILE CodCia+CodigoTA+CodigoTM+CodMaq+Num_OrdReq = LsLlaveOT
		LsLLaveMT = CodCia+CodigoTA+CodigoTM+CodMaq+CodSec+CodEqu+CodPar+m.Parametro+Cod_activi+Num_OrdReq
		SELECT MTUT
		SEEK LsLLaveMT
		SCAN WHILE CodCia+CodigoTA+CodigoTM+CodMaq+CodSec+CodEqu+CodPar+Parametro+Cod_activi+Num_OrdReq = LsLLaveMT
			IF EMPTY(LsCdFami) AND EMPTY(LsCdSufa)
				IF  (CodMat>=LsCodMatD AND CodMat<=LsCodMatH )
					** Grabamos detalle **	
					SELECT TEMPO
					APPEND BLANK
					** Campos de la cabecera **
					DO CASE 
						CASE  GsSigCia='DELFINES'
							REPLACE MATERIAL 	WITH  IIF(SEEK(MTUT.CdFami+MTUT.CdSufa+TRIM(MTUT.CodMat),'ARTI'),ARTI.DslArt,'')
						OTHERWISE 
							REPLACE MATERIAL 	WITH  IIF(SEEK(TRIM(MTUT.CodMat),'ARTI'),ARTI.Desmat,'')
					ENDCASE 			
					REPLACE Codigo				WITH  MTUT.CodMat
					** Campos a mostrar en el detalle
					Replace Fecha	  		WITH m.Fech_Ord	
					Replace Numero_OT 		WITH m.Num_OrdReq
					REPLACE Equipo			WITH ACTM.DesMaq   	
					REPLACE Cantidad		WITH MTUT.CANT_Util
					REPLACE Und				WITH IIF(SEEK(TRIM(MTUT.TablaUnd+MTUT.Unidad),'TABL'),TABL.NomBre,'')
					REPLACE Importe			WITH MTUT.Cant_Util*IIF(XnCodMon=1,MTUT.PU_Soles_R,MTUT.PU_Dolar_R)
					
					** Campos que forman la llave para los quiebres
					Replace Key1 WITH Codigo
					REPLACE Key2 WITH 'A'				
					
					SELECT MTUT
				ENDIF													
			
			ELSE
				IF CdFami+CdSufa=LsCdFami+LsCdSufa AND (CodMat>=LsCodMatD AND CodMat<=LsCodMatH )
					** Grabamos detalle **	
					SELECT TEMPO
					APPEND BLANK
					** Campos de la cabecera **
					DO CASE 
						CASE  GsSigCia='DELFINES'
							REPLACE MATERIAL 	WITH  IIF(SEEK(MTUT.CdFami+MTUT.CdSufa+TRIM(MTUT.CodMat),'ARTI'),ARTI.DslArt,'')
						OTHERWISE 
							REPLACE MATERIAL 	WITH  IIF(SEEK(TRIM(MTUT.CodMat),'ARTI'),ARTI.Desmat,'')
					ENDCASE 			
					REPLACE Codigo				WITH  MTUT.CodMat
					** Campos a mostrar en el detalle
					Replace Fecha	  		WITH m.Fech_Ord	
					Replace Numero_OT 		WITH m.Num_OrdReq
					REPLACE Equipo			WITH ACTM.DesMaq   	
					REPLACE Cantidad		WITH MTUT.CANT_Util
					REPLACE Und				WITH IIF(SEEK(TRIM(MTUT.TablaUnd+MTUT.Unidad),'TABL'),TABL.NomBre,'')
					REPLACE Importe			WITH MTUT.Cant_Util*IIF(XnCodMon=1,MTUT.PU_Soles_R,MTUT.PU_Dolar_R)
					
					** Campos que forman la llave para los quiebres
					Replace Key1 WITH Codigo
					REPLACE Key2 WITH 'A'				
					
					SELECT MTUT
				ENDIF													
			ENDIF
		ENDSCAN	
		
		SELECT DO_T	
	ENDSCAN
	SELECT CO_T
ENDSCAN


*******************
FUNCTION Abrir_Dbfs
*******************
LOCAL LoDB as DataAdmin OF k:\aplvfp\classgen\vcxs\FPDosvr.vcx
LoDB = CREATEOBJECT("FPDosvr.DataAdmin")
*
DIMENSION aAlias(10,2)
STORE '' TO aALIAS
LlRetVal = .T.
*

IF !LoDB.AbrirTabla('ABRIR','MTOCRQOC','CO_T','CO_T01','')		
   aALIAS(1,1) = ALIAS()
   aALIAS(1,2) = '*'
ENDIF
*
IF !LoDB.AbrirTabla('ABRIR','MTODRQOC','DO_T','XPKMTODRQO','')
   aALIAS(2,1) = ALIAS()
   aALIAS(2,2) = '*'
ENDIF
*
IF !LoDB.AbrirTabla('ABRIR','MTOMOUTI','MOUT','XPKMTOMOUT','')
   aALIAS(3,1) = ALIAS()
   aALIAS(3,2) = '*'
ENDIF
*
IF !LoDB.AbrirTabla('ABRIR','MTOMTUTI','MTUT','XPKMTOMTUT','')
   aALIAS(4,1) = ALIAS()
   aALIAS(4,2) = '*'
ENDIF
*
IF !LoDB.AbrirTabla('ABRIR','MTOACTIV','ACTI','XPKMTOACTI','')
   aALIAS(5,1) = ALIAS()
   aALIAS(5,2) = '*'
ENDIF
*
IF !LoDB.AbrirTabla('ABRIR','MTOACTMQ','ACTM','XPKMTOACTM','')
   aALIAS(6,1) = ALIAS()
   aALIAS(6,2) = '*'
ENDIF
*
DO CASE 
	CASE INLIST(GsSigCia ,'DELFINES','CEVA')
		IF !LoDB.AbrirTabla('ABRIR','IVMART01','ARTI','A1','')		
		   aALIAS(7,1) = ALIAS()
		   aALIAS(7,2) = '*'
		ENDIF
	OTHERWISE
		IF !LoDB.AbrirTabla('ABRIR','ALMCATGE','ARTI','CATG01','')		
		   aALIAS(7,1) = ALIAS()
		   aALIAS(7,2) = '*'
		ENDIF
ENDCASE
IF !LoDB.AbrirTabla('ABRIR','ALMTGSIS','TABL','TABL01','')		
   aALIAS(8,1) = ALIAS()
   aALIAS(8,2) = '*'
ENDIF
FOR K = 1 TO ALEN(aAlias,1)
	IF aAlias(K,2)='*'
		LlRetVal = .F.
	ENDIF
ENDFOR

IF !LlRetVal
	FOR K = 1 TO ALEN(aAlias,1)
		IF USED(aAlias(K,1))	
			USE IN (aAlias(K,1))
		ENDIF
	ENDFOR
ENDIF

RETURN  LlRetVal





