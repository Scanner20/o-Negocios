CREATE SQL VIEW v_notas_eeff_presupuesto AS  ;
SELECT Cbdnpres.nota, Cbdnpres.codcta, Cbdmctas.nomcta, Cbdnpres.signo,;
  Cbdnpres.forma, Cbdnpres.ctapre, Cbdnpres.codaux, Cbdtpres.nroitm,;
  Cbdnpres.rubro;
 FROM ;
     cia001!CBDTPRES ;
    INNER JOIN  cia001!CBDNPRES ;
    LEFT OUTER JOIN CBDMCTAS ;
   ON  Cbdnpres.codcta = Cbdmctas.codcta ;
   ON  Cbdtpres.rubro = Cbdnpres.rubro;
   AND  Cbdtpres.nota = Cbdnpres.nota;
 ORDER BY Cbdnpres.rubro, Cbdnpres.nota
