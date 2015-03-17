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
extern	tempInt3:DWORD

extern	_A	:DWORD

.code

ECP_Dbl		proc	ptrA:DWORD, ptrB:DWORD
	pushad

	mov	esi, dword ptr [esp+20h+4]

	assume	esi: ptr ECPOINT
	assume	edi: ptr ECPOINT

	mov	eax, [esi].INFINITY
	test	eax, eax
	jz	@return0

	lea	ebx, [esi].X
	lea	ebp, [esi].Y

	invoke	comparezero, ebp
	jz	@return0

	invoke	mulmod, ebx, ebx, offset tempInt1		;Int1 = x1^2
	invoke	addmod, offset tempInt1, offset tempInt1, offset tempInt2
								;Int2 = 2*x1^2
	invoke	addmod, offset tempInt1, offset tempInt2, offset tempInt1
								;Int1 = 3*x1^2
	invoke	addmod, offset tempInt1, offset _A, offset tempInt1
								;Int1 = 3*x1^2 + a

	invoke	addmod, ebp, ebp, offset tempInt2		;Int2 = 2*y1
	invoke	invmod, offset tempInt2				;Int2 = (2*y1)^(-1)
	invoke	mulmod, offset tempInt1, offset tempInt2, offset tempInt1
								;Int1 = (3*x1^2 + a)/(2*y1)

	invoke	mulmod, offset tempInt1, offset tempInt1, offset tempInt2
								;Int2 = [(3*x1^2 + a)/(2*y1)]^2
	invoke	submod, offset tempInt2, ebx, offset tempInt2	;Int2 = [(3*x1^2 + a)/(2*y1)]^2 - x1
	invoke	submod, offset tempInt2, ebx, offset tempInt2	;Int2 = [(3*x1^2 + a)/(2*y1)]^2 - 2*x1
								;Int2 = x3

;-----
	invoke	submod, ebx, offset tempInt2, offset tempInt3	;Int3 = x1 - x3
	invoke	mulmod, offset tempInt1, offset tempInt3, offset tempInt3
								;Int3 = [(3*x1^2 + a)/(2*y1)](x1 - x3)
	invoke	submod, offset tempInt3, ebp, offset tempInt1	;Int1 = [(3*x1^2 + a)/(2*y1)](x1 - x3) - y1
								;Int1 = y3
;-----

	mov	edi, dword ptr [esp+20h+4+4]

	mov	[edi].INFINITY , 1
	lea	ebx, [edi].X
	lea	ebp, [edi].Y

	invoke	copy, offset tempInt2, ebx
	invoke	copy, offset tempInt1, ebp

	invoke	zero, offset tempInt1
	invoke	zero, offset tempInt2
	invoke	zero, offset tempInt3

@returnB:
	popad
	ret	8

@return0:
	mov	edi, dword ptr [esp+20h+4+4]
	and	[edi].INFINITY , 0
	jmp	@returnB

ECP_Dbl		endp

end