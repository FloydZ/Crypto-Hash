.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

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

end