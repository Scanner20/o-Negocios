PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 
*!*	Aperturamos tablas
LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','CBDMCTAS','CTAS','CTAS01','')
LoDatAdm.abrirtabla('ABRIR','CBDMTABL','TABL','TABL01','')
LoDatAdm.abrirtabla('ABRIR','CBDMAUXI','AUXI','AUXI01','')
LoDatAdm.abrirtabla('ABRIR','CJATPROV','PROV','PROV01','')
LoDatAdm.abrirtabla('ABRIR','CBDVMOVM','VMOV','VMOV01','')
LoDatAdm.abrirtabla('ABRIR','CBDRMOVM','RMOV','RMOV06','')
LoDatAdm.abrirtabla('ABRIR','ADMMTCMB','TCMB','TCMB01','')
*STORE '' TO vDatos,vCdCta,vCodCta,vMovDoc,XsCodAux
*XdFchVto = {}
STORE 0 TO XiForma &&,NumEle,NumCta,ZiOpcion
*!*	LfSalAct1 = 0.00
*!*	LfSalAct2 = 0.00
SET PROCEDURE TO cja_cjaccpag_1.prg ADDITIVE 
LsNroAst = SPACE(10)
ZiOpcion = 3
DO FORM cja_cjaccpag2 TO LsNroAst
WAIT WINDOW LsNroAst
SET PROCEDURE TO 
SET PROCEDURE TO janesoft,fxgen_2
