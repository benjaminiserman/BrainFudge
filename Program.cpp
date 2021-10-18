#include<iostream>
#include<string>
#include<vector>
using namespace std;

void jumpForward(), jumpBack();
void expand(int);
void interpret(char);

string code;
vector<int> cells = vector<int>();
int currentCell = 0, currentInstruction = 0, instructionsRan = 0;

int main()
{
    while (true)
    {
        instructionsRan = currentInstruction = currentCell = 0;
        cells.clear();
        cells.push_back(0);
        code = "";

        printf("Enter BrainFudge code: (press enter twice to run)\n");

        string input;
        while (getline(cin, input))
        {
            if (input.empty()) break;

            code.append(input);
        }

        while (currentInstruction < code.length())
        {
            interpret(code[currentInstruction]);

            currentInstruction++;
            instructionsRan++;
        }

        printf("%d instructions ran.\n", instructionsRan);
        printf("Cell Data:\n");

        for (int i = 0; i < cells.size(); i++)
        {
            printf("%d", cells[i]);
        }

        printf("\n");
    }
}

void interpret(char c)
{
    switch (c)
    {
        case '>':
        {
            currentCell++;
            expand(currentCell);
            break;
        }
        case '<':
        {
            currentCell--;
            expand(currentCell);
            break;
        }
        case '+':
        {
            cells[currentCell]++;
            break;
        }
        case '-':
        {
            cells[currentCell]--;
            break;
        }
        case '.':
        {
            printf("%c", (char)cells[currentCell]);
            break;
        }
        case ',':
        {
            char c;
            scanf("%c", &c);
            cells[currentCell] = (int)c;
            break;
        }
        case '[':
        {
            if (cells[currentCell] == 0) jumpForward();
            break;
        }
        case ']':
        {
            if (cells[currentCell] != 0) jumpBack();
            break;
        }
        default:
        {
            instructionsRan--;
            break;
        }
    }
}

void expand(int cell)
{
    for (int i = cells.size(); i <= cell; i++) cells.push_back(0);
}

void jumpForward()
{
    currentInstruction++;

    for (int open = 1; open > 0; currentInstruction++)
    {
        if (code[currentInstruction] == '[') open++;
        else if (code[currentInstruction] == ']') open--;
    }

    currentInstruction--;
}

void jumpBack()
{
    currentInstruction--;

    for (int open = 1; open > 0; currentInstruction--)
    {
        if (code[currentInstruction] == '[') open--;
        else if (code[currentInstruction] == ']') open++;
    }

    currentInstruction++;
}