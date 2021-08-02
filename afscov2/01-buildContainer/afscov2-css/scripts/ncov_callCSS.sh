#!/bin/bash

##For SARS-CoV2 consensus calling

read -p "Enter Output name: " outname

#Make directory
ls -d *.gz|cut -d '_' -f 1,2|uniq > sample_names.tmp
for sample in $(cat sample_names.tmp);do
	mkdir $sample
	mv $sample*.gz $sample;
done


#Trimming
cat sample_names.tmp|parallel --eta -j $ncpu --load 80% --noswap 'bbduk.sh -Xmx20g in1={}/{}_L001_R1_001.fastq.gz in2={}/{}_L001_R2_001.fastq.gz out1={}/Trimmed_{}_R1.fq out2={}/Trimmed_{}_R2.fq ref=/media/data_storage/Hong/index_adapter/MiSeq_adapter_index0.fa ktrim=r k=23 mink=11 hdist=1 tpe tbo qtrim=rl minlength=100 minavgquality=20 &>{}/{}_Trimming.log;'

#Alignment using BWA-MEM

cat sample_names.tmp|parallel --eta -j $ncpu --load 80% --noswap 'bwa mem -t 20 -V /db/NC_045512.fasta {}/Trimmed_{}_R1.fq {}/Trimmed_{}_R2.fq -o {}/{}.sam'
cat sample_names.tmp|parallel --eta -j $ncpu --load 80% --noswap 'samtools view {}/{}.sam -o {}/{}.bam'
cat sample_names.tmp|parallel --eta -j $ncpu --load 80% --noswap 'samtools sort {}/{}.bam -o {}/{}.sorted.bam'
cat sample_names.tmp|parallel --eta -j $ncpu --load 80% --noswap 'rm -f {}/{}.sam {}/{}.bam'


#ivar trim
cat sample_names.tmp|parallel --eta -j $ncpu --load 80% --noswap 'ivar trim -e -i {}/{}.sorted.bam -b /media/data_storage/Hong/ARTIC/V3/ARTIC-V3.bed -p {}/{}.primertrim'
cat sample_names.tmp|parallel --eta -j $ncpu --load 80% --noswap 'samtools sort {}/{}.primertrim.bam -o {}/{}.primertrim.sorted.bam'

#Calculate DOC&BOC
for sample in $(cat sample_names.tmp);do
	rm -f $sample/sum_doc.tmp;
	for line in $(cat ref_name.txt ); do
		samtools depth -a $sample/$sample.primertrim.sorted.bam > $sample/${sample%_S*}_doc.txt
		grep -i "$line" $sample/${sample%_S*}_doc.txt | \
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

	echo ${sample%_S*} >> $sample/name.tmp 

	rm -f $sample/lowestDOC.tmp;
	for line in $(cat ref_name.txt); do
		samtools depth -a $sample/$sample.primertrim.sorted.bam| \
		sort -nk3|\
		head -n 1|\
		awk '{print "position="$2, "lowestDOC="$3}'\
		>> $sample/lowestDOC.tmp
	done

	for line in $(cat ref_name.txt); do
		awk -v number="10" '25 <= number' $sample/${sample%_S*}_doc.txt > $sample/${sample%_S*}.lower10
	done

	paste $sample/name.tmp $sample/sum_doc.tmp $sample/sum_boc.tmp $sample/lowestDOC.tmp >> $sample/${sample%_S*}_sum_doc_boc.tmp
	
	cat $sample/${sample%_S*}_sum_doc_boc.tmp >> Summary_DOC_BOC.tmp;
	
	awk '{print $2, $3}' $sample/${sample%_S*}_doc.txt > $sample/${sample%_S*}_doc.tmp;
	gnuplot -e "set terminal jpeg; set title 'Depth of Coverage Plot'; set xlabel 'Position'; set ylabel 'DOC'; \
		set style data lines; plot '$sample/${sample%_S*}_doc.tmp'" > ${sample%_S*}_plot.jpeg
done

#Consensus Calling by without ambiguous base
cat sample_names.tmp|parallel --eta -j $ncpu --load 80% --noswap 'samtools mpileup -Q 25 -A {}/{}.primertrim.sorted.bam|ivar consensus -q 25 -t 0 -m 10 -n N -p {}/{}_ivar'
cat sample_names.tmp|parallel --eta -j $ncpu --load 80% --noswap 'sed 's/[a-z]/N/g' {}/{}_ivar.fa > {}/{}_ivar.tmp'
cat sample_names.tmp|parallel --eta -j $ncpu --load 80% --noswap 'sed "s/>.*/>{}/g" {}/{}_ivar.tmp >> {}.CSS.fa'

for sample in $(cat sample_names.tmp);do
	cat $sample.CSS.fa >> $outname.consensus.fa
done

#for sample in $(cat sample_names.tmp);do
#	samtools mpileup -Q 25 -A $sample/$sample.primertrim.sorted.bam| \
#	ivar consensus -q 25 -t 0 -m 10 -n N -p $sample/${sample%_S*}_ivar
#	sed 's/[a-z]/N/g' $sample/${sample%_S*}_ivar.fa > $sample/${sample%_S*}_ivar.tmp	
#	sed "s/>.*/>${sample%_S*}/g" $sample/${sample%_S*}_ivar.tmp >> ${sample%_S*}_CSS.fa
#	cat ${sample%_S*}_CSS.fa >> All_consensus.fa
#	#rm -f $sample/*.tmp $sample/${sample%_S*}_ivar*
#done

#QC
mkdir QC_report
cat sample_names.tmp|parallel --eta -j $ncpu --load 80% --noswap 'fastqc {}/{}.primertrim.sorted.bam --outdir ./QC_report|qualimap bamqc -bam {}/{}.primertrim.sorted.bam'
#cat sample_names.tmp|parallel --eta -j 10 --load 80% --noswap 'SAMstatsParallel --sorted_sam_file {}/{}.primertrim.sorted.bam --outf ./QC_report/{}.samstat --chunk_size 1000 --threads 10'

multiqc .

convert *_plot.jpeg -append Over_Plot.jpeg
sort -nk1 Summary_DOC_BOC.tmp > Summary_DOC_BOC.txt 
mkdir BAM
for sample in $(cat sample_names.tmp); do
	cp $sample/$sample.primertrim.sorted.bam ./BAM
done
rm -f *.amb *.ann *.bwt *.fai *.pac *sa ref_name.txt sample_names.tmp Summary_DOC_BOC.tmp 
rm -rf QC_report multiqc_data

#extract CDS
mkdir CDS
cp $outname.consensus.fa ./CDS
cd ./CDS
ncov_CDS.sh $outname.consensus.fa $outname
cd ..
#calculate number of N base in the consensus sequences
mkdir callN
cp ./CDS/$outname.CDS.fa ./callN
cd ./callN
ncov_callN_sub.sh  $outname.CDS.fa $outname 
cd ..
#Seeking Clade
mkdir Clade
cp ./CDS/$outname.consensus.fa.Ref.mafft_n ./Clade
cd ./Clade
ncov_clade_sub.sh $outname.consensus.fa.Ref.mafft_n $outname
cd ..

mkdir $outname.result
cp *.jpeg *.html *consensus.fa *.CSS.fa Summary_DOC_BOC.txt ./callN/*SUMcallN ./Clade/*.cladeResult ./$outname.result
####Note#### 
#Working Directory contains all fastq.gz 
#Command line: ncov_callCSS.sh





