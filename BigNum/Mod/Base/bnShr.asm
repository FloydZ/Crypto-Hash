.686
.model flat,stdcall
option casemap:none
include .\bnlib.inc
include .\bignum.inc

.code

bnShr proc uses edi esi ebx bn:DWORD,sc:DWORD 
	mov edx,sc
	shr edx,5
	jnz @@Shr32
@@Shrle31:
	mov ecx,sc
	mov esi,bn
	and ecx,31
	jz @@Exit
	xor eax,eax
	mov ebx,[esi].BN.dwSize
	mov edx,[esi].BN.dwArray[0*4]
	shrd eax,edx,cl
	add esi,BN.dwArray
	mov edi,eax
	jmp @F
	.repeat
		mov eax,[esi+1*4]
		shrd edx,eax,cl
		mov [esi],edx
		mov edx,eax
		add esi,4
@@:		dec ebx
	.until zero?
	shr edx,cl
	mov eax,edi; preserved
	mov [esi],edx
	mov edi,bn
	mov ecx,[edi].BN.dwSize
	call _bn_normalize
@@Exit:
	ret
@@Shr32:	; do 32 bit shifts
	mov esi,bn
	mov ebx,[esi].BN.dwSize
	mov edi,esi
	.if (edx <= ebx) && !BN_IS_ZERO(esi)
		sub ebx,edx
		mov [edi].BN.dwSize,ebx
		lea esi,[esi].BN.dwArray[edx*4+4-4]
		add edi,BN.dwArray
		mov ecx,ebx
		rep movsd
		mov ecx,edx
		xor eax,eax
		rep stosd
		jmp @@Shrle31
	.endif
	invoke bnClear,bn
	xor eax,eax
	ret
bnShr endp

end
