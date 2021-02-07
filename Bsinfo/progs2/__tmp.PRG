Scan

DO CASE 
CASE Quiebre1='A'
	replace col01 WITH desmaq 
	replace col02 wITH Ubic_actua 
	replace col03 wITH Marca 
	replace col04 wITH Modelo
	replace col05 wITH noserie
CASE Quiebre1='B'
	replace col01 WITH DTOC(FchDoc)+' '+NroOrd 
	replace col02 wITH Autor 
	replace col03 wITH IIF(SEEK('MT'+Tipo,'TABL'),TABL.Nombre,'No definido') 
	replace col04 wITH DTOC(Fchprog)
	replace col05 wITH Des_narr
CASE Quiebre1='C'
	LnLenAct=LEN(DesAct)
	replace col01 WITH CodAct+' '+LEFT(DesAct,LnLenAct/2)
	replace col02 WITH SUBSTR(DesAct,LnLenAct/2+1)
	replace col03 WITH []
	replace col04 WITH STR(NroTare,0)
	replace col05 wITH []
CASE Quiebre1='D'
	replace col01 WITH Especial
	replace col02 WITH Nomper
	replace col03 WITH TRANSFORM(Horusad,'999.99')
	replace col04 WITH []
	replace col05 wITH TRANSFORM(CostoMo,'999,999.99')

CASE Quiebre1='E'
	replace col01 WITH CodMat+' '+Desmat
	replace col02 WITH []
	replace col03 WITH TRANSFORM(CanMat,'999.99')
	replace col04 WITH Unidad
	replace col05 WITH TRANSFORM(CostoMt,'999,999.99')

	
ENDCASE 

ENDSCAN



UPDATE (thisform.ctabla_remota) SET ;
			PtoVta = m.PtoVta ,;
			&LsSetUpdCmp1.  ;
    		WHERE CodCia = m.CodCia AND CodSed = m.Codsed AND CodDoc = m.CodDoc