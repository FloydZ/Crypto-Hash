.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

bnInc proc uses edi bn:DWORD
	mov edi,bn
	mov eax,1
	.if [edi].BN.bSigned
		.if ABS_BN_IS_ONE(edi) 
			and [edi].BN.bSigned,0
		.endif
		call _bn_subdw_ignoresign
		ret
	.endif
	call _bn_adddw_ignoresign
	ret
bnInc endp

end
