** VETT  18/03/11 12:50:07 : EJEMPLO DE FORMA DE USO 
*!*		thisform.LockScreen = .T.
*!*		IF thisform.ObjRefTran.XcFlgEst = 'A'
*!*			thisform.ObjCntPage.Deshabilita
*!*			thisform.hABilita_pagina(.F.,2)
*!*			thisform.hABilita_pagina(.F.,3)
*!*			thisform.hABilita_pagina(.F.,4)
*!*		ELSE
*!*			thisform.hABilita_pagina(.T.,2)
*!*			thisform.hABilita_pagina(.T.,3)
*!*			thisform.hABilita_pagina(.T.,4)
*!*		ENDIF
*!*		thisform.LockScreen = .F.
*!*	-------------------------------------------------------------------------------


parameter lHabilita,nNumPag
with this.pgfDetalle.Pages(nNumPag)
	IF lHabilita
		for i = 1 to .ControlCount
			.Controls(i).Enabled  = lHabilita AND thisform.xReturn<>'E' && AND !thisform.lnavegando
			IF INLIST(UPPER(.Controls(i).Name),'CNTCODCTA')
				do case 
					case Thisform.xReturn$'A'
						.Controls(i).Enabled  = !lHabilita 
					case Thisform.xReturn$'I'
					case Thisform.xReturn$'E'
				ENDcase	
			
			ENDIF
			
		endfor	
	ELSE
		for i = 1 to .ControlCount
			.Controls(i).Enabled  = lHabilita  && AND thisform.xReturn<>'E'
		endfor	
	ENDIF
endwith
