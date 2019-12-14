INCLUDE AES.inc

.code

;-----------------------------------------------------
MixCols		PROC,
			msg	:PTR BYTE			; Offset of message matrix
;
; Multiplys the message matrix by a fixed matrix [MulMatrix].
; Returns: nothing
;-----------------------------------------------------
			pushad			; save all registers

			popad			; restore all registers
			ret
MixCols		ENDP

END