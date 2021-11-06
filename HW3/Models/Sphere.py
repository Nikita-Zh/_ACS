from Models.Shape import Shape
from math import pi


class Sphere(Shape):
    def __init__(self, radius=0, density=0):
        super().__init__(density)
        self.radius = int(radius)

    def square(self):
        return 2 * pi * self.radius * self.radius

    def __str__(self):
        return f"Sphere; radius: {self.radius}, density: {self.density}, square: {self.square()}"
