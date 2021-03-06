#! /bin/bash

#running structure on the command line
#if structure, param files and input file are in the working directory
#just fill in the following 3 variables (and make sure the param files are completed
#need to change extraparams file "#define RANDOMIZE" =0 and remove # from in front of "#define SEED"

NAME=Testdata1			#supply file name suffix
MAXK=5					#supply max number of K value to test (K = 1-? )
NREP=5					#supply number of reps for each Kvalue test

mkdir results

COUNTER=1 
while [  $COUNTER -le $MAXK  ]; do 
	REP=1
	while [ $REP -le $NREP ]; do
		nohup ./structure -m mainparams -D $[RANDOM % 9999999]$COUNTER$REP -K $COUNTER -o ./results/"$NAME"_K"$COUNTER"_rep"$REP" 2> /dev/null < /dev/null &
		REP=$((REP+1))
		done
	let COUNTER=COUNTER+1
done	
echo "Enter 'ps' to see Structure processes running"	
#  -e extraparams

#Running STRUCTURE

#From the command line, with your path in the folder containing both your infile and the
#executable....

#For K=2, 
#./structure -m mainparams -e extraparams -K 2 -L 26 -N 335 -i 335wolves_26msats_structure.txt -o 335wolves_26msats_K2_rep01.txt
#./structure -m mainparams -e extraparams -K 2 -L 26 -N 335 -i 335wolves_26msats_structure.txt -o 335wolves_26msats_K2_rep02.txt
#./structure -m mainparams -e extraparams -K 2 -L 26 -N 335 -i 335wolves_26msats_structure.txt -o 335wolves_26msats_K2_rep03.txt
#./structure -m mainparams -e extraparams -K 2 -L 26 -N 335 -i 335wolves_26msats_structure.txt -o 335wolves_26msats_K2_rep04.txt
#./structure -m mainparams -e extraparams -K 2 -L 26 -N 335 -i 335wolves_26msats_structure.txt -o 335wolves_26msats_K2_rep05.txt
#./structure -m mainparams -e extraparams -K 2 -L 26 -N 335 -i 335wolves_26msats_structure.txt -o 335wolves_26msats_K2_rep06.txt
#./structure -m mainparams -e extraparams -K 2 -L 26 -N 335 -i 335wolves_26msats_structure.txt -o 335wolves_26msats_K2_rep07.txt
#./structure -m mainparams -e extraparams -K 2 -L 26 -N 335 -i 335wolves_26msats_structure.txt -o 335wolves_26msats_K2_rep08.txt
#./structure -m mainparams -e extraparams -K 2 -L 26 -N 335 -i 335wolves_26msats_structure.txt -o 335wolves_26msats_K2_rep09.txt
#./structure -m mainparams -e extraparams -K 2 -L 26 -N 335 -i 335wolves_26msats_structure.txt -o 335wolves_26msats_K2_rep10.txt
#
#./structure -m mainparams -e extraparams -K 2 -o 335wolves_26msats_K2_rep01.txt
#./structure -m mainparams -e extraparams -K 2 -o 335wolves_26msats_K2_rep02.txt
#./structure -m mainparams -e extraparams -K 2 -o 335wolves_26msats_K2_rep03.txt
#./structure -m mainparams -e extraparams -K 2 -o 335wolves_26msats_K2_rep04.txt
#./structure -m mainparams -e extraparams -K 2 -o 335wolves_26msats_K2_rep05.txt
#./structure -m mainparams -e extraparams -K 2 -o 335wolves_26msats_K2_rep06.txt
#./structure -m mainparams -e extraparams -K 2 -o 335wolves_26msats_K2_rep07.txt
#./structure -m mainparams -e extraparams -K 2 -o 335wolves_26msats_K2_rep08.txt
#./structure -m mainparams -e extraparams -K 2 -o 335wolves_26msats_K2_rep09.txt
#./structure -m mainparams -e extraparams -K 2 -o 335wolves_26msats_K2_rep10.txt
#
#For K=3, 
#./structure -m mainparams -e extraparams -K 3 -L 26 -N 335 -i 335wolves_26msats_structure.txt -o 335wolves_26msats_K3.txt
#
#For K=4, 
#./structure -m mainparams -e extraparams -K 4 -L 26 -N 335 -i 335wolves_26msats_structure.txt -o 335wolves_26msats_K4.txt
#
#For K=10, 
#./structure -m mainparams -e extraparams -K 10 -L 26 -N 335 -i 335wolves_26msats_structure.txt -o 335wolves_26msats_K10.txt
#