.686p
.mmx
.model flat,stdcall
option casemap:none
option prologue:none
option epilogue:none

.code

div2	proc	ptrA:DWORD

	pushad

	mov	esi, dword ptr [esp+20h+4]

	mov	eax, dword ptr [esi   ]
	mov	ebx, dword ptr [esi+ 4]
	mov	ecx, dword ptr [esi+ 8]
	mov	edx, dword ptr [esi+12]
	shr	edx, 1
	rcr	ecx, 1
	rcr	ebx, 1
	rcr	eax, 1
	mov	dword ptr [esi   ], eax
	mov	dword ptr [esi+ 4], ebx
	mov	dword ptr [esi+ 8], ecx
	mov	dword ptr [esi+12], edx

	popad
	ret	4

div2	endp

end