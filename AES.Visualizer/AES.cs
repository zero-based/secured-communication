using System;
using System.Collections.Generic;

namespace AES.Visualizer
{
    public static class AES
    {
        private const int BlockSize = 4;
        private const int KeySize = 4;
        private const int Rounds = 10;
        private const int KeysCount = BlockSize * (Rounds + 1);

        private static readonly byte[,] State = new byte[4, BlockSize];
        private static readonly byte[,] Words = new byte[KeysCount, 4];

        private static readonly byte[,] RoundingConstants = {
            {0x00, 0x00, 0x00, 0x00},
            {0x01, 0x00, 0x00, 0x00},
            {0x02, 0x00, 0x00, 0x00},
            {0x04, 0x00, 0x00, 0x00},
            {0x08, 0x00, 0x00, 0x00},
            {0x10, 0x00, 0x00, 0x00},
            {0x20, 0x00, 0x00, 0x00},
            {0x40, 0x00, 0x00, 0x00},
            {0x80, 0x00, 0x00, 0x00},
            {0x1b, 0x00, 0x00, 0x00},
            {0x36, 0x00, 0x00, 0x00}
        };

        private static readonly byte[,] SBox = {
            /*       0     1     2     3     4     5     6     7     8     9     a     b     c     d     e     f */
            /*0*/  {0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5, 0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76},
            /*1*/  {0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0, 0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0},
            /*2*/  {0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc, 0x34, 0xa5, 0xe5, 0xf1, 0x71, 0xd8, 0x31, 0x15},
            /*3*/  {0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05, 0x9a, 0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75},
            /*4*/  {0x09, 0x83, 0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0, 0x52, 0x3b, 0xd6, 0xb3, 0x29, 0xe3, 0x2f, 0x84},
            /*5*/  {0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b, 0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf},
            /*6*/  {0xd0, 0xef, 0xaa, 0xfb, 0x43, 0x4d, 0x33, 0x85, 0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c, 0x9f, 0xa8},
            /*7*/  {0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5, 0xbc, 0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2},
            /*8*/  {0xcd, 0x0c, 0x13, 0xec, 0x5f, 0x97, 0x44, 0x17, 0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19, 0x73},
            /*9*/  {0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88, 0x46, 0xee, 0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb},
            /*a*/  {0xe0, 0x32, 0x3a, 0x0a, 0x49, 0x06, 0x24, 0x5c, 0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79},
            /*b*/  {0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9, 0x6c, 0x56, 0xf4, 0xea, 0x65, 0x7a, 0xae, 0x08},
            /*c*/  {0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6, 0xb4, 0xc6, 0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a},
            /*d*/  {0x70, 0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e, 0x61, 0x35, 0x57, 0xb9, 0x86, 0xc1, 0x1d, 0x9e},
            /*e*/  {0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e, 0x94, 0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf},
            /*f*/  {0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68, 0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16}
        };

        private static readonly byte[,] InvSBox = {
            /*       0     1     2     3     4     5     6     7     8     9     a     b     c     d     e     f */
            /*0*/  {0x52, 0x09, 0x6a, 0xd5, 0x30, 0x36, 0xa5, 0x38, 0xbf, 0x40, 0xa3, 0x9e, 0x81, 0xf3, 0xd7, 0xfb},
            /*1*/  {0x7c, 0xe3, 0x39, 0x82, 0x9b, 0x2f, 0xff, 0x87, 0x34, 0x8e, 0x43, 0x44, 0xc4, 0xde, 0xe9, 0xcb},
            /*2*/  {0x54, 0x7b, 0x94, 0x32, 0xa6, 0xc2, 0x23, 0x3d, 0xee, 0x4c, 0x95, 0x0b, 0x42, 0xfa, 0xc3, 0x4e},
            /*3*/  {0x08, 0x2e, 0xa1, 0x66, 0x28, 0xd9, 0x24, 0xb2, 0x76, 0x5b, 0xa2, 0x49, 0x6d, 0x8b, 0xd1, 0x25},
            /*4*/  {0x72, 0xf8, 0xf6, 0x64, 0x86, 0x68, 0x98, 0x16, 0xd4, 0xa4, 0x5c, 0xcc, 0x5d, 0x65, 0xb6, 0x92},
            /*5*/  {0x6c, 0x70, 0x48, 0x50, 0xfd, 0xed, 0xb9, 0xda, 0x5e, 0x15, 0x46, 0x57, 0xa7, 0x8d, 0x9d, 0x84},
            /*6*/  {0x90, 0xd8, 0xab, 0x00, 0x8c, 0xbc, 0xd3, 0x0a, 0xf7, 0xe4, 0x58, 0x05, 0xb8, 0xb3, 0x45, 0x06},
            /*7*/  {0xd0, 0x2c, 0x1e, 0x8f, 0xca, 0x3f, 0x0f, 0x02, 0xc1, 0xaf, 0xbd, 0x03, 0x01, 0x13, 0x8a, 0x6b},
            /*8*/  {0x3a, 0x91, 0x11, 0x41, 0x4f, 0x67, 0xdc, 0xea, 0x97, 0xf2, 0xcf, 0xce, 0xf0, 0xb4, 0xe6, 0x73},
            /*9*/  {0x96, 0xac, 0x74, 0x22, 0xe7, 0xad, 0x35, 0x85, 0xe2, 0xf9, 0x37, 0xe8, 0x1c, 0x75, 0xdf, 0x6e},
            /*a*/  {0x47, 0xf1, 0x1a, 0x71, 0x1d, 0x29, 0xc5, 0x89, 0x6f, 0xb7, 0x62, 0x0e, 0xaa, 0x18, 0xbe, 0x1b},
            /*b*/  {0xfc, 0x56, 0x3e, 0x4b, 0xc6, 0xd2, 0x79, 0x20, 0x9a, 0xdb, 0xc0, 0xfe, 0x78, 0xcd, 0x5a, 0xf4},
            /*c*/  {0x1f, 0xdd, 0xa8, 0x33, 0x88, 0x07, 0xc7, 0x31, 0xb1, 0x12, 0x10, 0x59, 0x27, 0x80, 0xec, 0x5f},
            /*d*/  {0x60, 0x51, 0x7f, 0xa9, 0x19, 0xb5, 0x4a, 0x0d, 0x2d, 0xe5, 0x7a, 0x9f, 0x93, 0xc9, 0x9c, 0xef},
            /*e*/  {0xa0, 0xe0, 0x3b, 0x4d, 0xae, 0x2a, 0xf5, 0xb0, 0xc8, 0xeb, 0xbb, 0x3c, 0x83, 0x53, 0x99, 0x61},
            /*f*/  {0x17, 0x2b, 0x04, 0x7e, 0xba, 0x77, 0xd6, 0x26, 0xe1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0c, 0x7d}
        };


        public static byte[] Encrypt(byte[] input, byte[] key, Action<string, byte[,]> onStateChanged, Action<int, byte[,]> onRoundChanged)
        {
            KeyExpansion(key);
            onRoundChanged(0, GetRoundKey(0));

            ColumnMajorOrder(input);
            onStateChanged("Input " + nameof(ColumnMajorOrder), State);

            AddRoundKey(0);
            onStateChanged(nameof(AddRoundKey), State);

            for (var round = 1; round <= Rounds - 1; ++round)
            {
                onRoundChanged(round, GetRoundKey(round));

                SubBytes();
                onStateChanged(nameof(SubBytes), State);

                ShiftRows();
                onStateChanged(nameof(ShiftRows), State);

                MixColumns();
                onStateChanged(nameof(MixColumns), State);

                AddRoundKey(round);
                onStateChanged(nameof(AddRoundKey), State);
            }

            onRoundChanged(Rounds, GetRoundKey(Rounds));

            SubBytes();
            onStateChanged(nameof(SubBytes), State);

            ShiftRows();
            onStateChanged(nameof(ShiftRows), State);

            AddRoundKey(Rounds);
            onStateChanged(nameof(AddRoundKey), State);

            return Flatten();
        }


        public static byte[] Decrypt(byte[] input, byte[] key, Action<string, byte[,]> onStateChanged, Action<int, byte[,]> onRoundChanged)
        {
            KeyExpansion(key);
            onRoundChanged(Rounds, GetRoundKey(Rounds));

            ColumnMajorOrder(input);
            onStateChanged("Input " + nameof(ColumnMajorOrder), State);

            AddRoundKey(Rounds);
            onStateChanged(nameof(AddRoundKey), State);

            for (var round = Rounds - 1; round >= 1; --round)
            {
                onRoundChanged(round, GetRoundKey(round));

                InvShiftRows();
                onStateChanged(nameof(InvShiftRows), State);

                InvSubBytes();
                onStateChanged(nameof(InvSubBytes), State);

                AddRoundKey(round);
                onStateChanged(nameof(AddRoundKey), State);

                InvMixColumns();
                onStateChanged(nameof(InvMixColumns), State);
            }

            onRoundChanged(0, GetRoundKey(0));

            InvShiftRows();
            onStateChanged(nameof(InvShiftRows), State);

            InvSubBytes();
            onStateChanged(nameof(InvSubBytes), State);

            AddRoundKey(0);
            onStateChanged(nameof(AddRoundKey), State);

            return Flatten();
        }

        private static void ColumnMajorOrder(IReadOnlyList<byte> input)
        {
            for (var i = 0; i < 4 * BlockSize; ++i)
                State[i % 4, i / 4] = input[i];
        }

        private static byte[] Flatten()
        {
            var output = new byte[4 * BlockSize];
            for (var i = 0; i < 4 * BlockSize; ++i)
                output[i] = State[i % 4, i / 4];
            return output;
        }

        private static void AddRoundKey(int round)
        {
            for (var r = 0; r < 4; ++r)
            for (var c = 0; c < 4; ++c)
                State[r, c] = (byte) (State[r, c] ^ Words[round * 4 + c, r]);
        }

        private static void SubBytes()
        {
            for (var r = 0; r < 4; ++r)
            for (var c = 0; c < 4; ++c)
                State[r, c] = SBox[State[r, c] >> 4, State[r, c] & 0x0f];
        }

        private static void InvSubBytes()
        {
            for (var r = 0; r < 4; ++r)
            for (var c = 0; c < 4; ++c)
                State[r, c] = InvSBox[State[r, c] >> 4, State[r, c] & 0x0f];
        }

        private static void ShiftRows()
        {
            var temp = new byte[4, 4];
            for (var r = 0; r < 4; ++r)
            for (var c = 0; c < 4; ++c)
                temp[r, c] = State[r, c];

            for (var r = 1; r < 4; ++r)
            for (var c = 0; c < 4; ++c)
                State[r, c] = temp[r, (c + r) % BlockSize];
        }

        private static void InvShiftRows()
        {
            var temp = new byte[4, 4];
            for (var r = 0; r < 4; ++r)
            for (var c = 0; c < 4; ++c)
                temp[r, c] = State[r, c];

            for (var r = 1; r < 4; ++r)
            for (var c = 0; c < 4; ++c)
                State[r, (c + r) % BlockSize] = temp[r, c];
        }

        private static void MixColumns()
        {
            var temp = new byte[4, 4];
            for (var r = 0; r < 4; ++r)
            for (var c = 0; c < 4; ++c)
                temp[r, c] = State[r, c];

            for (var c = 0; c < 4; ++c)
            {
                State[0, c] = (byte) (Mul02(temp[0, c]) ^ Mul03(temp[1, c]) ^
                                      Mul01(temp[2, c]) ^ Mul01(temp[3, c]));
                State[1, c] = (byte) (Mul01(temp[0, c]) ^ Mul02(temp[1, c]) ^
                                      Mul03(temp[2, c]) ^ Mul01(temp[3, c]));
                State[2, c] = (byte) (Mul01(temp[0, c]) ^ Mul01(temp[1, c]) ^
                                      Mul02(temp[2, c]) ^ Mul03(temp[3, c]));
                State[3, c] = (byte) (Mul03(temp[0, c]) ^ Mul01(temp[1, c]) ^
                                      Mul01(temp[2, c]) ^ Mul02(temp[3, c]));
            }
        }

        private static void InvMixColumns()
        {
            var temp = new byte[4, 4];
            for (var r = 0; r < 4; ++r)
            for (var c = 0; c < 4; ++c)
                temp[r, c] = State[r, c];

            for (var c = 0; c < 4; ++c)
            {
                State[0, c] = (byte) (Mul0E(temp[0, c]) ^ Mul0B(temp[1, c]) ^
                                      Mul0D(temp[2, c]) ^ Mul09(temp[3, c]));
                State[1, c] = (byte) (Mul09(temp[0, c]) ^ Mul0E(temp[1, c]) ^
                                      Mul0B(temp[2, c]) ^ Mul0D(temp[3, c]));
                State[2, c] = (byte) (Mul0D(temp[0, c]) ^ Mul09(temp[1, c]) ^
                                      Mul0E(temp[2, c]) ^ Mul0B(temp[3, c]));
                State[3, c] = (byte) (Mul0B(temp[0, c]) ^ Mul0D(temp[1, c]) ^
                                      Mul09(temp[2, c]) ^ Mul0E(temp[3, c]));
            }
        }


        private static byte Mul01(byte b) => b;
        private static byte Mul02(byte b) => b < 0x80 ? (byte)(b << 1) : (byte)((b << 1) ^ 0x1b);
        private static byte Mul03(byte b) => (byte)(Mul02(b) ^ b);
        private static byte Mul09(byte b) => (byte)(Mul02(Mul02(Mul02(b))) ^ b);
        private static byte Mul0B(byte b) => (byte)(Mul02(Mul02(Mul02(b))) ^ Mul02(b) ^ b);
        private static byte Mul0D(byte b) => (byte)(Mul02(Mul02(Mul02(b))) ^ Mul02(Mul02(b)) ^ b);
        private static byte Mul0E(byte b) => (byte)(Mul02(Mul02(Mul02(b))) ^ Mul02(Mul02(b)) ^ Mul02(b));

        private static byte[,] GetRoundKey(int round)
        {
            // Word is a column
            var key = new byte[KeySize, 4];
            for (var r = 0; r < KeySize; ++r)
            for (var c = 0; c < KeySize; ++c)
                key[r, c] = Words[round * 4 + c, r];
            return key;
        }

        private static void KeyExpansion(IReadOnlyList<byte> key)
        {
            for (var row = 0; row < KeySize; ++row)
            {
                Words[row, 0] = key[4 * row];
                Words[row, 1] = key[4 * row + 1];
                Words[row, 2] = key[4 * row + 2];
                Words[row, 3] = key[4 * row + 3];
            }

            var temp = new byte[4];

            for (var row = KeySize; row < KeysCount ; row++)
            {
                temp[0] = Words[row - 1, 0];
                temp[1] = Words[row - 1, 1];
                temp[2] = Words[row - 1, 2];
                temp[3] = Words[row - 1, 3];

                if (row % KeySize == 0)
                {
                    temp = SubstituteWord(RotateWord(temp));
                    temp[0] = (byte) (temp[0] ^ RoundingConstants[row / KeySize, 0]);
                    temp[1] = (byte) (temp[1] ^ RoundingConstants[row / KeySize, 1]);
                    temp[2] = (byte) (temp[2] ^ RoundingConstants[row / KeySize, 2]);
                    temp[3] = (byte) (temp[3] ^ RoundingConstants[row / KeySize, 3]);
                }

                Words[row, 0] = (byte) (Words[row - KeySize, 0] ^ temp[0]);
                Words[row, 1] = (byte) (Words[row - KeySize, 1] ^ temp[1]);
                Words[row, 2] = (byte) (Words[row - KeySize, 2] ^ temp[2]);
                Words[row, 3] = (byte) (Words[row - KeySize, 3] ^ temp[3]);
            }
        }

        private static byte[] SubstituteWord(IReadOnlyList<byte> word)
        {
            return new[]
            {
                SBox[word[0] >> 4, word[0] & 0x0f],
                SBox[word[1] >> 4, word[1] & 0x0f],
                SBox[word[2] >> 4, word[2] & 0x0f],
                SBox[word[3] >> 4, word[3] & 0x0f]
            };
        }

        private static byte[] RotateWord(IReadOnlyList<byte> word)
        {
            return new[]
            {
                word[1],
                word[2],
                word[3],
                word[0]
            };
        }

    }
}