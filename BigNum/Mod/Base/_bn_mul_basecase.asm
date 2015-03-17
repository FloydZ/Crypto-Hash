.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

dwCARRY		equ dword ptr [esp+pushad_eax]

;;	esi=bnX
;;	edi=bnY
;;	ebx=Prod
	
;; School boy
_bn_mul_basecase proc c
	xor eax,eax
	pushad
	mov ebp,[esp+pushad_ebx]
	xor ebx,ebx
	.repeat
		xor ecx,ecx
		xor edx,edx
		.repeat
			mov eax,[esi].BN.dwArray[ebx*4-4+4]
			mul dword ptr [edi].BN.dwArray[ecx*4-4+4]
			add eax,dwCARRY
			adc edx,0
			add [ebp].BN.dwArray[ecx*4-4+4],eax
			adc edx,0
			inc ecx
			mov dwCARRY,edx
		.until ecx >= [edi].BN.dwSize
		mov eax,dwCARRY
		add ebp,4
		inc ebx
		mov [ebp].BN.dwArray[ecx*4-4],eax
		xor eax,eax
		mov dwCARRY,eax
	.until ebx >= [esi].BN.dwSize
	popad
	ret
_bn_mul_basecase endp

end