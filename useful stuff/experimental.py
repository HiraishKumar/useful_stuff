import tkinter as tkin
from PIL import ImageTk,Image
import random
import os.path

root = tkin.Tk()
root.title("killy's 2D Chess")
root.geometry("1300x1000")

header = tkin.Label(root,text="2D Chess",)
header.config(font=("courier",20))
header.grid(column=0,row=3)

def labelTop():
        #putting letter labels at top of board
        topLabels = ["A","B","C","D","E","F","G","H"]
        count=1
        for letter in topLabels:
                letter = tkin.Label(root,text=letter)
                letter.grid(column=count,row=0,sticky="S")
                count+=1


root.mainloop()
