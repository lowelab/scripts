#!/usr/bin/env python

import sys
"""
x = 1
print x

x = x + 1
print x

x = 0

for number in range(10):
	x = x + number
	print x

print x

"""



seq = "agccgaattagctc"
seq = raw_input("Sequence: ")			#user can input a sequence
seq = seq.lower()						#put in lower case

for base in set(seq):
	if base not in ('a','c','t','g'):			#check the characters in the
		print "invalid input: not 'agct'"		#sequence are nucleotides
		sys.exit()							#end program (need to import sys)
		

reverse_complement = ""				#create an empty string

for base in seq[::-1]:				#reverse sequence
	if base == "a":					#assign value of paired nucleotide
		rc = "t"
	elif base == "t":
		rc = "a"
	elif base == "g":
		rc = "c"
	elif base == "c":
		rc = "g"
#	print base + " - " + rc
	reverse_complement = reverse_complement + rc
print reverse_complement