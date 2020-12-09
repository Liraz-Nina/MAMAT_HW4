#!/bin/bash

wget https://www.ynetnews.com/category/3082
grep -o 'https://www.ynetnews.com/article/.........' 3082 >list.txt
#getting only one copy of each link
cat list.txt | sort | uniq >links.txt
rm list.txt
num=$(wc -l < links.txt)
echo -n $num >  results.csv
#checking apppearances in each link
for ((i=1; i<=$num; i++))do
	link=$(ls -l | sed -n $i\p links.txt)
	wget $link -O article
	gantz_num=$(grep -o 'Gantz' article | wc -l) 
	netanyahu_num=$(grep -o 'Netanyahu' article | wc -l)
#checking if wc -l didn't return a number
	re='^[0-9]+$'
	if ! [[ $gantz_num =~ $re ]] ; then
		gantz_num=0
	fi
	if ! [[ $netanyahu_num =~ $re ]] ; then
		netanyahu_num=0
	fi
	if [[ $gantz_num == 0 && $netanyahu_num == 0 ]];then
		echo -n -e '\n'$link, - >>results.csv
	else
		echo -n -e '\n'$link, Netanyahu, $netanyahu_num, Gantz, $gantz_num >>results.csv
	fi
done
rm article
rm links.txt
rm 3082
