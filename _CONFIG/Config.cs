using System.Diagnostics;
using System.Net;

namespace _CONFIG
{
    public static class Config
    {
        public const string AesDllPath = @"..\..\..\AES\Debug\AES.dll";

        private const int BitsCount = 128;
        public const int BytesCount = BitsCount / 8;

        public const string Msg = "__Hello_World!__";
        public const string Key = "___SECURE_KEY___";

        private const string Ip = "127.0.0.1";
        private const int Port = 8080;
        public static readonly IPAddress IpAddress = IPAddress.Parse(Ip);
        public static readonly IPEndPoint IpEndPoint = new IPEndPoint(IpAddress, Port);

        public static void AssertLengths()
        {
            Debug.Assert(Msg.Length == 16, "Message must be 16 characters long!");
            Debug.Assert(Key.Length == 16, "Key must be 16 characters long!");
        }
    }
}