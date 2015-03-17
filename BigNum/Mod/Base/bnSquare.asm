.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code
bnSquare proc uses ebx esi edi bnX:DWORD
	LOCAL tmpProd
	bnSCreateX tmpProd
	xor eax,eax
	mov esi,bnX
	inc eax
	mov edi,tmpProd
	mov eax,[esi]
	add eax,eax
	.if eax <= BN_MAX_DWORD
		mov [edi],eax
		call _bn_square_basecase
		mov edi,tmpProd
		mov ecx,[edi].BN.dwSize
		call _bn_normalize
	.endif
	invoke bnMov,bnX,tmpProd
	bnSDestroyX
	ret
bnSquare endp
end
