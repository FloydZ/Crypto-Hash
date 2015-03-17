.686p
.mmx
.model flat,stdcall
option casemap:none
option prologue:none
option epilogue:none

extern	rc4keytable:DWORD

.code

rc4_setkey		proc	ptrPass:DWORD, lPass:DWORD
	pushad

	mov	ebp, dword ptr [esp+20h+4+4]
	test	ebp, ebp
	jz	@done

	mov	eax, 0FFFEFDFCh
	mov	ecx, 256/4
@@:	mov	dword ptr [rc4keytable+4*ecx-4], eax
	sub	eax, 04040404h
	dec	ecx
	jnz	@B

	xor	eax, eax
	mov	edi, dword ptr [esp+20h+4]		;ptrPass

@setKey:
	xor	ebx, ebx
	mov	esi, ebp
	jmp	@new_key

@@:
	inc	bl
	dec	esi
	jz	@setKey

@new_key:
	mov	dl, byte ptr [rc4keytable+ecx]
	add	al, byte ptr [edi+ebx]
	add	al, dl
	mov	dh, byte ptr [rc4keytable+eax]
	mov	byte ptr [rc4keytable+ecx], dh
	mov	byte ptr [rc4keytable+eax], dl
	inc	cl
	jnz	@B
@done:
	popad
	ret	8
rc4_setkey	endp

end