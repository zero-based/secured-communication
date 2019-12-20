using _CONFIG;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;

namespace AES.Test
{
    [TestClass]
    public class AESTests
    {
        private static IEnumerable<string[]> GetData()
        {
            /*                        Message               Key                       Encrypted Message Bytes              */
            yield return new[] { "__Hello_World!__", "___SECURE_KEY___", "53 C8 59 6E CF 28 67 FB 2D EA 06 C3 56 4A E2 B0" };
            yield return new[] { "Two One Nine Two", "Thats my Kung Fu", "29 C3 50 5F 57 14 20 F6 40 22 99 B3 1A 02 D7 3A" };
            yield return new[] { "A Secret Message", "==@#$3CR3T#K3Y==", "75 CE AD 35 7D FF 86 1D 47 A3 D6 9E E4 50 5E 6C" };
        }

        [DataTestMethod]
        [DynamicData(nameof(GetData), DynamicDataSourceType.Method)]
        public void EncryptTest(string msg, string key, string encrypted)
        {
            var msgBytes = Encoding.ASCII.GetBytes(msg);
            var keyBytes = Encoding.ASCII.GetBytes(key);
            Encrypt(msgBytes, keyBytes);
            CollectionAssert.AreEqual(HexToBytes(encrypted), msgBytes);
        }

        [DataTestMethod]
        [DynamicData(nameof(GetData), DynamicDataSourceType.Method)]
        public void DecryptTest(string msg, string key, string encrypted)
        {
            var encryptedBytes = HexToBytes(encrypted);
            var keyBytes = Encoding.ASCII.GetBytes(key);
            Decrypt(encryptedBytes, keyBytes);
            Assert.AreEqual(msg, Encoding.ASCII.GetString(encryptedBytes));
        }

        private static byte[] HexToBytes(string str)
        {
            return str.Split(' ').Select(x => Convert.ToByte(x, 16)).ToArray();
        }

        [DllImport(Config.AesDllPath)]
        private static extern void Encrypt([In, Out]byte[] msg, [In, Out]byte[] key);

        [DllImport(Config.AesDllPath)]
        private static extern void Decrypt([In, Out]byte[] msg, [In, Out]byte[] key);
    }
}
