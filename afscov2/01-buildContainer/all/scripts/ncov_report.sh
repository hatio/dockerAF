#!/bin/bash
#require file lineage_report.csv .silent
read -p "Enter Output name: " outname
awk '{print $1}' *.silent | sort -u > sample_name.tmp
for sample in $(cat sample_name.tmp);do
	#echo $sample > $sample.gen1.tmp
	grep -P $sample *.silent| awk '{print $2,$13,$14}' >> $sample.gen1.tmp;
	sed -z 's/,/\t/g' lineage_report.csv >lineage_report.tmp
	lineages=$(grep $sample lineage_report.tmp| awk '{print $1, $2, $4}')
	clade=$(grep $sample *.cladeResult| awk '{print $2}')
	echo $lineages $clade > $sample.gen2.tmp
	datamash -sW -g1 collapse 2 collapse 3 < $sample.gen1.tmp >$sample.gen3.tmp
#sort datamash
	awk '$1 == "ORF1a"' $sample.gen3.tmp|awk '{print $1, $3, $2}'  > $sample.gen4.tmp
	awk '$1 == "ORF1b"' $sample.gen3.tmp|awk '{print $1, $3, $2}'  >> $sample.gen4.tmp
	awk '$1 == "S"' $sample.gen3.tmp|awk '{print $1, $3, $2}'  >> $sample.gen4.tmp
	awk '$1 == "ORF3a"' $sample.gen3.tmp|awk '{print $1, $3, $2}'  >> $sample.gen4.tmp
	awk '$1 == "E"' $sample.gen3.tmp|awk '{print $1, $3, $2}'  >> $sample.gen4.tmp
	awk '$1 == "M"' $sample.gen3.tmp|awk '{print $1, $3, $2}'  >> $sample.gen4.tmp
	awk '$1 == "ORF6"' $sample.gen3.tmp|awk '{print $1, $3, $2}'  >> $sample.gen4.tmp
	awk '$1 == "ORF7a"' $sample.gen3.tmp|awk '{print $1, $3, $2}'  >> $sample.gen4.tmp
	awk '$1 == "ORF7b"' $sample.gen3.tmp|awk '{print $1, $3, $2}'  >> $sample.gen4.tmp
	awk '$1 == "ORF8"' $sample.gen3.tmp|awk '{print $1, $3, $2}'  >> $sample.gen4.tmp
	awk '$1 == "N"' $sample.gen3.tmp|awk '{print $1, $3, $2}'  >> $sample.gen4.tmp
	awk '$1 == "ORF9b"' $sample.gen3.tmp|awk '{print $1, $3, $2}'  >> $sample.gen4.tmp
	awk '$1 == "ORF14"' $sample.gen3.tmp|awk '{print $1, $3, $2}'  >> $sample.gen4.tmp
	awk '$1 == "ORF10"' $sample.gen3.tmp|awk '{print $1, $3, $2}'  >> $sample.gen4.tmp
	sed -z 's/ /\t/g' $sample.gen4.tmp > $sample.gen5.tmp
	paste $sample.gen2.tmp $sample.gen5.tmp > $sample.gen6.tmp
	
done
cat *.gen6.tmp > $outname.summary_ncov_report.txt

