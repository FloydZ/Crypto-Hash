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

extern	_P	:DWORD

.code

ECP_Add		proc	ptrA:DWORD, ptrB:DWORD

	pushad

	mov	esi, dword ptr [esp+20h+4]
	mov	edi, dword ptr [esp+20h+4+4]

	assume	esi: ptr ECPOINT
	assume	edi: ptr ECPOINT

	mov	eax, [esi].INFINITY
	test	eax, eax
	jz	@returnB

	mov	eax, [edi].INFINITY
	test	eax, eax
	jz	@returnA

; zaden z punktow nie jest w nieskonczonosci

	lea	ebx, [esi].X
	lea	ebp, [edi].X
	lea	eax, [esi].Y
	lea	edx, [edi].Y

	invoke	compare, ebx, ebp
	jnz	@AisntminusB

	invoke	compare, eax, edx
	jz	@doubleA

; sprawdzmy czy A = -B

	;jesli x1 == x2 musimy sprawdzic czy y2 = -y1 (modulo prime), wiemy ze y2 != y1
	;wiec mozemy pominac sytuacje kiedy y2=y1=0

	invoke	submod, offset _P, eax, offset tempInt1	;-y1 mod p
	invoke	compare, edx, offset tempInt1			;cmp y2, -y1 mod p
	jz	@return0

@AisntminusB:

; dodajemy punkty :)

	invoke	submod, edx, eax, offset tempInt1		;Int1 = y2 - y1
	invoke	submod, ebp, ebx, offset tempInt2		;Int2 = x2 - x1
	invoke	invmod, offset tempInt2				;Int2 = (x2 - x1)^(-1)
	invoke	mulmod, offset tempInt1, offset tempInt2, offset tempInt3
								;Int3 = (y2 - y1)/(x2 - x1)
	invoke	mulmod, offset tempInt3, offset tempInt3, offset tempInt1
								;Int1 = [(y2 - y1)/(x2 - x1)]^2
	invoke	submod, offset tempInt1, ebx, offset tempInt1	;Int1 = [(y2 - y1)/(x2 - x1)]^2 - x1
	invoke	submod, offset tempInt1, ebp, offset tempInt1	;Int1 = [(y2 - y1)/(x2 - x1)]^2 - x1 - x2
								;x3 = Int1

	invoke	submod, ebx, offset tempInt1, offset tempInt2	;Int2 = x1 - x3
	invoke	mulmod, offset tempInt3, offset tempInt2, offset tempInt3
								;Int3 = [(y2 - y1)/(x2 - x1)]*(x3 - x1)
	invoke	submod, offset tempInt3, eax, offset tempInt2	;Int2 = [(y2 - y1)/(x2 - x1)]*(x3 - x1) - y1
								;y3 = Int2
	invoke	copy, offset tempInt1, ebp
	invoke	copy, offset tempInt2, edx

@returnB:
	invoke	zero, offset tempInt1
	invoke	zero, offset tempInt2
	invoke	zero, offset tempInt3

	popad
	ret	8

@doubleA:
	invoke	ECP_Dbl, esi, edi
	jmp	@returnB

@return0:
	and	[edi].INFINITY , 0
	jmp	@returnB

@returnA:
	invoke	ECP_Copy, esi, edi
	jmp	@returnB

ECP_Add		endp

end