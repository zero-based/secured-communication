INCLUDE AES.inc

.code
	
;-----------------------------------------------------
SubBytes	PROC,
			msg		:PTR BYTE,						; Offset of message
			_Sbox	:PTR BYTE						; Offset of S_BOX matrix
;
; Each byte in message matrix is replaced with another
; according to [S_BOX] lookup table.
; Returns: nothing
;-----------------------------------------------------
			pushad									; save all registers

			mov		ebx, 0							; indexing message matrix
			mov		ecx, MSG_BYTES					; loop counter
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