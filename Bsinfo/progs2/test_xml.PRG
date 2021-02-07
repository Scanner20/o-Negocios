PUBLIC LcXml
LcXml=''
USE h:\o-negocios\aromas\data\ccbtbdoc
CURSORTOXML("ccbtbdoc","lcXML",1,32)
*STRTOFILE(lcXML,"customer.xml")
STRTOFILE(STRCONV(lcXML,9),"customer.xml")
XMLTOCURSOR("customer.xml","curCustomer",512)
RETURN


