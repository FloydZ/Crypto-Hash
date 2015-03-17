.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

_bn_add_carry_dword proc c; uses ecx
	.if eax
		mov ecx,[edi].BN.dwSize
		inc ecx
		.if ecx <= BN_MAX_DWORD
			mov [edi].BN.dwArray[ecx*4-1*4],eax ; eax == carry
			mov [edi].BN.dwSize,ecx
			ret
		.endif
		mov eax,BNERR_OVERFLOW
		call _bn_error
	.endif
	ret
_bn_add_carry_dword endp

end
