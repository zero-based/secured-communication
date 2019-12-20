using System;
using System.Net.Sockets;
using System.Runtime.InteropServices;
using System.Text;
using _CONFIG;

namespace ServerNS
{
    public static class Server
    {
        private static void Main(string[] args)
        {
            Console.Title = "Server";

            // Start Socket
            var listener = new Socket(Config.IpAddress.AddressFamily, SocketType.Stream, ProtocolType.Tcp);
            listener.Bind(Config.IpEndPoint);
            Logger.Log("Server Started.", ConsoleColor.Blue);

            // Wait for Clients
            listener.Listen(10);
            Logger.Log("Waiting for Clients...", ConsoleColor.Blue);

            // Listen to connected Client
            var clientSocket = listener.Accept();
            Logger.Log("New Client Connected.", ConsoleColor.Blue);

            while (true)
            {
                Logger.Separator();

                // Receive Key
                var keyBytes = new byte[Config.BytesCount];
                clientSocket.Receive(keyBytes);
                Logger.Log("Key", BitConverter.ToString(keyBytes));

                // Receive Encrypted Message
                var msgBytes = new byte[Config.BytesCount];
                clientSocket.Receive(msgBytes);
                Logger.Log("Encrypted", BitConverter.ToString(msgBytes));

                // Decrypt Message
                Decrypt(msgBytes, keyBytes);
                Logger.Log("Decrypted", BitConverter.ToString(msgBytes));
                Logger.Log("Message", Encoding.ASCII.GetString(msgBytes));

                Logger.Log("Done", " ");
            }
        }

        [DllImport(Config.AesDllPath)]
        private static extern void Decrypt([In, Out]byte[] msg, [In, Out]byte[] key);
    }
}