CLEAR 
SET DEVICE TO print
SET PRINTER TO  c:\temp\difcmb200710413.txt additive
SUM IIF(tpomov='D',Import,0),IIF(tpomov='H',Import,0) TO Debe,Haber FOR  nromes>='00' AND nromes<='01'
SUM IIF(tpomov='D',Impusa,0),IIF(tpomov='H',Impusa,0) TO Debe2,Haber2 FOR nromes>='00' AND nromes<='01'
?debe,haber, debe-haber
?debe2,haber2, debe2-haber2
?(debe-haber)/( debe2-haber2), "DIF.CMB ENE:",ROUND((debe2-haber2)*IIF(SEEK('20070131','TCMB'),tcmb.OfiCmp,0),2) - (Debe - Haber) , 'T.C:'+STR(TCMB.OfiCmp,6,4)
?REPLICATE('-',80)
SUM IIF(tpomov='D',Import,0),IIF(tpomov='H',Import,0) TO Debe,Haber FOR  nromes>='00' AND nromes<='02'
SUM IIF(tpomov='D',Impusa,0),IIF(tpomov='H',Impusa,0) TO Debe2,Haber2 FOR nromes>='00' AND nromes<='02'
?debe,haber, debe-haber
?debe2,haber2, debe2-haber2
?(debe-haber)/( debe2-haber2), "DIF.CMB FEB:",ROUND((debe2-haber2)*IIF(SEEK('20070228','TCMB'),tcmb.OfiCmp,0),2) - (Debe - Haber) , 'T.C:'+STR(TCMB.OfiCmp,6,4)
?REPLICATE('-',80)
SUM IIF(tpomov='D',Import,0),IIF(tpomov='H',Import,0) TO Debe,Haber FOR  nromes>='00' AND nromes<='03'
SUM IIF(tpomov='D',Impusa,0),IIF(tpomov='H',Impusa,0) TO Debe2,Haber2 FOR nromes>='00' AND nromes<='03'
?debe,haber, debe-haber
?debe2,haber2, debe2-haber2
?(debe-haber)/( debe2-haber2), "DIF.CMB MAR:",ROUND((debe2-haber2)*IIF(SEEK('20070331','TCMB'),tcmb.OfiCmp,0),2) - (Debe - Haber) , 'T.C:'+STR(TCMB.OfiCmp,6,4)
?REPLICATE('-',80)
SUM IIF(tpomov='D',Import,0),IIF(tpomov='H',Import,0) TO Debe,Haber FOR  nromes>='00' AND nromes<='04'
SUM IIF(tpomov='D',Impusa,0),IIF(tpomov='H',Impusa,0) TO Debe2,Haber2 FOR nromes>='00' AND nromes<='04'
?debe,haber, debe-haber
?debe2,haber2, debe2-haber2
?(debe-haber)/( debe2-haber2), "DIF.CMB ABR:",ROUND((debe2-haber2)*IIF(SEEK('20070430','TCMB'),tcmb.OfiCmp,0),2) - (Debe - Haber) , 'T.C:'+STR(TCMB.OfiCmp,6,4)
?REPLICATE('-',80)
SUM IIF(tpomov='D',Import,0),IIF(tpomov='H',Import,0) TO Debe,Haber FOR  nromes>='00' AND nromes<='05'
SUM IIF(tpomov='D',Impusa,0),IIF(tpomov='H',Impusa,0) TO Debe2,Haber2 FOR nromes>='00' AND nromes<='05'
?debe,haber, debe-haber
?debe2,haber2, debe2-haber2
?(debe-haber)/( debe2-haber2), "DIF.CMB MAY:",ROUND((debe2-haber2)*IIF(SEEK('20070531','TCMB'),tcmb.OfiCmp,0),2) - (Debe - Haber) , 'T.C:'+STR(TCMB.OfiCmp,6,4)
?REPLICATE('-',80)
SUM IIF(tpomov='D',Import,0),IIF(tpomov='H',Import,0) TO Debe,Haber FOR  nromes>='00' AND nromes<='06'
SUM IIF(tpomov='D',Impusa,0),IIF(tpomov='H',Impusa,0) TO Debe2,Haber2 FOR nromes>='00' AND nromes<='06'
?debe,haber, debe-haber
?debe2,haber2, debe2-haber2
?(debe-haber)/( debe2-haber2), "DIF.CMB JUN:",ROUND((debe2-haber2)*IIF(SEEK('20070630','TCMB'),tcmb.OfiCmp,0),2) - (Debe - Haber) , 'T.C:'+STR(TCMB.OfiCmp,6,4)
?REPLICATE('-',80)
SUM IIF(tpomov='D',Import,0),IIF(tpomov='H',Import,0) TO Debe,Haber FOR  nromes>='00' AND nromes<='07'
SUM IIF(tpomov='D',Impusa,0),IIF(tpomov='H',Impusa,0) TO Debe2,Haber2 FOR nromes>='00' AND nromes<='07'
?debe,haber, debe-haber
?debe2,haber2, debe2-haber2
?(debe-haber)/( debe2-haber2), "DIF.CMB JUL:",ROUND((debe2-haber2)*IIF(SEEK('20070731','TCMB'),tcmb.OfiCmp,0),2) - (Debe - Haber) , 'T.C:'+STR(TCMB.OfiCmp,6,4)
?REPLICATE('-',80)
SUM IIF(tpomov='D',Import,0),IIF(tpomov='H',Import,0) TO Debe,Haber FOR  nromes>='00' AND nromes<='08'
SUM IIF(tpomov='D',Impusa,0),IIF(tpomov='H',Impusa,0) TO Debe2,Haber2 FOR nromes>='00' AND nromes<='08'
?debe,haber, debe-haber
?debe2,haber2, debe2-haber2
?(debe-haber)/( debe2-haber2), "DIF.CMB AGO:",ROUND((debe2-haber2)*IIF(SEEK('20070831','TCMB'),tcmb.OfiCmp,0),2) - (Debe - Haber) , 'T.C:'+STR(TCMB.OfiCmp,6,4)
?REPLICATE('-',80)
SUM IIF(tpomov='D',Import,0),IIF(tpomov='H',Import,0) TO Debe,Haber FOR  nromes>='00' AND nromes<='09'
SUM IIF(tpomov='D',Impusa,0),IIF(tpomov='H',Impusa,0) TO Debe2,Haber2 FOR nromes>='00' AND nromes<='09'
?debe,haber, debe-haber
?debe2,haber2, debe2-haber2
?(debe-haber)/( debe2-haber2), "DIF.CMB SET:",ROUND((debe2-haber2)*IIF(SEEK('20070930','TCMB'),tcmb.OfiCmp,0),2) - (Debe - Haber) , 'T.C:'+STR(TCMB.OfiCmp,6,4)
?REPLICATE('-',80)
SUM IIF(tpomov='D',Import,0),IIF(tpomov='H',Import,0) TO Debe,Haber FOR  nromes>='00' AND nromes<='10'
SUM IIF(tpomov='D',Impusa,0),IIF(tpomov='H',Impusa,0) TO Debe2,Haber2 FOR nromes>='00' AND nromes<='10'
?debe,haber, debe-haber
?debe2,haber2, debe2-haber2
?(debe-haber)/( debe2-haber2), "DIF.CMB OCT:",ROUND((debe2-haber2)*IIF(SEEK('20071031','TCMB'),tcmb.OfiCmp,0),2) - (Debe - Haber) , 'T.C:'+STR(TCMB.OfiCmp,6,4)
?REPLICATE('-',80)
SUM IIF(tpomov='D',Import,0),IIF(tpomov='H',Import,0) TO Debe,Haber FOR  nromes>='11' AND nromes<='11'
SUM IIF(tpomov='D',Impusa,0),IIF(tpomov='H',Impusa,0) TO Debe2,Haber2 FOR nromes>='11' AND nromes<='11'
?debe,haber, debe-haber
?debe2,haber2, debe2-haber2
?(debe-haber)/( debe2-haber2), "DIF.CMB NOV:",ROUND((debe2-haber2)*IIF(SEEK('20071130','TCMB'),tcmb.OfiCmp,0),2) - (Debe - Haber) , 'T.C:'+STR(TCMB.OfiCmp,6,4)
?REPLICATE('-',80)
SUM IIF(tpomov='D',Import,0),IIF(tpomov='H',Import,0) TO Debe,Haber FOR  nromes>='12' AND nromes<='12'
SUM IIF(tpomov='D',Impusa,0),IIF(tpomov='H',Impusa,0) TO Debe2,Haber2 FOR nromes>='12' AND nromes<='12'
?debe,haber, debe-haber
?debe2,haber2, debe2-haber2
?(debe-haber)/( debe2-haber2), "DIF.CMB DIC:",ROUND((debe2-haber2)*IIF(SEEK('20071231','TCMB'),tcmb.OfiCmp,0),2) - (Debe - Haber) , 'T.C:'+STR(TCMB.OfiCmp,6,4)
SET PRINTER to
SET DEVICE TO screen
