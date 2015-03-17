
.data
MD2pi_subst label dword
db  41, 46, 67,201,162,216,124,  1, 61, 54, 84,161,236,240,  6, 19
db  98,167,  5,243,192,199,115,140,152,147, 43,217,188, 76,130,202
db  30,155, 87, 60,253,212,224, 22,103, 66,111, 24,138, 23,229, 18
db 190, 78,196,214,218,158,222, 73,160,251,245,142,187, 47,238,122
db 169,104,121,145, 21,178,  7, 63,148,194, 16,137, 11, 34, 95, 33
db 128,127, 93,154, 90,144, 50, 39, 53, 62,204,231,191,247,151,  3
db 255, 25, 48,179, 72,165,181,209,215, 94,146, 42,172, 86,170,198
db  79,184, 56,210,150,164,125,182,118,252,107,226,156,116,  4,241
db  69,157,112, 89,100,113,135, 32,134, 91,207,101,230, 45,168,  2
db	27, 96, 37,173,174,176,185,246, 28, 70, 97,105, 52, 64,126, 15
db  85, 71,163, 35,221, 81,175, 58,195, 92,249,206,186,197,234, 38
db  44, 83, 13,110,133, 40,132,  9,211,223,205,244, 65,129, 77, 82
db 106,220, 55,200,108,193,171,250, 36,225,123,  8, 12,189,177, 74
db 120,136,149,139,227, 99,232,109,233,203,213,254, 59,  0, 29, 57
db 242,239,183, 14,102, 88,208,228,166,119,114,248,235,117, 75, 10
db  49, 68, 80,180,143,237, 31, 26,219,153,141, 51,159, 17,131, 20

.data?
; Digest           - 16 bytes
; Transform Buffer - 32 bytes
; Checksum         - 16 bytes
MD2HashBuf db 64 dup(?)
			dd ?
MD2Len dd ?

.code
align dword
MD2Transform proc
	pushad
	mov ebp,offset MD2HashBuf
	sub esp,4
	Tmp equ dword ptr [esp]
	mov eax,[ebp+16+0*4]
	mov ebx,[ebp+16+1*4]
	mov ecx,[ebp+16+2*4]
	mov edx,[ebp+16+3*4]
	xor eax,[ebp+0*4]
	xor ebx,[ebp+1*4]
	xor ecx,[ebp+2*4]
	xor edx,[ebp+3*4]
	mov [ebp+32+0*4],eax
	mov [ebp+32+1*4],ebx
	mov [ebp+32+2*4],ecx
	mov [ebp+32+3*4],edx
	movzx edx,byte ptr [ebp+63]
	mov edi,-24
	.repeat
	MD21 macro ii
		movzx ecx,byte ptr [ebp+edi+24+16+ii]
		movzx eax,byte ptr [ebp+edi+24+16+32+ii]
		xor edx,ecx
		movzx ebx,byte ptr [MD2pi_subst+edx]
		xor eax,ebx
		mov [ebp+edi+24+16+32+ii],al
		mov edx,eax
	endm
		MD21 0
		MD21 1
		MD21 2
		MD21 3
		add edi,4
	.until ZERO?
	xor eax,eax
	mov esi,offset MD2HashBuf
	xor edx,edx
	mov ebp,-48
	.repeat
		.repeat
		MD22 macro ii
			movzx ebx,byte ptr [esi+ebp+48+ii]
			movzx eax,byte ptr [MD2pi_subst+eax]
			xor eax,ebx
			mov [esi+ebp+48+ii],al
		endm
			MD22 0
			MD22 1
			MD22 2
			MD22 3
			add ebp,4
		.until ZERO?
		add eax,edx
		inc edx
		and eax,0FFh
		cmp edx,18
		mov ebp,-48
	.until ZERO?
	add esp,4
	popad
	ret
MD2Transform endp

align dword
MD2Init proc uses edi
	xor eax, eax
	mov MD2Len,eax
	mov edi,offset MD2HashBuf
	mov ecx,(sizeof MD2HashBuf)/4
	rep stosd
	mov eax,offset MD2HashBuf
	ret
MD2Init endp

align dword
MD2Update proc uses esi edi ebx lpBuffer:dword, dwBufLen:dword
	mov ebx,dwBufLen
	mov esi,lpBuffer
	.while ebx
		mov eax,MD2Len
		mov edx,16
		sub edx,eax
		.if ebx<edx
			mov edx,ebx
		.endif 
		lea edi,[MD2HashBuf+eax+16]	
		mov ecx,edx
		rep movsb
		sub ebx,edx
		add eax,edx
		.if eax == 16
			call MD2Transform
			xor eax,eax
		.endif
		mov MD2Len,eax
	.endw
	ret
MD2Update endp

align dword
MD2Final proc uses esi edi
	mov eax,MD2Len
	mov edx,16
	sub edx,eax
	lea edi,[MD2HashBuf+eax+16]	
	and edx,0FFh
	mov eax,edx
	mov ecx,edx
	rep stosb
	call MD2Transform
	mov esi,offset [MD2HashBuf+48];Checksum
	mov edi,offset [MD2HashBuf+16];Buffer
	mov ecx,16
	rep movsb
	call MD2Transform
	mov eax,offset MD2HashBuf	
	ret
MD2Final endp

