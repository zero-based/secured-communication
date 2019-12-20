using System;

namespace _CONFIG
{
    public static class Logger
    {
        private const int Padding = 24;

        public static void Log(string key, string value = "")
        {
            key = $"    [{key}]    ".PadRight(Padding);
            Console.ForegroundColor = ConsoleColor.Yellow;
            Console.Write(key);
            Console.ResetColor();
            if (!string.IsNullOrEmpty(value)) Console.WriteLine(value);
        }

        public static void Log(string message, ConsoleColor color)
        {
            Console.ForegroundColor = color;
            Console.WriteLine(message);
            Console.ResetColor();
        }

        public static void Separator()
        {
            Console.Write("\n\n");
        }
    }
}
