from manim import *
class MonteCarlo(Scene):
    def construct(self):
        equation=MathTex(
            "\partial f(x+h,y+k)","=",
            "hf_{x}(x,y)+kf_{y}(x,y)","=",
            "f(x+h,y+k)","-","f(x,y)"
        ).move_to(UP*2.5).scale(0.8)
        self.play(Write(equation))
        framebox1 = SurroundingRectangle(equation[4:7], buff = .1)
        framebox2 = SurroundingRectangle(equation[6], buff = .1)
        self.play(
            Create(framebox1),
        )
        zero=MathTex("0").move_to(UP*2.5+RIGHT*5).scale(0.8)
        self.wait()
        self.play(
            ReplacementTransform(framebox1,framebox2),
        )
        self.wait()  
        text=Tex("By choice of function f(x,y) at (0,0) is 0").move_to(UP*2).scale(0.8)
        self.play(Write(text))
        self.play(ReplacementTransform(equation[6],zero))
        self.wait()  
        self.play(text.animate.move_to(DOWN*3.5))  
        self.wait()
        equation2=MathTex("\partial f(x+h,y+k)","=",
            "hf_{x}(x,y)+kf_{y}(x,y)","=",
            "f(x+h,y+k)")
        self.play(Write(equation2))
        self.play(equation2.animate.move_to(UP*2).scale(0.8))
        self.wait()
           