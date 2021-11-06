from Models.Shape import Shape


class Tetrahedron(Shape):
    def __init__(self, x=0, density=0):
        super().__init__(density)
        self.x = int(x)

    def square(self):
        return self.x * self.x * 3 ** 0.5

    def __str__(self):
        return f"Tetrahedron; x: {self.x}, density: {self.density}, square: {self.square()}"
