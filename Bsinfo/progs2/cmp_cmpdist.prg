STORE '' TO  m.PerTra,m.PerAnt,PsCodMat,xscodaux ,LsUndStk

STORE {} TO PdFchFin,PdFchFin
STORE 0 TO m.mes,LfCanPrg,LfCanPen,XfTpoCmb,UltTecla,XfPorIgv,m.Salir,AnoAct,MesAct,previo

STORE .T. TO M.PRIMERA


IF FILE(GoCfgVta.oentorno.tspathcia+'CMPCONFG.MEM')
	RESTORE FROM GoCfgVta.oentorno.tspathcia+'CMPCONFG.MEM' ADDITIVE
ENDIF

IF VARTYPE(CFGADMIGV)='U'
	XfPorIgv = 19
ELSE
	XfPorIgv = CFGADMIGV
ENDIF

DO FORM cmp_cmptdist
return
****************
FUNCTION vCodAux
****************
PARAMETERS prov
if deleted()
	return
endif

lvalido=F1_BUSCA(prov,[CODAUX],[AUXI],[AUXI],GsClfPro,.F.,[])
IF lValido
   *DO WHILE !RLOCK([DIST])
   *ENDDO
   *REPLACE DIST.CodAux WITH m.CodAux
   *replace dist.nOMaUX with aUXI.NOMAUX
   *UNLOCK IN [DIST]
ENDIF
RETURN lValido
****************
FUNCTION vPorDis
****************
PARAMETERS por
*poracum = por
*SELECT dist1
*regact = RECNO()
*GO TOP 
*SCAN 
*	poracum = poracum + pordis
*ENDSCAN 
*IF !EOF()
*	GO regact 
*ENDIF  
RETURN (Por>=0 AND por<=100)
****************
FUNCTION vFmaPgo
****************
PARAMETERS fp
lValido = F1_Busca(FP,[FMAPGO],[FPGO],[FPGO],[],.T.,[])
IF lValido
	*DO WHILE !RLOCK([DIST])
	*ENDDO
	*REPLACE DIST.FmaPgo WITH m.FmaPgo
	*UNLOCK IN [DIST]
ENDIF	
RETURN lValido
****************
FUNCTION vEmiO_C
****************
PARAMETERS oc
RETURN OC>=0
****************
FUNCTION vcpProd
****************
PARAMETERS en
RETURN en>=0
****************
FUNCTION Can_Prg
****************
RETURN ROUND(LfCanPen*PorDis/100,2)
****************
FUNCTION vCodMon
****************
SCATTER MEMVAR
RETURN INLIST(m.CodMon,1,2)
******************
PROCEDURE TOT_PROG
******************
lfcanpen = 0
sele prmy
xsllave = m.pertra+pscodmat+tran(m.mes,[@l ##])
seek xsllave
if found()
   scan while periodo+codmat+nromes=xsllave for sitprog=[P]
        lfcanpen = lfcanpen + progcmp
   endscan
endif
sele dist
return
*****************
FUNCTION F_Tpocmb    && Tomar el tipo de cambio de una fecha
*****************
PARAMETER _Fch
PRIVATE AREA_ACT
AREA_ACT=ALIAS()
_TpoCmb=-1
IF SEEK(DTOS(_fch),"TCMB")
   IF Tcmb.OfiVta<=0
      SELE TCMB
      DO WHILE !BOF()
         SKIP -1
         IF TCMB.OfiVta>0
            EXIT
         ENDIF
      ENDDO
      IF TCMB.OfiVta>0
   	     _TpoCmb= TCMB.OfiVTa
	  ENDIF
  ELSE
      IF TCMB.OfiVta>0
  	     _TpoCmb= TCMB.OfiVTa
   	  ENDIF
  ENDIF
ELSE
   SELE TCMB
   IF !FOUND() AND RECNO(0)>0
	  GO RECNO(0)
   ENDIF
   IF !BOF()
      SKIP -1
   ENDIF
   IF TCMB.OfiVta>0
      _TpoCmb = TCMB.OfiVta
   ENDIF
ENDIF
SELE (AREA_ACT)
RETURN _TpoCmb
*****************
FUNCTION _mespro     &&  m.mes VALID
*****************
if m.mes<MesAct 
	WAIT WINDOW "Mes debe ser mayor que mes actual" nowait
   return .f.
ENDIF
IF m.mes>12 .OR. m.mes<1
	WAIT WINDOW "Mes incorrecto" nowait
  	return .f.
endif
*AnoAct = VAL(SUBSTR(m.PerTra,1,4))
AnoAct = VAL(SUBSTR(m.PerAnt,1,4))
IF m.mes<12
   PdFchFin = CTOD("01/"+STR(m.mes+1,2,0)+"/"+STR(AnoAct,4,0)) - 1
ELSE
   PdFchFin = CTOD("31/12/"+STR(AnoAct,4,0))
ENDIF
*=SEEK(m.PerTra+PsCodMat,[PACI])
=SEEK(m.PerAnt+PsCodMat,[PACI])
LsCmpMes=[PACI.CP]+TRAN(m.mes,[@L ##])
LfCanPrg=EVAL(LscmpMes)
*
do tot_prog