.686p
.mmx
.model flat,stdcall
option casemap:none
option prologue:none
option epilogue:none

.code

compareone	proc	ptrA:DWORD

	push	eax
	push	esi

	mov	esi, dword ptr [esp+4+8]

	mov	eax, dword ptr [esi+12]
	or	eax, dword ptr [esi+ 8]
	or	eax, dword ptr [esi+ 4]
	test	eax, eax
	jnz	@F

	cmp	dword ptr [esi], 1

@@:	pop	esi
	pop	eax
	ret	4

compareone	endp


end