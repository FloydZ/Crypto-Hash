.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code
bnMulDw proc uses edi esi ebx bn:dword,dwVal:dword
	mov esi,bn
	mov edi,dwVal
	bnSCreateX ebx
	mov eax,[esi].BN.dwSize
	inc eax
	.if eax <= BN_MAX_DWORD
		mov [ebx],eax
		call _bn_muldw_basecase
		mov ecx,[esi].BN.dwSize
		mov edi,ebx
		inc ecx
		call _bn_normalize
		invoke bnMov,bn,ebx
	.endif
	bnSDestroyX
	ret
bnMulDw endp
end
