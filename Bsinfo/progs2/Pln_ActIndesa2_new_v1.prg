PARAMETERS PsRutaCIAOrig,PsRutaAAAAOrig,PsRutaCiaDest,PsRutaAAAADest 
*!*	PsrutaCiaOrig="O:\o-negocios\indesa\data\cia001"
*!*	PsRutaAAAAOrig="O:\o-negocios\indesa\data\P0012023"


**JUSTPATH(DBF())
**LsRutaDestDBF=JUSTPATH(DBF())
*!*	PsRutaCiaDest="O:\o-negocios\queirolo\data\cia001"
*!*	PsRutaAAAADest="O:\o-negocios\queirolo\data\P0012024"
LsDBCCIADest  = JUSTFNAME(PsRutaCiaDest)
LsRutaAAAADest = ADDBS(PsRutaCiaDest)+"C"+RIGHT(JUSTFNAME(PsRutaAAAADest),4)
LsDBCAAAADest =  JUSTFNAME(PsRutaAAAADest)

OPEN DATABASE &PsRutaCiaDest
REMOVE TABLE plnarafp DELETE
REMOVE TABLE plnbanco DELETE
REMOVE TABLE plnbancr DELETE
REMOVE TABLE plncofg0 DELETE
REMOVE TABLE plncoope DELETE
REMOVE TABLE plndjtf1 DELETE
REMOVE TABLE plndjtf2 DELETE
REMOVE TABLE plnmpcts DELETE
REMOVE TABLE plnmtabl DELETE


OPEN DATABASE &PsrutaCiaOrig
SELECT 0
USE plnarafp
COPY TO ADDBS(PsRutaCiaDest)+"plnarafp.dbf" WITH CDX DATABASE &LsDBCCIADest
USE IN plnarafp
 
SELECT 0
USE plnbanco
COPY TO ADDBS(PsRutaCiaDest)+"plnbanco.dbf" WITH CDX DATABASE &LsDBCCIADest
USE IN plnbanco

SELECT 0
USE plnbancr
COPY TO ADDBS(PsRutaCiaDest)+"plnbancr.dbf" WITH CDX DATABASE &LsDBCCIADest
USE IN plnbancr

SELECT 0
USE plncofg0
COPY TO ADDBS(PsRutaCiaDest)+"plncofg0.dbf" WITH CDX DATABASE &LsDBCCIADest
USE IN plncofg0

SELECT 0
USE plncoope
COPY TO ADDBS(PsRutaCiaDest)+"plncoope.dbf" WITH CDX DATABASE &LsDBCCIADest
USE IN plncoope

SELECT 0
USE plndjtf1
COPY TO ADDBS(PsRutaCiaDest)+"plndjtf1.dbf" WITH CDX DATABASE &LsDBCCIADest
USE IN plndjtf1

SELECT 0
USE plndjtf2
COPY TO ADDBS(PsRutaCiaDest)+"plndjtf2.dbf" WITH CDX DATABASE &LsDBCCIADest
USE IN plndjtf2

SELECT 0
USE plnmpcts
COPY TO ADDBS(PsRutaCiaDest)+"plnmpcts.dbf" WITH CDX DATABASE &LsDBCCIADest
USE IN plnmpcts

SELECT 0
USE plnmtabl
COPY TO ADDBS(PsRutaCiaDest)+"plnmtabl.dbf" WITH CDX DATABASE &LsDBCCIADest
USE IN plnmtabl

USE cia001! IN 0



OPEN DATABASE  &PsRutaAAAAOrig

COPY TO ADDBS(LsRutaAAAADest)+"PLNANLAB.DBF" WITH CDX DATABASE &LsDBCAAAADest

DIMENSION aDBFPLN(100)
STORE "" TO aDBFPLN
aDBFPLN(01)="PER:PLNANLAB.DBF" 
aDBFPLN(02)="PER:PLNBLP11.DBF"    
aDBFPLN(03)="PER:PLNBLP22.DBF"                   
aDBFPLN(04)="PER:PLNBLP33.DBF"                                   
aDBFPLN(05)="PER:PLNBLP44.DBF"                                     
aDBFPLN(06)="PER:PLNBLP55.DBF"                                              
aDBFPLN(07)="PER:PLNBLPG1.DBF"                                             
aDBFPLN(08)="PER:PLNBLPG2.DBF"                                            
aDBFPLN(99)="PER:PLNBLPG3.DBF"                                           
aDBFPLN(10)="PER:PLNBLPG4.DBF"                                                
aDBFPLN(11)="PER:PLNBLPG5.DBF"                                                 
aDBFPLN(12)="PER:PLNCFGP1.DBF"                                                 
aDBFPLN(13)="PER:PLNCFGP2.DBF"                                                 
aDBFPLN(14)="PER:PLNCFGP3.DBF"                                                 
aDBFPLN(15)="PER:PLNCFGP4.DBF"                                                 
aDBFPLN(16)="PER:PLNCFGP5.DBF"                                                 
aDBFPLN(17)="PER:PLNDCCTE.DBF"                                                  
aDBFPLN(18)="PER:PLNDECTS.DBF"                                                
aDBFPLN(19)="PER:PLNDJUDI.DBF"                                                
aDBFPLN(20)="PER:PLNDMOVT.DBF"                                              
aDBFPLN(21)="PER:PLNDZAPE.DBF"                                              
aDBFPLN(22)="PER:PLNDZOPE.DBF"                                              
aDBFPLN(23)="PER:PLNEMOVT.DBF"                                              
aDBFPLN(24)="PER:PLNESPRO.DBF"                                              
aDBFPLN(25)="PER:PLNESTAB.DBF"                                              
aDBFPLN(26)="PER:PLNHORAS.DBF"                                              
aDBFPLN(27)="PER:PLNMASIT.DBF"                                              
aDBFPLN(28)="PER:PLNMPDER.DBF"                                              
aDBFPLN(29)="PER:PLNMPERS.DBF"                                              
aDBFPLN(30)="PER:PLNMTQUI.DBF"                                                 
aDBFPLN(31)="PER:PLNMTSEM.DBF"                                                 
aDBFPLN(32)="PER:PLNPEPER.DBF"                                                  
aDBFPLN(33)="PER:PLNPERIO.DBF"                                                 
aDBFPLN(34)="PER:PLNTDIAS.DBF"                                                
aDBFPLN(35)="PER:PLNTMOV1.DBF"                                               
aDBFPLN(36)="PER:PLNTMOV2.DBF"                                                 
aDBFPLN(37)="PER:PLNTMOV3.DBF"                                                 
aDBFPLN(38)="PER:PLNTMOV4.DBF"                                               
aDBFPLN(39)="PER:PLNTMOV5.DBF"                                             
aDBFPLN(40)="PER:PLNTPERI.DBF"                                                
aDBFPLN(41)="PER:PLNTTCMB.DBF"                                                
aDBFPLN(42)="PER:PLNTURNO.DBF"
aDBFPLN(43)="CIA:plnarafp.DBF"
aDBFPLN(44)="CIA:plnbanco.DBF"
aDBFPLN(45)="CIA:plnbancr.DBF"
aDBFPLN(46)="CIA:plncofg0.DBF"
aDBFPLN(47)="CIA:plncoope.DBF"
aDBFPLN(48)="CIA:plndjtf1.DBF"
aDBFPLN(49)="CIA:plndjtf2.DBF"
aDBFPLN(50)="CIA:plnmpcts.DBF"
aDBFPLN(51)="CIA:plnmtabl.DBF"                                                
