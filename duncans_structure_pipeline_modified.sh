#!/bin/sh



#---------------User input variables---------------#

#----------all programs----------#

    ##Important##
    
    #Remove all results from previous runs prior to running this shell
    #all files be deleted at the beginning of each run


NAME=Testdata1			#supply file name suffix
MINK=1					#supply minimum K value (usually 1)
MAXK=5					#supply max number of K value to test (K = 1-? )
NREP=10					#supply number of reps for each Kvalue test


#Min=2		#=Minimum K to test
#Max=6		#=Maximum K to test (structure will run Max + 1 K's)
#Rep=3		#=Replicates of each K to test
Ind=200		#=Number of Individuals in the dataset (Info used in CLUMPP)
Pop=2		#=Number of populations in the dataset (Info used in CLUMPP)
#Loc=104		#=number of Loci in dataset
#BURN=100   #=length of STRUCTURE burnin period (will replace existing test in mainparams file)
#REPS=200   #=number of MCMC reps in STRUCTURE after burnin (will replace existing test in mainparams file)

#Structure Input file#    #change accordingly

#INPUT=A2S3_West_east.txt (in mainparams)

#DISTRUCT Label Below file#    #change accordingly

#LB=A2S3_WE_pop.txt

#---------------end variables---------------#



#~~~~~ STRUCTURE ~~~~~#

# Edit the mainparams file:
#		Set the parameters of your run with BURNIN ; NUMREPS
#		Spend time getting the information from your dataset entered correctly. Pay particular attention to:
#        - NUMINDS ; NUMLOCI ; MISSING ; ONEROWPERIND ; LABEL ; POPDATA ; EXTRACOLS ; MARKERNAMES

#~~~~~~~~~~ end non variable ~~~~~~~~~~#


#==========Start analysis==========#

echo "Starting structure_pipeline analysis"
echo "analysis started at $(date)"

#=====run delete contents of Results Directory=====#

echo "deleting contents of Results folder"


if [ -d ./results ]
then rm -r results
mkdir results
fi

if [ -f ./commands.txt ]
then rm commands.txt
fi

if [ -f ./results.zip ]
then rm results.zip
fi
#=====end clear Results Directory=====#

#=====run STRUCTURE=====#

echo "running STRUCTURE"
echo "started at $(date)"



COUNTER=$MINK 
while [  $COUNTER -le $MAXK  ]; do 
	REP=1
	while [ $REP -le $NREP ]; do
		echo "nohup ./structure -D $[RANDOM % 999999999] -K $COUNTER -o ./results/"$NAME"_K"$COUNTER"_rep"$REP" 2>&1 " >> commands.txt
		REP=$((REP+1))
		done
	let COUNTER=COUNTER+1
done	
nohup parallel < commands.txt &
wait



echo "STRUCTURE complete"
echo "completed at $(date)"

#=====end STRUCTURE=====#

#=====remove .DS_Store file from STRUCTURE Results folder=====#

if [ -f results/.DS_Store ]
then rm results/.DS_Store
fi

#=====end .DS_Store remove=====#

#=====zip STRUCTURE Results folder=====#

echo "zipping STRUCTURE results"

zip -r results{.zip,}

#=====end zip=====#

#=====run STRUCTURE harvester=====#

echo "running STRUCTURE harvester"
echo "started at $(date)"

./Harvester/structureHarvester.py --dir=results --out=results/HARVESTER --clumpp --evanno

echo "STRUCTURE harvester completed"
echo "completed at $(date)"

#=====end STRUCTURE Harvester=====#

#=====remove unwanted lines from evanno.txt file, rename the output=====#

echo "reformating STRUCTURE harvester results to identify best K and make files suitable for CLUMPP"
echo "started at $(date)"

sed -e '1,18d' results/HARVESTER/evanno.txt > results/HARVESTER/subevanno.txt

#=====end remove/rename=====#

#=====find best K=====#

c=$(sort -nrk7 results/HARVESTER/subevanno.txt | head -1 | cut -f1)

echo 
echo best delta K = "$c"
echo 

#=====end find best K=====#

#=====reformat best K INDFILE and POPFILE=====#

cp results/HARVESTER/K"$c".indfile  results/HARVESTER/K"$c".indfile.txt
cp results/HARVESTER/K"$c".popfile  results/HARVESTER/K"$c".popfile.txt

echo "reformatting completed"
echo "completed at $(date)"

#=====end reformat=====#

#=====run CLUMPP=====#

echo "running CLUMPP"
echo "started at $(date)"

#    this will run CLUMPP for both population and individual, needed for DISTRUCT

echo "running CLUMPP on Individual data"
echo "started at $(date)"
mkdir results/CLUMPP
cd CLUMPP
./CLUMPP paramfile_ind -i ../results/HARVESTER/K"$c".indfile.txt -p ../results/HARVESTER/K"$c".popfile.txt -o ../results/CLUMPP/K"$c".indoutfile.txt -j ../results/CLUMPP/K"$c".indmiscfile.txt -k "$c" -r "$NREP" -c "$Ind"

echo "CLUMPP on Individual data completed"
echo "completed at $(date)"

echo "running CLUMPP on Population data"
echo "started at $(date)"

./CLUMPP paramfile_pop -i ../results/HARVESTER/K"$c".indfile.txt -p ../results/HARVESTER/K"$c".popfile.txt -o ../results/CLUMPP/K"$c".popoutfile.txt -j ../results/CLUMPP/K"$c".popmiscfile.txt -k "$c" -r "$NREP" -c "$Pop"

echo "CLUMPP on Population data completed"
echo "completed at $(date)"

echo "CLUMPP completed"
echo "completed at $(date)"

#=====end CLUMPP=====#

#=====run DISTRUCT=====#
cd ../
mkdir results/DISTRUCT
cd distruct1.1/
echo "running DISTRUCT"
echo "started at $(date)"

./distructLinux1.1 -K "$c" -M "$Pop" -N "$Ind" -p ../results/CLUMPP/K"$c".popoutfile.txt -i ../results/CLUMPP/K"$c".indoutfile.txt -o ../results/DISTRUCT/"$NAME"_K"$c".ps
#./distruct1.1/distructLinux1.1 -K "$c" -M "$Pop" -N "$Ind" -p results/CLUMPP/K"$c".popoutfile.txt -i results/CLUMPP/K"$c".indoutfile.txt -b "$LB" -o results/DISTRUCT/"$INPUT"_K"$c".ps


echo "DISTRUCT completed"
echo "completed at $(date)"
cd ../
#=====end DISTRUCT=====#

echo "structure_pipeline completed"
echo "analysis completed at $(date)"

#==========end analysis==========#


#++++++++++Variables available for each program++++++++++#

#+++++STRUCTURE+++++#

#-m mainparams
#-e extraparams
#-s stratparams
#-i input file
#-o output file
#-K MAXPOPS = $a
#-L NUMLOCI =$Loc
#-N NUMINDS =$Ind
#-D SEED

#+++++CLUMPP+++++#

#-i (INDFILE) Read a different indfile from the one specified in paramfile.
#-p (POPFILE) Read a different popfile from the one specified in paramfile.
#-o (OUTFILE) Print to a different outfile from the one specified in paramfile.
#-j (MISCFILE) Print to a different miscfile from the one specified in paramfile.
#-k (K) Change the number of clusters.
#-c (C) Change the number of populations.
#-r (R) Change the number of runs.
#-m (M) Change the choice of algorithm (1 = FullSearch, 2 = Greedy, 3 = LargeKGreedy).
#-w (W) Change the procedure for weighting by the number of individuals (1 = weight by number of individuals, 0 = weight each line equally). If DATATYPE = 0, this option is automatically set to 0.
#-s (S) Change the choice of pairwise matrix similarity statistic (1 for G and 2 for G′).

#+++++Distruct+++++#

#-d (drawparams) Read a different parameter input file instead of drawparams.
#-K (K) Change the number of clusters.
#-M (NUMPOPS) Change the number of predefined populations.
#-N (NUMINDS) Change the number of individuals.
#-p (input file) Read a different input file for the population Q-matrix.
#-i (input file) Read a different input file for the individual Q-matrix.
#-a (input file) Read a different input file for the labels to be printed atop the figure.
#-b (input file) Read a different input file for the labels to be printed below the figure.
#-c (input file) Read a different input file for the permutation of clusters and the colors.
#-o (output file) Print results to a different output file.

#++++++++++end available++++++++++#