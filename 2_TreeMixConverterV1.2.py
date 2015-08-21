#!/usr/bin/env python

Usage ="""
Converter.py - version 1.2	created 28/11/2013, last update 18/3/2014
updated:this version inputs a standard - 2 columns for each SNP. one row for each individual
Convert STRUCTURE SNP input file (0,1 (missing = blank); tab delimited text file) into TREEMIX input file.
Input: Number of column containing population data, and immediately before snp data columns
Save to new text file, gzip text file, and text file with the population list ordered

Usage: 
	Converter.py *.*   [*.* = input file name]
Output :
	{TreeMix_*.*} and {TreeMix_*.*.gz} and {poporder}
"""
import sys
import csv
import gzip
import os

if len(sys.argv)<2:
	print Usage
else:
	File = sys.argv[1] #first input is the text file
	PopColumn = int(raw_input("Column number of population information (integer) :"))
	print "File:",File, ";  Populations column:",PopColumn
	
	LOL = list(csv.reader(open(File,'rb'), delimiter='\t')) 
	# open file as read only, input data 
	#turn tab-delimited data into a list of lists 
	#(each line becomes a list of string values)
	#print LOL
	
	LineNum = 0 # a counter for line number in LOL
	OutLOS = [] # final format list of strings for printing to file
	
	
	PopList = [] # create a list for data in population column
	Count = 0
	for Line in LOL: # loop once per line
		if Count > 0:
#			PopList.append(int(Line[(PopColumn-1)])) #make a list of values in pop column
			PopList.append(Line[(PopColumn-1)])
		Count += 1
	
	Popset = list(set(PopList)) # create a set of the values present
	Popset.sort()                         # one value for each population
	Pops = Popset
#	Pops = [str(i) for i in Popint]
#	print Pops
	
	Header = ' '.join(Pops) # the column headers of the final file
#	print Header
	OutLOS.append(Header)
#	print OutLOS
	Poporder = open("poporder", 'wb')    #create poporder file for treemix plots                     
	for Pop in Pops: # for each population in turn
		Poporder.write(Pop + "\n")
		PopFileName = 'Pop' + Pop + '.txt' #create a file for each population
		PopFile = open(PopFileName, 'wb') # open the pop file for writing
		PopCount = 0
		# Count3 = 0
		for Line in LOL:     #loop through lists in the LOL
			if PopCount > 0:   #skip first line

				if Line[(PopColumn-1)] == Pop:  # if it's in the pop, 
					#LineString = 
					PopFile.write(str(Line[PopColumn:])+'\n') 	# add the data to the file
			PopCount = PopCount + 1	
	Poporder.close()

	FirstPop = 0
	for Pop in Pops:							# for each population
		ListCount = 0
		PopFileName = 'Pop' + Pop + '.txt'
#		print PopFileName
		PopFile = open(PopFileName, 'rb')	# open the popfile for reading
		
#		PopLOL = [None]*max( )
		PopLOL = []
		for Line in PopFile:					# for each line of data
			Line = Line.strip('\n').strip("['").strip("']")#.strip("'").strip("'")
			LineList = Line.split("', '" )	# return the line to a list
			#print LineList
			SnpCount = 0
			twogeno = 0	
			for Datum in LineList:			# for each datum in the list
				if twogeno == 0:
					if ListCount == 0:
						PopLOL.append(list(Datum))
	#					PopLOL[SnpCount] = list(Datum) #start string with 1st Datum
					else:						
						PopLOL[SnpCount].append(Datum) # tab and next datum, etc
					twogeno += 1
					
				elif twogeno ==1:
					PopLOL[SnpCount].append(Datum) # tab and next datum, etc
					twogeno = 0
					SnpCount += 1
			ListCount += 1
#		for x in PopLOL:
#			print x
		
		SNPNumber = 1
		for SNP in PopLOL:
			Count0 = 0
			Count1 = 0
			for Datum in SNP:
				if Datum == '0':
					Count0 += 1
				elif Datum == '1':
					Count1 += 1
			if FirstPop == 0:
				OutLOS.append(str(Count0) + ',' + str(Count1))
			else:
				OutLOS[SNPNumber] += ' ' + (str(Count0) + ',' + str(Count1))
			
			SNPNumber += 1
		PopFile.close()
		os.remove(PopFileName)
		FirstPop += 1
					
#	for i in OutLOS:
#		print i				
	OutputFileName = 'TreeMix_' + File 
	OutputFile = open(OutputFileName, 'w') #open an output file
	for Line in OutLOS:
		OutputFile.write(Line + '\n') 
	OutputFile.close()
	print "Output File : " + OutputFileName	
	
	OutText = open(OutputFileName, 'rb')
	CompressedOutput = gzip.open(OutputFileName + ".gz", 'wb')
	CompressedOutput.writelines(OutText)	
	OutText.close()
	CompressedOutput.close()			
					
					