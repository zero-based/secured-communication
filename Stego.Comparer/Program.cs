using System;
using Stego.Test;

namespace Stego.Comparer
{
    internal static class Program
    {
        private const string StegoOutputDir = @"..\..\..\Stego.Test\bin\Debug\";
        private const string BitmapName = "colors";

        private const string Path1 = StegoOutputDir + StegoTests.BitmapsDir + BitmapName + StegoTests.BitmapExt;
        private const string Path2 = StegoOutputDir + StegoTests.BitmapsDir + BitmapName + StegoTests.StegoSuffix + StegoTests.BitmapExt;

        private static void Main(string[] args)
        {
            Console.Title = "Stego Comaprer";

            var diff = Comparer.Compare(Path1, Path2);
            Console.WriteLine();
            Console.WriteLine(diff + " Possible Modified Pixels.");
            Console.WriteLine();
        }
    }
}
