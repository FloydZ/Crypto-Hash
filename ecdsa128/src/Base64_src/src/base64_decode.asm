.686p
.mmx
.model flat,stdcall
option casemap:none
option prologue:none
option epilogue:none

extern	_base64:DWORD

.code
Base64_Decode		proc	ptrIn:DWORD, ptrOut:DWORD

	pushad
	cld
	xor	ebx, ebx
	xor	edx, edx
	mov	esi, dword ptr [esp+20h+4]	;ptrIn
	mov	edi, dword ptr [esp+20h+8]	;ptrOut

	cmp	esi, edi
	jz	@b64d_error
@b64d_loop:
	lodsb
	test	al, al
	jz	@b64d_done

	test	dh, dh
	jnz	@b64d_done

	mov	bl, 3Fh

@@:	cmp	byte ptr [_base64+ebx], al
	jz	@F
	dec	ebx
	jns	@B
	jmp	@b64d_error

@@:	mov	ecx, ebx
	shl	ecx, 6
	lodsb
	mov	bl, 3Fh

@@:	cmp	byte ptr [_base64+ebx], al
	jz	@F
	dec	ebx
	jns	@B
	jmp	@b64d_error

@@:	or	ecx, ebx
	shl	ecx, 6
	lodsb
	cmp	al, 3Dh
	jnz	@F

	inc	dh
	jmp	@b64d_skip1

@@:	mov	bl, 3Fh

@@:	cmp	byte ptr [_base64+ebx], al
	jz	@F
	dec	ebx
	jns	@B
	jmp	@b64d_error

@@:	or	ecx, ebx

@b64d_skip1:
	shl	ecx, 6
	lodsb
	cmp	al, 3Dh ; '='
	jnz	@F

	inc	dh
	jmp	@b64d_skip2

@@:	test	dh, dh
	jnz	@b64d_error
	
	mov	bl, 3Fh

@@:	cmp	byte ptr [_base64+ebx], al
	jz	@F
	dec	ebx
	jns	@B
	jmp	@b64d_error

@@:	or	ecx, ebx

@b64d_skip2:
	mov	eax, ecx
	rol	eax, 10h
	stosb
	cmp	dh, 2
	jz	@b64d_loop

	rol	eax, 8
	stosb
	cmp	dh, 1
	jz	@b64d_loop

	rol	eax, 8
	stosb
	jmp	@b64d_loop

@b64d_done:
	sub	edi, dword ptr [esp+20h+8]

@@:	mov	dword ptr [esp+28], edi

	popad
	ret	8

@b64d_error:
	xor	edi, edi
	jmp	@B

Base64_Decode	endp

end