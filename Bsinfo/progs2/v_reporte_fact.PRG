SELECT Ccbrgdoc.coddoc, Ccbrgdoc.nrodoc, Ccbrgdoc.tpodoc,;
  Ccbrgdoc.fchdoc, Ccbrgdoc.codcli, Ccbrgdoc.nomcli, Ccbrgdoc.coddire,;
  Ccbrgdoc.dircli, Ccbrgdoc.cndpgo, Ccbrgdoc.diavto, Ccbrgdoc.ruccli,;
  Ccbrgdoc.codmon, Ccbrgdoc.tpocmb, Ccbrgdoc.impbto, Ccbrgdoc.pordto,;
  Ccbrgdoc.impdto, Ccbrgdoc.impint, Ccbrgdoc.impgas, Ccbrgdoc.impnet,;
  Ccbrgdoc.impadm, Ccbrgdoc.porigv, Ccbrgdoc.impigv, Ccbrgdoc.imptot,;
  Ccbrgdoc.fchvto, Ccbrgdoc.glodoc, Ccbrgdoc.codref, Ccbrgdoc.nroref,;
  Ccbrgdoc.nroped, Ccbrgdoc.glosa1, Ccbrgdoc.glosa2, Ccbrgdoc.glosa3,;
  Ccbrgdoc.glosa4, Ccbrgdoc.codzon, Ccbrgdoc.codven, Vtaritem.codmat,;
  Vtaritem.desmat, Vtaritem.undvta, Vtaritem.preuni, Vtaritem.canfac,;
  Vtaritem.implin, Vtaritem.facequ, Vtaritem.d1, Vtaritem.d2, Vtaritem.d3,;
  Cbdmauxi.nomaux, Ccbrgdoc.nroo_c, Ccbrgdoc.tpovta, Ccbrgdoc.impflt,;
  Ccbrgdoc.impseg, Ccbrgdoc.destino, Ccbrgdoc.via;
 FROM ;
     CIA001!cbdmauxi,;
    CIA001!cctcdire,;
    CIA001!ccbrgdoc ;
    LEFT OUTER JOIN CIA001!vtaritem ;
   ON  Ccbrgdoc.coddoc = Vtaritem.coddoc;
   AND  Ccbrgdoc.nrodoc = Vtaritem.nrodoc;
 WHERE ( (  Cbdmauxi.codaux = Ccbrgdoc.codven;
   AND  Ccbrgdoc.coddire = Cctcdire.coddire );
   AND  Cctcdire.codaux = Ccbrgdoc.codcli );
   AND  ( ( (  Ccbrgdoc.coddoc = ( ?_CodDOc );
   AND  Ccbrgdoc.nrodoc = ( ?_NroDoc ) );
   AND  Cbdmauxi.clfaux = ( ?GsClfVen ) );
   AND  Cctcdire.clfaux = ( ?GsClfCli ) );
 ORDER BY Ccbrgdoc.tpodoc, Ccbrgdoc.coddoc, Ccbrgdoc.nrodoc
 
 SELECT Ccbrgdoc.coddoc, Ccbrgdoc.nrodoc, Ccbrgdoc.tpodoc,;
  Ccbrgdoc.fchdoc, Ccbrgdoc.codcli, Ccbrgdoc.nomcli, Ccbrgdoc.coddire,;
  Ccbrgdoc.dircli, Ccbrgdoc.cndpgo, Ccbrgdoc.diavto, Ccbrgdoc.ruccli,;
  Ccbrgdoc.codmon, Ccbrgdoc.tpocmb, Ccbrgdoc.impbto, Ccbrgdoc.pordto,;
  Ccbrgdoc.impdto, Ccbrgdoc.impint, Ccbrgdoc.impgas, Ccbrgdoc.impnet,;
  Ccbrgdoc.impadm, Ccbrgdoc.porigv, Ccbrgdoc.impigv, Ccbrgdoc.imptot,;
  Ccbrgdoc.fchvto, Ccbrgdoc.glodoc, Ccbrgdoc.codref, Ccbrgdoc.nroref,;
  Ccbrgdoc.nroped, Ccbrgdoc.glosa1, Ccbrgdoc.glosa2, Ccbrgdoc.glosa3,;
  Ccbrgdoc.glosa4, Ccbrgdoc.codzon, Ccbrgdoc.codven, Vtaritem.codmat,;
  Vtaritem.desmat, Vtaritem.undvta, Vtaritem.preuni, Vtaritem.canfac,;
  Vtaritem.implin, Vtaritem.facequ, Vtaritem.d1, Vtaritem.d2, Vtaritem.d3,;
  Ccbrgdoc.nroo_c, Ccbrgdoc.tpovta, Ccbrgdoc.impflt,;
  Ccbrgdoc.impseg, Ccbrgdoc.destino, Ccbrgdoc.via,Cbdmauxi.NomAux,cctcdire.desdire;
 FROM  CIA001!ccbrgdoc ;
    LEFT OUTER JOIN CIA001!vtaritem ;
   ON  Ccbrgdoc.coddoc = Vtaritem.coddoc;
   AND  Ccbrgdoc.nrodoc = Vtaritem.nrodoc;
 	LEFT OUTER JOIN cbdmauxi ON cbdmauxi.clfaux+cbdmauxi.codaux=gsclfven+ccbrgdoc.codven ;
	left outer join cctcdire on cctcdire.clfaux+cctcdire.codaux=gsclfcli+ccbrgdoc.codcli ;
 	where ccbrgdoc.CodDoc+ccbrgdoc.Nrodoc = ?_Coddoc+?_NroDoc
 	
 	      