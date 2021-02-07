LcUrl="https://www.vnbackoffice.ccal.com.pe/InterfacesWebAmex/InterfacesWeb.svc?wsdl"
Local loClasePrueba4 As "XML Web Service"
Local loException, lcErrorMsg, loWSHandler
TRY
loWSHandler = Newobject("WSHandler",Iif(Version(2)=0,"",Home()+"FFC\")+"_ws3client.vcx")
loClasePrueba4 = loWSHandler.SetupClient(LcUrl,"InterfacesWeb", "InterfacesWeb")
SET STEP on
If Vartype(loClasePrueba4)="O"
	lcXML=loClasePrueba4.ProcPrueba4()
	Local Xmla As Xmladapter
	Xmla=Createobject('xmladapter')
	Xmla.ReleaseXML(.T.)
	Xmla.LoadXML(lcXML,.F.)
	For iLoop = 1 To Xmla.Tables.Count
	lcAlias = Xmla.Tables.Item(iLoop).Alias
	If Used(lcAlias)
	Use In (lcAlias)
	Endif
	Xmla.Tables.Item(iLoop).ToCursor()
	Select(lcAlias)
	Browse
	Endfor
Endif
Catch To loException
	lcErrorMsg="Error: "+Transform(loException.Errorno)+" -
	"+loException.Message"
	Do Case
	Case Vartype(loClasePrueba4)#"O"
	* Handle SOAP error connecting to web service
	Case !Empty(loClasePrueba4.FaultCode)
	* Handle SOAP error calling method
	lcErrorMsg=lcErrorMsg+Chr(13)+loClasePrueba4.Detail
	Otherwise
	* Handle other error
	Endcase
	Messagebox(lcErrorMsg)
Finally
Endtry