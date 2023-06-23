from tkinter import *
import pygame
root=Tk()
root.geometry=("500,500")


def fun1():
    image3 = PhotoImage(file="D:\-41601334000juyqtkjgzt.png")
    img_label = Label(root, image = image3)
    img_label.image = image3
    img_label.pack()
    
    pygame.init()
    pygame.mixer.music.load(r"d:\253.mp3")
    pygame.mixer.music.play(loops=0)
    
   
    
button=Button(root,text="Are You Sure", font=("Times New Roman",32),command=fun1)
button.pack()
root.mainloop()

    
    
