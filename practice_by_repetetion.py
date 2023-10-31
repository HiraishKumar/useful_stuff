s = "()[]{}"

def isValid(s: str) -> bool:    
    stack=[]
    complement={'[':']','{':'}','(':')'}
    for char in s:
        if char in complement:
            stack.append(char)
        elif len(stack)==0 or complement[stack[-1]] != char:
            return False
        else:
            stack.pop()
    return len(stack)==0
                 
print(isValid(s))