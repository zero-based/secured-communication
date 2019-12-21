.model falt, stdcall
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
Embed		PROC EXPORT,
			pxls		:PTR BYTE,					; Pixels Array Pointer
			msg			:PTR BYTE, 		            ; Message Array Pointer
            len         :DWORD                      ; Length of Message Array
;
; Hides given message's bits in an array of pixels (consecutive R, G, B Colors)
; using LSB Steganography Algorithm
; Returns: nothing
;-----------------------------------------------------
			pushad

			popad
			ret

Embed		ENDP

;-----------------------------------------------------
Extract		PROC EXPORT,
			pxls		:PTR BYTE,					; Pixels Array Pointer
			msg			:PTR BYTE, 		            ; Message Array Pointer
            len         :DWORD                      ; Length of Message Array
;
; Extracts a hidden message from an array of pixels (consecutive R, G, B Colors)
; using LSB Steganography Algorithm
; Returns: nothing
;-----------------------------------------------------
			pushad

			popad
			ret
Extract		ENDP

END DllMain