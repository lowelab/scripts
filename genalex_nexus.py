#!/usr/bin/env python

import csv
import sys

Usage ="""
genalex_nexus.py - version 1.0		version 1.1	created 12/12/2013, last update 23/12/2013
Convert GenAlEx SNP input file (tab delimited txt file, 
		0 , 1 , - converted [e.g. using 0101converter.py]) 
		into Nexus SNP input file(for SNAPP).
Save to new .nex file

Usage: 
	genalex_nexus.py filename.txt 
Input: [number of taxa] [number of SNPs]
"""

if len(sys.argv)<2:
	print Usage
else:
	File = sys.argv[1] #first input is the text file
	Ntaxa = raw_input("Number of taxa:")
	Nchar = raw_input("Number of SNPs:")
	print "File:",File, "ntax:",Ntaxa," nchar:",Nchar
	
	LOL = list(csv.reader(open(File,'rb'), delimiter='\t')) 
	# open file as read only, input data 
	#turn tab-delimited data into a list of lists 
	#(each line becomes a list of string values)
	#print LOL


	OutLOS = [] # final format list of strings for printing to file
	
	OutputFileName = File + '.nex'
	OutputFile = open(OutputFileName, 'wb') #open an output file
	header = '#NEXUS\n\nBegin data;\n\tDimensions ntax=%s nchar=%s;\n\
\tFormat datatype=standard symbols="012" gap=-;\n\tMatrix\n' % (Ntaxa, Nchar)
	OutputFile.write(header) # start output file with header info incl user input
	
	LineNum = 0 # a counter for line number in LOL		
	for List in LOL:
		if LineNum >2:
			ItemCount = 0
			paircount = 0
			for item in List:
				
				if ItemCount == 0:
					Name = item.strip()
				elif ItemCount == 1:
					Name += '_'+item +'\t'
				elif ItemCount > 1:
					if item == '-':
						if paircount == 0:
							Name += item
							paircount = 1
						elif paircount == 1:
							paircount = 0
					elif paircount == 0:
						N = int(item)
						paircount = 1
					elif paircount == 1:
						N = N + int(item)
						Name += str(N)
						paircount = 0
				ItemCount += 1
			OutLOS.append(Name)	
		LineNum += 1			
	#print OutLOS
	
	for Line in OutLOS:
		OutputFile.write(Line + '\n') 
	OutputFile.write("\t;\nEnd;\n")
	OutputFile.close()
	print "Output File : " + OutputFileName		
	
	