LOCAL LoPln as Planillas OF "k:\aplvfp\classgen\vcxs\dosvr.vcx"  
LoPln = CREATEOBJECT('DosVr.Planillas')
** Parametro
** Formato: HH.MM   tipo numerico 
** Ejemplo: 10 Horas 45 minutos 
LnHoras=LoPln.horas(10.45) 
?LnHoras && Devuelve 10.75 Horss , tipo numerico 

** Si tienes la hora y minutos separados en campos diferentes
** Entonces LnHH =10 Horas y  LnMM = 45 min
LnHH = 10  && Horas
LnMM = 15  && Minutos
LnHoras = LoPln.horas(LnHH+LnMM/100) 
?LnHoras   && Devuelve 10.25 horas , Tipo Numerico

** Diferencia de 2 fechas y/o horas , util para dias diferentes.

?LoPln.timediff(DATE(),DATE()+1,"18:00","5:00")