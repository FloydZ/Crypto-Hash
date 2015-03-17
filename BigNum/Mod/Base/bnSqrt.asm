.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code
;; X=X^^(1/2)

ABS_BN_LE_ONE macro bnreg:req
	exitm <>
endm 

bnSqrt proc uses edi esi ebx bnX:DWORD
	mov edi,bnX
	.if [edi].BN.bSigned
		mov eax,BNERR_SQRTNEG
		call _bn_error
		ret
	.elseif (([edi].BN.dwSize == 1) && ([edi].BN.dwArray[0] <= 1))
		ret
	.endif
	bnSCreateX edi,esi

	invoke bnBits,edi
	mov edi,esi
	mov ecx,eax
	bts [edi].BN.dwArray[0],eax; 2^n > N
	shr ecx,5
	inc ecx
	call _bn_normalize

	invoke bnInc,esi
	invoke bnBits,edi
	lea ecx,[eax+1]
	shr ecx,1
	invoke bnShl,esi,ecx
	.repeat
		invoke bnMov,edi,esi
		invoke bnDiv,bnX,edi,esi,0
		invoke bnAdd,esi,edi
		invoke bnShr1,esi
		invoke bnCmpAbs,edi,esi
	.until eax==1
	invoke bnMov,bnX,edi
	bnSDestroyX
	ret
bnSqrt endp


end
