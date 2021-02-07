*-- GetFormRef
*   Busca un formulario abierto según su título o nombre 
*   y devuelve una referencia al mismo. Si no se consiguió
*   el formulario indicado, se devuelve NULL
*
*   Sintáxis:
*   oForm=GetFormRef(cCaption | cName)
*
*   Ejemplo:
*   oClientes=GetFormRef("Maestro de Clientes")
*   if not isnull(oClientes)
*    oClientes.Show()
*   else
*    do form Clientes
*   endif
*
*   Autor:  V. Espina
*   FUM  :  7-NOV-2001
*
PROC GetFormRef(pcCaption)
 *
 *-- Si no hay formas abiertas, se cancela
 *
 if _Screen.FormCount=0
  return NULL
 endif
 
 *-- Se recorren las ventanas abiertas
 *
 local i,oRef
 oRef=NULL
 for i=1 to _Screen.FormCount
  if upper(_Screen.Forms(i).Caption)==upper(pcCaption) or ;
     upper(_Screen.Forms(i).Name)==upper(pcCaption)
   oRef=_Screen.Forms(i)
   exit
  endif
 endfor
 
 *--Se devuelve la referencia a la forma (si se encontró)
 *
 return oRef
 *
ENDPROC