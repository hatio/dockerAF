#!/bin/bash

#For nCoV-19 Nucleotide Mismatch Calling
multifasta=$1
output=$2

#Please check the directory of nCoV-19_Mismatch_source
DIR="/media/data_storage/Hong/nCoV-19_Mismatch_source"

#Split multiFasta file into separated single fasta file
Spilt-multifasta.sh $1

#Comparison
for sample in $(cat sample_names.tmp);do
	grep -v '>' $sample/$sample.fa| grep -o -b "A\|T\|C\|G\|K\|M\|R\|Y\|S\|W\|B\|V\|H\|D\|N"|
	awk '{print NR,$1}'|
	column -s ":" -t|
	awk '{print $1,":", $3}'> $sample/${sample%.fasta*}.position;
	diff $DIR/NC_045512.position $sample/${sample%.fasta*}.position > $sample/${sample%.fasta*}.diff
	grep -i "<" $sample/${sample%.fasta*}.diff > $sample/${sample%.fasta*}.ref.tmb
	grep -i ">" $sample/${sample%.fasta*}.diff| awk '{print $4}' > $sample/${sample%.fasta*}.sample.tmb
	paste $sample/${sample%.fasta*}.ref.tmb $sample/${sample%.fasta*}.sample.tmb|sed 's/\t/>/g'|cut -d ' ' -f 2,3,4 > $sample/${sample%.fasta*}.nt_mismatch.tmb
	echo ${sample%.fasta*}|cat - $sample/${sample%.fasta*}.nt_mismatch.tmb > $sample/${sample%.fasta*}.nt_mismatch
	cp $sample/${sample%.fasta*}.nt_mismatch .
	rm -f $sample/*.tmb
done
paste *.nt_mismatch > $output.Mnt
rm -f *.nt_mismatch
#*****The multifasta have to no indel*****


#report silent or non-silent mutation
for sample in $(cat sample_names.tmp);do
	ncov-silent_sub.sh $sample
	cat $sample/$sample.silent_report >> $output.silent
	
done

##note
#multiplefasta is nucleotide genome and no indel 
