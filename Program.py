
code: str = str()
cells: list[int] = []
currentCell = currentInstruction = instructionsRan = 0

def interpret(c: str):
    global currentCell
    match c:
        case '>':
            currentCell += 1
            expand(currentCell)
        case '<':
            currentCell -= 1
            expand(currentCell)
        case '+':
            cells[currentCell] += 1
        case '-':
            cells[currentCell] -= 1
        case '.':
            print(chr(cells[currentCell]), end = '')
        case ',':
            cells[currentCell] = input()[0]
        case '[':
            if (cells[currentCell] == 0):
                jumpForward()
        case ']':
            if (cells[currentCell] != 0):
                jumpBack()
        case _:
            global instructionsRan
            instructionsRan -= 1


def expand(cell: int):
    for i in range(len(cells), cell + 1):
        cells.append(0)

def jumpForward():
    global currentInstruction
    currentInstruction += 1
    open = 1
    while (open > 0):
        if (code[currentInstruction] == '['):
            open += 1
        elif (code[currentInstruction] == ']'):
            open -= 1
        currentInstruction += 1
    currentInstruction -= 1

def jumpBack():
    global currentInstruction
    currentInstruction -= 1
    open = 1
    while (open > 0):
        if (code[currentInstruction] == '['):
            open -= 1
        elif (code[currentInstruction] == ']'):
            open += 1
        currentInstruction -= 1
    currentInstruction += 1

while (True):
    cells.clear()
    cells.append(0)
    currentCell = currentInstruction = instructionsRan = 0
    code = ""

    print("Enter BrainFudge code: (press enter twice to run)")

    while (True): # do while loop
        codeLine = input()
        code += codeLine
        if (codeLine.strip() == ""):
            break

    while (currentInstruction < len(code)):
        interpret(code[currentInstruction])

        currentInstruction += 1
        instructionsRan += 1

    print(f"{instructionsRan} instructions ran.")
    print("Cell Data:")

    for x in cells:
        print(x)
    print()