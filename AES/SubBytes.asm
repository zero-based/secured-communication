INCLUDE AES.inc

.code
	
;-----------------------------------------------------
SubBytes	PROC,
			msg		:PTR BYTE,							; Offset of message
			box		:PTR BYTE							; Offset of (INV_S/S)_BOX
;
; Each byte in message matrix is replaced with another
; according to [S_BOX] lookup table.
; Returns: nothing
;-----------------------------------------------------

			pushad

			mov		esi, box
			mov		edi, msg

			mov		ecx, MSG_BYTES
next:		movzx	ebx, BYTE PTR [edi + ecx - 1]		; Offset = msg[i]
			mov		al, [esi + ebx]
			mov		[edi + ecx - 1], al					; msg[i] = box[Offset]
			loop	next

			popad
			ret

SubBytes	ENDP

END