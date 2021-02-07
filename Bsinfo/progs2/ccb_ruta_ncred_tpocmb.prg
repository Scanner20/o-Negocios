** Ruta tipo de cambio en N/Credito **

**RN1 : Doc. referencia -> XsTpoRef+XsCodRef+XsNroRef
IF XiCodMon=2 AND GDOC.FchDoc<XdFchDoc 
    XfTpoCmb= GDOC.TpoCmb
    @  6,75 GET XfTpoCmb PICT "9,999.9999"
    CLEAR GETS												         	
    XlActTpoCmb = .t.
ENDIF