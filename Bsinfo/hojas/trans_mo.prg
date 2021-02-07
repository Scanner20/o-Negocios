clear
set dele on
*
SELE 0
USE plnmpers ORDER PERS01 ALIAS PERS   &&& codpers
go top
repla all basic02 with basic01 for basic02=0
repla all basic03 with basic02 for basic03=0
*repla all basic04 with basic03 for basic04=0
*
SELE 0
USE cpimo_tb ORDER MO_T01 ALIAS MO_T   &&& nrodoc
*
sele mo_t
set rela to codpers into pers
go top
scan while !eof()
     wait window [Nº Doc.:]+nrodoc nowait
     if !empty(h_normal) and at(":",h_normal) = 0
        repla h_normal with alltrim(h_normal)+[:00]
     endif 
     *
     if !empty(h_extra) and at(":",h_extra) = 0
        repla h_extra with alltrim(h_extra)+[:00]
     endif 
     *     
     mmes      = month(fchdoc)     
     m.codpers = codpers
     m.nrohijo = pers.nrohijos
     m.sueldo  = eval([pers.basic]+TRAN(mmes,"@l ##"))     
     *
     * Verificar el Costo x Hora  x Obrero
     * Carga Social 4% obrero , Asignación Familiar 10%
     *
     m.sueldo  = (m.sueldo*1.04)+iif(m.nrohijo<>0,41,0)
     m.sxdxh   = round((m.sueldo/30)/8,2)
     *
     repla cost_hn with 0
     repla cost_hn with m.sxdxh
     *
endscan
close data
return
*
