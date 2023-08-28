test=[1,3,-1,-3,5,3,6,7]
window=3

def SlidingWindowMax(nums:list[int],k:int)->list[int]:
    stack=nums[:k-1]
    results=[]
    for i in nums[k-1:]:
        if len(stack)==k:
            stack=stack[1:]
        while stack and stack[-1] < i:
            stack.pop()
        stack.append(i)
        results.append(max(stack))
        
    return results

    
print(SlidingWindowMax(test,window))

   
        
    
