.686p
.mmx
.model flat,stdcall
option casemap:none
option prologue:none
option epilogue:none

include	..\..\lib\gfp.inc
include	..\..\lib\ecp.inc

.code
ECP_Copy	proc	ptrA:DWORD, ptrB:DWORD

	pushad

	mov	esi, dword ptr [esp+20h+4]
	mov	edi, dword ptr [esp+20h+4+4]

	assume	esi: ptr ECPOINT
	assume	edi: ptr ECPOINT

	mov	eax, [esi].INFINITY
	mov	[edi].INFINITY, eax

	lea	ebx, [esi].X
	lea	ebp, [edi].X
	invoke	copy, ebx, ebp

	lea	ebx, [esi].Y
	lea	ebp, [edi].Y
	invoke	copy, ebx, ebp

	popad
	ret	8

ECP_Copy	endp

end