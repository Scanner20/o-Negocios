   7   !                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              gdoc.nomcli                    gdoc.dircli                    gdoc.ruccli                    rdoc.codigo                    tabla.nombre                   rdoc.import                    "999,999,999.99"               J                              GDOC->IMPTOT                   "999,999,999.99"               J                              gdoc.codcli                    IIF(GDOC->CodMon=1,'S/.','US$')                                 NRODOC                         "@R 999-0999999"               	"R.U.C.:"                      "LIMA, "                       DAY(GDOC.FCHDOC)               "@L ##"                        "DE "                          3MES(GDOC.FCHDOC,1)+" DE "+STR(YEAR(GDOC->FCHDOC),4)             GDOC.GLOSA1                    GDOC.GLOSA2                    GDOC.GLOSA3                    GDOC.GLOSA4                    "TOTAL:"                       ]"SON : "+NUMERO(GDOC->IMPTOT,2,1)+" "+IIF(GDOC->CODMON=1,"NUEVOS SOLES","DOLARES AMERICANOS")                                     "@I"                           "(SALVO ERROR U OMISION)"      "@I"                           "=============="               "--------------"               	CFGGLOANO                      "@I"