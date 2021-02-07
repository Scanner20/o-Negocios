GcTit4 = [LISTA DE PRECIOS]
DO FONDO WITH GcTit1,GcTit2,GcTit3,GcTit4
SELE 0
USE CCBRGDOC ORDER GDOC01

xFOR   = []
xWHILE = []

Largo  = 66       && Largo de pagina
IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN2]

IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN2]
sNomRep = "YULINO"

IniPrn = [_PRN0+_PRN5A+CHR(Largo)+_PRN5B+_PRN3]
DO admprint WITH "REPORTS"
CLOSE DATA
RETURN
************************************************************************ FIN *

