
.data?
SHA256HashBuf db 64 dup(?)
SHA256Len dd ?
SHA256Index dd ?
SHA256Digest dd 8 dup(?)

.code
SHA256R macro A, B, C, D, E, F, G, H, locX, constAC
	mov edi,E
	mov ebp,edi
	ror edi,6
	mov esi,edi
	ror esi,5;11
	xor esi,edi
	rol ebp,32-25
	xor ebp,esi
    mov esi,F
    xor esi,G
    and esi,E
    xor esi,G
    add esi,ebp
    add esi,H
	add esi,constAC
    add esi,locX
    mov SHA256tmp,esi; T1
	mov edi,A
	mov ebp,edi
	ror edi,2
	mov esi,A
	ror esi,13
	xor edi,esi
	rol ebp,32-22
	xor ebp,edi 
	mov edi,A
	or edi,B
	and edi,C
	mov esi,A
	and esi,B
	or edi,esi
	add edi,ebp
	mov esi,SHA256tmp
	add edi,esi
	mov H,edi
	add D,esi
ENDM

align dword
SHA256Transform proc
	pushad
	SHA256locals equ 4*4+1*4+64*4
	sub esp,SHA256locals
	dwE equ dword ptr [esp+0*4]
	dwF equ dword ptr [esp+1*4]
	dwG equ dword ptr [esp+2*4]
	dwH equ dword ptr [esp+3*4]
	SHA256tmp equ dword ptr [esp+4*4]
	SHA256W equ dword ptr [esp+5*4]
	dwA equ eax
	dwB equ ebx
	dwC equ ecx
	dwD equ edx
	mov edi,offset SHA256HashBuf
	xor ebx,ebx
	.repeat
		mov eax,[edi+ebx*4]
		mov ecx,[edi+ebx*4+4]
		mov edx,[edi+ebx*4+32]
		mov esi,[edi+ebx*4+32+4]
		bswap eax
		bswap edx
		bswap ecx
		bswap esi
		mov SHA256W[ebx*4],eax
		mov SHA256W[ebx*4+4],ecx
		mov SHA256W[ebx*4+32],edx
		mov SHA256W[ebx*4+32+4],esi
		inc ebx
		inc ebx
	.until ebx==8
	shl ebx,1
	.repeat
		mov esi,SHA256W[4*ebx-02*4]
		mov ecx,esi
		ror ecx,17
		mov edx,esi
		ror edx,19
		xor edx,ecx
		shr esi,10
		xor esi,edx
		mov eax,SHA256W[4*ebx-15*4]
		mov ecx,eax
		ror ecx,07
		mov edx,eax
		ror edx,18
		xor edx,ecx
		shr eax,3
		add esi,SHA256W[4*ebx-07*4]
		xor eax,edx
		add eax,esi
		add eax,SHA256W[4*ebx-16*4]
		inc ebx
		mov SHA256W[4*ebx-4],eax
	.until ebx==64
	mov edi,offset SHA256Digest
	mov eax,[edi+7*4]
	mov ebx,[edi+6*4]
	mov ecx,[edi+5*4]
	mov edx,[edi+4*4]; e
	mov dwH,eax
	mov dwG,ebx
	mov dwF,ecx
	mov dwE,edx
	mov eax,[edi+0*4]
	mov ebx,[edi+1*4]
	mov ecx,[edi+2*4]
	mov edx,[edi+3*4]
	;==========================================================================
	SHA256R dwA, dwB, dwC, dwD, dwE, dwF, dwG, dwH, SHA256W[4*00], 0428A2F98h
	SHA256R dwH, dwA, dwB, dwC, dwD, dwE, dwF, dwG, SHA256W[4*01], 071374491h
	SHA256R dwG, dwH, dwA, dwB, dwC, dwD, dwE, dwF, SHA256W[4*02], 0B5C0FBCFh
	SHA256R dwF, dwG, dwH, dwA, dwB, dwC, dwD, dwE, SHA256W[4*03], 0E9B5DBA5h
	SHA256R dwE, dwF, dwG, dwH, dwA, dwB, dwC, dwD, SHA256W[4*04], 03956C25Bh
	SHA256R dwD, dwE, dwF, dwG, dwH, dwA, dwB, dwC, SHA256W[4*05], 059F111F1h
	SHA256R dwC, dwD, dwE, dwF, dwG, dwH, dwA, dwB, SHA256W[4*06], 0923F82A4h
	SHA256R dwB, dwC, dwD, dwE, dwF, dwG, dwH, dwA, SHA256W[4*07], 0AB1C5ED5h
	;==========================================================================
	SHA256R dwA, dwB, dwC, dwD, dwE, dwF, dwG, dwH, SHA256W[4*08], 0D807AA98h
	SHA256R dwH, dwA, dwB, dwC, dwD, dwE, dwF, dwG, SHA256W[4*09], 012835B01h
	SHA256R dwG, dwH, dwA, dwB, dwC, dwD, dwE, dwF, SHA256W[4*10], 0243185BEh
	SHA256R dwF, dwG, dwH, dwA, dwB, dwC, dwD, dwE, SHA256W[4*11], 0550C7DC3h
	SHA256R dwE, dwF, dwG, dwH, dwA, dwB, dwC, dwD, SHA256W[4*12], 072BE5D74h
	SHA256R dwD, dwE, dwF, dwG, dwH, dwA, dwB, dwC, SHA256W[4*13], 080DEB1FEh
	SHA256R dwC, dwD, dwE, dwF, dwG, dwH, dwA, dwB, SHA256W[4*14], 09BDC06A7h
	SHA256R dwB, dwC, dwD, dwE, dwF, dwG, dwH, dwA, SHA256W[4*15], 0C19BF174h
	;==========================================================================
	SHA256R dwA, dwB, dwC, dwD, dwE, dwF, dwG, dwH, SHA256W[4*16], 0E49B69C1h
	SHA256R dwH, dwA, dwB, dwC, dwD, dwE, dwF, dwG, SHA256W[4*17], 0EFBE4786h
	SHA256R dwG, dwH, dwA, dwB, dwC, dwD, dwE, dwF, SHA256W[4*18], 00FC19DC6h
	SHA256R dwF, dwG, dwH, dwA, dwB, dwC, dwD, dwE, SHA256W[4*19], 0240CA1CCh
	SHA256R dwE, dwF, dwG, dwH, dwA, dwB, dwC, dwD, SHA256W[4*20], 02DE92C6Fh
	SHA256R dwD, dwE, dwF, dwG, dwH, dwA, dwB, dwC, SHA256W[4*21], 04A7484AAh
	SHA256R dwC, dwD, dwE, dwF, dwG, dwH, dwA, dwB, SHA256W[4*22], 05CB0A9DCh
	SHA256R dwB, dwC, dwD, dwE, dwF, dwG, dwH, dwA, SHA256W[4*23], 076F988DAh
	;==========================================================================
	SHA256R dwA, dwB, dwC, dwD, dwE, dwF, dwG, dwH, SHA256W[4*24], 0983E5152h
	SHA256R dwH, dwA, dwB, dwC, dwD, dwE, dwF, dwG, SHA256W[4*25], 0A831C66Dh
	SHA256R dwG, dwH, dwA, dwB, dwC, dwD, dwE, dwF, SHA256W[4*26], 0B00327C8h
	SHA256R dwF, dwG, dwH, dwA, dwB, dwC, dwD, dwE, SHA256W[4*27], 0BF597FC7h
	SHA256R dwE, dwF, dwG, dwH, dwA, dwB, dwC, dwD, SHA256W[4*28], 0C6E00BF3h
	SHA256R dwD, dwE, dwF, dwG, dwH, dwA, dwB, dwC, SHA256W[4*29], 0D5A79147h
	SHA256R dwC, dwD, dwE, dwF, dwG, dwH, dwA, dwB, SHA256W[4*30], 006CA6351h
	SHA256R dwB, dwC, dwD, dwE, dwF, dwG, dwH, dwA, SHA256W[4*31], 014292967h
	;==========================================================================
	SHA256R dwA, dwB, dwC, dwD, dwE, dwF, dwG, dwH, SHA256W[4*32], 027B70A85h
	SHA256R dwH, dwA, dwB, dwC, dwD, dwE, dwF, dwG, SHA256W[4*33], 02E1B2138h
	SHA256R dwG, dwH, dwA, dwB, dwC, dwD, dwE, dwF, SHA256W[4*34], 04D2C6DFCh
	SHA256R dwF, dwG, dwH, dwA, dwB, dwC, dwD, dwE, SHA256W[4*35], 053380D13h
	SHA256R dwE, dwF, dwG, dwH, dwA, dwB, dwC, dwD, SHA256W[4*36], 0650A7354h
	SHA256R dwD, dwE, dwF, dwG, dwH, dwA, dwB, dwC, SHA256W[4*37], 0766A0ABBh
	SHA256R dwC, dwD, dwE, dwF, dwG, dwH, dwA, dwB, SHA256W[4*38], 081C2C92Eh
	SHA256R dwB, dwC, dwD, dwE, dwF, dwG, dwH, dwA, SHA256W[4*39], 092722C85h
	;==========================================================================
	SHA256R dwA, dwB, dwC, dwD, dwE, dwF, dwG, dwH, SHA256W[4*40], 0A2BFE8A1h
	SHA256R dwH, dwA, dwB, dwC, dwD, dwE, dwF, dwG, SHA256W[4*41], 0A81A664Bh
	SHA256R dwG, dwH, dwA, dwB, dwC, dwD, dwE, dwF, SHA256W[4*42], 0C24B8B70h
	SHA256R dwF, dwG, dwH, dwA, dwB, dwC, dwD, dwE, SHA256W[4*43], 0C76C51A3h
	SHA256R dwE, dwF, dwG, dwH, dwA, dwB, dwC, dwD, SHA256W[4*44], 0D192E819h
	SHA256R dwD, dwE, dwF, dwG, dwH, dwA, dwB, dwC, SHA256W[4*45], 0D6990624h
	SHA256R dwC, dwD, dwE, dwF, dwG, dwH, dwA, dwB, SHA256W[4*46], 0F40E3585h
	SHA256R dwB, dwC, dwD, dwE, dwF, dwG, dwH, dwA, SHA256W[4*47], 0106AA070h
	;==========================================================================
	SHA256R dwA, dwB, dwC, dwD, dwE, dwF, dwG, dwH, SHA256W[4*48], 019A4C116h
	SHA256R dwH, dwA, dwB, dwC, dwD, dwE, dwF, dwG, SHA256W[4*49], 01E376C08h
	SHA256R dwG, dwH, dwA, dwB, dwC, dwD, dwE, dwF, SHA256W[4*50], 02748774Ch
	SHA256R dwF, dwG, dwH, dwA, dwB, dwC, dwD, dwE, SHA256W[4*51], 034B0BCB5h
	SHA256R dwE, dwF, dwG, dwH, dwA, dwB, dwC, dwD, SHA256W[4*52], 0391C0CB3h
	SHA256R dwD, dwE, dwF, dwG, dwH, dwA, dwB, dwC, SHA256W[4*53], 04ED8AA4Ah
	SHA256R dwC, dwD, dwE, dwF, dwG, dwH, dwA, dwB, SHA256W[4*54], 05B9CCA4Fh
	SHA256R dwB, dwC, dwD, dwE, dwF, dwG, dwH, dwA, SHA256W[4*55], 0682E6FF3h
	;==========================================================================
	SHA256R dwA, dwB, dwC, dwD, dwE, dwF, dwG, dwH, SHA256W[4*56], 0748F82EEh
	SHA256R dwH, dwA, dwB, dwC, dwD, dwE, dwF, dwG, SHA256W[4*57], 078A5636Fh
	SHA256R dwG, dwH, dwA, dwB, dwC, dwD, dwE, dwF, SHA256W[4*58], 084C87814h
	SHA256R dwF, dwG, dwH, dwA, dwB, dwC, dwD, dwE, SHA256W[4*59], 08CC70208h
	SHA256R dwE, dwF, dwG, dwH, dwA, dwB, dwC, dwD, SHA256W[4*60], 090BEFFFAh
	SHA256R dwD, dwE, dwF, dwG, dwH, dwA, dwB, dwC, SHA256W[4*61], 0A4506CEBh
	SHA256R dwC, dwD, dwE, dwF, dwG, dwH, dwA, dwB, SHA256W[4*62], 0BEF9A3F7h
	SHA256R dwB, dwC, dwD, dwE, dwF, dwG, dwH, dwA, SHA256W[4*63], 0C67178F2h
	;==========================================================================
	mov edi,offset SHA256Digest
	add [edi+0*4],eax
	add [edi+1*4],ebx
	add [edi+2*4],ecx
	add [edi+3*4],edx
	mov eax,dwH
	mov ebx,dwG
	mov ecx,dwF
	mov edx,dwE
	add [edi+7*4],eax
	add [edi+6*4],ebx
	add [edi+5*4],ecx
	add [edi+4*4],edx
	add esp,SHA256locals
	popad
	ret
SHA256Transform endp

SHA256BURN macro
	xor eax,eax
	mov SHA256Index,eax
	mov edi,Offset SHA256HashBuf
	mov ecx,(sizeof SHA256HashBuf)/4
	rep stosd
endm

align dword
SHA256Init proc uses edi
	xor eax, eax
	mov SHA256Len,eax
	SHA256BURN
	mov eax,offset SHA256Digest
	mov	dword ptr [eax+0*4], 06a09e667h 
	mov	dword ptr [eax+1*4], 0bb67ae85h
	mov	dword ptr [eax+2*4], 03c6ef372h
	mov	dword ptr [eax+3*4], 0a54ff53ah
	mov	dword ptr [eax+4*4], 0510e527fh	
	mov	dword ptr [eax+5*4], 09b05688ch
	mov	dword ptr [eax+6*4], 01f83d9abh
	mov	dword ptr [eax+7*4], 05be0cd19h
	ret
SHA256Init endp

align dword
SHA256Update proc uses esi edi ebx lpBuffer:dword, dwBufLen:dword
	mov ebx,dwBufLen
	add SHA256Len,ebx
	.while ebx
		mov eax,SHA256Index
		mov edx,64
		sub edx,eax
		.if edx <= ebx
			lea edi, [SHA256HashBuf+eax]	
			mov esi, lpBuffer
			mov ecx, edx
			rep movsb
			sub ebx, edx
			add lpBuffer, edx
			call SHA256Transform
			SHA256BURN
		.else
			lea edi, [SHA256HashBuf+eax]	
			mov esi, lpBuffer
			mov ecx, ebx
			rep movsb
			mov eax, SHA256Index
			add eax, ebx
			mov SHA256Index,eax
			.break
		.endif
	.endw
	ret
SHA256Update endp

align dword
SHA256Final proc uses esi edi
	mov ecx, SHA256Index
	mov byte ptr [SHA256HashBuf+ecx],80h
	.if ecx >= 56
		call SHA256Transform
		SHA256BURN
	.endif
	mov eax,SHA256Len
	xor edx,edx
	shld edx,eax,3
	shl eax,3
	bswap edx; \
	bswap eax; /
	mov dword ptr [SHA256HashBuf+56],edx
	mov dword ptr [SHA256HashBuf+60],eax
	call SHA256Transform
	mov eax,offset SHA256Digest	
	mov edx,[eax+0*4]
	mov ecx,[eax+1*4]
	mov esi,[eax+2*4]
	mov edi,[eax+3*4]
	bswap edx
	bswap ecx
	bswap edi
	bswap esi
	mov [eax+0*4],edx
	mov [eax+1*4],ecx
	mov [eax+2*4],esi
	mov [eax+3*4],edi
	mov edx,[eax+4*4]
	mov ecx,[eax+5*4]
	mov esi,[eax+6*4]
	mov edi,[eax+7*4]
	bswap edx
	bswap ecx
	bswap edi
	bswap esi
	mov [eax+4*4],edx
	mov [eax+5*4],ecx
	mov [eax+6*4],esi
	mov [eax+7*4],edi
	ret
SHA256Final endp

