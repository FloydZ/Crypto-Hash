
RC4Init proto :DWORD,:DWORD
RC4Encrypt proto :DWORD,:DWORD

.data?
align 4
rc4_key db 256 dup(?)
rc4_x dd ?
rc4_y dd ?

.code

align 4
RC4Init proc uses esi edi ebx pKey:DWORD,dwKeyLen:DWORD
	xor eax,eax
	mov ecx,256-16
	mov rc4_x,eax
	mov rc4_y,eax
	mov esi,offset rc4_key
	mov edx,0FFFEFDFCh
	mov eax,0FBFAF9F8h
	mov ebx,0F7F6F5F4h
	mov edi,0F3F2F1F0h
	.repeat
		mov [esi+ecx+3*4],edx
		mov [esi+ecx+2*4],eax
		mov [esi+ecx+1*4],ebx
		mov [esi+ecx+0*4],edi
		sub edx,010101010h
		sub eax,010101010h
		sub ebx,010101010h
		sub edi,010101010h
		sub ecx,16
	.until sign?;esi < offset rc4_key
	xor edx,edx
	xor ecx,ecx
	mov esi,pKey
	xor ebx,ebx
	mov edi,dwKeyLen
	.repeat
	@@:
		mov al,rc4_key[ecx]
		add dl,[esi+ebx]
		add dl,al
		mov ah,rc4_key[edx]
		inc ebx
		mov rc4_key[edx],al
		mov rc4_key[ecx],ah
		cmp ebx,edi
		jae @F
		inc cl
		jnz @B
		.break
	@@:		
		xor ebx,ebx
		inc cl
	.until zero?
	ret
RC4Init endp

align 4
RC4Encrypt proc uses esi edi ebx pBlock:DWORD,dwBlockLen:DWORD
	mov edi,pBlock
	mov edx,rc4_x
	mov ecx,dwBlockLen
	mov ebx,rc4_y
	dec edi
	xor eax,eax
	.repeat
		add bl,rc4_key[edx+1]
		mov al,rc4_key[edx+1]
		mov ch,rc4_key[ebx]
		mov rc4_key[ebx],al
		mov rc4_key[edx+1],ch
		add al,ch
		inc edi
		mov al,rc4_key[eax]
		inc dl
		xor [edi],al
		dec cl
	.until zero?
	mov rc4_x,edx
	mov rc4_y,ebx
	ret
RC4Encrypt endp
RC4Decrypt equ <RC4Encrypt>

