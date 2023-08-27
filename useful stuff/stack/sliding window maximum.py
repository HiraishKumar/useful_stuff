test=[1,2,3,4,5,6,7,8,9]
window=4

def SlidingWindowMax(nums:list[int],k:int)->list[int]:
    stack=nums[0:k-1]
    results=[max(stack)]
    for i in range(k,len(stack)):
        
    
