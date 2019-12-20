INCLUDE AES.inc

.code

;-----------------------------------------------------
ShiftRows	PROC,
			msg		:PTR BYTE,				; Offset of message
			mode	:BYTE					; ENC_MODE or DEC_MDOE
;
; It's a transposition step where the last three rows of 
; the state (matrix) are rotated left in encryption 
; according to their index.
; Returns: nothing
;----------------------------------------------------------

			pushad

			mov		esi, msg
			mov		ebx, 1											; RowIndex (Starting at 1, Row 0 is skipped)

rows:		mov		eax, BITS_PER_BYTE								; Initialize it with BITS_PER_BYTE
			mul		ebx												; Multiply it by RowIndex
			mov		ecx, eax										; RotateBits = RowIndex * BITS_PER_BYTE

			cmp		mode, ENC_MODE
			jne		decrypt
			ror		DWORD PTR [esi + ebx * MSG_SIZE], cl			; Encrypt mode: rotate row #RowIndex right
			jmp		cont
decrypt:	rol		DWORD PTR [esi + ebx * MSG_SIZE], cl			; Decrypt mode: rotate row #RowIndex left

cont:		inc		ebx
			cmp		ebx, MSG_SIZE
			jb		rows

			popad
			ret

ShiftRows	ENDP

END