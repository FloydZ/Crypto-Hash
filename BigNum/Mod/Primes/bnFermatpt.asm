.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

bnFermatpt proc uses esi edi ebx bn:dword
LOCAL cnt
	xor ecx,ecx; FALSE
	push ecx
	mov cnt,ecx
	bnCreateX edi,esi,ebx; tmp's
	invoke bnMov,edi,bn
	invoke bnDec,edi
	; test a^(m-1) = 1 (mod m)
	mov eax,cnt
	.repeat
		movzx eax,[BN_FIRST13PRIMES+eax]
		mov [esi].BN.dwArray[0],eax
		invoke bnModExp,esi,edi,bn,ebx		
		.if !ABS_BN_IS_ONE(ebx)
			jmp @@NotPrime
		.endif
		mov eax,cnt
		inc eax
		mov cnt,eax 
	.until eax == BN_FIRST13PRIMES_SIZE
	inc dword ptr [esp];,TRUE
;	mov [esi].BN.dwArray[0],2
;	invoke bnModExp,esi,edi,bn,ebx
;	.if ABS_BN_IS_ONE(ebx)
;		mov [esi].BN.dwArray[0],3
;		invoke bnModExp,esi,edi,bn,ebx
;		.if ABS_BN_IS_ONE(ebx) 
;			mov [esi].BN.dwArray[0],5
;			invoke bnModExp,esi,edi,bn,ebx
;			.if ABS_BN_IS_ONE(ebx)
;				mov [esi].BN.dwArray[0],7
;				invoke bnModExp,esi,edi,bn,ebx
;				.if ABS_BN_IS_ONE(ebx)
;					mov dword ptr [esp],TRUE
;				.endif
;			.endif
;		.endif
;	.endif
@@NotPrime:
	bnDestroyX
	pop eax
	ret
bnFermatpt endp

end
