.686p
.mmx
.model flat,stdcall
option casemap:none
option prologue:none
option epilogue:none

.code
ECP_Zero_J	proc	ptrA:DWORD

	pushad

	xor	eax, eax
	mov	ecx, (16+16+16)/4
	mov	edi, dword ptr [esp+20h+4]
	cld
	rep	stosd

	popad
	ret	4

ECP_Zero_J	endp

end