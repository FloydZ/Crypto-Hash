.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

bnXchg proc uses esi edi bnX:DWORD,bnY:DWORD
	mov ecx,BN_ALLOC_BYTES
	mov edi,bnX
	sub ecx,4
	mov esi,bnY 
	.repeat
		mov eax,[esi+ecx]
		mov edx,[edi+ecx]
		mov [edi+ecx],eax
		mov [esi+ecx],edx
		sub ecx,4
	.until sign?
	ret 
bnXchg endp

end

