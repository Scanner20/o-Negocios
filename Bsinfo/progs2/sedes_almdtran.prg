set dele on
sele 0
use almtalma orde alma01 alias alma
sele 0
use almctran alias ctra
set rela to subalm into alma
sele 0
use almdtran alias dtra
set rela to subalm into alma
*
sele dtra
go top
scan while !eof()
     wait window subalm+[ ]+nrodoc nowait
     repla codsed with alma.codsed
endscan
*
sele ctra
go top
scan while !eof()
     wait window subalm+[ ]+nrodoc nowait
     repla codsed with alma.codsed
endscan
close data
return
*

