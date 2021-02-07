************************************************************************************
Function gcObfuscate
Lparameters tcCode,tcOo
*- obfuscate codes, design and test in fox9 sp2
*-  	remove comment,obfucsate variable define by local and lparameter
*-
*- tcCode£ºcode segments 
*- tcOo£º default "o0" , two single of double byte characters
*-			suggestions £º  ¡ð¡ò ¡ð¡è ¡Ø¡Þ ¡ß¡à §ê§ë ©¨©¬ _£ß  ¡ß¡à ¡Ø¡Þ ¡ö¡õ ¡ï¡î
*- 
*- exception: variable will not touch if it appear in a string 
*- 
*- I had not handle the situation of text / endtext because ... lazy :)
*-
*- feel free the use this code as you need. send me bugs report and your suggestion plz.
*- 
*- author:  Max Chan   email: max2051@126.com  blog: maxchan.cnblogs.com 

Local cSep,XTbl[1,2],i,j,k,cLine,cBin,nLineCnt,cTmp,nLineIdx,nXTBLidx
Local nIdx,cVarName,nPos,cTmpCodes,cTmpLine,cNewCode,nOccurs
Local nBeforePos,cBeforeChar,	nAfterPos,cAfterChar, o1,o2

tcOo=Evl(tcOo,'o0')
o1=Substrc(tcOo,1,1)
o2=Substrc(tcOo,2,1)
		
Rand(-1)
 
cNewCode=''
cSep = Chr(13)+Chr(10)+Chr(9)+"()=+-*/@#<>.',%&[] !;"+'"'
nLineCnt = Getwordcount(tcCode,Chr(13)+Chr(10))

For nLineIdx=1 To nLineCnt
	cLine = Ltrim(Getwordnum(tcCode,nLineIdx,Chr(13)+Chr(10)),0,Chr(9),' ')
	If Empty(cLine)
		Loop
	Endif

	*-- 0. semicolon in the end of line, ignore this 
	*!*		If Right(cLine,1)=';'
	*!*		EndIf  

	*-- 1. remove comment ----------------------------------------------
	If Left(cLine,1)='*'
		Loop
	Endif
	For i=1 To Occurs('&'+'&',cLine)
		nPos = At('&'+'&',cLine,i)
		If not glInString(cLine,nPos) 
			cLine = Substr(cLine,1,nPos-1)
			Exit
		Endif
	Next

	*-- 2. found  local / lparameters definition £¬create Xtable  ----------------------------
	*- ig. £º local i,j(2,3,2) as char , k,alist[2,3,2],oCa as oCa,uVal
	cTmp = Lower(GetWordNum(cLine,1,' '))
	If cTmp=='local' Or ( At(cTmp,'lparameters')=1 and Len(cTmp)>=4 )
		cTmpLine = cLine			

		*- 2.1 handle array define
		If '[' $ cTmpLine OR '(' $ cTmpLine
			cTmpLine = Chrtran(cTmpLine,'[]()','<><>')
			For i=1 to Occurs('<',cTmpLine)
				cTmpLine = Stuff(cTmpLine,At('<',cTmpLine,1),At('>',cTmpLine,1) - At('<',cTmpLine,1)+1,'')
			Next 
		EndIf 		

		*- 2.2 gen xtable
		For i=1 To Getwordcount(cTmpLine,',')
			cVarName = Lower( Alltrim(Getwordnum(cTmpLine,i,','),1,Chr(10),Chr(9),Chr(13),' ') )
			cTmp = Getwordnum(cVarName,1 ,' ')   && for  AS
			If cTmp=='local' or cTmp=='lparameters'	
				cVarName = Getwordnum(cVarName,2 ,' ')
			EndIf 	
			
			If Ascan(XTbl,cVarName,1,0,1,2+4)>0
				Loop
			Endif

			If Vartype(XTbl(1))<>'L'
				Declare XTbl( Alen(XTbl,1)+1, 2)
			Endif

			XTbl(Alen(XTbl,1),1) = cVarName
			cBin = ''
			For j=30 To 0 Step -1
				cBin = cBin + Iif(Bittest(Rand()*100000000,i),o1,o2)
			Next
			XTbl(Alen(XTbl,1),2) = o1 + cBin
		Next
	Endif

	*-- 3. new function/proc, reset XTbl
	cTmp = 'function,procedure,define class,func,proc'
	For i=1 to GetWordCount(cTmp,',')
		cTmp=GetWordNum(cTmp,i,',')
		If Lower(Left(cLine,Len(cTmp)+1)) == cTmp+' '
			Declare XTbl[1,2]
			Store .f. to XTbl		
			Exit
		EndIf 
	next

	*--4.   replacing ....o0o0o0o0o0oooo000 --------------------------------------
	For nXTBLidx=1 To Alen(XTbl,1)
		nOccurs = 1
		Do While .T.
			If Empty(XTbl(nXTBLidx,1))
				Exit
			EndIf 	
			
			nPos = Atc(XTbl(nXTBLidx,1),cLine,nOccurs)
			If nPos=0
				Exit
			EndIf
			nBeforePos = nPos-1
			cBeforeChar = Substr(cLine,nBeforePos,1)
			nAfterPos = nPos+Len(XTbl(nXTBLidx,1))
			cAfterChar  = Substr(cLine,nAfterPos,1)
			If Not (cBeforeChar $ cSep Or Empty(cBeforeChar)) Or Not (cAfterChar $ cSep Or Empty(cAfterChar))
				nOccurs = nOccurs + 1
				Loop
			EndIf
			
			*- In String, don't replace. undo before 
			If glInString(cLine,nPos) 
				cNewCode = Strtran(cNewCode,Xtbl(nXTBLidx,2),Xtbl(nXTBLidx,1),1,99999,1)
				cLine = Strtran(cLine,Xtbl(nXTBLidx,2),Xtbl(nXTBLidx,1),1,99999,1)
				Store .f. to Xtbl(nXTBLidx,2),Xtbl(nXTBLidx,1)
				Exit 
			Else
				cLine =  Left(cLine, nPos-1) + XTbl(nXTBLidx,2) + Substr(cLine,nPos + Len(XTbl(nXTBLidx,1)) )	
			EndIf 	
		EndDo
	Next
	*------------------
	
	cNewCode = cNewCode + cLine +Chr(13)+Chr(10)

	Wait Window Nowait  ( Textmerge('obfuscating  line <<nLineidx>> of <<nLineCnt>> ' ) )
Next
Wait clear 
tcCode = cNewCode &&for reference call

Return cNewCode

************************************************************************************
Function glInString
Lparameters tcString,tnPos

Local cStr,nLeftPos,cTheAnthorSep,i,cTmp,nRightPos
cStr = Substr(tcString,1,tnPos-1)
If Empty(cStr)
	Return .F.
Endif
*- [ ] '' ""

Do While .T.
	nLeftPos = Min(  Evl(At('"',cStr), 99999), Evl(At("'",cStr), 99999) ) &&Evl(At('[',cStr),99999)
	If nLeftPos=99999
		Return .f.
	EndIf 	

	cTheAnthorSep = Substr(cStr,nLeftPos,1)

	cStr=Substr(cStr,nLeftPos+1)
	
	nRightPos = At(cTheAnthorSep,cStr)
	If nRightPos = 0
		Return .t.
	EndIf
	
	cStr = Substr(cStr,nRightPos+1)	
EndDo 

****************************************************
