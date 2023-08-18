test=[2,5,9,3,1,12,6,8,7]

def StockSpan(test:list[int])-> dict:
    stack=[]
    Stock_span={}
    
    for num,i in enumerate(test,1):
        if len(stack)==0 or i > stack[-1] :            
            stack.append((num,i))
        else:
            while len(stack)!=0 and stack[-1] <= i :
                Stock_span[i] = num 


print(StockSpan(test))       