replace nromes WITH m.NroMes 
replace Nroano WITH m.NroAno && = STR(_ano,4,0)
replace NroReq WITH m.NroReq && = thisform.grdRequ.column1.txtNroReq.Value
replace FchReq WITH  m.FchReq && = thisform.grdRequ.column2.txtFchSol.Value
replace TpoReq  WITH m.TpoReq &&= thisform.grdRequ.column3.cboClaseReq.Value
replace Sede WITH m.Sede && = thisform.grdRequ.column10.cboSede.Value
replace SubAlm WITH m.SubAlm && = thisform.grdRequ.column11.cboSubAlm.Value
replace CodMat WITH m.CodMat && = thisform.grdRequ.column4.txtCodMat.Value
replace DesReq WITH m.DesReq  && = thisform.grdRequ.column5.edtDesReq.Value
replace UndCmp WITH m.UndCmp  && = thisform.grdRequ.column7.txtUndStk.Value
replace CanReq WITH m.CanReq  && = thisform.grdRequ.column6.txtCanReq.Value
replace FchEnt WITH m.FchEnt  && = thisform.grdRequ.column8.txtFchEnt.Value
replace FlgEst WITH m.FlgEst  && = thisform.grdRequ.column9.cboFlgEst.Value
replace PreSug WITH m.PreSug  && = thisform.grdRequ.column12.txtPreSug.Value
replace PreVta WITH m.PreVta  && = thisform.grdRequ.column13.txtPreVta.Value
replace canped WITH m.Canped

SELECT RORD.* FROM RORD INTO CURSOR temporal READWRITE WHERE RORD.NroOrd=XsNroOrd AND RORD.TpoO_C=XcTpoO_C;
					ORDER BY RORD.NroOrd,RORD.NroReq  