.model flat, stdcall

; Constants

BITS_PER_BYTE = 8

MSG_ROWS      = 4
MSG_COLS      = 4
MSG_BYTES     = MSG_ROWS * MSG_COLS
MSG_BITS      = BITS_PER_BYTE * MSG_BYTES

KEY_ROWS      = 4
KEY_COLS      = 4
KEY_BYTES     = KEY_ROWS * KEY_COLS
KEY_BITS      = BITS_PER_BYTE * KEY_BYTES




; Shared Memory Data

EXTERNDEF	S_BOX		:BYTE
EXTERNDEF	INV_S_BOX	:BYTE
EXTERNDEF	ENC_MATRIX	:BYTE 
EXTERNDEF	DEC_MATRIX	:BYTE
EXTERNDEF	ROUND_TABLE	:BYTE



; Procedures Prototypes

GenerateKey	 PROTO,
			key1	:PTR BYTE,			; Offset of Previous key matrix
			key2	:PTR BYTE			; Offset New key matrix

Col1		PROTO, 
			key1	:PTR BYTE,			; Previous Round's Key Offset
			key2	:PTR BYTE,			; New Key Offset in keys array
			_Rcon	:BYTE				; Rounding Constant according to round number

XORCols		PROTO,
			key1	:PTR BYTE,			; Offset of message matrix
			key2	:PTR BYTE			; Offset of output Column

AddRndKey	PROTO,
			msg		:PTR BYTE,			; Offset of message matrix
			key		:PTR BYTE			; Offset of key matrix

SubBytes	PROTO,
			msg		:PTR BYTE,			; Offset of message matrix
			_Sbox	:PTR BYTE			; Offset of S_BOX matrix

ShiftRows	PROTO,
			msg		:PTR BYTE,			; Offset of message matrix
			encrypt	:BYTE				; Encrypt/Decrypt Flag

MixCols		PROTO,
			msg		:PTR BYTE,			; Offset of message matrix
			mode	:BYTE				; Encryptipn/decryption Flag


