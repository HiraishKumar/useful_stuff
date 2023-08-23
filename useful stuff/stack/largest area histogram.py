# test = [6, 2, 5, 4, 5, 1, 6]

# def Largesthistogram(test: list[int]) -> int:
    
#     areas = 0
#     for i in range(1, len(test)-1):
#         if test[i-1] >= test[i] or test[i+1] >= test[i]:
#             back, front = i, i
#             while back > 0 and test[back-1] >= test[i]: 
#                 back -= 1
#             while front < len(test)-1 and test[front+1] >= test[i]:  
#                 front += 1
#             test_range = test[back:front+1]
#             area = (front - back + 1) * min(test_range)
#             areas=max(area,areas)
#         else:
#             areas=max(areas,test[i])
#     areas=max(areas,test[-1])
#     return areas

# print(Largesthistogram(test))

def largest_area_histogram(heights):
    stack = []  # Initialize a stack to keep track of indices
    max_area = 0
    
    for i in range(len(heights)):
        while stack and heights[i] <= heights[stack[-1]]:
            height = heights[stack.pop()]
            width = i if not stack else i - stack[-1] - 1
            max_area = max(max_area, height * width)
        stack.append(i)
    
    while stack:
        height = heights[stack.pop()]
        width = len(heights) if not stack else len(heights) - stack[-1] - 1
        max_area = max(max_area, height * width)
    
    return max_area

# Example usage
histogram = [6, 2, 5, 4, 5, 1, 6]
print(largest_area_histogram(histogram))
