from tkinter import *
import pygame


root=Tk()
root.geometry("400x500")
root.title('yellow')

pygame.mixer.init()
def play():
    pygame.mixer.music.load(r"D:\253.mp3")
    pygame.mixer.music.play(loop=0)
#width,height
# root.minsize(192,108)
# root.maxsize(720,680)

photo=PhotoImage(file=r"C:\Users\HERAISH\Desktop\pictures\wxv8yfaw79ya1.png" )
label=Label(root,image=photo, bg = "#F5A9B8", width="400",height="500")
command=play


label.pack()
root.mainloop()
