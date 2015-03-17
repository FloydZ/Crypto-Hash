.686p
.mmx
.model flat,stdcall
option casemap:none
option prologue:none
option epilogue:none

.code

copy		proc	ptrA:DWORD, ptrB:DWORD

	;b=a

	pushad
	mov	esi, dword ptr [esp+20h+4]
	mov	edi, dword ptr [esp+20h+8]

	mov	eax, dword ptr [esi   ]
	mov	ebx, dword ptr [esi+ 4]
	mov	ecx, dword ptr [esi+ 8]
	mov	edx, dword ptr [esi+12]

	mov	dword ptr [edi   ], eax
	mov	dword ptr [edi+ 4], ebx
	mov	dword ptr [edi+ 8], ecx
	mov	dword ptr [edi+12], edx

	popad
	ret	8
copy		endp

end