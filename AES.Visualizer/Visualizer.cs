using System;

namespace AES.Visualizer
{
    internal static class Visualizer
    {
        private const int Padding = 4;
        private static readonly string Whitespace = new string(' ', Padding);
        private static readonly string HalfWhitespace = new string(' ', Padding / 2);

        private static void WriteColored(string message, ConsoleColor color)
        {
            Console.ForegroundColor = color;
            Console.WriteLine(message);
            Console.ResetColor();
        }

        internal static void WriteH1(string h1)
        {
            Console.WriteLine();
            Console.WriteLine();
            WriteColored($"{HalfWhitespace}[  {h1}  ]".ToUpper(), ConsoleColor.Blue);
            Console.WriteLine();
        }

        internal static void WriteH2(string h2)
        {
            Console.WriteLine();
            WriteColored($"{Whitespace}{h2}:", ConsoleColor.Yellow);
            Console.WriteLine();
        }

        internal static void WriteBytes(byte[] bytes)
        {
            Console.Write($"{Whitespace}| ");
            for (var i = 0; i < bytes.GetLength(0); i++)
            {
                Console.Write($"{bytes[i]:X2} ");
            }
            Console.WriteLine("|");
        }

        internal static void WriteBytes(byte[,] bytes)
        {
            for (var i = 0; i < bytes.GetLength(0); i++)
            {
                Console.Write($"{Whitespace}| ");
                for (var j = 0; j < bytes.GetLength(1); j++)
                {
                    Console.Write($"{bytes[i, j]:X2} ");
                }
                Console.WriteLine("|");
            }
        }

        internal static void JustSpace()
        {
            Console.WriteLine();
            Console.WriteLine();
            Console.WriteLine();
        }
    }
}
