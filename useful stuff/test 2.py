from tkinter import *

root = Tk()

name = StringVar()
check_box_list = []
ent=Entry(root,textvariable=name).pack()

def clear():
    for i in check_box_list:
        i.pack_forget()    # forget checkbutton
        # i.destroy()        # use destroy if you dont need those checkbuttons in future

def generate():
    k=name.get()
    c=Checkbutton(root,text=k)
    c.pack()
    check_box_list.append(c)  # add checkbutton

btn1=Button(root,text="Submit",command=generate)
btn1.pack()

btn2=Button(root,text="Clear",command=clear)
btn2.pack()

mainloop()