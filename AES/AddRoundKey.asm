INCLUDE AES.inc

.code

; ----------------------------------------------------------
AddRndKey	PROC,
			msg		:PTR BYTE,					; Offset of message matrix
			rnd		:BYTE						; Round Number
;
; It's a simple XOR between the plain text and the round key.
; It's the same step in encryption and decryption.
; Returns: nothing
; ----------------------------------------------------------

			pushad

			shl		rnd, KEY_SIZE				; Key offset = Round Number * 2 ^ KEY_SIZE
			movzx	ebx, rnd

			mov		esi, OFFSET WORDS
			add		esi, ebx
			mov		edi, msg

			mov		ecx, 0
next:		mov		dl, [esi + ecx]
			xor		BYTE PTR [edi + ecx], dl
			inc		ecx
			cmp		ecx, MSG_BYTES
			jb		next

			popad
			ret

AddRndKey	ENDP

END
