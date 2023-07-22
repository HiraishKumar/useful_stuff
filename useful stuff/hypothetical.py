

t=int(input('input integer here: ')) #This must be an odd number
c = 'H'
#Top Cone
for i in range (0,t):
    print((c*(1+2*i)).center(t*2,'-'))    
#Top Pillars
for i in range(t+1):
    print((c*t).center(t*2,'-')+(c*t).center(t*6,'-'))
#Middle Beam
for i in range((t+1)//2):
    print((c*(t*5)).center(t*6,'-'))
#Bottom Pillars
for i in range(t+1):
    print((c*t).center(t*2,'-')+(c*t).center(t*6),'-')
#Bottom cone
for i in range(0,t):
    print((c*(t*2-1-2*i)).center(t*10),'-')

    
    
    

