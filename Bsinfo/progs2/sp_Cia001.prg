FUNCTION Cal_impbrt
m.ImpBrt = ImpBto
IF _triggerlevel =1
endif
replace impbrt WITH m.ImpBrt
RETURN .t.
***************
FUNCTION LEN_Id
***************
PRIVATE LsCurSor
LsCurSor=SYS(2015) 
nSelect = SELECT()
COPY STRUCTURE EXTENDED TO (LsCurSor) FIELDS NRODOC
SELECT 0
USE (LsCursor)
LnLen = field_Len
USE IN (LsCursor)
SELECT(nSelect)
replace Len_Id WITH LnLen
RETURN .t.
*************************
FUNCTION Add_item_maquina
*************************
SCATTER MEMVAR memo
LOCAL LnSelect,LlAbrirtablas,LnLen_Id
LnSelect = SELECT()
LlAbrirTablas = .f.
IF !USED('MTOSECMQ') OR !USED('MTOEQSEC') OR !USED('MTOPXEQU') OR !USED('MTOSPECT') OR !USED('MTOACTIV') OR !USED('MTOPTCMQ') OR !USED('MTOTAREA')
	LOCAL LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\Fpdosvr.vcx" 
	LoDatAdm=CREATEOBJECT('FpDosvr.DataAdmin')
	LlAbrirTablas = .t.
ENDIF	
IF !USED('MTOSECMQ')
	LoDatAdm.abrirtabla('ABRIR','MTOSECMQ','MTOSECMQ','XPKMTOSECM','')
ENDIF
IF !USED('MTOEQSEC')
	LoDatAdm.abrirtabla('ABRIR','MTOEQSEC','MTOEQSEC','XPKMTOEQSE','')
ENDIF
IF !USED('MTOPXEQU')
	LoDatAdm.abrirtabla('ABRIR','MTOPXEQU','MTOPXEQU','XPKMTOPXEQ','')
ENDIF
IF !USED('MTOSPECT')
	LoDatAdm.abrirtabla('ABRIR','MTOSPECT','MTOSPECT','XPKMTOSPEC','')
ENDIF 
IF !USED('MTOACTIV')
	LoDatAdm.abrirtabla('ABRIR','MTOACTIV','MTOACTIV','XPKMTOACTI','')
ENDIF 
IF !USED('MTOPTCMQ')
	LoDatAdm.abrirtabla('ABRIR','MTOPTCMQ','MTOPTCMQ','XPKMTOPTCM','')
ENDIF 
IF !USED('MTOTAREA')
	LoDatAdm.abrirtabla('ABRIR','MTOTAREA','MTOTAREA','XPKMTOTARE','')
ENDIF 


SELECT MTOSECMQ
m.CodSec = '001'
m.DesSec = 'SECCION 1'
m.Cant_Equ = 1
SEEK m.CodCia+m.CodigoTA+m.CodigoTM+m.CodMaq+m.CodSec
IF !FOUND()
	APPEND BLANK
	GATHER MEMVAR 
ENDIF
*
SELECT MTOEQSEC
LnLen_Id = LEN(CodEqu)
LnNroDoc = 1
m.CodEqu = RIGHT(REPLI('0',LnLen_id) + LTRIM(STR(LnNroDoc)), LnLen_id)
m.Desc_Equ = 'EQUIPO 1'
m.CantPartes = 1
SEEK m.CodCia+m.CodigoTA+m.CodigoTM+m.CodMaq+m.CodSec+m.CodEqu
IF !FOUND()
	APPEND BLANK
	GATHER MEMVAR 
ENDIF
*
SELECT MTOPXEQU
LnLen_Id = LEN(CodPar)
LnNroDoc = 1
m.CodPar = RIGHT(REPLI('0',LnLen_id) + LTRIM(STR(LnNroDoc)), LnLen_id)
m.Desc_parte = 'PARTE 1'

SEEK m.CodCia+m.CodigoTA+m.CodigoTM+m.CodMaq+m.CodSec+m.CodEqu+m.CodPar
IF !FOUND()
	APPEND BLANK
	GATHER MEMVAR 
ENDIF
*
SELECT MTOSPECT
LnLen_Id = LEN(Cod_Carac)
LnNroDoc = 1
m.Cod_Carac = RIGHT(REPLI('0',LnLen_id) + LTRIM(STR(LnNroDoc)), LnLen_id)
m.Txt_Carac = 'CARACTERISTICA 1'
SEEK m.CodCia+m.CodigoTA+m.CodigoTM+m.CodMaq+m.CodSec+m.CodEqu+m.CodPar+m.Cod_Carac
IF !FOUND()
	APPEND BLANK
	GATHER MEMVAR 
ENDIF
*
SELECT MTOACTIV
LnLen_Id = LEN(Cod_Activi)
LnNroDoc = 1
m.Cod_Activi = RIGHT(REPLI('0',LnLen_id) + LTRIM(STR(LnNroDoc)), LnLen_id)
m.Des_Act = 'ACTIVIDAD 1'
m.Num_Tareas = 1
SEEK m.CodCia+m.CodigoTA+m.CodigoTM+m.CodMaq+m.CodSec+m.CodEqu+m.CodPar+m.Cod_Activi
IF !FOUND()
	APPEND BLANK
	GATHER MEMVAR 
ENDIF
*
SELECT MTOPTCMQ
LnLen_Id = LEN(Parametro)
LnNroDoc = 1
m.Parametro = RIGHT(REPLI('0',LnLen_id) + LTRIM(STR(LnNroDoc)), LnLen_id)
m.DesPtoCon = 'MANTENIMIENTO DE RUTINA'
m.Num_Tareas = 1
SEEK m.CodCia+m.CodigoTA+m.CodigoTM+m.CodMaq+m.CodSec+m.CodEqu+m.CodPar+m.Parametro
IF !FOUND()
	APPEND BLANK
	GATHER MEMVAR 
ENDIF
*
SELECT MTOTAREA
LnLen_Id = LEN(Cod_Tarea)
LnNroDoc = 1
m.Cod_Tarea = RIGHT(REPLI('0',LnLen_id) + LTRIM(STR(LnNroDoc)), LnLen_id)
m.Desc_Tarea = 'TAREA 1'
SEEK m.CodCia+m.CodigoTA+m.CodigoTM+m.CodMaq+m.CodSec+m.CodEqu+m.CodPar+m.Cod_Activi
IF !FOUND()
	APPEND BLANK
	GATHER MEMVAR 
ENDIF
RELEASE LoDatAdm

SELECT (LnSelect)
****************************
FUNCTION DEL_DETALLE_MAQUINA
****************************
SCATTER MEMVAR
LOCAL LnSelect,LlAbrirtablas,LnLen_Id
LnSelect = SELECT()
LlAbrirTablas = .f.
IF !USED('MTOSECMQ') OR !USED('MTOEQSEC') OR !USED('MTOPXEQU') OR !USED('MTOSPECT') OR !USED('MTOTAREA')
	LOCAL LoDatAdm as dataadmin OF "k:\aplvfp\classgen\vcxs\Fpdosvr.vcx" 
	LoDatAdm=CREATEOBJECT('FpDosvr.DataAdmin')
	LlAbrirTablas = .t.
ENDIF	
IF !USED('MTOSECMQ')
	LoDatAdm.abrirtabla('ABRIR','MTOSECMQ','MTOSECMQ','XPKMTOSECM','')
ENDIF
IF !USED('MTOEQSEC')
	LoDatAdm.abrirtabla('ABRIR','MTOEQSEC','MTOEQSEC','XPKMTOEQSE','')
ENDIF
IF !USED('MTOPXEQU')
	LoDatAdm.abrirtabla('ABRIR','MTOPXEQU','MTOPXEQU','XPKMTOPXEQ','')
ENDIF
IF !USED('MTOSPECT')
	LoDatAdm.abrirtabla('ABRIR','MTOSPECT','MTOSPECT','XPKMTOSPEC','')
ENDIF 
IF !USED('MTOTAREA')
	LoDatAdm.abrirtabla('ABRIR','MTOTAREA','MTOTAREA','XPKMTOTARE','')
ENDIF 

DELETE FROM MTOSECMQ WHERE CodCia+CodigoTA+CodigoTM+CodMaq+CodSec = ; 
							m.CodCia+m.CodigoTA+m.CodigoTM+m.CodMaq
DELETE FROM MTOEQSEC WHERE CodCia+CodigoTA+CodigoTM+CodMaq+CodSec+CodEqu = ; 
							m.CodCia+m.CodigoTA+m.CodigoTM+m.CodMaq
DELETE FROM MTOPXEQU WHERE CodCia+CodigoTA+CodigoTM+CodMaq+CodSec+CodEqu+CodPar = ;
							m.CodCia+m.CodigoTA+m.CodigoTM+m.CodMaq
DELETE FROM MTOACTIV WHERE CodCia+CodigoTA+CodigoTM+CodMaq+CodSec+CodEqu+CodPar+Cod_Activi = ;
							m.CodCia+m.CodigoTA+m.CodigoTM+m.CodMaq
DELETE FROM MTOPTCMQ WHERE CodCia+CodigoTA+CodigoTM+CodMaq+CodSec+CodEqu+CodPar+Parametro = ;
							m.CodCia+m.CodigoTA+m.CodigoTM+m.CodMaq
DELETE FROM MTOSPECT WHERE CodCia+CodigoTA+CodigoTM+CodMaq+CodSec+CodEqu+CodPar+Cod_Carac = ;
							m.CodCia+m.CodigoTA+m.CodigoTM+m.CodMaq

DELETE FROM MTOTAREA WHERE CodCia+CodigoTA+CodigoTM+CodMaq+CodSec+CodEqu+CodPar+Cod_Activi = ;
							m.CodCia+m.CodigoTA+m.CodigoTM+m.CodMaq

RELEASE LoDatAdm

SELECT (LnSelect)

FUNCTION _CDarti
m.CdArti = CodMat
IF _triggerlevel =1
endif
REPLACE CdArti  WITH m.CdArti
RETURN .t.
