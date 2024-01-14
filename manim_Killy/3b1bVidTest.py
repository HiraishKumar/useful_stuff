from manim import *
def derivative(func, dt=1e-7):
    return lambda z: (func(z + dt) - func(z)) / dt
def joukowsky_map(z):
    if z == 0:
        return 0
    return z + 1/z
def cylinder_flow_vector_field(point, R=1, U=1):
    z = R3_to_complex(point)
    # return complex_to_R3(1.0 / derivative(joukowsky_map)(z))
    return complex_to_R3(derivative(joukowsky_map)(z).conjugate())

def four_swirls_function(point):
    x, y = point[:2]
    result = (y**3 - 4 * y) * RIGHT + (x**3 - 16 * x) * UP
    result *= 0.05
    # norm = get_norm(result)
    # if norm == 0:
    #     return result
    # result *= 2 * sigmoid(norm) / norm
    return result

class Testing(Scene):
    CONFIG = {
        "func": cylinder_flow_vector_field,
        "flow_time": 15,
    }

    def construct(self):
        lines = StreamLines(
            cylinder_flow_vector_field,
            virtual_time=3,
            # min_magnitude=0,
            # max_magnitude=2,
        )
        arrows=ArrowVectorField(cylinder_flow_vector_field)
        
        # self.add(AnimatedStreamLines(
        #     lines,
        #     line_anim_class=ShowPassingFlash
        # ))
        self.add(lines)
        lines.start_animation(line_anim_class=ShowPassingFlash)
        self.wait(3)
        # self.add(arrows)
        # self.wait(3)