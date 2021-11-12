#!/bin/bash

outfile="tisch_Q.csv"

startdate="2020-01-28 12:00:00"
enddate="2020-02-01 12:00:00"

d=$startdate

#while [[ $(date -d "$d") < $(date -d "$enddate") ]]
for id in $(seq 102 104)
do
	echo -e "Filtro \e[32m $id \e[0m"


	if [ $id == 69 ]
	then
		echo -e "\e[31m El filtro 69 se saltió \e[0m"; continue
	else
		for hr in $(seq 0 23)
		do
			if [[ $id == 22 || $id == 23 ]]
			then
				echo -e "\e[31m Los filtros 22 y 23 no se pusieron! \e[0m";
				Q="Nan"
			else
				read Q
			fi

			printf "%03d; %10s; %8s; %6s\n" $id $(date -d "$d $hr hour" +"%Y-%m-%d %H:%M:%S" ) $Q | tee -a $outfile
		done
		d=`date -d "$d 3 day" +"%Y-%m-%d %H:%M:%S"`
	fi
done
