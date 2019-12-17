INCLUDE AES.inc


.data

res				BYTE	?
x00				BYTE	?
x01				BYTE	?
x02				BYTE	?
x03				BYTE	?

outputArr		BYTE	MSG_BYTES dup (?)
encryptVar		BYTE	?
arrVarCounter	BYTE	?
index			DWORD	?
columnIndex		BYTE	?
rowIndex		DWORD	?
counter			BYTE	?
rowCounter		BYTE	?
temp			DWORD	?

.code

;-----------------------------------------------------
MulShift	PROC,
			x	:BYTE
;
; Shifts the byte to left by one, check the output bit if it’s one
; then XOR with `ADV_MUL_CONST` then use this value as the output of multiplication.
; If it’s zero then use this shifted value asthe output of multiplication.
; Returns: Result in EAX
;-----------------------------------------------------

			pushad

			mov		al, x
			shl		al, 1
			jc		carry
			jmp		return
carry:		xor		al, ADV_MUL_CONST

return:		mov		res, al
			popad
			mov		al, res
			ret

MulShift	ENDP

;-----------------------------------------------------
AdvMulEnc	PROC,
			x	:BYTE,					; Value of required byte from msg matrix
			y	:BYTE					; Value of required byte from (ENC/DEC)_MATRIX
;
; Multiplys x times y using advanced multiplication
; Returns: Result in EAX
;-----------------------------------------------------

			pushad

			mov		al, x
			mov		bl, y
			mov		x00, al
			INVOKE	MulShift, x00
			mov		x01, al


			cmp		bl, 1
			je		case1
			cmp		bl, 2
			je		case2
			cmp		bl, 3
			je		case3

case1:		mov		al, x00
			mov		res, al
			jmp		return

case2:		mov		al, x01
			mov		res, al
			jmp		return

case3:		mov		al, x00
			xor		al, x01
			mov		res, al

return:		popad
			mov		al, res
			ret

AdvMulEnc	ENDP


;-----------------------------------------------------
AdvMulDec	PROC,
			x	:BYTE,					; Value of required byte from msg matrix
			y	:BYTE					; Value of required byte from (ENC/DEC)_MATRIX
;
; Multiplys x times y using advanced multiplication
; Returns: Result in EAX
;-----------------------------------------------------

			pushad

			mov		al, x
			mov		bl, y

			mov		x00, al
			INVOKE	MulShift, x00
			mov		x01, al
			INVOKE	MulShift, x01
			mov		x02, al
			INVOKE	MulShift, x02
			mov		x03, al

			cmp		bl, 09h
			je		case09
			cmp		bl, 0bh
			je		case0b
			cmp		bl, 0dh
			je		case0d
			cmp		bl, 0eh
			jmp		case0e

case09:		mov		al, x00
			xor		al, x03
			jmp		return

case0b:		mov		al, x03
			xor		al, x01
			xor		al, x00
			jmp		return

case0d:		mov		al, x03
			xor		al, x02
			xor		al, x00
			jmp		return

case0e:		mov		al, x03
			xor		al, x02
			xor		al, x01

return:		mov		res, al

			popad
			mov		al, res
			ret

AdvMulDec	ENDP

;-----------------------------------------------------
Encryption PROC,
		   msg		:PTR BYTE			; Offset of message matrix
;
; Given matrix of the message, it’ll generate the mix columns
; Returns: nothing
;-----------------------------------------------------

			pushad

			mov		esi, msg
			mov		edi, OFFSET ENC_MATRIX
			mov		edx, OFFSET outputArr
			movzx	eax, BYTE PTR [esi]
			movzx	ebx, BYTE PTR [edi]

			mov		counter, 0
			mov		index, 0
			mov		rowIndex, 0
			mov		rowCounter, 0
			mov		columnIndex, 0
			mov		arrVarCounter, MSG_BYTES

outerLoop:	cmp		columnIndex, MSG_COLS
			je		nextRow
			jmp		rest

nextRow:	inc		rowCounter
			mov		edi, OFFSET ENC_MATRIX 
			mov		index, 0
			add		rowIndex, MSG_ROWS 
			push	ebx
			mov		ebx, rowIndex
			mov     temp, ebx
			pop		ebx
			mov		columnIndex, 0

rest:		mov		ecx, MSG_COLS

innerLoop:	mov		esi, msg 
			mov		edi, OFFSET ENC_MATRIX 
			add		esi, index
			add		edi, rowIndex
			INVOKE	AdvMulEnc, [esi], BYTE PTR [edi]

addNew:		xor		encryptVar, al
			mov		al, encryptVar
			inc		counter
			add		index, MSG_ROWS 
			cmp		counter, MSG_ROWS 
			jz		nextColumn
			jmp		sameCloumn

nextColumn:	mov		[edx], al
			mov		encryptVar, 0
			inc		edx
			inc		columnIndex
			cmp		rowCounter, 0
			ja		newRow
			mov		edi, OFFSET ENC_MATRIX
			mov		rowIndex, 0
			jmp		notNewRow

newRow:		mov		edi, OFFSET ENC_MATRIX
			push	ebx
			mov		ebx, temp
			mov		rowIndex, ebx
			pop		ebx

notNewRow:	dec		rowIndex
			push	eax
			mov		al, columnIndex
			mov		index, eax
			mov		counter, 0
			pop		eax

sameCloumn:	inc		rowIndex
			dec		ecx
			cmp		ecx, 0
			jnz		innerLoop
			dec		arrVarCounter
			cmp		arrVarCounter, 0
			jnz		outerLoop

			cld
			mov		edi, msg
			mov		esi, OFFSET outputArr
			mov		ecx, 16
			rep		movsb

			popad
			ret

Encryption ENDP

;-----------------------------------------------------
Decryption PROC,
		   msg		:PTR BYTE			; Offset of message matrix
;
; Given matrix of the encrypted message, it’ll generate the mix columns
; Returns: nothing
;-----------------------------------------------------
			pushad

			mov		esi, msg
			mov		edi, OFFSET DEC_MATRIX
			mov		edx, OFFSET outputArr
			movzx	eax, BYTE PTR [esi]
			movzx	ebx, BYTE PTR [edi]

			mov		counter, 0
			mov		index, 0
			mov		rowIndex, 0
			mov		rowCounter, 0
			mov		columnIndex, 0
			mov		arrVarCounter, MSG_BYTES

outerLoop:	cmp		columnIndex, MSG_COLS
			je		nextRow
			jmp		rest

nextRow:	inc		rowCounter
			mov		edi, OFFSET DEC_MATRIX 
			mov		index, 0
			add		rowIndex, MSG_ROWS 
			push    ebx
			mov		ebx, rowIndex
			mov     temp, ebx
			pop		ebx
			mov		columnIndex, 0

rest:		mov		ecx, MSG_COLS

innerLoop:	mov		esi, msg
			mov		edi, OFFSET DEC_MATRIX 
			add		esi, index
			add		edi, rowIndex
			INVOKE	AdvMulDec, [esi], BYTE PTR [edi]


addNew:		xor		encryptVar, al
			mov		al, encryptVar
			inc		counter
			add		index, MSG_ROWS 
			cmp		counter, MSG_ROWS 
			jz		nextColumn
			jmp		sameCloumn

nextColumn:	mov		[edx], al
			mov		encryptVar, 0
			inc		edx
			inc		columnIndex
			cmp		rowCounter, 0
			ja		newRow
			mov		edi, OFFSET DEC_MATRIX
			mov		rowIndex, 0
			jmp		notNewRow

newRow:		mov		edi, OFFSET DEC_MATRIX
			push    ebx 
			mov		ebx, temp
			mov		rowIndex, ebx
			pop		ebx
			

notNewRow:	dec		rowIndex
			push	eax
			mov		al, columnIndex
			mov		index, eax
			mov		counter, 0
			pop		eax

sameCloumn:	inc		rowIndex
			dec		ecx
			cmp		ecx, 0
			jnz		innerLoop
			dec		arrVarCounter
			cmp		arrVarCounter, 0
			jnz		outerLoop
			
			cld
			mov		edi, msg
			mov		esi, OFFSET outputArr
			mov		ecx, 16
			rep		movsb

			popad
			ret

Decryption ENDP

;-----------------------------------------------------
MixCols		PROC,
			msg	:PTR BYTE,				; Offset of message matrix
			mode:BYTE					; Encryptipn/decryption Flag
;
; Multiplys the message matrix by a fixed matrix [MulMatrix].
; Returns: nothing
;-----------------------------------------------------
			pushad						; save all registers
			
			cmp		mode, 1
			je		enc
			INVOKE	Decryption, msg
			jmp		quit
enc:		INVOKE	Encryption, msg

quit:		popad						; restore all registers
			ret
MixCols		ENDP

END