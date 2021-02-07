PARAMETERS PsCodOpe,PnMesIni,PnMesFin
SET STEP ON 
IF VARTYPE(PnMesIni)#'N'
	PnMesIni =1
ENDIF
IF VARTYPE(PnMesFin)#'N'
	PnMesFin =12
ENDIF
IF VARTYPE(PsCodOpe)#'C'
	PsCodOpe =""
ENDIF

IF PARAMETERS()=0
	PsCodOpe=''
	PnMesIni=1
	PnMesFin=12
ENDIF
IF PARAMETERS()=1
	PnMesIni = 1
	PnMesFin = 12
ENDIF
IF PARAMETERS()=2
	PnMesFin=PnMesIni
ENDIF


USE p0012007!cbdtoper exclu 
IF !USED()
	=MESSAGEBOX('Este proceso requiere que se accese en forma exclusiva al maestro de operaciones y correlativos contables',48,'ATENCION')
ENDIF
*** Rutina para actualizar correlativos sin contemplar el codigo de la divisionaria ***
SCAN FOR CodOpe=PsCodOpe
	FOR K = PnMesIni TO PnMesFin
		LsMesCorr= 'NDOC'+TRANSFORM(K,"@L ##")
		REPLACE &LsMesCorr. WITH VAL('0000'+SUBSTR(TRANSFORM(&LsMesCorr.,"@L "+REPLICATE('#',Len_id)),5))
	ENDFOR
ENDSCAN