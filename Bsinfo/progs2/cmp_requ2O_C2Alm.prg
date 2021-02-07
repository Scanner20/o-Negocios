CLOSE TABLES ALL
goentorno.open_dbf1('ABRIR','CMPCO_CG','CO_C','CO_C01','')
goentorno.open_dbf1('ABRIR','CMPDO_CG','DO_C','DO_C01','')
goentorno.open_dbf1('ABRIR','ALMCATAL','CATA','CATA02','')
goentorno.open_dbf1('ABRIR','ALMCATGE','CATG','CATG01','')
goentorno.open_dbf1('ABRIR','ALMTGSIS','GSIS','TABL01','')
goentorno.open_dbf1('ABRIR','CMPCREQU','CREQ','CREQ03','') 
goentorno.open_dbf1('ABRIR','ALMDTRAN','DTRA','DTRA04','')
goentorno.open_dbf1('ABRIR','ALMCTRAN','CTRA','CTRA01','')

SELECT CO_C
SET RELATION TO CO_C.nroord INTO DO_C ADDITIVE
SELECT DO_C
SET RELATION TO DO_C.nroreq INTO CREQ ADDITIVE
SET RELATION TO 'O_CM'+DO_C.NroOrd INTO DTRA ADDITIVE

SELECT CO_C
SET FILTER TO flgest='E'
