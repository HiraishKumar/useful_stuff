tests={'test1':'[(a+b)+{(c+d)*(e/f)}]',
'test2':'[(a+b)+{(c+d)*(e/f)]}',
'test3':'[(a+b)+{(c+d)*(e/f)}',
'test4':'([(a+b)+{(c+d)*(e/f)}]'}

def HasBalancedBrackets(string:str)-> bool:
    
    pairing={')':'(',']':'[','}':'{'}
    stack=[]
    for element in string :
        if element in pairing.values():
            stack.append(element)
        elif element in pairing:
            if stack[-1] != pairing[element]:
                return False
            stack.pop()
                    
    return len(stack) == 0

for test in tests:
    print(HasBalancedBrackets(tests[test]))
