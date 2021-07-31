#!/bin/bash

#For nCoV-19 clade prediction
#*****The multifasta have to no indel*****
multifasta=$1
output=$2
#Please check the directory of nCoV-19_Mismatch_source
DIR="/media/data_storage/Hong/nCoV-19_Mismatch_source"

#Split multiFasta file into separated single fasta file
Spilt-multifasta.sh $1

#nucleotide variant calling
for sample in $(cat sample_names.tmp);do
	grep -v '>' $sample/$sample.fa| grep -o -b "A\|T\|C\|G\|K\|M\|R\|Y\|S\|W\|B\|V\|H\|D\|N"|
	awk '{print NR,$1}'|
	column -s ":" -t|
	awk '{print $1,":", $3}'> $sample/${sample%.fasta*}.nt_position;
done

#amino acid variant calling
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
		gotranseq -s $sample/$name_gene*.nt.fa -o $sample/$name_gene.aa.tmp
		seqtk seq $sample/$name_gene.aa.tmp > $sample/$name_gene.aa.fa
		#rm -f $sample/*.aa.tmp;
	done
done

#Generate Position file
for sample in $(cat sample_names.tmp);do
	for name_gene in $(cat $DIR/name_gene.txt);do
		grep -v '>' $sample/$name_gene.aa.fa| grep -o -b "G\|A\|S\|T\|C\|V\|L\|I\|M\|P\|F\|Y\|W\|D\|E\|N\|Q\|H\|K\|R\|*\|X"|
		awk '{print NR,$1}'|
		column -s ":" -t|
		awk '{print $1,":", $3}'> $sample/$name_gene.aa_position;
	done
done

##Clade Prediction
#extarct clade marker
for sample in $(cat sample_names.tmp);do
#clade_S
	grep -w "8782\|28144" $sample/$sample.nt_position > $sample/$sample.cladeS.tmp
	grep -w "84" $sample/ORF8.aa_position >> $sample/$sample.cladeS.tmp
#clade_L
	grep -w "241\|3037\|23403\|8782\|11083\|26144\|28144" $sample/$sample.nt_position > $sample/$sample.cladeL.tmp
#clade_V
	grep -w "11083\|26144" $sample/$sample.nt_position > $sample/$sample.cladeV.tmp
	grep -w "37" $sample/nsp6.aa_position >> $sample/$sample.cladeV.tmp
	grep -w "251" $sample/ORF3a.aa_position >> $sample/$sample.cladeV.tmp
#clade_G
	grep -w "241\|3037\|23403" $sample/$sample.nt_position > $sample/$sample.cladeG.tmp
	grep -w "614" $sample/S.aa_position >> $sample/$sample.cladeG.tmp
#clade_GH
	grep -w "241\|3037\|23403\|25563" $sample/$sample.nt_position > $sample/$sample.cladeGH.tmp
	grep -w "614" $sample/S.aa_position >> $sample/$sample.cladeGH.tmp
	grep -w "57" $sample/ORF3a.aa_position >> $sample/$sample.cladeGH.tmp
#clade_GR
	grep -w "241\|3037\|23403\|28882" $sample/$sample.nt_position > $sample/$sample.cladeGR.tmp
	grep -w "614" $sample/S.aa_position >> $sample/$sample.cladeGR.tmp
	grep -w "204" $sample/N.aa_position >> $sample/$sample.cladeGR.tmp
#clade_GV
	grep -w "241\|3037\|23403\|22227" $sample/$sample.nt_position > $sample/$sample.cladeGV.tmp
	grep -w "614" $sample/S.aa_position >> $sample/$sample.cladeGV.tmp
	grep -w "222" $sample/S.aa_position >> $sample/$sample.cladeGV.tmp
#clade_GRY
	grep -w "241\|3037\|21765\|21766\|21767\|21768\|21769\|21770\|21991\|21992\|21993\|23063\|23403\|28882" $sample/$sample.nt_position > $sample/$sample.cladeGRY.tmp
	grep -w "69\|70\|144\|501\|614" $sample/S.aa_position >> $sample/$sample.cladeGRY.tmp
	grep -w "204" $sample/N.aa_position >> $sample/$sample.cladeGRY.tmp
done

##Make report
for sample in $(cat sample_names.tmp);do
	clade_resultS=$(diff -s $sample/$sample.cladeS.tmp $DIR/clade/cladeS)
	if [[ "$clade_resultS" == *"are identical" ]]
	then 
		echo -e $sample'\t'"Clade_S" > $sample.cladeResult.tmp
	fi
	clade_resultL=$(diff -s $sample/$sample.cladeL.tmp $DIR/clade/cladeL)
	if [[ "$clade_resultL" == *"are identical" ]]
	then 
		echo -e $sample'\t'"Clade_L" > $sample.cladeResult.tmp
	fi 
	clade_resultV=$(diff -s $sample/$sample.cladeV.tmp $DIR/clade/cladeV)
	if [[ "$clade_resultV" == *"are identical" ]]
	then 
		echo -e $sample'\t'"Clade_V" > $sample.cladeResult.tmp
	fi   
	clade_resultG=$(diff -s $sample/$sample.cladeG.tmp $DIR/clade/cladeG)
	if [[ "$clade_resultG" == *"are identical" ]]
	then 
		echo -e $sample'\t'"Clade_G" > $sample.cladeResult.tmp
	fi
	clade_resultGH=$(diff -s $sample/$sample.cladeGH.tmp $DIR/clade/cladeGH)
	if [[ "$clade_resultGH" == *"are identical" ]]
	then 
		echo -e $sample'\t'"Clade_GH" > $sample.cladeResult.tmp
	fi
	clade_resultGR=$(diff -s $sample/$sample.cladeGR.tmp $DIR/clade/cladeGR)
	if [[ "$clade_resultGR" == *"are identical" ]]
	then 
		echo -e $sample'\t'"Clade_GR" > $sample.cladeResult.tmp
	fi 
	clade_resultGV=$(diff -s $sample/$sample.cladeGV.tmp $DIR/clade/cladeGV)
	if [[ "$clade_resultGV" == *"are identical" ]]
	then 
		echo -e $sample'\t'"Clade_GV" > $sample.cladeResult.tmp
	fi 
	clade_resultGRY=$(diff -s $sample/$sample.cladeGRY.tmp $DIR/clade/cladeGRY)
	if [[ "$clade_resultGRY" == *"are identical" ]]
	then 
		echo -e $sample'\t'"Clade_GRY" > $sample.cladeResult.tmp
	fi  
	if [[ ! -f $sample.cladeResult.tmp ]]
   	then 
		echo -e $sample'\t'"Clade_unknown" > $sample.cladeResult.tmp
	fi 
done
cat *.cladeResult.tmp > $output.cladeResult
##https://www.gisaid.org/references/statements-clarifications/clade-and-lineage-nomenclature-aids-in-genomic-epidemiology-of-active-hcov-19-viruses/
