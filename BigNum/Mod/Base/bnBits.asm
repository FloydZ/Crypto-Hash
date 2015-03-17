.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

bnBits proc bn:dword
	mov edx,bn
	mov ecx,[edx].BN.dwSize
	bsr eax,[edx].BN.dwArray[ecx*4-1*4]
	jz @F
	shl ecx,5
	lea eax,[eax+ecx-8*4+1]
@@:	ret
bnBits endp

end
