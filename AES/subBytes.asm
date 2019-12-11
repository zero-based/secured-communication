INCLUDE procs.inc			; get procedure prototypes
INCLUDE vars.inc			; get variables

.code
	
;-----------------------------------------------------
SubBytes	PROC,
			msg		:PTR BYTE,			; Offset of message
			_Sbox	:PTR BYTE			; Offset of SBox matrix
;
; Each byte in message matrix is replaced with another
; according to [SBox] lookup table.
; Returns: nothing
;-----------------------------------------------------
			pushad			; save all registers

			popad			; restore all registers
			ret
SubBytes	ENDP

END