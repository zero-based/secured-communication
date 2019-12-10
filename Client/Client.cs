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
            Config.AssertLengths();

            // Start Socket
            var sender = new Socket(Config.IpAddress.AddressFamily, SocketType.Stream, ProtocolType.Tcp);
            Logger.Log("Client Started.", ConsoleColor.Green);

            // Connect to Server
            Logger.Log("Connecting to Server...", ConsoleColor.Green);
            sender.Connect(Config.IpEndPoint);
            Logger.Log("Connected to Server.", ConsoleColor.Green);

            Logger.Separator();

            Logger.Log("Message", Config.Msg);
            Logger.Log("Key", Config.Key);

            // Encrypt Message
            var msgBytes = Encoding.ASCII.GetBytes(Config.Msg);
            var keyBytes = Encoding.ASCII.GetBytes(Config.Key);
            Encrypt(msgBytes, keyBytes);

            // Send Encrypted Message's Bytes
            var encryptedBytes = msgBytes;
            sender.Send(encryptedBytes);
            var encryptedMsg = Encoding.ASCII.GetString(encryptedBytes);
            Logger.Log("Sent", encryptedMsg);

            Logger.Separator();

            // Close Socket
            sender.Shutdown(SocketShutdown.Both);
            sender.Close();
            Logger.Log("Session Terminated.", ConsoleColor.Red);

            Logger.Separator();
        }

        [DllImport(Config.AesDllPath)]
        private static extern void Encrypt([In, Out]byte[] msg, [In, Out]byte[] key);
    }
}