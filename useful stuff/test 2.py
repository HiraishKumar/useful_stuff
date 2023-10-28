dic={'A':4,'B':3,'C':2,'D':1}
k=2

print((sorted(dic.keys(),key= lambda x:dic[x]))[0:k])