** Validacion de cambio de registro en un grid con buffering
WITH This
  IF INLIST( .RowColChange, 1, 3 )
    *** If we are trying to move to a new row
    *** validate the current row
    IF NOT EOF( .RecordSource ) AND RECCOUNT( .RecordSource ) > RECNO( .RecordSource )  
      *** Do not allow the move if the validation fails
      IF NOT .ValidateCurrentRow()
        NODEFAULT
      ENDIF	
    ENDIF
  ENDIF
ENDWITH
