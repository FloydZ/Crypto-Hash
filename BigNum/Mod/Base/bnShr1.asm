.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

bnShr1 proc uses edi bn:DWORD
	mov edi,bn
	xor eax,eax; CLC
	mov ecx,[edi].BN.dwSize
	lea edi,[edi].BN.dwArray[ecx*4-4]
	.repeat
		mov edx,[edi]
		lea edi,[edi-4]
		rcr edx,1
		dec ecx
		mov [edi+4],edx
	.until zero?
	mov edi,bn
	adc eax,eax
	mov ecx,[edi].BN.dwSize
	call _bn_normalize
	ret
bnShr1 endp
end