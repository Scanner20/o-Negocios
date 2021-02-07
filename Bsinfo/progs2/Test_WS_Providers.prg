LOCAL oProxy
	
oProxy = CREATEOBJECT("MSSOAP.SoapClient")
oProxy.MSSoapInit("http://www.foxcentral.net/foxcentral.wsdl")

lcXML =  oProxy.GetProviders()
? lcXml
XMLTOCURSOR(lcXML,"xproviders",0)
BROWSE

RELEASE oProxy