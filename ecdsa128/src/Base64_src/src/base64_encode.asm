.686p
.mmx
.model flat,stdcall
option casemap:none
option prologue:none
option epilogue:none

extern	_base64:DWORD

.code
Base64_Encode		proc	ptrIn:DWORD, lenIn:DWORD, ptrOut:DWORD

	pushad

	mov	ebx, dword ptr [esp+20h+ 4]	;ptrIn
	mov	ebp, dword ptr [esp+20h+ 8]	;lenIn
	mov	edi, dword ptr [esp+20h+12]	;ptrOut

	cmp	ebx, edi
	jz	@b64e_exit

	xor	esi, esi
@b64e_loop:
	cmp	esi, ebp
	jge	@b64e_exit

	mov	cl, byte ptr [esi+ebx]
	inc	esi
	shl	ecx, 8
	cmp	esi, ebp
	jge	@F

	mov	cl, byte ptr [esi+ebx]

@@:	inc	esi
	shl	ecx, 8
	cmp	esi, ebp
	jge	@F

	mov	cl, byte ptr [esi+ebx]

@@:	inc	esi
	mov	eax, ecx
	and	eax, 0FC0000h
	shr	eax, 12h
	mov	al, byte ptr [_base64+eax]
	mov	byte ptr [edi], al

	mov	eax, ecx
	and	eax, 3F000h
	shr	eax, 0Ch
	mov	al, byte ptr [_base64+eax]
	mov	byte ptr [edi+1], al

	mov	eax, ecx
	and	eax, 0FC0h
	shr	eax, 6
	mov	al, byte ptr [_base64+eax]
	mov	byte ptr [edi+2], al

	mov	eax, ecx
	and	eax, 3Fh
	mov	al, byte ptr [_base64+eax]
	mov	byte ptr [edi+3], al
	lea	edx, [ebp+1]
	cmp	esi, ebp
	jle	@F

	mov	byte ptr [edi+3], 3Dh ; '='

@@:	cmp	esi, edx
	jle	@F

	mov	byte ptr [edi+2], 3Dh ; '='

@@:	add	edi, 4
	jmp	@b64e_loop

@b64e_exit:
	and	byte ptr [edi], 0
	sub	edi, dword ptr [esp+20h+12]	;ptrOut
	mov	dword ptr [esp+28], edi
	popad
	ret	12

Base64_Encode	endp

end