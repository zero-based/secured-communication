INCLUDE AES.inc

.data

src	byte MSG_BYTES dup (?)
dst byte MSG_BYTES dup (?)

.code

; ----------------------------------------------------------
ColMajor	PROC,
			mtrx	:PTR BYTE						; Offset of row-major ordered array
;
; Transforms Array of bytes from row-major order to column-major order
; Returns: nothing
; ----------------------------------------------------------

			; Move input bytes into src bytes

			cld
			mov		ecx, MSG_BYTES
			mov		esi, mtrx
			mov		edi, OFFSET src
			rep		movsb


			; Transpose src bytes into dst bytes

			mov		ebx, 0							; [i] : (base for src, index for dst)
rows:		mov		esi, 0							; [j] : (base for dst, index for src)

cols:		mov		al, src[ebx * MSG_COLS + esi]	; store src[i, j]
			mov		dst[esi * MSG_COLS + ebx], al	; dst[j, i] = src[i, j]

			inc		esi
			cmp		esi, MSG_COLS
			jb		cols
		
			inc		ebx
			cmp		ebx, MSG_ROWS
			jb		rows


			; Move dst bytes into the input bytes

			cld
			mov		ecx, MSG_BYTES
			mov		esi, OFFSET dst
			mov		edi, mtrx
			rep		movsb

			ret

ColMajor	ENDP

END