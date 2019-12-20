using System;
using System.Net.Sockets;
using System.Runtime.InteropServices;
using System.Text;
using _CONFIG;

namespace ClientNS
{
    internal static class Client
    {
        private static void Main(string[] args)
        {
            Console.Title = "Client";

            // Start Socket
            var sender = new Socket(Config.IpAddress.AddressFamily, SocketType.Stream, ProtocolType.Tcp);
            Logger.Log("Client Started.", ConsoleColor.Green);

            // Connect to Server
            Logger.Log("Connecting to Server...", ConsoleColor.Green);
            sender.Connect(Config.IpEndPoint);
            Logger.Log("Connected to Server.", ConsoleColor.Green);

            while (true)
            {
                Logger.Separator();

                // Key Prompt
                var key = LimitedPrompt("Key", Config.BytesCount);
                var keyBytes = Encoding.ASCII.GetBytes(key);
                Logger.Log("Bytes", BitConverter.ToString(keyBytes));

                // Send Key
                sender.Send(keyBytes);
                Logger.Log("Sent Key", " ");

                // Message Prompt
                var msg = LimitedPrompt("Message", Config.BytesCount);
                var msgBytes = Encoding.ASCII.GetBytes(msg);
                Logger.Log("Bytes", BitConverter.ToString(msgBytes));

                // Encrypt Message
                Encrypt(msgBytes, keyBytes);
                Logger.Log("Encrypted", BitConverter.ToString(msgBytes));

                // Send Message
                sender.Send(msgBytes);
                Logger.Log("Sent Message", " ");
            }
        }

        [DllImport(Config.AesDllPath)]
        private static extern void Encrypt([In, Out]byte[] msg, [In, Out]byte[] key);

        private static string LimitedPrompt(string key, int length)
        {
            string str;
            do
            {
                Logger.Log(key);
                str = Console.ReadLine();
            } while (str.Length != length);

            return str;
        }

    }
}