.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code
bnModDw proc uses edi esi bnX:DWORD,valY:DWORD
	mov esi,bnX
	mov edi,valY
	mov edx,[esi].BN.dwArray[0]
	mov ecx,[esi].BN.dwSize
	test edi,edi
	jz @@DivisionByZero
	cmp ecx,1
	jne @@X_GT_Y
	test edx,edx
	je @@DivideZero
	cmp edx,edi
	jbe @@X_LE_Y
@@X_GT_Y:
	; X > Y
	xor edx,edx
	dec ecx
	.repeat
		mov eax,[esi].BN.dwArray[ecx*4]
		div dword ptr valY
		dec ecx
	.until sign?
	mov eax,edx
	ret
@@X_LE_Y:
	jnz @@DivideZero
	xor edx,edx; X = Y, fall trough
@@DivideZero:	; (X < Y) OR (X = 0)
	mov eax,edx
	ret
@@DivisionByZero: 
	mov eax,BNERR_DBZ 
	call _bn_error
	;xor edx,edx
	;div edx
	ret
bnModDw endp

end
