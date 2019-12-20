.model flat, stdcall

; Constants

ENC_MODE		= 0
DEC_MODE		= 1

ROUNDS			= 10
ADV_MUL_CONST	= 1bh

BITS_PER_BYTE	= 8

MSG_SIZE		= 4
MSG_BYTES		= MSG_SIZE * MSG_SIZE
MSG_BITS		= MSG_BYTES * BITS_PER_BYTE

KEY_SIZE		= 4
KEY_BYTES		= KEY_SIZE * KEY_SIZE
KEY_BITS		= KEY_BYTES * BITS_PER_BYTE

WORDS_SIZE		= (ROUNDS + 1) * KEY_BYTES


; Shared Memory Data

EXTERNDEF	S_BOX		:BYTE
EXTERNDEF	INV_S_BOX	:BYTE
EXTERNDEF	ENC_MATRIX	:BYTE 
EXTERNDEF	DEC_MATRIX	:BYTE
EXTERNDEF	ROUND_TABLE	:BYTE
EXTERNDEF	WORDS		:BYTE


; Procedures Prototypes

ColMajor	PROTO,
			mtrx	:PTR BYTE			; Offset of row-major ordered array

ExpandKey	PROTO,
			key		:PTR BYTE			; Offset of input key matrix

AddRndKey	PROTO,
			msg		:PTR BYTE,			; Offset of message matrix
			rnd		:BYTE				; Round Number

SubBytes	PROTO,
			msg		:PTR BYTE,			; Offset of message matrix
			box		:PTR BYTE			; Offset of (INV_S/S)_BOX

ShiftRows	PROTO,
			msg		:PTR BYTE,			; Offset of message
			mode	:BYTE				; ENC_MODE or DEC_MDOE

MixCols		PROTO,
			msg		:PTR BYTE,			; Offset of message matrix
			mtrx	:PTR BYTE			; Offset of (ENC/DEC)_MATRIX
