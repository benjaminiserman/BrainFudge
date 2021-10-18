using System;
using System.Collections.Generic;

namespace BrainFudge
{
    class Program
    {
        static string code;
        static List<int> cells = new();
        static int currentCell = 0, currentInstruction = 0, instructionsRan = 0;

        static void Main(string[] args)
        {
            while (true)
            {
                cells.Clear();
                cells.Add(0);
                currentCell = currentInstruction = instructionsRan = 0;
                code = string.Empty;

                Console.WriteLine("Enter BrainFudge code: (press enter twice to run)");

                string input;
                do
                {
                    input = Console.ReadLine().Trim();
                    code += input;
                }
                while (input != string.Empty);

                while (currentInstruction < code.Length)
                {
                    Interpret(code[currentInstruction]);

                    currentInstruction++;
                    instructionsRan++;
                }

                Console.WriteLine($"{instructionsRan} instructions ran.");
                Console.WriteLine("Cell Data:");

                foreach (var x in cells) Console.WriteLine(x);

                Console.WriteLine();
            }
        }

        static void Interpret(char c)
        {
            switch (c)
            {
                case '>':
                {
                    currentCell++;
                    Expand(currentCell);
                    break;
                }
                case '<':
                {
                    currentCell--;
                    Expand(currentCell);
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
                    Console.Write((char)cells[currentCell]);
                    break;
                }
                case ',':
                {
                    cells[currentCell] = Console.ReadLine()[0];
                    break;
                }
                case '[':
                {
                    if (cells[currentCell] == 0) JumpForward();
                    break;
                }
                case ']':
                {
                    if (cells[currentCell] != 0) JumpBack();
                    break;
                }
                default:
                {
                    instructionsRan--;
                    break;
                }
            }
        }

        static void Expand(int cell)
        {
            for (int i = cells.Count; i <= cell; i++) cells.Add(0);
        }

        static void JumpForward()
        {
            currentInstruction++;

            for (int open = 1; open > 0; currentInstruction++)
            {
                if (code[currentInstruction] == '[') open++;
                else if (code[currentInstruction] == ']') open--;
            }

            currentInstruction--;
        }

        static void JumpBack()
        {
            currentInstruction--;

            for (int open = 1; open > 0; currentInstruction--)
            {
                if (code[currentInstruction] == '[') open--;
                else if (code[currentInstruction] == ']') open++;
            }

            currentInstruction++;
        }
    }
}
