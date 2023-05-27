import os

directory = os.path.join(os.getenv("HOME"), "VAULT", "TODOs")
filename = os.path.join(directory, "todo.xit")

count = 0
empty_lines = 0

with open(filename, 'r') as file:
    for line in file:
        line = line.strip()
        if line.startswith('[ ]'):
            count += 1
        elif not line:
            empty_lines += 1
            if empty_lines == 2:
                break

print(count)
