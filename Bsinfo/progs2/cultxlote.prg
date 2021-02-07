select 0
use cpicuxlt order cuxlt01 alias cxlot
select 0
USE CPICULTI ORDER CULT01 ALIAS CULTI
select 0
use cpico_tb order co_t04 alias CO_T
SELECT 0
USE Cpiactiv order acti01 alias Acti
SELECT 0
USE CPIQO_TB ORDER QO_T01 ALIAS QO_T
select 0
use cbdmpart order part01 alias mpart
select 0
use almdtran order dtra04 alias DTRA
*** - Variables a cargar del formulario que ejecuta el reporte *** 
*LsPeriodo	='200201'  && Periodo 
LsPeriodo	= {^2002-01-11}
LsGrupo_act ='008'     && Grupo de Actividades
LsTpoRef = 'O_T '
*** ------------ ***
store 0 to nc,nl,nEspxCult,nCulxLot 
Store '' TO LsEncab1,LsEncab2,LsEncab3
dimension aCultxLote(1,2)
store '' to aCultxLote
nEspxCult = 8   && espacio por cultivo
sele cxlot
go top
do while !eof()
	LsCodLote=CodLote
	nCulxLot = 0 && Numero de cultivos por lote
	SCAN while CodLote=LsCodLote
		if !verifica_mov_culxlote(CodLote,CodCult,LsPeriodo,LsGrupo_Act)
		    loop
		endif
		nl=nl + 1
		IF ALEN(aCultxLote,1)<nl
			dimension aCultxLote(nl+1,2)
		ENDIF	
		aCultxLote(nl,1)=CodLote
		aCultxLote(nl,2)=CodCult
		=SEEK(CodCult,'CULTI')
		LsEncab2=LsEncab2 + PADR(CULTI.DESCULT,nEspxCult)
		nCulxLot = nCulxLot + 1
	ENDSCAN
	LsEncab1=LsEncab1 + PADR(LsCodLote,nEspxCult*nCulxLot)
	SELE cxlot
enddo
*!*	?lsencab1
*!*	?lsencab2
=Captura_Mov_Recurso()
suspe
******************************
function verifica_mov_culxlote
******************************
PARAMETERS _Lote,_Cultivo,_Periodo,_Actividad
If parameters()=0
	=messagebox('Parametros : LOTE [,CULTIVO] [,FECHA][,ACTIVIDAD]')
	return .f.
endif
LOCAL LsLlave,LsArea_Act,LsOrden_act
LsArea_Act = ALIAS()
DO CASE
	CASE Parameters()=1
		LsLlave = _Lote
	CASE Parameters()=2
		LsLlave = _Lote+_Cultivo
	CASE Parameters()>=3
		do case
			case Vartype(_Periodo) = 'D'
				LsLlave = _Lote+_Cultivo+DTOS(_Periodo)
			case Vartype(_Periodo) = 'C' AND LEN(_Periodo)=6
				LsLlave = _Lote+_Cultivo+TRIM(_Periodo)
			case Vartype(_Periodo) = 'C' AND LEN(_Periodo)=4			
				LsLlave = _Lote+_Cultivo+TRIM(_Periodo)
		endcase
		
ENDCASE
*** ------- ***
IF Parameters()=4 AND !(EMPTY(_Actividad) OR ISNULL(_Actividad))
	LlOk = .F.
	SELECT CO_T
	LsOrden_act = ORDER()
	SET ORDER TO CO_T04
	SEEK LsLLave
	SCAN WHILE CodLote+CodCult+DTOS(FchDoc) = LsLLave
		IF  SEEK(CodActiv,'Acti') AND ACTI.CodGral=_Actividad   && Te falta evitar este Harcode!! CORCHA!!!
			LlOk = .T.
			exit
		ENDIF
	ENDSCAN
	set order to (LsOrden_act)
else
	LlOk = SEEK(Lsllave,'CO_T','CO_T04')
endif	
IF !EMPTY(LsArea_Act)
	SELECT (LsArea_act)
ENDIF
RETURN LlOk
****************************
FUNCTION Captura_Mov_Recurso
****************************
select 0
use cpicxlgral 
LcArcTmp = GoEntorno.TmpPath+SYS(3)
copy stru to (LcArcTmp) WITH CDX
USe (LcArctmp) EXCLU ALIAS TEMPO order cxlt01

**
IF VARTYPE(LsPeriodo)='D'
	LsFecha=DTOS(LsPeriodo)
ENDIF
**

SELECT CO_T
LsOrden_act = ORDER()
SET ORDER TO CO_T04
FOR K = 1 TO ALEN(aCultxLote,1)
	LsLlave = aCultxLote(K,1)+aCultxLote(K,2)+LsFecha
	store 0 to LfTotxCol01,LfTotxCol02 	&& Totales por columnas
	SELECT CO_T
	SEEK LsLLave
	SCAN WHILE CodLote+CodCult+DTOS(FchDoc) = LsLLave
		IF  SEEK(CodActiv,'Acti') AND ACTI.CodGral=LsGrupo_act   
			SELE DTRA	
			seek LsTpoRef+CO_T.NroDoc
			SCAN while TpoRef+NroRef = LsTpoRef+CO_T.NroDoc
				IF SEEK(NroRef,'QO_T')
					LsRecurso=QO_T.CodPar
				ELSE	
					LsRecurso=SPACE(LEN(QO_T.CodPar))
				ENDIF
				select 	Tempo
				SEEK DTRA.CodMat+LsRecurso
				IF !FOUND()
					APPEND BLANK	
					replace codmat with DTRA.CodMat
					replace CodPar WITH LsRecurso
				ENDIF
			** Acumulamos Cantidad total por Insumo
				replace canxRec with CanxRec + DTRA.CanDes
			** Acumulamos Costo Total por Insumo
				replace ctoxRec WITH CtoxRec + DTRA.ImpNAc
			** Acumulamos horas por Lote y Cultivo (Columna K) **
				** Calculamos Horas acumuladas  de la columna  K				
				LsCmpHora = 'H'+TRAN(K,"@L ##")
*!*	*!*					LsHora = EVAL(LsCmpHora)
*!*	*!*					LnXMin=at(":",Lshora)
*!*	*!*					LfHoraxCol=val(left(Lshora,LnXMin-1))+ round(val(substr(Lshora,LnXMin+1))/60,2)
				** Obtenemos horas acumuladas por el insumo, la O_T y el recurso
				LnXMin=at(":",QO_T.n_hora)
				LfValHora=val(left(QO_T.n_hora,LnXMin-1))+ round(val(substr(QO_T.n_hora,LnXMin+1))/60,2)
				** Hora total **
				replace (LsCmpHora) WITH eval(LsCmpHora) + LfValHora
				** Acumulamos Costo por Lote y Cultivo (Columna K) **
				LsCmpCto = 'C'+TRAN(K,"@L ##")
				replace (LsCmpCto) WITH EVAL(LsCmpCto) + DTRA.ImpNAc
			ENDSCAN
			SELE CO_T
		ENDIF
	ENDSCAN
	*** Grabamos total por columnas ***
	
endfor
select co_t
set order to (LsOrden_act)
