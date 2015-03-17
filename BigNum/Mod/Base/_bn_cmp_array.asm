.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

; 0 if |X|=|Y|      1 if |X|>|Y|      -1 if |X|<|Y|
; edi=x esi=y
_bn_cmp_array proc c; uses edx,ecx,eax 
	mov edx,[edi].BN.dwSize
	mov ecx,[esi].BN.dwSize
	lea eax,[edx+1]; i = size + 1
	jmp @F
	.repeat
		dec eax
		jz @@Exit; done, equal
		mov edx,[edi].BN.dwArray[eax*4-1*4];bnX[i]
		mov ecx,[esi].BN.dwArray[eax*4-1*4];bnY[i]
@@:	.until edx != ecx
	sbb eax,eax
	lea eax,[eax*2+1]
@@Exit:
	ret
_bn_cmp_array endp

end