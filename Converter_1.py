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
	#turn tab-delimited data into a list of lists 
	#(each line becomes a list of string values)
	#print LOL
	
	LineNum = 0 # a counter for line number in LOL
	OutLOL = [] # final format list of lists, which will then be returned to csv
	
	
	PopList = []
	Count = 0
	for Line in LOL: # loop once per line
		if Count > 0:
			PopList.append(Line[(PopColumn-1)]) #make a list of values in pop column
		Count += 1
	Pops = list(set(PopList)) # create a set of the values present
	                          # one value for each population
	                          
	for Pop in Pops:
		PopFileName = 'Pop' + Pop + '.txt' # for each population,
		PopFile = open(PopFileName, 'ab') # create a blank .txt file
		PopCount = 0
		LineCount = 0
		ItemCount = 0
		for Line in LOL:     #loop through lists in the LOL
			if PopCount > 0:   #skip first line

				if Line[(PopColumn-1)] == Pop: #if line is from pop
					if LineCount = 0 
					#PopFile.write(str(Line[PopColumn:])+'\n') 	#write data in the pop.txt
						for Item in Line[PopColumn:]:
							SnpList = list(Line[(PopColumn+LineCount)])
					
					LineCount += 1
						
					
					
			PopCount = PopCount + 1	
			
		