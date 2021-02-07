parameter CO
IF PARAMETERS()<1
	RETURN 
ENDIF
*!*	SELECT 0
*!*	USE h:\clientes\quimica\cia006\almmmatg
SELECT 0
USE h:\clientes\quimica\cia006\c2006\almrmovm  order rmov02 SHARED 
IF EMPTY(CO)
	RETURN
ENDIF

lcSql="select iif(tipmov='I','Ingresos','Salidas'),codmov,nrodoc,nompro,fchdoc,nrorf1,candes,cospro,stkact,subalm,tipmov from almrmovm where codmat=co into cursor cdetalle order by fchdoc"
&LcSql.



SELECT cdetalle
LsFile='c:\temp\KARDEX_'+co 
BROWSE 
COPY TO (LsFile) TYPE XLS
USE IN cdetalle
CLOSE TABLES all
