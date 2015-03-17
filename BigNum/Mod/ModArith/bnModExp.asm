.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

;
;	EQUALS POWMOD
;	bnResult = bnX^bnExp mod bnModulus
;	

bnModExp proc uses ebx edi esi bnX:DWORD, bnExp:DWORD, bnModulus:DWORD, bnResult:DWORD
	mov eax,bnModulus
	.if ! BN_IS_ZERO(eax)
		.if BN_IS_ODD(eax)
			invoke bnMontyModExp,bnX,bnExp,bnModulus,bnResult; 18* faster
			ret
		.endif
		invoke bnCreatei,1
		mov esi,bnExp
		mov edi,eax
		.if ! BN_IS_ZERO(esi)
			invoke bnBits,esi
			lea ebx,[eax-1]
			jmp @F
			.repeat  
				invoke bnSquare,edi
				invoke bnMod,edi,bnModulus,edi
			@@:
				bt [esi].BN.dwArray[0],ebx
				.if CARRY?
					invoke bnMul,edi,bnX,edi
					invoke bnMod,edi,bnModulus,edi
				.endif
				dec ebx
			.until SIGN?
		.endif  
		xor eax,eax
		invoke bnMov,bnResult,edi
		invoke bnDestroy,edi
	.endif
	ret
bnModExp endp

end