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
            Config.AssertLengths();

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

            Logger.Separator();

            // Receive Encrypted Message
            var encryptedBytes = new byte[Config.BytesCount];
            clientSocket.Receive(encryptedBytes);
            var encryptedMsg = Encoding.ASCII.GetString(encryptedBytes);
            Logger.Log("Received", encryptedMsg);

            // Decrypt Message
            var keyBytes = Encoding.ASCII.GetBytes(Config.Key);
            Decrypt(encryptedBytes, keyBytes);
            var decryptedBytes = encryptedBytes;
            var decryptedMsg = Encoding.ASCII.GetString(decryptedBytes);
            Logger.Log("Decrypted", decryptedMsg);

            Logger.Separator();

            // Close Client Socket
            clientSocket.Shutdown(SocketShutdown.Both);
            clientSocket.Close();
            Logger.Log("Client Session Terminated.", ConsoleColor.Red);

            // Close Server Socket
            listener.Close();
            Logger.Log("Server Session Terminated.", ConsoleColor.Red);

            Logger.Separator();
        }

        [DllImport(Config.AesDllPath)]
        private static extern void Decrypt([In, Out]byte[] msg, [In, Out]byte[] key);
    }
}