INCLUDE procs.inc									; get procedure prototypes
INCLUDE vars.inc									; get variables

.data
arraySize DWORD 16 

.code
	
;-----------------------------------------------------
SubBytes	PROC,
			msg		:PTR BYTE,						; Offset of message
			_Sbox	:PTR BYTE						; Offset of SBox matrix
;
; Each byte in message matrix is replaced with another
; according to [SBox] lookup table.
; Returns: nothing
;-----------------------------------------------------
			pushad									; save all registers

			mov		ebx, 0							; indexing message matrix
			mov		ecx, arraySize					; loop counter
			mov		edx, msg
Subst:		mov		esi, _Sbox
			movzx	eax, BYTE PTR [edx]				; access message matrix
			add		esi, eax
			mov		al, [esi]						; access sbox matrix
			mov		[edx], al						; substitute bytes
			inc		edx
			dec		ecx
			cmp		ecx, 0
			jz		EndLoop
			jmp		Subst
EndLoop:

			popad									; restore all registers
			ret
SubBytes	ENDP

END