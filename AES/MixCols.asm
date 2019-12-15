INCLUDE AES.inc


.data

outputArr		BYTE  MSG_BYTES dup (?)
encryptVar		BYTE  ?
arrVarCounter	BYTE  ?
mulCase3		BYTE  ?
secondMulCase3	BYTE  ?
mulCase2		BYTE  ?
index			DWORD ?
columnIndex		BYTE  ?
rowIndex		DWORD ?
counter			BYTE  ?
rowCounter		BYTE  ?
temp			DWORD ?
mul0			BYTE  ?
mul1			BYTE  ?
mul2			BYTE  ?
mul3			BYTE  ?

.code

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
			mov		al, [esi]
			movzx	ebx, BYTE PTR [edi]
			cmp		ebx, 1
			je		case1
			cmp		ebx, 2
			je		case2
			cmp		ebx, 3
			je		case3

case1:		mov		al, BYTE PTR [esi]
			jmp		addNew

case2:		shl		al, 1
			cmp		BYTE PTR [esi], 1
			mov		mulCase2, al
			js		carryFlag
			jmp		addNew

carryFlag:	xor		mulCase2, 01bh
			mov		al, mulCase2
			jmp		addNew

case3:		mov		mulCase3, al
			shl		al, 1
			cmp		BYTE PTR [esi], 1
			js		isNegative
			mov		secondMulCase3, al
			mov		al, secondMulCase3
			xor		al, mulCase3
			jmp		addNew

isNegative:	xor		eax, 01bh
			mov		secondMulCase3, al 
			mov		al, secondMulCase3
			xor		al, mulCase3
			jmp		addNew

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
			mov		ebx,rowIndex
			mov     temp,ebx
			pop		ebx
			mov		columnIndex, 0

rest:		mov		ecx, MSG_COLS

innerLoop:	mov		esi, msg
			mov		edi, OFFSET DEC_MATRIX 
			add		esi, index
			add		edi, rowIndex
			mov		al, [esi]
			movzx	ebx, BYTE PTR [edi]

			mov		al, BYTE PTR [esi]
			mov		mul0, al
			shl		al, 1
			cmp		mul0, 1
			js		negative
			mov		mul1, al
			jmp		X1

negative:	xor		al, 01Bh
			mov		mul1, al

X1:			shl		al, 1
			cmp		mul1, 1
			js		negative1
			mov		mul2, al
			jmp		X2

negative1:	xor		al, 01Bh
			mov		mul2, al

X2:			shl		al, 1
			cmp		mul2, 1
			js		negative3
			mov		mul3, al
			jmp		mulIsOver

negative3:	xor		al, 01Bh
			mov		mul3, al

mulIsOver:	cmp		ebx, 09h
			je		case09
			cmp		ebx, 0Bh
			je		case0B
			cmp		ebx, 0Dh
			je		case0D
			cmp		ebx, 0Eh
			je		case0E

case09:		movzx	eax, mul0
			xor		al, mul3
			jmp		addNew

case0B:		movzx	eax, mul3
			xor		al, mul1
			xor		al, mul0
			jmp		addNew

case0D:		movzx	eax, mul3
			xor		al, mul2
			xor		al, mul0
			jmp		 addNew
case0E:		movzx	eax, mul3
			xor		al, mul2
			xor		al, mul1
			jmp		addNew

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