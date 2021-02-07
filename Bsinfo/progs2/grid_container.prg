oFrm = Createobject("myForm")
oFrm.AddObject("mGrid","myGrid")
oFrm.mGrid.column1.Width= 400
oFrm.mGrid.column1.AddObject("mycontain","myContain")
oFrm.mGrid.column1.Sparse= .F.
oFrm.mGrid.column1.CurrentControl="myContain"
oFrm.Show(1)

Define Class myForm As Form
   Width = 400
   Procedure Load
       Create Cursor mCur (Name c(10),dir c(10),Tel c(10))
       Insert Into mCur (Name,dir,Tel);
           Values ("Mike","123","555 1212")
       Insert Into mCur (Name,dir,Tel);
           Values ("John","321","555 1232")
       Insert Into mCur (Name,dir,Tel);
           Values ("Frank","111","555 5432")
       Insert Into mCur (Name,dir,Tel);
           Values ("Marie","984","555 8587")
       Insert Into mCur (Name,dir,Tel);
           Values ("Peter","827","555 3958")
       Go Top
   EndProc
EndDefine 

Define Class myGrid As Grid
   ColumnCount = 1
   Width = 400
   Height = 200
   Visible = .T.
   RowHeight = 100
EndDefine 

Define Class mycontain As Container
   Visible = .T.
   Width = 346
   Height = 96
   Name = "mycontain"

    Add Object text1 As TextBox With ;
       HEIGHT = 23, ;
       LEFT = 12, ;
       TOP = 7, ;
       WIDTH = 204, ;
       NAME = "Text1",;
       CONTROLSOURCE="mCur.name"

   Add Object text2 As TextBox With ;
        HEIGHT = 23, ;
       LEFT = 12, ;
       TOP = 36, ;
       WIDTH = 204, ;
       NAME = "Text2",;
       CONTROLSOURCE="mCur.dir"

    Add Object text3 As TextBox With ;
       HEIGHT = 23, ;
       LEFT = 12, ;
       TOP = 62, ;
       WIDTH = 204, ;
       NAME = "Text3",;
       CONTROLSOURCE="mCur.Tel"

    Add Object label1 As Label With ;
       CAPTION = "Nombre", ;
       HEIGHT = 17, ;
       LEFT = 228, ;
       TOP = 12, ;
       WIDTH = 40, ;
       NAME = "Label1"

    Add Object label2 As Label With ;
       AUTOSIZE = .T., ;
       CAPTION = "Dirección", ;
       HEIGHT = 17, ;
       LEFT = 228, ;
       TOP = 36, ;
       WIDTH = 48, ;
       NAME = "Label2"

    Add Object label3 As Label With ;
       CAPTION = "Teléfono", ;
       HEIGHT = 17, ;
       LEFT = 228, ;
       TOP = 60, ;
       WIDTH = 40, ;
       NAME = "Label3"
EndDefine 
