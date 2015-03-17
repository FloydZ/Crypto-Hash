.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

_bn_add_ignoresign proc c uses edi esi; uses eax,ecx,edx
	mov ecx,[edi].BN.dwSize
	cmp ecx,[esi].BN.dwSize
	cmovb ecx,[esi].BN.dwSize
	mov [edi].BN.dwSize,ecx; max
	lea esi,[esi].BN.dwArray
	lea edx,[edi].BN.dwArray
	xor eax,eax; clear carry
	.repeat
		mov eax,[esi]
		lea esi,[esi+4]
		adc [edx],eax
		dec ecx
		lea edx,[edx+4]
	.until ZERO?
	sbb eax,eax
	and eax,1
	call _bn_add_carry_dword
	ret
_bn_add_ignoresign endp

end
