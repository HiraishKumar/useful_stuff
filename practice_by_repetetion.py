nums = [-1,1,0,-3,3]

def productExceptSelf(nums: list[int]) -> list[int]:
    lst=[]
    prod=1
    for i in nums:
        if i!=0:
            prod=prod*i 
    if nums.count(0)==1:
        return [0 if num!=0 else prod for num in nums ]
    if nums.count(0)>1:
        return [0 for i in nums]    
    return [prod//num for num in nums]

print(productExceptSelf(nums))