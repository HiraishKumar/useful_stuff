from manim import *

class ElectricParticle(Scene):
    def construct(self):
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
        def Slope(pos):
            test=(np.power(pos[0],2)+np.power(pos[1],2))
            if test!=0:
                denom=np.power(test,5/2)
                return (10*pos[0]/denom)*RIGHT + (10*pos[1]/denom)*UP
            else:
                return 0*UP +0*RIGHT
        
        mob=StreamLines(Slope)
        text=Tex("Testing the electric field equation").scale(0.8).move_to(UP*3+RIGHT*4)
        self.add(mob)
        self.add(MathTex(r"\vec{E}=\frac{Q\left ( x\hat{i}+y\hat{j} \right )}{4\pi\epsilon_{0}\left ( x^{2}+y^{2} \right )^{\frac{3}{2}}}").next_to(text,DOWN*1).scale(0.8))
        self.add(Circle(
            radius=0.75,fill_opacity=1, fill_color=BLUE, stroke_color=WHITE
                ))
        self.add(MathTex("+").scale(2.5))
        self.add(text)
        mob.start_animation(time_width=1)
        self.wait(1)