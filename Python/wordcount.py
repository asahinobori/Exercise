#!/usr/bin/python 
#Filename: wordcount.py
#Count lines,sentences,and words of a text file

#set all the conters to zero

import sys

lines, blanklines, sentences, words = 0, 0, 0, 0

print "-" *50

try:
    #use a text file you have
    filename = raw_input("Input filename:")
    textf = file(filename)
except IOError:
    print "Cannot open file %s for reading" %filename
    sys.exit()

#read one line at a time
for line in textf:
    print line, #test
    lines += 1

    if line.startswith('\n'):
        blanklines += 1
    else:
        #assume that each sentence ends with . or ! or ?
        #so simply count these characters
        sentences += line.count('.') + line.count('!') + line.count('?')

        #create a list of words
        #use None to split at any whitespace regardless of length
        #so for instance double space counts as one space
        tempwords = line.split(None)
        print tempwords #test

        #word total count
        words += len(tempwords)

textf.close()

print '-' * 50
print "Lines        :", lines
print "Blank lines  :", blanklines
print "Sentences    :", sentences
print "Words        :", words
