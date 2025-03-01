# COLLECTIONS 
#     namedtuple()
#     deque
#     ChainMap
#     Counter

#CHAINMAP                       # it makes combining, easier and faster access to dicts which are updateable

from collections import ChainMap
a={1:'hello',2:'hola',3:'namaste'}
b={'a':'oi','b':'aree','c':'yaar'}
d=ChainMap(a,b)
# >>> d is ChainMap({1: 'hello', 2: 'hola', 3: 'namaste'}, {'a': 'oi', 'b': 'aree', 'c': 'yaar'})

e=d.new_child()
f=ChainMap({},*d.maps)               # e and f are equivalent 
# print(e)                        # as no arguments are passed in new_child, it adds a empty dict at the front
# print(f)                        # if the maps wasnt used we would get only the keys 
                                #>>>ChainMap({}, 'a', 'b', 'c', 1, 2, 3)
                                # if the * wasnt used we would get a list housing the 2 dicts                                   
                                #>>>ChainMap({}, [{1: 'hello', 2: 'hola', 3: 'namaste'}, {'a': 'oi', 'b': 'aree', 'c': 'yaar'}]) 

# c = ChainMap()        # Create root context
# d = c.new_child()     # Create nested child context
# e = c.new_child()     # Child of c, independent from d
# e.maps[0]             # Current context dictionary -- like Python's locals()
# e.maps[-1]            # Root context -- like Python's globals()
# e.parents             # Enclosing context chain -- like Python's nonlocals

# d['x'] = 1            # Set value in current context
# d['x']                # Get first key in the chain of contexts
# del d['x']            # Delete from current context
# list(d)               # All nested keys
# 'k' in d              # Check all nested values
# len(d)                # Number of nested values
# d.items()             # All nested items
# dict(d)               # Flatten into a regular dictionary

#to get a specific value in a maping d.maps[index][key]

#COUNTER

from collections import Counter
c=Counter('HELLO')
# print(c)                #>>>Counter({'L': 2, 'H': 1, 'E': 1, 'O': 1})
# print(list(c))          #>>>['H', 'E', 'L', 'O']
# print(dict(c))          #>>>{'H': 1, 'E': 1, 'L': 2, 'O': 1}
# print(c['L'])           #>>>2

#           .elements gives a an chain object which can be converted to a list or be sorted         
#print(list(c.elements()))#>>>['H', 'E', 'L', 'L', 'O']

#           .most_common([n]) gives the most commomn n elements
#print(c.most_common(2))  #>>>[('L', 2), ('H', 1)]  or (if written as dict) >>>{'L': 2, 'H': 1}

#           .update(iter) updates the couter with any iterabel (list, tuppel, set, string, dict )
# print(dict(c))           #>>>{'H': 1, 'E': 1, 'L': 2, 'O': 1}
# c.update('abcde')
# print(dict(c))           #>>>{'H': 1, 'E': 1, 'L': 2, 'O': 1, 'a': 1, 'b': 1, 'c': 1, 'd': 1, 'e': 1}

#DEQUE



# from collections import deque
# d = deque('ghi')                 # make a new deque with three items
# for elem in d:                   # iterate over the deque's elements
#     print(elem.upper())
# G
# H
# I

# d.append('j')                    # add a new entry to the right side
# d.appendleft('f')                # add a new entry to the left side
# d                                # show the representation of the deque
# deque(['f', 'g', 'h', 'i', 'j'])

# d.pop()                          # return and remove the rightmost item
# 'j'
# d.popleft()                      # return and remove the leftmost item
# 'f'
# list(d)                          # list the contents of the deque
# ['g', 'h', 'i']
# d[0]                             # peek at leftmost item
# 'g'
# d[-1]                            # peek at rightmost item
# 'i'

# list(reversed(d))                # list the contents of a deque in reverse
# ['i', 'h', 'g']
# 'h' in d                         # search the deque
# True
# d.extend('jkl')                  # add multiple elements at once
# d
# deque(['g', 'h', 'i', 'j', 'k', 'l'])
# d.rotate(1)                      # right rotation
# d
# deque(['l', 'g', 'h', 'i', 'j', 'k'])
# d.rotate(-1)                     # left rotation
# d
# deque(['g', 'h', 'i', 'j', 'k', 'l'])

# deque(reversed(d))               # make a new deque in reverse order
# deque(['l', 'k', 'j', 'i', 'h', 'g'])
# d.clear()                        # empty the deque
# d.pop()                          # cannot pop from an empty deque
# Traceback (most recent call last):
#     File "<pyshell#6>", line 1, in -toplevel-
#         d.pop()
# IndexError: pop from an empty deque

# d.extendleft('abc')              # extendleft() reverses the input order
# d
# deque(['c', 'b', 'a'])

#NAMED TUPLE 

from collections import namedtuple
# Basic example
# Point = namedtuple('Point', ['x', 'y'])
# p = Point(11, y=22)     # instantiate with positional or keyword arguments
# p[0] + p[1]             # indexable like the plain tuple (11, 22)
# 33
# x, y = p                # unpack like a regular tuple
# x, y
# (11, 22)
# p.x + p.y               # fields also accessible by name
# 33
# p                       # readable __repr__ with a name=value style
# Point(x=11, y=22)

#           _make(iter) assigns values of an iterabel to the elements of a tupple which act as keys 
# t = [11, 22]
# Point._make(t)
# Point(x=11, y=22)

#           _asdict() Return a new dict which maps field names to their corresponding values:
# p = Point(x=11, y=22)
# p._asdict()
# {'x': 11, 'y': 22}

#           _replace(**kwargs) takes in a keyword argument as you have to specify, value of which you want changed
#           _fields() tupple of strings listing the feild names
# Declaring namedtuple()
# Student = collections.namedtuple('Student', ['name', 'age', 'DOB'])
 
# # Adding values
# S = Student('Nandini', '19', '2541997')
 
# # using _fields to display all the keynames of namedtuple()
# print("All the fields of students are : ")
# print(S._fields)
 
# # ._replace returns a new namedtuple, it does not modify the original
# print("returns a new namedtuple : ")
# print(S._replace(name='Manjeet'))
# # original namedtuple
# print(S)
 
# # Student.__new__ returns a new instance of Student(name,age,DOB)
# print(Student.__new__(Student,'Himesh','19','26082003'))
 
# H=Student('Himesh','19','26082003')
# # .__getnewargs__ returns the named tuple as a plain tuple
# print(H.__getnewargs__())
 
# # This code was improved by Himesh Singh Chauha

# >>>All the fields of students are : 
# ('name', 'age', 'DOB')
# returns a new namedtuple : 
# Student(name='Manjeet', age='19', DOB='2541997')
# Student(name='Nandini', age='19', DOB='2541997')
# Student(name='Himesh', age='19', DOB='26082003')
# ('Himesh', '19', '26082003')
