.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

_bn_adddw_ignoresign proc c; uses edi,esi,eax,ecx,edx
	lea edx,[edi].BN.dwArray[0*4]
	mov ecx,[edi].BN.dwSize
	clc
	.repeat
		adc [edx],eax
		mov eax,0
		lea edx,[edx+4]
		jnc @F
		dec ecx
	.until zero?
	adc eax,eax
	jz @F
	call _bn_add_carry_dword
@@:	ret
_bn_adddw_ignoresign endp

end
