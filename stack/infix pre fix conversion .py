string ='53+3+ (44+6  /2)+6  -2'
def Calculator(s:str)->float:
    operator=[]
    operand=[]
    priority={'(':0,'+':1,'-':1,'*':3,'/':2}
    i=0
    while i < len(s):       
        char=s[i]        
        if char.isnumeric():
            num=''
            num+=char
            while i<len(s)-1 and s[i+1].isnumeric():
                i+=1
                num+=s[i]
            operator.append(int(num))
        elif char==' ':
            pass        
        else:
            if char==')':
                while operand[-1]!='(':
                    result=0
                    A=operator.pop()
                    B=operator.pop()
                    sig=operand.pop()
                    if priority[operand[-1]] >= priority[sig]:
                        sig_priority=operand.pop()
                        C=operator.pop()
                        if sig_priority=='+':
                            B=(C)+(B)
                        elif sig_priority=='-':
                            B=(C)+(B)
                        elif sig_priority=='*':
                            B=(C)*(B)
                        elif sig_priority=='/':
                            B=(C)/(B)
                    if sig=='+':
                        result+=(B)+(A)
                        operator.append(result)
                    elif sig=='-':
                        result+=(B)-(A)
                        operator.append(result)
                    elif sig=='*':
                        result+=(B)*(A)
                        operator.append(result)
                    elif sig=='/':
                        result+=(B)/(A) 
                        operator.append(result)                       
                operand.pop()
            else:
                operand.append(char)
        i+=1 
    while operand:
        result=0
        A=operator.pop()
        B=operator.pop()
        sig=operand.pop()
        if operand and priority[operand[-1]] >= priority[sig]:
            sig_priority=operand.pop()
            C=operator.pop()
            if sig_priority=='+':
                B=(C)+(B)
            elif sig_priority=='-':
                B=(C)+(B)
            elif sig_priority=='*':
                B=(C)*(B)
            elif sig_priority=='/':
                B=(C)/(B)
        if sig=='+':
            result+=(B)+(A)
        elif sig=='-':
            result+=(B)-(A)
        elif sig=='*':
            result+=(B)*(A)
        elif sig=='/':
            result+=(B)/(A) 
        operator.append(result)                
    return operator[-1]     
print(Calculator(string))  
        