#!/usr/bin/env python

Usage ="""
0101converter.py - version 1.0 by Joey Gerlach 13/12/2013
Converts a SNP file with multiple characters(1,2,3,4) to (0,1) file

input, tab delimited text file; 
column and row number (counting from 1), after which all entries are data;
input character for missing data, will be converted to '-'; 
important - only 2 character types per row (plus missing data character)

Usage: 
	0101converter.py *.txt [row number] [column number] [missing data character] 
"""
import sys
import csv


if len(sys.argv)<5:
	print Usage
else:
	File = sys.argv[1] #first input is the text file
	Row = int(sys.argv[2]) -1
	Col = int(sys.argv[3]) -1
	Miss = sys.argv[4]
	print "File:",File, ";  start data:",str(Row+1)+','+str(Col+1), " ;  missing data:", Miss
	
	LOL = list(csv.reader(open(File,'rb'), delimiter='\t')) 
	# open file as read only, input data 
	#turn tab-delimited data into a list of lists 
	#(each line becomes a list of string values)
	#print LOL
	
	LineNum = 0 # a counter for line number in LOL
	OutLOS = [] # final format list of strings for printing to file
	NCols = (len(LOL[1]) - Col ) #count the number of columns with data to be changed
	
	
	TwistedLOL = []
	
	Count = Col
	for i in range(NCols):
		List = [Line[Count] for Line in LOL[Row:]]
		Count += 1
		TwistedLOL.append(List)   #make a new list of lists, lists of columns of
					#data, only including data to be changed
	ListNum = 0	
	NewTwisted = []
	for Lists in TwistedLOL:
		Iteration = 0
		Line = []
		for datum in Lists:
			if datum == Miss:
				datum = '-'		#missing data to '-'-
			else:
				if Iteration == 0:
					char = datum
					datum = '0'			#first SNP character to '0'
				else:
					if datum == char:
						datum = '0'
					else:
						datum = '1'		#second SNP char to '1'
				Iteration += 1
			Line.append(datum)
		NewTwisted.append(Line)		#write it to a new list of lists
#	print NewTwisted

	NewMatrix = []
	NRows = len(NewTwisted[1])
	Count = 0
	for i in range(NRows):
		List = [Line[Count] for Line in NewTwisted]
		Count += 1
		NewMatrix.append(List)  		# return rows and columns (untwist)
	for Line in NewMatrix:
		OutLOS.append('\t'.join(Line))		#return to tab delimited matrix
	#print OutLOS
	
	OutFileName = '0101'+File
	OutFile = open(OutFileName, 'wb')
	CountLine = 0
	for List in LOL:
		if CountLine < Row:
			Line = '\t'.join(List)
		else:
			ItemCount = 0
			for Item in List:
				if ItemCount == 0 and Col > 0:
					Line = Item
					
				else:
					if ItemCount < Col:
						Line += '\t'+Item
					elif ItemCount == (Col + 1):
						Line += '\t'+OutLOS[CountLine-Row]
				ItemCount += 1
		CountLine+= 1
		OutFile.write(Line + '\n')
	
	OutFile.close()
					
		
	
	
	
	
	
	
	
