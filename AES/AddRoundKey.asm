INCLUDE AES.inc

.code

; ----------------------------------------------------------
AddRndKey	PROC,
			msg		:PTR BYTE,			; Offset of message matrix
			key		:PTR BYTE			; Offset of key matrix
;
; It's a simple XOR between the plain text and the round key.
; It's the same step in encryption and decryption.
; Returns: nothing
; ----------------------------------------------------------
			pushad						; save all registers

			mov		ecx, MSG_BYTES		; loop counter 
			mov		edi, msg
			mov		esi, key
XorLoop:	mov		al, BYTE PTR [edi]
			xor		al, [esi]
			mov		[edi], al
			inc		esi
			inc		edi
			loop	XorLoop

			popad						; restore all registers
			ret
AddRndKey	ENDP

END
