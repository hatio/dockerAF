#!/bin/bash

#For extract base position
in_sample_name=$1
DIR="/media/data_storage/Hong/nCoV-19_Mismatch_source"

#remove N base
grep -v ">N" $1/$1.nt_mismatch|grep -vw "> " > $1/$1.nt_mismatch.grep
awk 'NR>1 {print $1}' $1/$1.nt_mismatch.grep > $1/num1.txt

#create sample bed file
while read line; do
	#ORF1a
	if [[ $line -ge 266 && $line -le 13468 ]];
		then a=$[line-265]
		b=$(echo "scale=2;$a/3"|bc)
		echo -e ">"'\n'$b >> $1/num2.txt
		echo -e $1'\t'"ORF1a" >> $1/num3.txt
		echo $line >> $1/num4.txt
			if [[ "$b" == *".33"* ]];
				then echo -e ${1%.fa*}'\t'$[line-1]'\t'$[line+2]'\t'"ORF1a" >> $1/$1.bed
			fi;
			if [[ "$b" == *".66"* ]];
				then echo -e ${1%.fa*}'\t'$[line-2]'\t'$[line+1]'\t'"ORF1a"  >> $1/$1.bed
			fi;
			if [[ "$b" == *".00"* ]];
				then echo -e ${1%.fa*}'\t'$[line-3]'\t'$line'\t'"ORF1a"  >> $1/$1.bed
			fi;
	fi;
	#ORF1b
	if [[ $line -ge 13468 && $line -le 21555 ]];
		then a=$[line-13467]
		b=$(echo "scale=2;$a/3"|bc)
		echo -e ">"'\n'$b >> $1/num2.txt
		echo -e $1'\t'"ORF1b" >> $1/num3.txt
		echo $line >> $1/num4.txt
			if [[ "$b" == *".33"* ]];
				then echo -e ${1%.fa*}'\t'$[line-1]'\t'$[line+2]'\t'"ORF1b" >> $1/$1.bed
			fi;
			if [[ "$b" == *".66"* ]];
				then echo -e ${1%.fa*}'\t'$[line-2]'\t'$[line+1]'\t'"ORF1b"  >> $1/$1.bed
			fi;
			if [[ "$b" == *".00"* ]];
				then echo -e ${1%.fa*}'\t'$[line-3]'\t'$line'\t'"ORF1b"  >> $1/$1.bed
			fi;
	fi;
	#S gene
	if [[ $line -ge 21563 && $line -le 25384 ]];
		then a=$[line-21562]
		b=$(echo "scale=2;$a/3"|bc)
		echo -e ">"'\n'$b >> $1/num2.txt
		echo -e $1'\t'"S" >> $1/num3.txt
		echo $line >> $1/num4.txt
			if [[ "$b" == *".33"* ]];
				then echo -e ${1%.fa*}'\t'$[line-1]'\t'$[line+2]'\t'"S" >> $1/$1.bed
			fi;
			if [[ "$b" == *".66"* ]];
				then echo -e ${1%.fa*}'\t'$[line-2]'\t'$[line+1]'\t'"S"  >> $1/$1.bed
			fi;
			if [[ "$b" == *".00"* ]];
				then echo -e ${1%.fa*}'\t'$[line-3]'\t'$line'\t'"S"  >> $1/$1.bed
			fi;
	fi;
	#ORF3a
	if [[ $line -ge 25393 && $line -le 26220 ]];
		then a=$[line-25392]
		b=$(echo "scale=2;$a/3"|bc)
		echo -e ">"'\n'$b >> $1/num2.txt
		echo -e $1'\t'"ORF3a" >> $1/num3.txt
		echo $line >> $1/num4.txt
			if [[ "$b" == *".33"* ]];
				then echo -e ${1%.fa*}'\t'$[line-1]'\t'$[line+2]'\t'"ORF3a" >> $1/$1.bed
			fi;
			if [[ "$b" == *".66"* ]];
				then echo -e ${1%.fa*}'\t'$[line-2]'\t'$[line+1]'\t'"ORF3a"  >> $1/$1.bed
			fi;
			if [[ "$b" == *".00"* ]];
				then echo -e ${1%.fa*}'\t'$[line-3]'\t'$line'\t'"ORF3a"  >> $1/$1.bed
			fi;
	fi;
	#E gene
	if [[ $line -ge 26245 && $line -le 26472 ]];
		then a=$[line-26244]
		b=$(echo "scale=2;$a/3"|bc)
		echo -e ">"'\n'$b >> $1/num2.txt
		echo -e $1'\t'"E" >> $1/num3.txt
		echo $line >> $1/num4.txt
			if [[ "$b" == *".33"* ]];
				then echo -e ${1%.fa*}'\t'$[line-1]'\t'$[line+2]'\t'"E" >> $1/$1.bed
			fi;
			if [[ "$b" == *".66"* ]];
				then echo -e ${1%.fa*}'\t'$[line-2]'\t'$[line+1]'\t'"E"  >> $1/$1.bed
			fi;
			if [[ "$b" == *".00"* ]];
				then echo -e ${1%.fa*}'\t'$[line-3]'\t'$line'\t'"E"  >> $1/$1.bed
			fi;
	fi;
	#M gene
	if [[ $line -ge 26523 && $line -le 27191 ]];
		then a=$[line-26522]
		b=$(echo "scale=2;$a/3"|bc)
		echo -e ">"'\n'$b >> $1/num2.txt
		echo -e $1'\t'"M" >> $1/num3.txt
		echo $line >> $1/num4.txt
			if [[ "$b" == *".33"* ]];
				then echo -e ${1%.fa*}'\t'$[line-1]'\t'$[line+2]'\t'"M" >> $1/$1.bed
			fi;
			if [[ "$b" == *".66"* ]];
				then echo -e ${1%.fa*}'\t'$[line-2]'\t'$[line+1]'\t'"M"  >> $1/$1.bed
			fi;
			if [[ "$b" == *".00"* ]];
				then echo -e ${1%.fa*}'\t'$[line-3]'\t'$line'\t'"M"  >> $1/$1.bed
			fi;
	fi;
	#ORF6
	if [[ $line -ge 27202 && $line -le 27387 ]];
		then a=$[line-27201]
		b=$(echo "scale=2;$a/3"|bc)
		echo -e ">"'\n'$b >> $1/num2.txt
		echo -e $1'\t'"ORF6" >> $1/num3.txt
		echo $line >> $1/num4.txt
			if [[ "$b" == *".33"* ]];
				then echo -e ${1%.fa*}'\t'$[line-1]'\t'$[line+2]'\t'"ORF6" >> $1/$1.bed
			fi;
			if [[ "$b" == *".66"* ]];
				then echo -e ${1%.fa*}'\t'$[line-2]'\t'$[line+1]'\t'"ORF6"  >> $1/$1.bed
			fi;
			if [[ "$b" == *".00"* ]];
				then echo -e ${1%.fa*}'\t'$[line-3]'\t'$line'\t'"ORF6"  >> $1/$1.bed
			fi;
	fi;
	#ORF7a
	if [[ $line -ge 27394 && $line -le 27759 ]];
		then a=$[line-27393]
		b=$(echo "scale=2;$a/3"|bc)
		echo -e ">"'\n'$b >> $1/num2.txt
		echo -e $1'\t'"ORF7a" >> $1/num3.txt
		echo $line >> $1/num4.txt
			if [[ "$b" == *".33"* ]];
				then echo -e ${1%.fa*}'\t'$[line-1]'\t'$[line+2]'\t'"ORF7a" >> $1/$1.bed
			fi;
			if [[ "$b" == *".66"* ]];
				then echo -e ${1%.fa*}'\t'$[line-2]'\t'$[line+1]'\t'"ORF7a"  >> $1/$1.bed
			fi;
			if [[ "$b" == *".00"* ]];
				then echo -e ${1%.fa*}'\t'$[line-3]'\t'$line'\t'"ORF7a"  >> $1/$1.bed
			fi;
	fi;
	#ORF7b
	if [[ $line -ge 27756 && $line -le 27887 ]];
		then a=$[line-27755]
		b=$(echo "scale=2;$a/3"|bc)
		echo -e ">"'\n'$b >> $1/num2.txt
		echo -e $1'\t'"ORF7b" >> $1/num3.txt
		echo $line >> $1/num4.txt
			if [[ "$b" == *".33"* ]];
				then echo -e ${1%.fa*}'\t'$[line-1]'\t'$[line+2]'\t'"ORF7b" >> $1/$1.bed
			fi;
			if [[ "$b" == *".66"* ]];
				then echo -e ${1%.fa*}'\t'$[line-2]'\t'$[line+1]'\t'"ORF7b"  >> $1/$1.bed
			fi;
			if [[ "$b" == *".00"* ]];
				then echo -e ${1%.fa*}'\t'$[line-3]'\t'$line'\t'"ORF7b"  >> $1/$1.bed
			fi;
	fi;
	#ORF8
	if [[ $line -ge 27894 && $line -le 28259 ]];
		then a=$[line-27893]
		b=$(echo "scale=2;$a/3"|bc)
		echo -e ">"'\n'$b >> $1/num2.txt
		echo -e $1'\t'"ORF8" >> $1/num3.txt
		echo $line >> $1/num4.txt
			if [[ "$b" == *".33"* ]];
				then echo -e ${1%.fa*}'\t'$[line-1]'\t'$[line+2]'\t'"ORF8" >> $1/$1.bed
			fi;
			if [[ "$b" == *".66"* ]];
				then echo -e ${1%.fa*}'\t'$[line-2]'\t'$[line+1]'\t'"ORF8"  >> $1/$1.bed
			fi;
			if [[ "$b" == *".00"* ]];
				then echo -e ${1%.fa*}'\t'$[line-3]'\t'$line'\t'"ORF8"  >> $1/$1.bed
			fi;
	fi;
	#N gene
	if [[ $line -ge 28274 && $line -le 29533 ]];
		then a=$[line-28273]
		b=$(echo "scale=2;$a/3"|bc)
		echo -e ">"'\n'$b >> $1/num2.txt
		echo -e $1'\t'"N" >> $1/num3.txt
		echo $line >> $1/num4.txt
			if [[ "$b" == *".33"* ]];
				then echo -e ${1%.fa*}'\t'$[line-1]'\t'$[line+2]'\t'"N" >> $1/$1.bed
			fi;
			if [[ "$b" == *".66"* ]];
				then echo -e ${1%.fa*}'\t'$[line-2]'\t'$[line+1]'\t'"N"  >> $1/$1.bed
			fi;
			if [[ "$b" == *".00"* ]];
				then echo -e ${1%.fa*}'\t'$[line-3]'\t'$line'\t'"N"  >> $1/$1.bed
			fi;
	fi;
	#ORF9b
	if [[ $line -ge 28284 && $line -le 28577 ]];
		then a=$[line-28283]
		b=$(echo "scale=2;$a/3"|bc)
		echo -e ">"'\n'$b >> $1/num2.txt
		echo -e $1'\t'"ORF9b" >> $1/num3.txt
		echo $line >> $1/num4.txt
			if [[ "$b" == *".33"* ]];
				then echo -e ${1%.fa*}'\t'$[line-1]'\t'$[line+2]'\t'"ORF9b" >> $1/$1.bed
			fi;
			if [[ "$b" == *".66"* ]];
				then echo -e ${1%.fa*}'\t'$[line-2]'\t'$[line+1]'\t'"ORF9b"  >> $1/$1.bed
			fi;
			if [[ "$b" == *".00"* ]];
				then echo -e ${1%.fa*}'\t'$[line-3]'\t'$line'\t'"ORF9b"  >> $1/$1.bed
			fi;
	fi;
	#ORF14
	if [[ $line -ge 28734 && $line -le 28955 ]];
		then a=$[line-28733]
		b=$(echo "scale=2;$a/3"|bc)
		echo -e ">"'\n'$b >> $1/num2.txt
		echo -e $1'\t'"ORF14" >> $1/num3.txt
		echo $line >> $1/num4.txt
			if [[ "$b" == *".33"* ]];
				then echo -e ${1%.fa*}'\t'$[line-1]'\t'$[line+2]'\t'"ORF14" >> $1/$1.bed
			fi;
			if [[ "$b" == *".66"* ]];
				then echo -e ${1%.fa*}'\t'$[line-2]'\t'$[line+1]'\t'"ORF14"  >> $1/$1.bed
			fi;
			if [[ "$b" == *".00"* ]];
				then echo -e ${1%.fa*}'\t'$[line-3]'\t'$line'\t'"ORF14"  >> $1/$1.bed
			fi;
	fi;
	#ORF10
	if [[ $line -ge 29558 && $line -le 29674 ]];
		then a=$[line-29557]
		b=$(echo "scale=2;$a/3"|bc)
		echo -e ">"'\n'$b >> $1/num2.txt
		echo -e $1'\t'"ORF10" >> $1/num3.txt
		echo $line >> $1/num4.txt
			if [[ "$b" == *".33"* ]];
				then echo -e ${1%.fa*}'\t'$[line-1]'\t'$[line+2]'\t'"ORF10" >> $1/$1.bed
			fi;
			if [[ "$b" == *".66"* ]];
				then echo -e ${1%.fa*}'\t'$[line-2]'\t'$[line+1]'\t'"ORF10"  >> $1/$1.bed
			fi;
			if [[ "$b" == *".00"* ]];
				then echo -e ${1%.fa*}'\t'$[line-3]'\t'$line'\t'"ORF10"  >> $1/$1.bed
			fi;
	fi;
done < $1/num1.txt

#get base specific position

seqtk subseq $1/$1.fa $1/$1.bed > $1/$1.3base.nt

#translate

transeq $1/$1.3base.nt $1/$1.3base.aa

#report
while read line; do
	grep -w $line $1/$1.nt_mismatch.grep >> $1/$1.nt_mismatch.grep.tmp
done < $1/num4.txt

grep -v ">" $1/$1.3base.nt > $1/$1.3base.nt.tmp
grep -v ">" $1/$1.3base.aa > $1/$1.3base.aa.tmp
paste $1/num3.txt $1/$1.nt_mismatch.grep.tmp  $1/$1.3base.nt.tmp $1/$1.3base.aa.tmp > $1/$1.cut_seq

#####Reference AA calling
#generate reference bed
sed "s/$1/NC_045512/g" $1/$1.bed > $1/Ref.bed
#get Ref base specific position
seqtk subseq $DIR/NC_045512.fa $1/Ref.bed > $1/$1.Ref.3base.nt
#Ref translate
transeq $1/$1.Ref.3base.nt $1/$1.Ref.3base.aa
#Ref report
grep -v ">" $1/$1.Ref.3base.nt > $1/$1.Ref.3base.nt.tmp
grep -v ">" $1/$1.Ref.3base.aa > $1/$1.Ref.3base.aa.tmp
paste $1/$1.Ref.3base.nt.tmp $1/$1.Ref.3base.aa.tmp > $1/Ref.cut_seq
awk '{print "NC_045512", $0}' $1/Ref.cut_seq > $1/Ref.cut_seq.tmp
paste $1/$1.cut_seq $1/Ref.cut_seq.tmp > $1/$1.silent_ref

#Silent position report
awk '{print $10,$3,$7}' $1/$1.silent_ref > $1/$1.silentNT_pos
sed -i 's/ //g' $1/$1.silentNT_pos
awk '{print $2, $3}' $1/$1.silent_ref > $1/$1.silentAA.tmp
while read line;do
	GENE=$(echo $line|awk '{print $1}')
	PositionNT=$(echo $line|awk '{print $2}')
	#ORF1a
	if [[ "$GENE" == "ORF1a" ]];
		then a=$[$PositionNT-265]
		b=$(echo "$a/3"|bc -l)
			if [[ "$b" == *".33"* ]];
				then echo "${b%.*}+1"|bc >> $1/$1.silentAA.pos
			fi;
			if [[ "$b" == *".66"* ]];
				then echo "${b%.*}+1"|bc >> $1/$1.silentAA.pos
			fi;
			if [[ "$b" == *".00"* ]];
				then echo ${b%.*} >> $1/$1.silentAA.pos
			fi;
	fi;
	#ORF1b
	if [[ "$GENE" == "ORF1b" ]];
		then a=$[$PositionNT-13467]
		b=$(echo "$a/3"|bc -l)
			if [[ "$b" == *".33"* ]];
				then echo "${b%.*}+1"|bc >> $1/$1.silentAA.pos
			fi;
			if [[ "$b" == *".66"* ]];
				then echo "${b%.*}+1"|bc >> $1/$1.silentAA.pos
			fi;
			if [[ "$b" == *".00"* ]];
				then echo ${b%.*} >> $1/$1.silentAA.pos
			fi;
	fi;
	#S gene
	if [[ "$GENE" == "S" ]];
		then a=$[$PositionNT-21562]
		b=$(echo "$a/3"|bc -l)
			if [[ "$b" == *".33"* ]];
				then echo "${b%.*}+1"|bc >> $1/$1.silentAA.pos
			fi;
			if [[ "$b" == *".66"* ]];
				then echo "${b%.*}+1"|bc >> $1/$1.silentAA.pos
			fi;
			if [[ "$b" == *".00"* ]];
				then echo ${b%.*} >> $1/$1.silentAA.pos
			fi;
	fi;
	#ORF3a
	if [[ "$GENE" == "ORF3a" ]];
		then a=$[$PositionNT-25392]
		b=$(echo "$a/3"|bc -l)
			if [[ "$b" == *".33"* ]];
				then echo "${b%.*}+1"|bc >> $1/$1.silentAA.pos
			fi;
			if [[ "$b" == *".66"* ]];
				then echo "${b%.*}+1"|bc >> $1/$1.silentAA.pos
			fi;
			if [[ "$b" == *".00"* ]];
				then echo ${b%.*} >> $1/$1.silentAA.pos
			fi;
	fi;
	#E gene
	if [[ "$GENE" == "E" ]];
		then a=$[$PositionNT-26244]
		b=$(echo "$a/3"|bc -l)
			if [[ "$b" == *".33"* ]];
				then echo "${b%.*}+1"|bc >> $1/$1.silentAA.pos
			fi;
			if [[ "$b" == *".66"* ]];
				then echo "${b%.*}+1"|bc >> $1/$1.silentAA.pos
			fi;
			if [[ "$b" == *".00"* ]];
				then echo ${b%.*} >> $1/$1.silentAA.pos
			fi;
	fi;
	#M gene
	if [[ "$GENE" == "M" ]];
		then a=$[$PositionNT-26522]
		b=$(echo "$a/3"|bc -l)
			if [[ "$b" == *".33"* ]];
				then echo "${b%.*}+1"|bc >> $1/$1.silentAA.pos
			fi;
			if [[ "$b" == *".66"* ]];
				then echo "${b%.*}+1"|bc >> $1/$1.silentAA.pos
			fi;
			if [[ "$b" == *".00"* ]];
				then echo ${b%.*} >> $1/$1.silentAA.pos
			fi;
	fi;
	#ORF6
	if [[ "$GENE" == "ORF6" ]];
		then a=$[$PositionNT-27201]
		b=$(echo "$a/3"|bc -l)
			if [[ "$b" == *".33"* ]];
				then echo "${b%.*}+1"|bc >> $1/$1.silentAA.pos
			fi;
			if [[ "$b" == *".66"* ]];
				then echo "${b%.*}+1"|bc >> $1/$1.silentAA.pos
			fi;
			if [[ "$b" == *".00"* ]];
				then echo ${b%.*} >> $1/$1.silentAA.pos
			fi;
	fi;
	#ORF7a
	if [[ "$GENE" == "ORF7a" ]];
		then a=$[$PositionNT-27393]
		b=$(echo "$a/3"|bc -l)
			if [[ "$b" == *".33"* ]];
				then echo "${b%.*}+1"|bc >> $1/$1.silentAA.pos
			fi;
			if [[ "$b" == *".66"* ]];
				then echo "${b%.*}+1"|bc >> $1/$1.silentAA.pos
			fi;
			if [[ "$b" == *".00"* ]];
				then echo ${b%.*} >> $1/$1.silentAA.pos
			fi;
	fi;
	#ORF7b
	if [[ "$GENE" == "ORF7b" ]];
		then a=$[$PositionNT-27755]
		b=$(echo "$a/3"|bc -l)
			if [[ "$b" == *".33"* ]];
				then echo "${b%.*}+1"|bc >> $1/$1.silentAA.pos
			fi;
			if [[ "$b" == *".66"* ]];
				then echo "${b%.*}+1"|bc >> $1/$1.silentAA.pos
			fi;
			if [[ "$b" == *".00"* ]];
				then echo ${b%.*} >> $1/$1.silentAA.pos
			fi;
	fi;
	#ORF8
	if [[ "$GENE" == "ORF8" ]];
		then a=$[$PositionNT-27893]
		b=$(echo "$a/3"|bc -l)
			if [[ "$b" == *".33"* ]];
				then echo "${b%.*}+1"|bc >> $1/$1.silentAA.pos
			fi;
			if [[ "$b" == *".66"* ]];
				then echo "${b%.*}+1"|bc >> $1/$1.silentAA.pos
			fi;
			if [[ "$b" == *".00"* ]];
				then echo ${b%.*} >> $1/$1.silentAA.pos
			fi;
	fi;
	#N gene
	if [[ "$GENE" == "N" ]];
		then a=$[$PositionNT-28273]
		b=$(echo "$a/3"|bc -l)
			if [[ "$b" == *".33"* ]];
				then echo "${b%.*}+1"|bc >> $1/$1.silentAA.pos
			fi;
			if [[ "$b" == *".66"* ]];
				then echo "${b%.*}+1"|bc >> $1/$1.silentAA.pos
			fi;
			if [[ "$b" == *".00"* ]];
				then echo ${b%.*} >> $1/$1.silentAA.pos
			fi;
	fi;
	#ORF9b
	if [[ "$GENE" == "ORF9b" ]];
		then a=$[$PositionNT-28283]
		b=$(echo "$a/3"|bc -l)
			if [[ "$b" == *".33"* ]];
				then echo "${b%.*}+1"|bc >> $1/$1.silentAA.pos
			fi;
			if [[ "$b" == *".66"* ]];
				then echo "${b%.*}+1"|bc >> $1/$1.silentAA.pos
			fi;
			if [[ "$b" == *".00"* ]];
				then echo ${b%.*} >> $1/$1.silentAA.pos
			fi;
	fi;
	#ORF14
	if [[ "$GENE" == "ORF14" ]];
		then a=$[$PositionNT-28733]
		b=$(echo "$a/3"|bc -l)
			if [[ "$b" == *".33"* ]];
				then echo "${b%.*}+1"|bc >> $1/$1.silentAA.pos
			fi;
			if [[ "$b" == *".66"* ]];
				then echo "${b%.*}+1"|bc >> $1/$1.silentAA.pos
			fi;
			if [[ "$b" == *".00"* ]];
				then echo ${b%.*} >> $1/$1.silentAA.pos
			fi;
	fi;
	#ORF10
	if [[ "$GENE" == "ORF10" ]];
		then a=$[$PositionNT-29557]
		b=$(echo "$a/3"|bc -l)
			if [[ "$b" == *".33"* ]];
				then echo "${b%.*}+1"|bc >> $1/$1.silentAA.pos
			fi;
			if [[ "$b" == *".66"* ]];
				then echo "${b%.*}+1"|bc >> $1/$1.silentAA.pos
			fi;
			if [[ "$b" == *".00"* ]];
				then echo ${b%.*} >> $1/$1.silentAA.pos
			fi;
	fi;
done < $1/$1.silentAA.tmp

paste $1/$1.silent_ref $1/$1.silentAA.pos > $1/$1.silentAA.tmp2
awk '{print $10, $11, $7}' $1/$1.silentAA.tmp2 > $1/$1.silentAA.tmp3
sed -i 's/ //g' $1/$1.silentAA.tmp3
paste $1/$1.silentAA.tmp2 $1/$1.silentNT_pos $1/$1.silentAA.tmp3 > $1/$1.silent_report.tmp
awk '{print $3, $5}' $1/$1.silent_report.tmp > $1/$1.ntchange.tmp
sed -z 's/>/\t/g' $1/$1.ntchange.tmp >$1/$1.ntchange2.tmp
awk '{print $2$1$3}' $1/$1.ntchange2.tmp > $1/$1.ntchange3.tmp
paste $1/$1.silent_report.tmp $1/$1.ntchange3.tmp > $1/$1.silent_report
