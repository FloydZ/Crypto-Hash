comment " data   = 12 bytes (96-bit) "
comment " keylen = 12 bytes (96-bit) "
comment " rounds = 11                "

.686
.model flat,stdcall
option casemap:none


ThreeWayInit    proto :DWORD
ThreeWayEncrypt proto :DWORD,:DWORD
ThreeWayDecrypt proto :DWORD,:DWORD

.data
THREEWAY_ROUNDS equ 11; number of rounds is 11
tw_k dd 3 dup(0)
tw_ki dd 3 dup(0)
tw_E_rc dd 00B0Bh,01616h,02C2Ch,05858h,0B0B0h,07171h,0E2E2h,0D5D5h,0BBBBh,06767h,0CECEh,08D8Dh
tw_D_rc dd 0B1B1h,07373h,0E6E6h,0DDDDh,0ABABh,04747h,08E8Eh,00D0Dh,01A1Ah,03434h,06868h,0D0D0h

.code
THREEWAY_SwapBits macro reg,trashreg
	mov trashreg,reg
	shr reg,1
	and trashreg,055555555h
	and reg,055555555h
	lea reg,[2*trashreg+reg]
	mov trashreg,reg
	shr reg,2
	and trashreg,033333333h
	and reg,033333333h
	lea reg,[4*trashreg+reg]
	mov trashreg,reg
	shr reg,4
	and trashreg,0F0F0F0Fh
	and reg,0F0F0F0Fh
	shl trashreg,4
	add reg,trashreg
	bswap reg
endm

THREEWAY_mu macro  a0_,a1_,a2_
	THREEWAY_SwapBits a0_,edx
	THREEWAY_SwapBits a1_,esi
	THREEWAY_SwapBits a2_,edi
	xchg a0_,a2_
endm

THREEWAY_theta macro a0_,a1_,a2_ 
	;-
	mov edx,a0_
	xor edx,a1_
	xor edx,a2_
	mov esi,edx
	rol edx,16
	rol esi,8
	xor esi,edx
	mov b2,esi
	;-
	shl a0_,24
	shr a2_,8
	shl a1_,8
	xor a0_,a2_
	xor a0_,a1_
	mov esi,a0
	shr esi,24
	xor esi,a0_
	mov b0,esi
	;-
	mov a0_,a0
	mov a1_,a1
	mov a2_,a2
	shl a1_,24
	shr a0_,8
	shl a2_,8
	xor a0_,a2_
	xor a0_,a1_
	mov esi,a1
	shr esi,24
	xor esi,a0_
	mov b1,esi
	;-
	mov esi,b2
	mov edx,b0
	xor edx,esi
	xor a0,edx
	;-
	mov edx,b1
	xor edx,esi
	xor a1,edx
	;-
	mov edx,b0
	shr edx,16
	mov a2_,b1
	shl a2_,16
	xor a2_,edx
	xor a2_,esi
	xor a2,a2_
	;-
endm

THREEWAY_pi_gamma_pi macro a0_,a1_,a2_
	rol a2_,1
	rol a0_,22
	mov b2,a2_
	mov b0,a0_
	not a2_
	or a2_,a1
	xor a2_,a0_
	rol a2_,1
	mov a0,a2_
	mov edx,a1
	not edx
	or edx,a0_
	xor edx,b2
	rol edx,22
	mov a2,edx
	mov esi,b0
	not esi
	or esi,b2
	xor a1,esi
endm

align dword
ThreeWayInit proc uses edi esi ebx pKey:dword
LOCAL a0,a1,a2
LOCAL b0,b1,b2
	mov esi,pKey
	mov eax,[esi+0*4]
	mov ebx,[esi+1*4]
	mov ecx,[esi+2*4]
	bswap eax
	bswap ebx
	bswap ecx
	mov [tw_k+0*4],eax
	mov [tw_k+1*4],ebx
	mov [tw_k+2*4],ecx
	mov a0,eax
	mov a1,ebx
	mov a2,ecx
	THREEWAY_theta eax,ebx,ecx
	mov eax,a0
	mov ebx,a1
	mov ecx,a2
    THREEWAY_mu eax,ebx,ecx
	mov [tw_ki+0*4],eax
	mov [tw_ki+1*4],ebx
	mov [tw_ki+2*4],ecx
    ret
ThreeWayInit endp

align dword
ThreeWayEncrypt proc uses edi esi ebx pBlockIn:DWORD,pBlockOut:DWORD
LOCAL a0,a1,a2
LOCAL b0,b1,b2
	mov esi,pBlockIn
	xor edi,edi
	mov eax,[esi+0*4]
	mov ebx,[esi+1*4]
	mov ecx,[esi+2*4]
	bswap eax
	bswap ebx
	bswap ecx
	.repeat
		mov edx,[tw_E_rc+edi*4]
		shl edx,16
		xor eax,[tw_k+0*4]
		xor ebx,[tw_k+1*4]
		xor ecx,[tw_k+2*4]
		xor eax,edx
		xor ecx,[tw_E_rc+edi*4]
		mov a0,eax
		mov a1,ebx
		mov a2,ecx
		; rho {
		THREEWAY_theta eax,ebx,ecx
		mov eax,a0
		mov ebx,a1
		mov ecx,a2
		.break .if edi == THREEWAY_ROUNDS
		THREEWAY_pi_gamma_pi eax,ebx,ecx
		mov eax,a0
		mov ebx,a1
		mov ecx,a2
		; }
		inc edi
	.until 0 
	mov esi,pBlockOut
	bswap eax
	bswap ebx
	bswap ecx
	mov [esi+0*4],eax
	mov [esi+1*4],ebx
	mov [esi+2*4],ecx
	ret
ThreeWayEncrypt endp

align dword
ThreeWayDecrypt proc uses edi esi ebx pBlockIn:DWORD,pBlockOut:DWORD
LOCAL a0,a1,a2
LOCAL b0,b1,b2
	mov esi,pBlockIn
	mov eax,[esi+0*4]
	mov ebx,[esi+1*4]
	mov ecx,[esi+2*4]
	bswap eax
	bswap ebx
	bswap ecx
	THREEWAY_mu eax,ebx,ecx
	xor edi,edi
	.repeat
		mov edx,[tw_D_rc+edi*4]
		shl edx,16
		xor eax,[tw_ki+0*4]
		xor ebx,[tw_ki+1*4]
		xor ecx,[tw_ki+2*4]
		xor eax,edx
		xor ecx,[tw_D_rc+edi*4]
		mov a0,eax
		mov a1,ebx
		mov a2,ecx
		THREEWAY_theta eax,ebx,ecx
		mov eax,a0
		mov ebx,a1
		mov ecx,a2
		THREEWAY_pi_gamma_pi eax,ebx,ecx
		mov eax,a0
		mov ebx,a1
		mov ecx,a2
		inc edi
	.until edi == THREEWAY_ROUNDS
	mov edx,[tw_D_rc+THREEWAY_ROUNDS*4]
	shl edx,16
	xor eax,[tw_ki+0*4]
	xor ebx,[tw_ki+1*4]
	xor ecx,[tw_ki+2*4]
	xor eax,edx
	xor ecx,[tw_D_rc+THREEWAY_ROUNDS*4]
	mov a0,eax
	mov a1,ebx
	mov a2,ecx
	THREEWAY_theta eax,ebx,ecx
	mov eax,a0
	mov ebx,a1
	mov ecx,a2
	THREEWAY_mu eax,ebx,ecx
	mov esi,pBlockOut
	bswap eax
	bswap ebx
	bswap ecx
	mov [esi+0*4],eax
	mov [esi+1*4],ebx
	mov [esi+2*4],ecx
	ret
ThreeWayDecrypt endp

end

