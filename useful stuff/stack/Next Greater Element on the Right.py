test=[2,5,9,3,1,12,6,8,7]

# def NGETR(test:list[int])->str:
#     stack=[]
#     pairing={}
#     for i in test:
#         if stack or i <= stack[-1] :            
#             stack.append(i)
#         else:
#             while stack and stack[-1] < i :
#                 pairing[stack[-1]] = i
#                 stack.pop()
#             stack.append(i) 
#     for i in stack:
#         pairing[i]=-1
                
#     for key in test:
#         print(f'Next Greater Interger for {key} is {pairing[key]}')

def NGETR(test: list[int]) -> str:
    n = len(test)
    result = [-1] * n  # Initialize result array with -1
    stack = []  # Store indices of elements
    
    for i in range(n):
        while stack and test[i] > test[stack[-1]]:
            result[stack.pop()] = test[i]
        stack.append(i)
        
    for i in range(n):
        print(f'Next Greater Integer for {test[i]} is {result[i]}')
        
NGETR(test)