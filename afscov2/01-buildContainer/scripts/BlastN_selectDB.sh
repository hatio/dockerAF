#!/bin/bash

#BlastN
read -p "Enter Database [Flu, Den, CoV-19, virus, nt, plasmid, phage: " DB

DIR="/media/data_storage/BLASTDB_16Mar2020"

multifasta=$1


if [[ "$DB" == "Flu" ]]
then
	export BLASTDB=$DIR/Influenza2019
	blastn -db influenza2019 -query $multifasta -out $multifasta.fluDB -evalue 1e-10 -max_target_seqs 1 -num_threads 100 -best_hit_score_edge 0.05 -best_hit_overhang 0.25 -outfmt "6 qseqid sseqid salltitles pident length slen evalue"	
fi

if [[ "$DB" == "Den" ]]
then
	export BLASTDB=$DIR/Dengue
	blastn -db Dengue_since2015 -query $multifasta -out $multifasta.denDB -evalue 1e-10 -max_target_seqs 1 -num_threads 100 -best_hit_score_edge 0.05 -best_hit_overhang 0.25 -outfmt "6 qseqid sseqid salltitles pident length slen evalue"	
fi

if [[ "$DB" == "CoV-19" ]]
then
	export BLASTDB=$DIR/COV-19
	blastn -db COV-19 -query $multifasta -out $multifasta.cov-19DB -evalue 1e-10 -max_target_seqs 1 -num_threads 100 -best_hit_score_edge 0.05 -best_hit_overhang 0.25 -outfmt "6 qseqid sseqid salltitles pident length slen evalue"	
fi

if [[ "$DB" == "virus" ]]
then
	export BLASTDB=$DIR/Virus
	blastn -db viralDB_27Aug20 -query $multifasta -out $multifasta.viralDB -evalue 1e-10 -max_target_seqs 1 -num_threads 100 -best_hit_score_edge 0.05 -best_hit_overhang 0.25 -outfmt "6 qseqid sseqid salltitles pident length slen evalue"	
fi

if [[ "$DB" == "nt" ]]
then
	export BLASTDB=$DIR/nt
	blastn -db nt -query $multifasta -out $multifasta.nt -evalue 1e-10 -max_target_seqs 1 -num_threads 100 -best_hit_score_edge 0.05 -best_hit_overhang 0.25 -outfmt "6 qseqid sseqid salltitles pident length slen evalue"	
fi

if [[ "$DB" == "plasmid" ]]
then
	export BLASTDB=$DIR/plasmid
	blastn -db plasmidDB_27Aug20 -query $multifasta -out $multifasta.plasmidDB -evalue 1e-10 -max_target_seqs 1 -num_threads 100 -best_hit_score_edge 0.05 -best_hit_overhang 0.25 -outfmt "6 qseqid sseqid salltitles pident length slen evalue"	
fi

if [[ "$DB" == "phage" ]]
then
	export BLASTDB=$DIR/bacteriophageDB
	blastn -db 3455NC_Bacteriophage -query $multifasta -out $multifasta.phageDB -evalue 1e-10 -max_target_seqs 1 -num_threads 100 -best_hit_score_edge 0.05 -best_hit_overhang 0.25 -outfmt "6 qseqid sseqid salltitles pident length slen evalue"	
fi

