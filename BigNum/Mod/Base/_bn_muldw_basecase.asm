.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code
;;	esi=bnX
;;	edi=Prod
	
;; School boy
_bn_muldw_basecase proc c
	pushad
	mov ebp,[esp+pushad_ebx]
	xor ebx,ebx
	.repeat
		xor edx,edx
		mov eax,[esi].BN.dwArray[ebx*4-4+4]
		xor ecx,ecx
		inc ebx
		mul edi
		add eax,ecx
		adc edx,0
		add [ebp].BN.dwArray[0*4-4+4],eax
		adc edx,0
		add ebp,4
		mov [ebp].BN.dwArray[1*4-4],edx
	.until ebx >= [esi].BN.dwSize
	popad
	ret
_bn_muldw_basecase endp

end