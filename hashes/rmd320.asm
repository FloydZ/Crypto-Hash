
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
RMD320HashBuf db 64 dup(?)
RMD320Len dd ?
RMD320Index dd ?
RMD320Digest dd 10 dup(?)

.code
RMD320FF macro dwA, dwB, dwC, dwD, dwE, locX, rolS
	mov edi,dwB
    xor edi,dwC
    xor edi,dwD
    add dwA,locX
    add dwA,edi
	rol dwA,rolS
	add dwA,dwE
	rol	dwC,10
endm
RMD320GG macro dwA, dwB, dwC, dwD, dwE, locX, rolS, constAC
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
RMD320HH macro dwA, dwB, dwC, dwD, dwE, locX, rolS, constAC
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
RMD320II macro dwA, dwB, dwC, dwD, dwE, locX, rolS, constAC
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
RMD320JJ macro dwA, dwB, dwC, dwD, dwE, locX, rolS, constAC
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
RMD320Transform proc
	pushad
	mov edi,offset RMD320Digest
	mov ebp,offset RMD320HashBuf	
	mov eax,[edi+0*4]
	mov ebx,[edi+1*4]
	mov ecx,[edi+2*4]
	mov edx,[edi+3*4]
	mov esi,[edi+4*4]
	;==========================================================
	RMD320FF eax, ebx, ecx, edx, esi, dword ptr [ebp+00*4], 11
	RMD320FF esi, eax, ebx, ecx, edx, dword ptr [ebp+01*4], 14
	RMD320FF edx, esi, eax, ebx, ecx, dword ptr [ebp+02*4], 15
	RMD320FF ecx, edx, esi, eax, ebx, dword ptr [ebp+03*4], 12
	RMD320FF ebx, ecx, edx, esi, eax, dword ptr [ebp+04*4], 05
	RMD320FF eax, ebx, ecx, edx, esi, dword ptr [ebp+05*4], 08
	RMD320FF esi, eax, ebx, ecx, edx, dword ptr [ebp+06*4], 07
	RMD320FF edx, esi, eax, ebx, ecx, dword ptr [ebp+07*4], 09
	RMD320FF ecx, edx, esi, eax, ebx, dword ptr [ebp+08*4], 11
	RMD320FF ebx, ecx, edx, esi, eax, dword ptr [ebp+09*4], 13
	RMD320FF eax, ebx, ecx, edx, esi, dword ptr [ebp+10*4], 14
	RMD320FF esi, eax, ebx, ecx, edx, dword ptr [ebp+11*4], 15
	RMD320FF edx, esi, eax, ebx, ecx, dword ptr [ebp+12*4], 06
	RMD320FF ecx, edx, esi, eax, ebx, dword ptr [ebp+13*4], 07
	RMD320FF ebx, ecx, edx, esi, eax, dword ptr [ebp+14*4], 09
	RMD320FF eax, ebx, ecx, edx, esi, dword ptr [ebp+15*4], 08
	;==========================================================
	mov edi,offset RMD320Digest
	pushad; store a..e 1
	mov eax,[edi+5*4];a2
	mov ebx,[edi+6*4];b2
	mov ecx,[edi+7*4];c2
	mov edx,[edi+8*4];d2
	mov esi,[edi+9*4];d2
	;======================================================================
	RMD320JJ eax, ebx, ecx, edx, esi, dword ptr [ebp+05*4], 08, 050a28be6h
	RMD320JJ esi, eax, ebx, ecx, edx, dword ptr [ebp+14*4], 09, 050a28be6h
	RMD320JJ edx, esi, eax, ebx, ecx, dword ptr [ebp+07*4], 09, 050a28be6h
	RMD320JJ ecx, edx, esi, eax, ebx, dword ptr [ebp+00*4], 11, 050a28be6h
	RMD320JJ ebx, ecx, edx, esi, eax, dword ptr [ebp+09*4], 13, 050a28be6h
	RMD320JJ eax, ebx, ecx, edx, esi, dword ptr [ebp+02*4], 15, 050a28be6h
	RMD320JJ esi, eax, ebx, ecx, edx, dword ptr [ebp+11*4], 15, 050a28be6h
	RMD320JJ edx, esi, eax, ebx, ecx, dword ptr [ebp+04*4], 05, 050a28be6h
	RMD320JJ ecx, edx, esi, eax, ebx, dword ptr [ebp+13*4], 07, 050a28be6h
	RMD320JJ ebx, ecx, edx, esi, eax, dword ptr [ebp+06*4], 07, 050a28be6h
	RMD320JJ eax, ebx, ecx, edx, esi, dword ptr [ebp+15*4], 08, 050a28be6h
	RMD320JJ esi, eax, ebx, ecx, edx, dword ptr [ebp+08*4], 11, 050a28be6h
	RMD320JJ edx, esi, eax, ebx, ecx, dword ptr [ebp+01*4], 14, 050a28be6h
	RMD320JJ ecx, edx, esi, eax, ebx, dword ptr [ebp+10*4], 14, 050a28be6h
	RMD320JJ ebx, ecx, edx, esi, eax, dword ptr [ebp+03*4], 12, 050a28be6h
	RMD320JJ eax, ebx, ecx, edx, esi, dword ptr [ebp+12*4], 06, 050a28be6h
	;======================================================================
	mov edi,[esp+pushad_eax]
	mov [esp+pushad_eax],eax
	mov eax,edi
;	xchg eax,[esp+pushad_eax]
	pushad;store a..d 2
	mov eax,[esp+pushad_size+pushad_eax];a1
	mov ebx,[esp+pushad_size+pushad_ebx];b1
	mov ecx,[esp+pushad_size+pushad_ecx];c1
	mov edx,[esp+pushad_size+pushad_edx];d1
	mov esi,[esp+pushad_size+pushad_esi];d1
	;======================================================================
	RMD320GG esi, eax, ebx, ecx, edx, dword ptr [ebp+07*4], 07, 05a827999h
	RMD320GG edx, esi, eax, ebx, ecx, dword ptr [ebp+04*4], 06, 05a827999h
	RMD320GG ecx, edx, esi, eax, ebx, dword ptr [ebp+13*4], 08, 05a827999h
	RMD320GG ebx, ecx, edx, esi, eax, dword ptr [ebp+01*4], 13, 05a827999h
	RMD320GG eax, ebx, ecx, edx, esi, dword ptr [ebp+10*4], 11, 05a827999h
	RMD320GG esi, eax, ebx, ecx, edx, dword ptr [ebp+06*4], 09, 05a827999h
	RMD320GG edx, esi, eax, ebx, ecx, dword ptr [ebp+15*4], 07, 05a827999h
	RMD320GG ecx, edx, esi, eax, ebx, dword ptr [ebp+03*4], 15, 05a827999h
	RMD320GG ebx, ecx, edx, esi, eax, dword ptr [ebp+12*4], 07, 05a827999h
	RMD320GG eax, ebx, ecx, edx, esi, dword ptr [ebp+00*4], 12, 05a827999h
	RMD320GG esi, eax, ebx, ecx, edx, dword ptr [ebp+09*4], 15, 05a827999h
	RMD320GG edx, esi, eax, ebx, ecx, dword ptr [ebp+05*4], 09, 05a827999h
	RMD320GG ecx, edx, esi, eax, ebx, dword ptr [ebp+02*4], 11, 05a827999h
	RMD320GG ebx, ecx, edx, esi, eax, dword ptr [ebp+14*4], 07, 05a827999h
	RMD320GG eax, ebx, ecx, edx, esi, dword ptr [ebp+11*4], 13, 05a827999h
	RMD320GG esi, eax, ebx, ecx, edx, dword ptr [ebp+08*4], 12, 05a827999h
	;======================================================================
	mov [esp+pushad_size+pushad_eax],eax;a1
	mov [esp+pushad_size+pushad_ebx],ebx;b1
	mov [esp+pushad_size+pushad_ecx],ecx;c1
	mov [esp+pushad_size+pushad_edx],edx;d1
	mov [esp+pushad_size+pushad_esi],esi;d1
	mov eax,[esp+pushad_eax];a2
	mov ebx,[esp+pushad_ebx];b2
	mov ecx,[esp+pushad_ecx];c2
	mov edx,[esp+pushad_edx];d2
	mov esi,[esp+pushad_esi];d2
	;======================================================================
	RMD320II esi, eax, ebx, ecx, edx, dword ptr [ebp+06*4], 09, 05c4dd124h
	RMD320II edx, esi, eax, ebx, ecx, dword ptr [ebp+11*4], 13, 05c4dd124h
	RMD320II ecx, edx, esi, eax, ebx, dword ptr [ebp+03*4], 15, 05c4dd124h
	RMD320II ebx, ecx, edx, esi, eax, dword ptr [ebp+07*4], 07, 05c4dd124h
	RMD320II eax, ebx, ecx, edx, esi, dword ptr [ebp+00*4], 12, 05c4dd124h
	RMD320II esi, eax, ebx, ecx, edx, dword ptr [ebp+13*4], 08, 05c4dd124h
	RMD320II edx, esi, eax, ebx, ecx, dword ptr [ebp+05*4], 09, 05c4dd124h
	RMD320II ecx, edx, esi, eax, ebx, dword ptr [ebp+10*4], 11, 05c4dd124h
	RMD320II ebx, ecx, edx, esi, eax, dword ptr [ebp+14*4], 07, 05c4dd124h
	RMD320II eax, ebx, ecx, edx, esi, dword ptr [ebp+15*4], 07, 05c4dd124h
	RMD320II esi, eax, ebx, ecx, edx, dword ptr [ebp+08*4], 12, 05c4dd124h
	RMD320II edx, esi, eax, ebx, ecx, dword ptr [ebp+12*4], 07, 05c4dd124h
	RMD320II ecx, edx, esi, eax, ebx, dword ptr [ebp+04*4], 06, 05c4dd124h
	RMD320II ebx, ecx, edx, esi, eax, dword ptr [ebp+09*4], 15, 05c4dd124h
	RMD320II eax, ebx, ecx, edx, esi, dword ptr [ebp+01*4], 13, 05c4dd124h
	RMD320II esi, eax, ebx, ecx, edx, dword ptr [ebp+02*4], 11, 05c4dd124h
	;======================================================================
	mov edi,[esp+pushad_size+pushad_ebx]
	mov [esp+pushad_size+pushad_ebx],ebx
	mov ebx,edi
;	xchg ebx,[esp+pushad_size+pushad_ebx]
	mov [esp+pushad_eax],eax;a2
	mov [esp+pushad_ebx],ebx;b2
	mov [esp+pushad_ecx],ecx;c2
	mov [esp+pushad_edx],edx;d2
	mov [esp+pushad_esi],esi;d2
	mov eax,[esp+pushad_size+pushad_eax];a1
	mov ebx,[esp+pushad_size+pushad_ebx];b1
	mov ecx,[esp+pushad_size+pushad_ecx];c1
	mov edx,[esp+pushad_size+pushad_edx];d1
	mov esi,[esp+pushad_size+pushad_esi];d1
	;======================================================================
	RMD320HH edx, esi, eax, ebx, ecx, dword ptr [ebp+03*4], 11, 06ed9eba1h
	RMD320HH ecx, edx, esi, eax, ebx, dword ptr [ebp+10*4], 13, 06ed9eba1h
	RMD320HH ebx, ecx, edx, esi, eax, dword ptr [ebp+14*4], 06, 06ed9eba1h
	RMD320HH eax, ebx, ecx, edx, esi, dword ptr [ebp+04*4], 07, 06ed9eba1h
	RMD320HH esi, eax, ebx, ecx, edx, dword ptr [ebp+09*4], 14, 06ed9eba1h
	RMD320HH edx, esi, eax, ebx, ecx, dword ptr [ebp+15*4], 09, 06ed9eba1h
	RMD320HH ecx, edx, esi, eax, ebx, dword ptr [ebp+08*4], 13, 06ed9eba1h
	RMD320HH ebx, ecx, edx, esi, eax, dword ptr [ebp+01*4], 15, 06ed9eba1h
	RMD320HH eax, ebx, ecx, edx, esi, dword ptr [ebp+02*4], 14, 06ed9eba1h
	RMD320HH esi, eax, ebx, ecx, edx, dword ptr [ebp+07*4], 08, 06ed9eba1h
	RMD320HH edx, esi, eax, ebx, ecx, dword ptr [ebp+00*4], 13, 06ed9eba1h
	RMD320HH ecx, edx, esi, eax, ebx, dword ptr [ebp+06*4], 06, 06ed9eba1h
	RMD320HH ebx, ecx, edx, esi, eax, dword ptr [ebp+13*4], 05, 06ed9eba1h
	RMD320HH eax, ebx, ecx, edx, esi, dword ptr [ebp+11*4], 12, 06ed9eba1h
	RMD320HH esi, eax, ebx, ecx, edx, dword ptr [ebp+05*4], 07, 06ed9eba1h
	RMD320HH edx, esi, eax, ebx, ecx, dword ptr [ebp+12*4], 05, 06ed9eba1h
	;======================================================================
	mov [esp+pushad_size+pushad_eax],eax;a1
	mov [esp+pushad_size+pushad_ebx],ebx;b1
	mov [esp+pushad_size+pushad_ecx],ecx;c1
	mov [esp+pushad_size+pushad_edx],edx;d1
	mov [esp+pushad_size+pushad_esi],esi;d1
	mov eax,[esp+pushad_eax];a2
	mov ebx,[esp+pushad_ebx];b2
	mov ecx,[esp+pushad_ecx];c2
	mov edx,[esp+pushad_edx];d2
	mov esi,[esp+pushad_esi];d2
	;======================================================================
	RMD320HH edx, esi, eax, ebx, ecx, dword ptr [ebp+15*4], 09, 06d703ef3h
	RMD320HH ecx, edx, esi, eax, ebx, dword ptr [ebp+05*4], 07, 06d703ef3h
	RMD320HH ebx, ecx, edx, esi, eax, dword ptr [ebp+01*4], 15, 06d703ef3h
	RMD320HH eax, ebx, ecx, edx, esi, dword ptr [ebp+03*4], 11, 06d703ef3h
	RMD320HH esi, eax, ebx, ecx, edx, dword ptr [ebp+07*4], 08, 06d703ef3h
	RMD320HH edx, esi, eax, ebx, ecx, dword ptr [ebp+14*4], 06, 06d703ef3h
	RMD320HH ecx, edx, esi, eax, ebx, dword ptr [ebp+06*4], 06, 06d703ef3h
	RMD320HH ebx, ecx, edx, esi, eax, dword ptr [ebp+09*4], 14, 06d703ef3h
	RMD320HH eax, ebx, ecx, edx, esi, dword ptr [ebp+11*4], 12, 06d703ef3h
	RMD320HH esi, eax, ebx, ecx, edx, dword ptr [ebp+08*4], 13, 06d703ef3h
	RMD320HH edx, esi, eax, ebx, ecx, dword ptr [ebp+12*4], 05, 06d703ef3h
	RMD320HH ecx, edx, esi, eax, ebx, dword ptr [ebp+02*4], 14, 06d703ef3h
	RMD320HH ebx, ecx, edx, esi, eax, dword ptr [ebp+10*4], 13, 06d703ef3h
	RMD320HH eax, ebx, ecx, edx, esi, dword ptr [ebp+00*4], 13, 06d703ef3h
	RMD320HH esi, eax, ebx, ecx, edx, dword ptr [ebp+04*4], 07, 06d703ef3h
	RMD320HH edx, esi, eax, ebx, ecx, dword ptr [ebp+13*4], 05, 06d703ef3h
	;======================================================================
	mov edi,[esp+pushad_size+pushad_ecx]
	mov [esp+pushad_size+pushad_ecx],ecx
	mov ecx,edi
;	xchg ecx,[esp+pushad_size+pushad_ecx]
	mov [esp+pushad_eax],eax;a2
	mov [esp+pushad_ebx],ebx;b2
	mov [esp+pushad_ecx],ecx;c2
	mov [esp+pushad_edx],edx;d2
	mov [esp+pushad_esi],esi;d2
	mov eax,[esp+pushad_size+pushad_eax];a1
	mov ebx,[esp+pushad_size+pushad_ebx];b1
	mov ecx,[esp+pushad_size+pushad_ecx];c1
	mov edx,[esp+pushad_size+pushad_edx];d1
	mov esi,[esp+pushad_size+pushad_esi];d1
	;======================================================================
	RMD320II ecx, edx, esi, eax, ebx, dword ptr [ebp+01*4], 11, 08f1bbcdch
	RMD320II ebx, ecx, edx, esi, eax, dword ptr [ebp+09*4], 12, 08f1bbcdch
	RMD320II eax, ebx, ecx, edx, esi, dword ptr [ebp+11*4], 14, 08f1bbcdch
	RMD320II esi, eax, ebx, ecx, edx, dword ptr [ebp+10*4], 15, 08f1bbcdch
	RMD320II edx, esi, eax, ebx, ecx, dword ptr [ebp+00*4], 14, 08f1bbcdch
	RMD320II ecx, edx, esi, eax, ebx, dword ptr [ebp+08*4], 15, 08f1bbcdch
	RMD320II ebx, ecx, edx, esi, eax, dword ptr [ebp+12*4], 09, 08f1bbcdch
	RMD320II eax, ebx, ecx, edx, esi, dword ptr [ebp+04*4], 08, 08f1bbcdch
	RMD320II esi, eax, ebx, ecx, edx, dword ptr [ebp+13*4], 09, 08f1bbcdch
	RMD320II edx, esi, eax, ebx, ecx, dword ptr [ebp+03*4], 14, 08f1bbcdch
	RMD320II ecx, edx, esi, eax, ebx, dword ptr [ebp+07*4], 05, 08f1bbcdch
	RMD320II ebx, ecx, edx, esi, eax, dword ptr [ebp+15*4], 06, 08f1bbcdch
	RMD320II eax, ebx, ecx, edx, esi, dword ptr [ebp+14*4], 08, 08f1bbcdch
	RMD320II esi, eax, ebx, ecx, edx, dword ptr [ebp+05*4], 06, 08f1bbcdch
	RMD320II edx, esi, eax, ebx, ecx, dword ptr [ebp+06*4], 05, 08f1bbcdch
	RMD320II ecx, edx, esi, eax, ebx, dword ptr [ebp+02*4], 12, 08f1bbcdch
	;======================================================================
	mov [esp+pushad_size+pushad_eax],eax;a1
	mov [esp+pushad_size+pushad_ebx],ebx;b1
	mov [esp+pushad_size+pushad_ecx],ecx;c1
	mov [esp+pushad_size+pushad_edx],edx;d1
	mov [esp+pushad_size+pushad_esi],esi;d1
	mov eax,[esp+pushad_eax];a2
	mov ebx,[esp+pushad_ebx];b2
	mov ecx,[esp+pushad_ecx];c2
	mov edx,[esp+pushad_edx];d2
	mov esi,[esp+pushad_esi];d2
	;======================================================================
	RMD320GG ecx, edx, esi, eax, ebx, dword ptr [ebp+08*4], 15, 07a6d76e9h
	RMD320GG ebx, ecx, edx, esi, eax, dword ptr [ebp+06*4], 05, 07a6d76e9h
	RMD320GG eax, ebx, ecx, edx, esi, dword ptr [ebp+04*4], 08, 07a6d76e9h
	RMD320GG esi, eax, ebx, ecx, edx, dword ptr [ebp+01*4], 11, 07a6d76e9h
	RMD320GG edx, esi, eax, ebx, ecx, dword ptr [ebp+03*4], 14, 07a6d76e9h
	RMD320GG ecx, edx, esi, eax, ebx, dword ptr [ebp+11*4], 14, 07a6d76e9h
	RMD320GG ebx, ecx, edx, esi, eax, dword ptr [ebp+15*4], 06, 07a6d76e9h
	RMD320GG eax, ebx, ecx, edx, esi, dword ptr [ebp+00*4], 14, 07a6d76e9h
	RMD320GG esi, eax, ebx, ecx, edx, dword ptr [ebp+05*4], 06, 07a6d76e9h
	RMD320GG edx, esi, eax, ebx, ecx, dword ptr [ebp+12*4], 09, 07a6d76e9h
	RMD320GG ecx, edx, esi, eax, ebx, dword ptr [ebp+02*4], 12, 07a6d76e9h
	RMD320GG ebx, ecx, edx, esi, eax, dword ptr [ebp+13*4], 09, 07a6d76e9h
	RMD320GG eax, ebx, ecx, edx, esi, dword ptr [ebp+09*4], 12, 07a6d76e9h
	RMD320GG esi, eax, ebx, ecx, edx, dword ptr [ebp+07*4], 05, 07a6d76e9h
	RMD320GG edx, esi, eax, ebx, ecx, dword ptr [ebp+10*4], 15, 07a6d76e9h
	RMD320GG ecx, edx, esi, eax, ebx, dword ptr [ebp+14*4], 08, 07a6d76e9h
	;======================================================================
	mov edi,[esp+pushad_size+pushad_edx]
	mov [esp+pushad_size+pushad_edx],edx
	mov edx,edi
;	xchg edx,[esp+pushad_size+pushad_edx]
	mov [esp+pushad_eax],eax;a2
	mov [esp+pushad_ebx],ebx;b2
	mov [esp+pushad_ecx],ecx;c2
	mov [esp+pushad_edx],edx;d2
	mov [esp+pushad_esi],esi;d2
	mov eax,[esp+pushad_size+pushad_eax];a1
	mov ebx,[esp+pushad_size+pushad_ebx];b1
	mov ecx,[esp+pushad_size+pushad_ecx];c1
	mov edx,[esp+pushad_size+pushad_edx];d1
	mov esi,[esp+pushad_size+pushad_esi];d1
	;======================================================================
	RMD320JJ ebx, ecx, edx, esi, eax, dword ptr [ebp+04*4], 09, 0a953fd4eh
	RMD320JJ eax, ebx, ecx, edx, esi, dword ptr [ebp+00*4], 15, 0a953fd4eh
	RMD320JJ esi, eax, ebx, ecx, edx, dword ptr [ebp+05*4], 05, 0a953fd4eh
	RMD320JJ edx, esi, eax, ebx, ecx, dword ptr [ebp+09*4], 11, 0a953fd4eh
	RMD320JJ ecx, edx, esi, eax, ebx, dword ptr [ebp+07*4], 06, 0a953fd4eh
	RMD320JJ ebx, ecx, edx, esi, eax, dword ptr [ebp+12*4], 08, 0a953fd4eh
	RMD320JJ eax, ebx, ecx, edx, esi, dword ptr [ebp+02*4], 13, 0a953fd4eh
	RMD320JJ esi, eax, ebx, ecx, edx, dword ptr [ebp+10*4], 12, 0a953fd4eh
	RMD320JJ edx, esi, eax, ebx, ecx, dword ptr [ebp+14*4], 05, 0a953fd4eh
	RMD320JJ ecx, edx, esi, eax, ebx, dword ptr [ebp+01*4], 12, 0a953fd4eh
	RMD320JJ ebx, ecx, edx, esi, eax, dword ptr [ebp+03*4], 13, 0a953fd4eh
	RMD320JJ eax, ebx, ecx, edx, esi, dword ptr [ebp+08*4], 14, 0a953fd4eh
	RMD320JJ esi, eax, ebx, ecx, edx, dword ptr [ebp+11*4], 11, 0a953fd4eh
	RMD320JJ edx, esi, eax, ebx, ecx, dword ptr [ebp+06*4], 08, 0a953fd4eh
	RMD320JJ ecx, edx, esi, eax, ebx, dword ptr [ebp+15*4], 05, 0a953fd4eh
	RMD320JJ ebx, ecx, edx, esi, eax, dword ptr [ebp+13*4], 06, 0a953fd4eh
	;======================================================================
	mov [esp+pushad_size+pushad_eax],eax;a1
	mov [esp+pushad_size+pushad_ebx],ebx;b1
	mov [esp+pushad_size+pushad_ecx],ecx;c1
	mov [esp+pushad_size+pushad_edx],edx;d1
	mov [esp+pushad_size+pushad_esi],esi;d1
	mov eax,[esp+pushad_eax];a2
	mov ebx,[esp+pushad_ebx];b2
	mov ecx,[esp+pushad_ecx];c2
	mov edx,[esp+pushad_edx];d2
	mov esi,[esp+pushad_esi];d2
	;==========================================================
	RMD320FF ebx, ecx, edx, esi, eax, dword ptr [ebp+12*4], 08
	RMD320FF eax, ebx, ecx, edx, esi, dword ptr [ebp+15*4], 05
	RMD320FF esi, eax, ebx, ecx, edx, dword ptr [ebp+10*4], 12
	RMD320FF edx, esi, eax, ebx, ecx, dword ptr [ebp+04*4], 09
	RMD320FF ecx, edx, esi, eax, ebx, dword ptr [ebp+01*4], 12
	RMD320FF ebx, ecx, edx, esi, eax, dword ptr [ebp+05*4], 05
	RMD320FF eax, ebx, ecx, edx, esi, dword ptr [ebp+08*4], 14
	RMD320FF esi, eax, ebx, ecx, edx, dword ptr [ebp+07*4], 06
	RMD320FF edx, esi, eax, ebx, ecx, dword ptr [ebp+06*4], 08
	RMD320FF ecx, edx, esi, eax, ebx, dword ptr [ebp+02*4], 13
	RMD320FF ebx, ecx, edx, esi, eax, dword ptr [ebp+13*4], 06
	RMD320FF eax, ebx, ecx, edx, esi, dword ptr [ebp+14*4], 05
	RMD320FF esi, eax, ebx, ecx, edx, dword ptr [ebp+00*4], 15
	RMD320FF edx, esi, eax, ebx, ecx, dword ptr [ebp+03*4], 13
	RMD320FF ecx, edx, esi, eax, ebx, dword ptr [ebp+09*4], 11
	RMD320FF ebx, ecx, edx, esi, eax, dword ptr [ebp+11*4], 11
	;==========================================================
	mov edi,[esp+pushad_size+pushad_esi]
	mov [esp+pushad_size+pushad_esi],esi
	mov esi,edi
;	xchg esi,[esp+pushad_size+pushad_esi];b1<-->b2
	mov ebp,offset RMD320Digest
	add [ebp+5*4],eax
	add [ebp+6*4],ebx
	add [ebp+7*4],ecx
	add [ebp+8*4],edx
	add [ebp+9*4],esi
	popad
	popad
	mov ebp,offset RMD320Digest
	add [ebp+0*4],eax
	add [ebp+1*4],ebx
	add [ebp+2*4],ecx
	add [ebp+3*4],edx
	add [ebp+4*4],esi
	popad
	ret
RMD320Transform endp

RMD320BURN macro
	xor eax,eax
	mov RMD320Index,eax
	mov edi,Offset RMD320HashBuf
	mov ecx,(sizeof RMD320HashBuf)/4
	rep stosd
endm

align dword
RMD320Init proc uses edi
	xor eax, eax
	mov RMD320Len,eax
	RMD320BURN
	mov eax,offset RMD320Digest
	mov dword ptr [eax+0*4],067452301h
	mov dword ptr [eax+1*4],0EFCDAB89h
	mov dword ptr [eax+2*4],098BADCFEh
	mov dword ptr [eax+3*4],010325476h
	mov	dword ptr [eax+4*4],0C3D2E1F0h
	mov dword ptr [eax+5*4],076543210h
	mov dword ptr [eax+6*4],0FEDCBA98h
	mov dword ptr [eax+7*4],089ABCDEFh
	mov dword ptr [eax+8*4],001234567h
	mov	dword ptr [eax+9*4],03C2D1E0Fh
	ret
RMD320Init endp

align dword
RMD320Update proc uses esi edi ebx lpBuffer:dword, dwBufLen:dword
	mov ebx,dwBufLen
	add RMD320Len,ebx
	.while ebx
		mov eax,RMD320Index
		mov edx,64
		sub edx,eax
		.if edx <= ebx
			lea edi, [RMD320HashBuf+eax]	
			mov esi, lpBuffer
			mov ecx, edx
			rep movsb
			sub ebx, edx
			add lpBuffer, edx
			call RMD320Transform
			RMD320BURN
		.else
			lea edi, [RMD320HashBuf+eax]	
			mov esi, lpBuffer
			mov ecx, ebx
			rep movsb
			mov eax, RMD320Index
			add eax, ebx
			mov RMD320Index,eax
			.break
		.endif
	.endw
	ret
RMD320Update endp

align dword
RMD320Final proc uses esi edi
	mov ecx, RMD320Index
	mov byte ptr [RMD320HashBuf+ecx],80h
	.if ecx >= 56
		call RMD320Transform
		RMD320BURN
	.endif
	mov eax,RMD320Len
	xor edx,edx
	shld edx,eax,3
	shl eax,3
	mov dword ptr [RMD320HashBuf+56],eax
	mov dword ptr [RMD320HashBuf+60],edx
	call RMD320Transform
	mov eax,offset RMD320Digest
	ret
RMD320Final endp


