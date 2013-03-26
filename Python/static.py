#!/usr/bin/python.py
#Filename: static.py

import os

def walk_dir(dire, fileinfo, topdown = True):
    for root, dirs, files in os.walk(dire,topdown):
        for name in files:
            print(os.path.join(name))
            fileinfo.write(os.path.join(root, name) + '\n')
        for name in dirs:
            print(os.path.join(name))
            fileinfo.write(' ' + os.path.join(root, name) + '\n')
dire = raw_input("please input the path:")
fileinfo = open("static.txt", "w")
walk_dir(dire, fileinfo)
