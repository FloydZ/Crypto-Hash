.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

bnRsaGenPrime proc bn:dword, nbit:dword
	call _bn_dwrandomize
	invoke bnRandom,bn,nbit
;	int 1
	mov eax,bn
	mov ecx,[eax].BN.dwSize
	or [eax].BN.dwArray[000*4-0],00000000000000000000000000000001b
	or [eax].BN.dwArray[ecx*4-4],11000000000000000000000000000000b
	jmp @@Test
@@:	invoke bnAddDw,bn,2
	@@Test:
	invoke bnTrialDivpt,bn
	test eax,eax
	jz @B
;	invoke bnLehmanpt,bn
;	test eax,eax
;	jz @B
	invoke bnFermatpt,bn
	test eax,eax
	jz @B
	invoke bnRabinMillerpt,bn,1
	test eax,eax
	jz @B
;	invoke printbn,bn
	ret
bnRsaGenPrime endp

end
