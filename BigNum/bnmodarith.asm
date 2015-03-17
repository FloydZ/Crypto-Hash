.686
option casemap:none
include bnlib.inc
include bignum.inc
.code

bnBinGCD proc uses ebx edi esi bnX:DWORD, bnY:DWORD, bnResult:DWORD
	bnCreateX esi,edi
	xor ebx,ebx; k=0
	invoke bnMov,esi,bnX;u=x
	invoke bnMov,edi,bnY;v=y
	.if !BN_IS_ODD(esi) && !BN_IS_ODD(edi)
		.repeat
			invoke bnShr1,esi
			invoke bnShr1,edi
			inc ebx
		.until (BN_IS_ODD(esi)) || (BN_IS_ODD(edi))
	.endif
	.while !BN_IS_ZERO(esi)
		.if !BN_IS_ODD(esi)
			invoke bnShr1,esi
		.elseif !BN_IS_ODD(edi)
			invoke bnShr1,edi
		.else
			invoke bnCmp,esi,edi
			test eax,eax
			.if sign?
				invoke bnSub,edi,esi
				invoke bnShr1,edi
			.else
				invoke bnSub,esi,edi
				invoke bnShr1,esi
			.endif
		.endif
	.endw
	invoke bnShl,edi,ebx
	invoke bnMov,bnResult,edi
	bnDestroyX
	ret
bnBinGCD endp

;
;	result=gcd(x,y)
;	greatest common divisor (x,y)
;	Modern Euclidean Algorithm 
;	
bnGCD proc uses ebx edi esi bnX:DWORD, bnY:DWORD, bnResult:DWORD
	bnCreateX edi,ebx,esi
	invoke bnMov,edi,bnX
	invoke bnMov,esi,bnY
	.while !BN_IS_ZERO(esi)
		invoke bnMod,edi,esi,ebx; ebx = edi % esi
		invoke bnMov,edi,esi    ; edi = esi
		invoke bnMov,esi,ebx    ; esi = ebx
	.endw
	invoke bnMov,bnResult,edi
	bnDestroyX
	ret
bnGCD endp

;
;	least common multiple
;

bnLCM proc uses edi esi bnX:DWORD, bnY:DWORD, bnR:DWORD
	bnCreateX edi,esi
	invoke bnGCD,bnX,bnY,edi
	invoke bnMul,bnX,bnY,esi
	invoke bnDiv,esi,edi,bnR,0
	bnDestroyX
	ret
bnLCM endp


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

bnModInv proc uses ebx edi esi bnX:DWORD, bnN:DWORD, bnR:DWORD
LOCAL t0,t1
;	invoke bnGCD,bnX,bnN,bnR
;	mov eax,bnR
;	.if BN_IS_ONE(eax);
	invoke bnCreatei,1
	mov t1,eax
	bnCreateX ebx,edi,esi,t0
	invoke bnMov,ebx,bnX
	invoke bnMov,esi,bnN
	.while 1
		.if ABS_BN_IS_ONE(ebx)
			invoke bnMov,bnR,t1
			.break
		.endif
		invoke bnDiv,esi,ebx,edi,esi
		invoke bnMul,edi,t1,bnR
		invoke bnAdd,t0,bnR
		.if ABS_BN_IS_ONE(esi)
			invoke bnMov,bnR,bnN
			invoke bnSub,bnR,t0 ; never <0
			.break
		.endif
		invoke bnDiv,ebx,esi,edi,ebx
		invoke bnMul,edi,t0,bnR
		invoke bnAdd,t1,bnR
	.endw   
	bnDestroyX
	invoke bnDestroy,t1
	ret
;	.endif 
;	invoke bnClear,bnR
;	ret
bnModInv endp

