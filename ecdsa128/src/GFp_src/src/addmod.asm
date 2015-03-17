.686p
.mmx
.model flat,stdcall
option casemap:none
option prologue:none
option epilogue:none

extern	__mod:DWORD

.code

addmod		proc	ptrA:DWORD, ptrB:DWORD, ptrC:DWORD

	;a+b=c mod __mod

	pushad

	mov	esi, dword ptr [esp+20h+4]
	mov	edi, dword ptr [esp+20h+8]

	xor	ebp, ebp
	mov	eax, dword ptr [esi   ]
	mov	ebx, dword ptr [esi+ 4]
	mov	ecx, dword ptr [esi+ 8]
	mov	edx, dword ptr [esi+12]
	add	eax, dword ptr [edi   ]
	adc	ebx, dword ptr [edi+ 4]
	adc	ecx, dword ptr [edi+ 8]
	adc	edx, dword ptr [edi+12]

	mov	esi, dword ptr [esp+20h+12]
	adc	ebp, ebp

@@:	mov	dword ptr [esi   ], eax
	mov	dword ptr [esi+ 4], ebx
	mov	dword ptr [esi+ 8], ecx
	mov	dword ptr [esi+12], edx

        sub     eax, dword ptr [__mod   ]
        sbb     ebx, dword ptr [__mod+ 4]
        sbb     ecx, dword ptr [__mod+ 8]
        sbb     edx, dword ptr [__mod+12]
	sbb	ebp, 0
        jnc     @B

	popad
        ret	12

addmod		endp


end