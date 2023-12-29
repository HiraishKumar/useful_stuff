
test=[2,5,9,3,1,12,6,8,7]

def span(rates:list[int])-> list:
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

print(span(test))    