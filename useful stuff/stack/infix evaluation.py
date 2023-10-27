string="2+(3-2*3/2+1)+1"
def infix(s:str)->int: 
    operand = []
    sign = []
    operator_priority = {'(': 0, '+': 1, '-': 1, '*': 2, '/': 2}
    def solve(sign:list[str],operand:list[int]):
        operator = sign.pop()
        B = operand.pop()
        A = operand.pop()
        if operator == '+':
            return A+B
        elif operator == '-':
            return A-B
        elif operator == '*':
            return A*B
        elif operator == '/':
            return A/B

    for i in s:
        if i.isdigit():
            operand.append(int(i))
        elif i == '(':
            sign.append(i)
        elif i == ')':
            while sign and sign[-1] != '(':
                # this dosent need to check for the higer priority signs like * 
                # because they are already solved before encountering ')' in 
                # the last else in this indent
                operand.append(solve(sign,operand))
            sign.pop()  # Pop the '('
        else:
            while sign and operator_priority[i] <= operator_priority.get(sign[-1], 0):
                # checks if the encountered sign has the same or lower priority 
                # than the last admited sign in which case it solves the last 
                # admited sign befor admiting the new sign 
                operand.append(solve(sign,operand))
            sign.append(i) # admission of the new sign 

    while sign:
        operand.append(solve(sign,operand))
    return operand[0]

print(infix(string))