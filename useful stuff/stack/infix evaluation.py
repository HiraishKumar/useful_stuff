string='1-(     -2)'

def infix(string:str)->int: 
    stack=[]
    if '+' not in string and '-' not in string:
        ans=''
        for i in string:
            if i!='('and i!=')':
                ans+=i
        return int(ans)
           
    for i in string:
        if i ==')':
            while stack[-2]!='(':                
                A=int(stack.pop())
                opp=stack.pop()
                B=int(stack.pop())
                if opp=='+':
                    stack.append(str(A+B))
                elif opp=='-':
                    stack.append(str(B-A))
            num=stack.pop()
            stack.pop()
            stack.append(num)
        elif i!=' ':
            stack.append(i)
    stack=stack[::-1] 
    while len(stack)!=1:
        A=int(stack.pop())
        opp=stack.pop()
        B=int(stack.pop())
        if opp=='+':
            stack.append(str(A+B))
        elif opp=='-':
            stack.append(str(A-B))
    return int(stack[0])
    
    
                ##yeah

print(infix(string))