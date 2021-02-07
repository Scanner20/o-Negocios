parameter xano,xmes
**
sele 0
use \base\cia001\c1997\cbdrmovm order rmov01 alias rmov
if !used()
   close data
   return 
endif
**
sele 0
use \base\cia001\c1997\cbdvmovm order vmov01 alias vmov
if !used()
   close data
   return
endif
arctmp=[cb1997]+TRAN(xMes,[@L ##])+[.chk]
sele rmov
copy stru to (arctmp) with cdx 
sele 0
use (arctmp) alias tmp exclu
difer =0
sele rmov
seek TRAN(xMes,[@L ##])
scan while nromes=TRAN(xMes,[@L ##])
    wait window nromes+[ ]+codope+[ ]+nroast nowait
	scatter memvar
    sele vmov
	seek rmov.nromes+rmov.codope+rmov.nroast
	if !found()

	   sele tmp
	   append blank
	   gather memvar
	   if tpomov=[D]
	      difer=difer + import
	   ELSE
	      difer=difer - import
	   ENDIF
  	    wait window nromes+[ ]+codope+[ ]+nroast+[ *] nowait
	endif		
	sele rmov
endscan
sele tmp
append blank
replace glodoc with [Diferencia en soles: ]
replace import with difer
go top
brow
list nromes,codope,nroast,fchast,nrodoc,fchdoc,glodoc,import,codmon,impusa,tpocmb to print
close data 
return 