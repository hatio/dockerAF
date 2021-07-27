#!/bin/bash

#nanopore mapping using MiniMap2
##For SARS-CoV2 consensus calling

read -p "Enter Output name: " outname
DIR="/media/data_storage/Reference/SARS-CoV2"

#Make directory
ls -d *.fastq|cut -d '.' -f 1 > sample_names.tmp
for sample in $(cat sample_names.tmp);do
	mkdir $sample
	mv $sample.fastq $sample;
done

#Make index
cp $DIR/NC_045512.fasta .  
bwa index -a is NC_045512.fasta;
samtools faidx NC_045512.fasta;
grep -i ">" NC_045512.fasta|cut -d '|' -f 1|cut -c2-9 > ref_name.txt

#Trimming
cat sample_names.tmp|parallel --eta -j 10 --load 80% --noswap 'bbduk.sh -Xmx20g in1={}/{}.fastq out1={}/Trimmed_{}.fq minlen=700 minavgquality=5 &>{}/{}_Trimming.log;'


#Alignment using MiniMap2
for sample in $(cat sample_names.tmp);do
	minimap2 -ax map-ont NC_045512.fasta $sample/Trimmed_$sample.fq > $sample/$sample.sam
	samtools view $sample/$sample.sam -o $sample/$sample.bam
	samtools sort $sample/$sample.bam -o $sample/$sample.sorted.bam
	rm -f $sample/$sample.sam $sample/$sample.bam;
done

#ivar trim
cat sample_names.tmp|parallel --eta -j 10 --load 80% --noswap 'ivar trim -e -i {}/{}.sorted.bam -b /media/data_storage/Hong/ARTIC/V3/ARTIC-V3.bed -p {}/{}.primertrim'
cat sample_names.tmp|parallel --eta -j 10 --load 80% --noswap 'samtools sort {}/{}.primertrim.bam -o {}/{}.primertrim.sorted.bam'

#Calculate DOC&BOC

for sample in $(cat sample_names.tmp);do
	rm -f $sample/sum_doc.tmp;
	for line in $(cat ref_name.txt ); do
		samtools depth -a $sample/$sample.primertrim.sorted.bam > $sample/$sample.doc.txt
		grep -i "$line" $sample/$sample.doc.txt | \
		awk '{c++;s+=$3}END{print $1" " "mean_DOC: " s/c}'\
		>> $sample/sum_doc.tmp
	done

	rm -f $sample/sum_boc.tmp;	
	for line in $(cat ref_name.txt); do
		samtools depth -a $sample/$sample.primertrim.sorted.bam | \
		grep -i "$line" | \
		awk '{c++; if($3>0) total+=1}END{print " " "BOC: " (total/c)*100}' \
		>> $sample/sum_boc.tmp
	done

	echo $sample >> $sample/name.tmp 

	rm -f $sample/lowestDOC.tmp;
	for line in $(cat ref_name.txt); do
		samtools depth -a $sample/$sample.primertrim.sorted.bam| \
		sort -nk3|\
		head -n 1|\
		awk '{print "position="$2, "lowestDOC="$3}'\
		>> $sample/lowestDOC.tmp
	done

	for line in $(cat ref_name.txt); do
		awk -v number="$2" '$3 <= number' $sample/$sample.doc.txt > $sample/$sample.lower$2
	done

	paste $sample/name.tmp $sample/sum_doc.tmp $sample/sum_boc.tmp $sample/lowestDOC.tmp >> $sample/$sample.sum_doc_boc.tmp
	
	cat $sample/$sample.sum_doc_boc.tmp >> Summary_DOC_BOC.tmp;
	
	awk '{print $2, $3}' $sample/$sample.doc.txt > $sample/$sample.doc.tmp;
	gnuplot -e "set terminal jpeg; set title 'Depth of Coverage Plot'; set xlabel 'Position'; set ylabel 'DOC'; \
		set style data lines; plot '$sample/$sample.doc.tmp'" > $sample.plot.jpeg
done

#Consensus Calling by without ambiguous base
#for sample in $(cat sample_names.tmp);do
#	samtools mpileup -Q$3 -A $sample/$sample.sorted.bam| \
#	ivar consensus -q $3 -t 0 -m $2 -n N -p $sample/$sample.ivar
#	sed 's/[a-z]/N/g' $sample/$sample.ivar.fa > $sample/$sample.ivar.tmp	
#	sed "s/>.*/>$sample/g" $sample/$sample.ivar.tmp >> $sample.CSS.fa
#	cat $sample.CSS.fa >> All_consensus.fa
#	rm -f $sample/*.tmp $sample/$sample.ivar*
#done
#Consensus Calling by without ambiguous base
cat sample_names.tmp|parallel --eta -j 10 --load 80% --noswap 'samtools mpileup -Q5 -A {}/{}.primertrim.sorted.bam|ivar consensus -q 7 -t 0 -m 5 -n N -p {}/{}_ivar'
cat sample_names.tmp|parallel --eta -j 10 --load 80% --noswap 'sed 's/[a-z]/N/g' {}/{}_ivar.fa > {}/{}_ivar.tmp'
cat sample_names.tmp|parallel --eta -j 10 --load 80% --noswap 'sed "s/>.*/>{}/g" {}/{}_ivar.tmp >> {}.CSS.fa'

for sample in $(cat sample_names.tmp);do
	cat $sample.CSS.fa >> $outname.consensus.fa
done

#QC
mkdir QC_report
for sample in $(cat sample_names.tmp);do
	fastqc $sample/$sample.sorted.bam --outdir ./QC_report
	qualimap bamqc -bam $sample/$sample.sorted.bam
	samstat $sample/$sample.sorted.bam > ./QC_report
done

multiqc .

convert *.plot.jpeg -append Over_Plot.jpeg
sort -nk1 Summary_DOC_BOC.tmp > Summary_DOC_BOC.txt 
rm -f *.fa.fai *.fa.pac *.fa.sa ref_name.txt sample_names.tmp Summary_DOC_BOC.tmp	

#rm -f *.fa.amb *.fa.ann *.fa.bwt *.fa.fai *.fa.pac *.fa.sa ref_name.txt sample_names.tmp 

####Note####





