.686p
.mmx
.model flat,stdcall
option casemap:none
option prologue:none
option epilogue:none

extern	rc4keytable:DWORD

.code

rc4_crypt		proc	ptrData:DWORD, lData:DWORD

	pushad
	mov	edi, dword ptr [esp+20h+4+4]		;lData
	mov	esi, dword ptr [esp+20h+4]		;ptrData
	test	edi, edi
	jz	@rc4_enc_exit

	xor	eax, eax
	xor	ebx, ebx
	xor	ecx, ecx
	xor	edx, edx

@@:	inc	bl
	mov	dl, byte ptr [rc4keytable+ebx]
	add	al, dl
	mov	cl, byte ptr [rc4keytable+eax]
	mov	byte ptr [rc4keytable+ebx], cl
	mov	byte ptr [rc4keytable+eax], dl
	add	cl, dl
	mov	cl, byte ptr [rc4keytable+ecx]
	xor	byte ptr [esi], cl
	inc	esi
	dec	edi
	jnz	@B

@rc4_enc_exit:
	popad
	ret	8

rc4_crypt	endp

end