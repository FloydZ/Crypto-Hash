.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

bnShl1 proc uses edi bn:DWORD 
	mov edi,bn
	xor eax,eax; CLC
	mov ecx,[edi].BN.dwSize
	lea edi,[edi].BN.dwArray[0*4]
	.repeat
		mov edx,[edi]
		lea edi,[edi+4]
		adc edx,edx
		dec ecx
		mov [edi-4],edx
	.until zero?
	adc eax,eax 
	mov edi,bn
	.if zero?
		ret ; most probable case
	.endif
	call _bn_add_carry_dword
	ret
bnShl1 endp
end