string=input().strip()
substring=input().strip()

sub=[]
for i in range (len(substring)):
    sub.append(substring[i])

lst1=[]
for j in range (len(string)-len(substring)+1):  
    lst2=[]
    for k in range(len(substring)):
        lst2.append(string[j+k])
    lst1.append(lst2)
    
print(lst1.count(sub))
print(lst1)
print(sub)
        
        
        
        
        
# lst=[]
# for i in range(5):
#     lst2=[]
#     for i in range (5):
#         lst2.append(i)
#     lst.append(lst2)
# print(lst)

    
    
    
    
    

