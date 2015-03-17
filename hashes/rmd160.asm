
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
RMD160HashBuf db 64 dup(?)
RMD160Len dd ?
RMD160Index dd ?
RMD160Digest dd 5 dup(?)

.code
RMD160FF macro dwA, dwB, dwC, dwD, dwE, locX, rolS
	mov edi,dwB
    xor edi,dwC
    xor edi,dwD
    add dwA,locX
    add dwA,edi
	rol dwA,rolS
	add dwA,dwE
	rol	dwC,10
endm
RMD160GG macro dwA, dwB, dwC, dwD, dwE, locX, rolS, constAC
	mov	edi,dwC
	xor	edi,dwD
	and	edi,dwB
	xor	edi,dwD
	add	dwA,[locX]
	lea	dwA,[dwA+edi+constAC]
	rol	dwA,rolS
	add dwA,dwE
	rol	dwC,10
ENDM
RMD160HH macro dwA, dwB, dwC, dwD, dwE, locX, rolS, constAC
	mov edi,dwC
	xor edi,-1
	or edi,dwB
	xor edi,dwD
	add dwA,[locX]
	lea dwA,[dwA+edi+constAC]
	rol dwA,rolS
	add dwA,dwE
	rol	dwC,10
endm
RMD160II macro dwA, dwB, dwC, dwD, dwE, locX, rolS, constAC
	mov	edi,dwC
	xor	edi,dwB
	and	edi,dwD
	xor	edi,dwC
	add	dwA,[locX]
	lea	dwA,[dwA+edi+constAC]
	rol	dwA,rolS
	add dwA,dwE
	rol	dwC,10
endm
RMD160JJ macro dwA, dwB, dwC, dwD, dwE, locX, rolS, constAC
	mov	edi,dwD
	xor edi,-1
	or edi,dwC
	xor edi,dwB
	add dwA,[locX]	
	lea dwA,[dwA+edi+constAC]
	rol dwA,rolS
	add dwA,dwE
	rol dwC,10
ENDM

align dword
RMD160Transform proc
	pushad
	mov edi,offset RMD160Digest
	mov ebp,offset RMD160HashBuf
	mov eax,[edi+0*4]
	mov ebx,[edi+1*4]
	mov ecx,[edi+2*4]
	mov edx,[edi+3*4]
	mov esi,[edi+4*4]
	;==========================================================
	RMD160FF eax, ebx, ecx, edx, esi, dword ptr [ebp+00*4], 11
	RMD160FF esi, eax, ebx, ecx, edx, dword ptr [ebp+01*4], 14
	RMD160FF edx, esi, eax, ebx, ecx, dword ptr [ebp+02*4], 15
	RMD160FF ecx, edx, esi, eax, ebx, dword ptr [ebp+03*4], 12
	RMD160FF ebx, ecx, edx, esi, eax, dword ptr [ebp+04*4], 05
	RMD160FF eax, ebx, ecx, edx, esi, dword ptr [ebp+05*4], 08
	RMD160FF esi, eax, ebx, ecx, edx, dword ptr [ebp+06*4], 07
	RMD160FF edx, esi, eax, ebx, ecx, dword ptr [ebp+07*4], 09
	RMD160FF ecx, edx, esi, eax, ebx, dword ptr [ebp+08*4], 11
	RMD160FF ebx, ecx, edx, esi, eax, dword ptr [ebp+09*4], 13
	RMD160FF eax, ebx, ecx, edx, esi, dword ptr [ebp+10*4], 14
	RMD160FF esi, eax, ebx, ecx, edx, dword ptr [ebp+11*4], 15
	RMD160FF edx, esi, eax, ebx, ecx, dword ptr [ebp+12*4], 06
	RMD160FF ecx, edx, esi, eax, ebx, dword ptr [ebp+13*4], 07
	RMD160FF ebx, ecx, edx, esi, eax, dword ptr [ebp+14*4], 09
	RMD160FF eax, ebx, ecx, edx, esi, dword ptr [ebp+15*4], 08
	;======================================================================
	RMD160GG esi, eax, ebx, ecx, edx, dword ptr [ebp+07*4], 07, 05a827999h
	RMD160GG edx, esi, eax, ebx, ecx, dword ptr [ebp+04*4], 06, 05a827999h
	RMD160GG ecx, edx, esi, eax, ebx, dword ptr [ebp+13*4], 08, 05a827999h
	RMD160GG ebx, ecx, edx, esi, eax, dword ptr [ebp+01*4], 13, 05a827999h
	RMD160GG eax, ebx, ecx, edx, esi, dword ptr [ebp+10*4], 11, 05a827999h
	RMD160GG esi, eax, ebx, ecx, edx, dword ptr [ebp+06*4], 09, 05a827999h
	RMD160GG edx, esi, eax, ebx, ecx, dword ptr [ebp+15*4], 07, 05a827999h
	RMD160GG ecx, edx, esi, eax, ebx, dword ptr [ebp+03*4], 15, 05a827999h
	RMD160GG ebx, ecx, edx, esi, eax, dword ptr [ebp+12*4], 07, 05a827999h
	RMD160GG eax, ebx, ecx, edx, esi, dword ptr [ebp+00*4], 12, 05a827999h
	RMD160GG esi, eax, ebx, ecx, edx, dword ptr [ebp+09*4], 15, 05a827999h
	RMD160GG edx, esi, eax, ebx, ecx, dword ptr [ebp+05*4], 09, 05a827999h
	RMD160GG ecx, edx, esi, eax, ebx, dword ptr [ebp+02*4], 11, 05a827999h
	RMD160GG ebx, ecx, edx, esi, eax, dword ptr [ebp+14*4], 07, 05a827999h
	RMD160GG eax, ebx, ecx, edx, esi, dword ptr [ebp+11*4], 13, 05a827999h
	RMD160GG esi, eax, ebx, ecx, edx, dword ptr [ebp+08*4], 12, 05a827999h
	;======================================================================
	RMD160HH edx, esi, eax, ebx, ecx, dword ptr [ebp+03*4], 11, 06ed9eba1h
	RMD160HH ecx, edx, esi, eax, ebx, dword ptr [ebp+10*4], 13, 06ed9eba1h
	RMD160HH ebx, ecx, edx, esi, eax, dword ptr [ebp+14*4], 06, 06ed9eba1h
	RMD160HH eax, ebx, ecx, edx, esi, dword ptr [ebp+04*4], 07, 06ed9eba1h
	RMD160HH esi, eax, ebx, ecx, edx, dword ptr [ebp+09*4], 14, 06ed9eba1h
	RMD160HH edx, esi, eax, ebx, ecx, dword ptr [ebp+15*4], 09, 06ed9eba1h
	RMD160HH ecx, edx, esi, eax, ebx, dword ptr [ebp+08*4], 13, 06ed9eba1h
	RMD160HH ebx, ecx, edx, esi, eax, dword ptr [ebp+01*4], 15, 06ed9eba1h
	RMD160HH eax, ebx, ecx, edx, esi, dword ptr [ebp+02*4], 14, 06ed9eba1h
	RMD160HH esi, eax, ebx, ecx, edx, dword ptr [ebp+07*4], 08, 06ed9eba1h
	RMD160HH edx, esi, eax, ebx, ecx, dword ptr [ebp+00*4], 13, 06ed9eba1h
	RMD160HH ecx, edx, esi, eax, ebx, dword ptr [ebp+06*4], 06, 06ed9eba1h
	RMD160HH ebx, ecx, edx, esi, eax, dword ptr [ebp+13*4], 05, 06ed9eba1h
	RMD160HH eax, ebx, ecx, edx, esi, dword ptr [ebp+11*4], 12, 06ed9eba1h
	RMD160HH esi, eax, ebx, ecx, edx, dword ptr [ebp+05*4], 07, 06ed9eba1h
	RMD160HH edx, esi, eax, ebx, ecx, dword ptr [ebp+12*4], 05, 06ed9eba1h
	;======================================================================
	RMD160II ecx, edx, esi, eax, ebx, dword ptr [ebp+01*4], 11, 08f1bbcdch
	RMD160II ebx, ecx, edx, esi, eax, dword ptr [ebp+09*4], 12, 08f1bbcdch
	RMD160II eax, ebx, ecx, edx, esi, dword ptr [ebp+11*4], 14, 08f1bbcdch
	RMD160II esi, eax, ebx, ecx, edx, dword ptr [ebp+10*4], 15, 08f1bbcdch
	RMD160II edx, esi, eax, ebx, ecx, dword ptr [ebp+00*4], 14, 08f1bbcdch
	RMD160II ecx, edx, esi, eax, ebx, dword ptr [ebp+08*4], 15, 08f1bbcdch
	RMD160II ebx, ecx, edx, esi, eax, dword ptr [ebp+12*4], 09, 08f1bbcdch
	RMD160II eax, ebx, ecx, edx, esi, dword ptr [ebp+04*4], 08, 08f1bbcdch
	RMD160II esi, eax, ebx, ecx, edx, dword ptr [ebp+13*4], 09, 08f1bbcdch
	RMD160II edx, esi, eax, ebx, ecx, dword ptr [ebp+03*4], 14, 08f1bbcdch
	RMD160II ecx, edx, esi, eax, ebx, dword ptr [ebp+07*4], 05, 08f1bbcdch
	RMD160II ebx, ecx, edx, esi, eax, dword ptr [ebp+15*4], 06, 08f1bbcdch
	RMD160II eax, ebx, ecx, edx, esi, dword ptr [ebp+14*4], 08, 08f1bbcdch
	RMD160II esi, eax, ebx, ecx, edx, dword ptr [ebp+05*4], 06, 08f1bbcdch
	RMD160II edx, esi, eax, ebx, ecx, dword ptr [ebp+06*4], 05, 08f1bbcdch
	RMD160II ecx, edx, esi, eax, ebx, dword ptr [ebp+02*4], 12, 08f1bbcdch
	;======================================================================
	RMD160JJ ebx, ecx, edx, esi, eax, dword ptr [ebp+04*4], 09, 0a953fd4eh
	RMD160JJ eax, ebx, ecx, edx, esi, dword ptr [ebp+00*4], 15, 0a953fd4eh
	RMD160JJ esi, eax, ebx, ecx, edx, dword ptr [ebp+05*4], 05, 0a953fd4eh
	RMD160JJ edx, esi, eax, ebx, ecx, dword ptr [ebp+09*4], 11, 0a953fd4eh
	RMD160JJ ecx, edx, esi, eax, ebx, dword ptr [ebp+07*4], 06, 0a953fd4eh
	RMD160JJ ebx, ecx, edx, esi, eax, dword ptr [ebp+12*4], 08, 0a953fd4eh
	RMD160JJ eax, ebx, ecx, edx, esi, dword ptr [ebp+02*4], 13, 0a953fd4eh
	RMD160JJ esi, eax, ebx, ecx, edx, dword ptr [ebp+10*4], 12, 0a953fd4eh
	RMD160JJ edx, esi, eax, ebx, ecx, dword ptr [ebp+14*4], 05, 0a953fd4eh
	RMD160JJ ecx, edx, esi, eax, ebx, dword ptr [ebp+01*4], 12, 0a953fd4eh
	RMD160JJ ebx, ecx, edx, esi, eax, dword ptr [ebp+03*4], 13, 0a953fd4eh
	RMD160JJ eax, ebx, ecx, edx, esi, dword ptr [ebp+08*4], 14, 0a953fd4eh
	RMD160JJ esi, eax, ebx, ecx, edx, dword ptr [ebp+11*4], 11, 0a953fd4eh
	RMD160JJ edx, esi, eax, ebx, ecx, dword ptr [ebp+06*4], 08, 0a953fd4eh
	RMD160JJ ecx, edx, esi, eax, ebx, dword ptr [ebp+15*4], 05, 0a953fd4eh
	RMD160JJ ebx, ecx, edx, esi, eax, dword ptr [ebp+13*4], 06, 0a953fd4eh
	;======================================================================
	mov edi,offset RMD160Digest
	pushad;  parallel
	mov eax,[edi+0*4]
	mov ebx,[edi+1*4]
	mov ecx,[edi+2*4]
	mov edx,[edi+3*4]
	mov esi,[edi+4*4]
	;======================================================================
	RMD160JJ eax, ebx, ecx, edx, esi, dword ptr [ebp+05*4], 08, 050a28be6h
	RMD160JJ esi, eax, ebx, ecx, edx, dword ptr [ebp+14*4], 09, 050a28be6h
	RMD160JJ edx, esi, eax, ebx, ecx, dword ptr [ebp+07*4], 09, 050a28be6h
	RMD160JJ ecx, edx, esi, eax, ebx, dword ptr [ebp+00*4], 11, 050a28be6h
	RMD160JJ ebx, ecx, edx, esi, eax, dword ptr [ebp+09*4], 13, 050a28be6h
	RMD160JJ eax, ebx, ecx, edx, esi, dword ptr [ebp+02*4], 15, 050a28be6h
	RMD160JJ esi, eax, ebx, ecx, edx, dword ptr [ebp+11*4], 15, 050a28be6h
	RMD160JJ edx, esi, eax, ebx, ecx, dword ptr [ebp+04*4], 05, 050a28be6h
	RMD160JJ ecx, edx, esi, eax, ebx, dword ptr [ebp+13*4], 07, 050a28be6h
	RMD160JJ ebx, ecx, edx, esi, eax, dword ptr [ebp+06*4], 07, 050a28be6h
	RMD160JJ eax, ebx, ecx, edx, esi, dword ptr [ebp+15*4], 08, 050a28be6h
	RMD160JJ esi, eax, ebx, ecx, edx, dword ptr [ebp+08*4], 11, 050a28be6h
	RMD160JJ edx, esi, eax, ebx, ecx, dword ptr [ebp+01*4], 14, 050a28be6h
	RMD160JJ ecx, edx, esi, eax, ebx, dword ptr [ebp+10*4], 14, 050a28be6h
	RMD160JJ ebx, ecx, edx, esi, eax, dword ptr [ebp+03*4], 12, 050a28be6h
	RMD160JJ eax, ebx, ecx, edx, esi, dword ptr [ebp+12*4], 06, 050a28be6h
	;======================================================================
	RMD160II esi, eax, ebx, ecx, edx, dword ptr [ebp+06*4], 09, 05c4dd124h
	RMD160II edx, esi, eax, ebx, ecx, dword ptr [ebp+11*4], 13, 05c4dd124h
	RMD160II ecx, edx, esi, eax, ebx, dword ptr [ebp+03*4], 15, 05c4dd124h
	RMD160II ebx, ecx, edx, esi, eax, dword ptr [ebp+07*4], 07, 05c4dd124h
	RMD160II eax, ebx, ecx, edx, esi, dword ptr [ebp+00*4], 12, 05c4dd124h
	RMD160II esi, eax, ebx, ecx, edx, dword ptr [ebp+13*4], 08, 05c4dd124h
	RMD160II edx, esi, eax, ebx, ecx, dword ptr [ebp+05*4], 09, 05c4dd124h
	RMD160II ecx, edx, esi, eax, ebx, dword ptr [ebp+10*4], 11, 05c4dd124h
	RMD160II ebx, ecx, edx, esi, eax, dword ptr [ebp+14*4], 07, 05c4dd124h
	RMD160II eax, ebx, ecx, edx, esi, dword ptr [ebp+15*4], 07, 05c4dd124h
	RMD160II esi, eax, ebx, ecx, edx, dword ptr [ebp+08*4], 12, 05c4dd124h
	RMD160II edx, esi, eax, ebx, ecx, dword ptr [ebp+12*4], 07, 05c4dd124h
	RMD160II ecx, edx, esi, eax, ebx, dword ptr [ebp+04*4], 06, 05c4dd124h
	RMD160II ebx, ecx, edx, esi, eax, dword ptr [ebp+09*4], 15, 05c4dd124h
	RMD160II eax, ebx, ecx, edx, esi, dword ptr [ebp+01*4], 13, 05c4dd124h
	RMD160II esi, eax, ebx, ecx, edx, dword ptr [ebp+02*4], 11, 05c4dd124h
	;======================================================================
	RMD160HH edx, esi, eax, ebx, ecx, dword ptr [ebp+15*4], 09, 06d703ef3h
	RMD160HH ecx, edx, esi, eax, ebx, dword ptr [ebp+05*4], 07, 06d703ef3h
	RMD160HH ebx, ecx, edx, esi, eax, dword ptr [ebp+01*4], 15, 06d703ef3h
	RMD160HH eax, ebx, ecx, edx, esi, dword ptr [ebp+03*4], 11, 06d703ef3h
	RMD160HH esi, eax, ebx, ecx, edx, dword ptr [ebp+07*4], 08, 06d703ef3h
	RMD160HH edx, esi, eax, ebx, ecx, dword ptr [ebp+14*4], 06, 06d703ef3h
	RMD160HH ecx, edx, esi, eax, ebx, dword ptr [ebp+06*4], 06, 06d703ef3h
	RMD160HH ebx, ecx, edx, esi, eax, dword ptr [ebp+09*4], 14, 06d703ef3h
	RMD160HH eax, ebx, ecx, edx, esi, dword ptr [ebp+11*4], 12, 06d703ef3h
	RMD160HH esi, eax, ebx, ecx, edx, dword ptr [ebp+08*4], 13, 06d703ef3h
	RMD160HH edx, esi, eax, ebx, ecx, dword ptr [ebp+12*4], 05, 06d703ef3h
	RMD160HH ecx, edx, esi, eax, ebx, dword ptr [ebp+02*4], 14, 06d703ef3h
	RMD160HH ebx, ecx, edx, esi, eax, dword ptr [ebp+10*4], 13, 06d703ef3h
	RMD160HH eax, ebx, ecx, edx, esi, dword ptr [ebp+00*4], 13, 06d703ef3h
	RMD160HH esi, eax, ebx, ecx, edx, dword ptr [ebp+04*4], 07, 06d703ef3h
	RMD160HH edx, esi, eax, ebx, ecx, dword ptr [ebp+13*4], 05, 06d703ef3h
	;======================================================================
	RMD160GG ecx, edx, esi, eax, ebx, dword ptr [ebp+08*4], 15, 07a6d76e9h
	RMD160GG ebx, ecx, edx, esi, eax, dword ptr [ebp+06*4], 05, 07a6d76e9h
	RMD160GG eax, ebx, ecx, edx, esi, dword ptr [ebp+04*4], 08, 07a6d76e9h
	RMD160GG esi, eax, ebx, ecx, edx, dword ptr [ebp+01*4], 11, 07a6d76e9h
	RMD160GG edx, esi, eax, ebx, ecx, dword ptr [ebp+03*4], 14, 07a6d76e9h
	RMD160GG ecx, edx, esi, eax, ebx, dword ptr [ebp+11*4], 14, 07a6d76e9h
	RMD160GG ebx, ecx, edx, esi, eax, dword ptr [ebp+15*4], 06, 07a6d76e9h
	RMD160GG eax, ebx, ecx, edx, esi, dword ptr [ebp+00*4], 14, 07a6d76e9h
	RMD160GG esi, eax, ebx, ecx, edx, dword ptr [ebp+05*4], 06, 07a6d76e9h
	RMD160GG edx, esi, eax, ebx, ecx, dword ptr [ebp+12*4], 09, 07a6d76e9h
	RMD160GG ecx, edx, esi, eax, ebx, dword ptr [ebp+02*4], 12, 07a6d76e9h
	RMD160GG ebx, ecx, edx, esi, eax, dword ptr [ebp+13*4], 09, 07a6d76e9h
	RMD160GG eax, ebx, ecx, edx, esi, dword ptr [ebp+09*4], 12, 07a6d76e9h
	RMD160GG esi, eax, ebx, ecx, edx, dword ptr [ebp+07*4], 05, 07a6d76e9h
	RMD160GG edx, esi, eax, ebx, ecx, dword ptr [ebp+10*4], 15, 07a6d76e9h
	RMD160GG ecx, edx, esi, eax, ebx, dword ptr [ebp+14*4], 08, 07a6d76e9h
	;======================================================================
	RMD160FF ebx, ecx, edx, esi, eax, dword ptr [ebp+12*4], 08
	RMD160FF eax, ebx, ecx, edx, esi, dword ptr [ebp+15*4], 05
	RMD160FF esi, eax, ebx, ecx, edx, dword ptr [ebp+10*4], 12
	RMD160FF edx, esi, eax, ebx, ecx, dword ptr [ebp+04*4], 09
	RMD160FF ecx, edx, esi, eax, ebx, dword ptr [ebp+01*4], 12
	RMD160FF ebx, ecx, edx, esi, eax, dword ptr [ebp+05*4], 05
	RMD160FF eax, ebx, ecx, edx, esi, dword ptr [ebp+08*4], 14
	RMD160FF esi, eax, ebx, ecx, edx, dword ptr [ebp+07*4], 06
	RMD160FF edx, esi, eax, ebx, ecx, dword ptr [ebp+06*4], 08
	RMD160FF ecx, edx, esi, eax, ebx, dword ptr [ebp+02*4], 13
	RMD160FF ebx, ecx, edx, esi, eax, dword ptr [ebp+13*4], 06
	RMD160FF eax, ebx, ecx, edx, esi, dword ptr [ebp+14*4], 05
	RMD160FF esi, eax, ebx, ecx, edx, dword ptr [ebp+00*4], 15
	RMD160FF edx, esi, eax, ebx, ecx, dword ptr [ebp+03*4], 13
	RMD160FF ecx, edx, esi, eax, ebx, dword ptr [ebp+09*4], 11
	RMD160FF ebx, ecx, edx, esi, eax, dword ptr [ebp+11*4], 11
	;==========================================================
	mov ebp,offset RMD160Digest; update digest
	mov edi,[ebp+1*4]
    add esi,[esp+pushad_edx]
    add esi,[ebp+2*4]
    add eax,[esp+pushad_esi]
    add eax,[ebp+3*4]
    add ebx,[esp+pushad_eax]
    add ebx,[ebp+4*4]
	add	ecx,[esp+pushad_ebx]
	add ecx,[ebp+0*4]
    add edx,[esp+pushad_ecx]    
    add edx,edi
	mov [ebp+1*4],esi
	mov [ebp+2*4],eax
	mov [ebp+3*4],ebx
	mov [ebp+4*4],ecx
	mov [ebp+0*4],edx
	popad
	popad
	ret
RMD160Transform endp

RMD160BURN macro
	xor eax,eax
	mov RMD160Index,eax
	mov edi,Offset RMD160HashBuf
	mov ecx,(sizeof RMD160HashBuf)/4
	rep stosd
endm

align dword
RMD160Init proc uses edi
	xor eax, eax
	mov RMD160Len,eax
	RMD160BURN
	mov eax,offset RMD160Digest
	mov dword ptr [eax+0*4],067452301h
	mov dword ptr [eax+1*4],0EFCDAB89h
	mov dword ptr [eax+2*4],098BADCFEh
	mov dword ptr [eax+3*4],010325476h
	mov	dword ptr [eax+4*4],0C3D2E1F0h
	ret
RMD160Init endp

align dword
RMD160Update proc uses esi edi ebx lpBuffer:dword, dwBufLen:dword
	mov ebx,dwBufLen
	add RMD160Len,ebx
	.while ebx
		mov eax,RMD160Index
		mov edx,64
		sub edx,eax
		.if edx <= ebx
			lea edi, [RMD160HashBuf+eax]	
			mov esi, lpBuffer
			mov ecx, edx
			rep movsb
			sub ebx, edx
			add lpBuffer, edx
			call RMD160Transform
			RMD160BURN
		.else
			lea edi, [RMD160HashBuf+eax]	
			mov esi, lpBuffer
			mov ecx, ebx
			rep movsb
			mov eax, RMD160Index
			add eax, ebx
			mov RMD160Index,eax
			.break
		.endif
	.endw
	ret
RMD160Update endp

align dword
RMD160Final proc uses esi edi
	mov ecx, RMD160Index
	mov byte ptr [RMD160HashBuf+ecx],80h
	.if ecx >= 56
		call RMD160Transform
		RMD160BURN
	.endif
	mov eax,RMD160Len
	xor edx,edx
	shld edx,eax,3
	shl eax,3
	mov dword ptr [RMD160HashBuf+56],eax
	mov dword ptr [RMD160HashBuf+60],edx
	call RMD160Transform
	mov eax,offset RMD160Digest	
	ret
RMD160Final endp


