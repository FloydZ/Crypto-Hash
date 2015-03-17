.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code
bnDivDw proc uses edi esi ebx bnX:DWORD,valY:DWORD,bnQuo:DWORD
	mov edi,valY
	mov esi,bnX
	test edi,edi
	mov edx,[esi].BN.dwArray[0]
	jz @@DivisionByZero
	cmp [esi].BN.dwSize,1
	jne @F
	test edx,edx
	je @@DivideZero
	.if edx>edi
@@:	
 		; X > Y
		bnSCreateX edi;tempRem
		mov ecx,[esi].BN.dwSize
		xor edx,edx
		dec ecx
		.repeat
			mov eax,[esi].BN.dwArray[ecx*4]
			div dword ptr valY
			mov [edi].BN.dwArray[ecx*4],eax
			dec ecx
		.until sign?
		mov ebx,edx
		mov ecx,[esi].BN.dwSize
		call _bn_normalize
		.if bnQuo
			invoke bnMov,bnQuo,edi
		.endif
 		bnSDestroyX
 		mov eax,ebx
		ret
	.endif

	.if edx == edi 
		; X = Y
		.if bnQuo
			invoke bnMovzx,bnQuo,1
		.endif
		xor eax,eax
		ret
	.endif

	; (X < Y) OR (X = 0)
@@DivideZero:
	mov edi,edx
	.if bnQuo
		invoke bnClear,bnQuo
	.endif
	mov eax,edi
	ret

@@DivisionByZero: 
	mov eax,BNERR_DBZ 
	call _bn_error
	;xor edx,edx
	;div edx
	ret
bnDivDw endp
end
