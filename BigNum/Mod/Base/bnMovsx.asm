.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

bnMovsx proc uses edi bn:DWORD,dwVal:SDWORD
	mov ecx,BN_ALLOC_BYTES
	mov edi,bn  
	xor eax,eax
	shr ecx,2
	rep stosd
	inc ecx
	mov edi,bn
	mov eax,dwVal
	cdq; ABS     \
	xor eax,edx; | 
	sub eax,edx; /
	and edx,1
	mov [edi].BN.dwSize,ecx
	mov [edi].BN.bSigned,edx
	mov [edi].BN.dwArray[0*4],eax;init it with val
	ret
bnMovsx endp

end

