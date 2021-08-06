#!/bin/bash

#nanopore mapping using BWA

#Make directory
ls -d *.fastq|cut -d '.' -f 1 > sample_names.tmp

for sample in $(cat sample_names.tmp);do
	mkdir $sample
	mv $sample.fastq $sample;
done

#Make index
cp /media/data_storage/Reference/SARS-CoV2/NC_045512.fasta . 
samtools faidx NC_045512.fasta;
bwa index -a is NC_045512.fasta;
grep -i ">" NC_045512.fasta|cut -d '|' -f 1|cut -c 2-9 > ref_name.txt

#Trimming
for sample in $(cat sample_names.tmp);do
	bbduk.sh -Xmx20g in=$sample/$sample.fastq out1=$sample/Trimmed_$sample.fq qtrim=rl minlength=300 minavgquality=5 &>$sample/$sample.Trimming.log;
done

#Alignment using BWA
for sample in $(cat sample_names.tmp);do
	bwa mem -t 10 NC_045512.fasta $sample/Trimmed_$sample.fq > $sample/$sample.sam 
	samtools view $sample/$sample.sam -o $sample/$sample.bam
	samtools sort $sample/$sample.bam -o $sample/$sample.sorted.bam
	rm -f $sample/$sample.sam $sample/$sample.bam;
done

#ivar trim
cat sample_names.tmp|parallel --eta -j 10 --load 80% --noswap 'ivar trim -q 5 -i {}/{}.sorted.bam -b /media/data_storage/Hong/ARTIC/V3/ARTIC-V3.bed -p {}/{}.primertrim'
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
		awk -v number="10" '$3 <= number' $sample/$sample.doc.txt > $sample/$sample.lower10
	done

	paste $sample/name.tmp $sample/sum_doc.tmp $sample/sum_boc.tmp $sample/lowestDOC.tmp >> $sample/$sample.sum_doc_boc.tmp
	
	cat $sample/$sample.sum_doc_boc.tmp >> Summary_DOC_BOC.tmp;
	
	awk '{print $2, $3}' $sample/$sample.doc.txt > $sample/$sample.doc.tmp;
	gnuplot -e "set terminal jpeg; set title 'Depth of Coverage Plot'; set xlabel 'Position'; set ylabel 'DOC'; \
		set style data lines; plot '$sample/$sample.doc.tmp'" > $sample.plot.jpeg
done

#Consensus Calling by without ambiguous base
for sample in $(cat sample_names.tmp);do
	samtools mpileup -aa -f NC_045512.fasta -Q 10 -A $sample/$sample.primertrim.sorted.bam|ivar consensus -q 10 -t 0 -m 10 -n N -p $sample/$sample.ivar &>$sample/$sample.CSS.log
	sed 's/[a-z]/N/g' $sample/$sample.ivar.fa > $sample/$sample.ivar.tmp
	sed "s/>.*/>$sample/g" $sample/$sample.ivar.tmp >> $sample.CSS.fa
	cat $sample.CSS.fa >> All_consensus.fa
	rm -f $sample/*.tmp $sample/$sample.ivar*
done

#call varaint
cat sample_names.tmp|parallel --eta -j 10 --load 80% --noswap 'samtools mpileup -a -uf NC_045512.fasta {}/{}.primertrim.sorted.bam | bcftools call -m > {}/{}.vcf'

#QC
mkdir QC_report
for sample in $(cat sample_names.tmp);do
	fastqc $sample/$sample.primertrim.sorted.bam --outdir ./QC_report
	qualimap bamqc -bam $sample/$sample.primertrim.sorted.bam
	samstat $sample/$sample.primertrim..sorted.bam > ./QC_report
done

multiqc .

convert *_plot.jpeg -append Over_Plot.jpeg
sort -nk1 Summary_DOC_BOC.tmp > Summary_DOC_BOC.txt 	

#make report
mkdir report
cp All_consensus.fa multiqc_report.html Over_Plot.jpeg Summary_DOC_BOC.txt report
mkdir report/BAM
mkdir report/VCF
mkdir report/log
for sample in $(cat sample_names.tmp);do
	cp $sample/$sample.vcf report/VCF
	cp $sample/$sample.primertrim.sorted.bam report/BAM
	cp $sample/$sample.Trimming.log report/log
	cp $sample/$sample.CSS.log report/log
done
	
rm -f *.fa.fai *.fa.pac *.fa.sa ref_name.txt sample_names.tmp Summary_DOC_BOC.tmp

####Note####





