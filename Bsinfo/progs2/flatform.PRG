loFrm = CREATEOBJECT('frmMainWindowFocusTaker')
loFrm.Visible = .t.
DEFINE CLASS frmMainWindowFocusTaker AS form
    ShowWindow = 2 && As Top Level Form

    AlwaysOnTop =.t.
    TitleBar = 0
    ControlBox = .f.
    BorderStyle = 0

    Top = 10
    Left = -10
    Height = 1
    width = 1
    MaxHeight = 1
    MaxWidth = 1

    ADD OBJECT cmdClose AS CommandButton
    ADD OBJECT tmrClose AS timer ;
      WITH Interval=100

    PROCEDURE Init
      BINDEVENT(THISFORM.tmrClose,'Timer',THISFORM,'tmrClose_Timer')
      BINDEVENT(THISFORM.cmdClose,'Click',THISFORM,'tmrClose_Timer')
      THISFORM.tmrClose.enabled = .t.
    ENDPROC
    PROCEDURE tmrClose_Timer
      IF thisform.WindowState<>0
        _SCREEN.WindowState = thisform.WindowState
        thisform.WindowState = 0 && normal
      ENDIF
      IF _SCREEN.Visible
        THISFORM.Release
      ENDIF
    ENDPROC
ENDDEFINE
