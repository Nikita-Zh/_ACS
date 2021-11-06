from Models.Shape import Shape


class Parallelepiped(Shape):
    def __init__(self, x=0, y=0, z=0, density=0):
        super().__init__(density)
        self.x = int(x)
        self.y = int(y)
        self.z = int(z)

    def square(self):
        return 2 * (self.x * self.y
                    + self.x * self.z
                    + self.y * self.z)

    def __str__(self):
        return f"Parallelepiped;" \
               f" x: {self.x}," \
               f" y: {self.y}," \
               f" z: {self.z}," \
               f" density: {self.density}," \
               f" square: {self.square()}"
