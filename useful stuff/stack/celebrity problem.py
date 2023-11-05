knowledge=[[0,1,0,1,0],[0,0,1,0,0],[1,1,1,0,1],[0,1,0,1,1],[0,1,0,1,0]]
def Celebrity(knowledge:list[list[int]])->int:
    stack=[0,1,2,3,4]
    while len(stack)>1:
        A=stack.pop()
        B=stack.pop()
        if knowledge[A][B]==1: 
            stack.append(B)
        else:
            stack.append(A)            
    if knowledge[stack[0]].count(1)==0:
        return stack[0]+1        
    return None
print(Celebrity(knowledge))
    