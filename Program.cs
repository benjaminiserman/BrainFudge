using System;
using System.Collections.Generic;

namespace BrainFudge
{
    internal class Program
    {
        private static string _code;
        private static readonly List<int> _cells = new();
        private static int _currentCell = 0, _currentInstruction = 0, _instructionsRan = 0;

        private static void Main()
        {
            while (true)
            {
                _cells.Clear();
                _cells.Add(0);
                _currentCell = _currentInstruction = _instructionsRan = 0;
                _code = string.Empty;

                Console.WriteLine("Enter BrainFudge code: (press enter twice to run)");

                string input;
                do
                {
                    input = Console.ReadLine().Trim();
                    _code += input;
                }
                while (input != string.Empty);

                while (_currentInstruction < _code.Length)
                {
                    Interpret(_code[_currentInstruction]);

                    _currentInstruction++;
                    _instructionsRan++;
                }

                Console.WriteLine($"{_instructionsRan} instructions ran.");
                Console.WriteLine("Cell Data:");

                foreach (var x in _cells) Console.WriteLine(x);

                Console.WriteLine();
            }
        }

        private static void Interpret(char c)
        {
            switch (c)
            {
                case '>':
                {
                    _currentCell++;
                    Expand(_currentCell);
                    break;
                }
                case '<':
                {
                    _currentCell--;
                    Expand(_currentCell);
                    break;
                }
                case '+':
                {
                    _cells[_currentCell]++;
                    break;
                }
                case '-':
                {
                    _cells[_currentCell]--;
                    break;
                }
                case '.':
                {
                    Console.Write((char)_cells[_currentCell]);
                    break;
                }
                case ',':
                {
                    _cells[_currentCell] = Console.ReadLine()[0];
                    break;
                }
                case '[':
                {
                    if (_cells[_currentCell] == 0) JumpForward();
                    break;
                }
                case ']':
                {
                    if (_cells[_currentCell] != 0) JumpBack();
                    break;
                }
                default:
                {
                    _instructionsRan--;
                    break;
                }
            }
        }

        private static void Expand(int cell)
        {
            for (int i = _cells.Count; i <= cell; i++) _cells.Add(0);
        }

        private static void JumpForward()
        {
            _currentInstruction++;

            for (int open = 1; open > 0; _currentInstruction++)
            {
                if (_code[_currentInstruction] == '[') open++;
                else if (_code[_currentInstruction] == ']') open--;
            }

            _currentInstruction--;
        }

        private static void JumpBack()
        {
            _currentInstruction--;

            for (int open = 1; open > 0; _currentInstruction--)
            {
                if (_code[_currentInstruction] == '[') open--;
                else if (_code[_currentInstruction] == ']') open++;
            }

            _currentInstruction++;
        }
    }
}