.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

_bn_sub_ignoresign proc c uses edi esi; uses eax,ecx,edx
; x = x - y , x >= y
	mov ecx,[edi].BN.dwSize
	lea esi,[esi].BN.dwArray
	lea edx,[edi].BN.dwArray
	xor eax,eax; clear carry
	.repeat
		mov eax,[esi]
		lea esi,[esi+4]
		sbb [edx],eax
		dec ecx
		lea edx,[edx+4]
	.until ZERO?
	mov ecx,[edi].BN.dwSize
	call _bn_normalize
	ret
_bn_sub_ignoresign endp

end
