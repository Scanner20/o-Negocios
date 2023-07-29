*!*	Serializable VFP object to XML
*!*	Very simple, no help

*!*	Using:
*!*	Where? Anywhere in your program.
*!*	What time? If your program can be crash and you need save object with properties and values.

LOCAL lcPath,loSO,lcFile,loXX
lcPath=JUSTPATH(SYS(16))+"\"

SET PROCEDURE TO (lcPath+"serializableobject.prg")

loSO=CREATEOBJECT("_SerializableObject2XML")
*!*	Method Serializable() return file which containes XML data
lcFile=loSO.Serializable(_screen)
IF !EMPTY(lcFile)
   MODIFY FILE (lcFile) 
   DELETE FILE (lcFile)
ENDIF

*!*	Or You can send file name to method Serializable()
loSO=CREATEOBJECT("_SerializableObject2XML")
loXX=CREATEOBJECT("Collection")
loForm=CREATEOBJECT("FORM")
loForm.AddProperty("testNULL",.NULL.)
loXX.Add(loForm,"ss")
loXX.Add(_screen,"dd")
loXX.Add(45127,"ee")
lcFile=SYS(2023)+"\MyFile.xml"
lcFile=loSO.Serializable(loXX,lcFile)

IF !EMPTY(lcFile)
   MODIFY FILE (lcFile) 
   DELETE FILE (lcFile)
ENDIF


loSO=CREATEOBJECT("_SerializableObject2XML")
loSO.lShowChangedProperties=.T. 
lcFile=loSO.Serializable(loXX,lcFile)

IF !EMPTY(lcFile)
   MODIFY FILE (lcFile) 
   DELETE FILE (lcFile)
ENDIF

SET PROCEDURE TO 


