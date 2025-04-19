#!/bin/bash

python3 - <<EOF
from tkinter import *
import webbrowser as web
import os
import subprocess

root = Tk()
root.geometry('700x600')
root.configure(bg='#f5f5f5')
root.title("HDFS GUI Tool")

# Title
mylabel = Label(root, bg='#ffcc00', text="Welcome To Linux GUI", font='Helvetica 40 bold')
mylabel.pack(pady=10, fill=X)

# Input Fields
frame_inputs = Frame(root, bg='#f5f5f5')
frame_inputs.pack(pady=30)

Label(frame_inputs, text="Enter path in HDFS:", fg='black', bg='#f5f5f5', font="Arial 30").grid(row=0, column=0, sticky=W, padx=5, pady=5)
inputlink = Entry(frame_inputs, width=40)
inputlink.grid(row=0, column=1, padx=10, pady=10,ipady=5)

Label(frame_inputs, text="Enter File Name:", fg='black', bg='#f5f5f5', font="Arial 30").grid(row=1, column=0, sticky=W, padx=5, pady=5)
inputfile = Entry(frame_inputs, width=40)
inputfile.grid(row=1, column=1, padx=10, pady=10,ipady=5)

# Button Frame
frame_buttons = Frame(root, bg='#f5f5f5')
frame_buttons.pack(pady=20)

btn_style = {'bg': '#ffcc00', 'fg': 'black', 'font': 'Helvetica 14 bold', 'padx': 10, 'pady': 5}

Button(frame_buttons, text='LS', command=lambda: os.system("hdfs dfs -ls"), **btn_style).grid(row=0, column=0, padx=10, pady=10)
Button(frame_buttons, text='PWD', command=lambda: os.system("pwd"), **btn_style).grid(row=0, column=1, padx=10, pady=10)
Button(frame_buttons, text='Open Web', command=lambda: web.open(inputlink.get()), **btn_style).grid(row=0, column=2, padx=10, pady=10)

Button(frame_buttons, text='Create Dir', command=lambda: make_dir(), **btn_style).grid(row=1, column=0, padx=10, pady=10)
Button(frame_buttons, text='Create File', command=lambda: make_file(), **btn_style).grid(row=1, column=1, padx=10, pady=10)
Button(frame_buttons, text='Upload', command=lambda: put_file(), **btn_style).grid(row=1, column=2, padx=10, pady=10)
Button(frame_buttons, text='Download', command=lambda: get_file(), **btn_style).grid(row=1, column=3, padx=10, pady=10)
Button(frame_buttons, text='Copy', command=lambda: copy_file(), **btn_style).grid(row=2, column=0, padx=10, pady=10)
Button(frame_buttons, text='Moved', command=lambda: move_file(), **btn_style).grid(row=2, column=1, padx=10, pady=10)


# Functions
def make_dir():
    link = inputlink.get().strip()
    if not link:
        print("Please enter a directory path.")
        return
    exists = subprocess.call(f"hdfs dfs -test -d {link}", shell=True)
    if exists == 0:
        print("The directory already exists")
    else:
        os.system(f"hdfs dfs -mkdir {link}")
        print("The directory was successfully created")

def make_file():
    link = inputlink.get().strip()
    file_name = inputfile.get().strip()
    if not link or not file_name:
        print("Please enter a directory or file name.")
        return
    full_path = f"{link}/{file_name}"
    folder_exists = subprocess.call(f"hdfs dfs -test -d {link}", shell=True)
    file_exists = subprocess.call(f"hdfs dfs -test -e {full_path}", shell=True)
    if folder_exists == 0:
        if file_exists == 0:
            print("The file already exists")
        else:
            os.system(f"hdfs dfs -touchz {full_path}")
            print("The file was created")
    else:
        print("The folder does not exist")

def put_file():
    local = inputfile.get().strip()
    hdfs = inputlink.get().strip()
    if not local or not hdfs:
        print("Enter Local File Name and HDFS path")
        return
    command = f"hdfs dfs -put {local} {hdfs}"
    result = os.system(command)
    if result == 0:
        print("File uploaded successfully")
    else:
        print("File upload failed")

def get_file():
    local = inputfile.get().strip()
    hdfs = inputlink.get().strip()
    if not local or not hdfs:
        print("Enter Local File Name and HDFS path")
        return
    command = f"hdfs dfs -get {hdfs} {local}"
    result = os.system(command)
    if result == 0:
        print("File downloaded successfully")
    else:
        print("File download failed")

def copy_file():
    local = inputfile.get().strip()
    hdfs = inputlink.get().strip()
    if not local or not hdfs:
        print("Enter Local File Name and HDFS path")
        return
    command = f"hdfs dfs -cp {hdfs} {local}"
    result = os.system(command)
    if result == 0:
        print("Copy File successfully")
    else:
        print(" Copy failed")

def move_file():
    local = inputfile.get().strip()
    hdfs = inputlink.get().strip()
    if not local or not hdfs:
        print("Enter Local File Name and HDFS path")
        return
    command = f"hdfs dfs -mv {hdfs} {local}"
    result = os.system(command)
    if result == 0:
        print("Moved File successfully")
    else:
        print(" Moved failed")

root.mainloop()
EOF

