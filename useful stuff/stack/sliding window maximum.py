ascending=[1,2,3,4,5,6,7,8,9]
# dscending=[4,3,2,1]
window=3

def maxSlidingWindow(nums: list[int], k: int) -> list[int]:
    index_of_next_greater_in_range=0
    max_index=0
    result=[]
    for i in range(len(nums)-k+1):
        index_of_next_greater_in_range=i
        test=i
        while index_of_next_greater_in_range < len(nums):
            if nums[i+1] > nums[i]:
                index_of_next_greater_in_range=i+1
                break
            else:
                index_of_next_greater_in_range+=1
        if index_of_next_greater_in_range < i+k-1:
            max_index=index_of_next_greater_in_range
        elif index_of_next_greater_in_range >= i+k-1:
            max_index=i
        result.append(nums[max_index])           
    return result    
        

print(maxSlidingWindow(ascending,window))

   
        
    
