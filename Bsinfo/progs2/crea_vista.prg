*!*	SET DATABASE TO P0012002
*!*	CREATE VIEW v_materiales_x_almacen as ;
*!*	 SELECT Almcatal.subalm, Almcatal.codmat, Almcatge.desmat, ;
*!*	 Almcatge.undstk, Almcatal.stkact  FROM  p0012002!almcatal ; 
*!*	 INNER JOIN p0012002!almcatge  ;
*!*	 ON  Almcatal.codmat = Almcatge.codmat  ; 
*!*	 ORDER BY Almcatal.subalm, Almcatal.codmat


*!*	 CREATE VIEW v_cultivos_x_lote  as ;
*!*	 SELECT Cpicuxlt.codsed, Cpicuxlt.codlote, Cpicuxlt.codcult, ;
*!*	   Cpiculti.descult  FROM  p0012002!cpiculti ; 
*!*	   INNER JOIN p0012002!cpicuxlt    ;
*!*	    ON  Cpiculti.codcult = Cpicuxlt.codcult
*!*	    

*!*	CREATE VIEW v_materiales_x_almacen_2  as ;
*!*	SELECT V_materiales_x_almacen.subalm, Almtalma.dessub, ;
*!*	   V_materiales_x_almacen.codmat, V_materiales_x_almacen.desmat, ;
*!*	     V_materiales_x_almacen.undstk, V_materiales_x_almacen.stkact ;
*!*	      FROM  cia001!almtalma INNER JOIN p0012002!v_materiales_x_almacen  ;
*!*	         ON  Almtalma.subalm = V_materiales_x_almacen.subalm    
         
         
SET DATABASE TO  CIA001
*!*	CREATE VIEW v_materiales_x_almacen_2 as ;
*!*	SELECT V_materiales_x_almacen.subalm, Almtalma.dessub, ;
*!*	   V_materiales_x_almacen.codmat, V_materiales_x_almacen.desmat,  ;
*!*	 V_materiales_x_almacen.undstk, V_materiales_x_almacen.stkact  ;
*!*	 FROM  cia001!almtalma INNER JOIN p0012002!v_materiales_x_almacen  ;
*!*	   ON  Almtalma.subalm = V_materiales_x_almacen.subalm


CREATE VIEW v_actividades_x_fase_proc  as ;
SELECT Cpiacxpr.codfase, Cpiacxpr.codprocs, Cpiacxpr.codactiv, ;
 Cpiactiv.desactiv FROM  cia001!cpiactiv ;
INNER JOIN cia001!cpiacxpr    ON  Cpiactiv.codactiv = Cpiacxpr.codactiv

*** 
CREATE VIEW v_unidades_equivalencias as ;
SELECT Almtgsis.tabla, Almtgsis.codigo, Almequni.undvta, Almequni.facequ,  ;
 Almequni.undstk, Almequni.desvta  FROM  cia001!almtgsis ;
 INNER JOIN cia001!almequni ;
    ON  Almtgsis.codigo = Almequni.undstk  WHERE Almtgsis.tabla+Almtgsis.Codigo = "UD"

CREATE VIEW V_DOCUMENTOS_X_COBRAR  as ;
SELECT upper(tpodoc) as TpoDoc, ; 
 Ccbrgdoc.coddoc, Ccbrgdoc.nrodoc,  Ccbrgdoc.nomcli, ;
 Ccbrgdoc.fchdoc, Ccbrgdoc.imptot, ;
  IIF(codmon=1,"S/.",IIF(codmon=2,"US$",SPACE(3))) AS mon ;
 FROM cia001!ccbrgdoc ;
 ORDER BY Ccbrgdoc.coddoc, Ccbrgdoc.nrodoc         

SET DATABASE TO admin
CREATE VIEW v_distrito_x_zona  as ;
SELECT Distritos.coddist, Distritos.desdist, Distritos.codzona,  ;
  Zonas.deszona  FROM  distritos ; 
  INNER JOIN zonas     ON  Distritos.codzona = Zonas.codzona