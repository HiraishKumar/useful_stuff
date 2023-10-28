nums = [100,4,200,1,3,2]

def longestConsecutive(nums: list[int]) -> int:
    lst=sorted(set(nums))
    left,right=0,0
    longest=0
    for i in range(1,len(lst)):
        if lst[i-1]+1==lst[i]:
            right=i
        else:
            longest=max(longest,(right-left+1))
            left=i
    return max(longest,(right-left+1))


print(longestConsecutive(nums))