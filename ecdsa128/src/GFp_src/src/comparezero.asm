.686p
.mmx
.model flat,stdcall
option casemap:none
option prologue:none
option epilogue:none

.code

comparezero	proc	ptrA:DWORD

	push	eax
	push	esi

	mov	esi, dword ptr [esp+4+8]
	mov	eax, dword ptr [esi   ]
	or	eax, dword ptr [esi+ 4]
	or	eax, dword ptr [esi+ 8]
	or	eax, dword ptr [esi+12]
	test	eax, eax

	pop	esi
	pop	eax
	ret	4

comparezero	endp


end