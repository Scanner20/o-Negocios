*Precios de Compra segun Ing. almacen 
*close data
*SELE 0
*USE \BASE\ADMMTCMB ORDER TCMB01 ALIAS TCMB
*IF !USED()
*   close data
*   rETURN 
*endif
*SELE 0
*USE ALMCATGE ORDER CATG01 ALIAS CATG
*IF !USED()
*   close data
*   rETURN 
*endif
PUBLIC vtpocmb
dimension vtpocmb(12)
DO FORM cmp_cmpcmbpc
***
*sele catg
*brow field codmat:r,desmat:r,undstk:r,ps01:v=cmb(sys(18))  ,ps02:v=cmb(sys(18)),;
ps03:v=cmb(sys(18)),ps04:v=cmb(sys(18)),ps05:v=cmb(sys(18)),ps06:v=cmb(sys(18)),;
pS07:v=cmb(sys(18)),pS08:v=cmb(sys(18)),pS09:v=cmb(sys(18)),pS10:v=cmb(sys(18)),;
pd01:v=cmb(sys(18)),pd02:v=cmb(sys(18)),pd03:v=cmb(sys(18)),pd04:v=cmb(sys(18)),;
pd05:v=cmb(sys(18)),pd06:v=cmb(sys(18)),pd07:v=cmb(sys(18)),pd08:v=cmb(sys(18)),;
pd09:v=cmb(sys(18)),pd10:v=cmb(sys(18)),;
pS11:v=cmb(sys(18)),pS12:v=cmb(sys(18)),pd01:v=cmb(sys(18)),pd02:v=cmb(sys(18)),;
pd11:v=cmb(sys(18)),pd12:v=cmb(sys(18))
close data
return 
************
function cmb
************
parameter nomcampo
moneda=SUBSTR(UPPER(nomcampo),2,1)
mesact=val(SUBSTR(UPPER(nomcampo),3))
LFVALACT=&NOMCAMPO.
if moneda=[S]
   OTRCMP=[P]+[D]+TRAN(MESACT,[@L ##])
   REPLACE &OTRCMP. WITH round(LfValact/vTpocmb(mesact),4)
ELSE
   OTRCMP=[P]+[S]+TRAN(MESACT,[@L ##])
   REPLACE &OTRCMP. WITH round(LfValact*vTpocmb(mesact),4)
ENDIF
REPLACE MODI WITH .T.
RETURN