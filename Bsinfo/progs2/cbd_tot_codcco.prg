XnMes = 9
LsCursor = SYS(2015)

SELECT NroMes,;
		rmov.CodCta,;
		LEFT (Cta3.nomcta,20) as Ddescrip_Cta3dig ,;
		LEFT(CTAS.Nomcta,20) as Descripcion_Cuenta,;
		CodCCo,;
		TABL.NomBre as Descripcion_CCosto,;
		rmov.tpomov,;
		Sum(IIF(rmov.tpomov='D',import,0)) AS Tot_Dbe,;
		Sum(IIF(rmov.tpomov='H',import,0)) as tot_hbe ; 
		FROM p0012003!cbdrmovm rmov ;
		INNER JOIN cia001!cbdmtabl TABL ON tabl.tabla+tabl.codigo='03'+rmov.codcco ;
		inner join p0012003!cbdmctas ctas on ctas.codcta=rmov.codcta ;
		INNER JOIN p0012003!cbdmctas cta3 ON  PADR(LEFT(rmov.Codcta,3),LEN(rmov.codcta)) = cta3.codcta ;
		WHERE nromes=TRANSFORM(XnMes,'@L 99') AND !EMPTY(codcco) ; 
		GROUP BY nromes,rmov.codcta,codcco,rmov.tpomov INTO CURSOR (LsCursor)

		SELECT (LsCursor)
		LOCATE
		IF !EOF()
			lcRptTxt	= "Cbd_tot_CodCCO.FRX"
			lcRptGraph	= "Cbd_tot_CodCCO.FRX"
			lcRptDesc	= "Resumen de cuenta por centro costo mensual"
			*
			IF .f.
			   MODI REPORT  Cbd_tot_CodCCO	
			ENDIF
			*
			DO FORM ClaGen_Spool WITH lcRptTxt , lcRptGraph , '1' , 2 , lcRptDesc , 1

		ENDIF
		
		USE IN cbdmctas
		USE IN cbdmtabl
		USE IN cbdrmovm
		USE IN  (LsCursor)
	


		
**				INNER JOIN p0012003!cbdmctas cta3 ON PADR(LEFT(cta3.Codcta,3),LEN(cta3.codcta))== PADR(LEFT(rmov.Codcta,3),LEN(rmov.codcta)) ;