XnMes = _Mes
XNMes2 = _Mes
XiCodMon = 1
SELECT Temporal
LOCATE

SET PROCEDURE TO RepExpFl,RepEnhance,FrxExp_proc,prcgrl,prcgrl2 additive
SET LIBRARY TO foxtools.fll additive
m.lcfrxfilename = "o:\o-negocios\idc\repcbd_libro_mayor_auxiliar_CAUCHO.FRX"
m.lcfilename = 'C:\Users\Victor\Documents\IDC\LMA-MAR-2018-B.XLS'
lctofiletype = "XL5_97"
llxlsformat = .T.
LsReptDesc  = 'Libro Mayor Auxiliar Marzo 2018'

lnret = repexpfl(m.lcfrxfilename, "", @m.lcfilename, m.lctofiletype, .f., 3, .F., m.llxlsformat, m.llxlsformat, m.llxlsformat, m.llxlsformat, .F., "", LsReptDesc, 5)