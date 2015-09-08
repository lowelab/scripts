#!/bin/sh

#Programs/pipeline to run:
    #delete the contents of the results directory
    #STRUCTURE
    #remove .DS_Store from results/STRUCTURE folder (CLUMPPAK wont work unless this is removed)
    #zip STRUCTURE results
    #STRUCTURE harvested
    #remove 'noise' from evanno output file and refile the table
    #extract best K from the new extracted file
    #reformat best K IND/POPFILEs as .txt files
    #CLUMPP for both population and individual clusters (needed for DISTRUCT)
    #DISTRUCT

#%%%%%%NOTES FOR WHAT TO DO NEXT%%%%#

#make a line for "Run name""?
#make "$Runname"results folder? or use existing ones?
#make a line for burning and run length, and sed replace the main params file accordingly (like strauto program)
#get parallel working
#fix the DISTRUCT draw params file so the image fits onto the page better

#%%%%%end Notes%%%%%#

#---------------User input variables---------------#

#----------all programs----------#

    ##Important##
    
    #Remove all results from previous runs prior to running this shell
    #all files be deleted at the beginning of each run

Min=2		#=Minimum K to test
Max=6		#=Maximum K to test (structure will run Max + 1 K's)
Rep=3		#=Replicates of each K to test
Ind=840		#=Number of Individuals in the dataset (Info used in CLUMPP)
Pop=43		#=Number of populations in the dataset (Info used in CLUMPP)
Loc=104		#=number of Loci in dataset
#BURN=100   #=length of STRUCTURE burnin period (will replace existing test in mainparams file)
#REPS=200   #=number of MCMC reps in STRUCTURE after burnin (will replace existing test in mainparams file)

#Structure Input file#    #change accordingly

INPUT=A2S3_West_east.txt

#DISTRUCT Label Below file#    #change accordingly

LB=A2S3_WE_pop.txt

#---------------end variables---------------#


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


#~~~~~~~~~~ non variable amendments required for programs ~~~~~~~~~~#

#~~~~~ STRUCTURE ~~~~~#

#the length of burnin and run need to be specified in the mainparams file
#at present the input file is set from the mainparams file

#~~~~~~~~~~ end non variable ~~~~~~~~~~#


#==========Start analysis==========#

echo "Starting structure_pipeline analysis"
echo "analysis started at $(date)"

#=====run delete contents of results Directory=====#

echo "deleting contents of results folder"

find results -type f -delete

#=====end clear results Directory=====#

#=====run STRUCTURE=====#

echo "running STRUCTURE"
echo "started at $(date)"

for a in $(seq $Min $(($Max+1)))     #uses the Min and Max values from input variables
do
   for b in $(seq 1 $Rep)    #uses Rep information from input variables
   do
      ./structure -i "$INPUT" -K "$a" -L "$Loc" -N "$Ind" -o results/STRUCTURE/structure_K"$a"_R"$b"
   done
done

echo "STRUCTURE complete"
echo "completed at $(date)"

#=====end STRUCTURE=====#

#=====remove .DS_Store file from STRUCTURE results folder=====#

rm -rf results/STRUCTURE/.DS_Store

#=====end .DS_Store remove=====#

#=====zip STRUCTURE results folder=====#

echo "ziping STRUCTURE results"

zip -r results/STRUCTURE{.zip,}

#=====end zip=====#

#=====run STRUCTURE harvester=====#

echo "running STRUCTURE harvester"
echo "started at $(date)"

./structureHarvester.py --dir=results/STRUCTURE --out=results/harvested --clumpp --evanno

echo "STRUCTURE harvester completed"
echo "completed at $(date)"

#=====end STRUCTURE Harvester=====#

#=====remove unwanted lines from evanno.txt file, rename the output=====#

echo "reformating STRUCTURE harvester results to identify best K and make files suitable for CLUMPP"
echo "started at $(date)"

sed -e '1,17d' results/harvested/evanno.txt > results/harvested/subevanno.txt

#=====end remove/rename=====#

#=====find best K=====#

c=$(sort -nrk7 results/harvested/subevanno.txt | head -1 | cut -f1)

echo 
echo best delta K = "$c"
echo 

#=====end find best K=====#

#=====reformat best K INDFILE and POPFILE=====#

cp results/harvested/K"$c".indfile  results/harvested/K"$c".indfile.txt
cp results/harvested/K"$c".popfile  results/harvested/K"$c".popfile.txt

echo "reformatting completed"
echo "completed at $(date)"

#=====end reformat=====#

#=====run CLUMPP=====#

echo "running CLUMPP"
echo "started at $(date)"

    this will run CLUMPP for both population and individual, needed for DISTRUCT

echo "running CLUMPP on Individual data"
echo "started at $(date)"

./CLUMPP paramfile_0 -i results/harvested/K"$c".indfile.txt -p results/harvested/K"$c".popfile.txt -o results/CLUMPP/K"$c".indoutfile.txt -j results/CLUMPP/K"$c".indmiscfile.txt -k "$c" -r "$Rep" -c "$Ind"

echo "CLUMPP on Individual data completed"
echo "completed at $(date)"

echo "running CLUMPP on Population data"
echo "started at $(date)"

./CLUMPP paramfile_1 -i results/harvested/K"$c".indfile.txt -p results/harvested/K"$c".popfile.txt -o results/CLUMPP/K"$c".popoutfile.txt -j results/CLUMPP/K"$c".popmiscfile.txt -k "$c" -r "$Rep" -c "$Pop"

echo "CLUMPP on Population data completed"
echo "completed at $(date)"

echo "CLUMPP completed"
echo "completed at $(date)"

#=====end CLUMPP=====#

#=====run DISTRUCT=====#

echo "running DISTRUCT"
echo "started at $(date)"

./distructMac2013 -K "$c" -M "$Pop" -N "$Ind" -p results/CLUMPP/K"$c".popoutfile.txt -i results/CLUMPP/K"$c".indoutfile.txt -b "$LB" -o results/DISTRUCT/"$INPUT"_K"$c".ps

echo "DISTRUCT completed"
echo "completed at $(date)"

#=====end DISTRUCT=====#

echo "structure_pipeline completed"
echo "analysis completed at $(date)"

#==========end analysis==========#