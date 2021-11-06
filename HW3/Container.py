from Models.Parallelepiped import Parallelepiped
from Models.Sphere import Sphere
from Models.Tetrahedron import Tetrahedron


class Container:
    def __init__(self):
        self.shapes = []

    def input_from_file(self, path):
        with open(path, "r") as file:
            for line in file:
                line = line.split()
                shape = line[0]
                if shape == '1':
                    self.shapes.append(Sphere(line[1], line[2]))
                elif shape == '3':
                    self.shapes.append(Tetrahedron(line[1], line[2]))
                elif shape == '2':
                    self.shapes.append(Parallelepiped(line[1], line[2], line[3], line[4]))

    def print_to_file(self, path, mode="w"):
        with open(path, mode) as file:
            file.write(f"Container contains: {len(self.shapes)} elements.\n")
            for shape in self.shapes:
                file.write(f"{shape}\n")
            file.write("\n")

    def insertion_sort(self):
        for i in range(1, len(self.shapes)):
            temp = self.shapes[i]
            j = i - 1
            while j >= 0 and self.shapes[j].square() < temp.square():
                self.shapes[j + 1] = self.shapes[j]
                j = j - 1
            self.shapes[j + 1] = temp
