#! /bin/bash

#running structure on the command line
#if structure, param files and input file are in the working directory
#just fill in the following 3 variables (and make sure the param files are completed
#need to change extraparams file "#define RANDOMIZE" =0 and remove # from in front of "#define SEED"

NAME=Testdata1			#supply file name suffix
MAXK=5					#supply max number of K value to test (K = 1-? )
NREP=10					#supply number of reps for each Kvalue test

if [ ! -d ./results ]
then mkdir results
fi
if [ -f ./commands.txt ]
then rm commands.txt
fi

COUNTER=1 
while [  $COUNTER -le $MAXK  ]; do 
	REP=1
	while [ $REP -le $NREP ]; do
		echo "nohup ./structure -D $[RANDOM % 999999999] -K $COUNTER -o ./results/"$NAME"_K"$COUNTER"_rep"$REP" 2> ./nohup.out < /dev/null " >> commands.txt
		REP=$((REP+1))
		done
	let COUNTER=COUNTER+1
done	
nohup parallel < commands.txt &
sleep 2
echo "*"
echo "*"
echo "Enter 'ps' to see Structure processes running"
echo "*"
echo "*"
	
#  -e extraparams -m mainparams
