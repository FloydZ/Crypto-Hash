.686p
.mmx
.model flat,stdcall
option casemap:none
option prologue:none
option epilogue:none

include	..\..\lib\gfp.inc
include	..\..\lib\ecp.inc

.code
ECP_A2J		proc	ptrA:DWORD, ptrB:DWORD

	pushad

	mov	esi, dword ptr [esp+20h+4]	;ptrA
	mov	edi, dword ptr [esp+20h+8]	;ptrB

	assume	esi: ptr ECPOINT
	assume	edi: ptr ECPOINTJ

	lea	eax, [esi].X
	lea	edx, [esi].Y

	lea	ebp, [edi].Y
	lea	ecx, [edi].Z

	cmp	[esi].INFINITY, 0
	jz	@return0

	invoke	copy, eax, edi			;X2 = X1
	invoke	copy, edx, ebp			;Y2 = Y1

	invoke	zero, ecx
	inc	dword ptr [ecx]			;Z2 = 1

@ret:	popad
	ret	8

@return0:
	invoke	zero, ecx
	jmp	@ret

ECP_A2J		endp

end