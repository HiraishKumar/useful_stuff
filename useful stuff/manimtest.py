from manim import *

class Pith(Scene):
    def construct(self):
        name =Text("Killy Daviel").to_edge(UL, buff=0.5)
        sq = Square(side_length=0.5,fill_opacity=0.75).shift(LEFT*3)
        tri = Triangle(fill_opacity=0.75).scale(0.6).to_edge(DR)
        self.play(Write(name))
        self.play(DrawBorderThenFill(sq),run_time=2)
        self.play(Create(tri))
        self.wait()
        self.play(name.animate.to_edge(UR),run_time=2) 