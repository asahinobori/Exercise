#-*- coding: utf-8 -*-
#!/usr/bin/python

#
# BingWallpaperGet_xml.py
# brief     Get Bing Wallpaper (today to 8 day before)
# author    Yousein Chan
# version   1.0
# date      16Jan16
#
# history   1.0, 16Jan16, Yousein Chan, Create the file.
#

import os
import sys
import urllib
import xml.etree.ElementTree as ET

import win32gui, win32con, win32api

class BingWallpaper(object):
    # Link below will GET BingWallpaper info data (xml)
    # "&n=num" in the end define the total num wallpaper info that will return
    URL_FETCH_BING_IMG = "https://cn.bing.com/HPImageArchive.aspx?format=xml&idx=0&n=8"
    LOCAL_STORE_FILE = "./wallpaper.jpg"

    def __init__(self, args):
        if(len(args) == 0):
            self._n = 0
        else:
            i = int(args[0])
            if(i < 0):
                self._n = 0
            elif(i > 7):
                self._n = 7
            else:
                self._n = i


    def parseImageURL(self, xml):
        root = ET.fromstring(xml)
        i = 0
        for el in root.findall("./image/url"):
            if(i == self._n):
                return el.text
            i += 1
        return ""

    def fetchXML(self):
        return urllib.urlopen(BingWallpaper.URL_FETCH_BING_IMG).read()

    def downloadImage(self, url):
        urllib.urlretrieve(url, BingWallpaper.LOCAL_STORE_FILE)

    def setWallpaper(self):
        # k = win32api.RegOpenKeyEx(win32con.HKEY_CURRENT_USER, "Control Panel\\Desktop", 0, win32con.KEY_SET_VALUE)
        # win32api.RegSetValueEx(k, "WallpaperStyle", 0, win32con.REG_SZ, "10")
        # win32api.RegSetValueEx(k, "TileWallpaper", 0, win32con.REG_SZ, "0")
        path = os.getcwd()
        win32gui.SystemParametersInfo(win32con.SPI_SETDESKWALLPAPER, path+"\\wallpaper.jpg", 1+2)

    def run(self):
        xml = self.fetchXML();
        url = self.parseImageURL(xml)
        self.downloadImage("https://cn.bing.com/" + url)

# Bing Wallpaper Auto Change Tool start here
if __name__ == '__main__':
    backupname=len(os.listdir("./"))-1
    if os.path.exists("wallpaper.jpg"):
        os.rename("wallpaper.jpg", str(backupname)+".jpg")
    bingWallpaper = BingWallpaper(sys.argv[1:])
    bingWallpaper.run()
    bingWallpaper.setWallpaper()

# TileWallpaper
# 0: The wallpaper picture should not be tiled
# 1: The wallpaper picture should be tiled

# WallpaperStyle
# 0:  The image is centered if TileWallpaper=0 or tiled if TileWallpaper=1
# 2:  The image is stretched to fill the screen
# 6:  The image is resized to fit the screen while maintaining the aspect
#    ratio. (Windows 7 and later)
# 10: The image is resized and cropped to fill the screen while maintaining
#    the aspect ratio. (Windows 7 and later)
