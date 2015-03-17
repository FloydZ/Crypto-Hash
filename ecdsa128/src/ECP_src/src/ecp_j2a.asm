.686p
.mmx
.model flat,stdcall
option casemap:none
option prologue:none
option epilogue:none

include	..\..\lib\gfp.inc
include	..\..\lib\ecp.inc

extern	tempInt1:DWORD
extern	tempInt2:DWORD

.code
ECP_J2A		proc	ptrA:DWORD, ptrB:DWORD

	pushad

	mov	esi, dword ptr [esp+20h+4]	;ptrA
	mov	edi, dword ptr [esp+20h+8]	;ptrB

	assume	esi: ptr ECPOINTJ
	assume	edi: ptr ECPOINT

	lea	ebp, [esi].Y
	lea	ecx, [esi].Z

	lea	eax, [edi].X
	lea	edx, [edi].Y

	invoke	comparezero, ecx
	jz	@return0

	invoke	copy, ecx, offset tempInt1	;Z
	invoke	invmod, offset tempInt1		;T1 = 1/Z
	invoke	mulmod, offset tempInt1, offset tempInt1, offset tempInt2
						;T2 = (1/Z)^2
	invoke	mulmod, offset tempInt1, offset tempInt2, offset tempInt1
						;T1 = (1/Z)^3

	invoke	mulmod, ebp, offset tempInt1, edx
						;y = Y/(Z^3)
	invoke	mulmod, esi, offset tempInt2, eax
						;x = X/(Z^3)

	invoke	zero, offset tempInt1
	invoke	zero, offset tempInt2

	mov	[edi].INFINITY, 1

@ret:	popad
	ret	8

@return0:
	mov	[edi].INFINITY, 0
	jmp	@ret

ECP_J2A		endp

end