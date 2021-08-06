#!/bin/bash

##For call SARS-CoV-2 clade and nucleotide & amino acid mismatch
##Input is multiplefasta genome without indel compared to NC_045512

multifasta=$1

read -p "Enter output name: " output 

mkdir ./Clade ./Mnt ./Maa
parallel cp *.fa* ::: Clade Mnt Maa 
workingDIR=$(pwd)

######Clade calling "ncov_clade.sh"
cd $workingDIR/Clade 
ncov_clade_sub.sh $1 $output

######Nucleotide mismatch and Silent/Non-silent mutantion calling "ncov_callMismatch_ntSilent.sh"
cd $workingDIR/Mnt
ncov_Mnt_sub.sh $1 $output

######Amino acid mismatch calling "ncov_callMismatch_aa.sh"
cd $workingDIR/Maa
ncov_Maa_sub.sh $1 $output

######Making Report
cd $workingDIR
mkdir $output.MMdata
cp $workingDIR/Clade/$output.cladeResult ./$output.MMdata
cp $workingDIR/Mnt/$output.Mnt ./$output.MMdata
cp $workingDIR/Mnt/$output.silent ./$output.MMdata
cp $workingDIR/Maa/$output.Maa ./$output.MMdata

######Remove no need file
#rm -r ./Clade ./Mnt ./Maa
#####Require Shell list####
##Spilt-mutifasta.sh, ncov_clade.sh, ncov_callMismatch_ntSilent.sh, ncov-silent.sh,
