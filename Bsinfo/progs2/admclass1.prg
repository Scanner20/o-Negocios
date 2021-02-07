PARAMETERS _classLibRut,_ClassAnt,_ClassNew
SELECT 0
USE (_classLibRut) excl
LnActu = 0
SET FILTER TO _ClassAnt$classloc

SCAN
	LnActu = LnActu + 1
	LnTLen = LEN(ClassLoc)

	LnPos=at(_classant,classloc)
	LnLen=len(_classnew)
	LnDif  = LnTlen - LnPos
	REPLACE classloc WITH stuff(classloc,LnPos,LnLen+LnDif,_classnew)  && '..\vcxs\fpadmvrs.vcx'
ENDSCAN 
USE
WAIT WINDOW TRANSFORM(LnActu,'99,999') + ' Actualizaciones' NOWAIT  