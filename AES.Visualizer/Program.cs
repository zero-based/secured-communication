using System;
using System.Text;

namespace AES.Visualizer
{
    internal static class Program
    {
        private const string Msg = "__Hello_World!__";
        private const string Key = "___SECURE_KEY___";
        private static readonly byte[] EncryptedMsgBytes =
        {
            0x53, 0xC8, 0x59, 0x6E,
            0xCF, 0x28, 0x67, 0xFB,
            0x2D, 0xEA, 0x06, 0xC3,
            0x56, 0x4A, 0xE2, 0xB0
        };

        private enum Mode
        {
            Encrypt,
            Decrypt
        }

        private static void Main(string[] args)
        {
            Console.Title = "AES Visualizer";

            Console.WriteLine("[0] Encrypt");
            Console.WriteLine("[1] Decrypt");
            Console.WriteLine("[*] Stupidity");
            Console.WriteLine();
            Console.Write("> ");
            var mode = (Mode) Convert.ToInt32(Console.ReadLine());
            Console.Clear();

            if (mode != Mode.Encrypt && mode != Mode.Decrypt)
            {
                Console.WriteLine("Stupid?");
                return;
            }

            Visualizer.WriteH1(mode == Mode.Encrypt ? "Encryption Mode" : "Decryption Mode");

            var key = Encoding.ASCII.GetBytes(Key);
            Visualizer.WriteH1("Key");
            Visualizer.WriteH2(Encoding.ASCII.GetString(key));
            Visualizer.WriteBytes(key);

            var input = mode == Mode.Encrypt
                ? Encoding.ASCII.GetBytes(Msg)
                : EncryptedMsgBytes;

            Visualizer.WriteH1("Input");
            Visualizer.WriteH2(Encoding.ASCII.GetString(input));
            Visualizer.WriteBytes(input);

            var output = mode == Mode.Encrypt
                ? AES.Encrypt(input, key, StateChanged, RoundChanged)
                : AES.Decrypt(input, key, StateChanged, RoundChanged);

            Visualizer.WriteH1("Output");
            Visualizer.WriteH2(Encoding.ASCII.GetString(output));
            Visualizer.WriteBytes(output);

            Visualizer.JustSpace();
        }

        private static void StateChanged(string @event, byte[,] newState)
        {
            Visualizer.WriteH2(@event);
            Visualizer.WriteBytes(newState);
        }

        private static void RoundChanged(int n, byte[,] key)
        {
            Visualizer.WriteH1($"Round Number ({n})" + (n == 0 ? "*" : ""));
            Visualizer.WriteH2("Key" + (n == 0 ? " ColumnMajorOrder" : ""));
            Visualizer.WriteBytes(key);
        }
    }
}
