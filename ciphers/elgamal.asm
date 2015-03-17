ELGAMALKeyGen PROTO keySize:DWORD, pKey:DWORD, g:DWORD, gg:DWORD, h:DWORD, n:DWORD
ELGAMALEncode PROTO pKey:DWORD, _n:DWORD, _m:DWORD, _c:DWORD
ELGAMALDecode PROTO e:DWORD, n:DWORD, _c:DWORD, m:DWORD

	
.data?
buffer db 1024 dup (?)

.code
;gg = Ordnung; g = erzeuger
ELGAMALKeyGen proc keySize:DWORD, pKey:DWORD, g:DWORD, gg:DWORD, h:DWORD, n:DWORD
	LOCAL p, q
	
	mov eax, keySize
	mov ecx, 2
	xor edx, edx
	div ecx
	
	invoke bnInit, eax
	
	invoke bnCreate
	mov p, eax
	
	invoke bnCreate
	mov q, eax
	
	invoke bnInit,keySize
	bnCreateX p ,q
	
	mov eax, keySize
	xor edx, edx
	mov ecx, 2
	div ecx
	invoke bnRsaGenPrime,p,eax

	mov eax, keySize
	xor edx, edx
	mov ecx, 2
	div ecx
	invoke bnRsaGenPrime,q,eax
	
	invoke bnMul,p,q,n
	
	invoke bnDec,p
	invoke bnDec,q
	invoke bnMul,p,q,gg
	
	;phi = Ordnung
	invoke bnDec,gg
	invoke bnBits, gg
	mov ecx, eax
Elgamal_KeyGen_loop:
	push ecx
	invoke bnRandom, pKey, ecx
	invoke bnMod, pKey, gg, pKey
	invoke bnGCD, pKey, gg, h						;h nur als zwischen speicher
	.if (BN_IS_ONE(h))
		pop ecx
		jmp Elgamal_KeyGen_end
	.endif
	pop ecx
	jmp Elgamal_KeyGen_loop
Elgamal_KeyGen_end:	
	invoke printbn,pKey
	invoke printbn,g
	invoke printbn,gg
	invoke printbn,h
	ret
ELGAMALKeyGen endp