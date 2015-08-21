#!/usr/bin/env python

Usage="""
Usage:				twocols.py		J.Gerlach 05/04/14
	
 		input:	 twocols.py sequence.txt		"""

import sys
import os
import re

# Expects a file name as the argument
if len(sys.argv) < 2:
	print Usage
	
else:
	InfileName= sys.argv[1]
	
	FileName = InfileName + '_2.txt' 	
	WriteFile = open(FileName, 'wb') 		# open the file for writing
	linenumber = 0
	Infile = open(InfileName,'r')
	for line in Infile:
		if linenumber>2:
			linelist = line.split()
			newlist = []
			newlist[0:2] = linelist[0:2]
			for item in linelist[2:]:
#				print item
#				print type(item)
				if item == "9":
					newlist.append("9\t9")
				elif item == "0":
					newlist.append("0\t0")
				elif item == "1":
					newlist.append("0\t1")
				elif item == "2":
					newlist.append("1\t1")
			newline = "\t".join(newlist)	
#			print linelist	
			WriteFile.write(newline + "\n") 	
			linenumber += 1				# change counter
#					print line
		else:
			linenumber += 1					
			WriteFile.write(str(line)) 		#write seq in file after name
#			print line
			
	WriteFile.close()				

		
Infile.close()



