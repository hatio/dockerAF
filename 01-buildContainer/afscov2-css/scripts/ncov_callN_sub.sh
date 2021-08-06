#!/bin/bash

#For call N position
multifasta=$1
output=$2
#Split multiFasta file into separated single fasta file and directory

Spilt-multifasta.sh $multifasta

#For filter only specific position by start at position 1

for sample in $(cat sample_names.tmp);do
	grep -v '>' $sample/$sample.fa| grep -o -b "A\|T\|G\|C\|K\|M\|R\|Y\|S\|W\|B\|V\|H\|D\|-\|N"|
	awk '{print NR,$1}'|
	column -s ":" -t|
	awk '{print $1,":", $3}'> $sample/$sample.position.txt;
done

#Call N position

for sample in $(cat sample_names.tmp);do
	grep -v '>' $sample/$sample.position.txt| grep "N" > $sample/$sample.Nreport.txt
done

#convert sequentially number to range number
for sample in $(cat sample_names.tmp);do
    awk '{print $1}' $sample/$sample.Nreport.txt > $sample/Nreport1.tmp
    while read line; do 
        echo "$(($line + 265))" >> $sample/Nreport2.tmp
    done < $sample/Nreport1.tmp
    awk 'NR==1{first=$1;last=$1;next} $1 == last+1 {last=$1;next} {print first,last;first=$1;last=first} END{print first,last}' $sample/Nreport2.tmp > $sample/$sample.Nreport.range
    rm -f $sample/*.tmp	
done
#make report
for sample in $(cat sample_names.tmp);do
    echo $sample > ./$sample.Nsummary
    num1=$(wc -l $sample/$sample.position.txt|awk '{print $1}')
    num2=$(wc -l $sample/$sample.Nreport.txt|awk '{print $1}')
    echo "total nucleotide base include N :" $num1 >> ./$sample.Nsummary
    echo "total N base :" $num2 >> ./$sample.Nsummary
    echo "total base wo N: " $(($num1 - $num2)) >> ./$sample.Nsummary
    echo "N position range" >> ./$sample.Nsummary
    cat $sample/$sample.Nreport.range >> ./$sample.Nsummary	
done

paste *.Nsummary > $output.SUMcallN

###note###
##multiple-fasta have to CDS
##Progarm requirement: Spilt-mutifasta.sh




