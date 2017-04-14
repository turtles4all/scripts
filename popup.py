from tkinter import *
import tkinter.messagebox

root = Tk()  # creates root frame, only needed once
root.wm_withdraw()  # hides the root frame from view


def doStuff():
    print("Doing Stuff")

answer = tkinter.messagebox.askquestion('Download File', 'Do you want to download the file?')
if answer == 'yes':
    doStuff()  # if user presses Yes, call function doStuff