using System.Net;

namespace _CONFIG
{
    public static class Config
    {
        // AES
        public const string AesDllPath = @"..\..\..\AES\Debug\AES.dll";
        private const int BitsCount = 128;
        public const int BytesCount = BitsCount / 8;

        // IP and Port
        private const string Ip = "127.0.0.1";
        private const int Port = 8080;
        public static readonly IPAddress IpAddress = IPAddress.Parse(Ip);
        public static readonly IPEndPoint IpEndPoint = new IPEndPoint(IpAddress, Port);
    }
}