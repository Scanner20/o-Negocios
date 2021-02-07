*********************************************************
** Author   : Ramani (Subramanian.G)
**            FoxAcc Software / Winners Software
**            ramani_g@yahoo.com
** Type     : Freeware with reservation to Copyrights
** Warranty : Nothing implied or explicit
*********************************************************
** How to Run..
** 1. Save the following code as gsIncreSearch.PRG
** 2. From the command window run that
**    DO gsIncreSearch
*********************************************************
** gsIncreSearch.prg
*********************************************************
SET DELETED ON
SET EXACT OFF
SET NEAR ON

SELECT company,cust_id FROM HOME(2)+"data\Customer" INTO CURSOR temp
INDEX ON company TAG company
SET ORDER TO company

myFields = "company,cust_id"
=gsFindForm(myFields)
=MESSAGEBOX("You have selected :"+ALLTRIM(company)+" : "+cust_id, 0+16, "Eureka!")

RETURN
**************************************************
PROCEDURE gsFindForm
** The above codes are for example..
** The below code can be copied as gsFindForm.prg
** and you can call the code as shown in above or..
** DO FORM gsFindForm WITH myFields
*************************************************
** PROCEDURE gsFindForm
PARAMETERS tcFields

IF PARAMETERS() < 1
   RETURN .f.
ENDIF

PUBLIC oform1

oform1=NEWOBJECT("gsFindForm",'','',tcFields)
oform1.Show

RELEASE oForm1
RETURN
**************************************************
*-- Form:         gsFindForm
*-- ParentClass:  form
*-- BaseClass:    form
*
DEFINE CLASS gsFindForm AS form

   AutoCenter = .t.
   Height = 242
   Width = 420
   DoCreate = .T.
   Caption = "FindForm"
   Name = "gsFindForm"
   WindowType = 1
   TitleBar = 0
   inrecno = 0
   cFilterOld = ''
   cFilter = ''

   ADD OBJECT label1 AS Label WITH ;
      Top = 192, ;
      Left = 0, ;
      Height = 20, ;
      Width = 60, ;
      Caption = "Search for", ;
      Name = "label1"

   ADD OBJECT txtSearch AS textbox WITH ;
      Top = 192, ;
      Left = 64, ;
      Height = 20, ;
      Width = 240, ;
      Caption = "txtSearch", ;
      Name = "txtSearch"

   ADD OBJECT cmdfirst AS commandbutton WITH ;
      Top = 216, ;
      Left = 0, ;
      Height = 27, ;
      Width = 84, ;
      Caption = "\<First", ;
      Name = "cmdFirst"

   ADD OBJECT cmdprevious AS commandbutton WITH ;
      Top = 216, ;
      Left = 84, ;
      Height = 27, ;
      Width = 84, ;
      Caption = "\<Previous", ;
      Name = "cmdPrevious"

   ADD OBJECT cmdnext AS commandbutton WITH ;
      Top = 216, ;
      Left = 168, ;
      Height = 27, ;
      Width = 84, ;
      Caption = "\<Next", ;
      Name = "cmdNext"

   ADD OBJECT cmdlast AS commandbutton WITH ;
      Top = 216, ;
      Left = 252, ;
      Height = 27, ;
      Width = 84, ;
      Caption = "\<Last", ;
      Name = "cmdLast"

   ADD OBJECT cmdexit AS commandbutton WITH ;
      Top = 216, ;
      Left = 336, ;
      Height = 27, ;
      Width = 84, ;
      Cancel = .T., ;
      Caption = "E\<xit", ;
      Name = "cmdExit"

   ADD OBJECT grid1 AS grid WITH ;
      Height = 192, ;
      Left = 0, ;
      Top = 0, ;
      Width = 432, ;
      DeleteMark = .F., ;
      Name = "Grid1", ;
      HighlightRow = .T., ;
      RecordMark = .f., ;
      ReadOnly = .T., ;
      SCrollBars = 0, ;
      ForeColor = RGB(0,0,0), ;
      BackColor = RGB(255,255,192), ;
      GridLineColor = RGB(0,0,128)

   PROCEDURE Init
      PARAMETERS tcFields
      IF PARAMETERS() < 1
         RETURN .f.
      ENDIF
      LOCAL nCount
      nCount = ALINES(laFields,tcFields,",")
      WITH ThisForm.Grid1
         .ColumnCount = nCount
         FOR I=1 TO nCount
            .Columns(I).ControlSource = laFields(i)
         ENDFOR
         .SetFocus()
      ENDWITH
   ENDPROC


   PROCEDURE txtSearch.InteractiveChange

      LOCAL cFilterOld, cFilterIn
      cFilterOld = ThisForm.cFilterOld
      cFilterIn = KEY()
      SET FILTER TO
      IF LEFT(This.Value,1) = "*"
         IF LEN(ALLTRIM(This.Value)) > 1
            ThisForm.cFilter = ;
            RIGHT(ALLTRIM(This.Value),LEN(ALLTRIM(This.Value))-1)
            IF EMPTY(cFilterOld)
               SET FILTER TO ThisForm.cFilter $ &cFilterIn
            ELSE
               SET FILTER TO &cFilterOld .AND. ;
                   ThisForm.cFilter $ &cFilterIn
            ENDIF
            LOCATE
         ELSE
            IF !EMPTY(cFilterOld)
               SET FILTER TO &cFilterOld
            ENDIF
         ENDIF
      ELSE
         IF !EMPTY(cFilterOld)
            SET FILTER TO &cFilterOld
         ENDIF
         SEEK ALLT(This.Value)
      ENDIF
      ThisForm.Refresh()
      ThisForm.Grid1.SetFocus
      This.SetFocus
   ENDPROC

   PROCEDURE cmdfirst.Click
      GO TOP
      ThisForm.Grid1.SetFocus()
      ThisForm.Refresh()
   ENDPROC

   PROCEDURE cmdprevious.Click
      IF NOT BOF()
         SKIP -1
      ENDIF
      ThisForm.Grid1.SetFocus()
      ThisForm.Refresh()
   ENDPROC

   PROCEDURE cmdnext.Click
      IF NOT EOF()
         SKIP
      ENDIF
      ThisForm.Grid1.SetFocus()
      ThisForm.Refresh()
   ENDPROC

   PROCEDURE cmdlast.Click
      GO BOTTOM
      ThisForm.Grid1.SetFocus()
      ThisForm.Refresh()
   ENDPROC

   PROCEDURE cmdexit.Click
      ThisForm.Release()
   ENDPROC

   PROCEDURE Grid1.AfterRowColChange
      LPARAMETERS nColIndex
      DODEFAULT()
      ThisForm.inRecNo = IIF(EOF() OR BOF(),0,RECNO())
      This.Columns(This.ActiveColumn).Text1.BackColor = RGB(255,0,0)
      This.Columns(This.ActiveColumn).Text1.DisabledBackColor = RGB(32,224,224)
      This.Columns(This.ActiveColumn).Text1.DisabledForeColor = RGB(0,0,0)
      This.Refresh()
      ThisForm.txtSearch.SetFocus()
      RETURN .T.
   ENDPROC

   PROCEDURE Grid1.Init
      DODEFAULT()
      WITH THIS
          .SetAll("DynamicBackColor", ;
            "IIF(recno(This.RecordSource)= " +;
            "ThisForm.inRecno,RGB(32,224,224)," + ;
            "RGB(255,255,192))","COLUMN")
        .SetAll("BackColor", RGB(255,192,192),"Header")
        .SetAll("Alignment", 2, "Header")
      ENDWITH
   ENDPROC

ENDDEFINE
*
*-- EndDefine: form1
**************************************************
** EOF
**************************************************

