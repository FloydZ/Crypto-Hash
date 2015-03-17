.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

bnDec proc uses edi bn:DWORD
	mov edi,bn
	mov eax,1
	.if BN_IS_ZERO(edi)
		or [edi].BN.bSigned,1		
	.endif
	.if [edi].BN.bSigned
		call _bn_adddw_ignoresign
		ret
	.endif
	call _bn_subdw_ignoresign
	ret
bnDec endp 

end