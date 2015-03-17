; data = 8 (64-bit)
; keylen = 1..128
; 


RC2Init proto :DWORD,:DWORD
RC2Encrypt proto :DWORD,:DWORD
RC2Decrypt proto :DWORD,:DWORD

.data
align 4
sBox label byte
db 217,120,249,196, 25,221,181,237, 40,233,253,121, 74,160,216,157
db 198,126, 55,131, 43,118, 83,142, 98, 76,100,136, 68,139,251,162
db  23,154, 89,245,135,179, 79, 19, 97, 69,109,141,  9,129,125, 50
db 189,143, 64,235,134,183,123, 11,240,149, 33, 34, 92,107, 78,130
db  84,214,101,147,206, 96,178, 28,115, 86,192, 20,167,140,241,220
db  18,117,202, 31, 59,190,228,209, 66, 61,212, 48,163, 60,182, 38
db 111,191, 14,218, 70,105,  7, 87, 39,242, 29,155,188,148, 67,  3
db 248, 17,199,246,144,239, 62,231,  6,195,213, 47,200,102, 30,215
db   8,232,234,222,128, 82,238,247,132,170,114,172, 53, 77,106, 42
db 150, 26,210,113, 90, 21, 73,116, 75,159,208, 94,  4, 24,164,236
db 194,224, 65,110, 15, 81,203,204, 36,145,175, 80,161,244,112, 57
db 153,124, 58,133, 35,184,180,122,252,  2, 54, 91, 37, 85,151, 49
db  45, 93,250,152,227,138,146,174,  5,223, 41, 16,103,108,186,201
db 211,  0,230,207,225,158,168, 44, 99, 22,  1, 63, 88,226,137,169
db  13, 56, 52, 27,171, 51,255,176,187, 72, 12, 95,185,177,205, 46
db 197,243,219, 71,229,165,156,119, 10,166, 32,104,254,127,193,173

.data?
align 4
rc2_key db 128 dup(?)
	
.code

align 4
RC2Init proc uses esi edi ebx pKey,dwKeyLen
LOCAL KeyB[128]:byte
	lea edi,KeyB
	xor eax,eax
	mov ecx,128/4
	rep stosd

	mov esi,pKey
	lea edi,KeyB
	mov ecx,dwKeyLen
	rep movsb
	
	mov ecx,dwKeyLen
	.while ecx<128
		mov edx,ecx
		sub edx,dwKeyLen
		movzx eax,KeyB[edx]
		lea edx,[ecx-1]
		movzx edx,KeyB[edx]
		add edx,eax
		and edx,0ffh
		mov al,[sBox+edx]
		mov KeyB[ecx],al
		inc ecx
	.endw
	movzx edx,KeyB[0]
	mov al,[sBox+edx]
	mov KeyB[0],al
	lea esi,KeyB
	lea edi,rc2_key
	mov ecx,128/4
	rep movsd
	ret
RC2Init endp

RC2RE macro r0,r1,r2,r3,ki,rot
	mov ebx,R[r2*4]
	mov ecx,R[r3*4]
	mov eax,R[r1*4]
	and ebx,ecx
	movzx edx,word ptr [rc2_key+esi*8+ki*2]
	xor ecx,0FFFFh
	add edx,ebx
	and eax,ecx
	add edx,R[r0*4]
	add edx,eax
	and edx,0FFFFh; cut overflow
	rol dx,rot
	mov R[r0*4],edx
endm

align 4
RC2Encrypt proc uses esi edi ebx pBlockIn:DWORD,pBlockOut:DWORD
	rc2_locals equ 4*4
	R equ dword ptr [esp]
	sub esp,rc2_locals
	mov esi,pBlockIn
	movzx eax,word ptr[esi+0*2]
	movzx ebx,word ptr[esi+1*2]
	movzx ecx,word ptr[esi+2*2]
	movzx edx,word ptr[esi+3*2]
	mov R[0*4],eax
	mov R[1*4],ebx
	mov R[2*4],ecx
	mov R[3*4],edx
	xor esi,esi
@@RC2Enc:
	RC2RE 0,1,2,3, 0, 1
	RC2RE 1,2,3,0, 1, 2
	RC2RE 2,3,0,1, 2, 3
	RC2RE 3,0,1,2, 3, 5
	inc esi
	cmp esi,16
	je @@Break
	cmp esi,5
	je @F
	cmp esi,11
	jne @@RC2Enc
@@:	mov eax,R[3*4]
	and eax,63
	movzx ebx,word ptr rc2_key[eax*2]
	add ebx,R[0*4]
	mov R[0*4],ebx
	and ebx,63
	movzx ecx,word ptr rc2_key[ebx*2]
	add ecx,R[1*4]
	mov R[1*4],ecx
	and ecx,63
	movzx edx,word ptr rc2_key[ecx*2]
	add edx,R[2*4]
	mov R[2*4],edx
	and edx,63
	movzx eax,word ptr rc2_key[edx*2]
	add R[3*4],eax
	jmp @@RC2Enc
@@Break:
	mov edi,pBlockOut
	mov eax,R[0*4]
	mov ebx,R[1*4]
	mov ecx,R[2*4]
	mov edx,R[3*4]
	mov [edi+0*2],ax
	mov [edi+1*2],bx
	mov [edi+2*2],cx
	mov [edi+3*2],dx
	add esp,rc2_locals
	ret
RC2Encrypt endp


RC2RD macro r0,r1,r2,r3,ki,rot
           ; 3, 0, 1, 2, 3  5
	mov edx,R[r0*4]
	mov ecx,R[r3*4]
	ror dx,rot
	mov eax,R[r2*4]
	mov ebx,R[r1*4]
	and eax,ecx
	xor ecx,0FFFFh
	and ebx,ecx
	sub dx,ax
	sub dx,bx
	sub dx,word ptr [rc2_key+esi*8+ki*2]
	mov R[r0*4],edx
endm
	
align 4
RC2Decrypt proc uses esi edi ebx pBlockIn:DWORD,pBlockOut:DWORD
	rc2_locals equ 4*4
	R equ dword ptr [esp]
	sub esp,rc2_locals
	mov esi,pBlockIn
	
	movzx eax,word ptr[esi+0*2]
	movzx ebx,word ptr[esi+1*2]
	movzx ecx,word ptr[esi+2*2]
	movzx edx,word ptr[esi+3*2]
	mov R[0*4],eax
	mov R[1*4],ebx
	mov R[2*4],ecx
	mov R[3*4],edx
	
	mov esi,15
@@RC2Enc:
	RC2RD 3,0,1,2, 3, 5
	RC2RD 2,3,0,1, 2, 3
	RC2RD 1,2,3,0, 1, 2
	RC2RD 0,1,2,3, 0, 1
	dec esi
	js @@Break
	cmp esi,4
	je @F
	cmp esi,10
	jne @@RC2Enc
@@:	mov eax,R[2*4]
	mov ecx,R[3*4]
	and eax,63
	movzx eax,word ptr rc2_key[eax*2]
	sub ecx,eax
	and ecx,0FFFFh
	mov R[3*4],ecx
	mov eax,R[1*4]
	mov ecx,R[2*4]
	and eax,63
	movzx eax,word ptr rc2_key[eax*2]
	sub ecx,eax
	and ecx,0FFFFh
	mov R[2*4],ecx
	mov eax,R[0*4]
	mov ecx,R[1*4]
	and eax,63
	movzx eax,word ptr rc2_key[eax*2]
	sub ecx,eax
	and ecx,0FFFFh
	mov R[1*4],ecx
	mov eax,R[3*4]
	mov ecx,R[0*4]
	and eax,63
	movzx eax,word ptr rc2_key[eax*2]
	sub ecx,eax
	and ecx,0FFFFh
	mov R[0*4],ecx
	jmp @@RC2Enc
@@Break:
	mov edi,pBlockOut
	mov eax,R[0*4]
	mov ebx,R[1*4]
	mov ecx,R[2*4]
	mov edx,R[3*4]
	mov [edi+0*2],ax
	mov [edi+1*2],bx
	mov [edi+2*2],cx
	mov [edi+3*2],dx
	add esp,rc2_locals
	ret
RC2Decrypt endp

	