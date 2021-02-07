PUBLIC GsClfAux
GsClfAux  = [CLI]       && Depende de la Contabilidad
GsCodMat  = [999]       && Depende de la Contabilidad
GdFecha   = DATE()
PUBLIC GcTit1,GcTit2,GcTit3,GcTit4
RESTORE FROM VTACONFG ADDITIVE
GcTit1 = GsNomCia
GcTit2 = DTOC(DATE())
GcTit3 = [Sist. de Ventas]
GcTit4 = [Usuario:]+alltrim(GsUsuario)
UltTecla  = 0
DO vtamenus
CLOSE DATA
RETURN
*********************************************************************** EOF() *
