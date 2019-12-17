INCLUDE AES.inc

.386
.stack 4096

.data

.code

;-----------------------------------------------------
DllMain PROC,
	hInst	:DWORD,
	fdw		:DWORD, 
	lp		:DWORD
;
; DLL Entry Point
; Returns: True to the caller
;-----------------------------------------------------

            mov		eax, 1
            ret

DllMain ENDP


;-----------------------------------------------------
Encrypt PROC EXPORT,
	msg		:PTR BYTE,
	key		:PTR BYTE
;
; Encrypts a 128-bit messaage using the
; specified key and AES algorithm.
; Returns: Encrypted message 
;-----------------------------------------------------
			pushad

			INVOKE	ColMajor, msg
			INVOKE	ColMajor, key
			INVOKE	ExpandKey, key

            INVOKE	AddRndKey, msg, 0

			mov		ecx, 1
Round:		INVOKE	SubBytes, msg, OFFSET S_BOX
			INVOKE	ShiftRows, msg, 1
			INVOKE	MixCols, msg, 1
			INVOKE	AddRndKey, msg, ecx
			inc		ecx
			cmp		ecx, ROUNDS
			jb		Round

			INVOKE	SubBytes, msg, OFFSET S_BOX
			INVOKE	ShiftRows, msg, 1
			INVOKE	AddRndKey, msg, ROUNDS

			INVOKE	ColMajor, msg

			popad
            ret

Encrypt ENDP


;-----------------------------------------------------
Decrypt PROC EXPORT,
	msg		:PTR BYTE,
	key		:PTR BYTE
;
; Decrypts a 128-bit encrypted messaage using the
; specified key and AES algorithm.
; Returns: Decrypted message 
;-----------------------------------------------------
			pushad

			INVOKE	ColMajor, msg
			INVOKE	ColMajor, key
			INVOKE	ExpandKey, key

            INVOKE	AddRndKey, msg, ROUNDS

			mov		ecx, ROUNDS - 1
Round:		INVOKE	ShiftRows, msg, 0
			INVOKE	SubBytes, msg, OFFSET INV_S_BOX
			INVOKE	AddRndKey, msg, ecx
			INVOKE	MixCols, msg, 0
			dec		ecx
			cmp		ecx, 0
			ja		Round

			INVOKE	ShiftRows, msg, 0
			INVOKE	SubBytes, msg, OFFSET INV_S_BOX
			INVOKE	AddRndKey, msg, 0
			INVOKE	ColMajor, msg

			popad
            ret

Decrypt ENDP

END DllMain