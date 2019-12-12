INCLUDE procs.inc							; get procedure prototypes
INCLUDE vars.inc							; get variables

.data
rowIndex BYTE ?
arraySize DWORD 16 

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
			mov		ecx, 4 
			mov		esi, msg

Shift:		mov		eax, [esi]
			push	ecx
			mov		cl, rowIndex
			cmp		encrypt, 1				; if encryption flag == true
			jnz		Decrypt
			ror		eax, cl					; encrypt
			jmp		Next
Decrypt:	rol		eax, cl					; decrypt
Next:		add		rowIndex, 8
			mov		[esi], eax
			add		esi, TYPE arraySize
			pop		ecx
			loop	Shift

			popad							; restore all registers
			ret
ShiftRows	ENDP

END