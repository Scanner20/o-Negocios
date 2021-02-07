oForm=CREATEOBJECT('Admvrs.Base_form')

oForm.addobject('CmdSalir','Admgral.CmdSalir')

oform.CmdSalir.Enabled = .t.
oform.CmdSalir.Visible = .t.
WITH oForm.CmdSalir
   .Left = 50  && Command button column
   .Top = 100  && Command button row

ENDWITH
oForm.SHOW  && Display the form
*!*	READ EVENTS  && Start event processing
*!*	CLEAR EVENTS 