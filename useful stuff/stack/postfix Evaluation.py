string='2+3*5-6'
def postfixer(s:str)->str:
    operator=[]
    operand=[]
    priority={'(':0,'+':1,'-':1,'*':3,'/':2}
    expression=''
    for i in string:


        if i.isnumeric():
            operator.append(i)
        elif i in '+*/-':            
            B=operator[-1]
            exp=B
            while operand and priority[operand[-1]]>priority[i]:
                operator.pop()
                A=operator.pop()             
                ex=operand.pop()
                exp=A+exp+ex
            if len(exp)>1 and expression:    
                expression=exp+expression+'+'
            else:
                expression+=exp
            operand.append(i)
    exp=''
    B=operator.pop()
    exp+=B
    while operand:
        A=operator.pop()
        ex=operand.pop()
        exp=A+exp+ex
    if expression:
        expression=exp+expression+'+'
    else:
        expression=exp
    return expression        
        
print(postfixer(string))

