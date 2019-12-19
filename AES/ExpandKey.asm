INCLUDE AES.inc

.code

Col1		PROC, 
			key1	:PTR BYTE,									; Offset of Previous key matrix
			key2	:PTR BYTE,									; Offset New key matrix
			rndCon	:BYTE										; Rounding Constant according to round number
;
; Generates the first Column in a new key matrix as follows:
;	 1) Rotate the column one byte upwards.
;	 2) Substitute column's bytes from S-box.
;	 3) XOR with the same column in the previous key.
;	 4) XOR with round constant column[RoundTable] (Choose column based on round number).
; Returns: nothing
;-----------------------------------------------------

			pushad

			mov		esi, key1
			mov		edi, key2

			; Rotate the column one byte upwards
				
			mov		al, [esi + KEY_SIZE - 1]
			mov		[edi + (KEY_SIZE - 1) * KEY_SIZE], al		; key2[3][0] = key1[0][3]

			mov		ecx, KEY_SIZE - 1
rotate:		mov		ebx, ecx
			mov		al, [esi + ebx * KEY_SIZE + KEY_SIZE - 1]	
			dec		ebx
			mov		[edi + ebx * KEY_SIZE], al					; key2[i - 1][0] = key1[i][3]
			loop	rotate
	
			mov		ecx, 0
subXor:		mov		al, [esi + ecx * KEY_SIZE]	
			movzx	edx, BYTE PTR [edi + ecx * KEY_SIZE]		; Substitute column's bytes from S-box
			xor		al, S_BOX[edx]								; XOR with the same column in the previous key
			mov		[edi + ecx * KEY_SIZE], al
			inc		ecx
			cmp		ecx, KEY_SIZE
			jb		subXor
			
			mov		al, [edi]
			xor		al, rndCon									; XOR with round constant column[RCON]
			mov		[edi], al

			popad
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

			pushad

			mov		esi, key1
			mov		edi, key2

			mov		ecx, 1										; Columns Counter (j), skip first column
cols:		mov		ebx, 0										; Reset Rows Counter (i)

rows:		mov		eax, KEY_SIZE
			mul		ebx
			add		eax, ecx
			mov		dl, [esi + eax]
			xor		dl, [edi + eax - 1]
			mov		[edi + eax], dl								; key2[i][j] = key1[i][j] xor key2[i][j - 1]

			inc		ebx
			cmp		ebx, KEY_SIZE
			jb		rows

			inc		ecx
			cmp		ecx, KEY_SIZE
			jb		cols

			popad
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

			pushad

			cld
			mov		esi, key
			mov		edi, OFFSET WORDS
			mov		ecx, KEY_BYTES	
			rep		movsb										; Copy input key matrix to key expansion matrix
			
			mov		esi, OFFSET WORDS							; Initialize it with first key
			mov		edi, OFFSET WORDS + KEY_BYTES				; Initialize it with next key (redundant)

			mov		ecx, 0
expand:		INVOKE	Col1, esi, edi, ROUND_TABLE[ecx]			; Calculate `g` operation to get first column in the new key
			INVOKE	XORCols, esi, edi							; Claculate Columns XORing to get the rest of the new key
			add		esi, KEY_BYTES
			add		edi, KEY_BYTES
			inc		ecx
			cmp		ecx, ROUNDS
			jb		expand

			popad
			ret

ExpandKey	ENDP

END