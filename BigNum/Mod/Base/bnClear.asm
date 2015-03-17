.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

bnClear proc uses edi bn:DWORD
	mov edi,bn  
	xor eax,eax
	mov [edi].BN.dwSize,1
	mov [edi].BN.bSigned,eax;FALSE
	mov ecx,BN_MAX_DWORD
	add edi,BN.dwArray
	rep stosd;clear the num
	ret
bnClear endp

end
