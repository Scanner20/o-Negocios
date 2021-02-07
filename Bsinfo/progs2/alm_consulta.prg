LcArctmp="C:\fundo\"+sys(3)

SELECT 0
USE ALMCATGE ORDER CATG01 alias catg
SELECT 0
USE ALMDTRAN ORDER DTRA03
copy stru to (LcArctmp)
SEEK 'IFUN0065'
SET RELA TO CODMAT INTO CATG
lfstkini=catg.stkini
lfvinimn=catg.vinimn
LfStkAct = catg.stkini
LfVctomn = catg.vinimn
SCAN WHILE CODMAT='IFUN0065'
	scatter memvar
	if codajt='A'
		m.impcto=round(preuni*candes,6)
		LfImpCto=m.impcto
	else
		m.impnac=candes*round(Lfvctomn/lfstkact,6)	
		LfImpCto=m.impnac
	endif
	Lfstkact=Lfstkact + iif(tipmov='S',-Candes,Candes)
	Lfvctomn=Lfvctomn + iif(tipmov='S',-Lfimpcto,Lfimpcto)
	m.Stkact=LfStkact
	m.VctoMn=LfVctoMn
	insert into (lcarctmp) from memvar 
ENDSCAN
select (lcArctmp) 
BROW   FIEL CODMAT,TIPMOV,TPOCMB,CANDES,PREUNI,IMPCTO,IMPUSA,IMPNAC,STKACT,CTOUNI=VCTOMN/STKACT, VCTOMN,CODAJT font 'Courier New',9