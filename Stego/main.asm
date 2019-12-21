.386
.model flat, stdcall
.stack 4096

R_INDEX			= 0
G_INDEX			= 1
B_INDEX			= 2
PIXEL_SIZE		= 3

BITS_PER_BYTE	= 8
SLSB			= 00000001b
CLSB			= 11111110b

.data

msgBit	BYTE	?

.code

;-----------------------------------------------------
DllMain		PROC,
			hInst	:DWORD,
			fdw		:DWORD, 
			lp		:DWORD
;
; DLL Entry Point
; Returns: True to the caller
;-----------------------------------------------------

            mov		eax, 1
            ret

DllMain		ENDP



;-----------------------------------------------------
Embed		PROC EXPORT,
			pxls		:PTR BYTE,						; Pixels Array Pointer
			msg			:PTR BYTE, 						; Message Array Pointer
            len         :DWORD							; Length of Message Array
;
; Hides given message's bits in an array of pixels (consecutive R, G, B Colors)
; using LSB Steganography Algorithm
; Returns: nothing
;-----------------------------------------------------

			pushad

			mov		esi, msg							; Message's Offset
			mov		edi, pxls							; Pixels' Offset
			mov		ecx, 0								; Message Bytes Counter

nxtByte:	mov		edx, 0								; Bit Counter
			mov		bl, [esi + ecx]

nxtBit:		shl		bl, 1
			mov		msgBit, 0
			adc		msgBit, 0							; MSB of current msg's byte
			mov		al, [edi]
			and		al, SLSB							; LSB of Current Pixel's red Color
			xor		al, msgBit
			cmp		al, 1
			mov		al, msgBit
			jne		blue

			or		BYTE PTR [edi + R_INDEX], SLSB		; Set LSB of Red
			and		BYTE PTR [edi + G_INDEX], CLSB		; Clear LSB of Green
			or		BYTE PTR [edi + G_INDEX], al		; Replace LSB of Green with msgBit
			jmp		cont

blue:		and		BYTE PTR [edi + R_INDEX], CLSB		; Clear LSB of Red
			and		BYTE PTR [edi + B_INDEX], CLSB		; Clear LSB of Blue
			or		BYTE PTR [edi + B_INDEX], al		; Replace LSB of Blue with msgBit

cont:		inc		edx
			add		edi, PIXEL_SIZE						; next pixel
			cmp		edx, BITS_PER_BYTE
			jb		nxtBit								; get next bit of the message

			inc		ecx
			cmp		ecx, len
			jb		nxtByte								; get next Byte of the message

			popad
			ret

Embed		ENDP



;-----------------------------------------------------
Extract		PROC EXPORT,
			pxls		:PTR BYTE,					; Pixels Array Pointer
			msg			:PTR BYTE, 		            ; Message Array Pointer
            len         :DWORD                      ; Length of Message Array
;
; Extracts a hidden message from an array of pixels (consecutive R, G, B Colors)
; using LSB Steganography Algorithm
; Returns: nothing
;-----------------------------------------------------

			pushad

			mov		esi, msg						; Message's Offset
			mov		edi, pxls						; Pixels' Offset
			mov		ecx, 0							; Message Bytes Counter
			mov		eax, 0							; Init color holder

nxtByte:	mov		ebx, 0							; Message Byte Temp Storage
			mov		edx, 0							; Bit Counter

nxtBit:		mov		al, [edi + R_INDEX]
			shr		al, 1							; Push LSB of red color in CF
			jnc		blue

			mov		al, [edi + G_INDEX]
			shl		bl, 1
			shr		al, 1
			adc		bl, 0
			jmp		cont

blue:		mov		al, [edi + B_INDEX]
			shl		bl, 1
			shr		al, 1
			adc		bl, 0

cont:		inc		edx
			add		edi, PIXEL_SIZE
			cmp		edx, BITS_PER_BYTE
			jb		nxtBit							; get next bit of the message

			mov		[esi + ecx], bl
			inc		ecx
			cmp		ecx, len
			jb		nxtByte							; get next Byte of the message

Quit:		popad
			ret

Extract		ENDP

END DllMain