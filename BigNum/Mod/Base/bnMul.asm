.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code
bnMul proc uses ebx esi edi bnX:DWORD,bnY:DWORD,bnProd:DWORD
LOCAL tmpProd
	bnSCreateX tmpProd
	mov esi,bnX
	mov edi,bnY
;	.if !BN_IS_ZERO(esi) && !BN_IS_ZERO(edi) 
	mov eax,[esi].BN.dwSize
	mov ebx,tmpProd
	add eax,[edi].BN.dwSize; known max == size(x)+size(y)
	.if eax <= BN_MAX_DWORD
		mov [ebx],eax
		call _bn_mul_basecase
		mov edi,tmpProd
		mov ecx,[edi].BN.dwSize
		call _bn_normalize
		;---------------------;
		; sign(x) xor sign(y) ;
		;---------------------;
		mov esi,bnX
		mov eax,bnY
		mov ebx,[esi].BN.bSigned
		xor ebx,[eax].BN.bSigned
		.if ecx==1 && [edi].BN.dwArray[0] == 0 
			xor ebx,ebx
		.endif
		mov [edi].BN.bSigned,ebx;tmpProd
	.endif
	invoke bnMov,bnProd,tmpProd
	bnSDestroyX
	ret
bnMul endp

end
