from random import randint, random

for i in range(2, 11):
    with open(f"Tests/Input/test{i}.txt", "w") as file:
        n = randint(10, 1000)
        for j in range(n):
            shape = randint(1, 3)
            if shape == 1:
                file.write(f"{shape} {randint(1, 10000)} {random() * 1000}\n")
            elif shape == 2:
                file.write(f"{shape} {randint(1, 10000)} {randint(1, 10000)} {randint(1, 10000)} {random() * 1000}\n")
            elif shape == 3:
                file.write(f"{shape} {randint(1, 10000)} {random() * 1000}\n")
