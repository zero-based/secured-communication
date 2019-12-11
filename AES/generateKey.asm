INCLUDE procs.inc			; get procedure prototypes
INCLUDE vars.inc			; get variables

.code

;-----------------------------------------------------
GenerateKey	PROC,
			key1	:PTR BYTE,			; Offset of Previous key matrix
			key2	:PTR BYTE			; Offset New key matrix
;
; Given matrix of the previous key it'll generate the next key matrix,
; where each Round key depends the previous round key.
; Returns: nothing
;-----------------------------------------------------
			pushad			; save all registers

			popad			; restore all registers
			ret
GenerateKey ENDP

END