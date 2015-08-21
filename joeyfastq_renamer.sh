#! /bin/bash

files=$(ls | grep "barcd_.....fq.gz")
for i in $files; do 
	name=$(echo $i | sed "s/\(_[0-9][0-9]\)\(.*\)/\1_trimmed\2/")
	echo "$name"
	mv $i $name
done

#this worked for renaming files, adding the word trimmed after 2 digits.




for i in TS*.fastq; do 
	name=$(echo $i | sed "s/^\([A-Za-z0-9_]*\) .*/\1/")
	echo "$name"
	sed "s/^@.*/@$name/" "$i" >> test/"$name".fastq
done
#i="TS045_3_TRI_5_Ghana trimmed.fastq"
#name=$(echo $i | sed 's/\([A-Z0-9]*\)_/\1/')
#echo $name
#echo $name

#s="one two"
#ss=$(echo $s | sed 's/\(one\) \(two\)/\2 \1/')
#echo $ss

NAME=335wolves_26msats	#supply file name suffix for output files
MAXK=3					#supply max number of K value to test (K = 1-? )
NREP=3					#supply number of reps for each Kvalue test


COUNTER=1 
while [  $COUNTER -le $MAXK  ]; do 
	REP=1
	while [ $REP -le $NREP ]; do
		./structure -m mainparams -e extraparams -K $COUNTER -o "$NAME"_K"$COUNTER"_rep"$REP".txt
		REP=$((REP+1))
		done
	let COUNTER=COUNTER+1
done	
	