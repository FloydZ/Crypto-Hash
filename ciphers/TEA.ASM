; data   = 8 bytes (64-bit)
; keylen = 16 bytes (128-bit)
; rounds = 32


TEAInit	proto :DWORD
TEAEncrypt	proto :DWORD,:DWORD
TEADecrypt	proto :DWORD,:DWORD

TEA_ROUNDS equ 32
TEA_DELTA equ 9E3779B9h

.data?
TEA_KEY dd 4 dup(?)

.code

align dword
TEAInit proc pKey:DWORD
	mov eax,pKey
	mov ecx,[eax+0*4]
	mov edx,[eax+1*4]
	bswap ecx
	bswap edx
	mov [TEA_KEY+0*4],ecx
	mov [TEA_KEY+1*4],edx
	mov ecx,[eax+2*4]
	mov edx,[eax+3*4]
	bswap ecx
	bswap edx
	mov [TEA_KEY+2*4],ecx
	mov [TEA_KEY+3*4],edx
	ret
TEAInit endp

TEAROUND macro y,z,k,enc
	mov ecx,z
	shl ecx,4
	mov edi,z
	lea esi,[z+ebx]
	add ecx,[TEA_KEY+(k+0)*4]
	shr edi,5
	xor ecx,esi
	add edi,[TEA_KEY+(k+1)*4]
	xor ecx,edi
	if enc eq 1 
	add y,ecx
	else
	sub y,ecx
	endif
endm

align dword
TEAEncrypt proc uses edi esi ebx pBlockIn:DWORD,pBlockOut:DWORD
	mov esi,pBlockIn
	mov eax,[esi+0*4];y
	mov edx,[esi+1*4];z
	xor ebx,ebx
	bswap eax
	bswap edx
	.repeat
		add ebx,TEA_DELTA
		TEAROUND eax,edx,0,1
		TEAROUND edx,eax,2,1
		add ebx,TEA_DELTA
		TEAROUND eax,edx,0,1
		TEAROUND edx,eax,2,1
	.until ebx == TEA_DELTA*TEA_ROUNDS
	bswap eax
	bswap edx
	mov esi,pBlockOut
	mov [esi+0*4],eax
	mov [esi+1*4],edx
	ret
TEAEncrypt endp

align dword
TEADecrypt proc uses edi esi ebx pBlockIn:DWORD,pBlockOut:DWORD
	mov esi,pBlockIn
	mov eax,[esi+0*4]
	mov edx,[esi+1*4]
	
	;Bugfix by Floyd	
	mov ebx, TEA_DELTA
	imul ebx, ebx, TEA_ROUNDS
	
	;mov ebx,TEA_DELTA*TEA_ROUNDS
	
	bswap eax
	bswap edx
	.repeat
		TEAROUND edx,eax,2,0
		TEAROUND eax,edx,0,0
		sub ebx,TEA_DELTA
		TEAROUND edx,eax,2,0
		TEAROUND eax,edx,0,0
		sub ebx,TEA_DELTA
	.until zero?
	bswap eax
	bswap edx
	mov esi,pBlockOut
	mov [esi+0*4],eax
	mov [esi+1*4],edx
	ret
TEADecrypt endp

