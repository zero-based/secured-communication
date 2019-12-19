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

			pushad

			; Move input bytes into src bytes

			cld
			mov		esi, mtrx
			mov		edi, OFFSET src
			mov		ecx, MSG_BYTES
			rep		movsb


			; Transpose src bytes into dst bytes

			mov		ebx, 0							; [i] : (base for src, index for dst)
rows:		mov		esi, 0							; [j] : (base for dst, index for src)

cols:		mov		al, src[ebx * MSG_SIZE + esi]	; store src[i, j]
			mov		dst[esi * MSG_SIZE + ebx], al	; dst[j, i] = src[i, j]

			inc		esi
			cmp		esi, MSG_SIZE
			jb		cols
		
			inc		ebx
			cmp		ebx, MSG_SIZE
			jb		rows


			; Move dst bytes into the input bytes

			cld
			mov		esi, OFFSET dst
			mov		edi, mtrx
			mov		ecx, MSG_BYTES
			rep		movsb

			popad
			ret

ColMajor	ENDP

END