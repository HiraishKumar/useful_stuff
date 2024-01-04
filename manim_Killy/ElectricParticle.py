from manim import *

class ElectricParticle(Scene):
    def construct(self):
        #Adds the grid onto number plane
        number_plane = NumberPlane(  
            x_range=[-10, 10, 1],
            y_range=[-10, 10, 1],
            stroke_width=1,
            axis_config={
                "stroke_color": YELLOW,
                "stroke_width": 1,
            },
            background_line_style={
                "stroke_color": BLUE, 
                "stroke_width": 1, 
                "stroke_opacity": 1
            },
        )
        self.add(number_plane)
        
        #function to determine the slope in 
        #the x,y direction for a point(x,y)
        def Slope(pos):
            '''pos parameter has pos[0]=x and pos[1]=y
            
            
                        
            function to determine the slope in 
            the x,y direction for a point(x,y)'''
            test=(np.power(pos[0],2)+np.power(pos[1],2))
            if test!=0:
                denom=np.power(test,5/2)
                return (10*pos[0]/denom)*RIGHT + (10*pos[1]/denom)*UP
            
            else:
                return 0*UP +0*RIGHT       
            
        #Adds Text Onto Screen
        text=Tex("Testing the electric field equation").scale(0.8).move_to(UP*3+RIGHT*4)
        self.add(text)
        self.add(MathTex(r"\vec{E}=\frac{Q\left ( x\hat{i}+y\hat{j} \right )}{4\pi\epsilon_{0}\left ( x^{2}+y^{2} \right )^{\frac{3}{2}}}").next_to(text,DOWN*1).scale(0.8))
        
        # creates the arrows that indicate direction
        # and magnitude of electric Feild
        mob=ArrowVectorField(Slope)
        self.add(mob)
        
        #adds Proton To Image
        self.add(LabeledDot(Tex("+", color=WHITE), color=BLUE).scale(2) )
