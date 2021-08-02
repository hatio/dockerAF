#!/bin/bash

read -p "Enter output name: " out
#Create sample_names
ls -d *.bam|cut -d '.' -f 1 > sample_names.tmp

#Make directory
for sample in $(cat sample_names.tmp);do
	mkdir $sample
	mv $sample*.bam $sample
done


# read number of CPUs allocated
ncpu=$(nproc --all )

#Genome Guiding De novo assembly
cat sample_names.tmp|parallel --eta -j $ncpu --load 80% --noswap 'Trinity --genome_guided_bam {}/{}*.bam --genome_guided_max_intron 100 --max_memory 200G --CPU 200 --output {}/{}_trinity'

cat sample_names.tmp|parallel --eta -j $ncpu --load 80% --noswap 'cp {}/{}_trinity/Trinity-GG.fasta ./{}-trinity.fa'

mkdir $out.Trinity_out
mv *.fa $out.Trinity_out
rm -f sample_names.tmp
