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

            mov		esi, msg
            ;------------------------
            ; Dummy Encryption
            mov		bl, '*'
            mov		[esi + 00], bl
            mov		[esi + 01], bl
            mov		[esi + 14], bl
            mov		[esi + 15], bl
            ;------------------------
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

            mov		esi, msg
            ;------------------------
            ; Dummy Decryption
            mov		bl, '_'
            mov		[esi + 00], bl
            mov		[esi + 01], bl
            mov		[esi + 14], bl
            mov		[esi + 15], bl
            ;------------------------
            ret

Decrypt ENDP

END DllMain