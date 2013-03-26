#!/usr/bin/python
#Filename: addressBook.py

import os
import cPickle
class Person:
    def __init__(self, name, email = "", mobile = "", teleNumber = ""):
        self.name = name
        self.email = email
        self.mobile = mobile
        self.teleNumber = teleNumber
addressPath = 'addressBook.data'
addressBook = {}
if os.path.exists(addressPath):
    addressFile = file(addressPath)
    addressBook = cPickle.load(addressFile)
isQuit = False
print '''\
Input a command.
'A' or 'a' Add a person
'D' or 'd' Delete a person
'F' or 'f' Find a person
'M' or 'm' Modify a person
'L' or 'l' List a person's detail
'Q' or 'q' Quit
'''
while not isQuit:
    command = raw_input('\nInput a command:')
    if (command == 'A' or command == 'a'):
        print 'Input Person information: name email mobile teleNumber'
        info = raw_input('Person Info:')
        info = info.split(' ')
        person = Person(info[0], info[1], info[2], info[3])
        if not addressBook.has_key(person.name):
            addressBook[person.name] = person
            print 'Success'
        else:
            print 'In AddressBook,there is a same name with', person.name, '.'
    elif (command == 'D' or command == 'd'):
        print "Input the person's name"
        name = raw_input('Name:')
        if addressBook.has_key(name):
            del addressBook[name]
            print 'Success'
        else:
            print 'No person is called', name
    elif (command == 'F' or command == 'f'):
        print 'Input the name of the person which you want to find'
        name = raw_input('Name:')
        if not addressBook.has_key(name):
            print 'No person is called', name
        else:
            print 'Email:', addressBook[name].email
            print 'Mobile:', addressBook[name].mobile
            print 'teleNumber:', addressBook[name].teleNumber
    elif (command == 'M' or command ==  'm'):
        print "Input the person's Name"
        name = raw_input('Name:')
        if addressBook.has_key(name):
            if raw_input('Modify email? y/n\n') == 'y':
                addressBook[name].email = raw_input('Input Email:')
            if raw_input('Modify mobile? y/n\n') == 'y':
                addressBook[name].mobile = raw_input('Input Mobile:')
            if raw_input('Modify teleNumber? y/n\n') == 'y':
                addressBook[name].teleNumber = raw_input('Input teleNumber:')
            print 'Success'
        else:
            print 'No person is called', name
    elif (command == 'Q' or command == 'q'):
        print 'The program is exit'
        isQuit = True
    elif (command == 'L' or command == 'l'):
        print '****************************'
        for name,detail in addressBook.items():
            print 'Name:', detail.name
            print 'Email:', detail.email
            print 'Mobile:', detail.mobile
            print 'TeleNumber:', detail.teleNumber
            print 
        print '****************************'
    else:
        print command, 'is not a command'
#Write to the file
try:
    addressFile = file(addressPath, 'w')
    cPickle.dump(addressBook, addressFile)
finally:
    addressFile.close()
