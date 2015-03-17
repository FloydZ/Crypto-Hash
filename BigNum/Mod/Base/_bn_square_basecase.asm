.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code
;;	esi=bnX
;;	edi=Prod
	
;; School boy
_bn_square_basecase proc c; uses all
	push ebp
	xor ebx,ebx
	.repeat
		mov eax,[esi].BN.dwArray[ebx*4-4+4]
		mul eax
		xor ebp,ebp
		add [edi].BN.dwArray[ebx*4-4+4],eax
		adc [edi].BN.dwArray[ebx*4-4+8],edx
		adc [edi].BN.dwArray[ebx*4-4+12],ebp
		lea ecx,[ebx+1]
		jmp @F
		.repeat
			mov eax,[esi].BN.dwArray[ebx*4-4+4]
			xor ebp,ebp
			mul [esi].BN.dwArray[ecx*4-4+4]
			add eax,eax
			adc edx,edx
			adc ebp,ebp
			add [edi].BN.dwArray[ecx*4-4+4],eax
			adc [edi].BN.dwArray[ecx*4-4+8],edx
			adc [edi].BN.dwArray[ecx*4-4+12],ebp
			inc ecx
@@:		.until ecx >= [esi].BN.dwSize
		add edi,4
		inc ebx
	.until ebx >= [esi].BN.dwSize
	pop ebp
	ret
_bn_square_basecase endp

end