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
            test=(np.power(pos[0]+2,2)+np.power(pos[1]+2,2))
            if test!=0:
                denom=np.power(test,5/2)
                return (10*(pos[0]+2)/denom)*RIGHT + (10*(pos[1]+2)/denom)*UP
            
            else:
                return 0*UP +0*RIGHT  
        def SlopeMul(pos,x1=-2.25,y1=-1.25,x2=2.25,y2=1.25):
            test1=(np.power(pos[0]-x1,2)+np.power(pos[1]-y1,2))
            test2=(np.power(pos[0]-x2,2)+np.power(pos[1]-y2,2))            
            if test1==0:
                denom_1=1
            else:
                denom_1=np.power(test1,4/2)
            if test2==0:
                denom_2=1
            else:
                denom_2=np.power(test2,4/2)
            p1x=10*(pos[0]-x1)/denom_1
            p1y=10*(pos[1]-y1)/denom_1
            p2x=10*(pos[0]-x2)/denom_2
            p2y=10*(pos[1]-y2)/denom_2
            return (p1x-p2x)*RIGHT+(p1y-p2y)*UP
                 
            
        #Adds Text Onto Screen
        text=Tex("Testing the electric field equation").scale(0.8).move_to(UP*3+LEFT*4)
        self.add(text)
        self.add(MathTex(r"\vec{E}=\frac{Q\left ( x\hat{i}+y\hat{j} \right )}{4\pi\epsilon_{0}\left ( x^{2}+y^{2} \right )^{\frac{3}{2}}}").next_to(text,DOWN*1).scale(0.8))
        
        # creates the arrows that indicate direction
        # and magnitude of electric Feild
        mob=ArrowVectorField(SlopeMul)
        self.add(mob)
        
        #adds Proton To Image
        self.add(LabeledDot(Tex("+", color=WHITE), color=BLUE).scale(2).move_to(DOWN*1.25+LEFT*2.25))
        self.add(LabeledDot(Tex("-", color=WHITE), color=BLUE).scale(2).move_to(UP*1.25+RIGHT*2.25))