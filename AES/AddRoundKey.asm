INCLUDE AES.inc

.data

key	BYTE KEY_BYTES dup (?)

.code

; ----------------------------------------------------------
AddRndKey	PROC,
			msg		:PTR BYTE,					; Offset of message matrix
			rnd		:DWORD						; Round Number
;
; It's a simple XOR between the plain text and the round key.
; It's the same step in encryption and decryption.
; Returns: nothing
; ----------------------------------------------------------
			pushad								; save all registers

			INVOKE	GetKey, rnd, OFFSET key		; Get Round Key

			mov		ecx, MSG_BYTES				; loop counter 
			mov		edi, msg
			mov		esi, OFFSET key
XorLoop:	mov		al, BYTE PTR [edi]
			xor		al, [esi]
			mov		[edi], al
			inc		esi
			inc		edi
			loop	XorLoop

			popad								; restore all registers
			ret
AddRndKey	ENDP

END
