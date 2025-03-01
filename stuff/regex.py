'''Regular expresiions helps us find regular patters of 
 charecters that find a string or a set of string '''
from re import *
n = int(input())
for i in range(0,n):  
    try:
        _input = input()
        a = (compile(_input))
        print(bool(a))
    except error:
        print('False')