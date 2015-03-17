.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

bnIsPrime proc bn
	mov eax,bn
	.if BN_IS_ODD(eax)
		invoke bnTrialDivpt,eax
		.if eax
			invoke bnFermatpt,bn
			.if eax
				invoke bnRabinMillerpt,bn,2
			.endif
		.endif
	.endif
	ret
bnIsPrime endp

end
