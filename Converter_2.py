#!/usr/bin/env python

Usage ="""
Converter.py - version 1.0
Convert STRUCTURE SNP input file (tab delimited txt file) into TREEMIX input file.
Save to new .txt file

Usage: 
	Converter.py *.txt 2(column containing population data, and immediately before snp data columns)
	 > *TreeMix.txt
"""
import sys
import csv

if len(sys.argv)<2:
	print Usage
else:
	File = sys.argv[1] #first input is the text file
	PopColumn = int(sys.argv[2])
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
			PopList.append(int(Line[(PopColumn-1)])) #make a list of values in pop column
		Count += 1
	
	Popint = list(set(PopList)) # create a set of the values present
	Popint.sort()                         # one value for each population
	Pops = [str(i) for i in Popint]
#	print Pops
	
	Header = '\t'.join(Pops) # the column headers of the final file
#	print Header
	                          
	for Pop in Pops: # for each population in turn
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
			for Datum in LineList:			# for each datum in the list
				
				if ListCount == 0:
					PopLOL.append(list(Datum))
#					PopLOL[SnpCount] = list(Datum) #start string with 1st Datum
				else:						
					PopLOL[SnpCount].append(Datum) # tab and next datum, etc
				SnpCount += 1
			ListCount += 1
#		for x in PopLOL:
#			print x
		
		
					
					
					
					
					