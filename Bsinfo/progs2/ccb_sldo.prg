PARAMETER _CodCli,_TpoDoc,_CodDoc,_NroDoc,_CodMon,_TpoCmb,_ImpTot,_TstLin,vImporte
PRIVATE LsLLave,NsClave,LfImport
xArea = ALIAS()
STORE 0 TO LfImport,LfImpRet,vImporte

** VETT:Vamos aislando este procedimiento >> ISOLATE 2015/03/30 16:02:49 ** 
IF VARTYPE(LoContab)<>'O'
	LOCAL LoContab as Contabilidad OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
	LoContab = CREATEOBJECT('Dosvr.Contabilidad')
ENDIF
LlUsedVtos=.F.
IF !USED('VTOS')
	lOk=LoContab.odatadm.abrirtabla('ABRIR','CCBMVTOS','VTOS','VTOS01','')
	IF !Lok
		=MESSAGEBOX('No hay acceso a detalle de documentos por cobrar',0+48,'Atención!!')
		RETURN lOk
	ENDIF
ELSE
	LlUsedVTOS=.T.
ENDIF	
** VETT:FIN >> ISOLATE 2015/03/30 16:03:08 ** 

IF _TpoDoc=[CARGO]
   NsClave = [CodCli+CodRef+NroRef]
   LsLlave = _CodCli+_CodDoc+_NroDoc
   SELE VTOS
   SET ORDER TO VTOS05
   SEEK LsLlave
ELSE
   NsClave = [CodDoc+NroDoc]
   LsLlave = _CodDoc+_NroDoc
   SELE VTOS
   SET ORDER TO VTOS01
   SEEK Lsllave
ENDIF
IF _coddoc+_nrodoc='BOLE0010000002'
**	SET STEP ON 
ENDIF
SCAN WHILE &NsClave=LsLLave FOR &_TstLin
    LfImport=LfImport+IIF(_CodMon=CodMon,Import,IIF(CodMon=1, ;
                 IIF(TpoCmb<=0,0,Import/Tpocmb),Import*Tpocmb))
    IF CodDoc='RETC'                                      
		LfImpRet=LfImpRet + IIF(_CodMon=CodMon,Import,IIF(CodMon=1, ;
                 IIF(TpoCmb<=0,0,Import/Tpocmb),Import*_Tpocmb))
    ENDIF
ENDSCAN

IF USED('VTOS') AND !LlUsedVTOS
	USE IN VTOS
ENDIF

SELE &xArea
vImporte(1)=_ImpTot - LfImport
vImporte(2)=LfImpRet
RETURN vImporte
