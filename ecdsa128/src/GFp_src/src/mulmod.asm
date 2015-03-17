.686p
.mmx
.model flat,stdcall
option casemap:none
option prologue:none
option epilogue:none

include	..\..\lib\gfp.inc

.data
mulmodSpace	VBIGINT<>

.code
mulmod		proc	ptrA:DWORD, ptrB:DWORD, ptrC:DWORD

	;c=a*b mod __mod

	pushad
	mov	esi, dword ptr [esp+20h+4]	;a
	mov	ebx, dword ptr [esp+20h+8]	;b
	mov	ebp, dword ptr [esp+20h+12]	;c

	mov	edi, offset mulmodSpace

	invoke	multiply, esi, ebx, edi
	invoke	modulo, edi, ebp

	xor	eax, eax
	mov	ecx, 8
	cld
	rep	stosd

	popad
	ret	12

mulmod		endp

end