
.const
pushad_size equ 8*4
pushad_eax equ 7*4
pushad_ecx equ 6*4
pushad_edx equ 5*4
pushad_ebx equ 4*4
pushad_esp equ 3*4
pushad_ebp equ 2*4
pushad_esi equ 1*4
pushad_edi equ 0*4


.data?
RMD128HashBuf db 64 dup(?)
RMD128Len dd ?
RMD128Index dd ?
RMD128Digest dd 4 dup(?)

.code
RMD128FF macro dwA, dwB, dwC, dwD, locX, rolS
	mov edi,dwB
    xor edi,dwC
    xor edi,dwD
    add dwA,locX
    add dwA,edi
	rol dwA,rolS
endm
RMD128GG macro dwA, dwB, dwC, dwD, locX, rolS, constAC
	mov	edi,dwC
	xor	edi,dwD
	and	edi,dwB
	xor	edi,dwD
	add	dwA,[locX]
	lea	dwA,[dwA+edi+constAC]
	rol	dwA,rolS
ENDM
RMD128HH macro dwA, dwB, dwC, dwD, locX, rolS, constAC
	mov edi,dwC
	xor edi,-1
	or edi,dwB
	xor edi,dwD
	add dwA,[locX]
	lea dwA,[dwA+edi+constAC]
	rol dwA,rolS
endm
RMD128II macro dwA, dwB, dwC, dwD, locX, rolS, constAC
	mov	edi,dwC
	xor	edi,dwB
	and	edi,dwD
	xor	edi,dwC
	add	dwA,[locX]
	lea	dwA,[dwA+edi+constAC]
	rol	dwA,rolS
endm

align dword
RMD128Transform proc
	pushad
	mov esi,offset RMD128Digest
	mov ebp,offset RMD128HashBuf
	mov eax,[esi+0*4]
	mov ebx,[esi+1*4]
	mov ecx,[esi+2*4]
	mov edx,[esi+3*4]
	;=====================================================
	RMD128FF eax, ebx, ecx, edx, dword ptr [ebp+ 0*4], 11
	RMD128FF edx, eax, ebx, ecx, dword ptr [ebp+ 1*4], 14
	RMD128FF ecx, edx, eax, ebx, dword ptr [ebp+ 2*4], 15
	RMD128FF ebx, ecx, edx, eax, dword ptr [ebp+ 3*4], 12
	RMD128FF eax, ebx, ecx, edx, dword ptr [ebp+ 4*4],  5
	RMD128FF edx, eax, ebx, ecx, dword ptr [ebp+ 5*4],  8
	RMD128FF ecx, edx, eax, ebx, dword ptr [ebp+ 6*4],  7
	RMD128FF ebx, ecx, edx, eax, dword ptr [ebp+ 7*4],  9
	RMD128FF eax, ebx, ecx, edx, dword ptr [ebp+ 8*4], 11
	RMD128FF edx, eax, ebx, ecx, dword ptr [ebp+ 9*4], 13
	RMD128FF ecx, edx, eax, ebx, dword ptr [ebp+10*4], 14
	RMD128FF ebx, ecx, edx, eax, dword ptr [ebp+11*4], 15
	RMD128FF eax, ebx, ecx, edx, dword ptr [ebp+12*4],  6
	RMD128FF edx, eax, ebx, ecx, dword ptr [ebp+13*4],  7
	RMD128FF ecx, edx, eax, ebx, dword ptr [ebp+14*4],  9
	RMD128FF ebx, ecx, edx, eax, dword ptr [ebp+15*4],  8
	;=================================================================
	RMD128GG eax, ebx, ecx, edx, dword ptr [ebp+ 7*4],  7, 05A827999h 
	RMD128GG edx, eax, ebx, ecx, dword ptr [ebp+ 4*4],  6, 05A827999h 
	RMD128GG ecx, edx, eax, ebx, dword ptr [ebp+13*4],  8, 05A827999h 
	RMD128GG ebx, ecx, edx, eax, dword ptr [ebp+ 1*4], 13, 05A827999h 
	RMD128GG eax, ebx, ecx, edx, dword ptr [ebp+10*4], 11, 05A827999h 
	RMD128GG edx, eax, ebx, ecx, dword ptr [ebp+ 6*4],  9, 05A827999h 
	RMD128GG ecx, edx, eax, ebx, dword ptr [ebp+15*4],  7, 05A827999h 
	RMD128GG ebx, ecx, edx, eax, dword ptr [ebp+ 3*4], 15, 05A827999h 
	RMD128GG eax, ebx, ecx, edx, dword ptr [ebp+12*4],  7, 05A827999h 
	RMD128GG edx, eax, ebx, ecx, dword ptr [ebp+ 0*4], 12, 05A827999h 
	RMD128GG ecx, edx, eax, ebx, dword ptr [ebp+ 9*4], 15, 05A827999h 
	RMD128GG ebx, ecx, edx, eax, dword ptr [ebp+ 5*4],  9, 05A827999h 
	RMD128GG eax, ebx, ecx, edx, dword ptr [ebp+ 2*4], 11, 05A827999h 
	RMD128GG edx, eax, ebx, ecx, dword ptr [ebp+14*4],  7, 05A827999h 
	RMD128GG ecx, edx, eax, ebx, dword ptr [ebp+11*4], 13, 05A827999h 
	RMD128GG ebx, ecx, edx, eax, dword ptr [ebp+ 8*4], 12, 05A827999h
	;=================================================================
	RMD128HH eax, ebx, ecx, edx, dword ptr [ebp+ 3*4], 11, 06ED9EBA1h
	RMD128HH edx, eax, ebx, ecx, dword ptr [ebp+10*4], 13, 06ED9EBA1h 
	RMD128HH ecx, edx, eax, ebx, dword ptr [ebp+14*4],  6, 06ED9EBA1h 
	RMD128HH ebx, ecx, edx, eax, dword ptr [ebp+ 4*4],  7, 06ED9EBA1h
	RMD128HH eax, ebx, ecx, edx, dword ptr [ebp+ 9*4], 14, 06ED9EBA1h  
	RMD128HH edx, eax, ebx, ecx, dword ptr [ebp+15*4],  9, 06ED9EBA1h
	RMD128HH ecx, edx, eax, ebx, dword ptr [ebp+ 8*4], 13, 06ED9EBA1h
	RMD128HH ebx, ecx, edx, eax, dword ptr [ebp+ 1*4], 15, 06ED9EBA1h
	RMD128HH eax, ebx, ecx, edx, dword ptr [ebp+ 2*4], 14, 06ED9EBA1h
	RMD128HH edx, eax, ebx, ecx, dword ptr [ebp+ 7*4],  8, 06ED9EBA1h
	RMD128HH ecx, edx, eax, ebx, dword ptr [ebp+ 0*4], 13, 06ED9EBA1h
	RMD128HH ebx, ecx, edx, eax, dword ptr [ebp+ 6*4],  6, 06ED9EBA1h
	RMD128HH eax, ebx, ecx, edx, dword ptr [ebp+13*4],  5, 06ED9EBA1h
	RMD128HH edx, eax, ebx, ecx, dword ptr [ebp+11*4], 12, 06ED9EBA1h
	RMD128HH ecx, edx, eax, ebx, dword ptr [ebp+ 5*4],  7, 06ED9EBA1h
	RMD128HH ebx, ecx, edx, eax, dword ptr [ebp+12*4],  5, 06ED9EBA1h
	;=================================================================
 	RMD128II eax, ebx, ecx, edx, dword ptr [ebp+ 1*4], 11, 08F1BBCDCh
	RMD128II edx, eax, ebx, ecx, dword ptr [ebp+ 9*4], 12, 08F1BBCDCh
	RMD128II ecx, edx, eax, ebx, dword ptr [ebp+11*4], 14, 08F1BBCDCh
	RMD128II ebx, ecx, edx, eax, dword ptr [ebp+10*4], 15, 08F1BBCDCh
	RMD128II eax, ebx, ecx, edx, dword ptr [ebp+ 0*4], 14, 08F1BBCDCh
	RMD128II edx, eax, ebx, ecx, dword ptr [ebp+ 8*4], 15, 08F1BBCDCh
	RMD128II ecx, edx, eax, ebx, dword ptr [ebp+12*4],  9, 08F1BBCDCh
	RMD128II ebx, ecx, edx, eax, dword ptr [ebp+ 4*4],  8, 08F1BBCDCh
	RMD128II eax, ebx, ecx, edx, dword ptr [ebp+13*4],  9, 08F1BBCDCh
	RMD128II edx, eax, ebx, ecx, dword ptr [ebp+ 3*4], 14, 08F1BBCDCh
	RMD128II ecx, edx, eax, ebx, dword ptr [ebp+ 7*4],  5, 08F1BBCDCh
	RMD128II ebx, ecx, edx, eax, dword ptr [ebp+15*4],  6, 08F1BBCDCh
	RMD128II eax, ebx, ecx, edx, dword ptr [ebp+14*4],  8, 08F1BBCDCh
	RMD128II edx, eax, ebx, ecx, dword ptr [ebp+ 5*4],  6, 08F1BBCDCh
	RMD128II ecx, edx, eax, ebx, dword ptr [ebp+ 6*4],  5, 08F1BBCDCh
	RMD128II ebx, ecx, edx, eax, dword ptr [ebp+ 2*4], 12, 08F1BBCDCh
	;=================================================================
	pushad;  parallel
	mov eax,[esi+0*4]
	mov ebx,[esi+1*4]
	mov ecx,[esi+2*4]
	mov edx,[esi+3*4]
	;=================================================================
	RMD128II eax, ebx, ecx, edx, dword ptr [ebp+ 5*4],  8, 050A28BE6h
	RMD128II edx, eax, ebx, ecx, dword ptr [ebp+14*4],  9, 050A28BE6h
	RMD128II ecx, edx, eax, ebx, dword ptr [ebp+ 7*4],  9, 050A28BE6h
	RMD128II ebx, ecx, edx, eax, dword ptr [ebp+ 0*4], 11, 050A28BE6h
	RMD128II eax, ebx, ecx, edx, dword ptr [ebp+ 9*4], 13, 050A28BE6h
	RMD128II edx, eax, ebx, ecx, dword ptr [ebp+ 2*4], 15, 050A28BE6h
	RMD128II ecx, edx, eax, ebx, dword ptr [ebp+11*4], 15, 050A28BE6h
	RMD128II ebx, ecx, edx, eax, dword ptr [ebp+ 4*4],  5, 050A28BE6h
	RMD128II eax, ebx, ecx, edx, dword ptr [ebp+13*4],  7, 050A28BE6h
	RMD128II edx, eax, ebx, ecx, dword ptr [ebp+ 6*4],  7, 050A28BE6h
	RMD128II ecx, edx, eax, ebx, dword ptr [ebp+15*4],  8, 050A28BE6h
	RMD128II ebx, ecx, edx, eax, dword ptr [ebp+ 8*4], 11, 050A28BE6h
	RMD128II eax, ebx, ecx, edx, dword ptr [ebp+ 1*4], 14, 050A28BE6h
	RMD128II edx, eax, ebx, ecx, dword ptr [ebp+10*4], 14, 050A28BE6h
	RMD128II ecx, edx, eax, ebx, dword ptr [ebp+ 3*4], 12, 050A28BE6h
	RMD128II ebx, ecx, edx, eax, dword ptr [ebp+12*4],  6, 050A28BE6h
	;=================================================================
    RMD128HH eax, ebx, ecx, edx, dword ptr [ebp+ 6*4],  9, 05C4DD124h
    RMD128HH edx, eax, ebx, ecx, dword ptr [ebp+11*4], 13, 05C4DD124h
    RMD128HH ecx, edx, eax, ebx, dword ptr [ebp+ 3*4], 15, 05C4DD124h
    RMD128HH ebx, ecx, edx, eax, dword ptr [ebp+ 7*4],  7, 05C4DD124h
    RMD128HH eax, ebx, ecx, edx, dword ptr [ebp+ 0*4], 12, 05C4DD124h
    RMD128HH edx, eax, ebx, ecx, dword ptr [ebp+13*4],  8, 05C4DD124h
    RMD128HH ecx, edx, eax, ebx, dword ptr [ebp+ 5*4],  9, 05C4DD124h
    RMD128HH ebx, ecx, edx, eax, dword ptr [ebp+10*4], 11, 05C4DD124h
    RMD128HH eax, ebx, ecx, edx, dword ptr [ebp+14*4],  7, 05C4DD124h
    RMD128HH edx, eax, ebx, ecx, dword ptr [ebp+15*4],  7, 05C4DD124h
    RMD128HH ecx, edx, eax, ebx, dword ptr [ebp+ 8*4], 12, 05C4DD124h
    RMD128HH ebx, ecx, edx, eax, dword ptr [ebp+12*4],  7, 05C4DD124h
    RMD128HH eax, ebx, ecx, edx, dword ptr [ebp+ 4*4],  6, 05C4DD124h
    RMD128HH edx, eax, ebx, ecx, dword ptr [ebp+ 9*4], 15, 05C4DD124h
    RMD128HH ecx, edx, eax, ebx, dword ptr [ebp+ 1*4], 13, 05C4DD124h
    RMD128HH ebx, ecx, edx, eax, dword ptr [ebp+ 2*4], 11, 05C4DD124h
    ;=================================================================
	RMD128GG eax, ebx, ecx, edx, dword ptr [ebp+15*4],  9, 06D703EF3h
	RMD128GG edx, eax, ebx, ecx, dword ptr [ebp+ 5*4],  7, 06D703EF3h
	RMD128GG ecx, edx, eax, ebx, dword ptr [ebp+ 1*4], 15, 06D703EF3h
	RMD128GG ebx, ecx, edx, eax, dword ptr [ebp+ 3*4], 11, 06D703EF3h
	RMD128GG eax, ebx, ecx, edx, dword ptr [ebp+ 7*4],  8, 06D703EF3h
	RMD128GG edx, eax, ebx, ecx, dword ptr [ebp+14*4],  6, 06D703EF3h
	RMD128GG ecx, edx, eax, ebx, dword ptr [ebp+ 6*4],  6, 06D703EF3h
	RMD128GG ebx, ecx, edx, eax, dword ptr [ebp+ 9*4], 14, 06D703EF3h
	RMD128GG eax, ebx, ecx, edx, dword ptr [ebp+11*4], 12, 06D703EF3h
	RMD128GG edx, eax, ebx, ecx, dword ptr [ebp+ 8*4], 13, 06D703EF3h
	RMD128GG ecx, edx, eax, ebx, dword ptr [ebp+12*4],  5, 06D703EF3h
	RMD128GG ebx, ecx, edx, eax, dword ptr [ebp+ 2*4], 14, 06D703EF3h
	RMD128GG eax, ebx, ecx, edx, dword ptr [ebp+10*4], 13, 06D703EF3h
	RMD128GG edx, eax, ebx, ecx, dword ptr [ebp+ 0*4], 13, 06D703EF3h
	RMD128GG ecx, edx, eax, ebx, dword ptr [ebp+ 4*4],  7, 06D703EF3h
	RMD128GG ebx, ecx, edx, eax, dword ptr [ebp+13*4],  5, 06D703EF3h
	;=================================================================
	RMD128FF eax, ebx, ecx, edx, dword ptr [ebp+ 8*4], 15
	RMD128FF edx, eax, ebx, ecx, dword ptr [ebp+ 6*4],  5
	RMD128FF ecx, edx, eax, ebx, dword ptr [ebp+ 4*4],  8
	RMD128FF ebx, ecx, edx, eax, dword ptr [ebp+ 1*4], 11
	RMD128FF eax, ebx, ecx, edx, dword ptr [ebp+ 3*4], 14
	RMD128FF edx, eax, ebx, ecx, dword ptr [ebp+11*4], 14
	RMD128FF ecx, edx, eax, ebx, dword ptr [ebp+15*4],  6
	RMD128FF ebx, ecx, edx, eax, dword ptr [ebp+ 0*4], 14
	RMD128FF eax, ebx, ecx, edx, dword ptr [ebp+ 5*4],  6
	RMD128FF edx, eax, ebx, ecx, dword ptr [ebp+12*4],  9
	RMD128FF ecx, edx, eax, ebx, dword ptr [ebp+ 2*4], 12
	RMD128FF ebx, ecx, edx, eax, dword ptr [ebp+13*4],  9
	RMD128FF eax, ebx, ecx, edx, dword ptr [ebp+ 9*4], 12
	RMD128FF edx, eax, ebx, ecx, dword ptr [ebp+ 7*4],  5
	RMD128FF ecx, edx, eax, ebx, dword ptr [ebp+10*4], 15
	RMD128FF ebx, ecx, edx, eax, dword ptr [ebp+14*4],  8
	;=====================================================
    mov edi,[esi+1*4]; update digest
    add eax,[esp+pushad_edx]
    add eax,[esi+2*4]
    add ebx,[esp+pushad_eax]
    add ebx,[esi+3*4]
	add	ecx,[esp+pushad_ebx]
	add ecx,[esi+0*4]
    add edx,[esp+pushad_ecx]
    add edx,edi
	mov [esi+1*4],eax
	mov [esi+2*4],ebx
	mov [esi+3*4],ecx
	mov [esi+0*4],edx
	popad
	popad
	ret
RMD128Transform endp

RMD128BURN macro
	xor eax,eax
	mov RMD128Index,eax
	mov edi,Offset RMD128HashBuf
	mov ecx,(sizeof RMD128HashBuf)/4
	rep stosd
endm

align dword
RMD128Init proc uses edi
	xor eax, eax
	mov RMD128Len,eax
	RMD128BURN
	mov eax,offset RMD128Digest
	mov dword ptr [eax+0*4],067452301h
	mov dword ptr [eax+1*4],0efcdab89h
	mov dword ptr [eax+2*4],098badcfeh
	mov dword ptr [eax+3*4],010325476h
	ret
RMD128Init endp

align dword
RMD128Update proc uses esi edi ebx lpBuffer:dword, dwBufLen:dword
	mov ebx,dwBufLen
	add RMD128Len,ebx
	.while ebx
		mov eax,RMD128Index
		mov edx,64
		sub edx,eax
		.if edx <= ebx
			lea edi, [RMD128HashBuf+eax]	
			mov esi, lpBuffer
			mov ecx, edx
			rep movsb
			sub ebx, edx
			add lpBuffer, edx
			call RMD128Transform
			RMD128BURN
		.else
			lea edi, [RMD128HashBuf+eax]	
			mov esi, lpBuffer
			mov ecx, ebx
			rep movsb
			mov eax, RMD128Index
			add eax, ebx
			mov RMD128Index,eax
			.break
		.endif
	.endw
	ret
RMD128Update endp

align dword
RMD128Final proc uses esi edi
	mov ecx, RMD128Index
	mov byte ptr [RMD128HashBuf+ecx],80h
	.if ecx >= 56
		call RMD128Transform
		RMD128BURN
	.endif
	mov eax,RMD128Len
	xor edx,edx
	shld edx,eax,3
	shl eax,3
	mov dword ptr [RMD128HashBuf+56],eax
	mov dword ptr [RMD128HashBuf+60],edx
	call RMD128Transform
	mov eax,offset RMD128Digest	
	ret
RMD128Final endp


