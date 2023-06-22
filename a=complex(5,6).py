a=input('input data: ')
match type(a):
  case type[str]:
    print('it is a STRING')
  case type(int(a)):
    print('it is an INTEGER')  
  case type(float(a)):
    print('it is a FLOAT')
  
    
  
