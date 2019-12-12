INCLUDE procs.inc										; get procedure prototypes
INCLUDE vars.inc										; get variables

.data

coli DWORD  0											; temp Loop Counter
rowi DWORD  0											; temp Loop Counter

.code

;-----------------------------------------------------
GenerateKey	PROC,
			key1	:PTR BYTE,							; Offset of Previous key matrix
			key2	:PTR BYTE							; Offset New key matrix
;
; Given matrix of the previous key, it�ll generate the next key matrix,
; where each Round key depends the previous round key.
; Returns: nothing
;-----------------------------------------------------
			pushad										; save all registers

			mov		esi, key1
			mov		edi, key2
			mov		ebx, offset RoundTable
			INVOKE	Col1, esi, edi, [ebx + (4*(10 - 10))]
			INVOKE	XORCols, esi, edi

			popad										; restore all registers
			ret
GenerateKey ENDP



Col1 PROC, 
			key1	:PTR BYTE,							; Offset of Previous key matrix
			key2	:PTR BYTE,							; Offset New key matrix
			_RCON	:BYTE								; Rounding Constant according to round number
;
; Generates the first Column in a new key matrix as follows:
;	 1) Rotate the column one byte upwards.
;	 2) Substitute column's bytes from S-box.
;	 3) XOR with the same column in the previous key.
;	 4) XOR with round constant column[RoundTable] (Choose column based on round number).
; Returns: nothing
;-----------------------------------------------------
			pushad										; save all registers

			mov		esi, key1
			mov		ebx, key2
			mov		ecx, 3

L1:			mov		edx, 5								; Rotate the column one byte upwards
			sub		edx, ecx
			dec		edx
			mov		al, [esi + (4*(edx)) + 3]
			dec		edx
			mov		[ebx + (4*(edx))], al 
	
			Loop	L1
	
			mov		al, [esi + 3]
			mov		[ebx + 12], al  
	
			mov		ecx, 4

			mov		edi, key2
			mov		ebx, 0
			mov		esi, offset SBOX
L2:			push	ecx
			push	esi
			movzx	edx, BYTE PTR [edi + (4*(ebx))]		; Substitute column's bytes from S-box
			mov		al,  BYTE PTR [esi + edx]
			mov		esi, key1							; XOR with the same column in the previous key
			mov		cl, BYTE PTR [esi + (4*(ebx))]
			xor		al, cl
			mov		[edi + (4*(ebx))], al
			inc		ebx
			pop		esi
			pop		ecx
			loop	L2
			
			mov		edi, key2							; XOR with round constant column[RCON]
			mov		al, [edi]
			xor		al, _RCON
			mov		[edi], al

			popad										; restore all registers
			ret
Col1		ENDP



XORCols PROC,
			key1	:PTR BYTE,							; Offset of Previous key matrix
			key2	:PTR BYTE							; Offset New key matrix
;
; XORs W[i-1] and W[i-4] where W[i-1] is the previous column in same key matrix,
; and W[i-4] is the same column in previous key matrix.
; Returns: nothing
;-----------------------------------------------------
			pushad										; save all registers

			mov		esi, key1
			mov		edi, key2
			mov		rowi, 0								; Rows Counter
			mov		coli, 1								; Columns Counter
			mov		ecx, 3
Outer:
			push	ecx
			mov		ecx, 4								; inner Loop Counter
			mov		rowi, 0								; Reset Rows Counter
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

			popad										; restore all registers
			ret
XORCols		ENDP

END