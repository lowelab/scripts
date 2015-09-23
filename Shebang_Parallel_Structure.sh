

#!/usr/bin/parallel --shebang-wrap bash

#running structure on the command line
#if structure, param files and input file are in the working directory
#just fill in the following 3 variables (and make sure the param files are completed
#need to change extraparams file "#define RANDOMIZE" =0 and remove # from in front of "#define SEED"

NAME=Testdata1			#supply file name suffix
MAXK=5					#supply max number of K value to test (K = 1-? )
NREP=10					#supply number of reps for each Kvalue test




mkdir results

COUNTER=1 
while [  $COUNTER -le $MAXK  ]; do 
	REP=1
	while [ $REP -le $NREP ]; do
		nohup ./structure -D $[RANDOM % 999999999] -K $COUNTER -o ./results/"$NAME"_K"$COUNTER"_rep"$REP" 2> ./nohup.out < /dev/null &
		REP=$((REP+1))
		done
	let COUNTER=COUNTER+1
done	


echo "Enter 'ps' to see Structure processes running"	
#  -e extraparams -m mainparams
