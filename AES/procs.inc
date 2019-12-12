.model flat, stdcall

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
			_Sbox	:PTR BYTE			; Offset of SBox matrix

ShiftRows	PROTO,
			msg		:PTR BYTE,			; Offset of message matrix
			encrypt	:BYTE				; Encrypt/Decrypt Flag

MixCols		PROTO,
			msg		:PTR BYTE			; Offset of message matrix


