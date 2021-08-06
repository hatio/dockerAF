#!/bin/bash

#For nCoV-19 Amino Acid Mismatch Calling
multifasta=$1
output=$2
#Please check the directory of nCoV-19_Mismatch_source
DIR="/media/data_storage/Hong/nCoV-19_Mismatch_source"


#Split multiFasta file into separated single fasta file

Spilt-multifasta.sh $1

#Create bed file
for sample in $(cat sample_names.tmp);do
	sed "s/NC_045512/$sample/g" $DIR/NC_045512.bed > $sample/$sample.bed.tmp
#GetFasta
	samtools faidx $sample/$sample.fa
	bedtools getfasta -fi $sample/$sample.fa -bed $sample/$sample.bed.tmp -nameOnly -fo $sample/$sample.nt35.fasta
#Split multiFasta file into separated single fasta file
		while read line; do 
			if [[ ${line:0:1} == '>' ]]; 
				then outfile=${line#>}.nt.fa; 
				echo $line > $sample/$outfile; 
		else echo $line >> $sample/$outfile;
		fi; 
	done < $sample/$sample.nt35.fasta
done

#Translation if N exist, the aa is X and Convert to one line sequence

for sample in $(cat sample_names.tmp);do
	for name_gene in $(cat $DIR/name_gene.txt);do
		gotranseq --sequence $sample/$name_gene.nt.fa --outseq $sample/$name_gene.aa.tmp
		seqtk seq $sample/$name_gene.aa.tmp > $sample/$name_gene.aa.fa
		rm -f $sample/*.aa.tmp;
	done
done

#Generate Position file
for sample in $(cat sample_names.tmp);do
	for name_gene in $(cat $DIR/name_gene.txt);do
		grep -v '>' $sample/$name_gene.aa.fa| grep -o -b "G\|A\|S\|T\|C\|V\|L\|I\|M\|P\|F\|Y\|W\|D\|E\|N\|Q\|H\|K\|R\|*\|X"|
		awk '{print NR,$1}'|
		column -s ":" -t|
		awk '{print $1,":", $3}'> $sample/$name_gene.aa.position;
	done
done

#Compare to Reference
for sample in $(cat sample_names.tmp);do
	for name_gene in $(cat $DIR/name_gene.txt);do
		diff $DIR/NC_045512/$name_gene.aa.position $sample/$name_gene.aa.position > $sample/$name_gene.aa.diff
		grep -i "<" $sample/$name_gene.aa.diff > $sample/$name_gene.aa.ref.tmb
		grep -i ">" $sample/$name_gene.aa.diff | awk '{print $4}' > $sample/$name_gene.aa.sample.tmb
		paste $sample/$name_gene.aa.ref.tmb $sample/$name_gene.aa.sample.tmb|sed 's/\t/>/g'|cut -d ' ' -f 2,3,4 > $sample/$name_gene.aa_mismatch.tmb
		echo $name_gene > $sample/$name_gene.aa_mismatch
		cat $sample/$name_gene.aa_mismatch.tmb >> $sample/$name_gene.aa_mismatch
		cat $sample/$name_gene.aa_mismatch|tr "\n" ","|sed 's/,$/\n/' > $sample/$name_gene.aa_tr
		echo $sample > $sample/$sample.result
	done
done
for sample in $(cat sample_names.tmp);do
	for name_gene in $(cat $DIR/name_gene.txt);do
		cat $sample/$name_gene.aa_tr >> $sample/$sample.result
	done
	cp $sample/$sample.result .
done
paste *.result > $output.tmp
datamash transpose < $output.tmp > $output.Maa
rm -f ./*.tmp

##Note##
##Program Requirement: Spilt-multifasta.sh, gotranseq, seqtk, reference.bed, bedtools, datamash
#multiplefasta is genome and no indel
