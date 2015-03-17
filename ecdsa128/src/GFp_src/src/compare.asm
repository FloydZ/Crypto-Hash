.686p
.mmx
.model flat,stdcall
option casemap:none
option prologue:none
option epilogue:none

.code

compare		proc	ptrA:DWORD, ptrB:DWORD

	;a==b

	pushad

	mov	esi, dword ptr [esp+20h+4]
	mov	edi, dword ptr [esp+20h+8]
	mov	ecx, 4

@@:	mov	eax, dword ptr [esi+4*ecx-4]
	cmp	eax, dword ptr [edi+4*ecx-4]
	jnz	@F
	dec	ecx
	jnz	@B

@@:
	popad
	ret	8

compare		endp

end