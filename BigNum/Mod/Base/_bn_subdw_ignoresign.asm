.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

_bn_subdw_ignoresign proc c
	lea edx,[edi].BN.dwArray[0*4]
	mov ecx,[edi].BN.dwSize
	clc
	.repeat
		sbb [edx],eax
		mov eax,0
		lea edx,[edx+4]
		jnc @F
		dec ecx
	.until zero?
@@:	mov ecx,[edi].BN.dwSize
	call _bn_normalize
	ret
_bn_subdw_ignoresign endp

end
