matrix = [[1,3,5,7],[10,11,16,20],[23,30,34,60]]

# matrix=[[1], [2], [3], [4], [5]]
target=13
def searchMatrix( matrix: list[list[int]], target: int) -> bool:
    right=len(matrix)-1
    left=0
    while right >= left:
        middle=((left+right)//2)
        if target in matrix[middle]:
            return True
        elif matrix[middle][0] <= target <= matrix[middle][-1]:
            higher=len(matrix[middle])-1
            lower=0
            while higher >= lower:
                mid = (higher+lower)//2
                if matrix[middle][mid]==target:
                    return True
                elif matrix[middle][mid] > target:
                    higher = mid-1
                else:
                    lower = mid + 1
            return False        
            # return False  
        elif matrix[middle][0] > target:
            right = middle - 1
        else:   
            left = middle + 1
            
print(searchMatrix(matrix,target))       
    


