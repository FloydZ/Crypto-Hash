.686p
.mmx
.model flat,stdcall
option casemap:none
option prologue:none
option epilogue:none

.code

zero		proc	ptrA:DWORD

	push	eax
	push	esi

	xor	eax, eax
	mov	esi, dword ptr [esp+4+8]
	and	dword ptr [esi   ], eax
	and	dword ptr [esi+ 4], eax
	and	dword ptr [esi+ 8], eax
	and	dword ptr [esi+12], eax

	pop	esi
	pop	eax
	ret	4

zero		endp


end