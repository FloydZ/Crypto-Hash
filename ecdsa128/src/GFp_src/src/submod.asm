.686p
.mmx
.model flat,stdcall
option casemap:none
option prologue:none
option epilogue:none

extern	__mod:DWORD

.code

submod		proc	ptrA:DWORD, ptrB:DWORD, ptrC:DWORD

	;a-b=c mod __mod

	pushad

	mov	esi, dword ptr [esp+20h+4]
	mov	edi, dword ptr [esp+20h+8]
	mov	ebp, dword ptr [esp+20h+12]

	mov	eax, dword ptr [esi   ]
	mov	ebx, dword ptr [esi+ 4]
	mov	ecx, dword ptr [esi+ 8]
	mov	edx, dword ptr [esi+12]
	sub	eax, dword ptr [edi   ]
	sbb	ebx, dword ptr [edi+ 4]
	sbb	ecx, dword ptr [edi+ 8]
	sbb	edx, dword ptr [edi+12]
	jnc	@F

	add	eax, dword ptr [__mod   ]
	adc	ebx, dword ptr [__mod+ 4]
	adc	ecx, dword ptr [__mod+ 8]
	adc	edx, dword ptr [__mod+12]

@@:	mov	dword ptr [ebp   ], eax
	mov	dword ptr [ebp+ 4], ebx
	mov	dword ptr [ebp+ 8], ecx
	mov	dword ptr [ebp+12], edx

	popad
	ret	12

submod		endp

end