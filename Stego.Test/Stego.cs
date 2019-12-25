using System;
using System.Collections;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;

namespace Stego.Test
{
    internal static class Stego
    {
        private static class Pixel
        {
            internal const int R = 0;
            internal const int G = 1;
            internal const int B = 2;
            internal const int Size = 3;
        }

        private const byte BitsPerByte = 8;
        private const byte ClearLsbMask = 0b11111110;
        private const byte SetLsbMask = 0b00000001;

        public static byte[] ReadBitmap(string path)
        {
            var bitmap = new Bitmap(path);

            var h = bitmap.Height;
            var w = bitmap.Width;

            var pixels = new byte[h * w * Pixel.Size];

            for (var y = 0; y < h; y++)
            {
                for (var x = 0; x < w; x++)
                {
                    var pixel = bitmap.GetPixel(x, y);
                    var index = (y * w + x) * Pixel.Size;
                    pixels[index + Pixel.R] = pixel.R;
                    pixels[index + Pixel.G] = pixel.G;
                    pixels[index + Pixel.B] = pixel.B;
                }
            }

            return pixels;
        }

        public static void WriteBitmap(byte[] pixels, string oldPath, string newPath)
        {
            var bitmap = new Bitmap(oldPath);

            var h = bitmap.Height;
            var w = bitmap.Width;

            for (var y = 0; y < h; y++)
            {
                for (var x = 0; x < w; x++)
                {
                    var index = (y * w + x) * Pixel.Size;
                    var color = Color.FromArgb(
                        pixels[index + Pixel.R],
                        pixels[index + Pixel.G],
                        pixels[index + Pixel.B]
                    );

                    bitmap.SetPixel(x, y, color);
                }
            }

            bitmap.Save(newPath);
        }


        private static bool GetLsb(byte b) => (b & 1) != 0;

        private static bool[] BytesToBits(IEnumerable<byte> bytes)
        {
            return bytes.Select(b => new BitArray(new[] { b }))
                .SelectMany(bits => bits.Cast<bool>().Reverse())
                .ToArray();
        }

        private static byte[] BitsToBytes(IEnumerable<bool> bits)
        {
            var bitsArray = new BitArray(bits.Reverse().ToArray());
            var bytes = new byte[bitsArray.Length / BitsPerByte];
            bitsArray.CopyTo(bytes, 0);
            return bytes.Reverse().ToArray();
        }


        public static byte[] Embed(byte[] pixels, IEnumerable<byte> message)
        {
            var output = (byte[])pixels.Clone();
            var messageBits = BytesToBits(message);

            for (var i = 0; i < messageBits.Length; i++)
            {
                var msgBit = messageBits[i];

                var index = i * Pixel.Size;
                var r = pixels[index + Pixel.R];
                var g = pixels[index + Pixel.G];
                var b = pixels[index + Pixel.B];

                if (GetLsb(r) ^ msgBit)
                {
                    output[index + Pixel.R] = (byte)(r | SetLsbMask);
                    output[index + Pixel.G] = (byte)(g & ClearLsbMask | Convert.ToByte(msgBit));
                }
                else
                {
                    output[index + Pixel.R] = (byte)(r & ClearLsbMask);
                    output[index + Pixel.B] = (byte)(b & ClearLsbMask | Convert.ToByte(msgBit));
                }
            }

            return output;
        }

        public static byte[] Extract(byte[] pixels, int length)
        {
            var bitsLength = length * BitsPerByte;
            var bits = new bool[bitsLength];

            for (var i = 0; i < bitsLength; i++)
            {
                var index = i * Pixel.Size;
                var r = pixels[index + Pixel.R];
                var g = pixels[index + Pixel.G];
                var b = pixels[index + Pixel.B];
                bits[i] = GetLsb(r) ? GetLsb(g) : GetLsb(b);
            }

            return BitsToBytes(bits);
        }

    }
}
