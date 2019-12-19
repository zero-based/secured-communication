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
columnIndex		BYTE	?
counter			BYTE	?
rowCounter		BYTE	?
index			DWORD	?
rowIndex		DWORD	?
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
AdvMul		PROC,
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

			cmp		bl, 01
			je		case01
			cmp		bl, 02
			je		case02
			cmp		bl, 03
			je		case03
			cmp		bl, 09h
			je		case09
			cmp		bl, 0bh
			je		case0b
			cmp		bl, 0dh
			je		case0d
			cmp		bl, 0eh
			jmp		case0e

case01:		mov		al, x00
			jmp		return

case02:		mov		al, x01
			jmp		return

case03:		mov		al, x00
			xor		al, x01
			jmp		return

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

AdvMul		ENDP



;-----------------------------------------------------
MixCols		PROC,
			msg		:PTR BYTE,				; Offset of message matrix
			mtrx	:PTR BYTE				; Offset of (ENC/DEC)_MATRIX
;
; Multiplys the message matrix by (ENC/DEC)_MATRIX.
; Returns: nothing
;-----------------------------------------------------

			pushad

			mov		esi, msg
			mov		edi, mtrx
			mov		edx, OFFSET outputArr
			movzx	eax, BYTE PTR [esi]
			movzx	ebx, BYTE PTR [edi]

			mov		counter, 0
			mov		index, 0
			mov		rowIndex, 0
			mov		rowCounter, 0
			mov		columnIndex, 0
			mov		arrVarCounter, MSG_BYTES

outerLoop:	cmp		columnIndex, MSG_SIZE
			je		nextRow
			jmp		rest

nextRow:	inc		rowCounter
			mov		edi, mtrx
			mov		index, 0
			add		rowIndex, MSG_SIZE 
			push	ebx
			mov		ebx, rowIndex
			mov     temp, ebx
			pop		ebx
			mov		columnIndex, 0

rest:		mov		ecx, MSG_SIZE

innerLoop:	mov		esi, msg 
			mov		edi, mtrx
			add		esi, index
			add		edi, rowIndex
			INVOKE	AdvMul, [esi], BYTE PTR [edi]

addNew:		xor		encryptVar, al
			mov		al, encryptVar
			inc		counter
			add		index, MSG_SIZE 
			cmp		counter, MSG_SIZE 
			jz		nextColumn
			jmp		sameCloumn

nextColumn:	mov		[edx], al
			mov		encryptVar, 0
			inc		edx
			inc		columnIndex
			cmp		rowCounter, 0
			ja		newRow
			mov		edi, mtrx
			mov		rowIndex, 0
			jmp		notNewRow

newRow:		mov		edi, mtrx
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
			mov		ecx, MSG_BYTES
			rep		movsb

			popad
			ret

MixCols		ENDP

END