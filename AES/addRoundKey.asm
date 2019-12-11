INCLUDE procs.inc			; get procedure prototypes
INCLUDE vars.inc			; get variables

.code

; ----------------------------------------------------------
AddRndKey	PROC,
			msg		:PTR BYTE,			; Offset of message matrix
			key		:ptr byte			; Offset of key matrix
;
; It's a simple XOR between the plain text and the round key.
; It's the same step in encryption and decryption.
; Returns: nothing
; ----------------------------------------------------------
			pushad			; save all registers

			popad			; restore all registers
			ret
AddRndKey	ENDP

END
