a=(input('specify an input '))
try:
    if(type(int(a))==int):
        b=(input('is it a  '))
        if(b=='yes','yeah','yep'):
            print('it is an INTEGAR')
        else:
            print('what are you doing')
except Exception:            
    if(type(a)==str):
        print('it is a STRING')
    
  
