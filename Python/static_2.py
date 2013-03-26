#!/usr/bin/python
#Filename: static_2.py

import os, sys

def listdir(dire,myfile):
    myfile.write(dire + '*' + '\n')
    filelist = os.listdir(dire)
    for line in filelist:
        filepath = os.path.join(dire, line)
        if os.path.isdir(filepath):
            listdir(filepath + '/', myfile)
        elif os.path:
            myfile.write('-' * len(dire) + line + '\n')
    
dire = raw_input('please input the path:')
myfile = open('list.txt', 'w')
listdir(dire, myfile)
myfile.close()
