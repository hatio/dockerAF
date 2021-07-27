#!/bin/bash

#For nCoV-19 extract CDS
#*****The multifasta have to no indel*****
multifasta=$1
output=$2
#Please check the directory of nCoV-19_Mismatch_source
DIR="/media/data_storage/Hong/nCoV-19_Mismatch_source"

#Mafft
cat $DIR/NC_045512.fasta $1 > $1.Ref.fasta
mafft --thread -1 $1.Ref.fasta > $1.Ref.mafft
awk '/^>/ {print($0)}; /^[^>]/ {print(toupper($0))}' $1.Ref.mafft > $1.Ref.mafft.upper
sed "s/-/N/g" $1.Ref.mafft.upper > $1.Ref.mafft_n

#Split multiFasta file into separated single fasta file
while read line; do 
			if [[ ${line:0:1} == '>' ]]; 
				then outfile=${line#>}.mafft_n.fa; 
				echo $line > $outfile; 
			else echo $line >> $outfile;
			fi; 
done < $1.Ref.mafft_n

ls -d *.mafft_n.fa|cut -d '.' -f 1 > mafftN_names.tmp

#Create bed file
for sample in $(cat mafftN_names.tmp);do
	sed "s/NC_045512/$sample/g ; s/CDS/$sample.CDS/g" $DIR/NC_045512CDS.bed > $sample.bed.tmp
#GetFasta
	samtools faidx $sample*.mafft_n.fa
	bedtools getfasta -fi $sample.mafft_n.fa -bed $sample.bed.tmp -name -fo $sample.CDS.fasta
done
cat *.CDS.fasta > $2.CDS.fa
