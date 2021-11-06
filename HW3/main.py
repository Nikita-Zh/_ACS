# ------------------------------------------------------------------------------
# Variant number = 130
# Number of task = 4
# Number of function = 10
# Python 3.8
# ------------------------------------------------------------------------------

import sys
import time
from Container import Container

if __name__ == '__main__':
    start = time.time()

    container = Container()
    container.input_from_file(sys.argv[1])
    container.print_to_file(sys.argv[2])
    container.insertion_sort()
    container.print_to_file(sys.argv[2], "a")

    end = time.time()
    print(f"{(end - start) * 1000 :.5f} ms")
