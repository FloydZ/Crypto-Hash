.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

bnMovzx proc uses edi bn:DWORD,dwVal:DWORD
	mov ecx,BN_ALLOC_BYTES
	mov edi,bn  
	mov edx,dwVal
	xor eax,eax
	shr ecx,2
	rep stosd	;mov [edi].BN.bSigned,FALSE
	mov edi,bn
	inc eax
	mov [edi].BN.dwSize,eax;set size to 1
	mov [edi].BN.dwArray[0*4],edx;init it with val
	ret
bnMovzx endp

end

