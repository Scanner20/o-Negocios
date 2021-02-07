* Funcion que devuelve .T. si existe algun
* saldo por despachar
SELE RPED
SEEK VPED->NroDoc
SCAN WHILE NroDoc = VPED->NroDoc
   IF CanPed-CanDes > 0
      RETURN .T.
   ENDIF
ENDSCAN
RETURN .F.
