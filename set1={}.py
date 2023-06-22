class vector(object):
    def __init__(self,x,y):
        self.x=x
        self.y=y
    def __add__(self,v):
        return('(',(self.x+v.x),',',(self.y+v.y),')')
    def __mul__(self,v):
        return('(',(self.x*v.x),',',(self.y*v.y),')')
    def __sub__(self,v):
        return('(',(self.x-v.x),',',(self.y-v.y),')')
e1=vector(5,7)
e2=vector(8,9)
print(type(e1))
print(e1+e2)
print(e1-e2)
print(e1*e2)