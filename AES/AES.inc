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
EXTERNDEF	KEY_EXPAN	:BYTE


; Procedures Prototypes

ColMajor	PROTO,
			mtrx	:PTR BYTE			; Offset of row-major ordered array

ExpandKey	PROTO,
			key		:PTR BYTE			; Offset of input key matrix


AddRndKey	PROTO,
			msg		:PTR BYTE,			; Offset of message matrix
			rnd		:DWORD				; Round Number

SubBytes	PROTO,
			msg		:PTR BYTE,			; Offset of message matrix
			_Sbox	:PTR BYTE			; Offset of S_BOX matrix

ShiftRows	PROTO,
			msg		:PTR BYTE,			; Offset of message matrix
			encrypt	:BYTE				; Encrypt/Decrypt Flag

MixCols		PROTO,
			msg		:PTR BYTE,			; Offset of message matrix
			mode	:BYTE				; Encryptipn/decryption Flag

GetKey		PROTO,
			rnd		:DWORD,				; Round Number 0 - 10
			key		:PTR BYTE			; Pointer to returned round Key [out]
