   �   !                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              CCBNTASG.DBF                   TASG                           TASG01                         CCBMVTOS.DBF                   VTOS                           VTOS01                         CCBRGDOC.DBF                   GDOC                           GDOC04                         CCBTBDOC.DBF                   TDOC                           BDOC01                         CBDMAUXI.DBF                   AUXI                           AUXI01                         CCBSALDO.DBF                   SLDO                           SLDO01                         CCBNRASG.DBF                   RASG                           RASG01                         ..\TMP\43464325.DBF            TEMPO                          nrodoc                         GsNomCia                       GsDirCia                       "INTERESES DIFERIDOS"          SNOMREP                        "DOCUMENTO"                    "FECHA"                        
"PROFORMA"                     "FECHA"                        "VCMTO."                       "DIAS"                         "LETRA"                        "TOTAL"                        	"INTERES"                      "MES"                          "ACTUAL"                       	"INTERES"                      
"DIFERIDO"                     nrodoc                         IIF(TIPO="1",fdoc,[])          IIF(TIPO="1",fvto,[])          IIF(TIPO="1",dias,[])          T_Int                          "999,999.99"                   t01                            "999,999.99"                   T_int - T01                    "999,999.99"                   t02                            "999,999.99"                   t03                            "999,999.99"                   t04                            "999,999.99"                   t05                            "999,999.99"                   t06                            "999,999.99"                   t07                            "999,999.99"                   LsEncab1                       LsEncab2                       t08                            "999,999.99"                   t09                            "999,999.99"                   t10                            "999,999.99"                   t11                            "999,999.99"                   t12                            "999,999.99"                   	"Fecha :"                      	"Pagina:"                      date()                         _pagENO                        "9999"                         	"Hora  :"                      time()                         *TRAN(XnAno,"9999")+"/"+TRAN(XnMes,"@L ##")                      
"PERIODO:"                     chr(255)                       NLINEAS                        nlineas + 1                    0                              M.T01                          m.t01 + t01                    0                              M.T02                          m.t02 + t02                    0                              M.T03                          m.t03 + t03                    0                              M.T04                          m.t04 + t04                    0                              M.T05                          m.t05 + t05                    0                              M.T06                          m.t06 + t06                    0                              M.T07                          m.t07 + t07                    0                              M.T08                          m.t08 + t08                    0                              M.T09                          m.t09 + t09                    0                              M.T10                          m.t10 + t10                    0                              M.T11                          m.t11 + t11                    0                              M.T12                          m.t12 + t12                    0                              M.T13                          m.t13 + t13                    0                              M.T_INT                        m.t_int + t_int                0