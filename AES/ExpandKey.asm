INCLUDE AES.inc

.data

coli	DWORD	0												; temp Loop Counter
rowi	DWORD	0												; temp Loop Counter

.code

Col1		PROC, 
			key1	:PTR BYTE,									; Offset of Previous key matrix
			key2	:PTR BYTE,									; Offset New key matrix
			_RCON	:BYTE										; Rounding Constant according to round number
;
; Generates the first Column in a new key matrix as follows:
;	 1) Rotate the column one byte upwards.
;	 2) Substitute column's bytes from S-box.
;	 3) XOR with the same column in the previous key.
;	 4) XOR with round constant column[RoundTable] (Choose column based on round number).
; Returns: nothing
;-----------------------------------------------------
			pushad												; save all registers

			mov		esi, key1
			mov		ebx, key2
			mov		ecx, 3

L1:			mov		edx, 5										; Rotate the column one byte upwards
			sub		edx, ecx
			dec		edx
			mov		al, [esi + KEY_ROWS * edx + KEY_COLS - 1]
			dec		edx
			mov		[ebx + KEY_ROWS * edx], al 
	
			Loop	L1
	
			mov		al, [esi + 3]
			mov		[ebx + 12], al  
	
			mov		ecx, 4

			mov		edi, key2
			mov		ebx, 0
			mov		esi, offset S_BOX
L2:			push	ecx
			push	esi
			movzx	edx, BYTE PTR [edi + KEY_ROWS * ebx]		; Substitute column's bytes from S-box
			mov		al,  BYTE PTR [esi + edx]
			mov		esi, key1									; XOR with the same column in the previous key
			mov		cl, BYTE PTR [esi + (4*(ebx))]
			xor		al, cl
			mov		[edi + (4*(ebx))], al
			inc		ebx
			pop		esi
			pop		ecx
			loop	L2
			
			mov		edi, key2									; XOR with round constant column[RCON]
			mov		al, [edi]
			xor		al, _RCON
			mov		[edi], al

			popad												; restore all registers
			ret
Col1		ENDP


XORCols		PROC,
			key1	:PTR BYTE,									; Offset of Previous key matrix
			key2	:PTR BYTE									; Offset New key matrix
;
; XORs W[i-1] and W[i-4] where W[i-1] is the previous column in same key matrix,
; and W[i-4] is the same column in previous key matrix.
; Returns: nothing
;-----------------------------------------------------
			pushad												; save all registers

			mov		esi, key1
			mov		edi, key2
			mov		rowi, 0										; Rows Counter
			mov		coli, 1										; Columns Counter
			mov		ecx, 3
Outer:
			push	ecx
			mov		ecx, 4										; inner Loop Counter
			mov		rowi, 0										; Reset Rows Counter
Inner:		mov		ebx, coli
			mov		eax, 4
			mul		rowi
			add		ebx, eax
			mov		dl, BYTE PTR [esi + ebx]
			dec		ebx
			xor		dl, BYTE PTR [edi + ebx]
			inc		ebx
			mov		[edi + ebx], dl
			inc		rowi
			loop	Inner

			inc		coli
			pop		ecx
			loop	Outer

			popad												; restore all registers
			ret
XORCols		ENDP

;-----------------------------------------------------
ExpandKey	PROC,
			key		:PTR BYTE									; Offset of input key matrix
;
; Given matrix of the input key, it’ll generate the expansion key matrix,
; where each Round key depends the previous round key.
; Returns: nothing
;-----------------------------------------------------
			pushad												; save all registers

			mov		esi, key
			mov		edi, OFFSET KEY_EXPAN
			mov		ecx, KEY_BYTES	
			cld
			rep		movsb										; Copy input key matrix to key expansion matrix
			
			mov		esi, OFFSET KEY_EXPAN						; Initialize esi with first key
			mov		edi, OFFSET KEY_EXPAN + KEY_BYTES			; Initialize esi with next key (redundant)

			mov		ecx, 0

Expansion:	INVOKE	Col1, esi, edi, ROUND_TABLE[ecx]			; Calculate `g` operation to get first column in the new key
			INVOKE	XORCols, esi, edi							; Claculate Columns XORing to get the rest of the new key
			add		esi, KEY_BYTES
			add		edi, KEY_BYTES
			inc		ecx
			cmp		ecx, 10										; 10 Rounds of expansion
			jne		Expansion

			popad												; restore all registers
			ret
ExpandKey ENDP
END