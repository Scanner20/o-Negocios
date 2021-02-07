** FUNCION   : ctb_aper
** Objeto    : aperturar bases de datos contables y verificar si el
**             mes NO esta cerrado
** Parametro : Dia del movimiento contable a realizar

PARAMETER _FchAst
PRIVATE LsDirCtb,TsPathDbf,TsPathCia,_ANO
_MES       = MONTH(_FchAst)
_ANO       = YEAR(_FchAst)
*!*	TsPathCia  = "cia"+GsCodCia
*!*	TsPathDbf  = PathOrg+";"+PathDef+"\"+TsPathCia+"\c"+LTRIM(STR(_ANO))
*!*	SET PATH TO (TsPathDbf)
* * * *
PUBLIC LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\dosvr.vcx" 

LoDatAdm=CREATEOBJECT('Dosvr.DataAdmin')
LoDatAdm.abrirtabla('ABRIR','CBDTCIER','CBDTCIER','','')

IF !USED('CBDTCIER')
   RETURN .F.
ENDIF
SELECT CBDTCIER  
RegAct = _Mes + 1
Modificar = ! Cierre
IF RegAct <= RECCOUNT()
   GOTO RegAct
   Modificar = ! Cierre
ENDIF
USE   && << OJO <<
*LoDatAdm.Close_file('CCB_CTB') 
IF !Modificar
   GsMsgErr = [Mes Cerrado, no puede ser modificado]
   DO lib_merr WITH 99
   RETURN .F.
ENDIF
* Abrimos bases de datos *
IF !LoDatAdm.Open_File('CTB',STR(_ANO,4,0))
	RELEASE LoDatAdm
	RETURN .F.
ENDIF

RELEASE LoDatAdm
* * * *
RETURN .T.
