
from tkinter import *
from PIL import Image, ImageTk

root=Tk()
root.geometry("1280x720")
root.title('GUI1')
#width,height 
# root.minsize(192,108)
# root.maxsize(720,680)
photo2=Image.open(r"C:\Users\HERAISH\Desktop\pictures\wxv8yfaw79ya1.png")
resized_image=photo2.resize((720,240),Image.ANTIALIAS)
converted_image=ImageTk.PhotoImage(resized_image)

photo=PhotoImage(file=r"C:\Users\HERAISH\Desktop\pictures\wxv8yfaw79ya1.png" )
label=Label(root,image=converted_image, fg= "#FF0000" ,bg = "#BB0000", width="1920",height="1080")
label.pack()
root.mainloop()
