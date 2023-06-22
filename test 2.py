s=input('enter numeral ').upper()
def fun(s):
    d={'I':1,'V':5,'X':10,'L':50,'C':100,'D':500,'M':1000}
    sum=0
    for i in range (len(s)):
        if i!=(len(s)-1):
            if d[s[i]]<d[s[i+1]]:
                sum+= -d[s[i]]               
            else:
                sum+= d[s[i]]
        else:
            sum+= d[s[i]]

    return sum
print(fun(s))


