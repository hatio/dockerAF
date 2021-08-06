#!/bin/bash

#Split multiFasta file into separated single fasta file

multifasta=$1 

while read line; do 
	if [[ ${line:0:1} == '>' ]];
		then outfile=${line#>}.fa;
		echo $line > $outfile;
		echo ${outfile%.fa} >> ./sample_names.tmp
	else echo $line >> $outfile;
	fi;
done < $multifasta

#Make directory
for sample in $(cat sample_names.tmp);do
	mkdir $sample
	mv $sample.fa $sample
done
#cat sample_names.tmp|parallel --eta -j 10 --load 80% --noswap 'mkdir {}|mv {}.fa {}'

