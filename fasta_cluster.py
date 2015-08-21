#!/usr/bin/env python

Usage="""
Usage:				fasta_cluster.py		J.Gerlach 01/04/14
	This program takes a mixed list of sequences, and saves them to separate fasta
	files based on the contig number.
 		input:	 fasta_cluster.py sequence.fasta		"""

import sys
import os
import re

# Expects a file name as the argument
if len(sys.argv) < 2:
	print Usage
	
else:
	for i in range(100001):
		exp="contig_"+str(i)+'_'
		FileName = 'Ayous_' + exp + '.fasta' 	#create a file for each contig
		WriteFile = open(FileName, 'wb') 		# open the file for writing
		linenumber = 0
		print exp
		InfileName= sys.argv[1]
		Infile = open(InfileName,'r')
		for line in Infile:
			if linenumber==0:
				if line[0]=='>': 					#if its a seq name			
					if re.search(exp, line):		#for the contig no. 'i'
						WriteFile.write(str(line)) 	#write name in file
						linenumber = 1				# change counter
						print line
			elif linenumber == 1:
				linenumber = 0					#reset counter
				WriteFile.write(str(line)) 		#write seq in file after name
				print line
				
		WriteFile.close()				
		if os.stat(FileName).st_size==0:		#delete new file if it is empty
			os.remove(FileName)
			
Infile.close()



