; data   = 8 bytes (64-bit)
; keylen = 16 bytes (128-bit)
; rounds = 1..64 


XTEAInit	proto :DWORD,:DWORD
XTEAEncrypt	proto :DWORD,:DWORD
XTEADecrypt	proto :DWORD,:DWORD

.data
XTEA_DELTA equ 9E3779B9h
XTEA_ROUNDVAL dd 64*XTEA_DELTA

.data?
XTEA_KEY dd 4 dup(?)

.code

align dword
XTEAInit proc pKey:DWORD,dwRounds:DWORD
	mov eax,dwRounds
	mov ecx,XTEA_DELTA
	mul ecx
	mov XTEA_ROUNDVAL,eax
	mov eax,pKey
	mov ecx,[eax+0*4]
	mov edx,[eax+1*4]
	bswap ecx
	bswap edx
	mov [XTEA_KEY+0*4],ecx
	mov [XTEA_KEY+1*4],edx
	mov ecx,[eax+2*4]
	mov edx,[eax+3*4]
	bswap ecx
	bswap edx
	mov [XTEA_KEY+2*4],ecx
	mov [XTEA_KEY+3*4],edx
	ret
XTEAInit endp

XTEAROUND macro y,z,k,enc
	mov ecx,z
	mov edi,z
	shl ecx,4
	shr edi,5
	xor ecx,edi
	mov esi,ebx
	add ecx,z
	if k ne 0
	shr esi,11
	endif
	and esi,3
	mov esi,[XTEA_KEY+esi*4]
	add esi,ebx
	xor ecx,esi
	if enc eq 1 
	add y,ecx
	else
	sub y,ecx
	endif
endm

align dword
XTEAEncrypt proc uses edi esi ebx pBlockIn:DWORD,pBlockOut:DWORD
	mov esi,pBlockIn
	mov eax,[esi+0*4];y
	mov edx,[esi+1*4];z
	xor ebx,ebx
	bswap eax
	bswap edx
	.repeat
		XTEAROUND eax,edx,0,1
		add ebx,XTEA_DELTA
		XTEAROUND edx,eax,11,1
		XTEAROUND eax,edx,0,1
		add ebx,XTEA_DELTA
		XTEAROUND edx,eax,11,1
	.until ebx == XTEA_ROUNDVAL
	bswap eax
	bswap edx
	mov esi,pBlockOut
	mov [esi+0*4],eax
	mov [esi+1*4],edx
	ret
XTEAEncrypt endp

align dword
XTEADecrypt proc uses edi esi ebx pBlockIn:DWORD,pBlockOut:DWORD
	mov esi,pBlockIn
	mov eax,[esi+0*4]
	mov edx,[esi+1*4]
	mov ebx,XTEA_ROUNDVAL
	bswap eax
	bswap edx
	.repeat
		XTEAROUND edx,eax,11,0
		sub ebx,XTEA_DELTA
		XTEAROUND eax,edx,0,0
		XTEAROUND edx,eax,11,0
		sub ebx,XTEA_DELTA
		XTEAROUND eax,edx,0,0
	.until !ebx;zero?
	bswap eax
	bswap edx
	mov esi,pBlockOut
	mov [esi+0*4],eax
	mov [esi+1*4],edx
	ret
XTEADecrypt endp
