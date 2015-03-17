.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

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

end
