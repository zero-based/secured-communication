using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Stego.Test
{
    [TestClass]
    public class StegoTests
    {
        private const string StegoDllPath = @"..\..\..\Stego\Debug\Stego.dll";

        public const string BitmapsDir  = @"Bitmaps\";
        public const string StegoSuffix = "-stego";
        public const string BitmapExt = ".bmp";

        private static IEnumerable<string[]> GetData()
        {
            /*                              Message            Bitmap   */
            yield return new[] { "ABC"                       , "colors" };
            yield return new[] { "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "meow"   };
        }

        [DataTestMethod]
        [DynamicData(nameof(GetData), DynamicDataSourceType.Method)]
        public void EmbedTest(string msg, string bitmapName)
        {
            var msgBytes = Encoding.ASCII.GetBytes(msg);
            var bitmapPath = BitmapsDir + bitmapName + BitmapExt;
            var stegoBitmapPath = BitmapsDir + bitmapName + StegoSuffix + BitmapExt;

            var pixels = Stego.ReadBitmap(bitmapPath);
            var expectedPixels = Stego.Embed(pixels, msgBytes);
            Stego.WriteBitmap(expectedPixels, bitmapPath, stegoBitmapPath);

            Embed(pixels, msgBytes, msgBytes.Length);

            CollectionAssert.AreEqual(expectedPixels, pixels);
        }

        [DataTestMethod]
        [DynamicData(nameof(GetData), DynamicDataSourceType.Method)]
        public void ExtractTest(string msg, string bitmapName)
        {
            var stegoBitmapPath = BitmapsDir + bitmapName + StegoSuffix + BitmapExt;
            var pixels = Stego.ReadBitmap(stegoBitmapPath);
            var expectedMsgBytes = Stego.Extract(pixels, msg.Length);

            var actualMsgBytes = new byte[msg.Length];
            Extract(pixels, actualMsgBytes, msg.Length);

            CollectionAssert.AreEqual(expectedMsgBytes, actualMsgBytes);
        }

        [DllImport(StegoDllPath)]
        private static extern void Embed([In, Out] byte[] pixels, [In, Out] byte[] msg, int length);

        [DllImport(StegoDllPath)]
        private static extern void Extract([In, Out] byte[] pixels, [In, Out] byte[] msg, int length);
    }
}
