#Calculo de Caudal efectivo
#	I:chart response
#	T:Temperatura (C)
#	P:Presion (mmHg)
#	Q:Caudal (m3/min)
#	V:Volumen (m3)
#	a:slope (I~Q)
#	b:intercep. (I~Q)

#Archivo de caudales digitalizados (Chart response (sin unidades)
I=read.csv("tisch_Q_clean.csv",sep=",",stringsAsFactors = F,na.strings = c("na"))
  I$date=as.POSIXct(I$date,"%Y-%m-%d %H:%M:%s")

#Archivo de temperaturas
T=read.csv("tisch_T.csv",sep=",")
  T$date=as.POSIXct(T$Time,"%Y-%m-%d %H:%M:%s");T$date=format(T$date,"%Y-%m-%d %H:00:00")
  T=aggregate(T[c("Temp")],by = list(date=T$date),FUN = mean);
  T$date=as.POSIXct(T$date,"%Y-%m-%d %H:%M:%s")

#Uno Caudal con Temperatura
M=merge(I,T,by="date",all.x = TRUE)

#Parametros de calibraciones: 
  #Avg Pressure [mmHg]
  M$Pr[M$date > as.POSIXct("2019-04-01", "%Y-%m-%d")]=753
  M$Pr[M$date > as.POSIXct("2019-08-01", "%Y-%m-%d")]=761
  M$Pr[M$date > as.POSIXct("2020-01-01", "%Y-%m-%d")]=758
  
  #Slope (calibracion)
  M$a[M$date > as.POSIXct("2019-04-01", "%Y-%m-%d")]=36.5394
  M$a[M$date > as.POSIXct("2019-08-01", "%Y-%m-%d")]=31.7730
  M$a[M$date > as.POSIXct("2020-01-01", "%Y-%m-%d")]=51.0111
  
  #Intercept (calibracion)
  M$b[M$date > as.POSIXct("2019-04-01", "%Y-%m-%d")]=6.8964
  M$b[M$date > as.POSIXct("2019-08-01", "%Y-%m-%d")]=13.5841
  M$b[M$date > as.POSIXct("2020-01-01", "%Y-%m-%d")]=7.6739

#Relleno temperatura con temperatura promedio
M$Temp[is.na(M$Temp)]=mean(M$Temp[!is.na(M$Temp)])

#Calculo de Caudal efectivo [m3/min]
M$Q=(M$I*sqrt((298/(M$Temp+273.3)*(M$Pr/760)))-M$b)/M$a

#Volumen por hora
M$Vol=M$Q*60

#Volumen por filtro
DF=aggregate(M[c("Vol")],by=list(c(id=M$id)),FUN=sum)

write.csv(M,"TISCH_tabla2.csv")
write.csv(DF,"TISCH_volumen_total_x_filtro2.csv")
