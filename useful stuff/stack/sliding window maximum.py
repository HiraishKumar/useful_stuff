test=[1,3,-1,-3,5,3,6,7]
window=3

def maxSlidingWindow(nums: list[int], k: int) -> list[int]:
    if k==1:
        return nums
    elif len(nums) == 1 or len(nums)==2:
        return [max(nums)]
    else:
        otv=[]
        b=max(nums[0:k])
        otv.append(b)
        for z in range(1,len(nums)-k+1):
            if nums[z-1]==b:
                if (nums[z]==b-1 or nums[z]==b) and nums[z+k-1]<nums[z]:
                    b=nums[z]
                    otv.append(b)
                    continue
                b=max(nums[z:z+k])
                otv.append(b) 
            elif nums[z+k-1]>b:
                b=nums[z+k-1]
                otv.append(b)
            else:
                otv.append(b)
        return otv
print(maxSlidingWindow(test,window))

   
        
    
