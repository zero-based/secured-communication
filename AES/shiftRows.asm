INCLUDE procs.inc			; get procedure prototypes
INCLUDE vars.inc			; get variables

.code

;-----------------------------------------------------
ShiftRows	PROC,
			msg		:PTR BYTE,		; Offset of message
			encrypt	:BYTE			; Encrypt/Decrypt Flag
;
; It's a transposition step where the last three rows of 
; the state (matrix) are rotated left in encryption 
; according to their index.
; Returns: nothing
;----------------------------------------------------------
			pushad			; save all registers

			popad			; restore all registers
			ret
ShiftRows	ENDP

END