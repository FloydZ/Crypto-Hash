.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

bnMov proc bn_Dest:DWORD,bn_Src:DWORD
	mov edx,edi
	mov eax,esi
	mov edi,bn_Dest
	mov ecx,BN_ALLOC_BYTES
	mov esi,bn_Src 
	shr ecx,2
	rep movsd
	mov esi,eax
	mov edi,edx
	ret 
bnMov endp

end

