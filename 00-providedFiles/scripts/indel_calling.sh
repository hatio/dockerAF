#!/bin/bash

#Insertion deletion calling
multifasta=$1
reference=$2

#Split multiFasta file into separated single fasta file
Spilt-multifasta.sh $multifasta 

#MAFFT alignment to check position

for sample in $(cat sample_names.tmp);do
	mafft-profile $2 $sample/$sample.fa > $sample/$sample.mafft
	while read line; do 
		if [[ ${line:0:1} == '>' ]];
			then outfile=${line#>}.mafft.fa;
			echo $line > $sample/$outfile;
			echo ${outfile%.fa} >> $sample/mafft_names.tmp
		else echo $line >> $sample/$outfile;
		fi;
	done < $sample/$sample.mafft

#Nucleotide Position

	for sample_mafft in $(cat $sample/mafft_names.tmp);do
		grep -v '>' $sample/$sample_mafft.fa|
		grep -o -b "a\|t\|c\|g\|n\|-"|
		awk '{print NR,$1}'|
		column -s ":" -t|
		awk '{print $1, ":", $3}' > $sample/$sample_mafft.position	
	done	
done

for sample in $(cat sample_names.tmp);do
	for sample_mafft in $(cat $sample/mafft_names.tmp);do
		echo $sample_mafft >> $sample/indel.tmp
		grep -i '-' $sample/$sample_mafft.position >> $sample/indel.tmp
	done
	sed "s/${2%.fasta}.mafft/$sample.insertion/g" $sample/indel.tmp > $sample/indel1.tmp
	sed "s/$sample.mafft/$sample.deletion/g" $sample/indel1.tmp > $sample/$sample.indel.report
	rm $sample/*.tmp
	cp $sample/$sample.indel.report .
done

paste *.report > ${1%.fa}.indel
rm *.report
