*+-----------------------------------------------------------------------------+
*Ý Nombre        Ý CmpPreIn.prg                                                Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Sistema       Ý LOGISTICA DE COMPRAS   - FOXPRO 2.6                         Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Autor         Ý VETT                   Telf: 4841538 - 9437638              Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Ciudad        Ý LIMA , PERU                                                 Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Direcci¢n     Ý Av. Bertello 170 - 401 Ciudad Satelite Sta. Rosa. - Callao  Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Prop¢sito     Ý Relacion de Precios de Insumos                              Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Creaci¢n      Ý 20/03/98                                                    Ý
*Ý---------------+-------------------------------------------------------------Ý
*Ý Actualizaci¢n Ý                                                             Ý
*Ý               Ý                                                             Ý
*+-----------------------------------------------------------------------------+
*=F1_BASE(GsNomCia,[RELACION DE PRECIOS DE INSUMOS],"USUARIO:"+GsUsuario,GsPeriodo)
*if !abrirdbfs()
*   do f1MsgErr WITH [Error en apertura de archivos]
*   close data
*   return
*ENDIF
PUBLIC lsencab1,lsencab2,nmesini,nmesfin,m.codmatd,m.codmath,ulttecla,;
m.control,m.ultpre
*
store [] to lsencab1,lsencab2
*nmesno    = [45]
nmesini   = _mes
nmesfin   = 12
*m.codmatd = space(len(catg.codmat))
*m.codmath = space(len(catg.codmat))
ulttecla  = 0
m.control = 1
m.ultpre  = .f.
do FORM cmp_cmpprein

*ulttecla  = lastkey()
*if m.control =2
*   ulttecla = k_esc
*endif
*
*if ulttecla # k_esc
*   do verif_item
*   do imp_item
*endif
*do desactiva
*close data
return
********************
PROCEDURE VERIF_ITEM
********************
m.codmatd = trim(m.codmatd)
m.codmath = trim(m.codmath)+chr(255)
sele catg
seek m.codmatd
if !found() and recno(0)>0
   go recno(0)
endif
scan while .not. eof() .and. codmat<=m.codmath for !inactivo
     wait window codmat+[=>]+catg.desmat+[ ]+catg.undstk nowait
     sele temp
     append blank
     do while !rlock()
     enddo
     repla codmat with catg.codmat
     repla desmat with catg.desmat
     repla undstk with catg.undstk
     unlock
     cc = 1
     if !m.ultpre
        for nm=nmesini to nmesfin
           *if !(ltrim(str(nm))$nmesno)   && MESES QUE NO SE DEBEN CONSIDERAR
              *
              lscmpmn = [PS]+tran(cc,[@l 99])
              lscmpus = [PD]+tran(cc,[@l 99])
              *
              pcmp1=[PS]+tran(nm,[@l 99])
              pcmp2=[PD]+tran(nm,[@l 99])
              lfprecmp1 = catg.&pcmp1.
              lfprecmp2 = catg.&pcmp2.
              *
              sele temp
              do while !rlock()
              enddo
              repla (lscmpmn) with lfprecmp1
              repla (lscmpus) with lfprecmp2
              unlock
              *
              cc = cc + 1
           *endif
        endfor
        *
        if nmesini+1 = nmesfin   &&& COMPARACION DE DOS MESES
           sele temp
           go top
           scan while !eof()
                do while !rlock()  
                enddo
                repla ps03 with ps02 - ps01
                repla pd03 with pd02 - pd01
                unlock
           endscan       
        endif
        *
     else
        pcmp1=[PS]+tran(nmesini,[@l 99])
        pcmp2=[PD]+tran(nmesini,[@l 99])
        lsmesaa = tran(nmesini,[@l 99])
        store 0 to lfprecmp1, lfprecmp2
        *
        do while .t.
           if catg.&pcmp1.#0
              lfprecmp1 = catg.&pcmp1.
              exit
           else
              if val(lsmesaa)>1
                 lsmesaa = tran(val(lsmesaa)-1,[@l ##])
                 pcmp1=[PS]+lsmesaa
              else
                 exit
              endif
           endif
        enddo
        xsmesmn = mes(val(lsmesaa))
        *
        lsmesaa = tran(nmesini,[@l 99])
        do while .t.
           if catg.&pcmp2.#0
              lfprecmp2 = catg.&pcmp2.
              exit
           else
              if val(lsmesaa)>1
                 lsmesaa = tran(val(lsmesaa)-1,[@l ##])
                 pcmp2=[PD]+lsmesaa
              else
                 exit
              endif
           endif
        enddo
        xsmesus = mes(val(lsmesaa))
        *
        sele temp
        do while !rlock()
        enddo
        repla ps01  with lfprecmp1
        repla mesmn with xsmesmn
        repla pd01  with lfprecmp2
        repla mesus with xsmesus
        unlock
     endif
     sele catg
endscan
return
*******************
PROCEDURE DESACTIVA
*******************
if !empty(woutput())
   release window (woutput())
endif
return
*******************
PROCEDURE ABRIRDBFS
*******************
sele 0
use almcatge order catg01 alias catg
if !used()
   return .f.
endif
*
arctmp1=pathuser+sys(3)
sele 0
create table &arctmp1. (codmat c(08) , desmat c(40), undstk c(03),;
                        ps01   n(14,4),pd01   n(14,4),;
                        ps02   n(14,4),pd02   n(14,4),;
                        ps03   n(14,4),pd03   n(14,4),;
                        ps04   n(14,4),pd04   n(14,4),;
                        ps05   n(14,4),pd05   n(14,4),;
                        ps06   n(14,4),pd06   n(14,4),;
                        ps07   n(14,4),pd07   n(14,4),;
                        ps08   n(14,4),pd08   n(14,4),;
                        ps09   n(14,4),pd09   n(14,4),;
                        ps10   n(14,4),pd10   n(14,4),;
                        ps11   n(14,4),pd11   n(14,4),;
                        ps12   n(14,4),pd12   n(14,4),;
                        mesmn  c(15),  mesus  c(15))
use &arctmp1. excl alias temp
if !used()
   return .f.
endif
index on codmat tag temp01
set order to temp01
return
******************
procedure imp_item
******************
if !m.ultpre
   do encabezado
endif
sele temp
go top
snomrep = iif(!m.ultpre,[cmpprein],[cmppreme])
xfor   = []
xwhile = []
largo  = 66       && largo de pagina
_plenght = largo
iniprn = [_prn0+_prn5a+chr(largo)+_prn5b+_prn4]
iniprnw= [_prn0+_prn5a+chr(largo)+_prn5b]
do f0print with [REPORTS]
return
*
********************
PROCEDURE Encabezado
********************
store [] to lsencab1,lsencab2
vtotitm = (nmesfin - nmesini) + 1
cc      = 1
for i=nmesini to nmesfin
    *if !(ltrim(str(i))$nmesno)   && MESES QUE NO SE DEBEN CONSIDERAR
       xxmes = padl(upper(mes(i)),16) + space(06)
       lsencab1 = lsencab1 + xxmes
       lsencab2 = lsencab2 + [    S/.       US$     ]
    *endif
    cc = cc + 1
    if cc > vtotitm
       exit
    endif
endfor
*
if nmesini+1 = nmesfin
   xxmes = padl([DIFERENCIA],16) + space(06)
   lsencab1 = lsencab1 + xxmes
   lsencab2 = lsencab2 + [    S/.       US$     ]    
   cc = cc + 1
endif
*
return
