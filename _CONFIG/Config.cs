using System.Diagnostics;
using System.Net;

namespace _CONFIG
{
    public static class Config
    {
        // Stego DLL
        public const string StegoDllPath = @"..\..\..\Stego\Debug\Stego.dll";

        // AES DLL
        public const string AesDllPath = @"..\..\..\AES\Debug\AES.dll";
        private const int BitsCount = 128;
        public const int BytesCount = BitsCount / 8;

        // Client/Server IP and Port Configuration
        private const string Ip = "127.0.0.1";
        private const int Port = 8080;
        public static readonly IPAddress IpAddress = IPAddress.Parse(Ip);
        public static readonly IPEndPoint IpEndPoint = new IPEndPoint(IpAddress, Port);

        // Visualizer Data
        public const string Msg = "__Hello_World!__";
        public const string Key = "___SECURE_KEY___";
        public static readonly byte[] EncryptedMsgBytes = {
            0x53, 0xC8, 0x59, 0x6E,
            0xCF, 0x28, 0x67, 0xFB,
            0x2D, 0xEA, 0x06, 0xC3,
            0x56, 0x4A, 0xE2, 0xB0
        };
    }
}