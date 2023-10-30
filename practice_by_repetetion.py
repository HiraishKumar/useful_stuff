height = [4,2,0,3,2,5]

def trap(height: list[int]) -> int:
    max_index=height.index(max(height))
    water=0
    l1,l2=0,0
    r1,r2=len(height)-1,len(height)-1
    while l2 < max_index:
        if height[l2+1] < height[l1]:
            l2+=1
        else:
            l2+=1
            test=height[l1]
            while l1<l2:
                water+=test-height[l1]
                l1+=1
            
    while max_index < r2:
        if height[r2-1] < height [r1]:
            r2-=1
        else:
            r2-=1  
            test=height[r1]
            while r2<r1 :
                water+=test-height[r1]
                r1-=1                 
    return water              

               

print(trap(height))