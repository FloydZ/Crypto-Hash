.686
option casemap:none
include bnlib.inc
include bignum.inc

.code

bnDivpow2 proc bnX:DWORD,bitsY:DWORD,bnQuo:DWORD
	invoke bnMov,bnQuo,bnX
	invoke bnShr,bnQuo,bitsY
	ret
bnDivpow2 endp

bnModpow2 proc uses esi edi ebx bnX:DWORD,bitsY:DWORD,bnRem:DWORD
	mov eax,bnX
	mov edi,bnRem	
	invoke bnMov,edi,eax
	mov ebx,bitsY
	mov ecx,ebx
	shr ebx,5
	;jz @F
	and ecx,31
	mov edx,1
	mov esi,[edi].BN.dwSize
	shl edx,cl
	xor eax,eax
	dec edx
	inc ebx
	.repeat
		.if esi == ebx 
			and [edi].BN.dwArray[esi*4-4],edx
			.break
		.endif
		mov [edi].BN.dwArray[esi*4-4],eax
		dec esi
	.until zero?
;@@:	
	mov ecx,[edi].BN.dwSize
	call _bn_normalize
	ret
bnModpow2 endp


bnMontyModExp proc uses edi esi ebx bnX:DWORD, bnE:DWORD, bnN:DWORD, bnR:dword 
	LOCAL r,r1,n1,tmp,m1,x1,tmp2,tmp3
	LOCAL rbits:DWORD
	bnCreateX r,r1,n1,tmp,m1,x1,tmp2,tmp3
	invoke bnBits,bnN
	mov edi,r
	mov rbits,eax
	bts [edi].BN.dwArray[0],eax; 2^n > N
	mov ecx,eax
	shr ecx,5
	inc ecx
	call _bn_normalize
	invoke bnModInv,bnN,r,tmp; 
	invoke bnMov,n1,r
	invoke bnSub,n1,tmp;n1 = r - modinv(n,r)
	invoke bnMov,tmp,r
	invoke bnSub,tmp,bnN
	invoke bnModInv,tmp,bnN,r1; r1 = modinv(n-r)
	invoke bnMulpow2,bnX,rbits,tmp; x*r;		invoke bnMul,bnX,r,tmp
	invoke bnMod,tmp,bnN,m1; m1 = x*r mod n
	invoke bnMod,r,bnN,x1; x1 = 1*r mod n
	invoke bnMov,x1,r
	invoke bnSub,x1,bnN

	invoke bnBits,bnE
	lea ebx,[eax-1]
	.repeat
		mov esi,x1
		mov edi,x1
		call @@MonPro 
		mov eax,bnE
		bt [eax].BN.dwArray[0],ebx
		.if carry?
			mov esi,m1
			mov edi,x1
			call @@MonPro
		.endif
		dec ebx
	.until sign?
	;///////////////////////////////
	;call @@MonPro2;x1=m1*x1
;	invoke bnMul,x1,1,tmp; mul by 1
	invoke bnMul,x1,n1,tmp2
	invoke bnModpow2,tmp2,rbits,tmp		;invoke bnMod,tmp2,r,tmp
	invoke bnMul,tmp,bnN,tmp2
	invoke bnAdd,tmp2,x1
	invoke bnDivpow2,tmp2,rbits,x1		;invoke bnDiv,tmp2,r,x1,0
	invoke bnCmp,x1,bnN
	test eax,eax
	.if !sign?
		invoke bnSub,x1,bnN
	.endif
	invoke bnMov,bnR,x1
	bnDestroyX
	ret
;////////////////////////////////////////////////////////////
	ALIGN 8
@@MonPro:; 1) x1=x1*x1 2) x1=m1*x1
	invoke bnMul,esi,edi,tmp
	invoke bnMul,tmp,n1,tmp2
	invoke bnModpow2,tmp2,rbits,tmp3		;invoke bnMod,tmp2,r,tmp3
	invoke bnMul,tmp3,bnN,tmp2
	invoke bnAdd,tmp2,tmp
	invoke bnDivpow2,tmp2,rbits,edi		;invoke bnDiv,tmp2,r,edi,0
	invoke bnCmp,edi,bnN
	test eax,eax
	.if !sign?
		invoke bnSub,edi,bnN
	.endif
	retn
;////////////////////////////////////////////////////////////
	
bnMontyModExp endp

bnMulpow2 proc bnX:DWORD,bitsY:DWORD,bnProd:DWORD
	invoke bnMov,bnProd,bnX
	invoke bnShl,bnProd,bitsY
	ret
bnMulpow2 endp