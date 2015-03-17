.686
option casemap:none

.data?
SHA0HashBuf db 64 dup(?)
SHA0Len dd ?
SHA0Index dd ?
SHA0Digest dd 5 dup(?)
  
.code
SHA0F0 macro dwA, dwB, dwC, dwD, dwE, locX, constAC
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

SHA0F1 macro dwA, dwB, dwC, dwD, dwE, locX, constAC
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

SHA0F2	macro dwA, dwB, dwC, dwD, dwE, locX, constAC
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

SHA0F3 macro dwA, dwB, dwC, dwD, dwE, locX, constAC
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
SHA0Transform proc
	pushad
	SHA0locals equ 80*4
	sub esp,SHA0locals
	SHA0W equ dword ptr [esp]
	mov edi,offset SHA0HashBuf
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
		mov SHA0W[ebx*4],eax
		mov SHA0W[ebx*4+4],ecx
		mov SHA0W[ebx*4+32],edx
		mov SHA0W[ebx*4+32+4],esi
		inc ebx
		inc ebx
	.until ebx==8
	shl ebx,1
	.repeat
		mov	eax,SHA0W[(4*ebx)-03*4]
		mov	edx,SHA0W[(4*ebx+4)-03*4]
		xor	eax,SHA0W[(4*ebx)-08*4]
		xor	edx,SHA0W[(4*ebx+4)-08*4]
		xor	eax,SHA0W[(4*ebx)-14*4]
		xor	edx,SHA0W[(4*ebx+4)-14*4]
		xor	eax,SHA0W[(4*ebx)-16*4]
		xor	edx,SHA0W[(4*ebx+4)-16*4]
;		rol	eax,1
		mov	SHA0W[4*ebx],eax
;		rol	edx,1
		mov	SHA0W[4*ebx+4],edx
		inc ebx
		inc ebx
	.until ebx==80
	mov edi,offset SHA0Digest
	mov eax,[edi+0*4]
	mov ebx,[edi+1*4]
	mov ecx,[edi+2*4]
	mov edx,[edi+3*4]
	mov esi,[edi+4*4]
	;========================================================
	SHA0F0 eax, ebx, ecx, edx, esi, SHA0W[00*4], 05a827999h
	SHA0F0 esi, eax, ebx, ecx, edx, SHA0W[01*4], 05a827999h
	SHA0F0 edx, esi, eax, ebx, ecx, SHA0W[02*4], 05a827999h
	SHA0F0 ecx, edx, esi, eax, ebx, SHA0W[03*4], 05a827999h
	SHA0F0 ebx, ecx, edx, esi, eax, SHA0W[04*4], 05a827999h
	SHA0F0 eax, ebx, ecx, edx, esi, SHA0W[05*4], 05a827999h
	SHA0F0 esi, eax, ebx, ecx, edx, SHA0W[06*4], 05a827999h
	SHA0F0 edx, esi, eax, ebx, ecx, SHA0W[07*4], 05a827999h
	SHA0F0 ecx, edx, esi, eax, ebx, SHA0W[08*4], 05a827999h
	SHA0F0 ebx, ecx, edx, esi, eax, SHA0W[09*4], 05a827999h
	SHA0F0 eax, ebx, ecx, edx, esi, SHA0W[10*4], 05a827999h
	SHA0F0 esi, eax, ebx, ecx, edx, SHA0W[11*4], 05a827999h
	SHA0F0 edx, esi, eax, ebx, ecx, SHA0W[12*4], 05a827999h
	SHA0F0 ecx, edx, esi, eax, ebx, SHA0W[13*4], 05a827999h
	SHA0F0 ebx, ecx, edx, esi, eax, SHA0W[14*4], 05a827999h
	SHA0F0 eax, ebx, ecx, edx, esi, SHA0W[15*4], 05a827999h
	SHA0F0 esi, eax, ebx, ecx, edx, SHA0W[16*4], 05a827999h
	SHA0F0 edx, esi, eax, ebx, ecx, SHA0W[17*4], 05a827999h
	SHA0F0 ecx, edx, esi, eax, ebx, SHA0W[18*4], 05a827999h
	SHA0F0 ebx, ecx, edx, esi, eax, SHA0W[19*4], 05a827999h
	;========================================================
	SHA0F1 eax, ebx, ecx, edx, esi, SHA0W[20*4], 06ed9eba1h
	SHA0F1 esi, eax, ebx, ecx, edx, SHA0W[21*4], 06ed9eba1h
	SHA0F1 edx, esi, eax, ebx, ecx, SHA0W[22*4], 06ed9eba1h
	SHA0F1 ecx, edx, esi, eax, ebx, SHA0W[23*4], 06ed9eba1h
	SHA0F1 ebx, ecx, edx, esi, eax, SHA0W[24*4], 06ed9eba1h
	SHA0F1 eax, ebx, ecx, edx, esi, SHA0W[25*4], 06ed9eba1h
	SHA0F1 esi, eax, ebx, ecx, edx, SHA0W[26*4], 06ed9eba1h
	SHA0F1 edx, esi, eax, ebx, ecx, SHA0W[27*4], 06ed9eba1h
	SHA0F1 ecx, edx, esi, eax, ebx, SHA0W[28*4], 06ed9eba1h
	SHA0F1 ebx, ecx, edx, esi, eax, SHA0W[29*4], 06ed9eba1h
	SHA0F1 eax, ebx, ecx, edx, esi, SHA0W[30*4], 06ed9eba1h
	SHA0F1 esi, eax, ebx, ecx, edx, SHA0W[31*4], 06ed9eba1h
	SHA0F1 edx, esi, eax, ebx, ecx, SHA0W[32*4], 06ed9eba1h
	SHA0F1 ecx, edx, esi, eax, ebx, SHA0W[33*4], 06ed9eba1h
	SHA0F1 ebx, ecx, edx, esi, eax, SHA0W[34*4], 06ed9eba1h
	SHA0F1 eax, ebx, ecx, edx, esi, SHA0W[35*4], 06ed9eba1h
	SHA0F1 esi, eax, ebx, ecx, edx, SHA0W[36*4], 06ed9eba1h
	SHA0F1 edx, esi, eax, ebx, ecx, SHA0W[37*4], 06ed9eba1h
	SHA0F1 ecx, edx, esi, eax, ebx, SHA0W[38*4], 06ed9eba1h
	SHA0F1 ebx, ecx, edx, esi, eax, SHA0W[39*4], 06ed9eba1h
	;========================================================
	SHA0F2 eax, ebx, ecx, edx, esi, SHA0W[40*4], 08f1bbcdch
	SHA0F2 esi, eax, ebx, ecx, edx, SHA0W[41*4], 08f1bbcdch
	SHA0F2 edx, esi, eax, ebx, ecx, SHA0W[42*4], 08f1bbcdch
	SHA0F2 ecx, edx, esi, eax, ebx, SHA0W[43*4], 08f1bbcdch
	SHA0F2 ebx, ecx, edx, esi, eax, SHA0W[44*4], 08f1bbcdch
	SHA0F2 eax, ebx, ecx, edx, esi, SHA0W[45*4], 08f1bbcdch
	SHA0F2 esi, eax, ebx, ecx, edx, SHA0W[46*4], 08f1bbcdch
	SHA0F2 edx, esi, eax, ebx, ecx, SHA0W[47*4], 08f1bbcdch
	SHA0F2 ecx, edx, esi, eax, ebx, SHA0W[48*4], 08f1bbcdch
	SHA0F2 ebx, ecx, edx, esi, eax, SHA0W[49*4], 08f1bbcdch
	SHA0F2 eax, ebx, ecx, edx, esi, SHA0W[50*4], 08f1bbcdch
	SHA0F2 esi, eax, ebx, ecx, edx, SHA0W[51*4], 08f1bbcdch
	SHA0F2 edx, esi, eax, ebx, ecx, SHA0W[52*4], 08f1bbcdch
	SHA0F2 ecx, edx, esi, eax, ebx, SHA0W[53*4], 08f1bbcdch
	SHA0F2 ebx, ecx, edx, esi, eax, SHA0W[54*4], 08f1bbcdch
	SHA0F2 eax, ebx, ecx, edx, esi, SHA0W[55*4], 08f1bbcdch
	SHA0F2 esi, eax, ebx, ecx, edx, SHA0W[56*4], 08f1bbcdch
	SHA0F2 edx, esi, eax, ebx, ecx, SHA0W[57*4], 08f1bbcdch
	SHA0F2 ecx, edx, esi, eax, ebx, SHA0W[58*4], 08f1bbcdch
	SHA0F2 ebx, ecx, edx, esi, eax, SHA0W[59*4], 08f1bbcdch
	;========================================================
	SHA0F3 eax, ebx, ecx, edx, esi, SHA0W[60*4], 0ca62c1d6h
	SHA0F3 esi, eax, ebx, ecx, edx, SHA0W[61*4], 0ca62c1d6h
	SHA0F3 edx, esi, eax, ebx, ecx, SHA0W[62*4], 0ca62c1d6h
	SHA0F3 ecx, edx, esi, eax, ebx, SHA0W[63*4], 0ca62c1d6h
	SHA0F3 ebx, ecx, edx, esi, eax, SHA0W[64*4], 0ca62c1d6h
	SHA0F3 eax, ebx, ecx, edx, esi, SHA0W[65*4], 0ca62c1d6h
	SHA0F3 esi, eax, ebx, ecx, edx, SHA0W[66*4], 0ca62c1d6h
	SHA0F3 edx, esi, eax, ebx, ecx, SHA0W[67*4], 0ca62c1d6h
	SHA0F3 ecx, edx, esi, eax, ebx, SHA0W[68*4], 0ca62c1d6h
	SHA0F3 ebx, ecx, edx, esi, eax, SHA0W[69*4], 0ca62c1d6h
	SHA0F3 eax, ebx, ecx, edx, esi, SHA0W[70*4], 0ca62c1d6h
	SHA0F3 esi, eax, ebx, ecx, edx, SHA0W[71*4], 0ca62c1d6h
	SHA0F3 edx, esi, eax, ebx, ecx, SHA0W[72*4], 0ca62c1d6h
	SHA0F3 ecx, edx, esi, eax, ebx, SHA0W[73*4], 0ca62c1d6h
	SHA0F3 ebx, ecx, edx, esi, eax, SHA0W[74*4], 0ca62c1d6h
	SHA0F3 eax, ebx, ecx, edx, esi, SHA0W[75*4], 0ca62c1d6h
	SHA0F3 esi, eax, ebx, ecx, edx, SHA0W[76*4], 0ca62c1d6h
	SHA0F3 edx, esi, eax, ebx, ecx, SHA0W[77*4], 0ca62c1d6h 
	SHA0F3 ecx, edx, esi, eax, ebx, SHA0W[78*4], 0ca62c1d6h
	SHA0F3 ebx, ecx, edx, esi, eax, SHA0W[79*4], 0ca62c1d6h
	;========================================================
	mov edi,offset SHA0Digest
	add [edi+0*4],eax
	add [edi+1*4],ebx
	add [edi+2*4],ecx
	add [edi+3*4],edx
	add [edi+4*4],esi
	add esp,SHA0locals
	popad
	ret
SHA0Transform endp

SHA0BURN macro
	xor eax,eax
	mov SHA0Index,eax
	mov edi,Offset SHA0HashBuf
	mov ecx,(sizeof SHA0HashBuf)/4
	rep stosd
endm

align dword
SHA0Init proc uses edi
	xor eax, eax
	mov SHA0Len,eax
	SHA0BURN
	mov eax,offset SHA0Digest
	mov dword ptr [eax+00],067452301h
	mov dword ptr [eax+04],0efcdab89h
	mov dword ptr [eax+08],098badcfeh
	mov dword ptr [eax+12],010325476h
	mov	dword ptr [eax+16],0c3d2e1f0h
	ret
SHA0Init endp

align dword
SHA0Update proc uses esi edi ebx lpBuffer:dword, dwBufLen:dword
	mov ebx,dwBufLen
	add SHA0Len,ebx
	.while ebx
		mov eax,SHA0Index
		mov edx,64
		sub edx,eax
		.if edx <= ebx
			lea edi, [SHA0HashBuf+eax]	
			mov esi, lpBuffer
			mov ecx, edx
			rep movsb
			sub ebx, edx
			add lpBuffer, edx
			call SHA0Transform
			SHA0BURN
		.else
			lea edi, [SHA0HashBuf+eax]	
			mov esi, lpBuffer
			mov ecx, ebx
			rep movsb
			mov eax, SHA0Index
			add eax, ebx
			mov SHA0Index,eax
			.break
		.endif
	.endw
	ret
SHA0Update endp

align dword
SHA0Final proc uses esi edi
	mov ecx, SHA0Index
	mov byte ptr [SHA0HashBuf+ecx],80h
	.if ecx >= 56
		call SHA0Transform
		SHA0BURN
	.endif
	mov eax,SHA0Len
	xor edx,edx
	shld edx,eax,3
	shl eax,3
	bswap edx; \
	bswap eax; /
	mov dword ptr [SHA0HashBuf+56],edx
	mov dword ptr [SHA0HashBuf+60],eax
	call SHA0Transform
	mov eax,offset SHA0Digest
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
SHA0Final endp

