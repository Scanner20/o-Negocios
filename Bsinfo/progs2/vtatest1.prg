oNeg=CREATEOBJECT('dosvr.onegocios')
oneg.abrir_dbfs_vta('FACT')
GO TOP IN DTRA
oneg.XsCodDoc='FACT'
oneg.xscodref=dtra.tporef
oneg.xsnroref=dtra.nroref
oneg.cCursor_d='c_DETA'
oneg.oDatAdm.GenCursor(oneg.cCursor_D ,'VTaritem','ITEM01','TPODOC+CODDOC+NRODOC','X')
oneg.traer_items_g_r()




*******************
PROCEDURE Prueba_01
*******************
_SCREEN.AddObject("oTime","TimerScreen")


* Definicion de la Clase TimerScreen
* Muestra un Reloj en un Wait Window
* Este se actualiza cada un segundo

DEFINE CLASS TimerScreen AS Timer
Interval= 1000
PROCEDURE Timer
WAIT WINDOW (TIME()) nowait
ENDPROC
ENDDEFINE 

PROCEDURE prueba_02
Public oform1 
oform1=Newobject("form1") 
oform1.Show 
Return 
  
Define Class form1 As Form 
    DoCreate = .T. 
    Caption = "Explorador de Archivos" 
    Name = "Form1" 
    Add Object ole1 As OleControl With ; 
        Top = 14, ; 
        Left = 18, ; 
        Height = 200, ; 
        Width = 341, ; 
        Name = "Ole1" ,; 
        OleClass = "Shell.Explorer.2" 
  
    Add Object command1 As CommandButton With ; 
        AutoSize = .T., ; 
        Top = 216, ; 
        Left = 80, ; 
        Height = 27, ; 
        Width = 114, ; 
        Caption = "Mostrar contenido de la carpeta", ; 
        Name = "Command1" 
    
    Procedure Init 
        This.ole1.Object.Navigate2("c:") 
    EndProc 
  
    Procedure command1.Click 
        Local cDir 
        cDir = Getdir(",",",2) 
        Thisform.ole1.Navigate2(cDir) 
    EndProc 
EndDefine 

PROCEDURE prueba_03
oWSH = Createobject("WScript.Network")
oImp = oWSH.EnumPrinterConnections()

For i=1 To oImp.Count-1
   ?oImp.Item(i)
Endfor

PROCEDURE prueba_04
Public oTbr
oTbr = Createobject("MyToolBar")
oTbr.Visible = .T.


Define Class MyToolBar As Toolbar
   Caption = "Sync toolbar with menu"
   Add Object cmd1 As CommandButton With;
       caption = "File New"

   Add Object cmd2 As CommandButton With;
       caption = "File Menu"

   Add Object cmd3 As CommandButton With;
       caption = "Spell Check"

   Add Object cmd4 As CommandButton With;
       caption = "Help Search"

   Procedure cmd1.Click
       Keyboard "{ctrl+n}"
   Endproc

    Procedure cmd2.Click
       Keyboard "{alt+f}"
   Endproc

   Procedure cmd3.Click
       Keyboard "{alt+t}S"
   Endproc

    Procedure cmd4.Click
       Keyboard "{alt+h}s"
   Endproc

Enddefine


PROCEDURE prueba_05
LOCAL o
o = Createobject("myform")
o.Show(1)

Define Class myform As Form
   DoCreate = .T.
   DataSession = 2
   AutoCenter = .T.
   Caption = "Trabajando con DyamicBackGround"
   Width = 600
   Height = 400
   MinHeight = 300
   MinWidth = 300
   Add Object grid1 As Grid With ;
       HEIGHT = This.Height, ;
       WIDTH = This.Width, ;
       DELETEMARK = .F. 

   Procedure Load
        Select * From (_samples+"datacustomer") ;
           Order By MaxOrdAmt Desc;
                     Into Cursor TmpCust
      Use In "customer"
   EndProc

   Procedure Init
        This.grid1.SetAll("dynamicbackcolor",;
                            "Thisform.GetBackColor(allt(country))")
    EndProc 

   Procedure Resize
        This.grid1.Width= This.Width
      This.grid1.Height= This.Height
   EndProc 

   Function GetBackColor(cCountry)
        Local nColor
       Do Case
           Case cCountry == "Germany"
               nColor = Rgb(255,255,255)
           Case cCountry == "UK"
               nColor = Rgb(224,224,0)
           Case cCountry == "Sweden"
               nColor = Rgb(224,224,160)
           Case cCountry == "France"
               nColor = Rgb(100,224,160)
           Case cCountry == "Spain"
               nColor = Rgb(100,224,160)
           Otherwise
               nColor = Rgb(224,100,224)
       EndCase 
       Return nColor
   EndFunc 
EndDefine 

PROCEDURE prueba_06
oForm = Createobject("MiForm")
oForm.Show(1)
Read Events

Define Class MiToolBar As Toolbar
   Caption = "Toolbar"
   Height = 28
   Left = 0
   Top = 0
    Width = 55
   ShowWindow = 1
   Name = "EjemToolBar"
   Add Object Cmd1 As CommandButton With ;
       Top = 3, ;
       Left = 5, ;
        Height = 22, ;
       Width = 23, ;
       Caption = "", ;
       Name = "Cmd1"
    Add Object Cmd2 As CommandButton With ;
       Top = 3, ;
       Left = 27, ;
       Height = 22, ;
        Width = 23, ;
       Caption = "", ;
       Name = "Cmd2"
   Add Object Cmd3 As CommandButton With ;
       Top = 3, ;
       Left = 27, ;
       Height = 22, ;
       Width = 23, ;
       Caption = "", ;
       Name = "Cmd3"
EndDefine

Define Class MiForm As Form
   ShowWindow = 2
   Procedure Activate
       If Type("THIS.oToolbar.Name") <> "C"
           This.AddProperty("oToolbar", .Null.)
            This.oToolbar = Createobject("MiToolBar")
           This.oToolbar.Dock(0)
           This.oToolbar.Show()
       EndIf 
   EndProc 
EndDefine 

PROCEDURE prueba_07
oPlayer = CreateObject("WMPlayer.OCX") 
oPlayer.URL = GetFile("mp3;wav;mid;snd;midi;au") 
  
INKEY(3, "H")
=MessageBox("Terminado")


PROCEDURE prueba_08
lcOldDBC = "NOMBREBASEDATOS"
lcNewDBC = "NUEVONOMBRE"
RenDbc(m.lcOldDBC, m.lcNewDBC)

Function RenDbc 
    Lparameters OldName, NewName 
    Open Data (OldName)
    lnTables=Adbobject(arrTables,"TABLE") 
  
    For ix=1 To lnTables
         lcTable = arrTables[ix]+".DBF"
     ;    handle=Fopen(lcTable,12) 
     =Fseek(handle,8,0)
        lnLowByte = Asc(Fread(handle,1))
       lnHighByte = Asc(Fread(handle,1))*256 
        lnBackLinkstart = lnHighByte + lnLowByte - 263 
    = Fseek (handle,lnBackLinkstart,0)
        Fwrite(handle,Forceext(NewName,"dbc" )+Replicate(Chr(0),263),263)
         =Fclose(handle) 
    Endfor 
    Close Data All

    Rename (Forceext(OldName,"dbc"))To (Forceext(NewName,"dbc"))
     Rename(Forceext(OldName,"dcx"))To (Forceext(NewName,"dcx"))
    Rename(Forceext(OldName,"dct"))To (Forceext(NewName,"dct")) 
Endfunc

PROCEDURE prueba_09
oVoz = CreateObject("SAPI.SpVoice") 
oVoz.Speak("Visual fox Pro") 
oVoz.Speak("Alessandra  I want my Pizza Hut")
oVoz.Speak("Alessandra  I want my Pizza Hut")
oVoz.Speak("Alessandra  I want my Pizza Hut")
oVoz.Speak("Alessandra  I want my Pizza Hut")
oVoz.Speak("Jane go to sleep")
oVoz.Speak("Jane go to sleep")
oVoz.Speak("Jane go to sleep")
oVoz.Speak("Jane go to sleep")

PROCEDURE prueba_10
Public oForm

oForm =Createobject("Form")

Set Talk Off

With oForm
    .Caption="" 
    .AutoCenter= .T.
    .Width= 375 
    .Height= 31 
    .Visible= .T.
   .ControlBox= .F.
    .AddObject("oBarra","OleControl","mscomctllib.progctrl.2")
  
    With .oBarra
       .Visible= .T.
        .Left= 4
        .Top= 5
        .Width= 368
       .Height= 20 
        .Min= 1
    Endwith
Endwith
Create Cursor MiTabla (Campo C(12))

For i = 1To 10000
    Append Blank
Endfor
 
nTotReg = Reccount("MiTabla") 
Locate 
oForm.oBarra.Max= nTotReg
Index On Progreso(Campo, Recno(), nTotReg) Tag Campo
oForm.Release 

Function Progreso(Campo, nRecno, nTotReg)

    cProg = Transform(Round((nRecno/nTotReg)*100,0)) + "%" 
    oForm.Caption="Progreso " + cProg
nbsp;   oForm.oBarra.Value= nRecno 
    Return Campo 
Endfunc

PROCEDURE prueba_11 
**En el AfteRowColchange del Grid digita lo siguiente:

Lparameters nColIndex

Thisform. LockScreen = .T.
This.Columns(1).ColumnOrder =This. LeftColumn
Thisform.LockScreen = .T.
** Y en el Scrolled del Grid esto :

Lparameters nDirection

Thisform. LockScreen= .T. 
If nDirection > 3 
This .Columns(1). ColumnOrder = This.LeftColumn
Endif
Thisform.LockScreen= .F.

**OTRA FORMA

** En el AfteRowColchange del Grid digita lo siguiente:

nPos =This. ActiveColumn-This.RelativeColumn

If nPos>0
This.COlumn1.ColumnOrder=nPos+1 
Else
This.COlumn1.ColumnOrder=1
Endif

PROCEDURE prueba_12

**Este truco te explica cual es la secuencia escape que debes enviar a la impresora Epson (TMU) para que corte el papel.

Set Console Off 
Set Device To Printer 
Set Printer To Name NombreDeImpresora 
Set Print On
??? Chr(27)+"m"&& Corta el Papel

Set Print Off
Set Device To Screen 
Set Printer To
Set Console On


PROCEDURE prueba_13
**Puedes mapear una unidad de disco de diferentes formas ... en este ejemplo se utiliza WSH (Windows Script Host).

oWSH = CREATEOBJECT("Wscript.Network") 
oWSH.MapNetworkDrive("P:", "servercarpeta")
Release oWSH


PROCEDURE prueba_14

**Una forma sencilla de conocer toda la información del procesador de nuestro PC.

? "Número de CPUs: " + GETENV("NUMBER_OF_PROCESSORS")+CHR(13) 
? "Arquitectura del Procesador: " +GETENV("PROCESSOR_ARCHITECTURE")+CHR(13) 
? "Identificador del Procesador Identifier: " +GETENV("PROCESSOR_IDENTIFIER")+CHR(13)
? "Nivel del Procesador: " +GETENV("PROCESSOR_LEVEL")+CHR(13) 
? "Revisión del Procesador Revision: " +GETENV("PROCESSOR_REVISION")+CHR(13)


PROCEDURE prueba_15

Set Classlib To Home(1) + "ffc\_agent.vcx" Additive

oAgent = Createobject( "_Agent")

With oAgent
    . Load("Merlin","merlin.acs")
     .setActiveAgent(" Merlin")
    . Show(Rand() * 400, Rand() * 400) 
    .speak("Bienvenidos...") 
    .speak("Esta es una prueba") 
Endwith

PROCEDURE p_16
**Para detenerlo

?oshell.ServiceStop("mysql", .T.)

**Para iniciarlo

?oshell.ServiceStart("mysql", .T.)

** Para eso solo debes pasarle el nombre del servicio, en este caso quiero saber si MYSQL esta corriendo actualmente en Windows.

oshell = CREATEOBJECT("Shell.Application")
? oshell.IsServiceRunning("mysql")

PROCEDURE p_17
** Existen diversas formas de conocer que sistema operativo utilizas; está es una forma sencilla pero bastante buena.

cOsx = Os(1)

cSistema = ""

Do Case
    Case "6.00" $ cOsx 
          cSistema = "LongHorn" 
     Case "5.02" $ cOsx 
         cSistema = "2003"
    Case "5.01" $ cOsx 
         cSistema = "XP"
    Case "5.0" $ cOsx 
         cSistema = "2000"
    Case "NT" $ cOsx 
         cSistema = "NT" 
    Case "4.1" $ cOsx 
         cSistema = "98"
    Case"4.9" $ cOsx
        cSistema = "ME"
    Case "4.0" $ cOsx Or "3.9" $ cOsx 
        cSistema = "95" 
    Case "3." $ cOsx 
        cSistema = "3.1"
Endcase
? "Windows " + cSistema

PROCEDURE p_18
If nKeyCode = 13 >Then && Enter
    lExists = .F.
    For i = 1To This. ListCount
         If Upper(This.ListItem<(i))= Upper(Alltrim( This.DisplayValue))
              lExists = .T. 
            Exit 
         Endif
    Endfor 
 
    If Not lExists 
        This.AddItem( This.DisplayValue)
         Wait Window "Agregado" 
     Else 
         Wait Window "Existente"
    Endif
Endif


PROCEDURE p_19
Local loserver, lnCounter, loBackupDevice

loserver=Createobject("SQLDMO.SqlServer")
loserver.Connect("MiServidor","MiUserName","MiPassword")

If loserver.BackupDevices.Count = 0
       loBackupDevice = Createobject("SQLDMO.BackupDevice")
       With loBackupDevice
             .Name = "MiNuevoBackup"
             .PhysicalLocation = "C:\MisBackups\BackupFile.bak"
             .Type = 2 && SQLDMODevice_DiskDump
      Endwith
      loserver.BackupDevices.Add(loBackupDevice)
Else
      For lnCounter = 1 To loserver.BackupDevices.Count
          ? loserver.BackupDevices(lnCounter).PhysicalLocation
      Next lnCounter
Endif

PROCEDURE p_20  

** Este truco te permite conocer la velocidad y tipo de procesador que
** tienes instalado en tu PC .... utiliza WMI, es un nueva herramienta de administración incorporada en las nuevas versiones de Windows.

objWMIService = Getobject("winmgmts:\\")
colItems = objWMIService.ExecQuery("Select * from Win32_Processor",,48)

For Each objItem In colItems
     ? objItem.Name
     ?objItem.CurrentClockSpeed
Next

PROCEDURE P_21
** Esta es una forma de iniciar el servidor de SQL Server MSDE a través
**  de SQLDMO.

oSvr = CreateObject("SQLDMO.SQLServer")
oSvr.LoginTimeout = 60 
oSvr.Start ( .T., "(local)", "sa", "")

Los parámetros pasados al método START son:

.T. = Modo de inicio.

(local) = Servidor 

sa = nombre de usuario (sa es el usuario por defecto)

"" = clave o password ("" es la clave por defecto para el usuario sa)

PROCEDURE P_22
** Excelente truquito que te permite determinar si Internet Information Server IIS esta instalado en tu PC.

oIIS = GetObject("IIS://localhost")
If Vartype(oIIS) = "O"
Wait window "Internet Information Server IIS esta instalado"
EndIf
  
**************
PROCEDURE p_23
**************

** Este es un ejemplo básico de como crear un treeview agregarle nodos, expandirlo y darle formato a un nodo especifico

#Define tvwFirst 0
#Define tvwLast 1
#Define tvwNext 2
#Define tvwPrevious 3
#Define tvwChild 4

oForm = Createobject('myForm')
oForm.Caption = "Ejemplo de Treeview"
With oForm
      With .Tree
          .Left = 10
          .Top = 10
          .Width = 300
          .Height = 200
          .Nodes.Add(,tvwFirst,"root0",'Main node 0')
          .Nodes.Add(,tvwFirst,"root1",'Main node 1')
          .Nodes.Add(,tvwFirst,"root2",'Main node 2')

         .Nodes.Add('root1',tvwChild,"child11",'Child11')
         .Nodes.Add('root1',tvwChild,"child12",'Child12')

         .Nodes.Add('root2',tvwChild,"child23",'Child23')

         .Nodes.Add('child11',tvwChild,"child113",'child113')
          With .Nodes.Add('child113',tvwPrevious,"child112",'child112')
               .Bold=.T.
          Endwith
          With .Nodes.Add('child112',tvwPrevious,"child111",'child111')
               .Bold = .T.
          Endwith

          With .Nodes.Add('child23',tvwPrevious,"child22",'Child22')
               .Bold=.T.
          Endwith

          With .Nodes.Add('child22',tvwPrevious,"child21",'Child21')
               .Bold=.T.
          Endwith

          For Each oNode In .Nodes
                oNode.Expanded = .T.
          Endfor
      Endwith
.Show()
Endwith
Read Events


Define Class myForm As Form
         Add Object Tree As OleControl With ;
         Name = 'Tree',OleClass='MSComCtlLib.TreeCtrl'

         Procedure Init
              With This.Tree
                   .linestyle = 1
                   .Font.Name = 'Tahoma'
                   .Font.Size = 10
                   .indentation = 5
             Endwith
Endproc

Procedure QueryUnload
             Clear Events
             Endproc
Enddefine

PROCEDURE p_24
** Otra forma de reproducir un archivo de sonido.... esta vez es utilizando WSH para que ejecute el archivo.

cWav = GetFile("WAV")
oWsh = CreateObject("Wscript.Shell")
oWsh.Run("sndrec32 /play /close " + cWav ,0, .T.)

PROCEDURE p_25
** Un buen ejemplo de como utilizar el DatePicker para mostrar el calendario.

oMyform = Create("MiCal")
oMyform.Show
Read Events
Return

Define Class MiCal As Form
      Height = 60
      Caption = "Testing DTPicker"
      AutoCenter = .T.
      MaxButton = .F.
      MinButton = .F.
      AlwaysOnTop = .T.

      Add Object odatetime As odttm With ;
      Width = 85,;
      Top = 5,;
      Height = 25

      Procedure Destroy
            Clear Events
      Endproc
Enddefine


Define Class odttm As OleControl
      OleClass = "MScomctl2.DTPicker.2"
      OleLCID = 1033

      Procedure Init
          This.Left = (Thisform.Width-This.Width) / 2
      Endproc
Enddefine

PROCEDURE P_26
* ORACLEDSN   = Es el nombre del DSN de tu base de datos de Oracle
* USUARIO        = Nombre del usuario de la base de datos
* PASSWORD   = Password del usuario de la base de datos
**************************************

h=SQLConnect("ORACLEDSN","USUARIO","PASSWORD") && Conectarse 

If h > 0
    =SQLExec(h,"{Call MIPROC}") && Ejecuta el procedimiento almacena MIPROC
    =SQLDisconnect(h) && Termina la conexión a la base de datos 
   Wait Window  "Procedimiento ejecutado correctamente"
Else
    Wait Window  "No fue posible realizar la conexión"
ENDIF 

PROCEDURE P_27
** Excelente truco que te devuelve el nombre de todas las base de datos que se encuentran en el servidor de SQL Server utilizando SQLDMO.

oSQLSer = CreateObject("SQLDMO.SQLServer")
oSQLSer.loginSecure = .T. 
oSQLSer.Connect 

For nNumBD = 1 to oSQLSer.Databases.Count
     oDatabse = oSQLSer.Databases(nNumBD)
     ? oDatabse.Name
Next 

PROCEDURE p_28
** WSH te permite agregar impresora .... en este caso se agregara una 
** impresora en red .... los parámetros a pasar son el puerto donde 
** esta conectado la impresora y la ruta de la misma dentro de la red

oWshNetk = CreateObject("WScript.Network")
oWshNet.AddPrinterConnection("LPT1", "\ServerPrint1")

PROCEDURE p_29
Create Cursor filename (cfilename c(128))

omyfiler = Createobject("Filer.FileUtil")

omyfiler.searchpath = "C:" && Ruta de Busqueda
omyfiler.subfolder = 1 && 1 = para incluir subdirectorios. 0 para no
omyfiler.SortBy = 0
omyfiler.Find(0)
Local ncount
ncount = 1

For nfilecount = 1 To omyfiler.Files.Count
If omyfiler.Files.Item(nfilecount).Name = "." Or ;
omyfiler.Files.Item(nfilecount).Name = ".."
Loop
Endif


Append Blank
Replace cfilename WITH Upper(omyfiler.Files.Item(nfilecount).Path)+ ;
UPPER(omyfiler.Files.Item(nfilecount).Name)
Endfor
Browse

PROCEDURE  p_31
Local F, X, Y, U, K

F = Sys(2023) + "" + SubStr(Sys(2015),1,8) + ".txt" 
X = SubStr(sys(0),1, At(" ", Sys(0))-1) 
Run PING &X > &F
Y = FileToStr(F)
Delete File &F
U = At("[", Y) + 1 
K = At("]", Y)
? SubStr(Y,U,K-U)

PROCEDURE p_32
** Cuantas veces no hemos querido saber si ya esta instalado Word, 
** Excel u otra aplicación en el equipo.
** En este ejemplo determinamos si se encuentra instalado Word 
** en el equipo pero puede ser cualquier otra aplicación. 

oWord = createobject("word.application")
IF VARTYPE(oWord) # "O"
     =Messagebox("Word no se encuentra instalado en este equipo")
     return
endif 

PROCEDURE p_33

*!*	Uno de los grandes problemas de VFP son los reportes; pero podemos realizar los reportes en Cristal Report y luego llamarlos desde VFP. No quiero decir con esto que sea mejor, más fácil o más cómodo; simplemente es otra forma de hacerlo y tiene muchas ventajas.

*!*	En los ejemplos que demuestro estoy utilizando la versión 8 del Cristal Report  de Seagate pero considero que se debe comportar igual con las demás versiones.

*!*	Primero veamos como puedo exportar un reporte a extensión .DOC (Word)

oCristalReport = createobject("crystal.crpe.application")
oRepx = oCristalReport.OpenReport("C: eporteventas.RPT")
oRepx.ExportOptions.FormatType = 14   && Formato de Word
oRepx.ExportOptions.DiskFileName = "c: eporteventasdelmes.doc"
oRepx.ExportOptions.DestinationType = 1 && Tipo de Destino a guardar
oRepx.Export(.F.)      && No muestra ningun cuadro de Dialogo 
release oRepx
release oCristalReport 
Los otros formatos en que podemos guardar los reportes son:

*!*	Extensión           FormatType

*!*	   RTF                           4

*!*	EXCEL 7               27 o 28

*!*	EXCEL 8               29 o 30 
*!*	  
*!*	Para ver en vista previa un reporte: 
oCristalreport = createobject("crystal.crpe.application")
oRep = oCristalreport.OpenReport("C: eporteventas.RPT")
oRep.Preview 
  
*!*	Para mandarlo a imprimir  
oCristalreport = createobject("crystal.crpe.application")
oRep = oCristalreport.OpenReport("C: eporteventas.RPT")
oRep.Printout(.F.)    && .F. no muestra cuadro para configurar impresora  

PROCEDURE p_34

DEFINE WINDOW wAyuda ;
FROM 1,1 TO 5,35 ;
FONT "MS SANS SERIF",8 STYLE "BN" 

** Define la ventana con fuente y estilo

ACTIVATE WINDOW wAyuda 
?"Lo Mejor de VFP"
?"La Web de Davphantom"
WAIT WINDOW "" TIMEOUT 3
RELEASE WINDOWS wAyuda

**Ejemplo No 2

Declare integer Sleep in "kernel32" ;
Long dwMilliseconds

DEFINE WINDOW wAyuda ;
FROM 1,1 TO 3,35 ;
FONT "MS SANS SERIF",8 ;
STYLE "BN" COLOR RGB(255,255,255,0,0,255) 
** Define la ventana con fuente y estilo

ACTIVATE WINDOW wAyuda 
?"Lo Mejor de VFP"
?"La Web de Davphantom"

=sleep(5000)
**WAIT WINDOW TIMEOUT 3
RELEASE WINDOWS wAyuda 

PROCEDURE p35
**Para realizar algunos procesos necesarios de las bases de datos debemos conocer
** los nombres de las tablas contenidas en ella. Por ejemplo a la hora de querer
** reindexar cada tablas de la B. D

OPEN DATABASE c:Ruta_Base_de_Datos.dbc
cNomTablas = ADBOBJECT(infVector, "TABLE")
FOR EACH cNomTablas IN infVector
    ? cNomTablas
ENDFOR

PROCEDURE p_36
** Otro de los temas de bastante consulta es como obtener el Serial de un Disco,
** esta forma es súper sencilla y con poco código.

oFS=CreateObject("scripting.filesystemobject")
? oFS.Drives("c").SerialNumber 
** Una de las formas más sencillas de obtener el serial de fabrica de las unidades de disco. 

objWMI = Getobject("winmgmts:\\")
cCadWMI = "Select * from Win32_PhysicalMedia"
oSistema = objWMI.ExecQuery(cCadWMI)

For Each Disco In oSistema
     ? "Serial de fabrica :" + Disco.SerialNumber
Next

objWMI = Getobject("winmgmts:\\")
cCadWMI = "Select * from Win32_LogicalDisk"
oSistema = objWMI.ExecQuery(cCadWMI)

For Each Disco In oSistema
     ? "Unidad: " + Disco.Name + " Serial: " + Disco.VolumeSerialNumber
Next


PROCEDURE p_40
**Diria Yo que este es de los mejores trucos .... utilizando WMI podemos instalar un servicio en Windows y especificarle todas sus propiedades .... EXCELENTE. Un servicio es una aplicación que corre en background cuando arranca Windows y el usuario no se percata de eso. Para comprobar si el servicio se instala podemos ir a MIPC y hacemos click con el botón derecho del mouse y seleccionamos "Administrar", luego en la parte izquierda de la ventana seleccionamos "Servicios" y allí debe aparecer el servicio que instalaremos.

**Para probar el ejemplo debes copiar un archivo exe a la carpeta system32 de Windows pero podría ser a cualquier carpeta, el nombre del archivo para el ejemplo debe ser PD.EXE ..... podria renombrar el NotePad y probar con el.

OWN_PROCESS = 16
NOT_INTERACTIVE = .F.
ControlError = 2 &&Normal
TipInicio = "Manual"
NomSer = "MiServicio"
NomMostrar = "Nombre para mostrar - MiServicio"
cRutaEXE = "c:\windows\system32\pd.exe"
cIniSesion = "NT AUTHORITY\LocalService"

objWMI = GetObject("winmgmts:\\")
objSer = objWMI.Get("Win32_BaseService")

errRet = objSer.Create(NomSer, NomMostrar, cRutaExe, OWN_PROCESS, ControlError, TipInicio, NOT_INTERACTIVE, cIniSesion, "" )
? errRet
 
PROCEDURE p_41
**Utilizando WMI para apagar un computador.

objWMI = GetObject("winmgmts:\\")
cCadWMI = "Select * from Win32_OperatingSystem"
oBServ = objWMI.ExecQuery(cCadWMI)

For Each Pc in oSys
    Pc.Win32Shutdown(1)
Next

PROCEDURE p_42
**Obtiene el Host y la IP de un equipo a través del API

#Define WSADATA_SIZE 398
#Define WS_VERSION 514
#Define HOSTBUFFER_SIZE 256
#Define HOSTENT_STRUCT_SIZE 16

Do DeclareAPIs

Local lcBuffer, lnResult, lcHostname, lcMessage, lcHostentStruct
lcBuffer = SPACE(WSADATA_SIZE)
lnResult = WSAStartup(WS_VERSION, @lcBuffer)
lcMessage = ""
  


If lnResult = 0
     lcBuffer = Replicate(CHR(0),HOSTBUFFER_SIZE)
     lnResult = gethostname(@lcBuffer,HOSTBUFFER_SIZE)
     
    If lnResult = 0
           lcHostname = STRTRAN(lcBuffer,CHR(0),"")
           lcMessage = "HOST: " + lcHostname + Chr(13)
           lnResult = gethostbyname(lcHostname)
  
       If lnResult != 0
             lcHostentStruct = MemoryBuffer(lnResult, HOSTENT_STRUCT_SIZE)
             lnResult = buf2dword(Substr(lcHostentStruct, 13,4))
           
          If lnResult != 0
                lcMessage = lcMessage + "LOCAL IP ADDRESS: " + IPPortion(lnResult)
          Endif
       Endif
   Endif
  
    If Empty(lcMessage)
          lcMessage = "Lo se pudo obtener Host - IP"
   EndIf 

    Messagebox(lcMessage,64,"Local Host & IP")

   =WSACleanup()
Else
     Messagebox("Error : " + Transform(lnResult))
ENDIF

**************************
PROCEDURE DeclareAPIs
**************************
    Declare Integer WSAStartup In wsock32 Integer wVerRq, String @lpWSAData
    Declare Integer WSACleanup In wsock32
    Declare Integer gethostname In wsock32 String @Name, Integer namelen
    Declare Integer gethostbyname In wsock32 String HostName
    Declare RtlMoveMemory In kernel32 As Heap2Str String @, Integer, Integer
Endproc

**************************
Function IPPortion(nPointer)
**************************
    Local lnAddress, lcResult
    lnAddress = buf2dword(MemoryBuffer(nPointer, 4))
    Return Iif(lnAddress <> 0, JustIP(MemoryBuffer(lnAddress, 4)), "")
Endfunc

**************************
Function JustIP(cBuffer)
**************************
   Local lcResult, lnCounter
   lcResult = ""
  For lnCounter=1 To 4
       lcResult = lcResult + Ltrim(Str(Asc(Substr(cBuffer, lnCounter)))) + Iif(lnCounter=4, "",".")
   Endfor
   Return lcResult
Endfunc

**************************
Function buf2word (cBuffer)
**************************
       Return Asc(Substr(cBuffer, 1,1)) + Asc(Substr(cBuffer, 2,1)) * 256
Endfunc

**************************
Function buf2dword(cBuffer)
**************************
     Return Asc(Substr(cBuffer, 1,1)) + ;
        BitLShift(Asc(Substr(cBuffer, 2,1)), 8) +;
        BitLShift(Asc(Substr(cBuffer, 3,1)), 16) +;
        BitLShift(Asc(Substr(cBuffer, 4,1)), 24)
Endfunc

**************************
Function MemoryBuffer(nAddress, nBuffersize)
**************************
   Local lcBuffer
   lcBuffer = SPACE(nBuffersize)
   = Heap2Str (@lcBuffer, nAddress, nBuffersize)
   Return lcBuffer
Endfunc
  




PROCEDURE p_37
LOCAL objXL, objXLchart, intRotate

objXL = CreateObject("Excel.Application")
objXL.Workbooks.Add
objXL.Cells(1,1).Value = 50
objXL.Cells(1,2).Value = 10
objXL.Cells(1,3).Value = 15
objXL.Range("A1:C1").Select

objXLchart = objXL.Charts.Add()
objXL.Visible = .t.
objXLchart.Type = -4100 

For intRotate = 5 To 180 Step 5
      objXLchart.Rotation = intRotate
Next

For intRotate = 175 To 0 Step -5
      objXLchart.Rotation = intRotate
Next

PROCEDURE p_42
**Un ejemplo como podemos crear tablas en Word con datos de tablas de VFP, a través de Automatización.

USE employee
lcTemp = SYS(2015)+_.txt_

COPY fields empl_id, last_name TO (lcTemp) TYPE csv
  
lnFields = 2
  
_ClipText = chrtran(FileToStr(lcTemp),_"_,__)
  
erase (lcTemp)
  
#define wdSeparateByCommas 2

oWordDocument=createobject("word.application") && Create word object
  
WITH oWordDocument
               .documents.add
         
                WITH .ActiveDocument
                        .Range.Paste
                        .Range.ConvertToTable(wdSeparateByCommas,,lnFields)
                ENDWITH
      
              .visible = .t.
              .Activate
ENDWITH
