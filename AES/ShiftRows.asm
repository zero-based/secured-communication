INCLUDE AES.inc

.data
rowIndex BYTE ?

.code

;-----------------------------------------------------
ShiftRows	PROC,
			msg		:PTR BYTE,				; Offset of message
			encrypt	:BYTE					; Encrypt/Decrypt Flag
;
; It's a transposition step where the last three rows of 
; the state (matrix) are rotated left in encryption 
; according to their index.
; Returns: nothing
;----------------------------------------------------------
			pushad							; save all registers

			mov		rowIndex, 0
			mov		ecx, MSG_ROWS 
			mov		esi, msg

Shift:		mov		eax, [esi]
			push	ecx
			mov		cl, rowIndex
			cmp		encrypt, 1				; if encryption flag == true
			jnz		Decrypt
			ror		eax, cl					; encrypt
			jmp		Next
Decrypt:	rol		eax, cl					; decrypt
Next:		add		rowIndex, BITS_PER_BYTE
			mov		[esi], eax
			add		esi, MSG_ROWS
			pop		ecx
			loop	Shift

			popad							; restore all registers
			ret
ShiftRows	ENDP

END