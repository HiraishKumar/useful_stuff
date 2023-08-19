
def span(rates:list[int])-> list:
    
    # stockspan = [1]
    # stack = [0]

    # for i in range(1, len(rates)):
    #     while len(stack)!=0 and rates[i] > rates[stack[-1]] :
    #         stack.pop()

    #     if len(stack) > 0:
    #         stockspan.append(i - stack[-1])
    #     else:
    #         stockspan.append(i + 1) 

    #     stack.append(i)
    
    # return stockspan
    stock_span=[1]
    stack=[0]
    for index in range(1,len(rates)):
        while len(stack) != 0 and rates[index] > rates[stack[-1]]:
            stack.pop()
            
        if len(stack) != 0:
            stock_span.append(index-stack[-1])
        else:
            stock_span.append(index+1)
        
        stack.append(index)    
    return stock_span
test=[2,5,9,3,1,12,6,8,7]
    

print(span(test))    