from manim import *

# class NamesOfAnimation(Scene):
#     def construct(self):
#         box=Square(stroke_color = GREEN, stroke_opacity=1.0,fill_color=RED ,fill_opacity=1.0,side_length=2)
#         self.add(box)
class MonteCarlo(Scene):
    def construct(self):
        number_plane = NumberPlane(
            background_line_style={
                "stroke_color": BLUE,
                "stroke_width": 4,
                "stroke_opacity": 0.6
            }
        )
        self.add(number_plane)       