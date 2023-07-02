# INFINITE COUNTERS
#     1.COUNT 
#     2.REPEAT 
#     3.CYCLE 
# TERMINATING COUNTERS
#     1.ACCUMULATE 
#     2.CHAIN 
#     3.CHAIN(from_iterable())     
#     4.COMPRESS
# COMBINATRONIC ITERATORS
#     1.PRODUCT 
#     2.PERMUTATIONS 
#     3.COMBINATIONS 
    



#infinte counters 
#1.COUNT                                {counting creates a count object which has to be iterated over}

from itertools import count
def counter(start,step,max_count):
    for i in count(start,step):
        if i < max_count+1:               #had to add this limiter cause this is a infinte iterator 
            print(i)
        else:
            break   
counter(0,1,3)
# >>>0 
# 1
# 2
# 3

#print(list(count(1,1))) {This dosent work because, the 'object' can be iterated infinitely, and, list doesnt know when to stop.}

#2.REPEAT                               {repeating creates a repeat object which has to be iterated over}

from itertools import repeat
def repeater(element,max_repeat):        # if the max repeat is not given, then, the 'object' can be iterated upon infinitly 
    for j in repeat(element,max_repeat):
        print(j)
repeater('hello',3)
# >>> hello 
# hello 
# hello

#3. CYCLE                                {cycle creates a cylcle object which has to be iterated over}

from itertools import cycle
def cyclcler(element,max_cycle):
    x=0
    for k in cycle(element):
        if x<max_cycle:                  #had to add this limiter cause this is a infinte iterator 
            print(k)
            x+=1
        else:
            break    
cyclcler('hello',5)       
# >>>h 
# e 
# l 
# l       
# o
            
#terminatining counters

#1.ACCMULATOR                            {its poupose it to add all the elements(integer) of lsit}

from itertools import accumulate
def accumulater(elements):
    sum = accumulate(elements)           
    print(list(sum))                     #we are printing the accumulate object as a list to see how it works 
accumulater([1,2,3,4,5,6,7,8,9,10,])#'hello']) # had it contained that string we would have gotten TypeError: unsupported operand type(s) for +: 'int' and 'str'  
# >>>[1, 3, 6, 10, 15, 21, 28, 36, 45, 55]   

#2.CHAIN                                {}

from itertools import chain
def chainer(element1,element2):
    chained=chain(element1,element2)
    print(list(chained))                  #we turn it to a list to so we can see it and not just get a object location
chainer('ABC','DEF')                      #this only works on strings 
# >>>['A', 'B', 'C', 'D', 'E', 'F']

#3.CHAIN(from_iterable)

def chainer_it(iterable):
    chained=chain.from_iterable(iterable)
    print(list(chained))                   #this works with everything
chainer_it([[1,2,3],['a','b','c'],[True,False,False]]) 
# >>>[1, 2, 3, 'a', 'b', 'c', True, False,False]

#4.COMPRESS

from itertools import compress
def compresser(data,selector):              #{it job is choose which elements of the first list to keep based on Boolean data of the second list}
    compressed=compress(data,selector)      #{Date can be any Data Type, Selector HAS to be Boolean}
    print(list(compressed))
compresser([[1,2,3],['a','b','c'],[True,False,True]],[True,False,True])    
# >>>[[1, 2, 3], [True, False, True]] 

#combinatronic iterators     

#1.PRODUCT
            
from itertools import product                #{it produces a cartesian product of the 2 lists} 
def producter(iterable1,iterable2):
    result=product(iterable1,iterable2)
    print(list(result))
producter([1,2,3],['a','b','c'])  
# >>>[(1, 'a'), (1, 'b'), (1, 'c'), (2, 'a'), (2, 'b'), (2, 'c'), (3, 'a'), (3, 'b'), (3, 'c')]  
    
#2.PERMUTATIONS

from itertools import permutations         
def permutater(iterable, size):              #{iterable has to be a string or a list(iterable), and, size a integer}
    result= permutations(iterable,size) 
    print(list(result))
permutater('ABCD',2)                        
# >>>[('A', 'B'), ('A', 'C'), ('A', 'D'), ('B', 'A'), ('B', 'C'), ('B', 'D'), ('C', 'A'), ('C', 'B'), ('C', 'D'), ('D', 'A'), ('D', 'B'), ('D', 'C')]

#3.COMBINATIONS

from itertools import combinations
def combinater(iterable,size):              #{iterable has to be a string or a list(iterable), and, size a integer}
    result=combinations(iterable,size)
    print(list(result))
combinater('ABCD',2)
# >>>[('A', 'B'), ('A', 'C'), ('A', 'D'), ('B', 'C'), ('B', 'D'), ('C', 'D')]
