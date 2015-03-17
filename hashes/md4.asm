
.data?
MD4HashBuf db 64 dup(?)
MD4Len dd ?
MD4Index dd ?
MD4Digest dd 4 dup(?)

.code
MD4FF macro dwA, dwB, dwC, dwD, locX, rolS, constAC
	mov edi,dwC
	mov esi,[locX]
	xor edi,dwD
	and edi,dwB
	xor edi,dwD
	add dwA,esi
	add dwA,edi
	rol dwA,rolS
endm

MD4GG macro dwA, dwB, dwC, dwD, locX, rolS, constAC
	mov edi,dwC
	and edi,dwD
	mov esi,dwB
	and esi,dwC
	or edi,esi
	mov esi,dwB
	and esi,dwD
	or edi,esi
	mov esi,[locX]
	lea dwA,[esi+constAC+dwA]
	add dwA,edi
	rol dwA,rolS
endm

MD4HH macro dwA, dwB, dwC, dwD, locX, rolS, constAC
	mov edi,dwB
	mov esi,[locX]
	xor edi,dwC
	xor edi,dwD
	lea dwA,[esi+dwA+constAC]
	add dwA,edi
	rol dwA,rolS
endm

align dword
MD4Transform proc
	pushad
	mov esi,offset MD4Digest
	mov edi,offset MD4HashBuf	
	mov eax,[esi+0*4]
	mov ebx,[esi+1*4]
	mov ecx,[esi+2*4]
	mov edx,[esi+3*4]
	mov ebp,edi
	;==================================================
	MD4FF eax, ebx, ecx, edx, dword ptr [ebp+00*4], 03
	MD4FF edx, eax, ebx, ecx, dword ptr [ebp+01*4], 07
	MD4FF ecx, edx, eax, ebx, dword ptr [ebp+02*4], 11
	MD4FF ebx, ecx, edx, eax, dword ptr [ebp+03*4], 19
	MD4FF eax, ebx, ecx, edx, dword ptr [ebp+04*4], 03 
	MD4FF edx, eax, ebx, ecx, dword ptr [ebp+05*4], 07 
	MD4FF ecx, edx, eax, ebx, dword ptr [ebp+06*4], 11 
	MD4FF ebx, ecx, edx, eax, dword ptr [ebp+07*4], 19 
	MD4FF eax, ebx, ecx, edx, dword ptr [ebp+08*4], 03 
	MD4FF edx, eax, ebx, ecx, dword ptr [ebp+09*4], 07 
	MD4FF ecx, edx, eax, ebx, dword ptr [ebp+10*4], 11 
	MD4FF ebx, ecx, edx, eax, dword ptr [ebp+11*4], 19 
	MD4FF eax, ebx, ecx, edx, dword ptr [ebp+12*4], 03 
	MD4FF edx, eax, ebx, ecx, dword ptr [ebp+13*4], 07 
	MD4FF ecx, edx, eax, ebx, dword ptr [ebp+14*4], 11 
	MD4FF ebx, ecx, edx, eax, dword ptr [ebp+15*4], 19 
	;==================================================
	MD4GG eax, ebx, ecx, edx, dword ptr [ebp+00*4], 03, 05a827999h
	MD4GG edx, eax, ebx, ecx, dword ptr [ebp+04*4], 05, 05a827999h 
	MD4GG ecx, edx, eax, ebx, dword ptr [ebp+08*4], 09, 05a827999h 
	MD4GG ebx, ecx, edx, eax, dword ptr [ebp+12*4], 13, 05a827999h 
	MD4GG eax, ebx, ecx, edx, dword ptr [ebp+01*4], 03, 05a827999h
	MD4GG edx, eax, ebx, ecx, dword ptr [ebp+05*4], 05, 05a827999h
	MD4GG ecx, edx, eax, ebx, dword ptr [ebp+09*4], 09, 05a827999h
	MD4GG ebx, ecx, edx, eax, dword ptr [ebp+13*4], 13, 05a827999h
	MD4GG eax, ebx, ecx, edx, dword ptr [ebp+02*4], 03, 05a827999h
	MD4GG edx, eax, ebx, ecx, dword ptr [ebp+06*4], 05, 05a827999h
	MD4GG ecx, edx, eax, ebx, dword ptr [ebp+10*4], 09, 05a827999h
	MD4GG ebx, ecx, edx, eax, dword ptr [ebp+14*4], 13, 05a827999h
	MD4GG eax, ebx, ecx, edx, dword ptr [ebp+03*4], 03, 05a827999h
	MD4GG edx, eax, ebx, ecx, dword ptr [ebp+07*4], 05, 05a827999h
	MD4GG ecx, edx, eax, ebx, dword ptr [ebp+11*4], 09, 05a827999h
	MD4GG ebx, ecx, edx, eax, dword ptr [ebp+15*4], 13, 05a827999h
	;==============================================================
	MD4HH eax, ebx, ecx, edx, dword ptr [ebp+00*4], 03, 06ed9eba1h
	MD4HH edx, eax, ebx, ecx, dword ptr [ebp+08*4], 09, 06ed9eba1h
	MD4HH ecx, edx, eax, ebx, dword ptr [ebp+04*4], 11, 06ed9eba1h
	MD4HH ebx, ecx, edx, eax, dword ptr [ebp+12*4], 15, 06ed9eba1h
	MD4HH eax, ebx, ecx, edx, dword ptr [ebp+02*4], 03, 06ed9eba1h
	MD4HH edx, eax, ebx, ecx, dword ptr [ebp+10*4], 09, 06ed9eba1h
	MD4HH ecx, edx, eax, ebx, dword ptr [ebp+06*4], 11, 06ed9eba1h
	MD4HH ebx, ecx, edx, eax, dword ptr [ebp+14*4], 15, 06ed9eba1h
	MD4HH eax, ebx, ecx, edx, dword ptr [ebp+01*4], 03, 06ed9eba1h
	MD4HH edx, eax, ebx, ecx, dword ptr [ebp+09*4], 09, 06ed9eba1h
	MD4HH ecx, edx, eax, ebx, dword ptr [ebp+05*4], 11, 06ed9eba1h
	MD4HH ebx, ecx, edx, eax, dword ptr [ebp+13*4], 15, 06ed9eba1h
	MD4HH eax, ebx, ecx, edx, dword ptr [ebp+03*4], 03, 06ed9eba1h
	MD4HH edx, eax, ebx, ecx, dword ptr [ebp+11*4], 09, 06ed9eba1h
	MD4HH ecx, edx, eax, ebx, dword ptr [ebp+07*4], 11, 06ed9eba1h
	MD4HH ebx, ecx, edx, eax, dword ptr [ebp+15*4], 15, 06ed9eba1h
	;==============================================================
	mov esi,offset MD4Digest; update digest
	add [esi+0*4],eax
	add [esi+1*4],ebx
	add [esi+2*4],ecx
	add [esi+3*4],edx
	popad	
	ret
MD4Transform endp

MD4BURN macro
	xor eax,eax
	mov MD4Index,eax
	mov edi,Offset MD4HashBuf
	mov ecx,(sizeof MD4HashBuf)/4
	rep stosd
endm

align dword
MD4Init proc uses edi
	xor eax, eax
	mov MD4Len,eax
	MD4BURN
	mov eax,offset MD4Digest
	mov dword ptr [eax+0*4],067452301h
	mov dword ptr [eax+1*4],0EFCDAB89h
	mov dword ptr [eax+2*4],098BADCFEh
	mov dword ptr [eax+3*4],010325476h
	ret
MD4Init endp

align dword
MD4Update proc uses esi edi ebx lpBuffer:dword, dwBufLen:dword
	mov ebx,dwBufLen
	add MD4Len,ebx
	.while ebx
		mov eax,MD4Index
		mov edx,64
		sub edx,eax
		.if edx <= ebx
			lea edi, [MD4HashBuf+eax]	
			mov esi, lpBuffer
			mov ecx, edx
			rep movsb
			sub ebx, edx
			add lpBuffer, edx
			call MD4Transform
			MD4BURN
		.else
			lea edi, [MD4HashBuf+eax]	
			mov esi, lpBuffer
			mov ecx, ebx
			rep movsb
			mov eax, MD4Index
			add eax, ebx
			mov MD4Index,eax
			.break
		.endif
	.endw
	ret
MD4Update endp

align dword
MD4Final proc uses esi edi
	mov ecx, MD4Index
	mov byte ptr [MD4HashBuf+ecx],80h
	.if ecx >= 56
		call MD4Transform
		MD4BURN
	.endif
	mov eax,MD4Len
	xor edx,edx
	shld edx,eax,3
	shl eax,3
	mov dword ptr [MD4HashBuf+56],eax
	mov dword ptr [MD4HashBuf+60],edx
	call MD4Transform
	lea eax, MD4Digest	
	ret
MD4Final endp

