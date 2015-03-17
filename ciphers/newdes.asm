comment ~

Algo	: NewDES by Robert Scott
Block	:  8 bytes
Key	: 15 bytes (120b)


encryption:
	push	offset password
	call	NewDES_SetEncryptKey

	push	offset plaintext
	push	offset ciphertext
	call	NewDES_Crypt

	call	NewDES_Clear

decryption:
	push	offset password
	call	NewDES_SetDecryptKey

	push	offset ciphertext
	push	offset plaintext
	call	NewDES_Crypt

	call	NewDES_Clear


24.03.2002 WiteG//xtreeme (witeg@poczta.fm, www.witeg.prv.pl)

~

.code
NewDES_Crypt		proc	ptrOut:DWORD, ptrIn:DWORD
	pushad

	xor	ebx, ebx
	xor	ecx, ecx

	mov	esi, ptrIn
	mov	edi, ptrOut
	mov	eax, dword ptr [esi]
	mov	edx, dword ptr [esi+4]
	mov	dword ptr [edi], eax
	mov	dword ptr [edi+4], edx

	mov	esi, offset NewDES_internal_key
	mov	ebp, 8
@@:
	mov	eax, dword ptr [edi]
	mov	edx, dword ptr [edi+4]
	xor	eax, dword ptr [esi]

	mov	cl, al					;cl = B0^K
	mov	bl, ah					;bl = B1^K
	xor	dl, byte ptr [NewDES_rotor+ecx]
	xor	dh, byte ptr [NewDES_rotor+ebx]
	ror	eax, 16
	ror	edx, 16
	mov	cl, al					;cl = B2^K
	mov	bl, ah					;bl = B3^K
	xor	dl, byte ptr [NewDES_rotor+ecx]
	xor	dh, byte ptr [NewDES_rotor+ebx]
	mov	eax, dword ptr [edi]
	ror	edx, 16
	ror	eax, 8
	mov	dword ptr [edi+4], edx

	add	esi, 4

	xor	dh, dl					;dh = B5^B4
	xor	dl, byte ptr [esi]			;dl = B4^K
	mov	cl, dh
	mov	bl, dl
	xor	ah, byte ptr [NewDES_rotor+ecx]
	xor	al, byte ptr [NewDES_rotor+ebx]
	ror	edx, 16
	ror	eax, 16
	xor	dx, word ptr [esi+1]
	mov	cl, dh
	mov	bl, dl
	xor	ah, byte ptr [NewDES_rotor+ecx]
	xor	al, byte ptr [NewDES_rotor+ebx]
	add	esi, 3
	ror	eax, 8
	dec	ebp
	mov	dword ptr [edi], eax
	jnz	@B

	mov	eax, dword ptr [edi]
	mov	edx, dword ptr [edi+4]
	xor	eax, dword ptr [esi]

	mov	cl, al					;cl = B0^K
	mov	bl, ah					;bl = B1^K
	xor	dl, byte ptr [NewDES_rotor+ecx]
	xor	dh, byte ptr [NewDES_rotor+ebx]
	ror	eax, 16
	ror	edx, 16
	mov	cl, al					;cl = B2^K
	mov	bl, ah					;bl = B3^K
	xor	dl, byte ptr [NewDES_rotor+ecx]
	xor	dh, byte ptr [NewDES_rotor+ebx]
	ror	edx, 16

	mov	dword ptr [edi+4], edx

	popad
	ret

NewDES_rotor	db	 32,137,239,188,102,125,221, 72,212, 68, 81, 37, 86,237,147,149
		db	 70,229, 17,124,115,207, 33, 20,122,143, 25,215, 51,183,138,142
		db	146,211,110,173,  1,228,189, 14,103, 78,162, 36,253,167,116,255
		db	158, 45,185, 50, 98,168,250,235, 54,141,195,247,240, 63,148,  2
		db	224,169,214,180, 62, 22,117,108, 19,172,161,159,160, 47, 43,171
		db	194,175,178, 56,196,112, 23,220, 89, 21,164,130,157,  8, 85,251
		db	216, 44, 94,179,226, 38, 90,119, 40,202, 34,206, 35, 69,231,246
		db	 29,109, 74, 71,176,  6, 60,145, 65, 13, 77,151, 12,127, 95,199
 		db	 57,101,  5,232,150,210,129, 24,181, 10,121,187, 48,193,139,252
		db	219, 64, 88,233, 96,128, 80, 53,191,144,218, 11,106,132,155,104
		db	 91,136, 31, 42,243, 66,126,135, 30, 26, 87,186,182,154,242,123
		db	 82,166,208, 39,152,190,113,205,114,105,225, 84, 73,163, 99,111
		db	204, 61,200,217,170, 15,198, 28,192,254,134,234,222,  7,236,248
		db	201, 41,177,156, 92,131, 67,249,245,184,203,  9,241,  0, 27, 46
		db	133,174, 75, 18, 93,209,100,120, 76,213, 16, 83,  4,107,140, 52
		db	 58, 55,  3,244, 97,197,238,227,118, 49, 79,230,223,165,153, 59

NewDES_Crypt		endp

NewDES_SetEncryptKey	proc	ptrPass:DWORD
	push	edi
	push	esi
	push	ecx

	mov	esi, ptrPass
	mov	edi, offset NewDES_internal_key
	mov	ecx, 15
	push	edi
	cld
	rep	movsb
	pop	esi
	mov	ecx, 3*15
	rep	movsb

	pop	ecx
	pop	esi
	pop	edi
	ret
NewDES_SetEncryptKey	endp

NewDES_SetDecryptKey	proc	ptrPass:DWORD

	pushad
	mov	eax, 11
	mov	esi, ptrPass
	mov	edi, offset NewDES_internal_key
	xor	edx, edx

@@key_de_loop:
	mov	bl, byte ptr [esi+eax]
	inc	eax
	mov	byte ptr [edi], bl
	cmp	al, 0Fh
	jnz	@F
	xor	eax, eax
@@:
	inc	edi
	mov	bl, byte ptr [esi+eax]
	inc	eax
	mov	byte ptr [edi], bl
	cmp	al, 0Fh
	jnz	@F
	xor	eax, eax
@@:
	inc	edi
	mov	bl, byte ptr [esi+eax]
	inc	eax
	mov	byte ptr [edi], bl
	cmp	al, 0Fh
	jnz	@F
	xor	eax, eax
@@:
	inc	edi
	mov	bl, byte ptr [esi+eax]
	mov	byte ptr [edi], bl
	inc	edi

	add	eax, 9
	div	byte ptr [_15]
	movzx	eax, ah
	cmp	al, 12
	jz	@@done

	mov	bl, byte ptr [esi+eax]
	inc	eax
	mov	byte ptr [edi], bl
	inc	edi

	mov	bl, byte ptr [esi+eax]
	inc	eax
	mov	byte ptr [edi], bl
	inc	edi

	mov	bl, byte ptr [esi+eax]
	mov	byte ptr [edi], bl
	inc	edi

	add	eax, 9
	div	byte ptr [_15]
	movzx	eax, ah
	jmp	@@key_de_loop

@@done:
	popad
	ret

	_15	db	15
NewDES_SetDecryptKey	endp

NewDES_Clear		proc

	push	eax
	push	ecx
	push	edi

	xor	eax, eax
	mov	ecx, (4*15)/4
	mov	edi, offset NewDES_internal_key
	cld
	rep	stosd

	pop	edi
	pop	ecx
	pop	eax
	ret

NewDES_Clear		endp

.data?
NewDES_internal_key	db 4*15 dup (?)