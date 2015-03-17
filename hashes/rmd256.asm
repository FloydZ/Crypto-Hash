
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
RMD256HashBuf db 64 dup(?)
RMD256Len dd ?
RMD256Index dd ?
RMD256Digest dd 8 dup(?)

.code

RMD256FF macro dwA, dwB, dwC, dwD, locX, rolS
	mov edi,dwB
    xor edi,dwC
    xor edi,dwD
    add dwA,locX
    add dwA,edi
	rol dwA,rolS
endm

RMD256GG macro dwA, dwB, dwC, dwD, locX, rolS, constAC
	mov	edi,dwC
	xor	edi,dwD
	and	edi,dwB
	xor	edi,dwD
	add	dwA,[locX]
	lea	dwA,[dwA+edi+constAC]
	rol	dwA,rolS
ENDM

RMD256HH macro dwA, dwB, dwC, dwD, locX, rolS, constAC
	mov edi,dwC
	xor edi,-1
	or edi,dwB
	xor edi,dwD
	add dwA,[locX]
	lea dwA,[dwA+edi+constAC]
	rol dwA,rolS
endm

RMD256II macro dwA, dwB, dwC, dwD, locX, rolS, constAC
	mov	edi,dwC
	xor	edi,dwB
	and	edi,dwD
	xor	edi,dwC
	add	dwA,[locX]
	lea	dwA,[dwA+edi+constAC]
	rol	dwA,rolS
endm

align dword
RMD256Transform proc
	pushad
	mov esi,offset RMD256Digest
	mov ebp,offset RMD256HashBuf
	mov eax,[esi+0*4];a1
	mov ebx,[esi+1*4];b1
	mov ecx,[esi+2*4];c1
	mov edx,[esi+3*4];d1
	;=====================================================
	RMD256FF eax, ebx, ecx, edx, dword ptr [ebp+ 0*4], 11
	RMD256FF edx, eax, ebx, ecx, dword ptr [ebp+ 1*4], 14
	RMD256FF ecx, edx, eax, ebx, dword ptr [ebp+ 2*4], 15
	RMD256FF ebx, ecx, edx, eax, dword ptr [ebp+ 3*4], 12
	RMD256FF eax, ebx, ecx, edx, dword ptr [ebp+ 4*4],  5
	RMD256FF edx, eax, ebx, ecx, dword ptr [ebp+ 5*4],  8
	RMD256FF ecx, edx, eax, ebx, dword ptr [ebp+ 6*4],  7
	RMD256FF ebx, ecx, edx, eax, dword ptr [ebp+ 7*4],  9
	RMD256FF eax, ebx, ecx, edx, dword ptr [ebp+ 8*4], 11
	RMD256FF edx, eax, ebx, ecx, dword ptr [ebp+ 9*4], 13
	RMD256FF ecx, edx, eax, ebx, dword ptr [ebp+10*4], 14
	RMD256FF ebx, ecx, edx, eax, dword ptr [ebp+11*4], 15
	RMD256FF eax, ebx, ecx, edx, dword ptr [ebp+12*4],  6
	RMD256FF edx, eax, ebx, ecx, dword ptr [ebp+13*4],  7
	RMD256FF ecx, edx, eax, ebx, dword ptr [ebp+14*4],  9
	RMD256FF ebx, ecx, edx, eax, dword ptr [ebp+15*4],  8
	;=====================================================
	pushad; store a..d 1
	mov eax,[esi+4*4];a2
	mov ebx,[esi+5*4];b2
	mov ecx,[esi+6*4];c2
	mov edx,[esi+7*4];d2
	;=================================================================
	RMD256II eax, ebx, ecx, edx, dword ptr [ebp+ 5*4],  8, 050A28BE6H
	RMD256II edx, eax, ebx, ecx, dword ptr [ebp+14*4],  9, 050A28BE6H
	RMD256II ecx, edx, eax, ebx, dword ptr [ebp+ 7*4],  9, 050A28BE6H
	RMD256II ebx, ecx, edx, eax, dword ptr [ebp+ 0*4], 11, 050A28BE6H
	RMD256II eax, ebx, ecx, edx, dword ptr [ebp+ 9*4], 13, 050A28BE6H
	RMD256II edx, eax, ebx, ecx, dword ptr [ebp+ 2*4], 15, 050A28BE6H
	RMD256II ecx, edx, eax, ebx, dword ptr [ebp+11*4], 15, 050A28BE6H
	RMD256II ebx, ecx, edx, eax, dword ptr [ebp+ 4*4],  5, 050A28BE6H
	RMD256II eax, ebx, ecx, edx, dword ptr [ebp+13*4],  7, 050A28BE6H
	RMD256II edx, eax, ebx, ecx, dword ptr [ebp+ 6*4],  7, 050A28BE6H
	RMD256II ecx, edx, eax, ebx, dword ptr [ebp+15*4],  8, 050A28BE6H
	RMD256II ebx, ecx, edx, eax, dword ptr [ebp+ 8*4], 11, 050A28BE6H
	RMD256II eax, ebx, ecx, edx, dword ptr [ebp+ 1*4], 14, 050A28BE6H
	RMD256II edx, eax, ebx, ecx, dword ptr [ebp+10*4], 14, 050A28BE6H
	RMD256II ecx, edx, eax, ebx, dword ptr [ebp+ 3*4], 12, 050A28BE6H
	RMD256II ebx, ecx, edx, eax, dword ptr [ebp+12*4],  6, 050A28BE6H
	;=================================================================
	mov edi,[esp+pushad_eax]
	mov [esp+pushad_eax],eax
	mov eax,edi
;	xchg eax,[esp+pushad_eax]
	pushad;store a..d 2
	mov eax,[esp+pushad_size+pushad_eax];a1
	mov ebx,[esp+pushad_size+pushad_ebx];b1
	mov ecx,[esp+pushad_size+pushad_ecx];c1
	mov edx,[esp+pushad_size+pushad_edx];d1
	;=================================================================
	RMD256GG eax, ebx, ecx, edx, dword ptr [ebp+ 7*4],  7, 05A827999H   
	RMD256GG edx, eax, ebx, ecx, dword ptr [ebp+ 4*4],  6, 05A827999H   
	RMD256GG ecx, edx, eax, ebx, dword ptr [ebp+13*4],  8, 05A827999H   
	RMD256GG ebx, ecx, edx, eax, dword ptr [ebp+ 1*4], 13, 05A827999H   
	RMD256GG eax, ebx, ecx, edx, dword ptr [ebp+10*4], 11, 05A827999H   
	RMD256GG edx, eax, ebx, ecx, dword ptr [ebp+ 6*4],  9, 05A827999H   
	RMD256GG ecx, edx, eax, ebx, dword ptr [ebp+15*4],  7, 05A827999H   
	RMD256GG ebx, ecx, edx, eax, dword ptr [ebp+ 3*4], 15, 05A827999H   
	RMD256GG eax, ebx, ecx, edx, dword ptr [ebp+12*4],  7, 05A827999H   
	RMD256GG edx, eax, ebx, ecx, dword ptr [ebp+ 0*4], 12, 05A827999H   
	RMD256GG ecx, edx, eax, ebx, dword ptr [ebp+ 9*4], 15, 05A827999H   
	RMD256GG ebx, ecx, edx, eax, dword ptr [ebp+ 5*4],  9, 05A827999H   
	RMD256GG eax, ebx, ecx, edx, dword ptr [ebp+ 2*4], 11, 05A827999H   
	RMD256GG edx, eax, ebx, ecx, dword ptr [ebp+14*4],  7, 05A827999H   
	RMD256GG ecx, edx, eax, ebx, dword ptr [ebp+11*4], 13, 05A827999H   
	RMD256GG ebx, ecx, edx, eax, dword ptr [ebp+ 8*4], 12, 05A827999H
	;=================================================================
	mov [esp+pushad_size+pushad_eax],eax;a1
	mov [esp+pushad_size+pushad_ebx],ebx;b1
	mov [esp+pushad_size+pushad_ecx],ecx;c1
	mov [esp+pushad_size+pushad_edx],edx;d1
	mov eax,[esp+pushad_eax];a2
	mov ebx,[esp+pushad_ebx];b2
	mov ecx,[esp+pushad_ecx];c2
	mov edx,[esp+pushad_edx];d2
	;=================================================================
    RMD256HH eax, ebx, ecx, edx, dword ptr [ebp+ 6*4],  9, 05C4DD124H
    RMD256HH edx, eax, ebx, ecx, dword ptr [ebp+11*4], 13, 05C4DD124H
    RMD256HH ecx, edx, eax, ebx, dword ptr [ebp+ 3*4], 15, 05C4DD124H
    RMD256HH ebx, ecx, edx, eax, dword ptr [ebp+ 7*4],  7, 05C4DD124H
    RMD256HH eax, ebx, ecx, edx, dword ptr [ebp+ 0*4], 12, 05C4DD124H
    RMD256HH edx, eax, ebx, ecx, dword ptr [ebp+13*4],  8, 05C4DD124H
    RMD256HH ecx, edx, eax, ebx, dword ptr [ebp+ 5*4],  9, 05C4DD124H
    RMD256HH ebx, ecx, edx, eax, dword ptr [ebp+10*4], 11, 05C4DD124H
    RMD256HH eax, ebx, ecx, edx, dword ptr [ebp+14*4],  7, 05C4DD124H
    RMD256HH edx, eax, ebx, ecx, dword ptr [ebp+15*4],  7, 05C4DD124H
    RMD256HH ecx, edx, eax, ebx, dword ptr [ebp+ 8*4], 12, 05C4DD124H
    RMD256HH ebx, ecx, edx, eax, dword ptr [ebp+12*4],  7, 05C4DD124H
    RMD256HH eax, ebx, ecx, edx, dword ptr [ebp+ 4*4],  6, 05C4DD124H
    RMD256HH edx, eax, ebx, ecx, dword ptr [ebp+ 9*4], 15, 05C4DD124H
    RMD256HH ecx, edx, eax, ebx, dword ptr [ebp+ 1*4], 13, 05C4DD124H
    RMD256HH ebx, ecx, edx, eax, dword ptr [ebp+ 2*4], 11, 05C4DD124H
    ;=================================================================
	mov edi,[esp+pushad_size+pushad_ebx]
	mov [esp+pushad_size+pushad_ebx],ebx
	mov ebx,edi
;	xchg ebx,[esp+pushad_size+pushad_ebx]
	mov [esp+pushad_eax],eax;a2
	mov [esp+pushad_ebx],ebx;b2
	mov [esp+pushad_ecx],ecx;c2
	mov [esp+pushad_edx],edx;d2
	mov eax,[esp+pushad_size+pushad_eax];a1
	mov ebx,[esp+pushad_size+pushad_ebx];b1
	mov ecx,[esp+pushad_size+pushad_ecx];c1
	mov edx,[esp+pushad_size+pushad_edx];d1
	;=================================================================
	RMD256HH eax, ebx, ecx, edx, dword ptr [ebp+ 3*4], 11, 06ED9EBA1H
	RMD256HH edx, eax, ebx, ecx, dword ptr [ebp+10*4], 13, 06ED9EBA1H   
	RMD256HH ecx, edx, eax, ebx, dword ptr [ebp+14*4],  6, 06ED9EBA1H   
	RMD256HH ebx, ecx, edx, eax, dword ptr [ebp+ 4*4],  7, 06ED9EBA1H
	RMD256HH eax, ebx, ecx, edx, dword ptr [ebp+ 9*4], 14, 06ED9EBA1H    
	RMD256HH edx, eax, ebx, ecx, dword ptr [ebp+15*4],  9, 06ED9EBA1H
	RMD256HH ecx, edx, eax, ebx, dword ptr [ebp+ 8*4], 13, 06ED9EBA1H
	RMD256HH ebx, ecx, edx, eax, dword ptr [ebp+ 1*4], 15, 06ED9EBA1H
	RMD256HH eax, ebx, ecx, edx, dword ptr [ebp+ 2*4], 14, 06ED9EBA1H
	RMD256HH edx, eax, ebx, ecx, dword ptr [ebp+ 7*4],  8, 06ED9EBA1H
	RMD256HH ecx, edx, eax, ebx, dword ptr [ebp+ 0*4], 13, 06ED9EBA1H
	RMD256HH ebx, ecx, edx, eax, dword ptr [ebp+ 6*4],  6, 06ED9EBA1H
	RMD256HH eax, ebx, ecx, edx, dword ptr [ebp+13*4],  5, 06ED9EBA1H
	RMD256HH edx, eax, ebx, ecx, dword ptr [ebp+11*4], 12, 06ED9EBA1H
	RMD256HH ecx, edx, eax, ebx, dword ptr [ebp+ 5*4],  7, 06ED9EBA1H
	RMD256HH ebx, ecx, edx, eax, dword ptr [ebp+12*4],  5, 06ED9EBA1H
	;=================================================================
	mov [esp+pushad_size+pushad_eax],eax;a1
	mov [esp+pushad_size+pushad_ebx],ebx;b1
	mov [esp+pushad_size+pushad_ecx],ecx;c1
	mov [esp+pushad_size+pushad_edx],edx;d1
	mov eax,[esp+pushad_eax];a2
	mov ebx,[esp+pushad_ebx];b2
	mov ecx,[esp+pushad_ecx];c2
	mov edx,[esp+pushad_edx];d2
	;=================================================================
	RMD256GG eax, ebx, ecx, edx, dword ptr [ebp+15*4],  9, 06D703EF3H
	RMD256GG edx, eax, ebx, ecx, dword ptr [ebp+ 5*4],  7, 06D703EF3H
	RMD256GG ecx, edx, eax, ebx, dword ptr [ebp+ 1*4], 15, 06D703EF3H
	RMD256GG ebx, ecx, edx, eax, dword ptr [ebp+ 3*4], 11, 06D703EF3H
	RMD256GG eax, ebx, ecx, edx, dword ptr [ebp+ 7*4],  8, 06D703EF3H
	RMD256GG edx, eax, ebx, ecx, dword ptr [ebp+14*4],  6, 06D703EF3H
	RMD256GG ecx, edx, eax, ebx, dword ptr [ebp+ 6*4],  6, 06D703EF3H
	RMD256GG ebx, ecx, edx, eax, dword ptr [ebp+ 9*4], 14, 06D703EF3H
	RMD256GG eax, ebx, ecx, edx, dword ptr [ebp+11*4], 12, 06D703EF3H
	RMD256GG edx, eax, ebx, ecx, dword ptr [ebp+ 8*4], 13, 06D703EF3H
	RMD256GG ecx, edx, eax, ebx, dword ptr [ebp+12*4],  5, 06D703EF3H
	RMD256GG ebx, ecx, edx, eax, dword ptr [ebp+ 2*4], 14, 06D703EF3H
	RMD256GG eax, ebx, ecx, edx, dword ptr [ebp+10*4], 13, 06D703EF3H
	RMD256GG edx, eax, ebx, ecx, dword ptr [ebp+ 0*4], 13, 06D703EF3H
	RMD256GG ecx, edx, eax, ebx, dword ptr [ebp+ 4*4],  7, 06D703EF3H
	RMD256GG ebx, ecx, edx, eax, dword ptr [ebp+13*4],  5, 06D703EF3H
	;=================================================================
	mov edi,[esp+pushad_size+pushad_ecx]
	mov [esp+pushad_size+pushad_ecx],ecx
	mov ecx,edi
;	xchg ecx,[esp+pushad_size+pushad_ecx]
	mov [esp+pushad_eax],eax;a2
	mov [esp+pushad_ebx],ebx;b2
	mov [esp+pushad_ecx],ecx;c2
	mov [esp+pushad_edx],edx;d2
	mov eax,[esp+pushad_size+pushad_eax];a1
	mov ebx,[esp+pushad_size+pushad_ebx];b1
	mov ecx,[esp+pushad_size+pushad_ecx];c1
	mov edx,[esp+pushad_size+pushad_edx];d1
	;=================================================================
 	RMD256II eax, ebx, ecx, edx, dword ptr [ebp+ 1*4], 11, 08F1BBCDCH
	RMD256II edx, eax, ebx, ecx, dword ptr [ebp+ 9*4], 12, 08F1BBCDCH
	RMD256II ecx, edx, eax, ebx, dword ptr [ebp+11*4], 14, 08F1BBCDCH
	RMD256II ebx, ecx, edx, eax, dword ptr [ebp+10*4], 15, 08F1BBCDCH
	RMD256II eax, ebx, ecx, edx, dword ptr [ebp+ 0*4], 14, 08F1BBCDCH
	RMD256II edx, eax, ebx, ecx, dword ptr [ebp+ 8*4], 15, 08F1BBCDCH
	RMD256II ecx, edx, eax, ebx, dword ptr [ebp+12*4],  9, 08F1BBCDCH
	RMD256II ebx, ecx, edx, eax, dword ptr [ebp+ 4*4],  8, 08F1BBCDCH
	RMD256II eax, ebx, ecx, edx, dword ptr [ebp+13*4],  9, 08F1BBCDCH
	RMD256II edx, eax, ebx, ecx, dword ptr [ebp+ 3*4], 14, 08F1BBCDCH
	RMD256II ecx, edx, eax, ebx, dword ptr [ebp+ 7*4],  5, 08F1BBCDCH
	RMD256II ebx, ecx, edx, eax, dword ptr [ebp+15*4],  6, 08F1BBCDCH
	RMD256II eax, ebx, ecx, edx, dword ptr [ebp+14*4],  8, 08F1BBCDCH
	RMD256II edx, eax, ebx, ecx, dword ptr [ebp+ 5*4],  6, 08F1BBCDCH
	RMD256II ecx, edx, eax, ebx, dword ptr [ebp+ 6*4],  5, 08F1BBCDCH
	RMD256II ebx, ecx, edx, eax, dword ptr [ebp+ 2*4], 12, 08F1BBCDCH
	;=================================================================
	mov [esp+pushad_size+pushad_eax],eax;a1
	mov [esp+pushad_size+pushad_ebx],ebx;b1
	mov [esp+pushad_size+pushad_ecx],ecx;c1
	mov [esp+pushad_size+pushad_edx],edx;d1
	mov eax,[esp+pushad_eax];a2
	mov ebx,[esp+pushad_ebx];b2
	mov ecx,[esp+pushad_ecx];c2
	mov edx,[esp+pushad_edx];d2
	;=====================================================
	RMD256FF eax, ebx, ecx, edx, dword ptr [ebp+ 8*4], 15
	RMD256FF edx, eax, ebx, ecx, dword ptr [ebp+ 6*4],  5
	RMD256FF ecx, edx, eax, ebx, dword ptr [ebp+ 4*4],  8
	RMD256FF ebx, ecx, edx, eax, dword ptr [ebp+ 1*4], 11
	RMD256FF eax, ebx, ecx, edx, dword ptr [ebp+ 3*4], 14
	RMD256FF edx, eax, ebx, ecx, dword ptr [ebp+11*4], 14
	RMD256FF ecx, edx, eax, ebx, dword ptr [ebp+15*4],  6
	RMD256FF ebx, ecx, edx, eax, dword ptr [ebp+ 0*4], 14
	RMD256FF eax, ebx, ecx, edx, dword ptr [ebp+ 5*4],  6
	RMD256FF edx, eax, ebx, ecx, dword ptr [ebp+12*4],  9
	RMD256FF ecx, edx, eax, ebx, dword ptr [ebp+ 2*4], 12
	RMD256FF ebx, ecx, edx, eax, dword ptr [ebp+13*4],  9
	RMD256FF eax, ebx, ecx, edx, dword ptr [ebp+ 9*4], 12
	RMD256FF edx, eax, ebx, ecx, dword ptr [ebp+ 7*4],  5
	RMD256FF ecx, edx, eax, ebx, dword ptr [ebp+10*4], 15
	RMD256FF ebx, ecx, edx, eax, dword ptr [ebp+14*4],  8
	;=====================================================
	mov edi,[esp+pushad_size+pushad_edx]
	mov [esp+pushad_size+pushad_edx],edx
	mov edx,edi
;	xchg edx,[esp+pushad_size+pushad_edx];b1<-->b2
	add [esi+4*4],eax;a2
	add [esi+5*4],ebx;...
	add [esi+6*4],ecx
	add [esi+7*4],edx
	popad
	popad
	add [esi+0*4],eax;a1
	add [esi+1*4],ebx;...
	add [esi+2*4],ecx
	add [esi+3*4],edx
	popad
	ret
RMD256Transform endp

RMD256BURN macro
	xor eax,eax
	mov RMD256Index,eax
	mov edi,Offset RMD256HashBuf
	mov ecx,(sizeof RMD256HashBuf)/4
	rep stosd
endm

align dword
RMD256Init proc uses edi
	xor eax, eax
	mov RMD256Len,eax
	RMD256BURN
	mov eax,offset RMD256Digest
	mov dword ptr [eax+0*4],067452301h
	mov dword ptr [eax+1*4],0efcdab89h
	mov dword ptr [eax+2*4],098badcfeh
	mov dword ptr [eax+3*4],010325476h
	mov dword ptr [eax+4*4],076543210h
	mov dword ptr [eax+5*4],0FEDCBA98h
	mov dword ptr [eax+6*4],089ABCDEFh
	mov dword ptr [eax+7*4],001234567h
	ret
RMD256Init endp

align dword
RMD256Update proc uses esi edi ebx lpBuffer:dword, dwBufLen:dword
	mov ebx,dwBufLen
	add RMD256Len,ebx
	.while ebx
		mov eax,RMD256Index
		mov edx,64
		sub edx,eax
		.if edx <= ebx
			lea edi, [RMD256HashBuf+eax]	
			mov esi, lpBuffer
			mov ecx, edx
			rep movsb
			sub ebx, edx
			add lpBuffer, edx
			call RMD256Transform
			RMD256BURN
		.else
			lea edi, [RMD256HashBuf+eax]	
			mov esi, lpBuffer
			mov ecx, ebx
			rep movsb
			mov eax, RMD256Index
			add eax, ebx
			mov RMD256Index,eax
			.break
		.endif
	.endw
	ret
RMD256Update endp

align dword
RMD256Final proc uses esi edi
	mov ecx, RMD256Index
	mov byte ptr [RMD256HashBuf+ecx],80h
	.if ecx >= 56
		call RMD256Transform
		RMD256BURN
	.endif
	mov eax,RMD256Len
	xor edx,edx
	shld edx,eax,3
	shl eax,3
	mov dword ptr [RMD256HashBuf+56],eax
	mov dword ptr [RMD256HashBuf+60],edx
	call RMD256Transform
	mov eax,offset RMD256Digest	
	ret
RMD256Final endp

