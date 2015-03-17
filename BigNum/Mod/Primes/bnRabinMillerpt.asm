.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

bnRabinMillerpt proc uses esi edi ebx bn,iter
LOCAL b,z,w1,m
LOCAL a
	bnCreateX b,z,w1,m
;	int 1
	mov edi,bn
	mov esi,w1
	invoke bnMov,esi,edi
	invoke bnDec,esi
	mov ecx,[esi].BN.dwSize
	xor edx,edx
	.repeat 
		mov eax,[esi].BN.dwArray[edx*4]
		inc edx
		test eax,eax
		.if !zero?
			bsf ecx,eax
			.break
		.endif
		dec ecx
	.until zero?
	mov a,ecx
	invoke bnMov,m,esi
	invoke bnShr,m,a; w-1 / 2^a
	mov esi,z
	;---------------------------------------------------
	call _bn_dwrandomize
	.repeat
		mov ecx,100
		call _bn_dwrandom
		mov edx,b
		mov eax,[eax*4+BN_PHASE2PRIMES]
		mov [edx].BN.dwArray[0],eax
;		mov eax,[edi].BN.dwSize
;		shl eax,5
;		invoke bnRandom,b,eax
;		invoke bnShr1,b
;		mov eax,b
;		or [eax].BN.dwArray[0],1
		xor ebx,ebx; J = 0
		invoke bnModExp,b,m,edi,esi
		.repeat
			invoke bnCmpAbs,esi,w1
			.if ( ebx==0 && ABS_BN_IS_ONE(esi) ) || (eax==0)
				jmp @@Cont
			.endif
			inc ebx
			.if ( ebx>0 && ABS_BN_IS_ONE(esi) )
				jmp @@NotPrime
			.endif
			.if ebx<a
				invoke bnSquare,esi
				invoke bnMod,esi,edi,esi
			.endif
		.until ebx >= a
		jmp @@NotPrime
	@@Cont:	
		dec iter
	.until zero?
	bnDestroyX	
	mov eax,1;TRUE
	ret
@@NotPrime:		
	bnDestroyX
	xor eax,eax
	ret
bnRabinMillerpt endp

end
