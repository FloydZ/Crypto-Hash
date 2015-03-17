
.data?
SHA1HashBuf db 64 dup(?)
SHA1Len dd ?
SHA1Index dd ?
SHA1Digest dd 5 dup(?)
  
.code
SHA1F0 macro dwA, dwB, dwC, dwD, dwE, locX, constAC
	mov	edi, dwC
	xor	edi, dwD
	and	edi, dwB
	xor	edi, dwD
	lea	dwE, [dwE + constAC + edi]
	rol	dwB, 30
	mov	edi, dwA
	rol	edi, 05
	add	dwE, [locX]
	add	dwE, edi
ENDM

SHA1F1 macro dwA, dwB, dwC, dwD, dwE, locX, constAC
	mov	edi, dwC
	xor	edi, dwD
	xor	edi, dwB
	lea	dwE, [dwE + constAC + edi]
	rol	dwB, 30
	mov	edi, dwA
	rol	edi, 05
	add	dwE, [locX]
	add	dwE, edi
ENDM

SHA1F2	macro dwA, dwB, dwC, dwD, dwE, locX, constAC
	mov	edi,dwB
	or edi,dwC
	and edi,dwD
	mov ebp,edi
	mov	edi,dwB
	and edi,dwC
	or edi,ebp
	lea	dwE,[dwE + constAC + edi]
	rol	dwB,30
	mov	edi,dwA
	rol	edi,05
	add	dwE,[locX]
	add	dwE,edi
ENDM

SHA1F3 macro dwA, dwB, dwC, dwD, dwE, locX, constAC
	mov	edi,dwC
	xor	edi,dwD
	xor	edi,dwB
	lea	dwE,[dwE + constAC + edi]
	rol	dwB,30
	mov	edi,dwA
	rol	edi,05
	add	dwE,[locX]
	add	dwE,edi
endm

align dword
SHA1Transform proc
	pushad
	SHA1locals equ 80*4
	sub esp,SHA1locals
	SHA1W equ dword ptr [esp]
	mov edi,offset SHA1HashBuf
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
		mov SHA1W[ebx*4],eax
		mov SHA1W[ebx*4+4],ecx
		mov SHA1W[ebx*4+32],edx
		mov SHA1W[ebx*4+32+4],esi
		inc ebx
		inc ebx
	.until ebx==8
	shl ebx,1
	.repeat
		mov	eax,SHA1W[(4*ebx)-03*4]
		mov	edx,SHA1W[(4*ebx+4)-03*4]
		xor	eax,SHA1W[(4*ebx)-08*4]
		xor	edx,SHA1W[(4*ebx+4)-08*4]
		xor	eax,SHA1W[(4*ebx)-14*4]
		xor	edx,SHA1W[(4*ebx+4)-14*4]
		xor	eax,SHA1W[(4*ebx)-16*4]
		xor	edx,SHA1W[(4*ebx+4)-16*4]
		rol	eax,1
		mov	SHA1W[4*ebx],eax
		rol	edx,1
		mov	SHA1W[4*ebx+4],edx
		inc ebx
		inc ebx
	.until ebx==80
	mov edi,offset SHA1Digest
	mov eax,[edi+0*4]
	mov ebx,[edi+1*4]
	mov ecx,[edi+2*4]
	mov edx,[edi+3*4]
	mov esi,[edi+4*4]
	;========================================================
	SHA1F0 eax, ebx, ecx, edx, esi, SHA1W[00*4], 05a827999h
	SHA1F0 esi, eax, ebx, ecx, edx, SHA1W[01*4], 05a827999h
	SHA1F0 edx, esi, eax, ebx, ecx, SHA1W[02*4], 05a827999h
	SHA1F0 ecx, edx, esi, eax, ebx, SHA1W[03*4], 05a827999h
	SHA1F0 ebx, ecx, edx, esi, eax, SHA1W[04*4], 05a827999h
	SHA1F0 eax, ebx, ecx, edx, esi, SHA1W[05*4], 05a827999h
	SHA1F0 esi, eax, ebx, ecx, edx, SHA1W[06*4], 05a827999h
	SHA1F0 edx, esi, eax, ebx, ecx, SHA1W[07*4], 05a827999h
	SHA1F0 ecx, edx, esi, eax, ebx, SHA1W[08*4], 05a827999h
	SHA1F0 ebx, ecx, edx, esi, eax, SHA1W[09*4], 05a827999h
	SHA1F0 eax, ebx, ecx, edx, esi, SHA1W[10*4], 05a827999h
	SHA1F0 esi, eax, ebx, ecx, edx, SHA1W[11*4], 05a827999h
	SHA1F0 edx, esi, eax, ebx, ecx, SHA1W[12*4], 05a827999h
	SHA1F0 ecx, edx, esi, eax, ebx, SHA1W[13*4], 05a827999h
	SHA1F0 ebx, ecx, edx, esi, eax, SHA1W[14*4], 05a827999h
	SHA1F0 eax, ebx, ecx, edx, esi, SHA1W[15*4], 05a827999h
	SHA1F0 esi, eax, ebx, ecx, edx, SHA1W[16*4], 05a827999h
	SHA1F0 edx, esi, eax, ebx, ecx, SHA1W[17*4], 05a827999h
	SHA1F0 ecx, edx, esi, eax, ebx, SHA1W[18*4], 05a827999h
	SHA1F0 ebx, ecx, edx, esi, eax, SHA1W[19*4], 05a827999h
	;========================================================
	SHA1F1 eax, ebx, ecx, edx, esi, SHA1W[20*4], 06ed9eba1h
	SHA1F1 esi, eax, ebx, ecx, edx, SHA1W[21*4], 06ed9eba1h
	SHA1F1 edx, esi, eax, ebx, ecx, SHA1W[22*4], 06ed9eba1h
	SHA1F1 ecx, edx, esi, eax, ebx, SHA1W[23*4], 06ed9eba1h
	SHA1F1 ebx, ecx, edx, esi, eax, SHA1W[24*4], 06ed9eba1h
	SHA1F1 eax, ebx, ecx, edx, esi, SHA1W[25*4], 06ed9eba1h
	SHA1F1 esi, eax, ebx, ecx, edx, SHA1W[26*4], 06ed9eba1h
	SHA1F1 edx, esi, eax, ebx, ecx, SHA1W[27*4], 06ed9eba1h
	SHA1F1 ecx, edx, esi, eax, ebx, SHA1W[28*4], 06ed9eba1h
	SHA1F1 ebx, ecx, edx, esi, eax, SHA1W[29*4], 06ed9eba1h
	SHA1F1 eax, ebx, ecx, edx, esi, SHA1W[30*4], 06ed9eba1h
	SHA1F1 esi, eax, ebx, ecx, edx, SHA1W[31*4], 06ed9eba1h
	SHA1F1 edx, esi, eax, ebx, ecx, SHA1W[32*4], 06ed9eba1h
	SHA1F1 ecx, edx, esi, eax, ebx, SHA1W[33*4], 06ed9eba1h
	SHA1F1 ebx, ecx, edx, esi, eax, SHA1W[34*4], 06ed9eba1h
	SHA1F1 eax, ebx, ecx, edx, esi, SHA1W[35*4], 06ed9eba1h
	SHA1F1 esi, eax, ebx, ecx, edx, SHA1W[36*4], 06ed9eba1h
	SHA1F1 edx, esi, eax, ebx, ecx, SHA1W[37*4], 06ed9eba1h
	SHA1F1 ecx, edx, esi, eax, ebx, SHA1W[38*4], 06ed9eba1h
	SHA1F1 ebx, ecx, edx, esi, eax, SHA1W[39*4], 06ed9eba1h
	;========================================================
	SHA1F2 eax, ebx, ecx, edx, esi, SHA1W[40*4], 08f1bbcdch
	SHA1F2 esi, eax, ebx, ecx, edx, SHA1W[41*4], 08f1bbcdch
	SHA1F2 edx, esi, eax, ebx, ecx, SHA1W[42*4], 08f1bbcdch
	SHA1F2 ecx, edx, esi, eax, ebx, SHA1W[43*4], 08f1bbcdch
	SHA1F2 ebx, ecx, edx, esi, eax, SHA1W[44*4], 08f1bbcdch
	SHA1F2 eax, ebx, ecx, edx, esi, SHA1W[45*4], 08f1bbcdch
	SHA1F2 esi, eax, ebx, ecx, edx, SHA1W[46*4], 08f1bbcdch
	SHA1F2 edx, esi, eax, ebx, ecx, SHA1W[47*4], 08f1bbcdch
	SHA1F2 ecx, edx, esi, eax, ebx, SHA1W[48*4], 08f1bbcdch
	SHA1F2 ebx, ecx, edx, esi, eax, SHA1W[49*4], 08f1bbcdch
	SHA1F2 eax, ebx, ecx, edx, esi, SHA1W[50*4], 08f1bbcdch
	SHA1F2 esi, eax, ebx, ecx, edx, SHA1W[51*4], 08f1bbcdch
	SHA1F2 edx, esi, eax, ebx, ecx, SHA1W[52*4], 08f1bbcdch
	SHA1F2 ecx, edx, esi, eax, ebx, SHA1W[53*4], 08f1bbcdch
	SHA1F2 ebx, ecx, edx, esi, eax, SHA1W[54*4], 08f1bbcdch
	SHA1F2 eax, ebx, ecx, edx, esi, SHA1W[55*4], 08f1bbcdch
	SHA1F2 esi, eax, ebx, ecx, edx, SHA1W[56*4], 08f1bbcdch
	SHA1F2 edx, esi, eax, ebx, ecx, SHA1W[57*4], 08f1bbcdch
	SHA1F2 ecx, edx, esi, eax, ebx, SHA1W[58*4], 08f1bbcdch
	SHA1F2 ebx, ecx, edx, esi, eax, SHA1W[59*4], 08f1bbcdch
	;========================================================
	SHA1F3 eax, ebx, ecx, edx, esi, SHA1W[60*4], 0ca62c1d6h
	SHA1F3 esi, eax, ebx, ecx, edx, SHA1W[61*4], 0ca62c1d6h
	SHA1F3 edx, esi, eax, ebx, ecx, SHA1W[62*4], 0ca62c1d6h
	SHA1F3 ecx, edx, esi, eax, ebx, SHA1W[63*4], 0ca62c1d6h
	SHA1F3 ebx, ecx, edx, esi, eax, SHA1W[64*4], 0ca62c1d6h
	SHA1F3 eax, ebx, ecx, edx, esi, SHA1W[65*4], 0ca62c1d6h
	SHA1F3 esi, eax, ebx, ecx, edx, SHA1W[66*4], 0ca62c1d6h
	SHA1F3 edx, esi, eax, ebx, ecx, SHA1W[67*4], 0ca62c1d6h
	SHA1F3 ecx, edx, esi, eax, ebx, SHA1W[68*4], 0ca62c1d6h
	SHA1F3 ebx, ecx, edx, esi, eax, SHA1W[69*4], 0ca62c1d6h
	SHA1F3 eax, ebx, ecx, edx, esi, SHA1W[70*4], 0ca62c1d6h
	SHA1F3 esi, eax, ebx, ecx, edx, SHA1W[71*4], 0ca62c1d6h
	SHA1F3 edx, esi, eax, ebx, ecx, SHA1W[72*4], 0ca62c1d6h
	SHA1F3 ecx, edx, esi, eax, ebx, SHA1W[73*4], 0ca62c1d6h
	SHA1F3 ebx, ecx, edx, esi, eax, SHA1W[74*4], 0ca62c1d6h
	SHA1F3 eax, ebx, ecx, edx, esi, SHA1W[75*4], 0ca62c1d6h
	SHA1F3 esi, eax, ebx, ecx, edx, SHA1W[76*4], 0ca62c1d6h
	SHA1F3 edx, esi, eax, ebx, ecx, SHA1W[77*4], 0ca62c1d6h 
	SHA1F3 ecx, edx, esi, eax, ebx, SHA1W[78*4], 0ca62c1d6h
	SHA1F3 ebx, ecx, edx, esi, eax, SHA1W[79*4], 0ca62c1d6h
	;========================================================
	mov edi,offset SHA1Digest
	add [edi+0*4],eax
	add [edi+1*4],ebx
	add [edi+2*4],ecx
	add [edi+3*4],edx
	add [edi+4*4],esi
	add esp,SHA1locals
	popad
	ret
SHA1Transform endp

SHA1BURN macro
	xor eax,eax
	mov SHA1Index,eax
	mov edi,Offset SHA1HashBuf
	mov ecx,(sizeof SHA1HashBuf)/4
	rep stosd
endm

align dword
SHA1Init proc uses edi
	xor eax, eax
	mov SHA1Len,eax
	SHA1BURN
	mov eax,offset SHA1Digest
	mov dword ptr [eax+00],067452301h
	mov dword ptr [eax+04],0efcdab89h
	mov dword ptr [eax+08],098badcfeh
	mov dword ptr [eax+12],010325476h
	mov	dword ptr [eax+16],0c3d2e1f0h
	ret
SHA1Init endp

align dword
SHA1Update proc uses esi edi ebx lpBuffer:dword, dwBufLen:dword
	mov ebx,dwBufLen
	add SHA1Len,ebx
	.while ebx
		mov eax,SHA1Index
		mov edx,64
		sub edx,eax
		.if edx <= ebx
			lea edi, [SHA1HashBuf+eax]	
			mov esi, lpBuffer
			mov ecx, edx
			rep movsb
			sub ebx, edx
			add lpBuffer, edx
			call SHA1Transform
			SHA1BURN
		.else
			lea edi, [SHA1HashBuf+eax]	
			mov esi, lpBuffer
			mov ecx, ebx
			rep movsb
			mov eax, SHA1Index
			add eax, ebx
			mov SHA1Index,eax
			.break
		.endif
	.endw
	ret
SHA1Update endp

align dword
SHA1Final proc uses esi edi
	mov ecx, SHA1Index
	mov byte ptr [SHA1HashBuf+ecx],80h
	.if ecx >= 56
		call SHA1Transform
		SHA1BURN
	.endif
	mov eax,SHA1Len
	xor edx,edx
	shld edx,eax,3
	shl eax,3
	bswap edx; \
	bswap eax; /
	mov dword ptr [SHA1HashBuf+56],edx
	mov dword ptr [SHA1HashBuf+60],eax
	call SHA1Transform
	mov eax,offset SHA1Digest	
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
	bswap edx
	mov [eax+4*4],edx
	ret
SHA1Final endp

