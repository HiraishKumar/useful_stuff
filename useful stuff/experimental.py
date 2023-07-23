# k,m=(input().split())
# lst=[]
# for i in range(int(k)):
#     a=input().split()
#     tst=[]
#     for j in range(int(a[0])):
#         tst.append(int(a[j+1]))
#     print(tst)    
#     lst.append(max(tst))
# print(lst)
    
# sum=0
# for i in lst:
#     sum += i**2
# print(sum%int(m))
# from itertools import product as pr
# a=input().split()
# k=int(a[0])
# m=int(a[1])

# N=[]
# for i in range (k):
#     lst=input().split()
#     lst=[int(n) for n in lst]
#     lst=lst[1:]
#     N.append(lst)
# print(N)
    
# product=list(pr(*N))
# # print(pro)
# # print(len(pro))
# fin=0
# for item in product:
#     sum=0
#     for num in item: 
#         sum+= num**2
#     mod = sum % k
# if mod<fin:
#     mod = fin        
# print(fin)




import itertools as it

# Generate all combinations of numbers in the range 10 taken 3 at a time
print(*list(it.combinations(range(5), 3)))

