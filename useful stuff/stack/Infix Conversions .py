string='a*(b-c)/d+e'

def infix_to_postfix(s:str)->str:
    operand=[]
    operator=[]
    postfix=''
    
    priority={'+':0,'-':0,"*":1,"/":1}
    for i in s:
        if i.isalpha():
            operand.append(i)
        elif i==')':            
            while operator.pop()!='(':
                op=operator.pop()
                if priority[operator[-1]] >= priority[op]:
                    A=operand.pop()
                    B=operand.pop()
                    op_high=operator.pop()
                    postfix+=A
                    postfix+=B
                    postfix+=op_high
                A=operand.pop()
                B=operand.pop()
                op=operator.pop()
                postfix+=A
                postfix+=B
                postfix+=op                  
