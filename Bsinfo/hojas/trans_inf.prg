*!*	Transferencia de Datos de Excel a Dbfs y de Dbfs a las Tablas del Sistema
clear
m.predio = [C]
m.mes    = 1
m.pase   = [N]
@09,083 say [<R>osita <C>ecilia :]
@10,085 say [Mes a Procesar   : ]
@11,085 say [Transferir <S/N> : ]
@09,104 get m.predio  pict [!] valid (m.predio$[RC])
@10,104 get m.mes     pict [99]
read
@11,104 get m.pase    pict [!] valid (m.pase$[SN])
read
*clear gets
m.mes = PADL(m.mes,2,[0])
XsNroMes  = m.mes
*
set deci to
sele 0
if m.predio = [R]
   use c:\aplvfp02\fundo\hojas\pdctraok orde ctra01 exclu alias c_ok   &&& Para verificar los correlativos de las PD
else
   use c:\aplvfp02\fundo\hojas\scctraok orde ctra01 exclu alias c_ok   &&& Para verificar los correlativos de las PD
endif
set safe off
delete all for substr(nroodt,4,2)=xsnromes
pack
set safe on
*
sele 0
use cpiculti orde cult03  alias cult   &&& OJO Indice con Códigos Anteriores Ejm. LUC,MARA,etc
sele 0
use almcdocm orde cdoc01  alias cdoc
sele 0
use almcatge orde catg01  alias catg
sele 0
use almcatal orde cata01  alias cata
sele 0
use cbdmpart orde part01  alias part
sele 0
use plnmpers orde pers01  alias pers
*
sele 0
use cpicuxlt orde cuxlt03 alias cuxlt
*
sele 0
use cpiacxpr orde acxpr01 alias acxpr
*
sele 0
use almctran orde ctra01  alias ctra
sele 0
use almdtran orde dtra01  alias dtra
sele 0
use cpico_tb orde co_t01  alias co_t
sele 0
use cpido_tb orde do_t02  alias do_t 
sele 0
use cpimo_tb orde mo_t01  alias mo_t
sele 0
use cpiqo_tb orde qo_t01  alias qo_t 
**
sele 0
if m.predio = [R]   &&&& Santa Rosita
   nom_dbf = [c:\aplvfp02\fundo\hojas\pd]+m.mes+[_ok]
else
   nom_dbf = [c:\aplvfp02\fundo\hojas\sc]+m.mes+[_ok]
endif
use (nom_dbf) exclu alias pdok
set safe off
index on codsed+mm+dd+nrodoc_pd+codpro+codlote+codfase+codprocs+codactiv tag pd01
index on codmat+upper(desmat)                                            tag pd02 addi
index on codpers+upper(ape_nom)                                          tag pd03 addi
index on codpar+upper(nompar)                                            tag pd04 addi
index on codlote+codpro                                                  tag pd05 addi
index on codfase+codprocs+codactiv                                       tag pd06 addi
if m.pase = [S]
   zap
endif
set safe on
**
if m.pase = [S]
sele 0
if m.predio = [R]   &&&& Santa Rosita
   nom_dbf = [c:\aplvfp02\fundo\hojas\sr_pd_]+m.mes
else                &&&& Santa Cecilia
   nom_dbf = [c:\aplvfp02\fundo\hojas\sc_pd_]+m.mes
endif
use (nom_dbf) exclu alias temp
**
sele temp
set safe off
if m.predio = [R]   &&&& Santa Rosita
   index on mm+dd+nrodoc           tag sr_pd01
   index on codmat+upper(desmat)   tag sr_pd02 addit
   index on codpers+upper(ape_nom) tag sr_pd03 addit
   index on codpar+upper(nompar)   tag sr_pd04 addit
else
   index on mm+dd+nrodoc           tag sc_pd01
   index on codmat+upper(desmat)   tag sc_pd02 addit
   index on codpers+upper(ape_nom) tag sc_pd03 addit
   index on codpar+upper(nompar)   tag sc_pd04 addit
endif
set safe on
go top
*
sele temp
set order to 
go top
scan while !eof()
     if !empty(nrodoc)
        scatter memvar
     endif
     *
     if empty(nrodoc)
        m.doc = alltrim(m.mm) + [-] + alltrim(m.dd) + [-] + alltrim(m.nrodoc) + []
        wait window [MM-DD-Nº ] + m.doc + str(recno(),6) nowait
        *
        repla nrodoc  with m.nrodoc,  mm       with m.mm,       dd       with m.dd
        repla codfase with m.codfase, codprocs with m.codprocs, codactiv with m.codactiv
        repla codlote with m.codlote, codpro   with m.codpro
     endif
     *
endscan
wait window [Ok ...] nowait
*
if m.predio = [R]   &&&& Santa Rosita
   wait window [Transfiriendo Información del ]+m.mes+[ SR_PD_ a PD_OK.....] nowait
else
   wait window [Transfiriendo Información del ]+m.mes+[ SC_PD_ a PD_OK.....] nowait
endif
go top
scan while !eof()
     scatter memvar
     *
     m.nrodoc_pd= padl(alltrim(m.nrodoc),2,[00])        
     m.mm       = padl(alltrim(m.mm),2,[00])
     m.dd       = padl(alltrim(m.dd),2,[00])
     *
     m.fchdoc   = ctod(m.dd+[/]+m.mm+[/]+str(_ano,4,0))             
     *
     m.codfase  = padl(alltrim(m.codfase),3,[000])
     m.codprocs = padl(alltrim(m.codprocs),3,[000])
     m.codactiv = padl(alltrim(m.codactiv),3,[000])
     if len(alltrim(m.codlote))<3 and !empty(m.codlote)
        m.codlote  = alltrim(left(m.codlote,1)+[0]+subst(m.codlote,2))
     endif
     m.codpro   = alltrim(m.codpro)
     *
     m.codsed   = iif(m.predio=[R],[001],[002])  &&& Santa Rosita
     *         
     m.subalm   = iif(!empty(m.subalm),padl(alltrim(m.subalm),3,[000]),m.subalm)
     m.tipmov   = [S]
     m.codmov   = [002]  &&& Cultivos en Proceso
     *
     m.codmat   = alltrim(m.codmat)
     m.candes   = val(m.candes)
     *
     m.codpers  = iif(!empty(m.codpers),padl(alltrim(m.codpers),6,[000000]),m.codpers)
     *
     m.codpar   = iif(!empty(m.codpar),padl(alltrim(m.codpar),8,[00000000]),m.codpar)
     *
     sele pdok
     append blank
     gather memvar
     sele temp
     *
endscan
endif
*
sele pdok
set rela to codmat                    into catg
set rela to subalm+codmat             into cata  addi
set rela to codpers                   into pers  addi
set rela to codpar                    into part  addi
set rela to codlote+codpro            into cuxlt addi
set rela to codfase+codprocs+codactiv into acxpr addi
set rela to codpro                    into cult  addi
set orde to pd01
go top
brow field mm,dd,nrodoc_pd,codpro,codlote,codfase,codprocs,codactiv nomodify
set orde to pd02
set filter to !empty(codmat+desmat)
go top
brow field codmat,catg.codmat,desmat,catg.desmat,undstk,catg.undstk,candes,mm,dd,nroguia,nrodoc_pd  &&& nomodify
set filter to !empty(subalm+codmat)
go top
brow field subalm,cata.subalm,codmat,cata.codmat,mm,dd,nrodoc_pd,desmat   &&& nomodify
set orde to pd03
set filter to !empty(codpers+ape_nom+h_n+h_e)
go top
brow field codpers,pers.codpers,ape_nom,pers.nompers,pers.apepers,h_n,h_e,h_n_a,h_e_a,h_n_d,h_n_proc,h_e_proc,mm,dd,nrodoc_pd  &&&& nomodify
set orde to pd04
set filter to !empty(codpar+nompar)
go top
brow field codpar,part.codpar,nompar,part.nompar,hora,mm,dd,nrodoc_pd    &&&  nomodify
set filter to
set orde to pd05
go top
brow field codlote,cuxlt.codlote,codpro,cuxlt.codcult1,cuxlt.codcult,mm,dd,nrodoc_pd   &&&& nomodify
set filter to
set orde to pd06
go top
brow field codfase,acxpr.codfase,codprocs,acxpr.codprocs,codactiv,acxpr.codactiv,mm,dd,nrodoc_pd   &&&& nomodify
*
sw = 0
if sw = 1
sele pdok
set orde to pd01
go top
do while !eof()
   jcnrodoc = codsed+mm+dd+right([000]+alltrim(nrodoc_pd),3)
   scatter memvar
   m.codpro  = cult.codpro
   m.codcult = cult.codcult
   *
   sele co_t
   wait window [Grabando en CO_T Nº]+jcnrodoc nowait   
   *
   append blank
   repla codlote   with m.codlote
   repla codfase   with m.codfase
   repla codprocs  with m.codprocs
   repla codactiv  with m.codactiv
   repla codcult   with m.codcult
   repla codpro    with m.codpro
   *
   repla nrodoc    with jcnrodoc
   repla fchdoc    with pdok.fchdoc
   repla fchfin    with pdok.fchdoc
   repla canobj    with 0
   repla canfin    with 0
   repla respon    with []
   repla cdarea    with []
   repla factor    with 1
   repla canfina   with 0
   repla fchfina   with m.fchdoc
   *
   repla vform1d01 with 0
   repla vform1d02 with 0
   repla vbatc1d01 with 0 
   repla vbatc1d02 with 0
   repla vmerm1d01 with 0
   repla vmerm1d02 with 0
   *
   repla vform2d01 with 0
   repla vform2d02 with 0
   repla vbatc2d01 with 0
   repla vbatc2d02 with 0
   repla vmerm2d01 with 0
   repla vmerm2d02 with 0
   *
   repla vforl1d01 with 0
   repla vforl1d02 with 0
   repla vbatl1d01 with 0
   repla vbatl1d02 with 0
   repla vmerl1d01 with 0
   repla vmerl1d02 with 0
   *
   repla vforl2d01 with 0
   repla vforl2d02 with 0
   repla vbatl2d01 with 0
   repla vbatl2d02 with 0
   repla vmerl2d01 with 0
   repla vmerl2d02 with 0
   *
   repla vdevomn   with 0
   repla vdevous   with 0
   repla vdevlmn   with 0
   repla vdevlus   with 0
   repla eficie    with 0
   repla tipo      with 0
   repla tipbat    with 1   &&& Batch    2->Regularizaciones
   *
   m.busca = 0
   m.swalm = 0
   sele pdok
   scan while codsed+mm+dd+right([000]+alltrim(nrodoc_pd),3) = jcnrodoc
        m.codsal = []
        scatter memvar
        m.codpro  = cult.codpro
        m.codcult = cult.codcult
        if !empty(codmat)
			do grab_mov_alm
            wait window [Grabando en DO_T Nº]+jcnrodoc nowait
            do grab_do_t
        endif
        *
        if !empty(codpers)  &&& Mano de Obra
            wait window [Grabando en MO_T Nº]+jcnrodoc nowait
            do grab_mo_t
        endif
        *
        if !empty(codpar)  &&& Maquinaria y Equipo
            wait window [Grabando en QO_T Nº]+jcnrodoc nowait        
            do grab_qo_t
        endif
        *   
        sele pdok
   endscan
   *
   sele pdok
enddo
endif
*
close tables all
return

*******************
PROCEDURE GRAB_DO_T
*******************
sele do_t
append blank
repla nrodoc  with jcnrodoc
repla codpro  with m.codpro
repla tippro  with [PTA]   && Productos que no son envases
repla subalm  with m.subalm
repla codmat  with m.codmat
repla fchdoc  with m.fchdoc
repla cansal  with m.candes
repla canfor  with 0
repla canadi  with 0
repla candev  with 0
repla undpro  with catg.undstk
repla facequ  with 1
repla canfora with 0
repla canadia with 0
repla candeva with 0
repla cansala with 0
repla stkfor  with .f.
repla stkadi  with .f.
repla flgfor  with .f.
repla flgadi  with .f.
repla flgdev  with .f.
repla codsal  with m.codsal
repla flgsal  with .t.
repla stksal  with .t.
repla cnfmla  with 0
return
*
**********************
PROCEDURE GRAB_MOV_ALM
**********************
wait window [Grabando en DTRA Nº]+jcnrodoc nowait
*
m.busca = jcnrodoc+m.subalm+m.tipmov+m.codmov
sele c_ok
seek m.busca
if found()
   m.NroDoc = c_ok.NroDoc
   m.codsal = c_ok.tipmov + c_ok.codmov + c_ok.nrodoc
else
   m.NroDoc=GoCfgAlm.correlativo(GoCfgAlm.EntidadCorrelativo,m.TipMov,m.CodMov,m.SubAlm,'0')
endif
*
IF !SEEK(m.SubAlm+m.TipMov+m.CodMov+m.NroDoc,'CTRA','CTRA01')
	DO GRAB_CTRA
ENDIF
DO GRAB_DTRA
*
*******************
PROCEDURE GRAB_CTRA
*******************
m.NroDoc=GoCfgAlm.correlativo(GoCfgAlm.EntidadCorrelativo,m.TipMov,m.CodMov,m.SubAlm,'0')
*
sele ctra
append blank
repla codsed    with m.codsed
repla subalm    with m.subalm
repla tipmov    with m.tipmov
repla codmov    with m.codmov
repla nrodoc    with m.nrodoc
repla fchdoc    with co_t.fchdoc
repla nroodt    with co_t.nrodoc
*
repla codlote   with co_t.codlote
repla codcult   with co_t.codcult
repla codfase   with co_t.codfase
repla codprocs  with co_t.codprocs
repla codactiv  with co_t.codactiv
repla codprd    with co_t.codpro
*
repla observ    with [TRANSFERENCIA DE INFORMACION] &&& Para Identificar los asientos que estoy pasando
*
=GoCfgAlm.correlativo(GoCfgAlm.EntidadCorrelativo,m.TipMov,m.CodMov,m.SubAlm,m.NroDoc)
*
m.codsal = ctra.tipmov + ctra.codmov + ctra.nrodoc
*
sele c_ok
append blank
repla nroodt with ctra.nroodt, subalm with ctra.subalm, tipmov with ctra.tipmov
repla codmov with ctra.codmov, nrodoc with ctra.nrodoc
return
*
*******************
PROCEDURE GRAB_DTRA
*******************
LsLlave_Reg = m.SubAlm + m.TipMov + m.CodMov + CTRA.NroDoc
select max(nroitm)+1 as nroitm from almdtran where subalm+tipmov+codmov+nrodoc=LsLlave_Reg into cursor cur_temp
IF _TALLY  = 0		&& Creando registro por primera vez
	m.NroItm = 1
ELSE
	m.NroItm = cur_temp.nroitm
ENDIF
use in cur_temp

sele dtra
append blank
repla subalm  with m.subalm
repla tipmov  with m.tipmov
repla codmov  with m.codmov
repla nrodoc  with ctra.nrodoc
repla nroitm  with m.NroItm
repla FchDoc  with CTRA.FchDoc
**repla nroodt with co_t.nrodoc
repla codprd  with co_t.codpro
repla codmat  with m.codmat
repla candes  with m.candes
repla factor  with 1
repla undvta  with catg.undstk
repla tporef  with [O_T]
repla nroref  with co_t.nrodoc
repla nroref2 with alltrim(m.nroguia)
**
repla anoast with [JCTA]  &&& Para Identificar los asientos que estoy pasando
replace ctra.NroItm with CTRA.NroItm  + 1
*
return
*
*******************
PROCEDURE GRAB_MO_T
*******************
sele mo_t
append blank
repla nrodoc   with jcnrodoc
repla codpers  with m.codpers
repla fchdoc   with m.fchdoc
repla h_normal with alltrim(m.h_n)
repla h_extra  with alltrim(m.h_e)
repla cost_hn  with 0        &&& ??? Miguel Costo Hora Normal
repla cost_he  with 0        &&&  ??? Miguel Costo Hora Extra
repla h_n_a    with alltrim(m.h_n_a)
repla h_e_a    with alltrim(m.h_e_a)
repla h_n_d    with alltrim(m.h_n_d)
repla h_n_proc with alltrim(m.h_n_proc)
repla h_e_proc with alltrim(m.h_e_proc)
return
*
*******************
PROCEDURE GRAB_QO_T
*******************
sele qo_t
append blank
repla nrodoc  with jcnrodoc
repla codpar  with m.codpar
repla fchdoc  with m.fchdoc
repla n_hora  with alltrim(m.hora)
return
*
