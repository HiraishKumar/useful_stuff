

test1='((a+b)+(c+d))'
test2='(a+b)+((c+d))'


def HasDuplicateBracket(string:str)-> bool:
    source=list(string)
    stack=[]
    for i in source:
        if i != ')':
            stack.append(i)
        else:
            lenth=0
            while stack[-1] != '(':
                stack.pop()
                lenth+=1
            stack.pop()
            if lenth == 0:
                return True
    return False
    
print('Has Duplicates' if HasDuplicateBracket(test1) else 'Does Not Have Duplictaes')