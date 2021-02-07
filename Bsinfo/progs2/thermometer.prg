USE cCtclien
COUNT TO lnMaxTermo FOR codven = "10"
@ 0, 1 SAY "...10...20...30...40...50...60...70...80...90...100"
lnContTermo = 0

SCAN FOR codven = "10"
    lnConInter = Thermomether (lnContTermo, lnMaxTermo)
*    REPLACE Name WITH "XXXX"
    lnContTermo = lnConInter
ENDSCAN

FUNCTION Thermomether (pnContTermo, pnMaxTermo)
   pnContTermo = pnContTermo + 1
   @ 1, 1 SAY REPLICATE (CHR (0), (pnContTermo / pnMaxTermo) * 60)
RETURN pnContTermo