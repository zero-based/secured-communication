using System;
using System.Drawing;

namespace Stego.Comparer
{
    internal static class Comparer
    {
        internal static int Compare(string bmpPath1, string bmpPath2)
        {
            var bitmap1 = new Bitmap(bmpPath1);
            var bitmap2 = new Bitmap(bmpPath2);

            var lastDiffIndex = GetLastDiffIndex(bitmap1, bitmap2);
            var changedPixels = lastDiffIndex + 1;
            WriteDiffPixels(bitmap1, bitmap2, changedPixels);
            
            bitmap1.Dispose();
            bitmap2.Dispose();

            return changedPixels;
        }

        private static int GetLastDiffIndex(Bitmap bitmap1, Bitmap bitmap2)
        {
            var h = bitmap1.Height;
            var w = bitmap1.Width;
            var lastDiffIndex = -1;

            for (var y = 0; y < h; y++)
            {
                for (var x = 0; x < w; x++)
                {
                    var pixel1 = bitmap1.GetPixel(x, y);
                    var pixel2 = bitmap2.GetPixel(x, y);
                    var index = y * h + x;
                    if (pixel1 != pixel2) lastDiffIndex = index;
                }
            }

            return lastDiffIndex;
        }

        private static void WriteDiffPixels(Bitmap bitmap1, Bitmap bitmap2, int pixelsCount)
        {
            var h = bitmap1.Height;
            var w = bitmap1.Width;

            for (var y = 0; y < h; y++)
            {
                for (var x = 0; x < w; x++)
                {
                    var pixel1 = bitmap1.GetPixel(x, y);
                    var pixel2 = bitmap2.GetPixel(x, y);
                    var index = y * h + x;
                    if (index == pixelsCount) return;
                    WriteComparedPixels(index, pixel1, pixel2);
                }
            }
        }

        private static void WriteComparedPixels(int index, Color p1, Color p2)
        {
            var diffR = p1.R != p2.R;
            var diffG = p1.G != p2.G;
            var diffB = p1.B != p2.B;
            var diff = diffR || diffG || diffB;

            const ConsoleColor unchangedColor = ConsoleColor.DarkGray;
            const ConsoleColor changedColor = ConsoleColor.Cyan;

            void WriteUnchangedPixel(Color p)
            {
                Console.ForegroundColor = unchangedColor;
                Console.Write($"#{p.R:X2}{p.G:X2}{p.B:X2}");
            }

            void WriteChangedPixel(Color p)
            {
                Console.ForegroundColor = unchangedColor;
                Console.Write("#");

                Console.ForegroundColor = diffR ? changedColor : unchangedColor;
                Console.Write($"{p.R:X2}");

                Console.ForegroundColor = diffG ? changedColor : unchangedColor;
                Console.Write($"{p.G:X2}");

                Console.ForegroundColor = diffB ? changedColor : unchangedColor;
                Console.Write($"{p.B:X2}");

            }

            Console.ForegroundColor = diff ? changedColor : unchangedColor;
            Console.Write($"[{index:D2}]  :  ");

            if (diff) WriteChangedPixel(p1);
            else WriteUnchangedPixel(p1);

            Console.ForegroundColor = diff ? changedColor : unchangedColor;
            Console.Write("  >>  ");

            if (diff) WriteChangedPixel(p2);
            else WriteUnchangedPixel(p2);

            if (diff)
            {
                Console.ForegroundColor = changedColor;
                Console.Write("   ~   ");
                if (diffR) Console.Write($"R{p2.R - p1.R:+#;-#}  ");
                if (diffG) Console.Write($"G{p2.G - p1.G:+#;-#}  ");
                if (diffB) Console.Write($"B{p2.B - p1.B:+#;-#}  ");
            }

            Console.ResetColor();
            Console.WriteLine();
        }
    }
}
