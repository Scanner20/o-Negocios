SELECT vtarpedi
RELEASE lcArrStru,newarray
declare lcArrStru(1),newarray(1)
=afields(lcArrStru)
LsCmpAutoInc= ''
FOR k= 1 TO ALEN(lcArrStru,1)
	IF INLIST(VARTYPE(LcArrStru(k,17)),'I','N') AND LcArrStru(k,17)>0
		LsCmpAutoInc = LsCmpAutoInc +  LcArrStru(k,1)+IIF(K+1>ALEN(lcArrStru,1),'',',')
	ENDIF
ENDFOR 
IF RIGHT(RTRIM(LsCmpAutoInc),1)=','
	LsCmpAutoInc = SUBSTR(LsCmpAutoInc,1,LEN(LsCmpAutoInc)-1)
ENDIF
cAlias='RPED'
create cursor &cAlias from array lcArrStru
SELECT vtarpedi
SCATTER MEMVAR memo FIELDS EXCEPT &LsCmpAutoInc.
SELECT (calias)
APPEND BLANK 
GATHER MEMVAR MEMO FIELDS EXCEPT &LsCmpAutoInc.

