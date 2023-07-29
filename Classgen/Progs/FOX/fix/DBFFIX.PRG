WAIT WINDOW 'DBF FIXING...' NOWAIT
SET TALK OFF
DIMENSION l1dbfs(1)
=ADIR(l1dbfs,'.\*.dbf')
l1err=.F.
CLEAR
??CHR(7)
WAIT WINDOW 'Checking Database Files...' NOWAIT
IF ALEN(l1dbfs)<>1
	FOR l1dbf=1 TO ALEN(l1dbfs)/5
		l1file=l1dbfs(l1dbf,1)
*		WAIT WINDOW RIGHT('          '+l1file,12)+'    ['
		STORE FOPEN(l1file,2) TO l1mess
		STORE FSEEK(l1mess, 0, 2) TO l1ndx_sz
		=FSEEK(l1mess,0)
		l1str=FREAD(l1mess,4)
		l1ass=readx(4)
		l1head=readx(2)
		l1rec=readx(2)
		l1actual=(l1ndx_sz-(l1head+1))/l1rec
		l1actual=IIF(l1ndx_sz=l1head,0,l1actual)
		IF l1actual<>l1ass
			l1err=.T.
*			WAIT WINDOW 'X]'
			=FSEEK(l1mess,0)
			l1str=FREAD(l1mess,4)
			l1replace=RIGHT('00000000'+hex(l1actual),8)
			l1tmp=''
			FOR l1loop=1 TO 4
				l1tmp=CHR(dec(SUBSTR(l1replace,l1loop*2-1,2)))+l1tmp
			ENDFOR
			=FWRITE(l1mess,l1tmp)
		ELSE
*			WAIT WINDOW CHR(251)+']'
		ENDIF
		= FCLOSE(l1mess)
	ENDFOR
ENDIF
WAIT WINDOW ;
IIF(l1err,'Errors Found!  Please Re-Index..press any key',';
	All Databases appear okay..press any key')
RETURN

FUNCTION readx
parameter l1len
l1str=FREAD(l1mess,l1len)
l1tmp=''
FOR l1loop=1 TO l1len
	l1tmp=RIGHT('00'+hex(ASC(SUBSTR(l1str,l1loop,1))),2)+l1tmp
ENDFOR
l1value=dec(l1tmp)
RETURN l1value

FUNCTION hex
PARAMETERS l1int
PRIVATE l1loop,l1hex,l1str
l1str='0123456789ABCDEF'
l1hex=''
FOR l1loop=7 TO 0 STEP -1
	l1part=INT(l1int/(16^l1loop))
	l1hex=l1hex+SUBSTR(l1str,l1part+1,1)
	l1int=l1int-l1part*(16^l1loop)
ENDFOR
DO WHILE LEFT(l1hex,1)='0'.and.len(l1hex)>1
	l1hex=SUBSTR(l1hex,2)
ENDDO
RETURN l1hex

FUNCTION dec
PARAMETERS l1hex
PRIVATE l1loop,l1int,l1str,l1ctr
l1str='0123456789ABCDEF'
l1int=0
FOR l1loop=LEN(l1hex)-1 TO 0 STEP -1
	l1int=l1int+(16^l1loop)*(AT(SUBSTR(l1hex,LEN(l1hex)-l1loop,1),l1str)-1)
ENDFOR
RETURN l1int
