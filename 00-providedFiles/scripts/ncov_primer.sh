#!/bin/bash

##For SARS-CoV2 observe mismatch primer
multifasta=$1
read -p "Enter Output name: " outname
DIR="/media/data_storage/Hong/ARTIC/V3"

#Split_fasta
faSplit byname $1 split

ls -d *.fa|cut -d '.' -f 1 > sample_names.tmp

#find mismatch primer
for sample in $(cat sample_names.tmp);do
	primersearch -seqall $sample.fa -infile $DIR/V3_primer_set.fa -mismatchpercent 20 -outfile $sample.primer.txt
done

#make report
mkdir $outname
mv *.primer.txt $outname
rm *.fa *.tmp
	


